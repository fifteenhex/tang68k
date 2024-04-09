//File Title: Timing Constraints file

create_clock -name ext_clk -period 20 -waveform {0 10} [get_ports {ext_clk}]
//create_clock -name clk_cpu -period 40 -waveform {0 20} [get_nets {clk_cpu}]
