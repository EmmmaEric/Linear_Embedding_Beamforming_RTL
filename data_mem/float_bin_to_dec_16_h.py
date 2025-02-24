import sys


#This code is copied form https://www.geeksforgeeks.org/program-for-conversion-of-32-bits-single-precision-ieee-754-floating-point-representation/
# Python program to convert 
# IEEE 754 floating point representation 
# into real value 

# Function to convert Binary 
# of Mantissa to float value. 
def convertToInt(mantissa_str): 

	# variable to make a count 
	# of negative power of 2. 
	power_count = -1

	# variable to store 
	# float value of mantissa. 
	mantissa_int = 0

	# Iterations through binary 
	# Number. Standard form of 
	# Mantissa is 1.M so we have 
	# 0.M therefore we are taking 
	# negative powers on 2 for 
	# conversion. 
	for i in mantissa_str: 

		# Adding converted value of 
		# Binary bits in every 
		# iteration to float mantissa. 
		mantissa_int += (int(i) * pow(2, power_count)) 

		# count will decrease by 1 
		# as we move toward right. 
		power_count -= 1
		
	# returning mantissa in 1.M form. 
	return (mantissa_int + 1) 

if __name__ == "__main__": 

	if(len(sys.argv)<2):
		print("enter the binary value")
		sys.exit()
	#else:
		#if(len(sys.argv[1])!=16):
			#print("Enter 16 bit binary")
			#sys.exit()

	




	# Floating Point Representation 
	# to be converted into real 
	# value. 
	ieee_20_hex = sys.argv[1]
	# print(ieee_20)

	ieee_20=bin(int(ieee_20_hex,16))[2:].zfill(16)


	# First bit will be sign bit. 
	sign_bit = int(ieee_20[0]) 

	# Next 8 bits will be 
	# Exponent Bits in Biased 
	# form. 
	exponent_bias = int(ieee_20[1 : 6], 2) #str index is open at 6 not including 6th element
	# print(ieee_20[1:5])
	# print(exponent_bias)


	# In 32 Bit format bias 
	# value is 127 so to have 
	# unbiased exponent 
	# subtract 127. 
	exponent_unbias = exponent_bias - 15
	print(exponent_unbias)

	# Next 23 Bits will be 
	# Mantissa (1.M format) 
	mantissa_str = ieee_20[6 : ] 
	# print(mantissa_str)


	# Function call to convert 
	# 23 binary bits into 
	# 1.M real no. form 
	mantissa_int = convertToInt(mantissa_str)
	print(mantissa_int) 

	# The final real no. obtained 
	# by sign bit, mantissa and 
	# Exponent. 
	if(exponent_unbias==-15):
		real_no = pow(-1, sign_bit) *(mantissa_int-1) * pow(2, exponent_unbias+1) 

	elif(exponent_bias==31):
		real_no= pow(-1, sign_bit) * pow(2,31-15)
	else:
		real_no = pow(-1, sign_bit) * mantissa_int * pow(2, exponent_unbias) 
	# Printing the obtained 
	# Real value of floating 
	# Point Representaion. 
	print("The float value of the given IEEE-754 representation is :",real_no) 
