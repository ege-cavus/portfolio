module NeuralNetworkProcessor(
    input clk,
    input reset
);
   
    parameter WIDTH = 10;
    parameter LEARNING_RATE = 32'h00000001;
    parameter NUM_SAMPLES = 10;

   
    reg [31:0] x [0:WIDTH-1];
    reg [31:0] y_true [0:NUM_SAMPLES-1];
    reg [31:0] weights [0:WIDTH-1];
    reg [31:0] bias;
    reg [31:0] y_pred;
    reg [31:0] grad_w [0:WIDTH-1]; 
    reg [31:0] grad_b;
    reg [31:0] loss; 
    reg [31:0] sum_loss; // Accumulated loss for averaging

    // Instruction memory interface
    wire [31:0] instruction;
    wire [7:0] pc_out;
    wire reg_write;
    wire [4:0] write_addr, read_addr1, read_addr2;
    wire [31:0] read_data1, read_data2, write_data; // Register data

    // Control signals
    reg [7:0] next_pc;
    reg start_training;
    integer i; // Loop index

    // Instantiate components
    ProgramCounter pc(
        .clk(clk),
        .reset(reset),
        .next_addr(next_pc),
        .pc(pc_out)
    );

    InstructionMemory imem(
        .addr(pc_out),
        .instruction(instruction)
    );

    ControlUnit control(
        .instruction(instruction),
        .reg_write(reg_write),
        .write_addr(write_addr),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .next_pc(next_pc)
    );

    RegisterFile reg_file(
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

   
    initial begin
       
        x[0] = 32'h00000001;
        x[1] = 32'h00000002;
       
        y_true[0] = 32'h00000003;
        y_true[1] = 32'h00000006;

        for (i = 0; i < WIDTH; i = i + 1) begin
            weights[i] = 32'h00000001;
        end
        bias = 32'h00000001; 
        sum_loss = 0;
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum_loss <= 0;
        end else if (start_training) begin
            
            y_pred = 0;
            for (i = 0; i < WIDTH; i = i + 1) begin
                y_pred = y_pred + (x[i] * weights[i]); 
            end
            y_pred = y_pred + bias;
            loss = (y_pred - y_true[0]) * (y_pred - y_true[0]);
            sum_loss = sum_loss + loss;

            for (i = 0; i < WIDTH; i = i + 1) begin
                grad_w[i] = 2 * (y_pred - y_true[0]) * x[i];
            end
            grad_b = 2 * (y_pred - y_true[0]);

           
            for (i = 0; i < WIDTH; i = i + 1) begin
                weights[i] = weights[i] - (LEARNING_RATE * grad_w[i]);
            end
            bias = bias - (LEARNING_RATE * grad_b);

           
            write_data = y_pred;
            if (reg_write) begin
                reg_file.write_data = write_data;
            end
            
           
            for (i = 0; i < WIDTH; i = i + 1) begin
                write_addr = i;
                write_data = weights[i];
                if (reg_write) begin
                    reg_file.write_data = write_data;
                end
            end
        end
    end


endmodule
