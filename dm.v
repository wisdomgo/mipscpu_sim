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
   input  [8:0]   addr;
   input  [31:0]  din;
   output [31:0]  dout;
   input  [1:0]   memOp;    //内存操作类型: 00 字节 01 半字 10 字
   
   reg [31:0] dmem[127:0];
    // 初始化dmem数组 方面仿真结果与mars做对比
   integer i;
   initial begin
   for (i = 0; i < 128; i = i + 1) begin
        dmem[i] = 32'b0;
    end
   end
   always @(posedge clk) begin
      if (DMWr) begin
         case (memOp)
            2'b00: begin  // 字操作
               dmem[addr[8:2]] <= din;  // 存储32位
            end
            2'b01: begin  // 字节操作
                case (addr[1:0])
                    2'b00: dmem[addr[8:2]] = {dout[31:8], din[7:0]};  // 最低字节
                    2'b01: dmem[addr[8:2]] = {dout[31:16], din[7:0], dout[7:0]};  // 低字节
                    2'b10: dmem[addr[8:2]] = {dout[31:24], din[7:0], dout[15:0]}; // 中字节
                    2'b11: dmem[addr[8:2]] = {din[7:0], dout[23:0]};  // 高字节
                endcase
            end
            2'b10: begin  // 半字操作
               if (addr[1] == 1'b0) begin
                  dmem[addr[8:2]] = {dout[31:16], din[15:0]};  // 存储低16位
               end 
               else begin
                  dmem[addr[8:2]] = {din[15:0], dout[15:0]}; // 存储高16位
               end
            end
            2'b11: begin  // 字操作
               dmem[addr[8:2]] <= din;  // 存储32位
            end
         endcase
         $display("0x%8x = 0x%8X", addr[8:0], dmem[addr[8:2]]);
      end
   end
   assign dout = dmem[addr[8:2]];
   
endmodule    
