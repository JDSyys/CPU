`include "ctrl_encode_def.v"
// data memory
module forwardunit(
input   RegWrite_ex_mem_out,
input [4:0]  rd_id_ex_mem_out,
input  [4:0] rs1_id_id_ex_out,
input   RegWrite_mem_wb_out,
input  [4:0] rd_id_mem_wb_out,
input [4:0]  rs2_id_id_ex_out,
input  MemRead_id_ex_out,
input   Memwrite_if_id_out,
input [4:0]  rd_id_id_ex_out,
input [4:0]  rs1_id_if_id_out,
input[4:0]   rs2_id_if_id_out,
input Memread_mem_wb_out,
input MemWrite_ex_mem_out,
input [4:0]rs2_id_ex_mem_out,
output reg[1:0]forwardA,
output reg[1:0]forwardB,
output reg forwardC,
output reg stall
);
always @(*) begin
//不是load或store指令引起的冒险(Memread=0，Memwrite=0时)
   forwardA<=2'b00;
   //forwardA =10,数据源于EX/MEM,ALU的第一个源操作数来自于EX/MEM流水线寄存器的数据前递,数据用的是上一个ALU的结果
   if((RegWrite_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&(rd_id_ex_mem_out==rs1_id_id_ex_out))   begin   forwardA<=2'b10; end
   //forwardA =01,数据源于MEM/WB,ALU的第一个源操作数来自于MEM/WB流水线寄存器的数据前递,数据用的是数据存储器的或者是更早的ALU计算结果
      else if((RegWrite_mem_wb_out)&&(rd_id_mem_wb_out!=0)&&(rd_id_mem_wb_out==rs1_id_id_ex_out)&&(!((RegWrite_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&(rd_id_ex_mem_out==rs1_id_id_ex_out)))) 
         begin    forwardA<=2'b01; end
   //forwardA =00,数据源于ID/EX,ALU的第一个源操作数来自于ID/EX流水线寄存器的数据,不需要前递,数据用的就是寄存器的 
      else begin   forwardA<=2'b00;  end 
     
         forwardB<=2'b00;
   //forwardB =10,数据源于EX/MEM,ALU的第2个源操作数来自于EX/MEM流水线寄存器的数据前递,数据用的是上一个ALU的结果
   if((RegWrite_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&(rd_id_ex_mem_out==rs2_id_id_ex_out))   begin   forwardB<=2'b10; end
   //forwardB =01,数据源于MEM/WB,ALU的第2个源操作数来自于MEM/WB流水线寄存器的数据前递,数据用的是数据存储器的或者是更早的ALU计算结果  
      else if((RegWrite_mem_wb_out)&&(rd_id_mem_wb_out!=0)&&(rd_id_mem_wb_out==rs2_id_id_ex_out)&&(!((RegWrite_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&(rd_id_ex_mem_out==rs2_id_id_ex_out)))) 
         begin    forwardB<=2'b01; end
   //forwardB =00,数据源于ID/EX,ALU的第2个源操作数来自于ID/EX流水线寄存器的数据,不需要前递,数据用的就是寄存器的
            else begin   forwardB<=2'b00;  end 


         //load指令ID完，load后面紧跟store且load.rd=store.rs1则需要阻塞,load后面跟其他指令有load.rd=nextinstr.rs1/rs2时也需要阻塞
   stall<=0;
if(((MemRead_id_ex_out==1)&&(Memwrite_if_id_out==1)&&(rd_id_id_ex_out==rs1_id_if_id_out)&&(rd_id_id_ex_out!=0))||((MemRead_id_ex_out==1)&&(Memwrite_if_id_out!=1)&&(rd_id_id_ex_out!=0)&&(rd_id_id_ex_out==rs1_id_if_id_out))||((MemRead_id_ex_out==1)&&(rd_id_id_ex_out!=0)&&(Memwrite_if_id_out!=1)&&(rd_id_id_ex_out==rs2_id_if_id_out)))
begin
   stall<=1;
end
else begin stall<=0;
end
forwardC<=0;
//load后面紧跟store，load.rd=store.rs2，需要把MEM/WB.rd送给MEM,不需要停顿
  if((Memread_mem_wb_out==1)&&(MemWrite_ex_mem_out==1)&&(rd_id_mem_wb_out==rs2_id_ex_mem_out)) begin forwardC<=1;end
   else  begin forwardC<=0; end

// //store前两条指令引起的冒险
// if(rd_id_mem_wb_out==rs1_id_id_ex_out)&&(MemWrite_id_ex_out==1)&&(rd_id_mem_wb_out!=0)//把MEM/WB.rd给ID/EX.rs1
// if(rd_id_ex_mem_out==rs1_id_id_ex_out)||(rd_id_ex_mem_out==rs2_id_id_ex_out)//把EX/MEM的数据给ID/EX

end
endmodule
// always @(*) begin
   //    forwardA<=2'b00;
   // //forwardA =10,数据源于EX/MEM,ALU的第一个源操作数来自于EX/MEM流水线寄存器的数据前递,数据用的是上一个ALU的结果
   // if((RegWrite_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&(rd_id_ex_mem_out==rs1_id_ex_out))   begin   forwardA<=2'b10; end
   // //forwardA =01,数据源于MEM/WB,ALU的第一个源操作数来自于MEM/WB流水线寄存器的数据前递,数据用的是数据存储器的或者是更早的ALU计算结果
   //    else if((RegWrite_mem_wb_out)&&(rd_id_mem_wb_out!=0)&&(rd_id_mem_wb_out==rs1_id_ex_out)&&(!((RegWrite_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&(rd_id_ex_mem_out==rs1_id_ex_out)))) 
   //       begin    forwardA<=2'b01; end
   // //forwardA =00,数据源于ID/EX,ALU的第一个源操作数来自于ID/EX流水线寄存器的数据,不需要前递,数据用的就是寄存器的 
   //    else begin   forwardA<=2'b00;  end 
     
   //       forwardB<=2'b00;
   // //forwardB =10,数据源于EX/MEM,ALU的第2个源操作数来自于EX/MEM流水线寄存器的数据前递,数据用的是上一个ALU的结果
   // if((RegWrite_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&(rd_id_ex_mem_out==rs2_id_ex_out))   begin   forwardB<=2'b10; end
   // //forwardB =01,数据源于MEM/WB,ALU的第2个源操作数来自于MEM/WB流水线寄存器的数据前递,数据用的是数据存储器的或者是更早的ALU计算结果  
   //    else if((RegWrite_mem_wb_out)&&(rd_id_mem_wb_out!=0)&&(rd_id_mem_wb_out==rs2_id_ex_out)&&(!((RegWrite_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&(rd_id_ex_mem_out==rs2_id_ex_out)))) 
   //       begin    forwardB<=2'b01; end
   // //forwardB =00,数据源于ID/EX,ALU的第2个源操作数来自于ID/EX流水线寄存器的数据,不需要前递,数据用的就是寄存器的
   //          else begin   forwardB<=2'b00;  end 
     
   
   // forwardC=2'b00;
   // //forwardC=01,数据源于MEM/WB,写入数据存储器的数据来自于MEM/WB流水线寄存器的数据前递,load后面紧跟store指令需要前递	
   //   // 如果是load后跟着store指令，并且load指令的rd与store指令的rs2相同而与rs1不同，则不需要停顿，只需要将MEM/WB 寄存器的数据前递到EX/MEM阶段
   // if((Memread_mem_wb_out==1)&&(MemWrite_ex_mem_out==1)&&(rd_id_mem_wb_out==rs2_ex_mem_out)) begin forwardC=2'b01;end
   //     // 如果是load后跟着store指令，并且load指令的rd与store指令的rs1相同，则需要停顿，还要将MEM/WB 寄存器的数据前递到ID/EX阶段
   //    else if  ((Memread_mem_wb_out==1)&&(MemWrite_ex_mem_out==1)&&(rd_id_mem_wb_out==rs1_ex_mem_out)) begin  stall=1;forwardA =01; end
   //  else  if  ((MemWrite_ex_mem_out==1)&&(rd_id_mem_wb_out==rs2_ex_mem_out)&&(rd_id_mem_wb_out!=0))begin  forwardC=2'b10;   end  //10时store指令与上一个指令发生数据冒险
   // else begin  forwardC=2'b00 ;end
   // //forwardC=00,数据源于EX/MEM，不用前递
   
   
   //    forwardD=0;//forwardD为1时store与上上条指令发生数据冒险，把上上条指令的WB.rd传给现在在EX/MEM.rs2的store指令
   //    if((MemWrite_ex_mem_out)&&(rd_id_wb_out!=0)&&(rd_id_wb_out==rs2_ex_mem_out)) begin
   //       forwardD=1;
   //    end
   //    else forwardD=0;
   
   
   //    if((Memread_ex_mem_out)&&(rd_id_ex_mem_out!=0)&&((rd_id_ex_mem_out==rs1_id_ex_out)||(rd_id_ex_mem_out==rs2_id_ex_out)))//load后面不是store而是其他指令发生冒险
   //    begin   stall<=1;  end//stall为1时表示阻塞一个周期，我们在load的EX完成后检测到load和后面指令发生冒险，此时我们把ID_EX信号清空,同时不改变pc和IF_ID阶段的值即可实现阻塞
   //       else begin stall<=0;end
   
   //          // forwardD=0;
   // //store要存入内存的数据在上一个指令执行完才能得到会发生冲突，要把MEM/WB的数据前递给EX/MEM
   //    // if((MemWrite_ex_mem_out==1)&&(rd_id_mem_wb_out==rs2_ex_mem_out)&&(rd_id_mem_wb_out!=0))begin  forwardD=1;   end
   //    //    else begin
   //    //       forwardD=0;
   //       end