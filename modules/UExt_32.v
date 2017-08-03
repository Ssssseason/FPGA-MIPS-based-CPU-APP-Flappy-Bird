`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:54 05/26/2017 
// Design Name: 
// Module Name:    UExt_32 
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
module UExt_32( 	input[15:0]imm_16,
						output[31:0]UImm_32
    );
	assign UImm_32 = {{16'b0}, imm_16[15:0]};

endmodule
