module processor_interface (
    input clk,
    input reset,
    input [31:0] proc_addr,     
    input proc_rw,           
    input [31:0] proc_data_in,  
    output reg [31:0] proc_data_out,
    output reg cache_rw,       
    output reg [31:0] cache_addr,    
    output reg [31:0] cache_data_in, 
    input [31:0] cache_data_out, 
    input cache_hit            
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        proc_data_out <= 32'b0;
        cache_rw <= 1'b0;
        cache_addr <= 32'b0;
        cache_data_in <= 32'b0;
    end
    else begin
        cache_addr <= proc_addr;
        cache_rw <= proc_rw;
        if (proc_rw) begin
            cache_data_in <= proc_data_in;
        end else if (cache_hit) begin
            proc_data_out <= cache_data_out; 
        end
    end
end

endmodule
