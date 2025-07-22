library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 

entity counter is 
    port (
        clk, enable : in std_logic;    
        q   : out std_logic
    ); 
end counter;

architecture rtl of counter is
    signal q_int : std_logic_vector (5 downto 0):="000000";
begin
    process (clk)
    begin
        if (clk'event and clk='1') then
            if enable = '1' then	 
                q_int <= q_int + 1; -- Increment counter
            end if;
        end if;
    end process;
    q <= q_int(5); 
end rtl;



-- Quartus II VHDL Template
-- Single port RAM with single read/write address 


--entity single_port_ram is
--
--	generic 
--	(
--		DATA_WIDTH : natural := 8;
--		ADDR_WIDTH : natural := 6
--	);
--
--	port 
--	(
--		clk		: in std_logic;
--		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
--		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
--		we		: in std_logic := '1';
--		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
--	);
--
--end entity;
--
--architecture rtl of single_port_ram is
--
--	-- Build a 2-D array type for the RAM
--	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
--	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;
--
--	-- Declare the RAM signal.	
--	signal ram : memory_t;
--
--	-- Register to hold the address 
--	signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;
--
--begin
--
--	process(clk)
--	begin
--	if(rising_edge(clk)) then
--		if(we = '1') then
--			ram(addr) <= data;
--		end if;
--
--		-- Register the address for reading
--		addr_reg <= addr;
--	end if;
--	end process;
--
--	q <= ram(addr_reg);
--
--end rtl;
