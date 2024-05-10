`include "ctrl_encode_def.v"
//CPU的ALU计算模块，负责各个指令在EX段的算术操作，由Verilog HDL自带的算术运算模块设计而成
/*定义了一个名为 alu 的模块，它有五个端口：两个输入 A 和 B（32位，有符号），
一个输入 ALUOp（3位，用于指示ALU操作类型），
一个输出 C（32位，有符号），以及一个输出 Zero（用于指示结果是否为0）。*/
module alu(A, B, ALUOp, C, Zero);
           
   input  signed [31:0] A, B;
   input         [3:0]  ALUOp;
   output signed [31:0] C;
   output Zero;
   
   reg [31:0] C;
   integer    i;
       
   always @( * ) begin
      case ( ALUOp )
          `ALU_NOP:  C = A;                          // NOP
          `ALU_ADD:  C = A + B;                      // ADD
          `ALU_SUB:  C = A - B;                      // SUB
          `ALU_AND:  C = A & B;                      // AND/ANDI
          `ALU_OR:   C = A | B;                      // OR/ORI
          `ALU_SLT:  C = (A < B) ? 32'd1 : 32'd0;    // SLT/SLTI
          `ALU_SLTU: C = ({1'b0, A} < {1'b0, B}) ? 32'd1 : 32'd0;
          `ALU_SLL:  C = B << A;                  // SLL/SLLI 左移
          `ALU_SRL:  C = B >> A;                  // SRL/SRLI  右移
          `ALU_NOR:  C = ~(A | B);                   // NOR 
          `ALU_LUI:  C = B << 16;                    // LUI
          `ALU_XOR:  C = A ^ B;                      // XOR  异或

          default:   C = A;                          // Undefined
      endcase
   end // end always
   
   assign Zero = (C == 32'b0);

endmodule
         //  `ALU_XOR:  C = A ^ B;                      // XOR  异或
         //  `ALU_SRA:  C = A >>> B;                    // SRA/SRAI  算术右移
         //  `ALU_SRAV: C = A >>> B;                    // SRV/SRAVI  可变算术右移
          //`ALU_SLLV: C = B << A[4:0];              //SLLV
          //`ALU_SRLV: C = B >> A[4:0];             //SRLV
/*
todo
sra - 算术右移
功能：将寄存器中的值右移指定位数，高位填充符号位（即最左边的位）。
格式：sra $rd, $rt, shamt
srav - 可变算术右移
功能：与sra相似，但移位数由另一个寄存器指定。
格式：srav $rd, $rt, $rs
lb - 加载字节
功能：从内存地址加载一个字节到寄存器，符号扩展到32位。
格式：lb $rt, offset($base)
实现注意事项：实现符号扩展和正确的内存地址计算。
lh - 加载半字
功能：从内存地址加载两个字节（半字）到寄存器，符号扩展到32位。
格式：lh $rt, offset($base)
实现注意事项：和lb类似，但涉及到更多字节的处理。
lbu - 加载字节（无符号）
功能：类似于lb，但进行零扩展。
格式：lbu $rt, offset($base)
实现注意事项：需要正确实现零扩展。
lhu - 加载半字（无符号）
功能：类似于lh，但进行零扩展。
格式：lhu $rt, offset($base)
实现注意事项：涉及零扩展和更多字节的处理。
sb - 存储字节
功能：将寄存器的低8位存储到内存中的一个字节。
格式：sb $rt, offset($base)
实现注意事项：确保只操作内存的一个字节。
sh - 存储半字
功能：将寄存器的低16位存储到内存中的两个字节。
格式：sh $rt, offset($base)
实现注意事项：正确处理内存的两个字节
*/
