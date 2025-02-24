from binary16 import *
import re
import random

def ieee_float(n):
    a=struct.unpack('<H',binary16(float(n)))
    a_int=int(a[0])
    b=bin(a_int)[2:]
    b=('0'*(16-len(b)))+b
    decimal_value = int(b, 2)
    hexadecimal_string = hex(decimal_value)
    return hexadecimal_string[2:]

for index in range (0, 64):
    configured_output = open('test_{index}.coe'.format(index = index), 'w')
    context = """
    MEMORY_INITIALIZATION_RADIX=16;
    MEMORY_INITIALIZATION_VECTOR=
    """
    data = """num1num2,
    """

    last_data = """num1num2;
    """
    code = ""
    code += context
    for i in range(0, 4095):
        random_number1 = random.uniform(0, 100)
        random_number2 = random.uniform(0, 100)
        temp = ""
        temp = re.sub("num1", str(ieee_float(random_number1)), data)
        temp = re.sub("num2", str(ieee_float(random_number2)), temp)
        code += temp

    last_random_number1 = random.uniform(0, 100)
    last_random_number2 = random.uniform(0, 100)
    last_temp = ""
    last_temp = re.sub("num1", str(ieee_float(random_number1)), last_data)
    last_temp = re.sub("num2", str(ieee_float(random_number2)), last_temp)
    code += last_temp

    configured_output.write(code)
    configured_output.close()