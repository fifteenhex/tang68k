module internalram
(
    input clk,
    input enable,
    input write,
    input [31:0] addr,
    input [15:0] data_in,
    output [15:0] data_out
);

wire [7:0] lowbyte_datain;
wire [7:0] highbyte_datain;
wire [7:0] lowbyte_dataout;
wire [7:0] highbyte_dataout;

bramwrapper_singleport lowbyte(
    .clk(clk),
    .enable(enable),
    .addr(addr),
    .data_in(lowbyte_datain),
    .data_out(lowbyte_dataout),
    .write(write)
);

bramwrapper_singleport highbyte(
    .clk(clk),
    .enable(enable),
    .addr(addr),
    .data_in(highbyte_datain),
    .data_out(highbyte_dataout),
    .write(write)
);

assign data_out = {highbyte_dataout, lowbyte_dataout};
assign highbyte_datain = data_in[15:8];
assign lowbyte_datain = data_in[7:0];

endmodule
