## Clock signal (100 MHz onboard oscillator)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset Button (Center Push Button - btnC)
set_property PACKAGE_PIN U18 [get_ports rst]						
	set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Switches (Sensors & Emergency Interrupt)
set_property PACKAGE_PIN V17 [get_ports emergency]					
	set_property IOSTANDARD LVCMOS33 [get_ports emergency]
set_property PACKAGE_PIN V16 [get_ports sensor_M]					
	set_property IOSTANDARD LVCMOS33 [get_ports sensor_M]
set_property PACKAGE_PIN W16 [get_ports sensor_MT]					
	set_property IOSTANDARD LVCMOS33 [get_ports sensor_MT]
set_property PACKAGE_PIN W17 [get_ports sensor_S]					
	set_property IOSTANDARD LVCMOS33 [get_ports sensor_S]

## LEDs (Traffic Lights Mapping)
# Main Street 1 (light_M1) - LEDs 0 to 2
set_property PACKAGE_PIN U16 [get_ports {light_M1[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_M1[0]}]
set_property PACKAGE_PIN E19 [get_ports {light_M1[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_M1[1]}]
set_property PACKAGE_PIN U19 [get_ports {light_M1[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_M1[2]}]

# Main Street 2 (light_M2) - LEDs 3 to 5
set_property PACKAGE_PIN V19 [get_ports {light_M2[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_M2[0]}]
set_property PACKAGE_PIN W18 [get_ports {light_M2[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_M2[1]}]
set_property PACKAGE_PIN U15 [get_ports {light_M2[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_M2[2]}]

# Main Turn (light_MT) - LEDs 6 to 8
set_property PACKAGE_PIN U14 [get_ports {light_MT[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_MT[0]}]
set_property PACKAGE_PIN V14 [get_ports {light_MT[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_MT[1]}]
set_property PACKAGE_PIN V13 [get_ports {light_MT[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_MT[2]}]

# Side Street (light_S) - LEDs 9 to 11
set_property PACKAGE_PIN V3 [get_ports {light_S[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_S[0]}]
set_property PACKAGE_PIN W3 [get_ports {light_S[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_S[1]}]
set_property PACKAGE_PIN U3 [get_ports {light_S[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {light_S[2]}]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
