--------------- Input Peripheral 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY InputPeripheral IS
	GENERIC(DataBusSize	: integer := 32);
	PORT( 
		MemRead		: IN	STD_LOGIC;
		ChipSelect	: IN 	STD_LOGIC;
		Data		: OUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
		GPInput		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END InputPeripheral;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF InputPeripheral IS
	-- SIGNAL GPInput_SIG	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN	
	-- GPInput_SIG	<= GPInput;
	Data		<= X"000000" & GPInput WHEN (MemRead AND ChipSelect) = '1' ELSE (OTHERS => 'Z');
	
END structure;