`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:39 05/09/2017 
// Design Name: 
// Module Name:    M_Ctrl 
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
module   MCtrl(input  clk,
					input  reset,
					input  [31:0] Inst_in,
					input  zero,
					input  overflow,
					input  MIO_ready,
					output reg MemRead,
					output reg MemWrite,
					output reg[2:0]ALU_operation,
					output [4:0]state_out,
					
					output reg CPU_MIO,
					output reg IorD,
					output reg IRWrite,
					output reg [1:0]RegDst,
					output reg RegWrite,
					output reg [1:0]MemtoReg,
					output reg [1:0]ALUSrcA,
					output reg [2:0]ALUSrcB,
					output reg [1:0]PCSource,
					output reg PCWrite,
					output reg PCWriteCond,
					output reg Branch
					);

parameter 	IF = 5'b00000, 		ID = 5'b00001, 		Mem_Exc = 5'b00010,	Mem_RD = 5'b00011,
				LW_WB = 5'b00100, 	Mem_WD = 5'b00101,	R_Exc = 5'b00110, 	R_WB = 5'b00111,
				I_Exc = 5'b01000,		I_WB = 5'b01001,		Lui_WB = 5'b01010,	Beq_Exc= 5'b01011,
				Bne_Exc =5'b01100,	Jal = 5'b01101,		Jr = 5'b01110,			J= 5'b01111, 		
				Jalr = 5'b10000,		Error = 5'b11111;
				
parameter 	AND=3'b000, OR=3'b001, ADD=3'b010, SUB=3'b110, NOR=3'b100, SLT=3'b111,
				XOR=3'b011, SRL=3'b101;
			
reg [4:0] state;
assign state_out = state;

task signalIF;
	begin
		MemRead <= 1'b1;
		MemWrite <= 1'b0;
		ALU_operation <= ADD;
		CPU_MIO <= 1'b1;
		IorD <= 1'b0;
		IRWrite <= 1'b1;
		RegWrite <= 1'b0;
		RegDst <= 2'b00;
		MemtoReg <= 2'b00;
		ALUSrcA <= 2'b00;//pc
		ALUSrcB <= 3'b001;//4
		PCSource <= 2'b00;
		PCWrite <= 1'b1;
		PCWriteCond <= 1'b0;
	end
endtask

task signalID;
	begin
		PCWrite <= 1'b0;
		PCWriteCond <= 1'b0;
		IorD     <= 1'b0;
		MemRead  <= 1'b0;
		MemWrite <= 1'b0;
		IRWrite  <= 1'b0;
		MemtoReg <= 2'b0;
		PCSource <= 2'b0;
		ALUSrcB  <= 3'b100;//offset
		ALUSrcA  <= 2'b00;//pc
		RegWrite <= 1'b0;
		RegDst   <= 2'b00;
		CPU_MIO  <= 1'b0;
		ALU_operation <= ADD;
	end
endtask
	
initial begin
	state <= IF;
	signalIF;
end

always @ (posedge clk or posedge reset)
	if (reset==1) begin state <= IF; signalIF; end
	else
		case (state)
			IF: 	if(MIO_ready) begin state <= ID; signalID; end
					else begin state <= IF; signalIF; end
			ID: 	case (Inst_in[31:26]) 
						//R-type OP
						6'b000000: begin 
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							state <= R_Exc;
							case(Inst_in[5:0]) 
								6'b100000: begin ALU_operation <= ADD; end
								6'b100010: begin ALU_operation <= SUB; end
								6'b100100: begin ALU_operation <= AND; end
								6'b100101: begin ALU_operation <= OR; 	end
								6'b100110: begin ALU_operation <= XOR; end
								6'b100111: begin ALU_operation <= NOR; end
								6'b101010: begin ALU_operation <= SLT; end
								6'b000010: begin ALU_operation <= SRL; ALUSrcA <= 2'b10; ALUSrcB <= 3'b010; end
								6'b001000: begin state <= Jr; PCWrite <= 1'b1; PCSource <= 2'b11; ALUSrcA  <= 2'b01; end 	//Jr
								6'b001001: begin state <= Jalr; PCWrite <= 1'b1; PCSource <= 2'b11; ALUSrcA  <= 2'b01;		//Jalr
												RegWrite <= 1'b1; RegDst <= 2'b01; end
								default: begin state <= IF; signalIF; end 	
							endcase
						end
						//Lw 0x23, SW 0x2b
						6'b100011, 6'b101011: begin state <= Mem_Exc; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010; ALU_operation <= ADD; end
						//I-type OP addi
						6'b001000: begin state <= I_Exc; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010; ALU_operation <= ADD; end
						//I-type OP andi
						6'b001100: begin state <= I_Exc; ALUSrcA <= 2'b01; ALUSrcB <= 3'b011; ALU_operation <= AND; end
						//I-type OP ori
						6'b001101: begin state <= I_Exc; ALUSrcA <= 2'b01; ALUSrcB <= 3'b011; ALU_operation <= OR; end
						//I-type OP xori
						6'b001110: begin state <= I_Exc; ALUSrcA <= 2'b01; ALUSrcB <= 3'b011; ALU_operation <= XOR; end
						//I-type OP slti
						6'b001010: begin state <= I_Exc; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010; ALU_operation <= SLT; end
						//Lui
						6'b001111: begin state <= Lui_WB; MemtoReg <= 2'b10; RegWrite <= 1'b1; end
						//Beq
						6'b000100: begin state <= Beq_Exc; Branch <= 1'b1; ALUSrcA <= 2'b01; ALUSrcB <= 3'b000; PCWriteCond <= 1'b1;
                            PCSource <= 2'b01; ALU_operation <= SUB; end
						//Bne
						6'b000101: begin state <= Bne_Exc; Branch <= 1'b0; ALUSrcA <= 2'b01; ALUSrcB <= 3'b000; PCWriteCond <= 1'b1;
                            PCSource <= 2'b01; ALU_operation <= SUB; end
						//Jal
						6'b000011: begin state <= Jal; PCWrite <= 1'b1; MemtoReg <= 2'b11; PCSource <= 2'b10; RegWrite <= 1'b1;
                            RegDst <= 2'b10;end
						//Jump
						6'b000010: begin state <= J; PCSource <= 2'b10; PCWrite <= 1'b1; end
						default: begin state <= IF; signalIF; end
					endcase
			Mem_Exc:	case(Inst_in[31:26])
							//LW
							6'b100011: begin state <= Mem_RD; MemRead <= 1'b1; IorD <= 1'b1; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010; 
							CPU_MIO <= 1'b1; end
							//SW
							6'b101011: begin state <= Mem_WD; MemWrite <= 1'b1; IorD <= 1'b1; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010; 
							CPU_MIO <= 1'b1; end
							default: begin state <= IF; signalIF; end
						endcase
			Mem_RD:	if (MIO_ready) begin state <= LW_WB; RegWrite <= 1'b1; MemtoReg <= 2'b01; end
						else begin state <= Mem_RD; MemRead <= 1'b1; IorD <= 1'b1; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010; 
						CPU_MIO <= 1'b1; end
			LW_WB:	begin state <= IF; signalIF; end
			Mem_WD:	if (MIO_ready) begin state <= IF; signalIF; end
						else begin MemWrite <= 1'b1; IorD <= 1'b1; ALUSrcA  <= 2'b01; ALUSrcB  <= 3'b010; CPU_MIO  <= 1'b1; 
						state <= Mem_WD; end
			R_Exc:	begin state <= R_WB; RegWrite <= 1'b1; RegDst <= 2'b01; MemtoReg <= 2'b00; end
			R_WB:		begin state <= IF; signalIF; end
			I_Exc:	begin state <= I_WB; RegWrite <= 1'b1; RegDst <= 2'b00; MemtoReg <= 2'b00; end
			Lui_WB: 	begin state <= IF; signalIF; end
			Beq_Exc:	begin state <= IF; signalIF; end
			Bne_Exc:	begin state <= IF; signalIF; end
			J:			begin state <= IF; signalIF; end
			Jal:		begin state <= IF; signalIF; end
			Jr:		begin state <= IF; signalIF; end
			Jalr:		begin state <= IF; signalIF; end
			Error: 	begin state <= IF; signalIF; end
			default: begin state <= IF; signalIF; end
		endcase

endmodule
