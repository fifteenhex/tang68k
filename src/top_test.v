module top_test
#(
    CLOCK_PERIOD = 10
);

reg ext_clk;
reg s1;

always #(CLOCK_PERIOD/2) ext_clk = ~ext_clk;

top uut(
    .ext_clk(ext_clk),
    .s1(s1)
);

initial begin
    $dumpfile("top.vcd");
    $dumpvars(0,uut);

    ext_clk <= 0;
    s1 <= 0;

    #10 s1 <= 0;
    #20 s1 <= 1;
    #30 s1 <= 0;
    #1000000;

    $finish;
end

endmodule
