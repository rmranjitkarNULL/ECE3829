vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../ECE3829_Lab_3.gen/sources_1/ip/clk_wiz_0" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ECE3829_Lab_3.gen/sources_1/ip/clk_wiz_0" \
"../../../ECE3829_Lab_3.srcs/sources_1/new/ALS_PMOD_Sensor.v" \
"../../../ECE3829_Lab_3.srcs/sim_1/new/ALS_PMOD_BFM_tb.v" \

vlog -work xil_defaultlib \
"glbl.v"

