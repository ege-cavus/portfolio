module bus_interface (
    input clk,
    input reset,
    input bus_request,
    output reg bus_grant,
    input [31:0] bus_data_in,
    output reg [31:0] bus_data_out,
    output reg bus_rw,
    input cache_hit,
    output reg invalidate
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bus_grant <= 0;
        bus_data_out <= 32'b0;
        bus_rw <= 0;
        invalidate <= 0;
    end else begin
        if (bus_request) begin
            bus_grant <= 1;
            bus_rw <= 1; 
            bus_data_out <= bus_data_in;
            invalidate <= 0; 
        end else if (cache_hit) begin
            bus_grant <= 1;
            bus_rw <= 0; 
            bus_data_out <= 32'b0; 
            invalidate <= 1; 
        end else begin
            bus_grant <= 0;
        end
    end
end

endmodule
