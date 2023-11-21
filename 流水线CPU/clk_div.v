`timescale 1ns / 1ps
module clk_div(input clk,
					input rst,
					input SW2,
					output reg[31:0]clkdiv,
					output Clk_CPU,
					output Clk_all
					);
					
// Clock divider-时锟接凤拷频锟斤拷


	always @ (posedge clk or posedge rst) begin 
		if (rst) clkdiv <= 0; else clkdiv <= clkdiv + 1'b1; end
		
	assign Clk_CPU=(SW2)? clkdiv[24] : clkdiv[4];
	assign Clk_all = clkdiv[2];
endmodule
