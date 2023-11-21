`timescale 1ns / 1ps



module MEM_WB_reg(
input clk,
input rstn,
input [31:0]Data_read_mem_wb_in,//写入寄存器的值
input [4:0] rd_id_mem_wb_in,  //写回的寄存器  
input [4:0]rs1_mem_wb_in,
input [4:0]rs2_mem_wb_in,
input  RegWrite_mem_wb_in, // control signal for register write
input [1:0] WDSel ,  // (register) write data selection
input [31:0] ALU_result_mem_wb_in,
input [31:0]pc_mem_wb_in,
input Memread_mem_wb_in,
output reg [31:0]Data_read_mem_wb_out,//写入寄存器的值
output reg [4:0] rd_id_mem_wb_out,  //写回的寄存器
output reg [4:0]rs1_mem_wb_out,
output reg [4:0]rs2_mem_wb_out, 
output reg  RegWrite_mem_wb_out,
output reg [1:0] WDSel_mem_wb_out , // (register) write data selection
output reg [31:0] ALU_result_mem_wb_out,
output reg [31:0]pc_mem_wb_out,
output reg  Memread_mem_wb_out
    );
// always @(posedge clk or negedge rstn) begin
//     if(!rstn)
//     begin
//         Data_read_mem_wb_out<=32'h00000000;
//         rd_id_mem_wb_out<=0;
//         RegWrite_mem_wb_out<=0;
//         WDSel_mem_wb_out<=2'b00;
//         ALU_result_mem_wb_out<=32'h00000000;
//         pc_mem_wb_out<=32'h00000000;
//         rs1_mem_wb_out<=5'b0;
//         rs2_mem_wb_out<=5'b0;
//         Memread_mem_wb_out<=0;
//     end
//     else begin
//         Data_read_mem_wb_out<=Data_read_mem_wb_in;
//         rd_id_mem_wb_out<=rd_id_mem_wb_in;
//         RegWrite_mem_wb_out<=RegWrite_mem_wb_in;
//         WDSel_mem_wb_out<=WDSel;
//         ALU_result_mem_wb_out<=ALU_result_mem_wb_in;
//         pc_mem_wb_out<=pc_mem_wb_in;
//         rs1_mem_wb_out<=rs1_mem_wb_in;
//         rs2_mem_wb_out<=rs2_mem_wb_in;
//         Memread_mem_wb_out<=Memread_mem_wb_in;
//     end
//  end
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
        begin
            Data_read_mem_wb_out<=32'h00000000;
            rd_id_mem_wb_out<=0;
            RegWrite_mem_wb_out<=0;
            WDSel_mem_wb_out<=2'b00;
            ALU_result_mem_wb_out<=32'h00000000;
            pc_mem_wb_out<=32'h00000000;
            rs1_mem_wb_out<=5'b0;
            rs2_mem_wb_out<=5'b0;
            Memread_mem_wb_out<=0;
        end
        else begin
            Data_read_mem_wb_out<=Data_read_mem_wb_in;
            rd_id_mem_wb_out<=rd_id_mem_wb_in;
            RegWrite_mem_wb_out<=RegWrite_mem_wb_in;
            WDSel_mem_wb_out<=WDSel;
            ALU_result_mem_wb_out<=ALU_result_mem_wb_in;
            pc_mem_wb_out<=pc_mem_wb_in;
            rs1_mem_wb_out<=rs1_mem_wb_in;
            rs2_mem_wb_out<=rs2_mem_wb_in;
            Memread_mem_wb_out<=Memread_mem_wb_in;
        end
    end

endmodule
