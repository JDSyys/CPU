`timescale 1ns / 1ps
`include "ctrl_encode_def.v"

module WB(
input clk,
input rstn,
input [31:0]ALU_result_wb_in,
input [31:0]Data_read_wb_in,//load时写入寄存器的值
input [4:0] rd_id_wb_in,  //写回的寄存器  
input  RegWrite_wb_in, // control signal for register write
input [31:0]pc_wb_in,
input [1:0] WDSel ,
output reg [31:0]WD,
output reg RegWrite_wb_out,
output reg [4:0] rd_id_wb_out
    );
    assign rst=~rstn;



    always @(*)
    begin
      case(WDSel)
        `WDSel_FromALU: WD<=ALU_result_wb_in;
        `WDSel_FromMEM: WD<=Data_read_wb_in;
        `WDSel_FromPC: WD<=pc_wb_in+4;
      endcase

    end
always @(*)
    begin
    RegWrite_wb_out<=RegWrite_wb_in;
    rd_id_wb_out<=rd_id_wb_in;
  end
   // RF rf_wb(.clk(clk),.rst(rst),.RFWr(RegWrite_wb_in),.A3(rd_id_wb_in),.WD(WD));


endmodule
