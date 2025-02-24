module vmm_single(
CLK, rst,
input_a_real1, input_a_real2, input_a_real3, input_a_real4, input_a_real5, input_a_real6, input_a_real7, input_a_real8,
input_b_real1, input_b_real2, input_b_real3, input_b_real4, input_b_real5, input_b_real6, input_b_real7, input_b_real8,
input_a_imag1, input_a_imag2, input_a_imag3, input_a_imag4, input_a_imag5, input_a_imag6, input_a_imag7, input_a_imag8,
input_b_imag1, input_b_imag2, input_b_imag3, input_b_imag4, input_b_imag5, input_b_imag6, input_b_imag7, input_b_imag8,
input_a_real9, input_a_real10, input_a_real11, input_a_real12, input_a_real13, input_a_real14, input_a_real15, input_a_real16,
input_b_real9, input_b_real10, input_b_real11, input_b_real12, input_b_real13, input_b_real14, input_b_real15, input_b_real16,
input_a_imag9, input_a_imag10, input_a_imag11, input_a_imag12, input_a_imag13, input_a_imag14, input_a_imag15, input_a_imag16,
input_b_imag9, input_b_imag10, input_b_imag11, input_b_imag12, input_b_imag13, input_b_imag14, input_b_imag15, input_b_imag16,
output_z_real1, output_z_real2, output_z_real3, output_z_real4, output_z_real5, output_z_real6, output_z_real7, output_z_real8,
output_z_imag1, output_z_imag2, output_z_imag3, output_z_imag4, output_z_imag5, output_z_imag6, output_z_imag7, output_z_imag8,
output_z_real9, output_z_real10, output_z_real11, output_z_real12, output_z_real13, output_z_real14, output_z_real15, output_z_real16,
output_z_imag9, output_z_imag10, output_z_imag11, output_z_imag12, output_z_imag13, output_z_imag14, output_z_imag15, output_z_imag16
);

input CLK, rst;
input [15:0] input_a_real1, input_a_real2, input_a_real3, input_a_real4, input_a_real5, input_a_real6, input_a_real7, input_a_real8;
input [9:0] input_b_real1, input_b_real2, input_b_real3, input_b_real4, input_b_real5, input_b_real6, input_b_real7, input_b_real8;
input [15:0] input_a_imag1, input_a_imag2, input_a_imag3, input_a_imag4, input_a_imag5, input_a_imag6, input_a_imag7, input_a_imag8;
input [9:0] input_b_imag1, input_b_imag2, input_b_imag3, input_b_imag4, input_b_imag5, input_b_imag6, input_b_imag7, input_b_imag8;
input [15:0] input_a_real9, input_a_real10, input_a_real11, input_a_real12, input_a_real13, input_a_real14, input_a_real15, input_a_real16;
input [9:0] input_b_real9, input_b_real10, input_b_real11, input_b_real12, input_b_real13, input_b_real14, input_b_real15, input_b_real16;
input [15:0] input_a_imag9, input_a_imag10, input_a_imag11, input_a_imag12, input_a_imag13, input_a_imag14, input_a_imag15, input_a_imag16;
input [9:0] input_b_imag9, input_b_imag10, input_b_imag11, input_b_imag12, input_b_imag13, input_b_imag14, input_b_imag15, input_b_imag16;
output [15:0] output_z_real1, output_z_real2, output_z_real3, output_z_real4, output_z_real5, output_z_real6, output_z_real7, output_z_real8;
output [15:0] output_z_imag1, output_z_imag2, output_z_imag3, output_z_imag4, output_z_imag5, output_z_imag6, output_z_imag7, output_z_imag8;
output [15:0] output_z_real9, output_z_real10, output_z_real11, output_z_real12, output_z_real13, output_z_real14, output_z_real15, output_z_real16;
output [15:0] output_z_imag9, output_z_imag10, output_z_imag11, output_z_imag12, output_z_imag13, output_z_imag14, output_z_imag15, output_z_imag16;



complex_multiplier DUT_VMM_1(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real1),
.input_b_real(input_b_real1),
.input_a_imag(input_a_imag1),
.input_b_imag(input_b_imag1),
.output_z_real(output_z_real1),
.output_z_imag(output_z_imag1)
);



complex_multiplier DUT_VMM_2(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real2),
.input_b_real(input_b_real2),
.input_a_imag(input_a_imag2),
.input_b_imag(input_b_imag2),
.output_z_real(output_z_real2),
.output_z_imag(output_z_imag2)
);



complex_multiplier DUT_VMM_3(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real3),
.input_b_real(input_b_real3),
.input_a_imag(input_a_imag3),
.input_b_imag(input_b_imag3),
.output_z_real(output_z_real3),
.output_z_imag(output_z_imag3)
);



complex_multiplier DUT_VMM_4(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real4),
.input_b_real(input_b_real4),
.input_a_imag(input_a_imag4),
.input_b_imag(input_b_imag4),
.output_z_real(output_z_real4),
.output_z_imag(output_z_imag4)
);



complex_multiplier DUT_VMM_5(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real5),
.input_b_real(input_b_real5),
.input_a_imag(input_a_imag5),
.input_b_imag(input_b_imag5),
.output_z_real(output_z_real5),
.output_z_imag(output_z_imag5)
);



complex_multiplier DUT_VMM_6(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real6),
.input_b_real(input_b_real6),
.input_a_imag(input_a_imag6),
.input_b_imag(input_b_imag6),
.output_z_real(output_z_real6),
.output_z_imag(output_z_imag6)
);



complex_multiplier DUT_VMM_7(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real7),
.input_b_real(input_b_real7),
.input_a_imag(input_a_imag7),
.input_b_imag(input_b_imag7),
.output_z_real(output_z_real7),
.output_z_imag(output_z_imag7)
);



complex_multiplier DUT_VMM_8(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real8),
.input_b_real(input_b_real8),
.input_a_imag(input_a_imag8),
.input_b_imag(input_b_imag8),
.output_z_real(output_z_real8),
.output_z_imag(output_z_imag8)
);



complex_multiplier DUT_VMM_9(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real9),
.input_b_real(input_b_real9),
.input_a_imag(input_a_imag9),
.input_b_imag(input_b_imag9),
.output_z_real(output_z_real9),
.output_z_imag(output_z_imag9)
);



complex_multiplier DUT_VMM_10(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real10),
.input_b_real(input_b_real10),
.input_a_imag(input_a_imag10),
.input_b_imag(input_b_imag10),
.output_z_real(output_z_real10),
.output_z_imag(output_z_imag10)
);



complex_multiplier DUT_VMM_11(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real11),
.input_b_real(input_b_real11),
.input_a_imag(input_a_imag11),
.input_b_imag(input_b_imag11),
.output_z_real(output_z_real11),
.output_z_imag(output_z_imag11)
);



complex_multiplier DUT_VMM_12(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real12),
.input_b_real(input_b_real12),
.input_a_imag(input_a_imag12),
.input_b_imag(input_b_imag12),
.output_z_real(output_z_real12),
.output_z_imag(output_z_imag12)
);



complex_multiplier DUT_VMM_13(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real13),
.input_b_real(input_b_real13),
.input_a_imag(input_a_imag13),
.input_b_imag(input_b_imag13),
.output_z_real(output_z_real13),
.output_z_imag(output_z_imag13)
);



complex_multiplier DUT_VMM_14(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real14),
.input_b_real(input_b_real14),
.input_a_imag(input_a_imag14),
.input_b_imag(input_b_imag14),
.output_z_real(output_z_real14),
.output_z_imag(output_z_imag14)
);



complex_multiplier DUT_VMM_15(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real15),
.input_b_real(input_b_real15),
.input_a_imag(input_a_imag15),
.input_b_imag(input_b_imag15),
.output_z_real(output_z_real15),
.output_z_imag(output_z_imag15)
);



complex_multiplier DUT_VMM_16(
.CLK(CLK), .rst(rst), 
.input_a_real(input_a_real16),
.input_b_real(input_b_real16),
.input_a_imag(input_a_imag16),
.input_b_imag(input_b_imag16),
.output_z_real(output_z_real16),
.output_z_imag(output_z_imag16)
);



endmodule
