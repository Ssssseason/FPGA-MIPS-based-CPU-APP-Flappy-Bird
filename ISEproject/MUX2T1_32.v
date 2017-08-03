`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:13:59 02/28/2017 
// Design Name: 
// Module Name:    MUX2T1_32 
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
module MUX2T1_32(input [31:0] I0,
	input[31:0] I1, 
	input s, 
	output [31:0] o
    );
	assign o=(s==0)?I0:I1;
endmodule
