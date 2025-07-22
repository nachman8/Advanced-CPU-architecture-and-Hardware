library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

--------------------------------------------------------------
entity Divide_Unit is

port(	Dividend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Divisor		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Unit_intake : IN 	STD_LOGIC;
		Residue		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Quotient 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		DIVIFG		: OUT 	STD_LOGIC;
		DIVCLK, Reset, Ena	: IN 	STD_LOGIC );

end Divide_Unit;
--------------------------------------------------------------
architecture behav of Divide_Unit is

    COMPONENT  Divide_Control
   	     PORT(		Start 		: OUT 	STD_LOGIC;
					Done 	    : OUT 	STD_LOGIC;
					last 	    : OUT 	STD_LOGIC;
					zero_division   : OUT 	STD_LOGIC;
					DIV_Ena		: OUT 	STD_LOGIC;
					DIV_reset	: OUT 	STD_LOGIC;
					DIVIFG		: IN 	STD_LOGIC;
                    Unit_intake : IN 	STD_LOGIC;
					Divisor		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					DIVCLK, reset,Ena	: IN 	STD_LOGIC );
	END COMPONENT;

--------------------------------------------------------------
SIGNAL  Start	    :STD_LOGIC;
SIGNAL  Ena_s	    :STD_LOGIC;
SIGNAL  DIV_reset 	:STD_LOGIC;
SIGNAL  Done 	    :STD_LOGIC;
SIGNAL  zero_division :STD_LOGIC;
SIGNAL  last 	    :STD_LOGIC;
SIGNAL  Divisor_s	:STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL  Dividend_s	:STD_LOGIC_VECTOR( 63 DOWNTO 0 );
SIGNAL  Residue_s 	:STD_LOGIC_VECTOR( 32 DOWNTO 0 );
SIGNAL  Quotient_s	:STD_LOGIC_VECTOR( 31 DOWNTO 0 );

begin

    Control : Divide_Control
	PORT MAP (	last  	        => last,
				Done  	        => Done,
				Start  	        => Start,
				zero_division   => zero_division,
				DIV_Ena 		=> Ena_s,
				DIV_reset		=> DIV_reset,
                Unit_intake  	=> Unit_intake,
				DIVIFG          => Done,
				Divisor         => Divisor,
				DIVCLK 			=> DIVCLK,  
				reset 			=> reset,
				Ena				=> Ena);

	------ Divisor ------
        process(DIVCLK,DIV_reset,Ena_s)
        begin
            if (DIV_reset='1') then   ------ reset
                Divisor_s <= X"00000000";
                
            elsif (DIVCLK'event and DIVCLK='1' and Start = '1') then
                  Divisor_s <= Divisor;
            end if;
        end process;
    ------ Residue------
	Residue_s <= ('0'& Dividend_s(63 downto 32)) - ('0'&Divisor_s);

    ----- Dividend_s -----
	process(DIVCLK,DIV_reset,Ena_s)
	variable sll_dividend : STD_LOGIC_VECTOR(63 downto 0);
	begin
		if (DIV_reset='1') then   
			Dividend_s <= X"0000000000000000";	-- reset dividend which resets residue as well
		elsif (DIVCLK'event and DIVCLK='1')  then	
			if (Start = '1')  then	
				Dividend_s(63 downto 32) <= X"0000000"&"000"& Dividend(31);
				Dividend_s(31 downto 0) <= Dividend (30 DOWNTO 0) & '0';
			elsif (Ena_s = '1')  then	
				sll_dividend := std_logic_vector(shift_left(unsigned(Dividend_s),1)); -- shl Quotient every cycle; 
				if (Residue_s(32) = '0')  then	
			        Dividend_s(63 downto 33) <= Residue_s(30 downto 0);
					Dividend_s(32 downto 0) <= sll_dividend(32 downto 0);
				else
				    Dividend_s <=sll_dividend;
				end if;	
			elsif (last = '1')  then
				if (Residue_s(32) = '0')  then	
					Dividend_s(63 downto 32) <= Residue_s(31 downto 0);
				end if;	
			elsif (zero_division = '1') then 
				Dividend_s <= X"FFFFFFFFFFFFFFFF";	
			end if;
		end if;
	end process;


    			----- Quotient_s -----
	process(DIVCLK,DIV_reset,Ena_s)
	variable shift_quot : STD_LOGIC_VECTOR(30 downto 0);
	begin
		if (DIV_reset='1') then  
			Quotient_s <= X"00000000"; -- reset Quotient
		elsif (DIVCLK'event and DIVCLK='1' ) then
			if (Start = '1') then
				Quotient_s <= X"0000000"& "000" & not Residue_s(32);
			elsif (Ena_s = '1' or last = '1')  then
				shift_quot := Quotient_s(30 downto 0); -- shl Quotient every cycle
				Quotient_s(0) <= not Residue_s(32);
				Quotient_s(31 downto 1) <= shift_quot;
			elsif (zero_division = '1') then 
				Quotient_s <= X"FFFFFFFF";	
			end if;
		end if;
	end process;
    
        ------- OUTPUT -----------
    Residue <= Dividend_s(63 downto 32);
	Quotient <= Quotient_s;
	DIVIFG <= Done;


END behav;