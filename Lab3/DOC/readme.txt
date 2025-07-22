# LAB3 - Digital System Design with VHDL (Multi-stage CPU Design)

In this lab session, we will apply the principles of system design with concurrent and sequential logic that we explored in labs 1 and 2. We will focus on the methodology of separating Control and Datapath for designing a controller-based processing machine configured as a multi-stage CPU to execute specified program code.

### System Controller 

**Inputs:**
* Control Signals from Test Bench: `rst`, `ena`, `clk`
* Initial content for ProgMem
* Initial content for dataMem

**Outputs:**
* Completion Signal to Test Bench: `done`
* Output data from dataMem to a text file

## Top Module (top.vhd)
This module encompasses the Control Unit (Finite State Machine, FSM) and the Datapath unit. The Datapath provides the status registers needed for each instruction, while the FSM generates the control signals for the Datapath to execute the required operations.

## Control Unit (Control.vhd)
This is the central logic unit. It retrieves the operation code necessary for execution and flags the appropriate control signals in the Datapath based on the opcode's status flags, using a synchronized Mealy machine model. The detailed FSM diagram is provided in pre3.pdf.

## Datapath Unit (Datapath.vhd)
Serving as the operational core of the system, it receives opcodes from the program memory, deciphers them through the opcode decoder, and informs the Control Module of the necessary instruction statuses. This module uses both synchronized and asynchronized components to manage tasks.

## Arithmetic Logic Unit (ALU.vhd)
The ALU processes assigned signals corresponding to commands from ProgMem. It is tasked with loading new commands when `IRin='1'`, deciphering the operation from the IR, and handling any necessary offsets and immediate values.

## Full Adder Unit (FA.vhd)
This adder processes three inputs - A, B, and an input carry (C-IN) - and outputs two signals: the sum (S) and the output carry (C-OUT).

## Instruction Register (IR.vhd)
The IR module manages signals related to commands received from ProgMem, updating new commands based on the `IRin` signal and extracting operation codes and other required data from the IR.

## Opcode Decoder (OPCdecoder.vhd)
This decoder interprets the opcode from the IR module, sending the appropriate status flags to the Control Module to facilitate the execution of instructions.

## Program Counter Logic (PCLogic.vhd)
This component advances the program counter (PC) according to the instruction requirements and the PC select multiplexer (PCsel Mux), outputting the read address for the program memory.

## Utility Package (`aux_package.vhd`)
This package contains definitions and components used throughout the lab exercises.

## Acknowledgments
This lab was developed by Nachman Mimoun and Danel Barsheshet.