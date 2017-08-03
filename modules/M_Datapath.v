`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:19 05/08/2017 
// Design Name: 
// Module Name:    M_Datapath 
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
module MDPath		(input clk,
					   input reset,
					  
					   input MIO_ready,		//=1
					   input IorD,
					   input IRWrite,
					   input[1:0] RegDst,
					   input RegWrite,
					   input[1:0]MemtoReg,
					   input[1:0]ALUSrcA,
					   input[2:0]ALUSrcB,
					   input[1:0]PCSource,
					   input PCWrite,
					   input PCWriteCond,	
					   input Branch,
					   input[2:0]ALU_operation,
					  
					   output[31:0]PC_Current,
					   input[31:0]data2CPU,
					   output[31:0]Inst,
					   output[31:0]data_out,
					   output[31:0]M_addr,
					  
					   output zero,
					   output overflow
					  );	
wire CE, N0, V5;
wire [4:0] Wt_addr;
wire [31:0] MDR, ALU_Out, Wt_data, rdata_A, rdata_B, offset;
wire [31:0] Imm_32, UImm_32, data_A, data_B, res, D;

VCC  v_13 (.P(V5));
GND  g_14 (.G(N0));

assign CE = (((zero == Branch) & PCWriteCond) | PCWrite) & MIO_ready;
assign data_out = rdata_B;

REG32 PC			(.clk(clk), .rst(reset), .CE(CE), .D(D), .Q(PC_Current));

REG32 IReg		(.clk(clk), .rst(reset), .CE(IRWrite), .D(data2CPU), .Q(Inst));
REG32 MDReg		(.clk(clk), .rst(N0), .CE(V5), .D(data2CPU), .Q(MDR));

MUX4T1_5 M1		(.s(RegDst), .I0(Inst[20:16]), .I1(Inst[15:11]), .I2({5{V5}}), .I3(), .o(Wt_addr));
MUX4T1_32 M2	(.s(MemtoReg), .I0(ALU_Out), .I1(MDR), .I2({Inst[15:0],{16{N0}}}), .I3(PC_Current), .o(Wt_data));

Regs U2			(.clk(clk), .rst(reset), .R_addr_A(Inst[25:21]), .R_addr_B(Inst[20:16]), 
					.Wt_addr(Wt_addr), .Wt_data(Wt_data), .L_S(RegWrite), .rdata_A(rdata_A), 
					.rdata_B(rdata_B));

Ext_32 ext		(.imm_16(Inst[15:0]), .Imm_32(Imm_32));
UExt_32 uext	(.imm_16(Inst[15:0]), .UImm_32(UImm_32));
assign offset = Imm_32[29:0] << 2;

MUX4T1_32 M3	(.s(ALUSrcA), .I0(PC_Current), .I1(rdata_A), .I2(rdata_B), .I3(), .o(data_A));
MUX8T1_32 M4	(.s(ALUSrcB), .I0(rdata_B), .I1({{29{N0}},V5,N0,N0}), .I2(Imm_32), .I3(UImm_32), 
					.I4(offset), .o(data_B));
alu M7			(.A(data_A), .B(data_B), .ALU_operation(ALU_operation), .zero(zero), 
					.res(res), .overflow(overflow));
REG32 ALUout	(.clk(clk), .rst(N0), .CE(V5), .D(res), .Q(ALU_Out));
MUX2T1_32 M5	(.s(IorD), .I0(PC_Current), .I1(ALU_Out), .o(M_addr));
MUX4T1_32 M6	(.s(PCSource), .I0(res), .I1(ALU_Out), .I2({PC_Current[31:28],Inst[25:0],N0,N0}), .I3(rdata_A), .o(D));

endmodule
