`include "ctrl_encode_def.v"
//计算下一个程序计数器（PC）地址的模块
module NPC(PC, NPCOp, IMM, NPC, RD1);  // next pc module
    
   input  [31:0] PC;        // pc
   input  [1:0]  NPCOp;     // next pc operation
   input  [25:0] IMM;       // immediate
   input  [31:0] RD1;      // jr
   output reg [31:0] NPC;   // next pc
   
   wire [31:0] PCPLUS4;
   
   assign PCPLUS4 = PC + 4; // pc + 4
   
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4:  NPC = PCPLUS4;
          `NPC_BRANCH: NPC = PCPLUS4 + {{14{IMM[15]}}, IMM[15:0], 2'b00}; //bne beq
          `NPC_JUMP:   NPC = {PCPLUS4[31:28], IMM[25:0], 2'b00};
          `NPC_JR:     NPC = RD1;
          default:     NPC = PCPLUS4;
      endcase
   end // end always
   
endmodule