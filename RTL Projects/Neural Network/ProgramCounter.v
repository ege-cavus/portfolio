module ProgramCounter(
    input clk,
    input reset,
    input [7:0] next_addr,
    output reg [7:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0; 
        end else begin
            pc <= next_addr;
        end
    end
endmodule
