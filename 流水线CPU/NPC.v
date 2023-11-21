`include "ctrl_encode_def.v"

module NPC(PC, NPCOp, IMM, NPC,aluout, stall,flush,NEXTPC);  // next pc module
    
   input  [31:0] PC;        // pc
   input  [2:0]  NPCOp;     // next pc operation
   input  [31:0] IMM;       // immediate
	input [31:0] aluout;
   output reg [31:0] NPC;   // next pc
   input stall;
   input [31:0]NEXTPC;
   output reg flush;
   reg [31:0] PCPLUS4;
always @(*) begin
   if(stall==0)begin
      PCPLUS4 = PC + 4; // pc + 4
  end
  else PCPLUS4 = PC;
end
   
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4: begin NPC = PCPLUS4; flush <= 0; end 
          `NPC_BRANCH:begin  NPC = NEXTPC+IMM; flush <= 1; end
          `NPC_JUMP:  begin NPC = NEXTPC+IMM;flush <= 1; end
		    `NPC_JALR:	 begin NPC = aluout;flush <= 1; end
          default:   begin  NPC = PCPLUS4;flush <= 0; end
      endcase
   end   // end always
   
endmodule
