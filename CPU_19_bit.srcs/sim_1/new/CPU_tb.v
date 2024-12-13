`timescale 1ns / 1ps

module CPU_tb;
    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [18:0] PC;

    // Instantiate the CPU module
    CPU uut (
        .clk(clk),
        .reset(reset),
        .PC(PC)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test variables
    integer i;

    initial begin
     
        clk = 0;
        reset = 0;

        $display("Applying Reset...");
        reset = 1;
        #10 reset = 0;
        $display("Reset Released. Starting simulation...");

        $display("Initializing Memory and Registers...");
        for (i = 0; i < 128; i = i + 1) begin
            uut.memory[i] = 19'b0;  // Clear memory
        end
        for (i = 0; i < 32; i = i + 1) begin
            uut.registers[i] = i;  // Initialize registers with index value
        end

        // ADD: R1 = R2 + R3
        uut.memory[0] = {5'b00001, 3'b010, 3'b011, 3'b001, 7'b0000000};  // ADD R1, R2, R3

        // SUB: R4 = R5 - R6
        uut.memory[1] = {5'b00010, 3'b101, 3'b110, 3'b100, 7'b0000000};  // SUB R4, R5, R6

        // MUL: R7 = R8 * R9
        uut.memory[2] = {5'b00011, 3'b1000, 3'b1001, 3'b0111, 7'b0000000};  // MUL R7, R8, R9

        // LD: R10 = MEM[20]
        uut.memory[3] = {5'b10001, 3'b000, 3'b000, 3'b1010, 7'b0010100};  // LD R10, MEM[20]

        // ST: MEM[21] = R11
        uut.memory[4] = {5'b10010, 3'b000, 3'b000, 3'b1011, 7'b0010101};  // ST MEM[21], R11

        // JMP: PC = 10
        uut.memory[5] = {5'b01100, 3'b000, 3'b000, 3'b000, 7'b0001010};  // JMP to address 10

        uut.memory[20] = 19'd100;  // Memory at address 20 = 100
        uut.memory[21] = 19'd0;    // Memory at address 21 = 0

        // Start Simulation
        #100;
        $display("Simulation complete. Checking results...");

        // Check results
        $display("Register R1 (ADD): %d (Expected: %d)", uut.registers[1], uut.registers[2] + uut.registers[3]);
        $display("Register R4 (SUB): %d (Expected: %d)", uut.registers[4], uut.registers[5] - uut.registers[6]);
        $display("Register R7 (MUL): %d (Expected: %d)", uut.registers[7], uut.registers[8] * uut.registers[9]);
        $display("Register R10 (LD): %d (Expected: 100)", uut.registers[10]);
        $display("Memory[21] (ST): %d (Expected: %d)", uut.memory[21], uut.registers[11]);

        $stop;
    end
endmodule