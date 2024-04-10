module cpuaddr2xy_test
#(
    CLOCK_PERIOD = 10
);

reg clk;
reg [31:0] addr;

always #(CLOCK_PERIOD/2) clk = ~clk;

cpuaddr2xy uut(
    .addr(addr)
);

initial begin
    $dumpfile("cpuaddr2xy.vcd");
    $dumpvars(0,clk);
    $dumpvars(0,uut);

    clk <= 0;
    addr <= 0;

    for (int y = 0; y < 512; y++) begin
        for (int x = 0; x < (1024 / 8); x++) begin
            addr <= (y * (1024/8)) + x;
            @(posedge clk);
        end
    end
    
    $finish;
end

endmodule
