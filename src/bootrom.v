module bootrom
(
    input clk,
    input logic [31:0] addr,
    output logic [15:0] data,
    input enable = 1,
    output logic berr
);
    
    assign berr = '0;
    
    /* Static test ROM that loops */
    /*
    always @(*) begin
        case (addr)
            'h0: data <= 16'h0000;
            'h2: data <= 16'h0000;
            'h4: data <= 16'h0000;
            'h6: data <= 16'h0008;
            'h8: data <= 16'h4efa;
            'ha: data <= 16'hfffe;
            default: begin
                data <= 16'hffff;
            end
        endcase
    end
    */

    reg  [15:0] data_discard;
    
    pROM bram_prom_0 (
        .DO({data_discard, data}),
        .CLK(clk),
        .OCE('1),
        .CE(enable),
        .RESET('0),
        .AD({addr[10:1],4'b0000})
    );
    defparam bram_prom_0.READ_MODE=1'b0; // bypass
    defparam bram_prom_0.BIT_WIDTH = 16;
    defparam bram_prom_0.RESET_MODE="ASYNC";
    `include "../bootrom/bootrom.bin.gowin";

endmodule
