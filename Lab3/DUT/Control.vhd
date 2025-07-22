LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
ENTITY Control IS
	PORT(
		st, ld, mov, done, add, and_s, or_s, xor_s, sub, jmp, jc, jnc, Cflag, Zflag, Nflag : in std_logic;
		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in : out std_logic;
		OPC : out std_logic_vector(3 downto 0);
		PCsel, RFaddr : out std_logic_vector(1 downto 0);
		clk, rst, ena : in STD_LOGIC;
		done_FSM : out std_logic
	);
END Control;
---------------------------------------------------------------
ARCHITECTURE behav OF Control IS
	TYPE state IS (	Fetch, Decode, Reset,
                    RtypeState_0, RtypeState_1,
					ItypeState_0, ItypeState_1, ItypeState_2);
	SIGNAL prv_state, nxt_state: state;
	SIGNAL temp: STD_LOGIC;
	
BEGIN
----------change state on clock rising-------------------------
    state_process : process(clk, rst)
    begin
        if (rst='1') then
            prv_state <= Reset;
        elsif (clk'EVENT AND clk='1' and ena = '1') then
            prv_state <= nxt_state;
			report "prv state = " & to_string(prv_state)
			& LF & "time =       " & to_string(now) ;
        end if;
    end process;
-----------------FSM logic-------------------
    FSM : process(prv_state, st, ld, mov, done, and_s, or_s, xor_s, add, sub, jmp, jc, jnc, Cflag, Zflag, Nflag)
	begin
        case prv_state is
---------------- Reset ---------------------
            when Reset =>
				if done = '0' then
                    Mem_wr	 <= '0';
					Cout	 <= '0';
					Cin	 	 <= '0';
					OPC	 	 <= "1111";  -- unaffected
					Ain	 	 <= '0';
					RFin	 <= '0';
					RFout	 <= '0';
					RFaddr	 <= "00";   -- unaffected 
					IRin	 <= '0';
					PCin	 <= '1';
					PCsel	 <= "00";   -- PC = zeros
					Imm1_in	 <= '0';
					Imm2_in	 <= '0';
					Mem_out	 <= '0';
					Mem_in	 <= '0';
					done_FSM <= '0';
					nxt_state <= Fetch;
				end if;
---------------- Fetch ---------------------
			when Fetch =>
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
                nxt_state <= Decode;   
---------------- Decode --------------------
            when Decode =>
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; -- unaffected
				Ain	 	 <= '0'; 
				RFin	 <= '0';
				RFout	 <= '0';  
				RFaddr	 <= "01";   -- rb out
				IRin 	 <= '0';
				PCin	 <= '0';
				PCsel	 <= "01";	-- PC = PC + 1			
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				done_FSM  <= '0';
         ---- next state logic
            ---- Rtype
				if (add = '1' or sub = '1' or and_s = '1' or or_s = '1' or xor_s = '1') then 
                Ain 	<= '1';
                RFout	<= '1';
                nxt_state <=  RtypeState_0;
            ---- Jtype
                elsif (jmp = '1' or jc = '1' or jnc = '1') then -- check if j type instruction is written
                    if (jmp = '1') or (jc = '1' and Cflag = '1') or  (jnc = '1' and Cflag = '0')  then --validate j type conidtion
                        PCsel <= "10"; 
                    end if;
                    PCin <= '1';
                    nxt_state <= Fetch;
            ---- Itype
				elsif mov = '1' then
					RFin	 <= '1';
					PCin	 <= '1';	
					RFaddr	 <= "10";   
					Imm1_in	 <= '1';
					nxt_state <= Fetch;
				elsif (ld = '1' or st = '1') then	
					Ain	 	 <= '1';
					RFout	 <= '1';						
					nxt_state <= ItypeState_0;
				elsif done = '1' then
					PCin	 <= '0';
					done_FSM <= '1';
					nxt_state <= Reset;
				else
					nxt_state <= Fetch;
				end if;
-------------- RtypeState0------------------
            when RtypeState_0 =>		
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
            ---- OPC
                if add = '1' then 
					OPC <= "0000";
				elsif sub = '1' then
					OPC <= "0001";
				elsif and_s = '1' then
					OPC <= "0010";
                elsif or_s = '1' then
                    OPC <= "0011";
                elsif xor_s = '1' then
                    OPC <= "0100";
             -- elsif tbd = '1' then
             --    OPC <= "0101";
             -- elsif tbd = '1' then
             --    OPC <= "0110"; 
                else
                    OPC <= "1111";
                    end if;
                nxt_state <= RtypeState_1;    
-------------- RtypeState1------------------
            when RtypeState_1 =>
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
				nxt_state <= Fetch; 
-------------- ItypeState0------------------
            when ItypeState_0 =>    
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
                nxt_state <= ItypeState_1;
-------------- ItypeState1------------------
            when ItypeState_1 =>
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
				if ld = '1' then
					Mem_out	 <= '0';  
					RFin	 <= '0'; 
					RFout	 <= '0'; 
					Mem_wr	 <= '0';
					Mem_in	 <= '0';
				elsif st  = '1' then
					RFout	 <= '0'; 
					Mem_wr	 <= '0'; 
					RFin	 <= '0';
					Mem_out	 <= '0';
					Mem_in	 <= '1';  
				end if;
				nxt_state <= ItypeState_2;
-------------- ItypeState2------------------                
            when ItypeState_2 =>		
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
				if ld = '1' then
					Mem_wr	 <= '0'; 
					Mem_out	 <= '1';  
					RFin	 <= '1';
					RFout <= '0';
				elsif st  = '1' then
					Mem_out	 <= '0';	
					RFout	 <= '1'; 
					Mem_wr	 <= '1'; 
					RFin	 <= '0';
				end if;
				nxt_state <= Fetch;
                end case;
	    end process;

end behav;	