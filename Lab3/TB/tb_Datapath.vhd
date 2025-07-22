library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity datapth_tb is
	generic(BusSize : integer := 16;
			Awidth:  integer:=6;  	-- Address Size
			RegSize: integer:=4; 	-- Register Size
			m: 	  integer:=16);  -- Program Memory In Data Size

    
    constant dataMemResult:	 	string(1 to 80) :=
	"C:\intelFPGA\20.1\HW3\DANEL__code\Code and binary memory files\datatb_result.txt";
	
	constant dataMemLocation: 	string(1 to 78) :=
	"C:\intelFPGA\20.1\HW3\DANEL__code\Code and binary memory files\datatb_data.txt";
	
	constant progMemLocation: 	string(1 to 81) :=
	"C:\intelFPGA\20.1\HW3\DANEL__code\Code and binary memory files\datatb_program.txt";
    end datapth_tb;
    
architecture tb of datapth_tb is

    signal		st, ld, mov, done, add, sub, jmp, jc, jnc, xor_s, or_s, and_s, Cflag, Zflag, Nflag:  std_logic;
    signal		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in :  std_logic;
    signal		OPC :  std_logic_vector(3 downto 0);
    signal 		done_FSM : std_logic;
    signal 		PCsel, RFaddr :  std_logic_vector(1 downto 0);
    signal 		TBactive, clk, rst : std_logic;
    signal 		TBWriteEnableProgMem, TBWriteEnableDataMem : std_logic;
    signal 		TBdataInDataMem    : std_logic_vector(BusSize-1 downto 0);
    signal 		TBdataInProgMem    : std_logic_vector(m-1 downto 0);
    signal 		TBWriteAddressProgMem, TBWriteAddressDataMem, TBReadAddressDataMem : std_logic_vector(Awidth-1 downto 0);
    signal 		TBdataOutDataMem   : std_logic_vector(BusSize-1 downto 0);
    signal 	    donePmemIn, doneDmemIn:	 BOOLEAN;

    begin 

    DataPathUnit: Datapath generic map(BusSize)  port map(st, ld, mov, done, add, sub, jmp, jc, jnc, xor_s, or_s, and_s, Cflag, Zflag, Nflag,
													IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in,
													OPC, PCsel, RFaddr,
													TBactive, clk, rst, 
													TBWriteEnableProgMem, TBWriteEnableDataMem,
													TBdataInProgMem, TBdataInDataMem, TBWriteAddressProgMem, TBWriteAddressDataMem, TBReadAddressDataMem,
													TBdataOutDataMem);


--------- Clock
gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;

--------- Reset
gen_rst : process
        begin
		  rst <='1','0' after 100 ns;
		  wait;
        end process;	
--------- TB
gen_TB : process
	begin
	 TBactive <= '1';
	 wait until donePmemIn and doneDmemIn;  
	 TBactive <= '0';
	 wait until done_FSM = '1';  
	 TBactive <= '1';	
	end process;	
	
	
--------- Reading from text file and initializing the data memory data--------------
LoadDataMem:process 
	file inDmemfile : text open read_mode is dataMemLocation;
	variable    linetomem			: std_logic_vector(BusSize-1 downto 0);
	variable	good				: boolean;
	variable 	L 					: line;
	variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; 
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

--------- Reading from text file and initializing the program memory instructions	
LoadProgramMem:process 
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

Tb : process
	begin
		wait until donePmemIn and doneDmemIn;  

    ------------- Reset ------------------------		
		wait until rising_edge(clk);
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; -- ALU unaffected
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "00";   -- RF unaffected
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "11";  -- PC = zeros 
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
    ---------------- Fetch ---------------------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; -- unaffected
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '0';
        RFaddr	 <= "00";   -- unaffected
        IRin	 <= '1';    -- IR  Output
        PCin	 <= '0';
        PCsel	 <= "01";	-- PC = PC + 1
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
    ---------------- Decode -----D303 ld 3,2-------------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; -- unaffected
        Ain	 	 <= '1'; 
        RFin	 <= '0';
        RFout	 <= '1';  
        RFaddr	 <= "01";   -- rb out
        IRin 	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";	-- PC = PC + 1			
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';            
    -------------- ItypeState0-----ld 3,2----------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0'; 
        Cin	 	 <= '1';
        OPC	 	 <= "0000"; 	
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '0';
        RFaddr	 <= "10";  		 
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";	
        Imm1_in	 <= '0';
        Imm2_in	 <= '1';
        Mem_out	 <= '0';			
        done_FSM  <= '0';
        Mem_in <= '0';
    -------------- ItypeState1-----ld 3,2-----------
        wait until rising_edge(clk);
        Cout	 <= '1'; 
        Cin	 	 <= '0';
        OPC	 	 <= "1111";
        Ain	 	 <= '0';				
        RFaddr	 <= "10";   
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";	
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';				
        done_FSM  <= '0';
        Mem_out	 <= '0';  
        RFin	 <= '0'; 
        RFout	 <= '0'; 
        Mem_wr	 <= '0';
        Mem_in	 <= '0';            
    -------------- ItypeState2-------ld 3,2---------
        wait until rising_edge(clk);                	
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; 
        Ain	 	 <= '0';				
        RFaddr	 <= "10";   
        IRin	 <= '0';
        PCin	 <= '1';	
        PCsel	 <= "01";	
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0'; 
        Mem_wr	 <= '0'; 
        Mem_out	 <= '1';  
        RFin	 <= '1';
        RFout <= '0';               
    ---------------- Fetch ---------------------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; -- unaffected
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '0';
        RFaddr	 <= "00";   -- unaffected
        IRin	 <= '1';    -- IR  Output
        PCin	 <= '0';
        PCsel	 <= "01";	-- PC = PC + 1
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';  
    ---------------- Decode ---C205 mov 2,5--------------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; -- unaffected
        Ain	 	 <= '0'; 
        RFin	 <= '1';
        RFout	 <= '0';  
        RFaddr	 <= "10";   -- rb out
        IRin 	 <= '0';
        PCin	 <= '1';
        PCsel	 <= "01";	-- PC = PC + 1			
        Imm1_in	 <= '1';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
    ---------------- Fetch ---------------------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; -- unaffected
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '0';
        RFaddr	 <= "00";   -- unaffected
        IRin	 <= '1';    -- IR  Output
        PCin	 <= '0';
        PCsel	 <= "01";	-- PC = PC + 1
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
    ---------------- Decode ----0432 add 4,3,2 --------------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; -- unaffected
        Ain	 	 <= '1'; 
        RFin	 <= '0';
        RFout	 <= '1';  
        RFaddr	 <= "01";   -- rb out
        IRin 	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";	-- PC = PC + 1			
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
    -------------- RtypeState0-----add 4,3,2-----------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1';  
        RFaddr	 <= "00";  		
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";	
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM <= '0';
        OPC	 	 <= "0000"; 
    -------------- RtypeState1------add 4,3,2-----------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '1';  
        Cin	 	 <= '0';
        OPC	 	 <= "1111";  
        Ain	 	 <= '0';
        RFin	 <= '1';
        RFout	 <= '0';
        RFaddr	 <= "10";   
        IRin	 <= '0';
        PCin	 <= '1';
        PCsel	 <= "01";	
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';   
    ---------------- Fetch ---------------------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; -- unaffected
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '0';
        RFaddr	 <= "00";   -- unaffected
        IRin	 <= '1';    -- IR  Output
        PCin	 <= '0';
        PCsel	 <= "01";	-- PC = PC + 1
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';   
    ---------------- Decode -----E401 --st 4,1--------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; -- unaffected
        Ain	 	 <= '1'; 
        RFin	 <= '0';
        RFout	 <= '1';  
        RFaddr	 <= "01";   -- rb out
        IRin 	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";	-- PC = PC + 1			
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';    
    -------------- ItypeState0-----st 4,1----------
        wait until rising_edge(clk);
        Mem_wr	 <= '0';
        Cout	 <= '0'; 
        Cin	 	 <= '1';
        OPC	 	 <= "0000"; 	
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '0';
        RFaddr	 <= "10";  		 
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";	
        Imm1_in	 <= '0';
        Imm2_in	 <= '1';
        Mem_out	 <= '0';			
        done_FSM  <= '0';
        Mem_in <= '0'; 
    -------------- ItypeState1-----st 4,1-----------
        wait until rising_edge(clk);
        Cout	 <= '1'; 
        Cin	 	 <= '0';
        OPC	 	 <= "1111";
        Ain	 	 <= '0';				
        RFaddr	 <= "10";   
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";	
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';				
        done_FSM  <= '0';
        RFout	 <= '0'; 
        Mem_wr	 <= '0'; 
        RFin	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '1';           
    -------------- ItypeState2-------st 4,1---------
        wait until rising_edge(clk);                	
        Cout	 <= '0';
        Cin	 	 <= '0';
        OPC	 	 <= "1111"; 
        Ain	 	 <= '0';				
        RFaddr	 <= "10";   
        IRin	 <= '0';
        PCin	 <= '1';	
        PCsel	 <= "01";	
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0'; 
        Mem_out	 <= '0';	
        RFout	 <= '1'; 
        Mem_wr	 <= '1'; 
        RFin	 <= '0';     
    ------------- Reset -------FINISH-------------		
        wait until rising_edge(clk);
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; -- ALU unaffected
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "00";   -- RF unaffected
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "11";  -- PC = zeros 
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '1';
		wait;
		
	end process;

    WriteToDataMem:process 
		file outDmemfile : text open write_mode is dataMemResult;
		variable    linetomem			: STD_LOGIC_VECTOR(BusSize-1 downto 0);
		variable	good				: BOOLEAN;
		variable 	L 					: LINE;
		variable	TempAddresses		: STD_LOGIC_VECTOR(Awidth-1 downto 0) ; 
	begin 

		wait until done_FSM = '1';  
		TempAddresses := (others => '0');
		while TempAddresses < 3 loop	--3 lines in file
			TBReadAddressDataMem <= TempAddresses;
			wait until rising_edge(clk);   -- 
			wait until rising_edge(clk); -- 
			linetomem := TBdataOutDataMem;   --
			hwrite(L,linetomem);
			writeline(outDmemfile,L);
			TempAddresses := TempAddresses +1;
		end loop ;
		file_close(outDmemfile);
		wait;
	end process;

    end tb;    
	            