Hello welcome to the x16 repo and thanks to visit my project
I am a 12 year old boy form India trying to make CPUs

This repository has some 16bit risc cpu that i designed in verilog along with its instruction set and a python assembler.

TIPS to use the assembler:
usage: X16A [input file] [output file]
the assembler will also generate a .hex file that has simple human readable hex codes like 0122 and 8E20

The prog.hex file has an example program that does the following
mvi r2 0003
mvi r3 0005
addi r4 r3 0004
add r2 r3
The rom element in the cpu/cpu.v has been limited to 32words but can be increaed upto 65535 words.
Thres is curently no IO in V2x16
This is the latest version of V2x16 as i will make a new V3x16 for making em turning complete.

But You can always note the bugs in V2x16 and inform me so that i can fix them
