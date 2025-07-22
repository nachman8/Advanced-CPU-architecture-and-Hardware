LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
ENTITY PC IS
    GENERIC(AddrSize		:INTEGER := 8;
            OffsetSize		:INTEGER := 8);
	PORT(	IRoffset 		:IN STD_LOGIC_VECTOR(OffsetSize -1 DOWNTO 0);
			PCsel			:IN STD_LOGIC_VECTOR(1 downto 0);
			PCin, clk		:IN STD_LOGIC;
			PCout			:OUT std_logic_vector(AddrSize -1 downto 0) := "00000000"
			);
END PC;
ARCHITECTURE dataflow OF PC IS
    SIGNAL current_pc,next_pc: STD_LOGIC_VECTOR(AddrSize -1 DOWNTO 0) := (others =>'0');
    SIGNAL offset: STD_LOGIC_VECTOR(OffsetSize -1 DOWNTO 0);
begin
    offset <= IRoffset;     
    pc_process: process (clk) begin
        if(clk'event and clk='1') then
            if(PCin = '1') then
				current_pc <= next_pc;
                end if;
            end if;
    end process;

    pc_input: with PCsel select
        next_pc <=  current_pc +1                           when "01",
                    current_pc +1 + offset                  when "10",
                    (others => '0')                         when "00", --1 state
                    unaffected when others;
    
    PCout<= current_pc;
    end dataflow;    

                