`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:48 05/18/2017 
// Design Name: 
// Module Name:    Top_OExp12_MSOC 
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
module Top_OExp12_MSOC(		input clk_100mhz,
									input RSTN,
									input [3:0] K_COL,
									output [4:0] K_ROW,
									input [15:0] SW,
									output LEDCLK, LEDDT, LEDEN, LEDCLR,
									output SEGCLK, SEGDT, SEGEN, SEGCLR,
									output Buzzer,
									output [7:0] SEGMENT,
									output [3:0] AN,
									output [7:0] LED,
									output CR, RDY, readn,
									
									input PS2_clk,
									input PS2_data,
									output [3:0]Blue, Green, Red,
									output HSYNC,
									output VSYNC
    );

wire rst, Clk_CPU, IO_clk, GPIOF0;
wire mem_w, V5, N0;
wire counter0_out, counter1_out, counter2_out, counter_we, GPIOe0000000_we, data_ram_we, vram_we;
wire [1:0] counter_ch;
wire [3:0] Pulse, BTN_OK;
wire [4:0] Key_out, State;
wire [7:0] blink, LE_out, point_out;
wire [8:0] row, picbird_addr;
wire [9:0] PS2_key, col;
wire [12:0] ram_addr;
wire [10:0] dog_addr, cat_addr;
wire [11:0] vga_data, dog_data, cat_data, vram_data_in, vram_data_out, picbird_data, picwall_data, picstart_data;
wire [13:0] picwall_addr;
wire [15:0] SW_OK, LED_out;
wire [16:0] picstart_addr;
wire [17:0] vram_r_addr, vram_w_addr;
wire [31:0] Div, Ai, Bi, Disp_num, inst, CPU2IO, PC, Addr_out, Data_in, Data_out, Counter_out, ram_data_in, ram_data_out;
wire [31:0] location;

SAnti_jitter U9	(.RSTN(RSTN), .clk(clk_100mhz), .Key_y(K_COL), .Key_x(K_ROW), .SW(SW), .readn(readn),
						.CR(CR), .Key_out(Key_out), .Key_ready(RDY), .pulse_out(Pulse), .BTN_OK(BTN_OK), 
						.SW_OK(SW_OK), .rst(rst));

clk_div U8			(.clk(clk_100mhz), .rst(rst), .SW2(SW_OK[2]), .clkdiv(Div), .Clk_CPU(Clk_CPU));

VCC  v_13 (.P(V5));
GND  g_14 (.G(N0));
assign Buzzer = V5;
assign IO_clk = ~Clk_CPU;

SEnter_2_32 M4		(.clk(clk_100mhz), .Din(Key_out), .D_ready(RDY), .BTN(BTN_OK[2:0]), .Ctrl({SW_OK[7:5],SW_OK[15],SW_OK[0]}),
						.readn(readn), .Ai(Ai), .Bi(Bi), .blink(blink));
						
Display	M5			(.clk(clk_100mhz), .rst(rst), .Start(Div[20]), .Text(SW_OK[0]), .flash(Div[25]), .Hexs(Disp_num), 
						.point(point_out), .LES(LE_out), .segclk(SEGCLK), .segsout(SEGDT), .SEGEN(SEGEN), .segclrn(SEGCLR));

MCPU U1				(.clk(Clk_CPU), .reset(rst), .inst_out(inst), .INT(counter0_out), .PC_out(PC), .mem_w(mem_w), 
						.Addr_out(Addr_out), .Data_in(Data_in), .Data_out(Data_out), .state(State), .MIO_ready(V5));

RAM_B U3				(.addra(ram_addr), .wea(data_ram_we), .dina(ram_data_in), .clka(clk_100mhz), .douta(ram_data_out));

Counter U10			(.clk(IO_clk), .rst(rst), .clk0(Div[6]), .clk1(Div[9]), .clk2(Div[11]), .counter_we(counter_we), 
						.counter_val(CPU2IO), .counter_ch(counter_ch), .counter0_OUT(counter0_out), .counter1_OUT(counter1_out), 
						.counter2_OUT(counter2_out), .counter_out(Counter_out));
						
Multi_8CH32 U5		(.clk(IO_clk), .rst(rst), .EN(GPIOe0000000_we), .Test(SW_OK[7:5]), .point_in({Div,Div}), .LES({64{1'b0}}), 
						.Data0(CPU2IO), .data1({N0,N0,PC[31:2]}), .data2(inst), .data3(Counter_out), .data4(Addr_out), .data5(Data_out), 
						.data6(Data_in), .data7({{22{N0}},PS2_key}), .Disp_num(Disp_num), .point_out(point_out), .LE_out(LE_out));
						
GPIO U7				(.clk(IO_clk), .rst(rst), .EN(GPIOF0), .Start(Div[20]), .P_Data(CPU2IO), .counter_set(counter_ch), 
						.LED_out(LED_out), .GPIOf0(), .led_clk(LEDCLK), .led_sout(LEDDT), .LED_PEN(LEDEN), .led_clrn(LEDCLR));

//ÀƒŒª∆ﬂ∂Œ¬Îœ‘ æ
Seg7_Dev U61		(.Scan({SW_OK[1],Div[19:18]}), .SW0(SW_OK[0]), .flash(Div[25]), .Hexs(Disp_num), .point(point_out), 
						.LES(LE_out),.SEGMENT(SEGMENT), .AN(AN));

PIO U71				(.clk(IO_clk), .rst(rst), .EN(GPIOF0), .PData_in(CPU2IO), .LED_out(LED));

MIO_BUS U4			(.clk(clk_100mhz), .rst(rst), .BTN(BTN_OK), .SW(SW_OK), .mem_w(mem_w), .addr_bus(Addr_out), 
						.Cpu_data4bus(Data_in), .Cpu_data2bus(Data_out), .ram_data_in(ram_data_in), .data_ram_we(data_ram_we), 
						.ram_addr(ram_addr), .ram_data_out(ram_data_out), .Peripheral_in(CPU2IO), .GPIOe0000000_we(GPIOe0000000_we), 
						.GPIOf0000000_we(GPIOF0), .led_out(LED_out), .counter_out(Counter_out), .counter2_out(counter2_out), 
						.counter1_out(counter1_out), .counter0_out(counter0_out), .counter_we(counter_we), 
						.ps2kb_key(PS2_key), .vram_we(vram_we), .vram_data(vram_data_in), .vram_addr(vram_w_addr),
						.picbird_data(picbird_data), .picbird_addr(picbird_addr),
						.picwall_data(picwall_data), .picwall_addr(picwall_addr),
						.picstart_data(picstart_data), .picstart_addr(picstart_addr)
						);

start512x200 start (.clka(clk_100mhz), .addra(picstart_addr), .douta(picstart_data));
						
wall20x480 wall 	(.a(picwall_addr), .spo(picwall_data));

bird20x20 bird 	(.a(picbird_addr), .spo(picbird_data));

VRAM frame 			(.clka(clk_100mhz), .wea(vram_we), .addra(vram_w_addr), .dina(vram_data_in), .clkb(Div[1]), 
						.addrb(vram_r_addr), .doutb(vram_data_out));

GPU gpu				(.clk(Div[1]), .row(row), .col(col), .vram_addr(vram_r_addr), .vram_data(vram_data_out), .vga_data(vga_data)
						);

VGA vga				(.clk(Div[1]), .rst(rst), .Din(vga_data), .row(row), .col(col), .rdn(), 
						.R(Red), .G(Green), .B(Blue), .HS(HSYNC), .VS(VSYNC));

ps2_ver2 ps2		(.clk(clk_100mhz), .rst(rst), .ps2_clk(PS2_clk), .ps2_data(PS2_data), 
						.data_out(PS2_key), .ready());

endmodule