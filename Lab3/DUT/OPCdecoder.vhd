library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
USE work.aux_package.all;
---------------------------------------------------------------
entity OPCdecoder is
    generic( RegSize: integer:=4);
	port(	IROp : in std_logic_vector(RegSize -1 downto 0);
			st, ld, mov, done, add, sub, jmp, jc, jnc, xor_s, or_s, and_s: out std_logic
);
end OPCdecoder;
architecture logic of OPCdecoder is
begin
    add  	<=	'1' when IROp = "0000" else '0';
    sub  	<=	'1' when IROp = "0001" else '0';
    and_s  	<=	'1' when IROp = "0010" else '0';
    or_s    <=  '1' when IROp = "0011" else '0';
    xor_s  	<=	'1' when IROp = "0100" else '0';
    --tbd   <=	'1' when IROp = "0101" else '0';
    --tbd  	<=	'1' when IROp = "0110" else '0';
    jmp     <=  '1' when IROp = "0111" else '0';
    jc  	<=	'1' when IROp = "1000" else '0';
    jnc   	<=  '1' when IROp = "1001" else '0';
    --tbd   <=	'1' when IROp = "1010" else '0';
    --tbd   <=  '1' when IROp = "1011" else '0';  
    mov   	<=  '1' when IROp = "1100" else '0';
    ld   	<=  '1' when IROp = "1101" else '0';
    st   	<=  '1' when IROp = "1110" else '0';
    done   	<=  '1' when IROp = "1111" else '0'; 
    end logic;     