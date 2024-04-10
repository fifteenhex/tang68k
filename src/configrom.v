module configrom
#(
    cs_bootrom,
    cs_configrom,
    cs_internalram,
    cs_framebuffer
)
(
    input clk,
    input logic [31:0] addr,
    output logic [15:0] data_out,
    input enable = 0
);

    always @(*) begin
        case (addr)
            'h0: data_out <= 16'h0000;
            default: begin
                data_out <= 16'hffff;
            end
        endcase
    end

endmodule
