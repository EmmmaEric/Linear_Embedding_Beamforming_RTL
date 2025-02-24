from binary16 import *
import re
import random
import scipy.io
import numpy as np

mat_data = scipy.io.loadmat('X_vec_quantized.mat')
vector_data = mat_data['X_vec']
arrays = [vector_data[i, :].reshape(1, -1) for i in range(64)]
print(arrays[0])

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
    b=('0'*(10-len(b)))+b  
    return b  

for file_num in range (0, 64):
    configured_output = open('memory_rom_{index}.v'.format(index = file_num), 'w')

    context_top = """
module memory_rom_index(
CLK, rst,
Addr, CEB, Q
);

input CLK, rst;
input [10:0] Addr;
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
    context_middle = """11'b0replace_num1: data <= 32'hreplace_num2replace_num3;
    """
    context_middle2 = """11'b1replace_num1: data <= 32'd0;
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
    for i in range(0,1024):
        random_number1 = np.real(arrays[file_num][0][i])
        random_number2 = np.imag(arrays[file_num][0][i])
        temp = ""
        temp = re.sub("replace_num1", str(binary_num(i)), context_middle)
        temp = re.sub("replace_num2", str(ieee_float(random_number1)), temp)
        temp = re.sub("replace_num3", str(ieee_float(random_number2)), temp)
        code += temp
    for i in range(0,1024):
        temp = ""
        temp = re.sub("replace_num1", str(binary_num(i)), context_middle2)    
        code += temp  
    code += context_last

    configured_output.write(code)
    configured_output.close()