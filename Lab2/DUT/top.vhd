LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
	signal x_1,x_2 : std_logic_vector(n-1 downto 0); -- x_1 is x(j-1) and x_2 is x(j-2)
	signal j : integer := 0;
	signal valid : std_logic;
	signal a, b, s : std_logic_vector(n-1 downto 0);
	signal cin : std_logic;
	signal cout : std_logic;
	signal detection_code_vector : std_logic_vector(n-1 downto 0); -- Intermediate signal
	
	

begin
	-----process_1--------------

	Two_sample: process(clk,rst,ena,x)
	begin
	if (rst = '1') THEN
	x_1 <= (others => '0');
	x_2 <= (others => '0');
	elsif (clk'event and clk = '1') then
		if ena = '1' then
		x_2 <= x_1;
		x_1 <= x;
		end if;
	end if;
	
	end process;
	
	
	-----process_2--------------
	
    detection_code_process: process(DetectionCode)
    begin
        case DetectionCode is
            when 0 =>
                detection_code_vector <= (others => '0');
            when 1 =>
                detection_code_vector <= (others => '0');
                detection_code_vector(0) <= '1';  -- Equivalent to binary 00000001
            when 2 =>
                detection_code_vector <= (others => '0');
                detection_code_vector(1) <= '1';  -- Equivalent to binary 00000010
            when 3 =>
                detection_code_vector <= (others => '0');
                detection_code_vector(1 downto 0) <= "11";  -- Equivalent to binary 00000011
            when others =>
                detection_code_vector <= (others => '0'); -- Default case, should not occur
        end case;
    end process;
		
	
	Signal_Adder: Adder generic map(length => n) port map(
		a => x_2,
		b => detection_code_vector,
		cin => '1',
		s => s,
		cout => cout
	);

	valid <= '1' when (s = x_1) else '0';
	-----process_3--------------

	m_valid_process: process(clk, rst, ena, valid)
		variable count : integer;
	begin
		if (rst = '1') then
			detector <= '0';
			count := 0;
		elsif (clk'event and clk = '1') then
			if (ena = '1') then
				if (valid = '1') then
					if (count = m) then 
						count := count;
					else
						count := count + 1;
					end if;
				else
					count := 0;
				end if;
			end if;
		end if;

		if (count = m) then
			detector <= '1';
		else
			detector <= '0';
		end if;
	end process;
	
end arc_sys;