# LAB4 - FPGA-based Digital Design

In this lab, we will synthesize a synchronous digital system based on the LAB1 Assignment, which was an ALU and a synchronous PWM Output for the Cyclone V FPGA. We'll focus on optimizing performance and logic usage.

## Digital System Module (The ALU and PWM)

### Inputs:
- Input signal X
- Input signal Y
- Control signal ALUFN:
  - ALUFN[4:3] selects the module:
    - 01: AdderSub
    - 10: Shifter
    - 11: Logic
    - 00: PWM
  - ALUFN[2:0] controls specific operations within each module
  - ALUFN[0] controls the PWM Module
- ENA: controls the enable for the PWM Output
- RST: Resets the counter and Output of the PWM
- CLK: the clock of our Hardware

### Outputs:
- Flags:
  - Z (Zero)
  - C (Carry)
  - N (Negative)
  - V (Overflow)
- ALUout: System output based on the selected module
- PWMout: system output of the PWM signal

## Module Descriptions

### PWM (PWM.vhd)
Performs Pulse Width Modulation based on our input of X and Y and the mode that we choose (set/reset or reset/set).
- X: when our counter starts to set/reset the output based on our mode.
- Y: when our counter resets and also sets/resets the output based on our mode.
- ALUFN[0]:
    - '0' - Set/Reset Mode
    - '1' - Reset/Set Mode

### AdderSub (AdderSub.vhd)
Performs addition or subtraction between signals X and Y based on the sub_cont control signal:
- sub_cont='0': Addition
- sub_cont='1': Subtraction
Also includes a NEG operation (subtraction between X and a zero vector).

### Shifter (Shifter.vhd)
Implements a barrel-shifter-based shift operation:
- ALUFN[2:0] = 000: Left shift
- ALUFN[2:0] = 001: Right shift
Uses a multi-layer approach, where each layer performs a shift based on the corresponding bit in X.

### Logic (Logic.vhd)
Performs various logical operations on X and Y signals based on ALUFN[2:0].

### Top (top.vhd)
Wraps the entire system, routing inputs to appropriate modules and organizing outputs.

### FullAdder (FA.vhd)
Implements a Full Adder component.

## Performance Test Case
To perform timing analysis on the asynchronous system, we'll confine the ALU between two synchronous registers.

## Hardware Test Case
We'll test the ALU on the DE10-Standard FPGA board using switches, keys, LEDs, and 7-segment displays.

### TopIO_Interface (IO_Interface.vhd)
Digital system with I/O interface for hardware testing.

---

Authors: Nachman Mimoun and Daniel Barsheshet