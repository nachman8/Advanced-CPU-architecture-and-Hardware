--------------- Interrupt Controller Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY INTERRUPT IS
	GENERIC(DataBusSize	: integer := 32;
			AddrBusSize	: integer := 12;
			IrqSize	    : integer := 7;
			RegSize		: integer := 8
			);
	PORT( 
			reset		: IN	STD_LOGIC;
			clock		: IN	STD_LOGIC;
			MemReadBus	: IN	STD_LOGIC;
			MemWriteBus	: IN	STD_LOGIC;
			AddressBus	: IN	STD_LOGIC_VECTOR(AddrBusSize-1 DOWNTO 0);
			DataBus		: INOUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
			IntrSrc		: IN	STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0); -- IRQ
			ChipSelect	: IN	STD_LOGIC;
			INTR		: OUT	STD_LOGIC;
			INTA		: IN	STD_LOGIC;
			IRQ_OUT		: OUT   STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0);
			INTR_Active	: OUT	STD_LOGIC;
			GIE			: IN	STD_LOGIC
		);
END INTERRUPT;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF INTERRUPT IS
	SIGNAL IRQ			: STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0);
	SIGNAL CLR_IRQ		: STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0);
	
	-- UART 
	SIGNAL IRQ_STATUS, CLR_IRQ_STATUS : STD_LOGIC;
	--
		
	SIGNAL IE		: STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0);
	SIGNAL IFG			: STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0);
	SIGNAL TypeReg		: STD_LOGIC_VECTOR(RegSize-1 DOWNTO 0);
	
	SIGNAL INTA_Delayed : STD_LOGIC;
	
	
	
BEGIN
--------------------------- IO MCU ---------------------------
-- OUTPUT TO MCU -- 
DataBus <=	X"000000" 		& TypeReg 	WHEN ((AddressBus = X"83E" AND MemReadBus = '1') OR (INTA = '0' AND MemReadBus = '0')) ELSE
			X"000000"&"0" 	& IE 	WHEN (AddressBus = X"83C" AND MemReadBus = '1') ELSE
			X"000000"&"0" 	& IFG		WHEN (AddressBus = X"83D" AND MemReadBus = '1') ELSE
			(OTHERS => 'Z');

--INPUT FROM MCU -- 

PROCESS(clock) 
BEGIN
	IF (falling_edge(clock)) THEN
		IF (AddressBus = X"83C" AND MemWriteBus = '1') THEN
			IE 	<=	DataBus(IrqSize-1 DOWNTO 0);
		END IF;		
	END IF;
END PROCESS;

IFG		<=	DataBus(IrqSize-1 DOWNTO 0)	WHEN (AddressBus = X"83D" AND MemWriteBus = '1') ELSE
			IRQ AND IE;		
TypeReg	<=	DataBus(RegSize-1 DOWNTO 0)	WHEN (AddressBus = X"83E" AND MemWriteBus = '1') ELSE
			(OTHERS => 'Z');
-------------------------------------------------------------

-- Find the INTR output
PROCESS (clock, IFG) BEGIN 
	IF (rising_edge(CLOCK)) THEN
		IF (IFG(0) = '1' OR IFG(1) = '1' OR IFG(2) = '1' OR
			IFG(3) = '1' OR IFG(4) = '1' OR IFG(5) = '1' OR IFG(6) = '1') THEN
			
			INTR <= GIE;
		ELSE 
			INTR <= '0';
		END IF;
	END IF;
END PROCESS;

------------ BTIMER ---------------
PROCESS (clock, reset, CLR_IRQ(2), IntrSrc(2))
BEGIN
	IF falling_edge(clock) THEN
		IF (reset = '1') THEN
			IRQ(2) <= '0';
		ELSIF CLR_IRQ(2) = '0' THEN
			IRQ(2) <= '0';
		ELSIF IntrSrc(2) = '1' THEN
			IRQ(2) <= '1';
		END IF;
	END IF;
END PROCESS;
------------ KEY1 ---------------
PROCESS (clock, reset, CLR_IRQ(3), IntrSrc(3))
BEGIN
	IF (reset = '1') THEN
		IRQ(3) <= '0';
	ELSIF CLR_IRQ(3) = '0' THEN
		IRQ(3) <= '0';
	ELSIF rising_edge(IntrSrc(3)) THEN
		IRQ(3) <= '1';
	END IF;
END PROCESS;
------------ KEY2 ---------------
PROCESS (clock, reset, CLR_IRQ(4), IntrSrc(4))
BEGIN
	IF (reset = '1') THEN
		IRQ(4) <= '0';
	ELSIF CLR_IRQ(4) = '0' THEN
		IRQ(4) <= '0';
	ELSIF rising_edge(IntrSrc(4)) THEN
		IRQ(4) <= '1';
	END IF;
END PROCESS;
------------ KEY3 ---------------
PROCESS (clock, reset, CLR_IRQ(5), IntrSrc(5))
BEGIN
	IF (reset = '1') THEN
		IRQ(5) <= '0';
	ELSIF CLR_IRQ(5) = '0' THEN
		IRQ(5) <= '0';
	ELSIF rising_edge(IntrSrc(5)) THEN
		IRQ(5) <= '1';
	END IF;
END PROCESS;
------------ DIVIDER ---------------
PROCESS (clock, reset, CLR_IRQ(6), IntrSrc(6))
BEGIN
	IF (reset = '1') THEN
		IRQ(6) <= '0';
	ELSIF CLR_IRQ(6) = '0' THEN
		IRQ(6) <= '0';
	ELSIF rising_edge(IntrSrc(6)) THEN
		IRQ(6) <= '1';
	END IF;
END PROCESS;
---


IRQ_OUT <= IRQ;

PROCESS (clock) BEGIN
	IF (reset = '1') THEN
		INTA_Delayed <= '1';
	ELSIF falling_edge(clock) THEN
		INTA_Delayed <= INTA;
	END IF;
END PROCESS;

-- Clear IRQ When Interrupt Ack recv
CLR_IRQ(2) <= '0' WHEN (TypeReg = X"10" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(3) <= '0' WHEN (TypeReg = X"14" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(4) <= '0' WHEN (TypeReg = X"18" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(5) <= '0' WHEN (TypeReg = X"1C" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(6) <= '0' WHEN (TypeReg = X"20" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';



-- Determinate if interrupt is currently active
INTR_Active	<= 	IFG(0) OR IFG(1) OR IFG(2) OR
				IFG(3) OR IFG(4) OR IFG(5) OR IFG(6);

-- Interrupt Vectors
TypeReg	<= 	X"00" WHEN reset  = '1' ELSE -- main
			--X"04" WHEN (IRQ_STATUS = '1' AND IE(0) = '1') ELSE  -- Uart Status Error
			--X"08" WHEN IFG(0) = '1' ELSE  	-- Uart RX
			--X"0C" WHEN IFG(1) = '1' ELSE  	-- Uart TX
			X"10" WHEN IFG(2) = '1' ELSE  	-- Basic timer
			X"14" WHEN IFG(3) = '1' ELSE  	-- KEY1
			X"18" WHEN IFG(4) = '1' ELSE	-- KEY2
			X"1C" WHEN IFG(5) = '1' ELSE	-- KEY3
			X"20" WHEN IFG(6) = '1' ELSE	-- Divider
			(OTHERS => 'Z');

END structure;




-- ---------------------------CS(5)-------------------------------
--define PORT_KEY[3-1]    0x814 ([1]000 00[01 01]00)   - LSB nibble (3 push-buttons - Input Mode)
-- ---------------------------CS(4)-------------------------------
--define UCTL             0x818 ([1]000 00[01 10]00)   - Byte       Write only
--define RXBF             0x819 ([1]000 00[01 10]01)   - Byte        Read only
--define TXBF             0x81A ([1]000 00[01 10]10)   - Byte       Write only
-- -----------------------------CS(3)-----------------------------
--define BTCTL            0x81C ([1]000 00[01 110]0)   - LSB byte   Write only
--define BTCNT            0x820 ([1]000 00[10 000]0)   - Word       Read only
--define BTCCR0           0x822 ([1]000 00[10 001]0)   - Word       Write only
--define BTCCR1           0x824 ([1]000 00[10 010]0)   - Word       Write only
-- ----------------------------CS(2)------------------------------
--define DIVIDEND         0x82C ([1]000 00[10 11]00)   - Word       Write only
--define DIVISOR          0x830 ([1]000 00[11 00]00)   - Word       Write only
--define QUOTIENT         0x834 ([1]000 00[11 01]00)   - Word       Read only
--define RESIDUE          0x838 ([1]000 00[11 10]00)   - Word       Read only
-- --------------------------CS(1)--------------------------------
--define IE               0x83C ([1]000 00[11 11]00)   - LSB byte   Read/Write
--define IFG              0x83D ([1]000 00[11 11]01)   - LSB byte   Read/Write
--define TYPE             0x83E ([1]000 00[11 11]10)   - LSB byte   Read only

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