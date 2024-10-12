module InstructionMemory(
    input [7:0] addr,
    output reg [31:0] instruction
);
    reg [31:0] memory [0:255];

    initial begin
       
        memory[0] = 32'h00000000; // Null
        memory[1] = 32'h00000001; // Loading State
        memory[2] = 32'h00000002; // Gradient Descent Calculation Step
       
    end

    always @(*) begin
        instruction = memory[addr];
    end
endmodule
