library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tbControl is
end tbControl;

architecture controltb of tbControl is
	signal		clk, rst, ena, st, ld, mov, done, add, and_s, or_s, xor_s, sub, jmp, jc, jnc, Cflag, Zflag, Nflag:  std_logic;
	signal		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in :  std_logic;
	signal		OPC :  std_logic_vector(3 downto 0);
	signal 		PCsel, RFaddr:  std_logic_vector(1 downto 0);
	SIGNAL      done_FSM:		std_logic := '0';

    begin
        ControlUnit: Control 	port map(st, ld, mov, done, add, and_s, or_s, xor_s, sub, jmp, jc, jnc, Cflag, Zflag, Nflag,
                                        IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in,
                                        OPC, PCsel, RFaddr,
                                        clk, rst, ena, done_FSM
                                        );
        gen_rst : process	-- reset process
                begin
                rst <='1','0' after 100 ns;	-- reset at the begining of the system
                wait;
                end process; 
                
                
                gen_clk : process	-- Clk process (duty cycle of 50% and period of 100 ns)
                begin
                clk <= '1';
                wait for 50 ns;
                clk <= not clk;
                wait for 50 ns;
                end process;
                
                ena <= '1';

        --------------- Commands ---------------------		
		add_cmd : process
        begin
		  add <='0', '1' after 100 ns, '0' after 500 ns;
		  wait;
        end process; 
		
		sub_cmd : process
        begin
		  sub <='0','1' after 500 ns, '0' after 900 ns;
		  wait;
        end process;
		
		and_cmd : process
        begin
        and_s <='0','1' after 900 ns, '0' after 1300 ns;
		  wait;
        end process;
		
		
		or_cmd : process
        begin
		  or_s <='0','1' after 1300 ns, '0' after 1700 ns;
		  wait;
        end process;
		
		
		xor_cmd : process
        begin
		  xor_s <='0','1' after 1700 ns, '0' after 2100 ns;
		  wait;
        end process;
		
		jmp_cmd : process
        begin
		  jmp <='0','1' after 2100 ns, '0' after 2300 ns;
		  wait;
        end process;
		
		jc_cmd : process
        begin
		  jc <='0','1' after 2300 ns, '0' after 2500 ns;
		  wait;
        end process;

        jnc_cmd : process
        begin
		  jnc <='0','1' after 2500 ns, '0' after 2700 ns;
		  wait;
        end process;
		
        mov_cmd : process
        begin
		  mov <='0','1' after 2700 ns, '0' after 2900 ns;
		  wait;
        end process;   

		ld_cmd : process
        begin
		  ld <='0','1' after 2900 ns, '0' after 3400 ns;
		  wait;
        end process;

        st_cmd : process
        begin
		  st <='0','1' after 3400 ns, '0' after 3900 ns;
		  wait;
        end process;
		
		done_cmd : process
        begin
		  done <='0','1' after 3900 ns;
		  wait;
        end process; 
        
    end controltb;
