module vmm_dcfir(
CLK, rst, 
ssb_coe1, sdi_coe1, 
ssb_coe2, sdi_coe2, 
ssb_coe3, sdi_coe3, 
ssb_coe4, sdi_coe4, 
ssb_vmm, sdi_vmm,
sel1, sel2, sel3, sel4,CEB,
output_z_real_final_adder_level2,
output_z_imag_final_adder_level2
);

input  CLK, rst, ssb_vmm;
input  ssb_coe1, ssb_coe2, ssb_coe3, ssb_coe4;
input  [22:0] sdi_coe1, sdi_coe2, sdi_coe3, sdi_coe4;
input  [5:0]  sel1, sel2, sel3, sel4;
input  [27:0] sdi_vmm;
input  CEB;

wire [31:0] output_z_0, output_z_1, output_z_2, output_z_3;
wire vmm_load;


top_combine VMM_TOP(
.CLK(CLK), .rst(rst),
.CEB(CEB), .ssb(ssb_vmm), 
.sdi(sdi_vmm),
.vmm_load(vmm_load),
.output_z_0(output_z_0), 
.output_z_1(output_z_1), 
.output_z_2(output_z_2), 
.output_z_3(output_z_3)
);


wire [15:0] output_real_dcfir0, output_img_dcfir0;
wire coe_load;
top_d_cfir_master DUT_DCFIR0(
.CLK(CLK), .rst(rst), .ssb(ssb_coe1), .sdi(sdi_coe1), .sel(sel1),    
.din_data_real(output_z_0[31:16]), .din_data_imag(output_z_0[15:0]),  
.output_real(output_real_dcfir0), 
.output_img(output_img_dcfir0),
.vmm_load(vmm_load),
.coe_load(coe_load)     
);


wire [15:0] output_real_dcfir1, output_img_dcfir1;
top_d_cfir_slave_1 DUT_DCFIR1(
.CLK(CLK), .rst(rst), .ssb(ssb_coe2), .sdi(sdi_coe2), .sel(sel2),    
.din_data_real(output_z_1[31:16]), .din_data_imag(output_z_1[15:0]),  
.output_real(output_real_dcfir1), 
.output_img(output_img_dcfir1),    
.coe_load(coe_load)   
);


wire [15:0] output_real_dcfir2, output_img_dcfir2;
top_d_cfir_slave_2 DUT_DCFIR2(
.CLK(CLK), .rst(rst), .ssb(ssb_coe3), .sdi(sdi_coe3), .sel(sel3),    
.din_data_real(output_z_2[31:16]), .din_data_imag(output_z_2[15:0]),  
.output_real(output_real_dcfir2), 
.output_img(output_img_dcfir2),  
.coe_load(coe_load)     
);

wire [15:0] output_real_dcfir3, output_img_dcfir3;
top_d_cfir_slave_3 DUT_DCFIR3(
.CLK(CLK), .rst(rst), .ssb(ssb_coe4), .sdi(sdi_coe4), .sel(sel4),    
.din_data_real(output_z_3[31:16]), .din_data_imag(output_z_3[15:0]),  
.output_real(output_real_dcfir3), 
.output_img(output_img_dcfir3),   
.coe_load(coe_load)    
);

wire [15:0] output_z_real_final_adder_level1_0;
wire [15:0] output_z_imag_final_adder_level1_0;

complex_adder DUT_FINAL_ADDER_level1_0(
.CLK(CLK), .rst(rst), 
.input_a_real(output_real_dcfir0),.input_b_real(output_real_dcfir1),
.input_a_imag(output_img_dcfir0),.input_b_imag(output_img_dcfir1),
.output_z_real(output_z_real_final_adder_level1_0),
.output_z_imag(output_z_imag_final_adder_level1_0)
);


wire [15:0] output_z_real_final_adder_level1_1;
wire [15:0] output_z_imag_final_adder_level1_1;

complex_adder DUT_FINAL_ADDER_level1_1(
.CLK(CLK), .rst(rst), 
.input_a_real(output_real_dcfir2),.input_b_real(output_real_dcfir3),
.input_a_imag(output_img_dcfir2),.input_b_imag(output_img_dcfir3),
.output_z_real(output_z_real_final_adder_level1_1),
.output_z_imag(output_z_imag_final_adder_level1_1)
);

output [15:0] output_z_real_final_adder_level2;
output [15:0] output_z_imag_final_adder_level2;

complex_adder DUT_FINAL_ADDER_level2(
.CLK(CLK), .rst(rst), 
.input_a_real(output_z_real_final_adder_level1_0),.input_b_real(output_z_real_final_adder_level1_1),
.input_a_imag(output_z_imag_final_adder_level1_0),.input_b_imag(output_z_imag_final_adder_level1_1),
.output_z_real(output_z_real_final_adder_level2),
.output_z_imag(output_z_imag_final_adder_level2)
);

endmodule
