module pin_update_slave(ssb,sdi,CLK,rst,coe_load,
interp_coe0_real,
interp_coe1_real,
interp_coe2_real,
interp_coe0_imag,
interp_coe1_imag,
interp_coe2_imag
);

input ssb,CLK;
input [22:0] sdi;
input rst;

reg [19:0] config0;
reg [19:0] config1;
reg [19:0] config2;
reg [19:0] config3;



always @(posedge CLK or posedge rst) begin
        if(rst==1'b1) begin
                config0 <= 23'b0; ///define what these mean later
                config1 <= 23'b0;
                config2 <= 23'b0;
                config3 <= 23'b0;
        end
        else begin
                if(ssb == 1'b1) begin
	                case (sdi[2:0])
		                3'd0: config0 <= sdi[22:3];
		                3'd1: config1 <= sdi[22:3];
		                3'd2: config2 <= sdi[22:3];
		                3'd3: config3 <= sdi[22:3]; 
                                default: config0 <= sdi[22:3];   
                        endcase                   
                end	
                else begin
                        config0 <= config0;
                        config1 <= config1;
                        config2 <= config2;
                        config3 <= config3;    
                end
        end
end

output [9:0] interp_coe0_real;
output [9:0] interp_coe1_real;
output [9:0] interp_coe2_real;
output [9:0] interp_coe0_imag;
output [9:0] interp_coe1_imag;
output [9:0] interp_coe2_imag;

input coe_load;
wire load;

reg [9:0] interp_coe0_real_pipe;
reg [9:0] interp_coe1_real_pipe;
reg [9:0] interp_coe2_real_pipe;
reg [9:0] interp_coe0_imag_pipe;
reg [9:0] interp_coe1_imag_pipe;
reg [9:0] interp_coe2_imag_pipe;


always @(posedge CLK or posedge rst) begin
        if (rst == 1'b1) begin
                interp_coe0_real_pipe <= 10'd0;
                interp_coe1_real_pipe <= 10'd0;
                interp_coe2_real_pipe <= 10'd0;
                interp_coe0_imag_pipe <= 10'd0;
                interp_coe1_imag_pipe <= 10'd0;
                interp_coe2_imag_pipe <= 10'd0;               
        end else begin
                if (coe_load == 1'b1) begin
                        interp_coe0_real_pipe <= config0[19:10];
                        interp_coe1_real_pipe <= config1[19:10];
                        interp_coe2_real_pipe <= config2[19:10];
                        interp_coe0_imag_pipe <= config0[9:0];
                        interp_coe1_imag_pipe <= config1[9:0];
                        interp_coe2_imag_pipe <= config2[9:0];
                end else begin
                        interp_coe0_real_pipe <= interp_coe0_real_pipe;
                        interp_coe1_real_pipe <= interp_coe1_real_pipe;
                        interp_coe2_real_pipe <= interp_coe2_real_pipe;
                        interp_coe0_imag_pipe <= interp_coe0_imag_pipe;
                        interp_coe1_imag_pipe <= interp_coe1_imag_pipe;
                        interp_coe2_imag_pipe <= interp_coe2_imag_pipe;
 
                end
        end
end

assign interp_coe0_real = interp_coe0_real_pipe;
assign interp_coe1_real = interp_coe1_real_pipe;
assign interp_coe2_real = interp_coe2_real_pipe;
assign interp_coe0_imag = interp_coe0_imag_pipe;
assign interp_coe1_imag = interp_coe1_imag_pipe;
assign interp_coe2_imag = interp_coe2_imag_pipe;


endmodule
