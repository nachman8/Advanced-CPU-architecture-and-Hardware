--------------- Optimized Address Decoder
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY OptAddrDecoder IS
	PORT( 
		reset                       : IN    STD_LOGIC;
		AddrBus                       : IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS                          : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
		--CS_LEDR, CS_SW              : OUT   STD_LOGIC;
		--CS_HEX01, CS_HEX23, CS_HEX45: OUT   STD_LOGIC
	);
END OptAddrDecoder;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF OptAddrDecoder IS
BEGIN

	CS(1)	<=	'0' WHEN reset = '1' ELSE '1' WHEN (AddrBus = X"800") ELSE '0';
	CS(6)	<=	'0' WHEN reset = '1' ELSE '1' WHEN (AddrBus = X"804" or AddrBus = X"805") ELSE '0';
	CS(5)	<=	'0' WHEN reset = '1' ELSE '1' WHEN (AddrBus = X"808" or AddrBus = X"809") ELSE '0';
	CS(4)	<=	'0' WHEN reset = '1' ELSE '1' WHEN (AddrBus = X"80C" or AddrBus = X"80D") ELSE '0';
	CS(7)	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddrBus = X"810" ELSE '0';
	
END structure;

--------------------------------------------------------------
--                         MEMORY Mapped I/O                    
--------------------------------------------------------------
--define PORT_LEDR[7-0]  0x800: [1]000 000[0 00]00- LSB byte (Output Mode): CS[1]
--------------------------------------------------------------
--define PORT_HEX0[7-0]  0x804: [1]000 000[0 01]00 - LSB byte (Output Mode): CS[6]
--define PORT_HEX1[7-0]  0x805: [1]000 000[0 01]01- LSB byte (Output Mode)
--------------------------------------------------------------
--define PORT_HEX2[7-0]  0x808: [1]000 000[0 10]00- LSB byte (Output Mode): CS[5]
--define PORT_HEX3[7-0]  0x809: [1]000 000[0 10]01- LSB byte (Output Mode)
--------------------------------------------------------------
--define PORT_HEX4[7-0]  0x80C: [1]000 000[0 11]00- LSB byte (Output Mode): CS[4]
--define PORT_HEX5[7-0]  0x80D: [1]000 000[0 11]01- LSB byte (Output Mode)
--------------------------------------------------------------
--define PORT_SW[7-0]    0x810: [1]000 000[1 00]00- LSB byte (Input Mode) : CS[7]
--------------------------------------------------------------