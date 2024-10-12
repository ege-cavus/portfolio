module RegisterFile(
    input clk,
    input [4:0] read_addr1, read_addr2, write_addr,
    input [31:0] write_data,
    input reg_write,
    output reg [31:0] read_data1, read_data2
);
    reg [31:0] registers [0:31]; // 32 registers

    always @(posedge clk) begin
        if (reg_write) begin
            registers[write_addr] <= write_data; // Write data to register
        end
    end

    always @(*) begin
        read_data1 = registers[read_addr1]; // Read data from register 1
        read_data2 = registers[read_addr2]; // Read data from register 2
    end
endmodule
