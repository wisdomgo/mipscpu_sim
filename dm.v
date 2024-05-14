// data memory 操作模块
// data memory
module dm(clk, DMWr, addr, din, dout,memOp);
//clk：时钟信号，用于控制存储器操作的时序。
//DMWr：写入使能信号，当此信号为高时，允许数据写入存储器。
//addr：访问存储器的地址，这里使用 [8:2] 表示只使用地址的一部分，实际使用的地址是7位，可以寻址128个字。
//din：写入的数据，32位宽。
//dout：从存储器读取的数据，32位宽。
   input          clk;
   input          DMWr;
   input  [8:2]   addr;
   input  [31:0]  din;
   output [31:0]  dout;
   input  [1:0]   memOp;    //内存操作类型: 00 字节 01 半字 10 字
   
   reg [31:0] dmem[127:0];
   wire [31:0] addrByte;

   
   assign addrByte = addr<<2;

   assign dout = dmem[addrByte[8:2]];
   
   always @(posedge clk)
      if (DMWr) begin
        dmem[addrByte[8:2]] <= din;
        $display("dmem[0x%8X] = 0x%8X,", addrByte, din); 
      end
   
endmodule    
