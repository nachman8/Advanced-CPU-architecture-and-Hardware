LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY IO_interface IS
  GENERIC (	HEX_num : integer := 7;
			n : INTEGER := 8
			); 
  PORT (
		  clk  : in std_logic; 
		  -- Switch Port
		  SW_i : in std_logic_vector(8 downto 0);
		  -- Keys Ports
		  KEY0, KEY1, KEY2, KEY3 : in std_logic;
		  -- 7 segment Ports
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(HEX_num-1 downto 0);
		  -- Leds Port
		  LEDs : out std_logic_vector(9 downto 0);
          -- PMW Port
          PWM_out : out std_logic
  );
END IO_interface;
------------------------------------------------
ARCHITECTURE struct OF IO_interface IS 
	-- ALU Inputs
	signal ALUout, x_sig, y_sig : 	std_logic_vector(n-1 downto 0);
	signal Nflag_sig, Cflag_sig, Zflag_sig, Vflag_sig: STD_LOGIC;
	signal ALUFN: std_logic_vector(4 downto 0);
    signal rst_sig, ena_sig: STD_LOGIC;
    signal PWM_sig: STD_LOGIC;
	signal PLL_clk: STD_LOGIC;
	signal Digital_clk, enable_clk: STD_LOGIC;
BEGIN

	-------------------TOP Module -----------------------------
	TOPModule:	TOP generic map(n) port map(Digital_clk, rst_sig, ena_sig, y_sig, x_sig, ALUFN, ALUout, Nflag_sig, Cflag_sig, Zflag_sig, Vflag_sig, PWM_out);
	
	-----------------PLL--------------------------------------
	PLLModule: PLL port map(refclk => clk, outclk_0 => PLL_clk);

	-----------------counter--------------------------------------
	enable_clk <= '1';
	counterModule: counter port map(PLL_clk, enable_clk, Digital_clk);
	
	---------------------7 Segment Decoder-----------------------------
	-- Display x_sig on 7 segment
	DecoderModuleXHex0: 	Seven_Segment	port map(x_sig(3 downto 0) , HEX0);
	DecoderModuleXHex1: 	Seven_Segment	port map(x_sig(7 downto 4) , HEX1);
	-- Display y_sig on 7 segment
	DecoderModuleYHex2: 	Seven_Segment	port map(y_sig(3 downto 0) , HEX2);
	DecoderModuleYHex3: 	Seven_Segment	port map(y_sig(7 downto 4) , HEX3);
	-- Display ALU output on 7 segment
	DecoderModuleOutHex4: 	Seven_Segment	port map(ALUout(3 downto 0) , HEX4);
	DecoderModuleOutHex5: 	Seven_Segment	port map(ALUout(7 downto 4) , HEX5);
	--------------------LEDS Binding-------------------------
	LEDs(0) <= Nflag_sig;
	LEDs(1) <= Cflag_sig;
	LEDs(2) <= Zflag_sig;
    LEDs(3) <= Vflag_sig;
	LEDs(9 downto 5) <= ALUFN;
	-------------------Keys Binding--------------------------
	rst_sig <= not(KEY3);
	process(KEY0) 
		begin
			if falling_edge(KEY0) then
				y_sig     <= SW_i(7 DOWNTO 0);
			end if;
	end process;

	process(KEY1) 
	begin
		if falling_edge(KEY1) then
			ALUFN <= SW_i(4 downto 0);
		end if;	
	end process;
	
	process(KEY2) 
	begin
		if falling_edge(KEY2) then
			x_sig	  <= SW_i(7 DOWNTO 0);
		end if;	
	end process;
	

   -------------------enable-------------------
    ena_sig     <= SW_i(8);



END struct;

