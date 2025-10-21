`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ryan Ranjitkar
// 
// Create Date: 01/19/2025 03:28:46 PM
// Design Name: 
// Module Name: lab1_top_
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


module lab1_top_(
    // Mode and Value switches, and push button input
    input [15:0] sw,           
    input [3:0] buttons,  
    // 16-bit LED output (led[15:0]), seven segment output, and anode output
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
    );
    
    wire [3:0] dispA, dispB, dispC, dispD;
    
     // Connect sw[15:14] to the mode select input and connect sw[13:0] to the swValue input
    input_select u_input_select (
        .sw(sw[15:14]),          
        .swValue(sw[13:0]),         
        .dispA(dispA),    
        .dispB(dispB),    
        .dispC(dispC),    
        .dispD(dispD)     
    );
    
   // Instantiate the seven_seg module
    seven_seg u_seven_seg (
        .dispA(dispA),    
        .dispB(dispB),   
        .dispC(dispC),    
        .dispD(dispD),    
        .select(buttons),    
        .seg(seg),                
        .an(an)                 
    );
    
    // Assigns each led to its corresponding switch/swValue
    assign led = sw;
    
endmodule
