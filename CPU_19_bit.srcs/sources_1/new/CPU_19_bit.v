module CPU (
    input clk,
    input reset,
    output reg [18:0] PC
);
    reg [18:0] registers [31:0];
    reg [18:0] memory [127:0];

    reg [4:0] opcode;   
    reg [2:0] src1, src2, dest;  
    reg [6:0] addr;     
    
    reg [18:0] result;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 19'b0;  
        end else begin
            
            opcode <= memory[PC][18:14];    
            src1 <= memory[PC][13:11];      
            src2 <= memory[PC][10:8];      
            dest <= memory[PC][7:5];        
            addr <= memory[PC][6:0];       

            case (opcode)
                // Arithmetic Instructions
                
                5'b00001: result <= registers[src1] + registers[src2];  //ADD
                5'b00010: result <= registers[src1] - registers[src2];  //SUB
                5'b00011: result <= registers[src1] * registers[src2];  //MUL
                5'b00100: result <= registers[src1] / registers[src2];  //DIV
                5'b00101: result <= registers[src1] + 1; // INC
                5'b00110: result <= registers[src1] - 1; //DEC

                // Logical Instructions
                
                5'b01000: result <= registers[src1] & registers[src2];  // AND
                5'b01001: result <= registers[src1] | registers[src2];  // OR
                5'b01010: result <= registers[src1] ^ registers[src2];  // XOR
                5'b01011: result <= ~registers[src1];  // NOT

                // Control Flow Instructions
                
                5'b01100: PC <= addr;  // JMP (Jump)
                5'b01101: if (registers[src1] == registers[src2]) PC <= addr;  // BEQ (Branch if equal)
                5'b01110: if (registers[src1] != registers[src2]) PC <= addr;  // BNE (Branch if not equal)
                5'b01111: begin  // CALL (Function Call)
                   
                    registers[31] <= PC + 1;  
                    PC <= addr;
                end
                5'b10000: PC <= registers[31];  
                
                // Memory Access Instructions
                
                5'b10001: registers[dest] <= memory[addr];  // LD (Load)
                5'b10010: memory[addr] <= registers[dest];  //  (Store)

                5'b10100: begin  // FFT
                   
                    memory[dest] <= registers[src1];  
                end
                5'b10101: begin  // ENC
                    
                    memory[dest] <= registers[src1];  
                end
                5'b10110: begin  // DEC 
                    
                    memory[dest] <= registers[src1];  
                end

                default: PC <= PC + 1;  
            endcase
            
            if (opcode >= 5'b00001 && opcode <= 5'b00110) begin
                registers[dest] <= result;
            end

            if (opcode != 5'b01100 && opcode != 5'b01101 && opcode != 5'b01110 && opcode != 5'b01111) begin
                PC <= PC + 1;
            end
        end
    end
endmodule