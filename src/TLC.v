`timescale 1ns / 1ps

module Traffic_Light_Controller(
    input wire clk,
    input wire rst,
    input wire emergency,       // High-priority emergency vehicle interrupt
    input wire sensor_M,        // Traffic presence sensor: Main Street
    input wire sensor_MT,       // Traffic presence sensor: Main Turn
    input wire sensor_S,        // Traffic presence sensor: Side Street
    output reg [2:0] light_M1,
    output reg [2:0] light_S,
    output reg [2:0] light_MT,
    output reg [2:0] light_M2 
);

    localparam [2:0] 
        S1    = 3'd0, // M1/M2 Green
        S2    = 3'd1, // M1/M2 Yellow
        S3    = 3'd2, // M1 & MT Green
        S4    = 3'd3, // M1 & MT Yellow
        S5    = 3'd4, // S Green
        S6    = 3'd5, // S Yellow
        S_EMG = 3'd6; // Emergency State Override

    // Timing parameters
    localparam [3:0] 
        SEC7 = 4'd7,
        SEC5 = 4'd5,
        SEC3 = 4'd3,
        SEC2 = 4'd2,
        SEC1 = 4'd1;

    reg [2:0] ps, ns;
    reg [3:0] count;

    // Sequential Logic: State Memory & Timer
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ps <= S1;
            count <= 4'd0;
        end else if (emergency) begin
            ps <= S_EMG;       // Immediate asynchronous-like jump on clock edge
            count <= 4'd0;
        end else begin
            if (ps != ns) begin
                ps <= ns;
                count <= 4'd0; // Auto-reset timer on state transition
            end else begin
                count <= count + 1'b1;
            end
        end
    end

    // Combinational Logic: Next State & Dynamic Timing
    always @(*) begin
        ns = ps; // Default to staying in the current state
        case (ps)
            S1: begin
                // Dynamic Timing: Wait full SEC7 if traffic is present, otherwise cut short to SEC3
                if (count >= SEC7 || (count >= SEC3 && !sensor_M)) 
                    ns = S2;
            end
            S2: begin
                if (count >= SEC2) ns = S3;
            end
            S3: begin
                if (count >= SEC5 || (count >= SEC2 && !sensor_MT)) 
                    ns = S4;
            end
            S4: begin
                if (count >= SEC2) ns = S5;
            end
            S5: begin
                if (count >= SEC3 || (count >= SEC1 && !sensor_S)) 
                    ns = S6;
            end
            S6: begin
                if (count >= SEC2) ns = S1;
            end
            S_EMG: begin
                // Hold in emergency state until the interrupt signal clears
                if (!emergency) ns = S1;
            end
            default: ns = S1;
        endcase
    end

    // Combinational Logic: Outputs
    always @(*) begin
        // Default assignment to prevent unintended latches and ensure safe failure
        light_M1 = 3'b100; // RED
        light_M2 = 3'b100; // RED
        light_MT = 3'b100; // RED
        light_S  = 3'b100; // RED
        
        case (ps)
            S1: begin
                light_M1 = 3'b001;
                light_M2 = 3'b001;
            end
            S2: begin
                light_M1 = 3'b001;
                light_M2 = 3'b010; // Yellow
            end
            S3: begin
                light_M1 = 3'b001;
                light_MT = 3'b001;
            end
            S4: begin
                light_M1 = 3'b010; // Yellow
                light_MT = 3'b010; // Yellow
            end
            S5: begin
                light_S  = 3'b001;
            end
            S6: begin
                light_S  = 3'b010; // Yellow
            end
            S_EMG: begin
                // Emergency Priority: Main lanes forced green, all others held red
                light_M1 = 3'b001; 
                light_M2 = 3'b001;
            end
        endcase
    end                         
endmodule
