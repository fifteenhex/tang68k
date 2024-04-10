module cpuaddr2xy 
(
    input logic [31:0] addr,
    output logic [9:0] x,
    output logic [8:0] y
);

    assign x = {addr[6:1], 4'b0000};
    assign y = addr[(8 + 7):(0 + 7)];

endmodule
