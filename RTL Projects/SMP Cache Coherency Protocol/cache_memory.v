module cache_memory (
    input clk,
    input reset,
    input [31:0] addr,
    input rw,
    input [31:0] data_in,
    output reg [31:0] data_out,
    input invalidate,
    input cache_hit
);

reg [31:0] cache_data [0:15]; 
reg [31:0] cache_tags [0:15]; 
reg [1:0] cache_states [0:15]; 

always @(posedge clk or posedge reset) begin
    if (reset) begin
        integer i;
        for (i = 0; i < 16; i = i + 1) begin
            cache_data[i] <= 32'b0;
            cache_tags[i] <= 32'b0;
            cache_states[i] <= 2'b00;
        end
    end else begin
        integer index;
        index = addr[3:0];

        if (invalidate) begin
            cache_states[index] <= 2'b00;
        end else if (rw) begin
            cache_data[index] <= data_in;
            cache_tags[index] <= addr[31:4];
            cache_states[index] <= 2'b10;
        end else begin
            if (cache_states[index] == 2'b10 || cache_states[index] == 2'b01) begin
                data_out <= cache_data[index];
            end else begin
                data_out <= 32'b0;
            end
        end
    end
end

endmodule
