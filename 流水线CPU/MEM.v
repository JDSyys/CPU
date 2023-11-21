`timescale 1ns / 1ps
 `include "ctrl_encode_def.v"

//输出要写往内存的32位数据
// module MEM(
//     input  clk,
//     input  rstn,
//     input  MemWrite_mem_in,
//     input [2:0] dm_ctrl_ex_mem_in,
//     input [31:0] ALU_result_mem_in, //load|store的内存地址
//     input [31:0]Data_read_from_dm,  //内存把数据给总线，总线再把数据给dmcontrol,load出来的数据
//     input [31:0]data_rs2_mem_in,   //store时要写入内存的数据即寄存器2的值
//     output [31:0]douta_mem_out,     //内存给总线的数据,直接读的32位的数据，load指令读取的数据
//     output reg[31:0]Data_read_mem_out  //从内存读来的经过对齐后的数据,WB阶段写入寄存器
//     );
//     reg [31:0]Data_write_to_dm;//调用RAM_B模块把数据写入内存
//     reg [3:0]wea_mem;
//     always @(posedge clk) begin
//         if (MemWrite_mem_in) begin//store
//         case(dm_ctrl_ex_mem_in)
//            //store的时候如果是字，就直接把Data_write给Data_write_to_dm
//         `dm_word              : begin Data_write_to_dm[31:0] <= data_rs2_mem_in[31:0]; wea_mem<=4'b1111 ;   end
//            //store的时候如果是半字，先根据addr[1]判断是哪个半字，然后在拓展，把拓展后的值给Data_write_to_dm，写wea_mem
//         `dm_halfword          :begin
//          if(ALU_result_mem_in[1]==0)  begin Data_write_to_dm[31:0]  <={2 {data_rs2_mem_in[15:0]}}; wea_mem<=4'b0011 ; end
//          else if (ALU_result_mem_in[1]==1) begin Data_write_to_dm[31:0]  <={2{ data_rs2_mem_in[15:0]}}; wea_mem<=4'b1100 ; end 
//          end 
     
//         `dm_halfword_unsigned : if(ALU_result_mem_in[1]==0)  begin Data_write_to_dm[31:0]  <={2 {data_rs2_mem_in[15:0]}}; wea_mem=4'b0011 ; end
//                            else if (ALU_result_mem_in[1]==1) begin Data_write_to_dm[31:0]  <={2 {data_rs2_mem_in[15:0]}};  wea_mem=4'b1100 ; end 
         
//            //store的时候如果是字节，先根据ALU_result_mem_in[1:0]判断是哪个字节，然后在拓展，把拓展后的值给Data_write_to_dm，写wea_mem
//         `dm_byte              :if(ALU_result_mem_in[1:0]==2'b00) begin Data_write_to_dm[31:0]  <={4{ data_rs2_mem_in[7:0]}} ; wea_mem=4'b0001  ; end  
//                                    else if (ALU_result_mem_in[1:0]==2'b01) begin  Data_write_to_dm[31:0]  <={4{ data_rs2_mem_in[7:0]}} ; wea_mem=4'b0010; end   
//                                      else if (ALU_result_mem_in[1:0]==2'b10) begin  Data_write_to_dm[31:0]  <={4{ data_rs2_mem_in[7:0]}} ; wea_mem=4'b0100;  end    
//                                        else if (ALU_result_mem_in[1:0]==2'b11)begin  Data_write_to_dm[31:0]  <={4{ data_rs2_mem_in[7:0]}} ;  wea_mem=4'b1000;  end   
//         `dm_byte_unsigned     :    if(ALU_result_mem_in[1:0]==2'b00)   begin   Data_write_to_dm[31:0]  <={4{ data_rs2_mem_in[7:0]}} ;            wea_mem=4'b0001  ; end  
//                                          else if (ALU_result_mem_in[1:0]==2'b01) begin   Data_write_to_dm[31:0]  <={4{ data_rs2_mem_in[7:0]}} ;  wea_mem=4'b0010; end   
//                                            else if (ALU_result_mem_in[1:0]==2'b10) begin  Data_write_to_dm[31:0] <={4{ data_rs2_mem_in[7:0]}} ;  wea_mem=4'b0100;  end    
//                                              else if (ALU_result_mem_in[1:0]==2'b11)begin   Data_write_to_dm[31:0] <={4{ data_rs2_mem_in[7:0]}} ;  wea_mem=4'b1000;  end      
//         endcase
//         end 
//          else  wea_mem=4'b0000; end
     
//        always @(negedge clk) begin    
//          case(dm_ctrl_ex_mem_in)//load
//           //load的时候如果是字，就直接把内存的数据Data_read_from_dm给cpu需要的经过对齐的数据Data_read，同时设置wea_mem
//         `dm_word              : Data_read_mem_out=Data_read_from_dm;
//           //load的时候如果是半字，就把内存的数据Data_read_from_dm根据add[1]给cpu需要的经过对齐的数据Data_read，同时设置wea_mem
//         `dm_halfword          : if(ALU_result_mem_in[1]==0)                         Data_read_mem_out<={{16{(Data_read_from_dm[15])}},Data_read_from_dm[15:0]};
//                                 else if (ALU_result_mem_in[1]==1)                   Data_read_mem_out<={{16{(Data_read_from_dm[31])}},Data_read_from_dm[31:16]};
//         `dm_halfword_unsigned : if(ALU_result_mem_in[1]==0)                         Data_read_mem_out<={{16{1'b0}},Data_read_from_dm[15:0]};
//                                   else if (ALU_result_mem_in[1]==1)                 Data_read_mem_out<={{16{1'b0}},Data_read_from_dm[31:16]};
//           //load的时候如果是字节，就把内存的数据Data_read_from_dm根据add[1：0]给cpu需要的经过对齐的数据Data_read，同时设置wea_mem
//         `dm_byte              : if(ALU_result_mem_in[1:0]==2'b00)                   Data_read_mem_out<={{24{(Data_read_from_dm[7])}},Data_read_from_dm[7:0]};
//                                     else if (ALU_result_mem_in[1:0]==2'b01)         Data_read_mem_out<={{24{Data_read_from_dm[15]}},Data_read_from_dm[15:8]};
//                                       else if (ALU_result_mem_in[1:0]==2'b10)       Data_read_mem_out<={{24{Data_read_from_dm[23]}},Data_read_from_dm[23:16]};
//                                         else if (ALU_result_mem_in[1:0]==2'b11)     Data_read_mem_out<={{24{Data_read_from_dm[31]}},Data_read_from_dm[31:24]};
//         `dm_byte_unsigned     :  if(ALU_result_mem_in[1:0]==2'b00)                        Data_read_mem_out<={{24{1'b0}},Data_read_from_dm[7:0]};
//                                           else if (ALU_result_mem_in[1:0]==2'b01)         Data_read_mem_out<={{24{1'b0}},Data_read_from_dm[15:8]};
//                                             else if (ALU_result_mem_in[1:0]==2'b10)       Data_read_mem_out<={{24{1'b0}},Data_read_from_dm[23:16]};
//                                               else if (ALU_result_mem_in[1:0]==2'b11)     Data_read_mem_out<={{24{1'b0}},Data_read_from_dm[31:24]}; 
//        endcase     
//          end
   
// endmodule
module MEM(
    input  clk,
    input  rstn,
    input [31:0]data_in, //从内存读来的经过对齐后的数据,WB阶段写入寄存器,load指令
    input  MemWrite_mem_in,
    input [2:0] dm_ctrl_mem_in,
    input [31:0] ALU_result_mem_in, //load|store的内存地址
   // input [31:0]Data_read_from_dm,  //内存把数据给总线，总线再把数据给dmcontrol,load出来的数据
    input [31:0]data_rs2_mem_in,   //store时要写入内存的数据即寄存器2的值
    input forwardC,
    input [31:0]Data_read_mem_wb_out,
    input [31:0]ALU_result_mem_wb_out,
    input  [31:0]rs1_data_mem_in,
    input [31:0]B_mem_in,
    input [4:0]ALUOp_mem_in,
    input [31:0]instr_mem_in,

    output  [2:0]dm_ctrl_mem_out,
    output  [31:0]ALU_result_mem_out,     //store写入内存的地址
    output  [31:0]douta_mem_out,     //store写入内存的数据
    output [31:0]Data_read_mem_out , //load从内存读来的经过对齐后的数据,WB阶段写入寄存器
    output  MemWrite_mem_out,//内存写信号
    output [2:0]NPCOp_mem_out
    );
   assign douta_mem_out=(forwardC)?Data_read_mem_wb_out:data_rs2_mem_in;
   assign Data_read_mem_out=data_in;
   assign  MemWrite_mem_out=MemWrite_mem_in;
   assign  ALU_result_mem_out=ALU_result_mem_in;
   assign  dm_ctrl_mem_out=dm_ctrl_mem_in;
  
    // if(forwardC==2'b01)begin
    //   douta_mem_out<=Data_read_mem_wb_out;
    //   Data_read_mem_out<=data_in;
    //   MemWrite_mem_out<=MemWrite_mem_in;
    //   ALU_result_mem_out<=ALU_result_mem_in;
    //   dm_ctrl_mem_out<=dm_ctrl_mem_in;
    // end
    // else if(forwardC==2'b00)begin
    //   douta_mem_out<=data_rs2_mem_in;
    //   Data_read_mem_out<=data_in;
    //   MemWrite_mem_out<=MemWrite_mem_in;
    //   ALU_result_mem_out<=ALU_result_mem_in;
    //   dm_ctrl_mem_out<=dm_ctrl_mem_in; end
    //   else if(forwardC==2'b10)begin
    //   douta_mem_out<=ALU_result_mem_wb_out;
    //   Data_read_mem_out<=data_in;
    //   MemWrite_mem_out<=MemWrite_mem_in;
    //   ALU_result_mem_out<=ALU_result_mem_in;
    //   dm_ctrl_mem_out<=dm_ctrl_mem_in;
    //   end
       alu mem_zero(.A(rs1_data_mem_in), .B(B_mem_in), .ALUOp(ALUOp_mem_in),.Zero(Zero_mem_out));
       wire [6:0]  Op;          // opcode
wire [6:0]  Funct7;       // funct7
wire [2:0]  Funct3;       // funct3
    assign Op = instr_mem_in[6:0];  // instruction
assign Funct7 = instr_mem_in[31:25]; // funct7
assign Funct3 = instr_mem_in[14:12]; // funct3

ctrl U_ctrl(
      .Op(Op), .Funct7(Funct7), .Funct3(Funct3), 
      .Zero(Zero_mem_out), .NPCOp(NPCOp_mem_out)
    );//产生控制信号
endmodule