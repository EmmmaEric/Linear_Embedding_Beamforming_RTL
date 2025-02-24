from binary16 import *
import re
import random
import scipy.io

mat_data = scipy.io.loadmat('X_vec_quantized.mat')

def ieee_float(n):
    a=struct.unpack('<H',binary16(float(n)))
    a_int=int(a[0])
    b=bin(a_int)[2:]
    b=('0'*(16-len(b)))+b
    decimal_value = int(b, 2)
    hexadecimal_string = hex(decimal_value)
    return hexadecimal_string[2:]

def binary_num(n):
    b=bin(n)[2:]
    b=('0'*(12-len(b)))+b  
    return b  

configured_input = open('input.v', 'w')
input_code = ""
for file_num in range (0, 64):
    configured_output = open('memory_rom_{index}.v'.format(index = file_num), 'w')
    
    context_input = """replace_num2replace_num3
    """

    context_top = """
module memory_rom_index(
CLK, rst,
Addr, CEB, Q
);

input CLK, rst;
input [11:0] Addr;
input CEB;		
output [31:0] Q;

(*rom_style = "block" *) reg [31:0] data;

always @(posedge CLK) begin
if (rst) begin
    data <= 32'd0;
end else begin
if (CEB)
case(Addr)
    """
    context_middle = """12'breplace_num1: data <= 32'hreplace_num2replace_num3;
    """

    context_last = """
endcase
end
end

assign Q = data;

endmodule

    """

    code = ""
    context_top = re.sub("index", str(file_num), context_top)
    code += context_top
    for i in range(0,4096):
        random_number1 = random.uniform(0, 2)
        random_number2 = random.uniform(0, 2)
        temp = ""
        temp_input = ""
        temp = re.sub("replace_num1", str(binary_num(i)), context_middle)
        temp = re.sub("replace_num2", str(ieee_float(random_number1)), temp)
        temp = re.sub("replace_num3", str(ieee_float(random_number2)), temp)
        temp_input = re.sub("replace_num2", str(ieee_float(random_number1)), context_input)
        temp_input = re.sub("replace_num3", str(ieee_float(random_number2)), temp_input)
        code += temp
        input_code += temp_input

    code += context_last

    configured_output.write(code)
    configured_output.close()

configured_input.write(input_code)
configured_input.close()