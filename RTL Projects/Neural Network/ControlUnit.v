module ControlUnit(
    input [31:0] instruction,
    output reg reg_write,
    output reg [4:0] write_addr,
    output reg [4:0] read_addr1, read_addr2,
    output reg [7:0] next_pc
);
    always @(*) begin
       
        case (instruction[31:24])

            8'h00: begin // NOP
                reg_write = 0;
                next_pc = 1;
            end
            8'h01: begin
                reg_write = 1;
                write_addr = instruction[23:19];
                read_addr1 = instruction[18:14];
                next_pc = 2;
            end
            8'h02: begin
                reg_write = 0;
                next_pc = 3;
            end
            default: begin
                reg_write = 0;
                next_pc = 0; 
            end
        endcase
    end
endmodule
