--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY  Execute IS
	PORT(	Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Func           	: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Zero 			: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Jr_Add			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC );
END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl				: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
BEGIN
	
	Jr_Add <= Read_data_1( 7 DOWNTO 0);	
						-- mux for shift
	Ainput <= 	Read_data_2 WHEN ( ALUSrc(1) = '1' ) ELSE
				Read_data_1;
						-- ALU input mux
	Binput <= Read_data_2 
		WHEN ( ALUSrc (0) = '0' ) 
  		ELSE  Sign_extend( 31 DOWNTO 0 );
						-- Generate ALU control bits
	ALU_ctl <= 		"0000"	 WHEN (ALUOp = "10" AND Func = "000000" and Opcode = "000000") ELSE -- shift left
					"0001" 	 WHEN (ALUOp = "10" AND Func = "000010" and Opcode = "000000") ELSE -- shift right				
					"0010"	 WHEN ((ALUOp = "10" AND (Func = "100000" or Func = "001000" )) or 
	                              (ALUOp = "01" and (Opcode = "001000" or Opcode = "100011" or Opcode = "101011")))  ELSE  -- add (used in lw sw and more)
					"0011" 	 WHEN ((ALUOp = "10" AND (Func = "100010" or Func = "101010" )) OR 
	                              (ALUOp = "01" and (Opcode = "000100" or Opcode = "000101" or Opcode = "001010")) OR (ALUOp = "11"))  ELSE  -- sub (used in BEQ BNE slti and more)
					"0100" 	 WHEN (ALUOp = "01" AND Opcode = "001111") ELSE -- lui
					"0101"	 WHEN (Opcode = "011100") ELSE -- mul
					"0111" 	 WHEN (ALUOp = "10" AND Func = "100100") or (ALUOp = "01" AND Opcode = "001100")  ELSE -- and
					"1000"	 WHEN (ALUOp = "10" AND Func = "100101") or (ALUOp = "01" AND Opcode = "001101") ELSE -- or
					"1001" 	 WHEN (ALUOp = "10" AND Func = "100110") or (ALUOp = "01" AND Opcode = "001110") ELSE -- xor
					"1011"	 WHEN (ALUOp = "10" AND Func = "100001") ELSE --  move
					"1111";	
						-- Generate Zero Flag
	Zero <= '1' 
		WHEN ( ALU_output_mux( 31 DOWNTO 0 ) = X"00000000"  )
		ELSE '0';    
						-- Select ALU output        
	ALU_result <= X"0000000" & B"000"  & ALU_output_mux( 31 ) 
		WHEN  ALUOp = "11" -- slt
		ELSE  	ALU_output_mux( 31 DOWNTO 0 );
						-- Adder to compute Branch Address
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
		Add_result 	<= Branch_Add( 7 DOWNTO 0 );

PROCESS ( ALU_ctl, Ainput, Binput )
	variable mul : STD_LOGIC_VECTOR(63 downto 0);
	BEGIN
					-- Select ALU operation
					CASE ALU_ctl IS
					-- A_input shift left 
	WHEN "0000" 	=>	ALU_output_mux 	<=	std_logic_vector(shift_left(unsigned(Ainput),to_integer(unsigned(Binput(10 downto 6)))));

					-- A_input shift right
	WHEN "0001" 	=>	ALU_output_mux 	<=	std_logic_vector(shift_right(unsigned(Ainput),to_integer(unsigned(Binput(10 downto 6)))));

					-- A_input + B_input
	WHEN "0010" 	=>	ALU_output_mux 	<= Ainput + Binput; 
	
					-- A_input - B_input
	WHEN "0011" 	=>	ALU_output_mux 	<= Ainput - Binput;

	 				-- LUI 
	WHEN "0100" 	=>	ALU_output_mux 	<= Binput(15 DOWNTO 0) & X"0000";
	
					-- A_input * B_input
	WHEN "0101" 	=>	mul := Ainput * Binput; -- 64 bit
						ALU_output_mux <= mul(31 DOWNTO 0); -- Take 32 bit
	
					-- A_input and B_input
	WHEN "0111" 	=>	ALU_output_mux 	<= Ainput AND Binput;
	
					-- A_input OR B_input
	WHEN "1000" 	=>	ALU_output_mux <= Ainput OR Binput;
	
					-- A_input XOR B_input
	WHEN "1001" 	=>	ALU_output_mux <= Ainput XOR Binput;
		
					-- move
	WHEN "1011" 	=>	ALU_output_mux 	<= Binput ;
	

 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
END behavior;

