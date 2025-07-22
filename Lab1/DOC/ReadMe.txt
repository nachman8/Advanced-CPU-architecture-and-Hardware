Lab 1 - VHDL Part 1: Concurrent Code
In this lab, we will acquire fundamental skills in the realm of parallel hardware using the VHDL language. Our objective is to create a system that manages several distinct modules, each operating independently based on a chip select derived from an input signal.

The system module includes the following components:

Inputs:
X: Input signal.
Y: Input signal.
ALUFN: Control signal where ALUFN[4:3] selects the module (01 -> AdderSub, 10 -> Shifter, 11 -> Logic). Each module operates differently based on ALUFN[2:0].

Outputs:
Z: Zero flag.
C: Carry flag.
N: Negative flag.
V: OverFlow flag.
ALUout: System output based on the selected module.

Module Descriptions

AdderSub (AdderSub.vhd)
This module performs addition or subtraction between two signals X and Y of equal lengths using a full adder (FA). The operation is controlled by the sub_cont signal (sub_cont='1' -> SUB, sub_cont='0' -> ADD). Additionally, a NEG operation is included, which subtracts X from a zero vector.

Shifter (Shifter.vhd)
This module executes barrel-shifter-based operations as per the ALUFN input. If ALUFN[2:0] = 000, it performs a left shift; if ALUFN[2:0] = 001, it performs a right shift. The implementation involves multiple layers (k = log_2(n)) where each layer's shift depends on the corresponding bit in X.

Logic (Logic.vhd)
This module carries out various logical operations on X and Y according to the ALUFN input. These operations are synthesizable in VHDL and are straightforward to implement by selecting the appropriate function based on ALUFN[2:0].

Top Module (top.vhd)
The top module integrates the entire system, handling input signals and directing them to the correct module. It also manages the output based on the selected module.

FullAdder (FA.vhd)
This module implements a Full Adder, which is essential for performing addition operations in the AdderSub module.

Auxiliary Package (aux_package.vhd)
This package file contains reusable components and definitions used across the laboratory projects.

Credits
This lab was developed by  Nachman Mimoun and Danel Barsheshet