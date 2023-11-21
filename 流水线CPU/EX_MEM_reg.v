`timescale 1ns / 1ps



module EX_MEM_reg(
    input clk,
    input rstn,
    //input forwardD,
    //input [31:0]WD,
    input flush,
    input [31:0] ALU_result_ex_mem_in,
    input [4:0]  rd_id_ex_mem_in,
    input [4:0]rs1_ex_mem_in,
    input [4:0]rs2_ex_mem_in,
    input  RegWrite_ex_mem_in, // control signal for register write
    input  MemWrite_ex_mem_in, // control signal for memory write
    input [2:0] dm_ctrl_ex_mem_in,
    input [1:0] GPRSel_ex_mem_in,
    input [31:0]data_rs2_ex_mem_in,
    input [1:0] WDSel ,  // (register) write data selection
    input [31:0]pc_ex_mem_in,
    input Memread_ex_mem_in,
    input [2:0]NPCOp_ex_mem_in,
    input [31:0]imm_ex_mem_in,
    input  [31:0]rs1_data_ex_mem_in,
    input [31:0]B_ex_mem_in,
    input [4:0]ALUOp_ex_mem_in,
    input [31:0]instr_ex_mem_in,
    output reg [31:0] ALU_result_ex_mem_out,
    output reg [4:0]  rd_id_ex_mem_out,
    output reg [4:0]rs1_ex_mem_out,
    output reg [4:0]rs2_ex_mem_out,
    output reg  RegWrite_ex_mem_out, // control signal for register write
    output reg  MemWrite_ex_mem_out, // control signal for memory write
    output reg [2:0] dm_ctrl_ex_mem_out,
    output reg [1:0] GPRSel_ex_mem_out,
    output reg [31:0]data_rs2_ex_mem_out,
    output reg [1:0] WDSel_ex_mem_out , // (register) write data selection
    output reg [31:0]pc_ex_mem_out,
    output reg Memread_ex_mem_out,
    output reg [2:0]NPCOp_ex_mem_out,
    output reg [31:0]imm_ex_mem_out,
    output reg[31:0]rs1_data_ex_mem_out,
    output reg[31:0]B_ex_mem_out,
    output reg[4:0]ALUOp_ex_mem_out,
    output reg[31:0]instr_ex_mem_out
    );
// always @(posedge clk or negedge rstn) begin
//     if(!rstn||flush)
//     begin
//         ALU_result_ex_mem_out<=32'h00000000;
//         rd_id_ex_mem_out<=5'b00000;
//         RegWrite_ex_mem_out<=0;
//         MemWrite_ex_mem_out<=0;
//         dm_ctrl_ex_mem_out<=3'b000;
//         GPRSel_ex_mem_out<=2'b00;
//         data_rs2_ex_mem_out<=32'b00000000;
//         WDSel_ex_mem_out<=2'b00;
//         pc_ex_mem_out<=32'b00000000;
//         rs1_ex_mem_out<=5'b0;
//         rs2_ex_mem_out<=5'b0;
//         Memread_ex_mem_out<=0;
//         NPCOp_ex_mem_out<=0;
//         imm_ex_mem_out<=0;
//         rs1_data_ex_mem_out<=0;
//         B_ex_mem_out<=0;
//         ALUOp_ex_mem_out<=0;
//         instr_ex_mem_out<=0;
//     end
//     else
//         begin
//             if(forwardD==0)begin
//             ALU_result_ex_mem_out<=ALU_result_ex_mem_in;
//             rd_id_ex_mem_out<=rd_id_ex_mem_in;
//             RegWrite_ex_mem_out<=RegWrite_ex_mem_in;
//             MemWrite_ex_mem_out<=MemWrite_ex_mem_in;
//             dm_ctrl_ex_mem_out<=dm_ctrl_ex_mem_in;
//             GPRSel_ex_mem_out<=GPRSel_ex_mem_in;   
//             data_rs2_ex_mem_out<=data_rs2_ex_mem_in;
//             WDSel_ex_mem_out<=WDSel;
//             pc_ex_mem_out<=pc_ex_mem_in;
//             rs1_ex_mem_out<=rs1_ex_mem_in;
//             rs2_ex_mem_out<=rs2_ex_mem_in;
//             Memread_ex_mem_out<=Memread_ex_mem_in;
//             NPCOp_ex_mem_out<=NPCOp_ex_mem_in;
//             imm_ex_mem_out<=imm_ex_mem_in;
//             rs1_data_ex_mem_out<=rs1_data_ex_mem_in;
//             B_ex_mem_out<=B_ex_mem_in;
//             ALUOp_ex_mem_out<=ALUOp_ex_mem_in;
//             instr_ex_mem_out<=instr_ex_mem_in;
//             end
//             else if(forwardD==1)
//                 begin
//             ALU_result_ex_mem_out<=ALU_result_ex_mem_in;
//             rd_id_ex_mem_out<=rd_id_ex_mem_in;
//             RegWrite_ex_mem_out<=RegWrite_ex_mem_in;
//             MemWrite_ex_mem_out<=MemWrite_ex_mem_in;
//             dm_ctrl_ex_mem_out<=dm_ctrl_ex_mem_in;
//             GPRSel_ex_mem_out<=GPRSel_ex_mem_in;   
//             data_rs2_ex_mem_out<=WD;
//             WDSel_ex_mem_out<=WDSel;
//             pc_ex_mem_out<=pc_ex_mem_in;
//             rs1_ex_mem_out<=rs1_ex_mem_in;
//             rs2_ex_mem_out<=rs2_ex_mem_in;
//             Memread_ex_mem_out<=Memread_ex_mem_in; 
//             NPCOp_ex_mem_out<=NPCOp_ex_mem_in;
//             imm_ex_mem_out<=imm_ex_mem_in;
//             rs1_data_ex_mem_out<=rs1_data_ex_mem_in;
//             B_ex_mem_out<=B_ex_mem_in;
//             ALUOp_ex_mem_out<=ALUOp_ex_mem_in;
//             instr_ex_mem_out<=instr_ex_mem_in;
//                 end
//         end
// end
    always @(posedge clk or negedge rstn) begin
        if(!rstn||flush)
        begin
            ALU_result_ex_mem_out<=32'h00000000;
            rd_id_ex_mem_out<=5'b00000;
            RegWrite_ex_mem_out<=0;
            MemWrite_ex_mem_out<=0;
            dm_ctrl_ex_mem_out<=3'b000;
            GPRSel_ex_mem_out<=2'b00;
            data_rs2_ex_mem_out<=32'b00000000;
            WDSel_ex_mem_out<=2'b00;
            pc_ex_mem_out<=32'b00000000;
            rs1_ex_mem_out<=5'b0;
            rs2_ex_mem_out<=5'b0;
            Memread_ex_mem_out<=0;
            NPCOp_ex_mem_out<=0;
            imm_ex_mem_out<=0;
            rs1_data_ex_mem_out<=0;
            B_ex_mem_out<=0;
            ALUOp_ex_mem_out<=0;
            instr_ex_mem_out<=0;
        end
        else
            begin
                // if(forwardD==0)begin
                ALU_result_ex_mem_out<=ALU_result_ex_mem_in;
                rd_id_ex_mem_out<=rd_id_ex_mem_in;
                RegWrite_ex_mem_out<=RegWrite_ex_mem_in;
                MemWrite_ex_mem_out<=MemWrite_ex_mem_in;
                dm_ctrl_ex_mem_out<=dm_ctrl_ex_mem_in;
                GPRSel_ex_mem_out<=GPRSel_ex_mem_in;   
                data_rs2_ex_mem_out<=data_rs2_ex_mem_in;
                WDSel_ex_mem_out<=WDSel;
                pc_ex_mem_out<=pc_ex_mem_in;
                rs1_ex_mem_out<=rs1_ex_mem_in;
                rs2_ex_mem_out<=rs2_ex_mem_in;
                Memread_ex_mem_out<=Memread_ex_mem_in;
                NPCOp_ex_mem_out<=NPCOp_ex_mem_in;
                imm_ex_mem_out<=imm_ex_mem_in;
                rs1_data_ex_mem_out<=rs1_data_ex_mem_in;
                B_ex_mem_out<=B_ex_mem_in;
                ALUOp_ex_mem_out<=ALUOp_ex_mem_in;
                instr_ex_mem_out<=instr_ex_mem_in;
                // end
                // else if(forwardD==1)
                //     begin
                // ALU_result_ex_mem_out<=ALU_result_ex_mem_in;
                // rd_id_ex_mem_out<=rd_id_ex_mem_in;
                // RegWrite_ex_mem_out<=RegWrite_ex_mem_in;
                // MemWrite_ex_mem_out<=MemWrite_ex_mem_in;
                // dm_ctrl_ex_mem_out<=dm_ctrl_ex_mem_in;
                // GPRSel_ex_mem_out<=GPRSel_ex_mem_in;   
                // data_rs2_ex_mem_out<=WD;
                // WDSel_ex_mem_out<=WDSel;
                // pc_ex_mem_out<=pc_ex_mem_in;
                // rs1_ex_mem_out<=rs1_ex_mem_in;
                // rs2_ex_mem_out<=rs2_ex_mem_in;
                // Memread_ex_mem_out<=Memread_ex_mem_in; 
                // NPCOp_ex_mem_out<=NPCOp_ex_mem_in;
                // imm_ex_mem_out<=imm_ex_mem_in;
                // rs1_data_ex_mem_out<=rs1_data_ex_mem_in;
                // B_ex_mem_out<=B_ex_mem_in;
                // ALUOp_ex_mem_out<=ALUOp_ex_mem_in;
                // instr_ex_mem_out<=instr_ex_mem_in;
                //     end
            end
    end

endmodule
