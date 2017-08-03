`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:06 05/08/2017 
// Design Name: 
// Module Name:    MUX4T1_5 
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
module MUX4T1_5(	 input [1:0]s,
						 input [4:0]I0,
						 input [4:0]I1,
						 input [4:0]I2,
						 input [4:0]I3,						
						 output reg[4:0]o
						 );

		always@*				//5位4选一,I0、I1、I2、I3对应选择通道0、1、2、3
			case(s)
			2'b00: o <= I0;
			2'b01: o <= I1;
			2'b10: o <= I2;
			2'b11: o <= I3;
			endcase
			
endmodule