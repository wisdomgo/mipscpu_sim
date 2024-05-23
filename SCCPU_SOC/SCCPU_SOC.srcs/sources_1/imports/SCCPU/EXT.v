//数字扩展模块，在一些指令中，要对寄存器数字进行扩展，这个模块负责进行符号或者算术扩展
module EXT( Imm16, EXTOp, Imm32 );
    
   input  [15:0] Imm16; //16位输入立即数
   input         EXTOp; //控制信号、指示扩展类型
   output [31:0] Imm32; //32位输出立即数
   
   assign Imm32 = (EXTOp) ? {{16{Imm16[15]}}, Imm16} : {16'b0, Imm16}; // signed-extension or zero extension
       
endmodule