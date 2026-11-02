Hello and welcome to my x16 repo
This branch is dedicated to the cpu V2x16
V2x16 is a 16bit cpu whic uses a custom instruction set i developed
It is not a V2x16 and is palned to be only have 14 arithemetic instructions 
The instructions are info are in the InstructionSet file

the prog.hex is a test program used by the testbench it contains the following program

mvi r2 0003
mvi r3 0004
addi r4 r2 0000
add r4 r3

mv r5 r4
addi r4 r0 0003

mvi r7 0004
sub r1 r7

[NOTE: the intermidiate instruction take the intermidiate value as the first value]
[For example subi r1 r2 0004 is r1=0004-r2 not r1=r2-0004]

The cpu.v has the main module that are packed into functional cpu and require a rom to run as
i dont know how to write a hardware rom in verilog.
the main CPU module i in cpu/cpu.v and the testbench is in cpu/testbench.v

The assembler is a python script
It is in assembler/X16A
to use it you type [Path of the script] [input file] [output file]
The assmebler alos produces a .hex file that the test bench can use
Curently the rom module in testbench.v is limited but you can increase it as i dot know much aout testbench syntax yet.