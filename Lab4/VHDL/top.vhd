LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY Top IS
  GENERIC (	
			n : INTEGER := 8
			); 
  PORT (
		  clk, rst, ena  : in std_logic; 
		  
		  Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
          ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
          ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
          Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC;

          PWM_out : out std_logic
  );
END Top;
------------------------------------------------
ARCHITECTURE struct OF Top IS 
SIGNAL ALUFN : STD_LOGIC;
SIGNAL state: STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
state <= ALUFN_i;
ALUFN<= state(0);
	-------------------ALU Module -----------------------------
	ALUModule:	ALU generic map(n) port map(Y_i, X_i, ALUFN_i, ALUout_o, Nflag_o, Cflag_o, Zflag_o, Vflag_o);

    ------------------PWM Module-------------------------------
  PWM_module:	PWM generic map(n) port map(Y_i=>Y_i, X_i=>X_i, ALUFN=>ALUFN,state=>state, PWM_out=>PWM_out, clk=>clk, rst=>rst, ena=>ena);

END struct;

