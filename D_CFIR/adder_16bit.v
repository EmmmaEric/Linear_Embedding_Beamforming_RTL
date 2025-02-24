`timescale 1ns / 1ps

module adder_16bit(
CLK, Reset, input_a,input_b,output_z
);

    //CLK and Reset
    input CLK,Reset;

    //Ports
    input [15:0] input_a, input_b;
    output reg [15:0] output_z;
    reg o_overflow; //overflow flag
    reg o_zero; //zero flag
    reg o_NaN; //Not a Number flag
    
    wire [15:0] result;
   
    wire [9:0] big_fra, small_fra; //to hold fraction part
    wire [4:0] big_ex_pre, small_ex_pre;
    wire [4:0] big_ex, small_ex; //to hold exponent part
    wire big_sig, small_sig; //to hold signs
    wire [10:0] big_float, small_float; //to hold as float number with integer
    wire [4:0] ex_diff; //diference between exponentials
    wire [4:0] exp_pre;//Just to correct the exponents to output subnormal numbers
   
    wire sameSign;
    wire zeroSmall;
    reg [15:0] bigNum, smallNum; //to seperate big and small numbers
     
    reg [15:0] p1_input_a,p1_input_b;
    reg [4:0] p3_big_ex, p3_small_ex; //to hold exponent part
    reg p3_big_sig, p3_small_sig; //to hold signs
    reg [10:0] p3_big_float,p3_small_shift_float;
    reg [4:0] p4_big_ex, p4_small_ex; //to hold exponent part
    reg p4_big_sig, p4_small_sig; //to hold signs
    reg [10:0] p4_sum,p5_sum;
    reg p4_sum_carry;
    reg [4:0] p5_big_ex, p5_small_ex; //to hold exponent part
    reg p5_big_sig, p5_small_sig; //to hold signs
    reg [9:0] p5_sum_shifted;
    reg p5_sum_carry;
    reg [3:0] p5_shift_am;
    reg p2_zero,p3_zero,p4_zero,p5_zero;
    reg p2_NaN,p3_NaN,p4_NaN,p5_NaN;
    reg p2_inf_num,p3_inf_num,p4_inf_num,p5_inf_num;
    reg p5_neg_ex;
    reg p3_zeroSmall,p4_zeroSmall,p5_zeroSmall;
    reg [9:0] p3_big_fra,p4_big_fra,p5_big_fra;
     
    wire [15:0] bigNum_w,smallNum_w;
    
    assign {bigNum_w,smallNum_w} = p1_input_b[14:10] > p1_input_a[14:10]?
                                       {p1_input_b,p1_input_a}:
                                       p1_input_b[14:10]==p1_input_a[14:10]?
                                           p1_input_b[9:0]>p1_input_a[9:0]?
                                           {p1_input_b,p1_input_a}:
                                           {p1_input_a,p1_input_b}:
                                       {p1_input_a,p1_input_b};
                   
    wire zero_w;                     
    assign zero_w = (p1_input_a[14:0] == p1_input_b[14:0]) & (~p1_input_a[15] == p1_input_b[15]);

    wire NaN_w;
    assign NaN_w = (&p1_input_a[14:10] & |p1_input_a[9:0]) | (&p1_input_b[14:10] & |p1_input_b[9:0]);
    
    wire inf_num_w;
  
    assign inf_num_w = (&p1_input_a[14:10] & ~|p1_input_a[9:0]) | (&p1_input_b[14:10] & ~|p1_input_b[9:0]); //check for infinite number

     
     	
   //decode numbers
   assign {big_sig, big_ex_pre, big_fra} = bigNum;
   assign {small_sig, small_ex_pre, small_fra} = smallNum;
   assign sameSign = (big_sig == small_sig);
   assign zeroSmall = ~(|small_ex | |small_fra);
   //Checks whether the smaller number is 0
   assign big_ex = big_ex_pre + {4'd0, ~|big_ex_pre};
   //This is special case for the subnormal case where we set the exponent as
   //1 if all the bits in the exponents are 0
   assign small_ex = small_ex_pre + {4'd0, ~|small_ex_pre};
   
  assign big_float = {|big_ex_pre, big_fra};
  //Consider the mantissa |big_ex_pre incorporates whether number is subnormal
  //or not.
  assign small_float = {|small_ex_pre, small_fra};

  assign ex_diff = big_ex - small_ex; //difference between exponents

  wire [10:0] shifted_small_float_w;

  assign shifted_small_float_w= (ex_diff==5'd0)? small_float:
                                (ex_diff==5'd1)? small_float>>1:
                                (ex_diff==5'd2)? small_float>>2:
                                (ex_diff==5'd3)? small_float>>3:
                                (ex_diff==5'd4)? small_float>>4:
                                (ex_diff==5'd5)? small_float>>5:
                                (ex_diff==5'd6)? small_float>>6:
                                (ex_diff==5'd7)? small_float>>7:
                                (ex_diff==5'd8)? small_float>>8:
                                (ex_diff==5'd9)? small_float>>9:
                                (ex_diff==5'd10)? small_float>>10:
                                11'b0;
                                   
      
  wire [10:0] sum_w;
  wire sum_carry_w;
      
  assign {sum_carry_w,sum_w}=(p3_small_sig==p3_big_sig)? p3_small_shift_float+p3_big_float:
                                                ~p3_small_shift_float+p3_big_float+11'd1;
      
  wire [3:0] shift_am_w;
      
  assign shift_am_w= (p4_sum[10]==1'b1)? 4'd0:
                     (p4_sum[9]==1'b1)? 4'd1:
                     (p4_sum[8]==1'b1)? 4'd2:
                     (p4_sum[7]==1'b1)? 4'd3:
                     (p4_sum[6]==1'b1)? 4'd4:
                     (p4_sum[5]==1'b1)? 4'd5:
                     (p4_sum[4]==1'b1)? 4'd6:
                     (p4_sum[3]==1'b1)? 4'd7:
                     (p4_sum[2]==1'b1)? 4'd8:
                     (p4_sum[1]==1'b1)? 4'd9:
                     4'd10;
                         
                         
       wire [9:0] sum_shifted_w;
       

                             
                             
        assign sum_shifted_w=(p4_sum[10]==1'b1)? p4_sum[9:0]:
                         (p4_sum[9]==1'b1)? {p4_sum[8:0],1'b0}:
                         (p4_sum[8]==1'b1)? {p4_sum[7:0],2'b00}:
                         (p4_sum[7]==1'b1)? {p4_sum[6:0],3'b000}:
                         (p4_sum[6]==1'b1)? {p4_sum[5:0],4'b0000}:
                         (p4_sum[5]==1'b1)? {p4_sum[4:0],5'b00000}:
                         (p4_sum[4]==1'b1)? {p4_sum[3:0],6'd0}:
                         (p4_sum[3]==1'b1)? {p4_sum[2:0],7'd0}:
                         (p4_sum[2]==1'b1)? {p4_sum[1:0],8'd0}:
                         (p4_sum[1]==1'b1)? {p4_sum[0],9'd0}:
                         10'd0;
         
         
        wire neg_ex_w;
        
        assign neg_ex_w=(p4_big_ex < shift_am_w)?1'b1:1'b0; 


  wire p5_sameSign;
  
  assign p5_sameSign = (p5_big_sig == p5_small_sig);
   
  assign overflow = p5_NaN|((&p5_big_ex[4:1] & ~p5_big_ex[0]) & p5_sum_carry & p5_sameSign) | &p5_big_ex |p5_inf_num;

  assign result[15] = p5_big_sig; //result sign same as big sign
  

  assign exp_pre= ((p5_sameSign) ? (p5_big_ex + {4'd0, (~p5_zeroSmall & p5_sum_carry & p5_sameSign)}) : ((p5_neg_ex | (p5_shift_am == 4'd10)) ? 5'd0 : (~p5_shift_am + p5_big_ex + 5'd1))) | {5{overflow}}; //result exponent

  assign result[14:10]=(exp_pre==5'd1) ? (5'd0+ p5_sum[10]):exp_pre;

  assign result[9:0] = ((p5_zeroSmall) ? p5_big_fra : ((p5_sameSign) ? ((p5_sum_carry) ? p5_sum[10:1] : p5_sum[9:0]) : ((p5_neg_ex) ? 10'd0 : p5_sum_shifted))) & {10{~overflow}};

     always @ (posedge CLK or posedge Reset)
        begin
            if(Reset==1'b1)
                begin
                    output_z<=16'd0;
                    o_overflow<=1'b0; //overflow flag
                    o_zero<=1'b0; //zero flag
                    o_NaN<=1'b0; //Not a Number flag
                    
                    //Pipeline registers
                    bigNum<=16'd0;
                    smallNum<=16'd0; //to seperate big and small numbers
                    
                    p1_input_a<=16'd0;
                    p1_input_b<=16'd0;
                    p3_big_ex<=5'd0; 
                    p3_small_ex<=5'd0; //to hold exponent part
                    p3_big_sig<=1'd0;
                    p3_small_sig<=1'd0; //to hold signs
                    p3_big_float<=11'd0;
                    p3_small_shift_float<=11'd0;
                    p4_big_ex<=5'd0;
                    p4_small_ex<=5'd0; //to hold exponent part
                    p4_big_sig<=1'd0;
                    p4_small_sig<=1'd0; //to hold signs
                    p4_sum<=11'd0;
                    p5_sum<=11'd0;
                    p4_sum_carry<=1'd0;
                    p5_big_ex<=5'd0;
                    p5_small_ex<=5'd0; //to hold exponent part
                    p5_big_sig<=1'd0;
                    p5_small_sig<=1'd0; //to hold signs
                    p5_sum_shifted<=10'd0;
                    p5_sum_carry<=1'd0;
                    p5_shift_am<=1'd0;
                    p2_zero<=1'd0;
                    p3_zero<=1'd0;
                    p4_zero<=1'd0;
                    p5_zero<=1'd0;
                    p2_NaN<=1'd0;
                    p3_NaN<=1'd0;
                    p4_NaN<=1'd0;
                    p5_NaN<=1'd0;
                    p2_inf_num<=1'd0;
                    p3_inf_num<=1'd0;
                    p4_inf_num<=1'd0;
                    p5_inf_num<=1'd0;
                    p5_neg_ex<=1'd0;
                    p3_zeroSmall<=1'd0;
                    p4_zeroSmall<=1'd0;
                    p5_zeroSmall<=1'd0;
                    p3_big_fra<=10'd0;
                    p4_big_fra<=10'd0;
                    p5_big_fra<=10'd0;
                    
                end
                
            else
                begin
                
                    //Stage 1
                    
                    //Latch the numbers
                    p1_input_a<=input_a;
                    p1_input_b<=input_b;
                    
                    //Stage 2
                    bigNum<=bigNum_w;
                    smallNum<=smallNum_w;
                    p2_zero<=zero_w;
                    
                    p2_NaN<=NaN_w;
                    
                    p2_inf_num<=inf_num_w;
                    //Stage 3
                    p3_small_sig<=small_sig;
                    p3_small_ex<=small_ex;
                    p3_small_shift_float<=shifted_small_float_w;
                
                    
                    p3_big_sig<=big_sig;
                    p3_big_ex<=big_ex;
                    p3_big_float<=big_float;
                    p3_zero<=p2_zero;
                    p3_NaN<=p2_NaN;
                    p3_inf_num<=p2_inf_num;
                    
                    p3_zeroSmall<=zeroSmall;
                    
                    p3_big_fra<=big_fra;
                    //Stage 4
                    p4_small_sig<=p3_small_sig;
                    p4_small_ex<=p3_small_ex;
                    
                    
                    p4_big_sig<=p3_big_sig;
                    p4_big_ex<=p3_big_ex;
                    
                    p4_sum<=sum_w;
                    p4_sum_carry<=sum_carry_w;
                    
                    p4_zero<=p3_zero;
                    p4_NaN<=p3_NaN;
                    p4_inf_num<=p3_inf_num;
                    
                    p4_zeroSmall<=p3_zeroSmall;
                    p4_big_fra<=p3_big_fra;
                   
                    //Stage 5
                    
                    p5_small_sig<=p4_small_sig;
                    p5_small_ex<=p4_small_ex;
                    
                    
                    p5_big_sig<=p4_big_sig;
                    p5_big_ex<=p4_big_ex;
                    
                    p5_sum_shifted<=sum_shifted_w;
                    p5_sum<=p4_sum;
                    p5_sum_carry<=p4_sum_carry;
                    p5_shift_am<=shift_am_w;
                    p5_neg_ex<=neg_ex_w;
                    
                    
                    p5_zero<=p4_zero;
                    
                    p5_NaN<=p4_NaN;
                    p5_inf_num<=p4_inf_num;
                    
                    p5_zeroSmall<=p4_zeroSmall;
                    p5_big_fra<=p4_big_fra;
                  
                    //Stage 6
                    
                    output_z<=result;
                    o_NaN<=p5_NaN;
                    o_overflow<=overflow;
                    o_zero<=p5_zero;
                    
                    
                
                
                
                
                
                end  //end of Reset-else
        
        
        end
     
     






endmodule
