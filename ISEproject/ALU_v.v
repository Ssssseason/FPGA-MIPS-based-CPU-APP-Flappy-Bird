`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:50:48 03/28/2017
// Design Name:
// Module Name:    ALU_v
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module alu(input [31:0]A, B,
			input[2:0] ALU_operation,
			output reg [31:0] res,
			output zero, overflow);
	wire [31:0] res_and,res_or,res_add,res_sub,res_nor,res_slt,res_srl,res_xor;
	parameter one = 32'h00000001, zero_0 = 32'h00000000;
	assign res_and= A&B;
	assign res_or= A|B;
	assign {overflow,res_add}=(ALU_operation==010)? (A+B):{1'b0,{A+B}};
	assign {overflow,res_sub}=(ALU_operation==110)? (A-B):{1'b0,{A-B}};
	assign res_srl=A>>B[10:6];
	assign res_xor=A^B;
	assign res_slt=(A < B) ? one : zero_0;

	always@ * begin
		case (ALU_operation)
			3'b000: res=res_and;
			3'b001: res=res_or;
			3'b010: res=res_add;
			3'b110: res=res_sub;
			3'b100: res=~(A|B);
			3'b111: res=res_slt;
			3'b101: res=res_srl;
			3'b011: res=res_xor;
			default: res=32'hx;
		endcase
	end
	assign zero = (res==0)? 1'b1: 1'b0;
endmodule
