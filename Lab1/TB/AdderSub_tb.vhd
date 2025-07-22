LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY AdderSub_tb IS
END AdderSub_tb;

ARCHITECTURE behavior OF AdderSub_tb IS 

  -- Component Declaration for the Unit Under Test (UUT)
  COMPONENT AdderSub
  PORT(
       x : IN  std_logic_vector(7 downto 0);
       y : IN  std_logic_vector(7 downto 0);
       sub_cont : IN  std_logic_vector(2 downto 0);
       cout : OUT  std_logic;
       s : OUT  std_logic_vector(7 downto 0)
      );
  END COMPONENT;

  --Inputs
  signal x : std_logic_vector(7 downto 0) := (others => '0');
  signal y : std_logic_vector(7 downto 0) := (others => '0');
  signal sub_cont : std_logic_vector(2 downto 0) := (others => '0');

  --Outputs
  signal cout : std_logic;
  signal s : std_logic_vector(7 downto 0);

BEGIN

  -- Instantiate the Unit Under Test (UUT)
  uut: AdderSub PORT MAP (
       x => x,
       y => y,
       sub_cont => sub_cont,
       cout => cout,
       s => s
      );

  -- Stimulus process
  stim_proc: process
  begin     
    -- Test case 1: Addition
    x <= "00000100";
    y <= "00000010";
    sub_cont <= "000";
    wait for 10 ns;
    assert(s = "00000110" and cout = '0')
      report "Test case 1 failed" severity error;

    -- Test case 2: Subtraction
    x <= "00000010";
    y <= "00000100";
    sub_cont <= "001";
    wait for 10 ns;
    assert(s = "00000010" and cout = '1')
      report "Test case 2 failed" severity error;
	
	
	    -- Test case 2.2: Subtraction 
    x <= "00000100"; -- 4
    y <= "00000010"; -- 2
    sub_cont <= "001"; -- Subtraction mode
    wait for 10 ns;
    assert(s = "11111110" and cout = '1')  -- 2 - 4 = -2 (negative result)
      report "Test case 2 failed" severity error;




    -- Test case 3: Overflow
    x <= "11111111";
    y <= "00000001";
    sub_cont <= "000";
    wait for 10 ns;
    assert(s = "00000000" and cout = '1')
      report "Test case 3 failed" severity error;

    -- Test case 4: Zero value
    x <= "00000000";
    y <= "00000000";
    sub_cont <= "000";
    wait for 10 ns;
    assert(s = "00000000" and cout = '0')
      report "Test case 4 failed" severity error;
	  
	-- Test case 6: Zero subtraction (Y - X)
    x <= "00000000"; -- 0
    y <= "00000000"; -- 0
    sub_cont <= "001"; -- Subtraction mode
    wait for 10 ns;
    assert(s = "00000000" and cout = '0')  -- 0 - 0 = 0
      report "Test case 6 failed" severity error;  
	  
	    -- Test case 8: Addition with large numbers
    x <= "10000000"; -- 128
    y <= "10000000"; -- 128
    sub_cont <= "000"; -- Addition mode
    wait for 10 ns;
    assert(s = "00000000" and cout = '1')  -- 128 + 128 = 256 (with overflow)
      report "Test case 8 failed" severity error;  



    wait;
  end process;

END;
