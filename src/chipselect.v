module chipselect
#(
    NUM_SELECTS = 8
)
(
    input [31:0] addr,
    output [NUM_SELECTS - 1:0] chipselects
);
    int cs_msb = $left(addr);
    int cs_lsb = $left(addr) - ($clog2(NUM_SELECTS) - 1);

    reg [$clog2(NUM_SELECTS) - 1: 0] cs_bits;
    assign cs_bits = addr[$left(addr):$left(addr) - ($clog2(NUM_SELECTS) - 1)];
    
    genvar i;
    generate
        for (i = 0; i < NUM_SELECTS; i++) begin
            assign chipselects[i] = (cs_bits == i) ? '1 : '0;
        end
    endgenerate

endmodule
