module cache_controller (
    input clk,
    input reset,
    input [31:0] addr,
    input rw,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg cache_hit,
    output reg bus_request,
    input bus_grant,
    input [31:0] bus_data_in,
    output reg [31:0] bus_data_out,
    input bus_rw,
    output reg invalidate,
    input snoop_hit
);

localparam INVALID = 2'b00,
           SHARED  = 2'b01,
           MODIFIED = 2'b10;

reg [1:0] cache_state;
reg [31:0] cache_data;
reg [31:0] cache_tag;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        cache_state <= INVALID;
        cache_tag <= 32'b0;
        bus_request <= 0;
        invalidate <= 0;
    end else begin
        case (cache_state)
            INVALID: begin
                if (rw) begin
                    bus_request <= 1;
                    bus_rw <= 1;
                    bus_data_out <= data_in;
                end else begin
                    bus_request <= 1;
                    bus_rw <= 0;
                end
                cache_hit <= 0;
            end
            
            SHARED: begin
                if (rw) begin
                    bus_request <= 1;
                    bus_rw <= 1;
                    bus_data_out <= data_in;
                    cache_state <= MODIFIED;
                end else begin
                    data_out <= cache_data;
                    cache_hit <= 1;
                end
            end
            
            MODIFIED: begin
                if (rw) begin
                    cache_data <= data_in;
                end else begin
                    data_out <= cache_data;
                    cache_hit <= 1;
                end
                if (bus_grant) begin
                    bus_request <= 1;
                    bus_rw <= 1;
                    bus_data_out <= cache_data;
                end
            end
        endcase
        
        if (snoop_hit) begin
            invalidate <= 1;
        end else begin
            invalidate <= 0;
        end
        
        if (bus_grant) begin
            if (rw) begin
                cache_data <= bus_data_in;
                cache_tag <= addr[31:4];
                cache_state <= MODIFIED;
            end else begin
                data_out <= bus_data_in;
                cache_hit <= 1;
            end
        end
    end
end

endmodule
