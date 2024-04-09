module sdram
(
    //
    input ext_clk,

    // Memory interface
    input logic enable,
    input logic write,
    input logic [25:0] addr,
    input logic [15:0] data_in,
    output logic [15:0] data_out,

    // SDRAM interface
    inout logic [15:0] sdram_data,
    output logic [12:0] sdram_addr,
    output logic [1:0] sdram_ba,
    output logic sdram_cs0ncs1,
    output logic sdram_cas,
    output logic sdram_ras,
    output logic sdram_udm,
    output logic sdram_ldm,
    output logic sdram_nwe,
    output logic sdram_clk
);

assign sdram_data = '0;
assign sdram_addr = '0;
assign sdram_ba = '0;
assign sdram_cs0ncs1 = '0;
assign sdram_cas = '1;
assign sdram_ras = '1;
assign sdram_udm = '1;
assign sdram_ldm = '1;
assign sdram_nwe = '1;
assign sdram_clk = '1;

assign data_out = '0;

sdram_chip_intf chip0(
);

sdram_chip_intf chip1(
);

endmodule
