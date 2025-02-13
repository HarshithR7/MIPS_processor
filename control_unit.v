`timescale 1ns / 1ps

module control_unit(
    input [5:0] opcode,
    input [5:0] funct,
    output reg reg_dst,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [3:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg jump,         //  J-type instructions
    output reg branch_type,
    output reg is_shift
);
    // Opcode definitions
    parameter R_TYPE = 6'b000000;
    parameter LW     = 6'b100011;
    parameter SW     = 6'b101011;
    parameter BEQ    = 6'b000100;
    parameter BNE    = 6'b000101;
    parameter ADDI   = 6'b001000;
    parameter ANDI   = 6'b001100;
    parameter ORI    = 6'b001101;
    parameter J      = 6'b000010;  // Jump
  

    always @(*) begin
        // Default control values
        reg_dst = 0;
        branch = 0;
        mem_read = 0;
        mem_to_reg = 0;
        alu_op = 4'b0000;
        mem_write = 0;
        alu_src = 0;
        reg_write = 0;
        jump = 0;
        is_shift = 0;
        branch_type = 0;

        case(opcode)
            R_TYPE: begin
                reg_dst = 1;
                reg_write = 1;
                case(funct)
                    6'b100000: begin // ADD
                        alu_op = 4'b0010;
                    end
                    6'b100010: begin // SUB
                        alu_op = 4'b1010;
                    end
                    6'b100100: begin // AND
                        alu_op = 4'b0100;
                    end
                    6'b100101: begin // OR
                        alu_op = 4'b0101;
                    end
                    6'b000000: begin // SLL
                        alu_op = 4'b0110;
                        is_shift = 1;
                    end
                    6'b000010: begin // SRL
                        alu_op = 4'b0111;
                        is_shift = 1;
                    end
                    6'b000011: begin // SRA
                        alu_op = 4'b1000;
                        is_shift = 1;
                    end
                   // 6'b000100: begin // beq
                     //   alu_op = 4'b1011;
                       // is_shift = 0;
                    //end
                    //6'b000101: begin // bne
                      //  alu_op = 4'b1011;
                        //is_shift = 0;
                    //end
                endcase
            end
            
            // I-type instructions

            ADDI: begin
                alu_src = 1;
                reg_write = 1;
                alu_op = 4'b0010;  
                reg_dst = 0;       
                mem_to_reg = 0;    
                branch = 0;
                jump = 0;
                mem_read = 0;
                mem_write = 0;
                is_shift = 0;
            end
            
            // ANDI instruction
ANDI: begin
    alu_src = 1;
    reg_write = 1;
    alu_op = 4'b0100;  
    reg_dst = 0;       
    mem_to_reg = 0;    
    branch = 0;
    jump = 0;
    mem_read = 0;
    mem_write = 0;
    is_shift = 0;
end

// ORI instruction
ORI: begin
    alu_src = 1;
    reg_write = 1;
    alu_op = 4'b0101;  
    reg_dst = 0;       
    mem_to_reg = 0;    
    branch = 0;
    jump = 0;
    mem_read = 0;
    mem_write = 0;
    is_shift = 0;
end
            
            // Memory instructions (I-type)
            LW: begin
                alu_src = 1;
                mem_to_reg = 1;
                reg_write = 1;
                mem_read = 1;
                alu_op = 4'b0010;  
            end
            
            SW: begin
                alu_src = 1;
                mem_write = 1;
                alu_op = 4'b0010;  
            end
            
            // Branch instructions (I-type)
            BEQ: begin
                branch = 1;
                branch_type = 0;
                alu_op = 4'b1011; 
                alu_src=0;
                reg_write=0;
            end
            
            BNE: begin
                branch = 1;
                branch_type = 1;
                alu_op = 4'b1101;  
                alu_src=0;
                reg_write=0;
            end

            // J-type instructions
            J: begin
                jump = 1;
                reg_write = 0;
                alu_op = 4'b0000;  
                branch = 0;       
                mem_write = 0;     
                mem_read = 0;      
                alu_src = 0;       
            
            end
        endcase
    end
endmodule