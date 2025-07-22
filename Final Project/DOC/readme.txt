# MIPS-based MCU Architecture Final Project

## Overview

This project implements a MIPS-based Microcontroller Unit (MCU) with a single-cycle CPU architecture on an Altera FPGA board. The design incorporates multiple peripheral components interacting with the CPU to perform various tasks, including I/O operations, timing functions, and interrupt management.

### Key Objectives

- Develop a functional MCU capable of executing the MIPS instruction set
- Implement efficient interrupt management
- Interface with external devices through GPIO and specialized peripherals
- Synthesize and test the design on an Altera FPGA board

## System Architecture

The system uses a Harvard architecture with separate instruction (ITCM) and data (DTCM) memories, both with 1-cycle read/write latency.

### Core Components

1. **CPU (Central Processing Unit)**
   - Single-cycle MIPS-based processor
   - Executes standard MIPS ISA
   - Interfaces with memory-mapped I/O
   - Supports interrupt handling

2. **GPIO (General Purpose Input/Output)**
   - Interfaces with LEDs, 7-segment displays, switches, and pushbuttons
   - Uses memory-mapped I/O approach

3. **Basic Timer**
   - Provides timing functions with output compare capability
   - Programmable registers for flexible timing control
   - Generates interrupts based on timer events

4. **Unsigned Binary Division Accelerator**
   - Performs multi-cycle unsigned division operations
   - Offloads complex calculations from the main CPU

5. **Interrupt Controller**
   - Manages interrupt requests from various sources
   - Supports prioritization and masking of interrupts


## Implementation Details

- Structural descriptions for top-level design and MIPS core
- Comprehensive testbench for simulation and validation
- Emphasizes proper clock management and reset functionality
- Efficient interrupt handling mechanism

## Testing and Verification

- Simulation using ModelSim
- Hardware verification on Altera FPGA board
- Use of SignalTap for real-time signal analysis

## Project Structure

Certainly! I'll format the README to make it more visually appealing and easier to read. Here's a nicely formatted version:
markdownCopy# MIPS-based MCU Architecture Final Project

## Overview

This project implements a MIPS-based Microcontroller Unit (MCU) with a single-cycle CPU architecture on an Altera FPGA board. The design incorporates multiple peripheral components interacting with the CPU to perform various tasks, including I/O operations, timing functions, and interrupt management.

### Key Objectives

- Develop a functional MCU capable of executing the MIPS instruction set
- Implement efficient interrupt management
- Interface with external devices through GPIO and specialized peripherals
- Synthesize and test the design on an Altera FPGA board

## System Architecture

The system uses a Harvard architecture with separate instruction (ITCM) and data (DTCM) memories, both with 1-cycle read/write latency.

### Core Components

1. **CPU (Central Processing Unit)**
   - Single-cycle MIPS-based processor
   - Executes standard MIPS ISA
   - Interfaces with memory-mapped I/O
   - Supports interrupt handling

2. **GPIO (General Purpose Input/Output)**
   - Interfaces with LEDs, 7-segment displays, switches, and pushbuttons
   - Uses memory-mapped I/O approach

3. **Basic Timer**
   - Provides timing functions with output compare capability
   - Programmable registers for flexible timing control
   - Generates interrupts based on timer events

4. **Unsigned Binary Division Accelerator**
   - Performs multi-cycle unsigned division operations
   - Offloads complex calculations from the main CPU

5. **Interrupt Controller**
   - Manages interrupt requests from various sources
   - Supports prioritization and masking of interrupts

6. **USART (Universal Synchronous/Asynchronous Receiver/Transmitter)**
   - Implements UART mode for serial communication (Bonus feature)
   - Supports programmable baud rate and independent transmit/receive operations

## Implementation Details

- Structural descriptions for top-level design and MIPS core
- Comprehensive testbench for simulation and validation
- Emphasizes proper clock management and reset functionality
- Efficient interrupt handling mechanism

## Testing and Verification

- Simulation using ModelSim
- Hardware verification on Altera FPGA board
- Use of SignalTap for real-time signal analysis

## Contributors

Nachman Mimoun
Danel Barsheshet
