module D_FlipFlop_16bits(D, CLK, Q, rst);

	input [15:0] D; // Data input 
	input  CLK,rst; // clock input 
	output reg [15:0] Q; // output Q 
	always @(posedge CLK or posedge rst) 
        begin
           if (rst==1'b1)
                 Q<=16'd0;
           else
 	   	 Q<= D; 
        end 
endmodule 
