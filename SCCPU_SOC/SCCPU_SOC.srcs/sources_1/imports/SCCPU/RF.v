
  module RF(   input         clk, 
               input         rst,
               input         RFWr,  // 寄存器文件写使能信号
               input  [4:0]  A1, A2, A3, // rs rt rd
               input  [31:0] WD, 
               output [31:0] RD1, RD2,
               input  [4:0]  reg_sel,
               output [31:0] reg_data,
               input  [1:0]  memOp,
               input  [1:0]  addr,
               input         EXTOp);

  reg [31:0] rf[31:0];

  integer i;

  always @(posedge clk, posedge rst)
    if (rst) begin    //  reset
      for (i=1; i<32; i=i+1)
        rf[i] <= 0; //  i;
    end
      
    else if (RFWr) begin
        case (memOp)
            2'b00: begin
                rf[A3] <= WD;
                $display("r[%2d] = 0x%8X,", A3, WD);
            end
            2'b01: begin
                if(EXTOp == 1'b1) // 判断是符号扩展还是零扩展
                    case (addr[1:0])
                        2'b00: begin
                            rf[A3] <= {{24{WD[7]}}, WD[7:0]};
                            $display("r[%2d] = 0x%8X,", A3, {{24{WD[7]}}, WD[7:0]});
                        end
                        2'b01: begin
                            rf[A3] <= {{24{WD[15]}}, WD[15:8]};
                            $display("r[%2d] = 0x%8X,", A3, {{24{WD[15]}}, WD[15:8]});
                        end
                        2'b10: begin
                            rf[A3] <= {{24{WD[23]}}, WD[23:16]};
                            $display("r[%2d] = 0x%8X,", A3, {{24{WD[23]}}, WD[23:16]});
                        end
                        2'b11: begin
                            rf[A3] <= {{24{WD[31]}}, WD[31:24]};
                            $display("r[%2d] = 0x%8X,", A3, {{24{WD[31]}}, WD[31:24]});
                        end
                    endcase
                else if(EXTOp == 1'b0)
                    case (addr[1:0])
                        2'b00: begin
                            rf[A3] <= {{24'b0}, WD[7:0]};
                            $display("r[%2d] = 0x%8X,", A3, {{24'b0}, WD[7:0]});
                        end
                        2'b01: begin
                            rf[A3] <= {{24'b0}, WD[15:8]};
                            $display("r[%2d] = 0x%8X,", A3, {{24'b0}, WD[15:8]});
                        end
                        2'b10: begin
                            rf[A3] <= {{24'b0}, WD[23:16]};
                            $display("r[%2d] = 0x%8X,", A3, {{24'b0}, WD[23:16]});
                        end
                        2'b11: begin
                            rf[A3] <= {{24'b0}, WD[31:24]};
                            $display("r[%2d] = 0x%8X,", A3, {{24{WD[31]}}, WD[31:24]});
                        end
                    endcase
            end
            2'b10: begin
                if(EXTOp == 1'b1)
                    case (addr[1])
                        1'b0: begin
                            rf[A3] <= {{16{WD[15]}}, WD[15:0]};
                            $display("r[%2d] = 0x%8X,", A3, {{16{WD[15]}}, WD[15:0]});
                        end
                        1'b1: begin
                            rf[A3] <= {{16{WD[31]}}, WD[31:16]};
                            $display("r[%2d] = 0x%8X,", A3, {{16{WD[31]}}, WD[31:16]});
                        end
                    endcase
                else if(EXTOp == 1'b0)
                    case (addr[1])
                        1'b0: begin
                            rf[A3] <= {{16'b0}, WD[15:0]};
                            $display("r[%2d] = 0x%8X,", A3, {{16'b0}, WD[15:0]});
                        end
                        1'b1: begin
                            rf[A3] <= {{16'b0}, WD[31:16]};
                            $display("r[%2d] = 0x%8X,", A3, {{16'b0}, WD[31:16]});
                        end
                    endcase
            end
            2'b11: begin
                rf[A3] <= WD;
                $display("r[%2d] = 0x%8X,", A3, WD); // lw：直接写入32位数据
            end
        endcase
        $display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]);
        //$display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, 123, 123123, 3, rf[4], rf[5], rf[6], rf[7]);
        $display("r[08-15]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[8], rf[9], rf[10], rf[11], rf[12], rf[13], rf[14], rf[15]);
        $display("r[16-23]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[16], rf[17], rf[18], rf[19], rf[20], rf[21], rf[22], rf[23]);
        $display("r[24-31]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[24], rf[25], rf[26], rf[27], rf[28], rf[29], rf[30], rf[31]);
        //$display("r[%2d] = 0x%8X,", A3, WD); // 由于赋值在时钟周期结束后才实现，因此不能直接看rf[A3]
      end
    

  assign RD1 = (A1 != 0) ? rf[A1] : 0;
  assign RD2 = (A2 != 0) ? rf[A2] : 0;
  assign reg_data = (reg_sel != 0) ? rf[reg_sel] : 0; 

endmodule 
