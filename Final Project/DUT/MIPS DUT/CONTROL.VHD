		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Func			: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
	RegDst 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- decide wether R31 or R (decode)
	ALUSrc 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- decide if Immediate or R inputs
	MemtoReg 		: OUT 	STD_LOGIC;
	RegWrite 		: OUT 	STD_LOGIC;
	MemRead 		: OUT 	STD_LOGIC;
	MemWrite 		: OUT 	STD_LOGIC;
	BEQ 			: OUT 	STD_LOGIC;
	BNE 			: OUT 	STD_LOGIC;
	Jal				: OUT 	STD_LOGIC;							-- for Decode
	JAL_ISR			: OUT 	STD_LOGIC;							-- for ISR jump
	Jump 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );		-- for Fetch and Decode
	ALUop 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, I_format, shift, beq_s, bne_s,j, jr, jal_s, slt, lw, sw	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000" OR Opcode = "011100" ELSE '0';  -- mul opcode is 011100
	I_format    <=  '1'  WHEN  Opcode(3) = '1' and (not(Opcode = "011100" ))ELSE '0';
	lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
	beq_s       <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
	bne_s       <=  '1'  WHEN  Opcode = "000101"  ELSE '0';
	shift       <=  '1'  WHEN  (Opcode = "00000") AND ((Func = "000000") or (Func = "000010")) ELSE '0';
	jal_s    	<=  '1'  WHEN  Opcode = "000011"  ELSE '0';
	j           <=  '1'  WHEN  Opcode = "000010"  ELSE '0';
	jr          <=  '1'  WHEN  Opcode = "000000" and Func = "001000"  ELSE '0';
	slt         <=  '1'  WHEN  (Opcode = "00000" AND Func = "101010") or (Opcode = "001010") ELSE '0';
	JAL_ISR     <=  '1'  WHEN  Opcode = "11111" ELSE '0';

  	RegDst(1)   <=  R_format;
	RegDst(0)	<=  jal_s;
	BEQ 		<=  beq_s;
	BNE 		<=  bne_s;
	Jump(0)     <=  jal_s OR j;
	Jump(1)     <=  jr;
	Jal 		<=  jal_s;
 	ALUSrc(0)  	<=  shift OR lw OR I_format;
	ALUSrc(1)  	<=  shift;
  	RegWrite 	<=  (I_format OR jal_s OR R_format OR Lw) and (not sw) and (not JAL_ISR);
	MemtoReg 	<=  Lw;
  	MemRead 	<=  Lw;
   	MemWrite 	<=  Sw; 
	ALUOp( 1 ) 	<=  slt OR R_format;
	ALUOp( 0 ) 	<=  Beq OR Bne OR Lw or slt OR I_format; 

   END behavior;


