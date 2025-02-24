`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2021 11:10:34 AM
// Design Name: 
// Module Name: in_shift_reg
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


module shift_register_16bit_4_stages(CLK,din, Q1, Q2, Q3, Q4, Reset);
    
    
    input CLK,Reset;
    input [15:0] din;  
    output [15:0] Q1, Q2, Q3, Q4;
    wire [15:0] out1, out2, out3;
    
    D_FlipFlop_16bits K1(.D(din),.CLK(CLK),.Q(out1),.rst(Reset));
    D_FlipFlop_16bits K2(.D(out1),.CLK(CLK),.Q(out2),.rst(Reset));
    D_FlipFlop_16bits K3(.D(out2),.CLK(CLK),.Q(out3),.rst(Reset));
    D_FlipFlop_16bits K4(.D(out3),.CLK(CLK),.Q(Q4),.rst(Reset));


    assign Q1=out1;
    assign Q2=out2;
    assign Q3=out3;
endmodule
