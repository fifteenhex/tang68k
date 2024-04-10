module display
(
    input clk,
    input logic [9:0] x,
    input logic [9:0] y,

    /* cpu HUD */
    input [31:0] m68k_addr,
    input [15:0] m68k_datain,
    input [15:0] m68k_dataout,
    input m68k_write,

    /* framebuffer */
    input logic framebuffer_pixel,

    output logic [2:0] pixel_data
);

wire [7:0] m68k_addr_chars [0:7];
wire [7:0] m68k_data_chars [0:3];

reg [7:0] m68k_direction_char;
assign m68k_direction_char = m68k_write ? "w" : "r";

hexbox #(
    .COLS(8)
) hexbox_addr (
    .value(m68k_addr),
    .chars(m68k_addr_chars)
);

reg [15:0] m68k_data;
assign m68k_data = m68k_write ? m68k_dataout : m68k_datain;


hexbox #(
    .COLS(4)
) hexbox_datain (
    .value(m68k_data),
    .chars(m68k_data_chars)
);

wire hud_pixel;
wire hud_active;

textbox #(
    .SCREEN_WIDTH(800),
    .SCREEN_HEIGHT(600),
    .COLS(16)
) textbox_inst (
    .clk(clk),
    .x(x),
    .y(y),
    .chars({" ", ":", m68k_addr_chars, " ", m68k_direction_char, m68k_data_chars}),
    .pixel(hud_pixel),
    .active(hud_active)
);

always @(*) begin
    if (hud_active)
        pixel_data <= (hud_pixel ? 3'b000 : 3'b111);
    else if (y < 512)
        pixel_data <= (framebuffer_pixel ? 3'b111 : 3'b100);
    else
        pixel_data <= 3'b000;
        
    if (y == 128)
        pixel_data <= 3'b001;
end

endmodule
