`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Georgia Institute of Technology
// Engineer: Xiangyu Mao
// 
// Create Date: 04/09/2023 
// Design Name: 
// Module Name: in_shift_reg
// Project Name: Beamforming
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_register_32_stages(
    CLK,din,rst,
    Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, 
    Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, 
    Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, 
    Q25, Q26, Q27, Q28, Q29, Q30, Q31, Q32);
    
    
    input CLK,rst;
    input [15:0] din;  
    output [15:0] Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16; 
    output [15:0] Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31, Q32;
    wire [15:0] out1, out2, out3, out4;
    wire [15:0] out5, out6, out7, out8;
    wire [15:0] out9, out10, out11, out12;
    wire [15:0] out13, out14, out15, out16;
    wire [15:0] out17, out18, out19, out20;
    wire [15:0] out21, out22, out23, out24;
    wire [15:0] out25, out26, out27, out28;
    wire [15:0] out29, out30, out31, out32;
    
    D_FlipFlop_16bits K1(.D(din),.CLK(CLK), .Q(out1),.rst(rst));
    D_FlipFlop_16bits K2(.D(out1),.CLK(CLK),.Q(out2),.rst(rst));
    D_FlipFlop_16bits K3(.D(out2),.CLK(CLK),.Q(out3),.rst(rst));
    D_FlipFlop_16bits K4(.D(out3),.CLK(CLK),.Q(out4),.rst(rst));
    D_FlipFlop_16bits K5(.D(out4),.CLK(CLK),.Q(out5),.rst(rst));
    D_FlipFlop_16bits K6(.D(out5),.CLK(CLK),.Q(out6),.rst(rst));    
    D_FlipFlop_16bits K7(.D(out6),.CLK(CLK),.Q(out7),.rst(rst));
    D_FlipFlop_16bits K8(.D(out7),.CLK(CLK),.Q(out8),.rst(rst));
    D_FlipFlop_16bits K9(.D(out8),.CLK(CLK),.Q(out9),.rst(rst));
    D_FlipFlop_16bits K10(.D(out9),.CLK(CLK),.Q(out10),.rst(rst));
    D_FlipFlop_16bits K11(.D(out10),.CLK(CLK),.Q(out11),.rst(rst));
    D_FlipFlop_16bits K12(.D(out11),.CLK(CLK),.Q(out12),.rst(rst));
    D_FlipFlop_16bits K13(.D(out12),.CLK(CLK),.Q(out13),.rst(rst));
    D_FlipFlop_16bits K14(.D(out13),.CLK(CLK),.Q(out14),.rst(rst));    
    D_FlipFlop_16bits K15(.D(out14),.CLK(CLK),.Q(out15),.rst(rst));
    D_FlipFlop_16bits K16(.D(out15),.CLK(CLK),.Q(out16),.rst(rst));
    D_FlipFlop_16bits K17(.D(out16),.CLK(CLK),.Q(out17),.rst(rst));
    D_FlipFlop_16bits K18(.D(out17),.CLK(CLK),.Q(out18),.rst(rst));
    D_FlipFlop_16bits K19(.D(out18),.CLK(CLK),.Q(out19),.rst(rst));
    D_FlipFlop_16bits K20(.D(out19),.CLK(CLK),.Q(out20),.rst(rst));
    D_FlipFlop_16bits K21(.D(out20),.CLK(CLK),.Q(out21),.rst(rst));
    D_FlipFlop_16bits K22(.D(out21),.CLK(CLK),.Q(out22),.rst(rst));    
    D_FlipFlop_16bits K23(.D(out22),.CLK(CLK),.Q(out23),.rst(rst));
    D_FlipFlop_16bits K24(.D(out23),.CLK(CLK),.Q(out24),.rst(rst));
    D_FlipFlop_16bits K25(.D(out24),.CLK(CLK),.Q(out25),.rst(rst));
    D_FlipFlop_16bits K26(.D(out25),.CLK(CLK),.Q(out26),.rst(rst));
    D_FlipFlop_16bits K27(.D(out26),.CLK(CLK),.Q(out27),.rst(rst));
    D_FlipFlop_16bits K28(.D(out27),.CLK(CLK),.Q(out28),.rst(rst));
    D_FlipFlop_16bits K29(.D(out28),.CLK(CLK),.Q(out29),.rst(rst));
    D_FlipFlop_16bits K30(.D(out29),.CLK(CLK),.Q(out30),.rst(rst));    
    D_FlipFlop_16bits K31(.D(out30),.CLK(CLK),.Q(out31),.rst(rst));
    D_FlipFlop_16bits K32(.D(out31),.CLK(CLK),.Q(Q32),.rst(rst));            

    assign Q1=out1;
    assign Q2=out2;
    assign Q3=out3;
    assign Q4=out4;
    assign Q5=out5;
    assign Q6=out6;
    assign Q7=out7;
    assign Q8=out8;
    assign Q9=out9;
    assign Q10=out10;
    assign Q11=out11;
    assign Q12=out12;
    assign Q13=out13;
    assign Q14=out14;
    assign Q15=out15;
    assign Q16=out16;
    assign Q17=out17;
    assign Q18=out18;
    assign Q19=out19;
    assign Q20=out20;
    assign Q21=out21;
    assign Q22=out22;
    assign Q23=out23;
    assign Q24=out24;
    assign Q25=out25;
    assign Q26=out26;
    assign Q27=out27;
    assign Q28=out28;
    assign Q29=out29;
    assign Q30=out30;
    assign Q31=out31;

endmodule
