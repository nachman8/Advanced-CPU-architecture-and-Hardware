--------------- Output Peripheral 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY OutputPeripheral_LEDR IS
	GENERIC (IOSize		: INTEGER := 8); -- 7 WHEN HEX, 8 WHEN LEDs
	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		ChipSelect	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		GPOutput	: OUT	STD_LOGIC_VECTOR(IOSize-1 DOWNTO 0)
		);
END OutputPeripheral_LEDR;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF OutputPeripheral_LEDR IS
	SIGNAL Latch_o	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	
	PROCESS(clock)
	BEGIN
	IF (reset = '1') THEN
		Latch_o	<= (others => '0');
	ELSIF (falling_edge(clock)) THEN -- falling edge because of the noise on the enable signal
		IF (MemWrite = '1' AND ChipSelect = '1') THEN
			Latch_o <= Data;
		END IF;
	END IF;
	END PROCESS;
	



	Data	<=	Latch_o WHEN (MemRead = '1' AND ChipSelect = '1') 	ELSE (others => 'Z'); 

	GPOutput <= Latch_o;
	
END structure;