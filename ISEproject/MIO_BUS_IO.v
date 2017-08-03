`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:14 06/30/2012 
// Design Name: 
// Module Name:    MIO_BUS 
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
module MIO_BUS(input clk,
					input rst,
					input[3:0]BTN,
					input[15:0]SW,
					input mem_w,
					input[31:0]Cpu_data2bus,				//data from CPU
					input[31:0]addr_bus,
					input[31:0]ram_data_out,
					input[15:0]led_out,
					input[31:0]counter_out,
					input counter0_out,
					input counter1_out,
					input counter2_out,
					
					output reg[31:0]Cpu_data4bus,				//write to CPU
					output reg[31:0]ram_data_in,				//from CPU write to Memory
					output reg[12:0]ram_addr,					//Memory Address signals
					output reg data_ram_we,
					output reg GPIOf0000000_we,				//PIO写/SW读
					output reg GPIOe0000000_we,				//七段写
					output reg counter_we,						//counter写送常数
					output reg[31:0]Peripheral_in,
					
					input [9:0] ps2kb_key,
					output reg vram_we,
					output reg [11:0] vram_data,
					output reg [17:0] vram_addr,
					
					input [11:0] picbird_data,
					output reg [8:0] picbird_addr,
					
					input [11:0] picwall_data,
					output reg [13:0] picwall_addr,
					
					input [11:0] picstart_data,
					output reg [16:0] picstart_addr
					);	

	reg data_ram_rd, GPIOf0000000_rd, GPIOe0000000_rd, counter_rd, ps2kb_rd, picstart_rd, picbird_rd, picwall_rd;
	wire counter_over; //变量定义

	always@(posedge clk) begin
		data_ram_we = 0; //主存写信号
		data_ram_rd = 0; //主存读信号
		counter_we = 0; //计数器写信号
		counter_rd = 0; //计数器读信号
		GPIOf0000000_we = 0; //设备1：PIO写信号
		GPIOe0000000_we = 0; //计数器：Counter_x写信号
		GPIOf0000000_rd = 0; //设备3、4：SW等读信号
		GPIOe0000000_rd = 0; //设备2：七段显示器写信号
		ram_addr = 13'h0; //内存物理地址：RAM_B地址
		ram_data_in = 32'h0; //内存写数据：RAM_B输入数据
		Peripheral_in=32'h0; //外设总线：CPU输出，外设写入数据
		ps2kb_rd = 0; //keyborad
		picbird_rd = 0;
		picbird_addr = 9'h0;
		picwall_rd = 0;
		picwall_addr = 14'h0;
		picstart_rd = 0;
		picstart_addr = 17'h0;
		vram_we = 0; //vga
		vram_data = 12'h0;
		vram_addr = 18'h0;
		case(addr_bus[31:28])
		4'h0:begin // data_ram (00000000 - 00000ffc, actually lower 4KB RAM)
				data_ram_we = mem_w;
				ram_addr = addr_bus[14:2];
				ram_data_in = Cpu_data2bus;
				data_ram_rd = ~mem_w;
		end
		4'he:begin // 七段显示器 (e0000000 - efffffff, SSeg7_Dev)
				GPIOe0000000_we = mem_w;
				Peripheral_in = Cpu_data2bus;
				GPIOe0000000_rd = ~mem_w;
		end
		4'hf:begin // PIO (f0000000 - ffffffff0, 8 LEDs & counter, f000004-fffffff4)
				if(addr_bus[2])begin    //counter 
					counter_we = mem_w;
					Peripheral_in = Cpu_data2bus; //write Counter Value 
					counter_rd = ~mem_w;
				end
				else begin     //LED
					GPIOf0000000_we = mem_w;
					Peripheral_in = Cpu_data2bus; //write Counter set & Initialization and light LED
					GPIOf0000000_rd = ~mem_w;
				end
		end
		4'hc:begin // vga
				vram_we = mem_w;
				vram_addr = addr_bus[17:0];
				vram_data = Cpu_data2bus[11:0];
		end
		4'hd:begin // keyborad
				ps2kb_rd = ~mem_w;
		end
		4'hb:begin // picstart
				picstart_rd = ~mem_w;
				picstart_addr = addr_bus[16:0];
		end
		4'ha:begin // picwall
				picwall_rd = ~mem_w;
				picwall_addr = addr_bus[13:0];
		end
		4'h9:begin // picbird
				picbird_rd = ~mem_w;
				picbird_addr = addr_bus[8:0];
		end
			
		default:begin;end
		
		endcase
	end
	
always @* begin
	Cpu_data4bus = 32'h0;
		casex({data_ram_rd,GPIOe0000000_rd,counter_rd,GPIOf0000000_rd, ps2kb_rd, picstart_rd, picwall_rd, picbird_rd})
			8'b1xxxxxxx:Cpu_data4bus = ram_data_out; //read from RAM
			8'bx1xxxxxx:Cpu_data4bus = counter_out;  //read from Counter
			8'bxx1xxxxx:Cpu_data4bus = counter_out;  //read from Counter
			8'bxxx1xxxx:Cpu_data4bus = {counter0_out,counter1_out,counter2_out,led_out[12:0],SW}; //read from SW & BTN
			8'bxxxx1xxx:Cpu_data4bus = {{22{1'b0}}, ps2kb_key}; //read from keyborad
			
			8'bxxxxx1xx:Cpu_data4bus = {{20{1'b0}}, picstart_data}; //read from picstart
			8'bxxxxxx1x:Cpu_data4bus = {{20{1'b0}}, picwall_data}; //read from picwall
			8'bxxxxxxx1:Cpu_data4bus = {{20{1'b0}}, picbird_data}; //read from picbird
		endcase
end


endmodule

