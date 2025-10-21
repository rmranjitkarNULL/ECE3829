// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Feb  7 22:07:09 2025
// Host        : AK317A-01 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/rmranjitkar/project_2/project_2.gen/sources_1/ip/clk_mmcm/clk_mmcm_stub.v
// Design      : clk_mmcm
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_mmcm(clk_25MHz, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_25MHz,reset,locked,clk_in1" */;
  output clk_25MHz;
  input reset;
  output locked;
  input clk_in1;
endmodule
