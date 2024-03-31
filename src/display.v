module display
(
    input clk,
    input logic [9:0] x,
    input logic [9:0] y,

    input [31:0] m68k_addr,
    input [15:0] m68k_datain,
    input m68k_write,

    output logic [2:0] pixel_data
);

wire pixel;

assign pixel_data = pixel ? 3'b111 : 3'b000;

wire [7:0] m68k_addr_chars [0:7];
wire [7:0] m68k_datain_chars [0:3];

reg [7:0] m68k_direction_char;
assign m68k_direction_char = m68k_write ? "w" : "r";

hexbox #(
    .COLS(8)
) hexbox_addr (
    .value(m68k_addr),
    .chars(m68k_addr_chars)
);

hexbox #(
    .COLS(4)
) hexbox_datain (
    .value(m68k_datain),
    .chars(m68k_datain_chars)
);

textbox #(
    .SCREEN_WIDTH(800),
    .SCREEN_HEIGHT(600),
    .COLS(16)
) textbox_inst (
    .clk(clk),
    .x(x),
    .y(y),
    .chars({" ", ":", m68k_addr_chars, " ", m68k_direction_char, m68k_datain_chars}),
    .pixel(pixel)
);

endmodule
