`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:40:40 05/06/2017 
// Design Name: 
// Module Name:    MCPU 
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
module MCPU(	input INT, clk, reset, MIO_ready,
					input [31:0] Data_in,
					output mem_w, CPU_MIO,
					output [31:0] PC_out, inst_out, Data_out, Addr_out,
					output [4:0] state
    );

wire MemRead, MemWrite, IorD, IRWrite, RegWrite, PCWrite, PCWriteCond, Branch, overflow, zero;
wire [1:0] RegDst, MemtoReg, ALUSrcA, PCSource;
wire [2:0] ALU_operation, ALUSrcB;

MCtrl Contorller	(.clk(clk), .reset(reset), .zero(zero), .overflow(overflow), .MIO_ready(MIO_ready), 
						.Inst_in(inst_out), .MemRead(MemRead), .MemWrite(MemWrite), .CPU_MIO(CPU_MIO), .IorD(IorD), 
						.IRWrite(IRWrite), .RegWrite(RegWrite), .ALUSrcA(ALUSrcA), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), 
						.Branch(Branch), .RegDst(RegDst), .MemtoReg(MemtoReg), .ALUSrcB(ALUSrcB), .PCSource(PCSource), 
						.ALU_operation(ALU_operation), .state_out(state));
						
MDPath DataPath	(.clk(clk), .reset(reset), .MIO_ready(MIO_ready), .IorD(IorD), .IRWrite(IRWrite),
						.RegWrite(RegWrite), .ALUSrcA(ALUSrcA), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), 
						.Branch(Branch), .RegDst(RegDst), .MemtoReg(MemtoReg), .ALUSrcB(ALUSrcB), .PCSource(PCSource), 
						.ALU_operation(ALU_operation), .data2CPU(Data_in), .zero(zero), .overflow(overflow),
						.PC_Current(PC_out), .Inst(inst_out), .data_out(Data_out), .M_addr(Addr_out));

assign mem_w = MemWrite & (~MemRead);

endmodule
