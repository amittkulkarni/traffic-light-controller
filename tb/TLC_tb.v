`timescale 1ns / 1ps

module Traffic_Light_Controller_TB;
    reg clk;
    reg rst;
    reg emergency;
    reg sensor_M;
    reg sensor_MT;
    reg sensor_S;

    wire [2:0] light_M1;
    wire [2:0] light_S;
    wire [2:0] light_MT;
    wire [2:0] light_M2;

    // Instantiate the Device Under Test (DUT)
    Traffic_Light_Controller dut (
        .clk(clk),
        .rst(rst),
        .emergency(emergency),
        .sensor_M(sensor_M),
        .sensor_MT(sensor_MT),
        .sensor_S(sensor_S),
        .light_M1(light_M1),
        .light_S(light_S),
        .light_MT(light_MT),
        .light_M2(light_M2)
    );

    // Clock generation: 10ns period (100MHz, matching Basys3 onboard clock)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Simulation Stimulus
    initial begin
        $display("--- Starting Smart Traffic Light Controller Simulation ---");
        
        // Initialize inputs
        rst = 1;
        emergency = 0;
        sensor_M = 1;
        sensor_MT = 1;
        sensor_S = 1;
        #20 rst = 0;

        // SCENARIO 1: Maximum Traffic (All sensors HIGH)
        // Verifies the FSM hits the maximum time constraints (sec7, sec5, etc.)
        $display("\n[Time: %0t] SCENARIO 1: Heavy Traffic (Max Wait Times)", $time);
        #300; 

        // SCENARIO 2: Dynamic Timing Optimization (Empty Lanes)
        // Verifies the FSM cuts green lights short when no traffic is detected
        $display("\n[Time: %0t] SCENARIO 2: Dynamic Timing (No Traffic Detected)", $time);
        sensor_M = 0;
        sensor_MT = 0;
        sensor_S = 0;
        #150; 

        // SCENARIO 3: Emergency Vehicle Priority Interrupt
        // Verifies the FSM abandons its current state and jumps to S_EMG safely
        $display("\n[Time: %0t] SCENARIO 3: Emergency Override Triggered", $time);
        emergency = 1;
        #60; // Hold emergency state for a few cycles
        
        $display("\n[Time: %0t] Emergency Cleared. Resuming Normal Operation.", $time);
        emergency = 0; 
        sensor_M = 1; // Restore main traffic
        #150;

        $display("--- Simulation Complete ---");
        $finish;
    end
    
    // Output Monitoring
    initial begin
        $monitor("Time=%0t | rst=%b emg=%b sens_M/MT/S=%b%b%b | Outputs(M1,M2,MT,S): %b %b %b %b", 
                 $time, rst, emergency, sensor_M, sensor_MT, sensor_S, 
                 light_M1, light_M2, light_MT, light_S);
    end
endmodule
