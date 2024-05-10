// `include "ctrl_encode_def.v"
// 译码模块，讲MIPS汇编语言程序形成的机械指令进行译码相关操作
// mips = op + rs + rt + rd + shamt + funct
//   32 = 6   + 5  + 5  + 5  + 5     + 6
module ctrl(Op, Funct, Zero, 
            RegWrite, MemWrite,
            EXTOp, ALUOp, NPCOp, 
            ALUSrc, GPRSel, WDSel, AregSel
            );
  /*定义了一个名为 ctrl 的模块，这是一个控制单元模块，它生成对应于指令的控制信号。输入包括操作码 Op、功能码 Funct 和零标志 Zero，输出包括各种控制信号。*/
   input  [5:0] Op;       // opcode
   input  [5:0] Funct;    // funct
   input        Zero;
   
   output       RegWrite; // control signal for register write
   output       MemWrite; // control signal for memory write
   output       EXTOp;    // control signal to signed extension
   output [3:0] ALUOp;    // ALU opertion
   output [1:0] NPCOp;    // next pc operation
   output       ALUSrc;   // ALU source for A
  

  output  [1:0] GPRSel;   // general purpose register selection
  output  [1:0] WDSel;    // (register) write data selection
  output       AregSel;
  //这些输出定义了控制信号，控制寄存器写入、内存写入、ALU操作、程序计数器操作等。GPRSel 和 WDSel 分别控制通用寄存器选择和数据写入选择。
  // r format
  //这行代码定义了一个信号 rtype，用于检测R类型的指令。~|Op 是 Op 所有位的 NOR 运算，如果 Op 为全0，则 rtype 为真，表示是R类型指令。
  // R型   op(6) + rs(5) + rt(5) + constant or address(16)
   wire rtype  = ~|Op; //操作码全为0即为R型指令
   wire i_add  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // add 100000
   wire i_sub  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // sub 100010
   wire i_and  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // and 100100
   wire i_or   = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]& Funct[0]; // or  100101
   wire i_slt  = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // slt 101010
   wire i_sltu = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // sltu 101011
   wire i_addu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // addu 100001
   wire i_subu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // subu 100011
   wire i_sll  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // sll 000000
   wire i_srl  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // srl 000010
   wire i_sllv = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // sllv 000100
   wire i_srlv = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // srlv 000110
   wire i_nor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; // nor 100111
   wire i_jr   = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // jr 001000
   wire i_jalr = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // jalr 001001
   wire i_xor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]&~Funct[0]; // xor 100110
   wire i_sra  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // sra 000011
   wire i_srav = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // srav 000111
  
  // i format
  // op(6) + rs(5) + rt(5) + constant or address(16)
   wire i_addi = ~Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; // addi
   wire i_ori  = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]& Op[0]; // ori
   wire i_lw   =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lw
   wire i_sw   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sw   
   wire i_beq  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // beq
   wire i_bne  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0]; // bne
   wire i_slti = ~Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]&~Op[0]; // slti 001010
   wire i_lui  = ~Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0]; // lui 001111
   wire i_andi = ~Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]& Op[0]; // andi 001100
   wire i_lb   =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lb 100000
   wire i_lh   =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lh 100001
   wire i_lbu  =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lbu 100100
   wire i_lhu  =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lhu 100101
   wire i_sb   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sb 101000
   wire i_sh   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sh 101001

  // j format
  // op(6) + address(26
   wire i_j    = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]&~Op[0];  // j
   wire i_jal  = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0];  // jal
  // generate control signals
  //寄存器写信号
  assign RegWrite   = rtype | i_lw | i_addi | i_ori |i_jal | i_slti | i_lui | i_andi | i_jalr; // register write  

  //数据写信号
  assign MemWrite   = i_sw;         //修改过，记得看看对不对 memory write
  //alusrc信号
  assign ALUSrc     = i_lw | i_sw | i_addi | i_ori | i_slti | i_lui | i_andi;   // ALU B is from instruction immediate
 //暂时不知道是啥，闹麻了
  assign EXTOp      = i_addi | i_lw | i_sw | i_slti;           // signed extension
  assign AregSel = i_sll | i_srl;

  // GPRSel_RD   1'b0
  // GPRSel_RT   1'b1
  assign GPRSel[0] = i_lw | i_addi | i_ori | i_slti | i_lui | i_andi;
  assign GPRSel[1] = i_jal | i_jalr;
  
  // WDSel_FromALU 2'b00
  // WDSel_FromMEM 2'b01
  // WDSel_FromPC  2'b10 
  assign WDSel[0] = i_lw;  
  assign WDSel[1] = i_jal | i_jalr;
  // NPC_PLUS4   2'b00
  // NPC_BRANCH  2'b01
  // NPC_JUMP    2'b10
  assign NPCOp[0] = (i_beq & Zero) | (i_bne & ~Zero) | i_jr | i_jalr;
  assign NPCOp[1] = i_j | i_jal | i_jr | i_jalr;
  
  // ALU_NOP   3'b000
  // ALU_ADD   3'b001
  // ALU_SUB   3'b010
  // ALU_AND   3'b011
  // ALU_OR    3'b100
  // ALU_SLT   3'b101
  // ALU_SLTU  3'b110
  assign ALUOp[0] = i_add | i_lw | i_sw | i_addi | i_and | i_slt | i_addu | i_sll | i_nor | i_slti;
  assign ALUOp[1] = i_sub | i_beq | i_and | i_sltu | i_subu | i_sll | i_lui;
  assign ALUOp[2] = i_or | i_ori | i_slt | i_sltu | i_sll | i_slti;
  assign ALUOp[3] = i_srl | i_srl | i_nor | i_lui;
endmodule
