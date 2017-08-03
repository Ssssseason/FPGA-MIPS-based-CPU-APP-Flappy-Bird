`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:29 06/03/2017 
// Design Name: 
// Module Name:    vga_data 
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
module GPU( 		input clk,
						input [31:0]location, //CPU输出相关物体坐标
						input [8:0] row, //VGA当前扫描点坐标
						input [9:0] col,
						output reg [11:0] data_out,
						
						input signal,
						input start,
						output over,
						
						input [11:0] dog_data,
						output reg [10:0] dog_addr,
						input [11:0] cat_data,
						output reg [10:0] cat_addr
    );

//640x480
wire [8:0] cat_y;
wire [8:0] dog_y;
assign cat_y = location[17:9];
assign dog_y = location[8:0];
parameter cat_x = 10'd80, dog_x = 10'd400;

assign over = (cat_y > 480-20 || cat_y < 20 || dog_y > 480-20 || dog_y < 20);

always @(posedge clk) begin
	if(start)begin
		data_out = 12'hf00; //blue
	end
	else if(over) begin
		data_out = 12'h0f0; //green
	end
	else begin
		if(row > cat_y-20 && row < cat_y+20 && col > cat_x-20 && col < cat_x+20) begin
			cat_addr = 40*(row-cat_y+20) + col-cat_x+20;
			data_out = cat_data;
		end
		else if(row > dog_y-20 && row < dog_y+20 && col > dog_x-20 && col < dog_x+20) begin
			dog_addr = 40*(row-dog_y+20) + col-dog_x+20;
			data_out = dog_data;
		end
		else begin
			data_out = 12'h00f; // red
		end
	end
end

endmodule
