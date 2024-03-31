module m68k_top (
    /* clk and reset */
    input logic clk,
    input logic clk_en = 1'b1,
    input logic reset_in,
    output logic reset_out,
    /* bus */
    output logic [31:0]  addr,
    output logic [2:0] fc,
    output logic [15:0] data_out,
    input  logic [15:0] data_in,
    output logic uds,
    output logic lds,
    output logic read,
    output logic write,
    input logic berr = 1'b0
);



/*
module tg68kdotc_verilog_wrapper
  (input  clk,
   input  berr,
   input  [2:0] ipl,
   input  dtack,
   input  vpa,
   inout  reset,
   inout  halt,
   output [31:0] addr,
   output [2:0] fc,
   inout  [15:0] data,
   output as,
   output uds,
   output lds,
   output rw,
   output e,
   output vma);
*/
    wire e;
    wire vma;
    wire nWr;

    assign read = nWr;
    assign write = ~nWr;

    tg68kdotc_verilog_wrapper cpu (
        .clk(clk),
        .clkena_in(clk_en),
        .nReset(~reset_in),
        .nResetOut(reset_out),
        .addr_out(addr),
        .FC(fc),
        .data_in(data_in),
        .data_write(data_out),
        .IPL(3'b111),
        .IPL_autovector('0),
        .berr(berr),
        .nWr(nWr),
        .nLDS(lds),
        .nUDS(uds)
    );

endmodule
