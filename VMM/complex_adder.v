module complex_adder(
CLK, rst, 
input_a_real,input_b_real,output_z_real,
input_a_imag,input_b_imag,output_z_imag
);

input CLK, rst;
input [15:0] input_a_real,input_a_imag;
input [15:0] input_b_real,input_b_imag;
output[15:0] output_z_real,output_z_imag;

adder_16bit DUT_ADDER_REAL(
.CLK(CLK), 
.Reset(rst), 
.input_a(input_a_real),
.input_b(input_b_real),
.output_z(output_z_real)
);

adder_16bit DUT_ADDER_IMAG(
.CLK(CLK), 
.Reset(rst), 
.input_a(input_a_imag),
.input_b(input_b_imag),
.output_z(output_z_imag)
);
endmodule
