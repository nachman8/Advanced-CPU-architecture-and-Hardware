library ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

--------------------------------------------------------------
entity Divide_Control is

	PORT(	Start 		: OUT 	STD_LOGIC;
			Done 	    : OUT 	STD_LOGIC;
			last 	    : OUT 	STD_LOGIC;
			zero_division   : OUT 	STD_LOGIC;
			DIV_Ena		: OUT 	STD_LOGIC;
			DIV_reset	: OUT 	STD_LOGIC;
			DIVIFG		: IN 	STD_LOGIC;
			Unit_intake : IN 	STD_LOGIC;
			Divisor		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			DIVCLK, reset,Ena	: IN 	STD_LOGIC );

end Divide_Control;
--------------------------------------------------------------
architecture behav of Divide_Control is

	SIGNAL  counter	:STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	SIGNAL  state	:STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL  next_state	:STD_LOGIC_VECTOR( 2 DOWNTO 0 );
begin

	---------------------- FSM ----------------------------------
	process(DIVCLK,reset,Ena)
	variable count : STD_LOGIC_VECTOR(5 downto 0);
	begin
	  if (reset='1') then
		  state <= "000";   ------ reset state
		  counter <= "000000";
	  elsif (DIVCLK'event and DIVCLK='1' and Ena = '1') then
		  if next_state = "111" then
			 counter <= "000000";
		  elsif (next_state = "010") or (next_state = "100") then
			 count := counter + "000001";
			 counter <= count;
		  end if;
		  state <= next_state;  
	  end if;	
	end process;
	
	process(state,ena,reset,Unit_intake,DIVCLK)
  		begin
		case state is
		-------------reset state--------------------------		
		when "000" =>	
		Start <= '0';
		DIV_Ena <= '0';
		DIV_reset <= '1';
		Done <= '0';
		last <= '0';
		zero_division <= '0';
		next_state <= "001";  
		----------------- waiting state --------------------------			
		when "001" => 
			DIV_Ena <= '0';
			DIV_reset <= '0';
			last <= '0';
			if (Ena = '1' and Unit_intake = '1' and DIVIFG = '0') then
				if (divisor = X"00000000") then
					zero_division <= '1';
					Done <= '1';
					next_state <= "001";
					Start <= '0';
				else
					zero_division <= '0';
					Done <= '0';
					next_state <= "010";
					Start <= '1';
				end if;
			else
				Done <= '0';
				next_state <= "001";  
			end if;

	-------------dividing state--------------------------			
		when "010" =>	 
			Start <= '0';
			DIV_Ena <= '1';
			DIV_reset <= '0';
			Done <= '0';
			last <= '0';  	
			zero_division <= '0';
			if (counter = "011111") then	
				next_state <= "100";
			else
			    next_state <= "010";  
			end if;
		------------- last  state--------------------------			
		when "100" =>	
			Start <= '0';
			DIV_Ena <= '0';
			DIV_reset <= '0';
			Done <= '0';
			last <= '1';
			zero_division <= '0';
			next_state <= "111";  
	------------- finish  state "111" --------------------------			
		when others =>	
		Start <= '0';
		DIV_Ena <= '0';
		DIV_reset <= '0';
		Done <= '1';
		last <= '0';
		zero_division <= '0';
		next_state <= "001";  
	
		END CASE;
	END PROCESS;
END behav;