module top
(
    input logic ext_clk,
    input logic s1,
    input logic s2,
    output led1,
    output led2,
    output [15:0] addr,
    output uds,
    output lds,
    output cpu_clk,
    // HDMI encoder signals
    output [2:0] hdmi_rgb,
    output hdmi_clk,
    output hdmi_de,
    output hdmi_vs,
    output hdmi_hs
);

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

    assign led2 = addr[8];

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

    reg [21:0] cpu_clk_div;
    always @(posedge clk_25mhz) begin
        cpu_clk_div <= cpu_clk_div + 1;
    end
    assign cpu_clk = cpu_clk_div[$left(cpu_clk_div)];
    
    assign led1 = rst;

    wire [31:0] cpu_addr;
    wire [15:0] cpu_datain;
    wire [15:0] cpu_dataout;
    wire cpu_write;
    wire cpu_berr;
    
    wire [7:0] chipselects;

    chipselect chipselect_inst(
        .addr(cpu_addr),
        .chipselects(chipselects)
    );

    bootrom bootrom_inst(
        .clk(clk_25mhz),
        .enable(chipselects[0]),
        .addr(cpu_addr),
        .data(cpu_datain),
        .berr(cpu_berr)
    );

    internalram internalram(
        .clk(clk_25mhz),
        .enable(chipselects[1]),
        .addr(cpu_addr),
        .data_in(cpu_dataout)
    );

    wire [2:0] fc;
    wire reset_out;
    wire read;

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

    display display_inst(
        .clk(ext_clk),
        .x(hdmi_x),
        .y(hdmi_y),

        .m68k_addr(cpu_addr),
        .m68k_datain(cpu_datain),
        .m68k_write(cpu_write),

        .pixel_data(pixel_data)
    );

endmodule
