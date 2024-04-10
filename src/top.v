module top
(
    input logic ext_clk,
    input logic s1,
    input logic s2,
    output led1,
    output led2,

    // HDMI encoder signals
    output [2:0] hdmi_rgb,
    output hdmi_clk,
    output hdmi_de,
    output hdmi_vs,
    output hdmi_hs,
    
    // SDRAM
    inout [15:0] sdram_data,
    output [12:0] sdram_addr,
    output [1:0] sdram_ba,
    output sdram_cs0ncs1,
    output sdram_cas,
    output sdram_ras,
    output sdram_udm,
    output sdram_ldm,
    output sdram_nwe,
    output sdram_clk
);
    localparam cs_bootrom = 0;
    localparam cs_configrom = 1;
    localparam cs_internalram = 2;
    localparam cs_framebuffer = 3;
    
    wire [9:0] hdmi_x;
    wire [9:0] hdmi_y;
    reg [2:0] pixel_data;

    hdmiintf hdmiintf_inst(
        .clk_in(ext_clk),
        .rgb(hdmi_rgb),
        .clk_out(hdmi_clk),
        .de(hdmi_de),
        .vs(hdmi_vs),
        .hs(hdmi_hs),
        // pixel data connections
        .x(hdmi_x),
        .y(hdmi_y),
        .pixel_data(pixel_data)
    );

    wire clk_25mhz;

    Gowin_PLL your_instance_name(
        .clkin(ext_clk), //input clkin
        .clkout0(clk_25mhz) //output clkout0
    );

    //CLKDIV2 clk_div2 (
    //    .HCLKIN(ext_clk),
    //    .RESETN('1),
    //    .CLKOUT(clk_25mhz)
    //);

    wire rst;
    resetgenerator rstgen(
        clk_25mhz,
        s1,
        rst
    );

    reg [9:0] cpu_clk_div;
    always @(posedge clk_25mhz) begin
        cpu_clk_div <= cpu_clk_div + 1;
    end
    wire cpu_clk;
    assign cpu_clk = cpu_clk_div[$left(cpu_clk_div)];
    //assign cpu_clk = clk_25mhz;

    assign led1 = rst;

    wire [31:0] cpu_addr;
    reg [15:0] cpu_datain;
    wire [15:0] cpu_dataout;
    wire cpu_write;
    wire cpu_berr;
    
    wire [7:0] chipselects;

    chipselect chipselect_inst(
        .addr(cpu_addr),
        .chipselects(chipselects)
    );

    wire [15:0] bootrom_dataout;
    
    bootrom bootrom_inst(
        .clk(clk_25mhz),
        .enable(chipselects[cs_bootrom]),
        .addr(cpu_addr),
        .data_out(bootrom_dataout),
        .berr(cpu_berr)
    );
    
    wire [15:0] configrom_dataout;
    
    configrom 
    #(
        .cs_bootrom(cs_bootrom),
        .cs_configrom(cs_configrom),
        .cs_internalram(cs_internalram),
        .cs_framebuffer(cs_framebuffer)
    ) configrom_inst (
        .clk(clk_25mhz),
        .enable(chipselects[cs_bootrom]),
        .addr(cpu_addr),
        .data_out(configrom_dataout)
    );

    wire [15:0] internalram_dataout;
    
    internalram internalram(
        .clk(clk_25mhz),
        .enable(chipselects[cs_internalram]),
        .addr(cpu_addr),
        .data_in(cpu_dataout),
        .data_out(internalram_dataout),
        .write(cpu_write)
    );

    always @(*) begin
        case (chipselects)
            'b00000001:
                cpu_datain <= bootrom_dataout;
            'b00000010:
                cpu_datain <= configrom_dataout;
            'b00000100:
                cpu_datain <= internalram_dataout;
            default: begin
                cpu_datain <= '0;
            end
        endcase
    end

    wire [2:0] fc;
    wire reset_out;
    wire read;

    wire lds;
    wire uds;
    
    m68k_top m68k (
        .clk(cpu_clk),
        .addr(cpu_addr),
        .data_in(cpu_datain),
        .data_out(cpu_dataout),
        .uds(uds),
        .lds(lds),
        .write(cpu_write),
        .read(read),
        .berr(cpu_berr),
        .reset_in(rst),
        .fc(fc)
    );

    wire framebuffer_out_pixel;
    reg [31:0] framebuffer_in_x;
    reg [31:0] framebuffer_in_y;

    cpuaddr2xy cpuaddr2xy_inst (
        .addr(cpu_addr),
        .x(framebuffer_in_x),
        .y(framebuffer_in_y)
    );
    
    framebuffer
    #(
        .WIDTH_IN(16)
    ) framebuffer_inst (
        /* cpu side */
        .in_clk(cpu_clk),
        .in_enable(chipselects[cs_framebuffer]),
        .in_y(framebuffer_in_y),
        .in_x(framebuffer_in_x),
        .in_data(cpu_dataout),
        /* display side */
        .out_clk(ext_clk),
        .out_x(hdmi_x),
        .out_y(hdmi_y),
        .out_data(framebuffer_out_pixel)
    );

    display display_inst(
        .clk(ext_clk),
        .x(hdmi_x),
        .y(hdmi_y),

        .m68k_addr(cpu_addr),
        .m68k_datain(cpu_datain),
        .m68k_dataout(cpu_dataout),
        .m68k_write(cpu_write),

        .framebuffer_pixel(framebuffer_out_pixel),

        .pixel_data(pixel_data)
    );

    sdram sdram_inst (
        .sdram_data(sdram_data),
        .sdram_addr(sdram_addr),
        .sdram_ba(sdram_ba),
        .sdram_cs0ncs1(sdram_cs0ncs1),
        .sdram_cas(sdram_cas),
        .sdram_ras(sdram_ras),
        .sdram_udm(sdram_udm),
        .sdram_ldm(sdram_ldm),
        .sdram_nwe(sdram_nwe),
        .sdram_clk(sdram_clk)
    );

endmodule
