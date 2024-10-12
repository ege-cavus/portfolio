module top_level (
    input clk,
    input reset,
    input [31:0] addr,
    input rw,
    input [31:0] data_in,
    output [31:0] data_out,
    output cache_hit,
    output bus_request,
    input bus_grant,
    input [31:0] bus_data_in,
    output [31:0] bus_data_out,
    input bus_rw,
    output invalidate,
    input snoop_hit
);

wire [31:0] cache_data_out;
wire [31:0] cache_memory_data_out;

cache_memory cache (
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .rw(rw),
    .data_in(data_in),
    .data_out(cache_data_out),
    .invalidate(invalidate),
    .cache_hit(cache_hit)
);

bus_interface bus (
    .clk(clk),
    .reset(reset),
    .bus_request(bus_request),
    .bus_grant(bus_grant),
    .bus_data_in(bus_data_in),
    .bus_data_out(bus_data_out),
    .bus_rw(bus_rw),
    .cache_hit(cache_hit),
    .invalidate(invalidate)
);

cache_controller controller (
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .rw(rw),
    .data_in(data_in),
    .data_out(data_out),
    .cache_hit(cache_hit),
    .bus_request(bus_request),
    .bus_grant(bus_grant),
    .bus_data_in(bus_data_in),
    .bus_data_out(bus_data_out),
    .bus_rw(bus_rw),
    .invalidate(invalidate),
    .snoop_hit(snoop_hit)
);

endmodule
