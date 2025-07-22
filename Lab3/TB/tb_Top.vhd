library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;

---------------------------------------------------------
entity top_tb is
	constant BusSize: integer:=16;
	constant m		: integer:=16;
	constant Awidth : integer:=6;	 
	constant RegSize: integer:=4;
	constant dept   : integer:=64;

	constant dataMemResult:	 	string(1 to 78) :=
	"C:\intelFPGA\20.1\HW3\DANEL__code\Code and binary memory files\DTCMcontent.txt";
	
	constant dataMemLocation: 	string(1 to 75) :=
	"C:\intelFPGA\20.1\HW3\DANEL__code\Code and binary memory files\DTCMinit.txt";
	
	constant progMemLocation: 	string(1 to 75) :=
	"C:\intelFPGA\20.1\HW3\DANEL__code\Code and binary memory files\ITCMinit.txt";
end top_tb;
---------------------------------------------------------
architecture rtb of top_tb is

	SIGNAL done_FSM:														STD_LOGIC := '0';
	SIGNAL rst, ena, clk, TBactive, TBWriteEnableDataMem, TBWriteEnableProgMem: 		STD_LOGIC;	
	SIGNAL TBdataInDataMem, TBdataOutDataMem: 							STD_LOGIC_VECTOR (BusSize-1 downto 0); -- n
	SIGNAL TBdataInProgMem: 											STD_LOGIC_VECTOR (BusSize-1 downto 0); -- m (m=n?)
	SIGNAL TBWriteAddressDataMem, TBWriteAddressProgMem:  							STD_LOGIC_VECTOR (Awidth-1 DOWNTO 0);
	SIGNAL TBReadAddressDataMem:												STD_LOGIC_VECTOR (Awidth-1 DOWNTO 0);
	SIGNAL donePmemIn, doneDmemIn:										BOOLEAN;
	
begin
	
	TopUnit: top port map(	done_FSM, clk, rst, ena, TBWriteEnableProgMem, TBWriteEnableDataMem, TBWriteAddressProgMem, TBWriteAddressDataMem, TBReadAddressDataMem, TBdataInProgMem, TBdataInDataMem,
							TBdataOutDataMem, TBactive);
						
    
	--------- start of stimulus section ------------------	
	
	--------- Rst
	gen_rst : process
	begin
	  rst <='1','0' after 100 ns;
	  wait;
	end process;
	
	------------ Clock
	gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;
	
	--------- 	TB
	gen_TB : process
        begin
		 TBactive <= '1';
		 wait until donePmemIn and doneDmemIn;  
		 TBactive <= '0';
		 wait until done_FSM = '1';  
		 TBactive <= '1';	
        end process;	
	
				
				
	--------- --Reading from text file and initializing the data memory data--------
	LoadDataMem: process 
		file inDmemfile : text open read_mode is dataMemLocation;
		variable    linetomem			: std_logic_vector(BusSize-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; -- Awidth
	begin 
		doneDmemIn <= false;
		TempAddresses := (others => '0');
		while not endfile(inDmemfile) loop
			readline(inDmemfile,L);
			hread(L,linetomem,good);
			next when not good;
			TBWriteEnableDataMem <= '1';
			TBWriteAddressDataMem <= TempAddresses;
			TBdataInDataMem <= linetomem;
			wait until rising_edge(clk);
			TempAddresses := TempAddresses +1;
		end loop ;
		TBWriteEnableDataMem <= '0';
		doneDmemIn <= true;
		file_close(inDmemfile);
		wait;
	end process;
		
		
	--------- Reading from text file and initializing the program memory instructions ------
	LoadProgramMem: process 
		file inPmemfile : text open read_mode is progMemLocation;
		variable    linetomem			: std_logic_vector(BusSize-1 downto 0); 
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; -- Awidth
	begin 
		donePmemIn <= false;
		TempAddresses := (others => '0');
		while not endfile(inPmemfile) loop
			readline(inPmemfile,L);
			hread(L,linetomem,good);
			next when not good;
			TBWriteEnableProgMem <= '1';
			TBWriteAddressProgMem <= TempAddresses;
			TBdataInProgMem <= linetomem;
			wait until rising_edge(clk);
			TempAddresses := TempAddresses +1;
		end loop ;
		TBWriteEnableProgMem <= '0';
		donePmemIn <= true;
		file_close(inPmemfile);
		wait;
	end process;
	

	ena <= '1' when (doneDmemIn and donePmemIn) else '0';
	
		
	--------- Writing from Data memory to external text file, after the program ends (done_FSM = 1). -----
	WriteToDataMem: process 
		file outDmemfile : text open write_mode is dataMemResult;
		variable    linetomem			: std_logic_vector(BusSize-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; -- Awidth
		variable 	counter				: integer;
	begin 
		wait until done_FSM = '1';  
		TempAddresses := (others => '0');
		counter := 1;
		while counter < 16 loop	--15 lines in file
			TBReadAddressDataMem <= TempAddresses;
			wait until rising_edge(clk);
			wait until rising_edge(clk); -- added now 12/5/2023 14:48
			hwrite(L,TBdataOutDataMem);
			writeline(outDmemfile,L);
			TempAddresses := TempAddresses +1;
			counter := counter +1;
		end loop ;
		file_close(outDmemfile);
		wait;
	end process;
		

end architecture rtb;

