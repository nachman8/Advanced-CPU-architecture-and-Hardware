LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;

ENTITY PWM IS
  GENERIC (n : INTEGER := 8); 
  PORT (
    Y_i, X_i: IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
    ALUFN, clk, rst, ena: IN STD_LOGIC;
    state: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    PWM_out: OUT STD_LOGIC
  );
END PWM;

ARCHITECTURE struct OF PWM IS 
  SIGNAL counter: INTEGER := 0;
  SIGNAL pwm_sig: STD_LOGIC := '0';
  SIGNAL x_int, y_int: INTEGER := 0;
BEGIN
  -- Convert STD_LOGIC_VECTOR to INTEGER
  x_int <= CONV_INTEGER(unsigned(X_i));
  y_int <= CONV_INTEGER(unsigned(Y_i));

  PROCESS(clk, rst)
  BEGIN
    IF rst = '1' THEN   --- reset counter and reset PWM out
      counter <= 0;
      pwm_sig <= '0';
    elsif (state = "00001") or (state = "00000") THEN ---- PWM Mode
      if x_int >= y_int THEN   ---- Wrong X can't be greater than Y
        counter <= 0;
        pwm_sig <= '0';
      ELSIF rising_edge(clk) THEN
        IF ena = '1' THEN  ------ Start counter only if enable is ON
          counter <= counter + 1;
          IF counter >= y_int THEN 
            counter <= 0;
          END IF;
          IF counter < x_int THEN 
            IF ALUFN = '0' THEN ----mode 0
              pwm_sig <= '0';
            ELSE                ------mode 1
              pwm_sig <= '1';
            END IF;
          ELSE          ----if counter > X
            IF ALUFN = '0' THEN  ----mode 0
              pwm_sig <= '1';
            ELSE                ------mode 1
              pwm_sig <= '0';
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
    END PROCESS;

  PWM_out <= pwm_sig;
END struct;
