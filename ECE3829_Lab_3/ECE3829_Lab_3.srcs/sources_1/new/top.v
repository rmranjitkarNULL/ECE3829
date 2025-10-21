`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 07:50:04 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    input btnC,
    output [6:0] seg,            
    output [3:0] an,
    
    //PMOD_ALS Sensor Ports
    input JC3,
    output JC1,
    output JC4
    );
    
   wire clk_10MHz;
   wire [7:0] sensor_val;
   wire reset_n;      
    
    clock_gen clk_mmcm
    (
        .clk_10MHz(clk_10MHz), 
        .reset_n(reset_n),
        .btnC(btnC),
        .clk(clk)
    );
    
    sensor_interface pmod_als
    (
        .clk(clk_10MHz),
        .reset_n(reset_n),
        .sdo(JC3),
        .sclk(JC4),
        .cs_n(JC1),
        .sensor_val(sensor_val)
    );
        
    seven_seg_display seven_seg
    (
        .clk(clk_10MHz),                      
        .reset_n(reset_n),                  
        .an(an),                
        .seg(seg),              
        .sensor_val(sensor_val)
    );  
    
    
    
endmodule
