`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:51:45 03/01/2017 
// Design Name: 
// Module Name:    MUX2T1_64 
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
module MUX2T1_64(input [63:0] a,
					 input [63:0] b,
					 input sel,
					 output [63:0] o
);
    assign o =sel?b:a;
endmodule
