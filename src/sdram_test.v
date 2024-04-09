module sdram_test
#(
    CLOCK_PERIOD = 10
);

reg clk;
reg [31:0] addr;
reg [15:0] data_in;

always #(CLOCK_PERIOD/2) clk = ~clk;

sdram uut(
    .ext_clk(clk),
    .addr(addr),
    .data_in(data_in)
);

initial begin
    $dumpfile("sdram.vcd");
    $dumpvars(0,clk);
    $dumpvars(0,uut);

    clk <= 0;
    addr <= 0;
    data_in <= 0;

    for (int i = 0; i < 100; i++)
        @(posedge clk);

    $finish;
end

endmodule
