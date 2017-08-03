`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:22:49 03/14/2017 
// Design Name: 
// Module Name:    Display 
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
module Display(input clk,
			   input rst,
			   input Start,
			   input Text,
			   input flash,
			   input [31:0]Hexs,
			   input [7:0]point,
			   input [7:0]LES,
			   output segclk,
			   output segsout,
			   output SEGEN,
			   output segclrn
);
	wire [63:0]a;
	wire [63:0]b;
	wire [63:0]SEGMENT;
	HexTo8SEG SM1(.flash(flash),
				  .Hexs(Hexs[31:0]),
				  .points(point[7:0]),
				  .LES(LES[7:0]),
				  .SEG_TXT(b[63:0]));
	SSeg_map SM3(.Disp_num({2{Hexs[31:0]}}),
				 .Seg_map(a[63:0]));
	MUX2T1_64 SM2(.a(a[63:0]),.b(b[63:0]),.sel(Text),.o(SEGMENT[63:0]));
	
	P2S #(.DATA_BITS(64), .DATA_COUNT_BITS(6), .DIR(1))
		M2(.clk(clk),
		   .rst(rst),
		   .Start(Start),
		   .PData(SEGMENT[63:0]),
		   .sclk(segclk),
		   .sout(segsout),
		   .EN(SEGEN),
		   .sclrn(segclrn));
endmodule
