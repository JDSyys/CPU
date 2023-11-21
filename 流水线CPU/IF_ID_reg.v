`timescale 1ns / 1ps


module IF_ID_reg(
    input clk,
    input rstn,
    input stall,
    input flush,
    input  [31:0] pc_if_id_in,
    input  [31:0] instr_if_id_in,
    input [4:0]rs1_id_if_id_in,
    input [4:0]rs2_id_if_id_in,
    input MemWrite_if_id_in,
    output reg [31:0]pc_if_id_out,
    output reg [31:0]instr_if_id_out,
    output reg[4:0]rs1_id_if_id_out,
    output reg[4:0]rs2_id_if_id_out,
    output reg MemWrite_if_id_out
    );

//    always @(posedge clk or negedge rstn) begin
//     if(!rstn ||flush) begin
//         pc_if_id_out<=32'h00000000;
//         instr_if_id_out<=32'h000000000;
//     end
//     else if(rstn&&(stall==0)) begin
//         pc_if_id_out<=pc_if_id_in;
//         instr_if_id_out<=instr_if_id_in;
//     end
//     else if(rstn&&(stall==1))//阻塞时IF_ID_reg保持不变
//         begin
            
//         end
//    end
    always @(posedge clk or negedge rstn) begin
        if((!rstn) ||(flush)||(stall)) begin
            pc_if_id_out<=32'h00000000;
            instr_if_id_out<=32'h000000000;
            rs1_id_if_id_out<=0;
            rs2_id_if_id_out<=0;
            MemWrite_if_id_out<=0;
        end
        else if(rstn&&(stall==0)) begin
            pc_if_id_out<=pc_if_id_in;
            instr_if_id_out<=instr_if_id_in;
            rs1_id_if_id_out<=rs1_id_if_id_in;
            rs2_id_if_id_out<=rs2_id_if_id_in;
            MemWrite_if_id_out<=MemWrite_if_id_in;
        end
        // else if(rstn&&(stall==1))//阻塞时IF_ID_reg保持不变
        //     begin
                
        //     end
       end
    

endmodule
