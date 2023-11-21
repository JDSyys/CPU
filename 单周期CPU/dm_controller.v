`include "ctrl_encode_def.v"

module dm_controller(mem_w, Addr_in,  dm_ctrl, 
Data_read_from_dm, Data_read,Data_write, Data_write_to_dm, wea_mem);
input mem_w;//一位，是否为写内存信号
input [31:0]Addr_in;// 读取的内存地址
input [2:0]dm_ctrl;//内存操作的类型
input [31:0]Data_read_from_dm;//从内存连到dm上
input [31:0]Data_write;//从总线来的数据
output reg [31:0]Data_read;//给CPU的经过对齐的数据
output reg [31:0]Data_write_to_dm;//写给内存的数据
output reg [3:0]wea_mem;//具体每一位的wea数据
//store写的时候先根据dm_ctrl判断字节还是字，然后把来自cpu的数据Data_write进行相应拓展对齐，把值给Data_write_to_dm，同时改变wea_mem
//load 读的时候也先根据dm_ctrl判断字节还是字，然后把Data_read_from_dm拓展对齐后给Data_read，同时要设置wea_mem

  always @(*) begin
   if (mem_w) begin//store
   case(dm_ctrl)
      //store的时候如果是字，就直接把Data_write给Data_write_to_dm
   `dm_word              : begin Data_write_to_dm[31:0]  = Data_write[31:0]; wea_mem<=4'b1111 ;   end
      //store的时候如果是半字，先根据addr[1]判断是哪个半字，然后在拓展，把拓展后的值给Data_write_to_dm，写wea_mem
   `dm_halfword          :begin
    if(Addr_in[1]==0)  begin Data_write_to_dm[31:0]  ={2 {Data_write[15:0]}}; wea_mem<=4'b0011 ; end
    else if (Addr_in[1]==1) begin Data_write_to_dm[31:0]  ={2{ Data_write[15:0]}}; wea_mem<=4'b1100 ; end 
    end 

   `dm_halfword_unsigned : if(Addr_in[1]==0)  begin Data_write_to_dm[31:0]  ={2 {Data_write[15:0]}}; wea_mem=4'b0011 ; end
                      else if (Addr_in[1]==1) begin Data_write_to_dm[31:0]  ={2 {Data_write[15:0]}};  wea_mem=4'b1100 ; end 
    
      //store的时候如果是字节，先根据Addr_in[1:0]判断是哪个字节，然后在拓展，把拓展后的值给Data_write_to_dm，写wea_mem
   `dm_byte              :if(Addr_in[1:0]==2'b00) begin Data_write_to_dm[31:0]  ={4{ Data_write[7:0]}} ; wea_mem=4'b0001  ; end  
                              else if (Addr_in[1:0]==2'b01) begin  Data_write_to_dm[31:0]  ={4{ Data_write[7:0]}} ; wea_mem=4'b0010; end   
                                else if (Addr_in[1:0]==2'b10) begin  Data_write_to_dm[31:0]  ={4{ Data_write[7:0]}} ; wea_mem=4'b0100;  end    
                                  else if (Addr_in[1:0]==2'b11)begin  Data_write_to_dm[31:0]  ={4{ Data_write[7:0]}} ;  wea_mem=4'b1000;  end   
   `dm_byte_unsigned     :    if(Addr_in[1:0]==2'b00)   begin   Data_write_to_dm[31:0]  ={4{ Data_write[7:0]}} ;            wea_mem=4'b0001  ; end  
                                    else if (Addr_in[1:0]==2'b01) begin   Data_write_to_dm[31:0]  ={4{ Data_write[7:0]}} ;  wea_mem=4'b0010; end   
                                      else if (Addr_in[1:0]==2'b10) begin  Data_write_to_dm[31:0]  ={4{ Data_write[7:0]}} ;  wea_mem=4'b0100;  end    
                                        else if (Addr_in[1:0]==2'b11)begin   Data_write_to_dm[31:0]  ={4{ Data_write[7:0]}} ;  wea_mem=4'b1000;  end      
   endcase
   end 
    else  wea_mem=4'b0000; end

  always @(*) begin  
 
  
     
    case(dm_ctrl)
     //load的时候如果是字，就直接把内存的数据Data_read_from_dm给cpu需要的经过对齐的数据Data_read，同时设置wea_mem
   `dm_word              : Data_read=Data_read_from_dm;
     //load的时候如果是半字，就把内存的数据Data_read_from_dm根据add[1]给cpu需要的经过对齐的数据Data_read，同时设置wea_mem
   `dm_halfword          : if(Addr_in[1]==0)                         Data_read<={{16{(Data_read_from_dm[15])}},Data_read_from_dm[15:0]};
                           else if (Addr_in[1]==1)                   Data_read<={{16{(Data_read_from_dm[31])}},Data_read_from_dm[31:16]};
   `dm_halfword_unsigned : if(Addr_in[1]==0)                         Data_read<={{16{1'b0}},Data_read_from_dm[15:0]};
                             else if (Addr_in[1]==1)                 Data_read<={{16{1'b0}},Data_read_from_dm[31:16]};
     //load的时候如果是字节，就把内存的数据Data_read_from_dm根据add[1：0]给cpu需要的经过对齐的数据Data_read，同时设置wea_mem
   `dm_byte              : if(Addr_in[1:0]==2'b00)                   Data_read<={{24{(Data_read_from_dm[7])}},Data_read_from_dm[7:0]};
                               else if (Addr_in[1:0]==2'b01)         Data_read<={{24{Data_read_from_dm[15]}},Data_read_from_dm[15:8]};
                                 else if (Addr_in[1:0]==2'b10)       Data_read<={{24{Data_read_from_dm[23]}},Data_read_from_dm[23:16]};
                                   else if (Addr_in[1:0]==2'b11)     Data_read<={{24{Data_read_from_dm[31]}},Data_read_from_dm[31:24]};
   `dm_byte_unsigned     :  if(Addr_in[1:0]==2'b00)                        Data_read<={{24{1'b0}},Data_read_from_dm[7:0]};
                                     else if (Addr_in[1:0]==2'b01)         Data_read<={{24{1'b0}},Data_read_from_dm[15:8]};
                                       else if (Addr_in[1:0]==2'b10)       Data_read<={{24{1'b0}},Data_read_from_dm[23:16]};
                                         else if (Addr_in[1:0]==2'b11)     Data_read<={{24{1'b0}},Data_read_from_dm[31:24]}; 
  endcase 
   
    
    end
//load
  
  endmodule
