library ieee;
use ieee.std_logic_1164.all;

entity Divide_Connection is
    port ( DIVCLK, Reset                : in STD_LOGIC;
        MemRead, MemWrite, Divider_CS   : in STD_LOGIC;
        DIVIFG                          : out STD_LOGIC; 
        AddrBus						    : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		DataBus						    : INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0));

        end Divide_Connection;

architecture Divide_Connection_flow of Divide_Connection is

    component Divide_Unit is

        port(	Dividend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Divisor		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Unit_intake : IN 	STD_LOGIC;
                Residue		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Quotient 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                DIVIFG		: OUT 	STD_LOGIC;
                DIVCLK, Reset, Ena	: IN 	STD_LOGIC );        
        end component;

signal dividend_s,divisior_s,quotient_s,residue_s,residue_register,quotient_register,data_in,data_out : STD_LOGIC_VECTOR(31 downto 0);
signal DIVIFG_s,clock_s,unit_intake_s : STD_LOGIC;
signal data_type :STD_LOGIC_VECTOR(1 downto 0);

-----pll use clock_s
begin
    DIVIFG   <= DIVIFG_s;
    clock_s  <= DIVCLK;
    data_in  <= DataBus when (MemWrite ='1' and Divider_CS = '1') else (others => 'Z');
    DataBus  <= data_out when (MemRead ='1' and Divider_CS = '1') else (others => 'Z');

    Divide_module: Divide_Unit Port map (Dividend => dividend_s, Divisor => divisior_s, Unit_intake => unit_intake_s, Residue => residue_s, Quotient => quotient_s,
                                     DIVIFG => DIVIFG_s, DIVCLK => clock_s, Reset => Reset, Ena => '1');
   
    data_type <= "00" WHEN AddrBus = X"82C" else -- Dividend
                 "01" WHEN AddrBus = X"830" else -- Divisor
                 "10" WHEN AddrBus = X"834" else -- Quotient
                 "11" WHEN AddrBus = X"838" else -- Residue
                 "ZZ";                    

    
    process (DIVCLK,Reset,DIVIFG_s)
    begin
        if (Reset='1') then   -- reset all registers
			quotient_register <= X"00000000";
            residue_register <= X"00000000";
            unit_intake_s    <= '0';
            data_out <= (others => 'Z');	
		elsif (DIVCLK'event and DIVCLK='1' and DIVIFG_s ='1')  then	
			residue_register <= residue_s;	
			quotient_register <= quotient_s;
        ELSIF falling_edge(DIVCLK) and (Divider_CS = '1') then
            if (MemWrite = '1') then
                if data_type = "00" then
                    dividend_s <= data_in;
                elsif data_type = "01" then
                    divisior_s <= data_in;
                    unit_intake_s <= '1';
                end if;
            elsif (MemRead = '1') then
                if data_type = "10" then
                    data_out <= quotient_register;
                    unit_intake_s <= '0';
                elsif data_type = "11" then
                    data_out <= residue_register;
                    unit_intake_s <= '0';
                else
                    data_out <= (others => 'Z');
                    unit_intake_s <= '0';
                end if;
            end if;
        elsif falling_edge(DIVCLK) then
            unit_intake_s <= '0';   
        end if;
    end process;

    end Divide_Connection_flow;
                
                
            

                    
