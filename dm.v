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
   
   always @(posedge clk) begin
      if (DMWr) begin
        $display("dmem[0x%8X] = 0x%8X,1", addrByte, dmem[addrByte]);
         case (memOp)
            2'b00: begin  // 字操作
               dmem[addrByte[8:2]] <= din;  // 存储32位
            end
            2'b01: begin  // 字节操作
               case (addrByte[1:0])
                  2'b00: dmem[addrByte[8:2]][7:0]   <= din[7:0];   // 存储低8位
                  2'b01: dmem[addrByte[8:2]][15:8]  <= din[7:0];   // 存储第8-15位
                  2'b10: dmem[addrByte[8:2]][23:16] <= din[7:0];   // 存储第16-23位
                  2'b11: dmem[addrByte[8:2]][31:24] <= din[7:0];   // 存储高8位
               endcase
            end
            2'b10: begin  // 半字操作
               if (addrByte[1] == 1'b0) begin
                  dmem[addrByte[8:2]][15:0] <= din[15:0];  // 存储低16位
               end 
               else begin
                  dmem[addrByte[8:2]][31:16] <= din[15:0]; // 存储高16位
               end
            end
            2'b11: begin  // 字操作
               dmem[addrByte[8:2]] <= din;  // 存储32位
            end
         endcase
         $display("dmem[0x%8X] = 0x%8X,2", addrByte, dmem[addrByte]);
      end
   end
   
endmodule    
