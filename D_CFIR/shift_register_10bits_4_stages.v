module shift_register_10bits_4_stages(CLK,din, Q1, Q2, Q3, Q4,Reset);
    
    
    input CLK,Reset;
    input [9:0] din;  
    output [9:0] Q1, Q2, Q3, Q4;
    wire [9:0] out1, out2, out3, out4;
    
    D_FlipFlop_10bits K1(.D(din),.CLK(CLK),.Q(out1),.Reset(Reset));
    D_FlipFlop_10bits K2(.D(out1),.CLK(CLK),.Q(out2),.Reset(Reset));
    D_FlipFlop_10bits K3(.D(out2),.CLK(CLK),.Q(out3),.Reset(Reset));
    D_FlipFlop_10bits K4(.D(out3),.CLK(CLK),.Q(out4),.Reset(Reset));


    assign Q1=out1;
    assign Q2=out2;
    assign Q3=out3;
    assign Q4=out4;

endmodule
