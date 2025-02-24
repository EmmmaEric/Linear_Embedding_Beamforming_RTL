module mux_32_to_1(clk,
din_0,
din_1,
din_2,
din_3,
din_4,
din_5,
din_6,
din_7,
din_8,
din_9,
din_10,
din_11,
din_12,
din_13,
din_14,
din_15,
din_16,
din_17,
din_18,
din_19,
din_20,
din_21,
din_22,
din_23,
din_24,
din_25,
din_26,
din_27,
din_28,
din_29,
din_30,
din_31,
sel,
mux_out);
input [15:0] din_0;
input [15:0] din_1;
input [15:0] din_2;
input [15:0] din_3;
input [15:0] din_4;
input [15:0] din_5;
input [15:0] din_6;
input [15:0] din_7;
input [15:0] din_8;
input [15:0] din_9;
input [15:0] din_10;
input [15:0] din_11;
input [15:0] din_12;
input [15:0] din_13;
input [15:0] din_14;
input [15:0] din_15;
input [15:0] din_16;
input [15:0] din_17;
input [15:0] din_18;
input [15:0] din_19;
input [15:0] din_20;
input [15:0] din_21;
input [15:0] din_22;
input [15:0] din_23;
input [15:0] din_24;
input [15:0] din_25;
input [15:0] din_26;
input [15:0] din_27;
input [15:0] din_28;
input [15:0] din_29;
input [15:0] din_30;
input [15:0] din_31;
input [5:0] sel;
input clk;
output reg [15:0] mux_out;
always @(posedge clk) begin
case(sel)
5'd0: mux_out <= din_0;
5'd1: mux_out <= din_1;
5'd2: mux_out <= din_2;
5'd3: mux_out <= din_3;
5'd4: mux_out <= din_4;
5'd5: mux_out <= din_5;
5'd6: mux_out <= din_6;
5'd7: mux_out <= din_7;
5'd8: mux_out <= din_8;
5'd9: mux_out <= din_9;
5'd10: mux_out <= din_10;
5'd11: mux_out <= din_11;
5'd12: mux_out <= din_12;
5'd13: mux_out <= din_13;
5'd14: mux_out <= din_14;
5'd15: mux_out <= din_15;
5'd16: mux_out <= din_16;
5'd17: mux_out <= din_17;
5'd18: mux_out <= din_18;
5'd19: mux_out <= din_19;
5'd20: mux_out <= din_20;
5'd21: mux_out <= din_21;
5'd22: mux_out <= din_22;
5'd23: mux_out <= din_23;
5'd24: mux_out <= din_24;
5'd25: mux_out <= din_25;
5'd26: mux_out <= din_26;
5'd27: mux_out <= din_27;
5'd28: mux_out <= din_28;
5'd29: mux_out <= din_29;
5'd30: mux_out <= din_30;
5'd31: mux_out <= din_31;
default: mux_out <= 0;
endcase
end
endmodule
