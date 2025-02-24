`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2021 05:58:56 PM
// Design Name: 
// Module Name: fixed_st1_opt_pipelined_n_multiplier_5_stage
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




//Found at https://github.com/suoglu/Fixed-Floating-Point-Adder-Multiplier/blob/master/Sources/adder-multiplier.v
//The original code copied was wrong.
//Modified and incorporated few more exceptions.




//float multi multiplier floating point numbers.

module multiplier_multibit(input_a_, input_b_, output_z, CLK,Reset);
//module multiplier_16FP(input_a_, input_b_, output_z, CLK,Reset,overflow,zero,NaN,precisionLost);
  //Operands
  input CLK,Reset;
  input [15:0] input_a_;
  input [9:0] input_b_;
  output reg [15:0] output_z;

  //input_b_16
  wire [15:0] input_b_16;
  //Flags
  wire overflow;//overflow flag
  wire zero; //zero flag
  wire NaN_; //Not a Number flag
  wire precisionLost;
  //Decode numbers
  wire sign1_, sign2_, signR; //hold signs
  wire [4:0] ex1_, ex2_, exR; //hold exponents
  wire [4:0] ex1_pre, ex2_pre, exR_calc, exR_calc_1; //hold exponents
  reg [4:0] exSubCor;//Corrected exponents for Subnormal Numbers
  wire [9:0] fra1, fra2, fraR; //hold fractions
  reg [9:0] fraSub;//Corrected Mantissa for SubNormal Numbers
  wire [20:0] float1;
  wire [10:0] float2;
  wire [5:0] exSum_; //exponent sum
  reg [11:0] float_res; //output_z
  reg [9:0] dump_res; //Lost precision
  wire [21:0] res_full;
  reg [20:0] mid[9:0];
  reg [21:0] mid_p2[5:0];
  reg [22:0] mid_p3[2:0];
  reg [23:0] mid_p4[1:0];
  wire inf_num_; //at least on of the operands is inf.
  wire NsubNormal;//not of subNormal number
  wire ovf;
  wire neg_ex;
  wire neg_ex_SubCor;
  wire ovf_ex_SubCor;
//  reg [15:0] input_a,input_b,input_ap1,input_bp1,input_ap2,input_bp2,input_ap3,input_bp3,input_ap4,input_bp4;
  wire ex_zero_;
  reg ex_zerop1,ex_zerop2,ex_zerop3,ex_zerop4,ex_zero;
  reg NaNp1,NaNp2,NaNp3,NaNp4,NaN;
  reg inf_nump1,inf_nump2,inf_nump3,inf_nump4,inf_num;
  reg [5:0] exSump2,exSump3,exSump4,exSum;
  reg sign1p1,sign1p2,sign1p3,sign1p4,sign1;
  reg sign2p1,sign2p2,sign2p3,sign2p4,sign2;
  reg [4:0] ex1p1,ex2p1;
  
  reg [20:0] float1p0;
  reg float2bp0;

  assign input_b_16={input_b_,6'd0};
  //Flags
//  assign zero = ~(|input_a[14:0] & |input_b[14:0]) | (~NsubNormal & ((fraSub == 10'd0) | ((exSubCor > exSum[4:0]) & |{ex1_pre,ex2_pre})));
  assign zero =~ex_zero | (~NsubNormal & ((fraSub == 10'd0) |ex_zero));
  assign ex_zero_=|{ex1_pre,ex2_pre};
 //Cases for zero
 //1. When all the exponents are 0
 //2. When number is SubNormal and the fraction Subnormal is 0 or when all the exponents are 0.
 
  assign NaN_ = (&input_a_[14:10] & |input_a_[9:0]) | (&input_b_16[14:10] & |input_b_16[9:0]);
  // All exponent is 1 and not all bits of the mantissa is zero.
  
  assign inf_num_ = (&input_a_[14:10] & ~|input_a_[9:0]) | (&input_b_16[14:10] & ~|input_b_16[9:0]); 
  
  //check for infinite number
  assign overflow = inf_num | neg_ex&ovf;
  //Cases for overflows
  //1. Either infinite number
  //2. When we do -15 from the sum of exponents, if the 2's complement based addition gives 1 as carryout and the MSB changes.
  // say two exponents are 16 and 31
  // Sum will be 6'd47
  // Substracting 15 using 2's complement 6'd101111 + 6'd110001 --> |1| 6'd100000.
  //When overflow happens the MSB of this sum will always be 1 and overflow will always be 1 as
  //This is a positive output. We combine this with and to check the oveflow.
  //When changing the precision of the multiplier we need to check which combination 
  //is the case whether overflow starts and plug into this accordingly
  
  
  
  assign NsubNormal = |float_res[11:10];
  //If the mantissa multiplication didn't yield 1 in the MSB. Consider it as
  //subnormal. There could be case when NsubNormal is 1 ans the number is subnormal.
  //Consider multiplication of
  //input_a=16'b0011011111111111;//0.4998
  //input_b=16'b0000001111111111; //6.1E-5
  //We will use certain exceptions to solve this.
  
  assign precisionLost = |dump_res;
  //If any bit is dumped
  
  //decode-encode numbers
  assign {sign1_, ex1_pre, fra1} = input_a_;
  assign {sign2_, ex2_pre, fra2} = input_b_16;
  
  assign ex1_ = ex1_pre + {4'd0, ~|ex1_pre};
  //If the Number is subnormal make exponent as 1 as for subNormal number we do 0.f*2^(1-b)
  
  assign ex2_ = ex2_pre + {4'd0, ~|ex2_pre};
  //If the Number is subnormal make exponent as 1 as for subNormal number we do 0.f*2^(1-b)
  
//  assign output_z = {signR, exR, fraR};
  //Final output
  
  assign res_full = {float_res, dump_res};
  //complete product of mantissa
  
  assign exSum_ = {1'b0,ex1p1} + {1'b0,ex2p1}; 
  //Adding the two exponents
 

//  //Get floating numbers
//  assign float1 = {|ex1_pre, fra1, 10'd0};
//  //This implements the 0.f in case of subnormal or 1.f in normal case
//  //append 10'd0} ? Why? do this such that shift and add topology for multiplier works.
//  assign float2 = {|ex2_pre, fra2};
  
  
  
  //Get floating numbers
  assign float1 = {|input_a_[14:10], input_a_[9:0], 10'd0};
  //This implements the 0.f in case of subnormal or 1.f in normal case
  //append 10'd0} ? Why? do this such that shift and add topology for multiplier works.
  assign float2 = {|input_b_16[14:10],input_b_16[9:0]};





    //This is computed in the last stage of the pipeline
  //Calculate output_z
  assign signR = ~zero & (sign1 ^ sign2);
  //Find the Sign
  assign {neg_ex,ovf,exR_calc_1} = exSum[5:0]+ {5'd0, float_res[11]} + 6'b110001;
  //This implements the case where we are trying to substract 15 from the sum of exponents using the 2's complement technique
  //Exponents are 5 bits so the sum is 6 bits. 2's complement of 15 in 6 bits is 110001. Now, if the product of mantissa yields 
  //an additional 1 add it to the exponent to make is normalised.
  //neg-ex-> If this substraction is negative then neg_ex is 0 (2's complement rule)
  //ovf-> This is done to implement the overflow check check above for discription. 
  //exR_calc_1-> Truncated 5 bit difference
  
  assign {neg_ex_SubCor,ovf_ex_SubCor, exR_calc} = {ovf,exR_calc_1} + (~{1'b0,exSubCor} & {6{~NsubNormal}}) + {5'd0, ~NsubNormal};
  //This makes sense when the number is NsubNormal i.e the first two bits of the mantissa multiplication did not give 1.
  //ex_SubCor-> It the exponent subnormal correction which is obtained by checking the first occurance of 1 in the mantissa multiplication.
  //Essentially we need to substract this to the exponent since we are moving the mantissa towards the left.
  //This (~{1'b0,exSubCor} & {6{~NsubNormal}}) + {5'd0, ~NsubNormal}; implements the 2's complement substraction.
  //neg_ex_SubCor-> If this substraction is negative then neg_ex_SubCor is 0 (2's complement rule)
  //ovf_ex-> This is the MSB of the difference which is dropped 
  // exR_calc-> Final 5 bit exponent output.

  assign exR = ((overflow) ? 5'b11111 : (~NsubNormal&(~neg_ex| ~neg_ex_SubCor)| ~neg_ex & ~neg_ex_SubCor) ? 5'b00000: (exR_calc)) & {5{~zero}};
  //Here we consider the exceptions and cases.
  // If overflow exponent is 5'd31;
  // else
  // If number is not SubNormal and either of the differnece above is negative exponent is 5'd0. If both are negative is a special case. for
  //    input_a=16'b0011011111111111;//0.4998
  //    input_b=16'b0000001111111111; //6.1E-5
  //else
  //exponent is exR_calc & !zero. If zero is 1 pull exponent to 0 

  assign fraR = (zero | overflow) ? 10'd0 : (~neg_ex & ~neg_ex_SubCor) ? float_res[11:2] : (neg_ex & ~neg_ex_SubCor & ~|exR) ? res_full >> (5'd11-exR_calc_1) :((NsubNormal | ~|{ex1_pre,ex2_pre}) ? ((float_res[11]) ? float_res[10:1] : float_res[9:0]) : fraSub);
  //Here we consider the exceptions and cases.
  // If overflow or zero output 0
  // else if both differences are negative output float_res[11:2] this is a special case.
  // else if first differnce is not negative but the exponent correction difference is negative
  //In this case whent all the bits of exponents are defined 0 initially. We shift the full mantissa product to the
  //right with (5'd11-exR_calc_1) where 11 is because we have 22( 1+11+ 10) wide product and exR-calc_1 is the left over difference
  // from first exponent substraction. Essentially we have a subnormal number but the exponent correction cannot to implemented as the
  //exponent is very small, so we ouput a subnormal number by shifting the full mantissa product by the amount left after first exponent
  //substraction.
  //else if the number is not subnormal then just output fraction seeing the MSB of the float_res.
  //else if Output the corrected fraction computed based on the occurance of 1 in the full mantissa product.

  //assign {float_res, dump_res} = mid[0] + mid[1] + mid[2] + mid[3] + mid[4] + mid[5] + mid[6] + mid[7] + mid[8] + mid[9] + mid[10];
  //This is essentially the multiplication using shift and add approach.

  always@(posedge CLK or posedge Reset) //create mids from fractions
    begin
        if(Reset==1'b1)
        begin
        output_z<=16'd0;
        //exSubCor<=5'd0;
        //fraSub<=10'd0;
        float_res<=12'd0;
        dump_res<=10'd0;
        mid[0]<=21'd0;
        mid[1]<=21'd0;
        mid[2]<=21'd0;
        mid[3]<=21'd0;
        mid[4]<=21'd0;
        mid[5]<=21'd0;
        mid[6]<=21'd0;
        mid[7]<=21'd0;
        mid[8]<=21'd0;
        mid[9]<=21'd0;        
        mid[10]<=21'd0;
        mid_p2[0]<=22'd0;
        mid_p2[1]<=22'd0;
        mid_p2[2]<=22'd0;
        mid_p2[3]<=22'd0;
        mid_p2[4]<=22'd0;
        mid_p2[5]<=22'd0;
        mid_p3[0]<=23'd0;
        mid_p3[1]<=23'd0;
        mid_p3[2]<=23'd0;
        mid_p4[0]<=24'd0;
        mid_p4[1]<=24'd0;
        ex_zerop1<=1'b0;
        ex_zerop2<=1'b0;
        ex_zerop3<=1'b0;
        ex_zerop4<=1'b0;
        ex_zero<=1'b0;
        
        
        NaNp1<=1'b0;
        NaNp2<=1'b0;
        NaNp3<=1'b0;
        NaNp4<=1'b0;
        NaN<=1'b0;
        inf_nump1<=1'b0;
        inf_nump2<=1'b0;
        inf_nump3<=1'b0;
        inf_nump4<=1'b0;
        inf_num<=1'b0;
        exSump2<=6'd0;
        exSump3<=6'd0;
        exSump4<=6'd0;
        exSum<=6'd0;
        sign1p1<=1'd0;
        sign1p2<=1'd0;
        sign1p3<=1'd0;
        sign1p4<=1'd0;
        sign1<=1'd0;
        sign2p1<=1'd0;
        sign2p2<=1'd0;
        sign2p3<=1'd0;
        sign2p4<=1'd0;
        sign2<=1'd0;
        ex1p1<=5'd0;
        ex2p1<=5'd0;
        float1p0<=21'b0;
        float2bp0<=1'b0;   
        
//        input_ap1<=16'd0;
//        input_bp1<=16'd0;
        
//        input_ap2<=16'd0;
//        input_bp2<=16'd0;
        
//        input_ap3<=16'd0;
//        input_bp3<=16'd0;

//        input_ap4<=16'd0;
//        input_bp4<=16'd0;
	
//	input_a<=16'd0;
//	input_b<=16'd0;
        end
        
        
        else
        
        
            begin
            
            //6th Stage
            output_z <= {signR, exR, fraR};
            
            //5th Stage
//            input_a<=input_ap4;
//            input_b<=input_bp4;
            sign1<=sign1p4;
            sign2<=sign2p4;
            ex_zero<=ex_zerop4;
            inf_num<=inf_nump4;
            NaN<=NaNp4;
            exSum<=exSump4;
            
            {float_res, dump_res}<=mid_p4[0]+mid_p4[1];

            //4th Stage
//            input_ap4<=input_ap3;
//            input_bp4<=input_bp3;
            sign1p4<=sign1p3;
            sign2p4<=sign2p3;
            ex_zerop4<=ex_zerop3;
            inf_nump4<=inf_nump3;
            NaNp4<=NaNp3;
            exSump4<=exSump3;
            mid_p4[0]<=mid_p3[0]+mid_p3[1];
            mid_p4[1]<=mid_p3[2];
            //3rd Stage
//            input_ap3<=input_ap2;
//            input_bp3<=input_bp2;
            sign1p3<=sign1p2;
            sign2p3<=sign2p2;
            ex_zerop3<=ex_zerop2;
            inf_nump3<=inf_nump2;
            NaNp3<=NaNp2;
            exSump3<=exSump2;            
           
            mid_p3[0]<=mid_p2[0]+mid_p2[1];
            mid_p3[1]<=mid_p2[2]+mid_p2[3];
            mid_p3[2]<=mid_p2[4]+mid_p2[5];
            //2nd Stage
//            input_ap2<=input_ap1;
//            input_bp2<=input_bp1;
                sign1p2<=sign1p1;
                sign2p2<=sign2p1;
                ex_zerop2<=ex_zerop1;
                inf_nump2<=inf_nump1;
                NaNp2<=NaNp1;
                exSump2<=exSum_;
            mid_p2[0]<=mid[0]+mid[1];            
            mid_p2[1]<=mid[2]+mid[3];
            mid_p2[2]<=mid[4]+mid[5];
            mid_p2[3]<=mid[6]+mid[7];
            mid_p2[4]<=mid[8]+mid[9];
//            mid_p2[5]<=mid[10];             
            mid_p2[5]<=float1p0 & {21{float2bp0}};            
              //1th Stage
//              input_ap1<=input_a_;
//              input_bp1<=input_b_;
                sign1p1<=sign1_;
                sign2p1<=sign2_;
                ex_zerop1<=ex_zero_;
                inf_nump1<=inf_num_;
                NaNp1<=NaN_;
//                exSump1<=exSum_;
                ex1p1<=ex1_;
                ex2p1<=ex2_;
              mid[0] <= (float1 >> 10) & {21{float2[0]}};
              mid[1] <= (float1 >> 9)  & {21{float2[1]}};
              mid[2] <= (float1 >> 8)  & {21{float2[2]}};
              mid[3] <= (float1 >> 7)  & {21{float2[3]}};
              mid[4] <= (float1 >> 6)  & {21{float2[4]}};
              mid[5] <= (float1 >> 5)  & {21{float2[5]}};
              mid[6] <= (float1 >> 4)  & {21{float2[6]}};
              mid[7] <= (float1 >> 3)  & {21{float2[7]}};
              mid[8] <= (float1 >> 2)  & {21{float2[8]}};
              mid[9] <= (float1 >> 1)  & {21{float2[9]}};
              float1p0<=float1;
              float2bp0<=float2[10];
//              mid[10] <= float1        & {21{float2[10]}};
            end
        
    end
  //Corrections for subnormal normal op
  always@*
    begin
      casex(res_full)
        22'b001xxxxxxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[18:9];
          end
        22'b0001xxxxxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[17:8];
          end
        22'b00001xxxxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[16:7];
          end
        22'b000001xxxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[15:6];
          end
        22'b0000001xxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[14:5];
          end
        22'b00000001xxxxxxxxxxxxxx:
          begin
            fraSub = res_full[13:4];
          end
        22'b000000001xxxxxxxxxxxxx:
          begin
            fraSub = res_full[12:3];
          end
        22'b0000000001xxxxxxxxxxxx:
          begin
            fraSub = res_full[11:2];
          end
        22'b00000000001xxxxxxxxxxx:
          begin
            fraSub = res_full[10:1];
          end
        22'b000000000001xxxxxxxxxx:
          begin
            fraSub = res_full[9:0];
          end
        22'b0000000000001xxxxxxxxx:
          begin
            fraSub = {res_full[8:0], 1'd0};
          end
        22'b00000000000001xxxxxxxx:
          begin
            fraSub = {res_full[7:0], 2'd0};
          end
        22'b000000000000001xxxxxxx:
          begin
            fraSub = {res_full[6:0], 3'd0};
          end
        22'b0000000000000001xxxxxx:
          begin
            fraSub = {res_full[5:0], 4'd0};
          end
        22'b00000000000000001xxxxx:
          begin
            fraSub = {res_full[4:0], 5'd0};
          end
        22'b000000000000000001xxxx:
          begin
            fraSub = {res_full[3:0], 6'd0};
          end
        22'b0000000000000000001xxx:
          begin
            fraSub = {res_full[2:0], 7'd0};
          end
        22'b00000000000000000001xx:
          begin
            fraSub = {res_full[1:0], 8'd0};
          end
        22'b000000000000000000001x:
          begin
            fraSub = {res_full[0], 9'd0};
          end
        default:
          begin
            fraSub = 10'd0;
          end
      endcase
    end
  always@*
    begin
      casex(res_full)
        22'b001xxxxxxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd1;
          end
        22'b0001xxxxxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd2;
          end
        22'b00001xxxxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd3;
          end
        22'b000001xxxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd4;
          end
        22'b0000001xxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd5;
          end
        22'b00000001xxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd6;
          end
        22'b000000001xxxxxxxxxxxxx:
          begin
            exSubCor = 5'd7;
          end
        22'b0000000001xxxxxxxxxxxx:
          begin
            exSubCor = 5'd8;
          end
        22'b00000000001xxxxxxxxxxx:
          begin
            exSubCor = 5'd9;
          end
        22'b000000000001xxxxxxxxxx:
          begin
            exSubCor = 5'd10;
          end
        22'b0000000000001xxxxxxxxx:
          begin
            exSubCor = 5'd11;
          end
        22'b00000000000001xxxxxxxx:
          begin
            exSubCor = 5'd12;
          end
        22'b000000000000001xxxxxxx:
          begin
            exSubCor = 5'd13;
          end
        22'b0000000000000001xxxxxx:
          begin
            exSubCor = 5'd14;
          end
        22'b00000000000000001xxxxx:
          begin
            exSubCor = 5'd15;
          end
        22'b000000000000000001xxxx:
          begin
            exSubCor = 5'd16;
          end
        22'b0000000000000000001xxx:
          begin
            exSubCor = 5'd17;
          end
        22'b00000000000000000001xx:
          begin
            exSubCor = 5'd18;
          end
        22'b000000000000000000001x:
          begin
            exSubCor = 5'd19;
          end
        default:
          begin
            exSubCor = 5'd0;
          end
      endcase
    end
endmodule



