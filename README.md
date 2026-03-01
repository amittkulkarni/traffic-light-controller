# Smart Traffic Light Controller on FPGA

## Overview
A hardware-optimized Finite State Machine (FSM) designed to control a 4-way traffic intersection, deployed and synthesized for the **Xilinx Basys 3 FPGA (Artix-7)**. This design moves beyond fixed-timer traffic lights by integrating real-time presence sensors and an asynchronous-like emergency override, ensuring high-efficiency traffic flow and priority lane clearance.

## Key Features & Architecture
* **Sensor-Based Dynamic Timing:** FSM transitions and state durations are dynamically truncated or extended based on `sensor_M`, `sensor_MT`, and `sensor_S` inputs.
* **Emergency Priority Interrupt:** High-priority `emergency` signal forces an immediate transition to a safe `S_EMG` state, granting a green corridor to the main lane while safely holding all other lanes at red.
* **Synchronous Design:** Implemented as a clean 3-always block Moore/Mealy machine, separating state memory, next-state logic, and output logic to ensure predictable synthesis and timing closure.

## FSM State Transitions
![FSM Diagram](docs/fsm_diagram.png)
* **S1 (Main Green):** Defaults to 7s, truncates to 3s if no traffic is present on the main street.
* **S3 (Main Turn Green):** Defaults to 5s, truncates to 2s if empty.
* **S5 (Side Street Green):** Defaults to 3s, truncates to 1s if empty.
* **S_EMG:** Overrides standard sequence to clear emergency paths.

## Hardware & Toolchain
* **RTL:** Verilog (IEEE 1364-2001)
* **EDA Tool:** AMD Vivado Design Suite
* **Target Hardware:** Xilinx Basys 3 (xc7a35tcpg236-1)

## Synthesis & Post-Implementation Results
*Note: The following data was extracted from AMD Vivado post-routing reports.*
* **LUT Utilization:** 25 / 20800 (0.12%)
* **Flip-Flop Utilization:** 7 / 41600 (0.017%)
* **Worst Negative Slack (WNS):** 6.523ns (Timing Met at 100MHz)
* **Total On-Chip Power:** 0.078 W

## Directory Structure
* `/src`: Contains the RTL source (`TLC.v`).
* `/tb`: Contains the self-checking behavioral simulation testbench (`TLC_tb.v`).
* `/constraints`: Basys3 I/O mapping (`basys3_TLC.xdc`).
* `/reports`: Raw Vivado utilization and timing summaries.
* `/docs`: FSM state diagrams and simulation waveforms.

## Simulation & Deployment
To simulate the edge-case scenarios (heavy traffic, dynamic bypass, and emergency interrupt):
1. Import `TLC.v` and `TLC_tb.v` into a Vivado RTL Project.
2. Run Behavioral Simulation. Observe the console outputs mapping to the 3 distinct testing scenarios.
3. For hardware deployment, generate the bitstream using the provided `basys3_TLC.xdc` and flash the Basys 3 board.
