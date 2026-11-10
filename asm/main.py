import tokenizer as tn
import sys

def assemble(filename, output):

    with open(filename, 'r') as file:
        data = file.read()

    tkdata = tn.tokenize(data)
    #spliting and clearing
    data = data.lower().split(";")
    data = [text.replace("\n", "") for text in data]
    while 1:
        try:
            data.remove('')
        except ValueError:
            break

    #Dictonaries
    labels = {}
    BinSubIns = {"add": 0b0000, "sub": 0b0001,
                 "xor": 0b0010, "or": 0b0011,
                 "and": 0b0100, "nand": 0b0101,
                 "addc": 0b0110, "shr": 0b0111,
                 
                 "addi": 0b1000, "subi": 0b1001,
                 "xori": 0b1010, "ori": 0b1011,
                 "andi": 0b1100, "nandi": 0b1101,
                 "addci": 0b1110, "shri": 0b1111,

                 "je": 0b1000, "ja": 0b1001,
                 "jb": 0b1010, "jne": 0b1011,
                 "jc": 0b1100
                 }
    
    BinIns = {"reg": 0b0001,
              "int": 0b0010,
              "ci" : 0b0011}
    registers = {"r0": 0b0000, "r1": 0b0001,
                 "r2": 0b0010, "r3": 0b0011,
                 "r4": 0b0100, "r5": 0b0101,
                 "r6": 0b0110, "r7": 0b0111}

    for i in range(len(tkdata)):

            #more spliting and clearing
            tmp2 = data[i].split(' ')
            while 1:
                try:
                    tmp.remove('')
                except:
                    break

            #the real stuff
            tmp = tkdata[i][0]['type'].split('.')
            match tmp[1]:
                
                case "lb":
                    if len(tmp2) == 2:
                        labels[tmp2[1]] = tkdata[i][1]-1
                        binins = 0
                    else:
                        sys.exit(f"Invalid lb opcodes: {tmp}\nInstruction No: {i}")
    with open(output, 'w') as file:
            binins = 0
            for i in range(len(tkdata)):
    
                #more spliting and clearing
                tmp2 = data[i].split(' ')
                while 1:
                    try:
                        tmp.remove('')
                    except:
                        break
    
                #the real stuff
                tmp = tkdata[i][0]['type'].split('.')
                match tmp[1]:
                    case "reg":
                        if len(tmp2) == 3:
                            try:
                                info = tmp
                                SubIns = BinSubIns[info[2]]
                                Ins    = BinIns[info[1]]
                                op1 = registers[tmp2[1]]
                                op2 = registers[tmp2[2]]
    
                                binins = (SubIns << 12) | (Ins << 8) | (op1 << 4) | (op2)
                            except KeyError:
                                sys.exit(f"Wrong register/other name: {data[i]}\nInstruction No: {i}")
                        else:
                            sys.exit(f"Invalid number of opcodes: {data[i]}\nInstruction No: {i}")
                    case "int":
                        if len(tmp2) == 4:
                            try:
                                info = tkdata[i][0]['type'].split('.')
                                SubIns = BinSubIns[info[2]]
                                Ins    = BinIns[info[1]]
                                op1 = registers[tmp2[1]]
                                op2 = registers[tmp2[2]]
    
                                try:
                                    opi = int(tmp2[3], 16)
                                except ValueError:
                                    opi = labels[tmp2[3]]
    
                                binins = (((SubIns << 12) | (Ins << 8) | (op1 << 4) | (op2)) << 16) | opi
                            except KeyError:
                                sys.exit(f"Invalid opcodes: {data[i]}\nInstruction No: {i}")
                        else:
                            sys.exit(f"Invalid  number of opcodes: {data[i]}\nInstruction No: {i}")
                    case "ci":
                        if len(tmp2) == 2:
                            try:
                                info = tkdata[i][0]['type'].split('.')
                                SubIns = BinSubIns[info[2]]
                                Ins    = BinIns[info[1]]
                                op1 = 0b0000
                                op2 = 0b0000
    
                                try:
                                      opi = int(tmp2[1], 16)
                                except ValueError:
                                      opi = labels[tmp2[1]]
                        
                                binins = (((SubIns << 12) | (Ins << 8) | (op1 << 4) | (op2)) << 16) | opi
                            except KeyError:
                                sys.exit(f"Invalid opcodes: {data[i]}\nInstruction No: {i}")
                        else:
                            sys.exit(f"Invalid  number of opcodes: {data[i]}\nInstruction No: {i}")
                    case "lb":
                        if len(tmp2) == 2:
                            labels[tmp2[1]] = tkdata[i][1]-1
                            binins = 0
                        else:
                            sys.exit(f"Invalid lb opcodes: {tmp}\nInstruction No: {i}")
                    case "cmt":
                        pass
                    
                    case _:
                        sys.exit("Error: Invalid Keyword")
                if binins != 0:
                    if len(hex(binins)[2:]) > 4:
                        tmp2 = hex(binins)[2:]
                        file.write(tmp2[0:4]+'\n'+tmp2[4:]+'\n')
                    else:
                        file.write(hex(binins)[2:]+'\n')
            

def hex2bin(filename, output):

    with open(filename, 'r') as file, open(output, 'wb') as fout:
        data = file.read()

        data = data.split('\n')
        data.remove("")
        for i in data:
            IntIns = int(i, 16)
            size = 0

            if (len(i)%2)==0: size = int(len(i)/2)
            else: size = (len(i)//2)+1 
            
            BinIns = int.to_bytes(IntIns, size, 'big')
            fout.write(BinIns)

assemble("asm/prog.x16", "asm/prog.hex")