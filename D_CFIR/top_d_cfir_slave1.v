`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Georgia Institute of Technology
// Engineer: Xiangyu Mao
// 
// Create Date: 04/09/2023 
// Design Name: 
// Module Name: d_cfir
// Project Name: Beamforming
// 
//////////////////////////////////////////////////////////////////////////////////


module top_d_cfir_slave_2(
CLK, rst, ssb, sdi, sel,
din_data_real, din_data_imag, //32bits
output_real, output_img,      //32bits
coe_load
);

input CLK, rst;
input [15:0] din_data_real, din_data_imag;
output [15:0] output_real, output_img;
input coe_load;

input ssb;
input [5:0] sel;
input [22:0] sdi;
wire [9:0] interp_coe0_real;
wire [9:0] interp_coe1_real;
wire [9:0] interp_coe2_real;
wire [9:0] interp_coe0_imag;
wire [9:0] interp_coe1_imag;
wire [9:0] interp_coe2_imag;



pin_update_slave DUT_COE(
.ssb(ssb), .sdi(sdi),
.CLK(CLK), .rst(rst),
.coe_load(coe_load),
.interp_coe0_real(interp_coe0_real),
.interp_coe1_real(interp_coe1_real),
.interp_coe2_real(interp_coe2_real),
.interp_coe0_imag(interp_coe0_imag),
.interp_coe1_imag(interp_coe1_imag),
.interp_coe2_imag(interp_coe2_imag)
);


dcfir_vmm3 DUT_CFIR_SLAVE(
.CLK(CLK), .rst(rst), 
.sel(sel),       
.din_data_real(din_data_real), .din_data_imag(din_data_imag), //32bits
.coe_real1(interp_coe0_real),
.coe_real2(interp_coe1_real),
.coe_real3(interp_coe2_real),
.coe_imag1(interp_coe0_imag),
.coe_imag2(interp_coe1_imag),
.coe_imag3(interp_coe2_imag),
.output_real(output_real), .output_img(output_img)       //32bits
);

endmodule
