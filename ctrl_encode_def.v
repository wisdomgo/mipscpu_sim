//存放ALU不同计算操作的编码

// NPC control signal
`define NPC_PLUS4   2'b00 //PC值加4，通常用于顺序执行的下一条指令。
`define NPC_BRANCH  2'b01 //当分支条件满足时，PC跳转到分支目标地址。
`define NPC_JUMP    2'b10 //无条件跳转到指定的跳转地址。
`define NPC_JR      2'b11 // 给jr指令使用

// ALU control signal
// `define ALU_NOP   3'b000  //无操作，ALU不执行任何算术或逻辑运算。
// `define ALU_ADD   3'b001  //加法运算，ALU将输入值相加。
// `define ALU_SUB   3'b010  //减法运算，ALU将输入值相减。
// `define ALU_AND   3'b011  //逻辑与运算，ALU对输入值执行逻辑与操作。
// `define ALU_OR    3'b100  //逻辑或运算，ALU对输入值执行逻辑或操作。
// `define ALU_SLT   3'b101  //设置小于运算，如果第一个输入小于第二个输入，ALU输出1；否则输出0。
// `define ALU_SLTU  3'b110  //无符号设置小于运算，逻辑同 ALU_SLT，但比较时视输入为无符号数。

// ALU control singal
`define ALU_NOP   4'b0000 
`define ALU_ADD   4'b0001
`define ALU_SUB   4'b0010 
`define ALU_AND   4'b0011
`define ALU_OR    4'b0100
`define ALU_SLT   4'b0101
`define ALU_SLTU  4'b0110
`define ALU_SLL   4'b0111
`define ALU_SRL   4'b1000
`define ALU_NOR   4'b1001
`define ALU_LUI   4'b1010
`define ALU_XOR   4'b1011
`define ALU_SRA   4'b1100
`define ALU_SRAV  4'b1101