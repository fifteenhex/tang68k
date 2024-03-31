module chipselect_test
#(
    CLOCK_PERIOD = 10
);

reg clk;
reg [31:0] addr;

always #(CLOCK_PERIOD/2) clk = ~clk;

chipselect uut(
    .addr(addr)
);

initial begin
    $dumpfile("chipselect.vcd");
    $dumpvars(0,clk);
    $dumpvars(0,uut);

    clk <= 0;
    addr <= 0;

    for (int i = 0; i < (uut.NUM_SELECTS * 2); i++) begin
        addr += 'h10000000;
        @(posedge clk);
    end
    
    $finish;
end

endmodule
