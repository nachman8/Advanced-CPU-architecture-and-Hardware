LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY ALU IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
	Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  );
END ALU;
------------- complete the ALU Architecture code --------------
ARCHITECTURE struct OF ALU IS 
type matrix is array(2 downto 0) of STD_LOGIC_VECTOR(n-1 downto 0);
SIGNAL mat : matrix;
SIGNAL cout: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL x_shift,y_shift,x_add,y_add,x_log,y_log : std_logic_vector(n-1 DOWNTO 0);
SIGNAL shift_FN,logic_FN,add_FN : STD_LOGIC_VECTOR(2 downto 0);
constant zero: std_logic_vector(n-1 downto 0) := (others => '0');
SIGNAL Z: std_logic_vector(n-1 DOWNTO 0) := (others => 'Z');
SIGNAL ALUout : std_logic_vector(n-1 downto 0);
SIGNAL ALU_arithmetic, ALU_add, ALU_sub, X_neg, Y_neg, ALUout_neg : STD_LOGIC;
SIGNAL SWAP_temp:  std_logic_vector(n-1 downto 0);
SIGNAL SWAP:  std_logic_vector(n-1 downto 0);	
BEGIN
-------initializing----------------------------------------------------------------------------
	x_shift  <= X_i					WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE Z;
	y_shift  <= Y_i 				WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE Z;
	shift_FN <= ALUFN_i(2 DOWNTO 0)	WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE "ZZZ";
	
	x_add  <= X_i 					WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE Z;
	y_add  <= Y_i 					WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE Z;
	add_FN <= ALUFN_i(2 DOWNTO 0)	WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE "ZZZ";
	
	x_log    <= X_i 					WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE Z;
	y_log    <= Y_i 					WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE Z;
	Logic_FN <= ALUFN_i(2 DOWNTO 0)		WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE "ZZZ";

	SWAP_temp  <= X_i 					WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE Z;
-------mapping--------------------------------------------------------------------------------
Shif	:Shifter 	GENERIC MAP(n,k) PORT MAP(x_shift, y_shift, shift_FN, cout(0), mat(0));	 -- Shifter   
AddSub	:AdderSub 	GENERIC MAP(n)	 PORT MAP(x_add, y_add, add_FN, cout(1), mat(1)); 	     -- AdderSub
Log	    :Logic		GENERIC MAP(n)	 PORT MAP(x_log, y_log, Logic_FN, mat(2)); 				 -- Logic
-------SWAP CALCULATION-------------------------------------------------------------------------
SWAP(n-1 downto 4) <= SWAP_temp (3 downto 0);
SWAP(3 downto 0) <= SWAP_temp (n-1 downto 4);
-------data transfer-------------------------------------------------------------------------------
Zflag_o <= '1' WHEN (ALUout = zero) ELSE -- check if zero
		   '0';
Nflag_o <= ALUout(n-1);   --result's MSB


		ALUout <= 	mat(0) WHEN (ALUFN_i = "10000" or ALUFN_i= "10001")						else 	-- Shifter
					mat(1) WHEN (ALUFN_i ="01000" or ALUFN_i="01001" or ALUFN_i= "01010")   else	-- AdderSub
					mat(2) WHEN ALUFN_i(4 downto 3) = "11"    								else	-- Logic
					SWAP   WHEN  ALUFN_i ="01011"											else  	-- SWAP
					zero;

			
		Cflag_o <= 	cout(0) WHEN ALUFN_i(4 DOWNTO 3) = "10"  									 else 	-- Shifter
					cout(1) WHEN (ALUFN_i ="01000" or ALUFN_i="01001") 		 else	-- AdderSub
					unaffected;	
	ALUout_o <= ALUout;					
--------vflag_o at addersub---------------	
-- Define arithmetic operations based on ALUFN_i
ALU_arithmetic <= '1' when (ALUFN_i(4 DOWNTO 3) = "01") else '0';
ALU_add <= '1' when (ALUFN_i = "01000") else '0';
ALU_sub <= '1' when (ALUFN_i = "01001") else '0';

-- Check the sign bit (most significant bit) of inputs and output
Y_neg <= '1' when (Y_i(n-1) = '1') else '0';
X_neg <= '1' when (X_i(n-1) = '1') else '0';
ALUout_neg <= '1' when (ALUout(n-1) = '1') else '0';

-- Determine overflow conditions for addition and subtraction
-- Overflow in addition: same signs of operands, different sign of result
-- Overflow in subtraction: different signs of operands, different sign of result
Vflag_o <= '1' when (ALU_arithmetic = '1' and 
                    ((ALU_add = '1' and (not (Y_neg xor X_neg) = '1' and (Y_neg xor ALUout_neg) = '1')) or 
                    (ALU_sub = '1' and (Y_neg xor X_neg) = '1' and (Y_neg xor ALUout_neg) = '1')))
                    else '0';

END struct;