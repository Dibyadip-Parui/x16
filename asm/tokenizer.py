import sys

def CleanData(data: str):

    #clearing the data and compresing down to instruction lines only
    data = data.lower()
    data = data.split(';')

    CLdata = []

    #Clearing out the \n
    for i in range(len(data)):
        data[i] = str.replace(data[i], '\n', '')
    #Clearing out the empty strings ('')
    for i in range(data.count('')):
        data.remove('')
    #Cleearing out comments and white or empty instructions
    for i in data:
        if str.startswith(i, '//'):
            continue
        elif str.startswith(i, ' '):
            continue
        else:
            CLdata.append(i)

    #Spliting the Instructions into indivisula list of opcode and operands
    tmp = []
    CL2data = []
    for i in CLdata:
        tmp = i.split(' ')
        for i in range(tmp.count('')):
            tmp.remove('')
        CL2data.append(tmp)

    return CL2data

def tokenize(data: list):

    #final Tokenization
    keywords = {"add": {"type":"reg.add", "size":1, "operands": 2},
                "sub": {"type":"reg.sub", "size":1, "operands": 2},
                "xor": {"type":"reg.xor", "size":1, "operands": 2},
                "or": {"type":"reg.or", "size":1, "operands": 2},
                "and": {"type":"reg.and", "size":1, "operands": 2},
                "nand": {"type":"reg.nand", "size":1, "operands": 2},
                "addc": {"type":"reg.addc", "size":1, "operands": 2},
                "cmp": {"type":"reg.cmp", "size":1, "operands": 2},
                
                "addi": {"type":"int.addi", "size":2, "operands": 3},
                "subi": {"type":"int.subi", "size":2, "operands": 3},
                "xori": {"type":"int.xori", "size":2, "operands": 3},
                "ori": {"type":"int.ori", "size":2, "operands": 3},
                "andi": {"type":"int.andi", "size":2, "operands": 3},
                "nandi": {"type":"int.nandi", "size":2, "operands": 3},
                "addci": {"type":"int.addci", "size":2, "operands": 3},
                "cmpi": {"type":"int.cmpi", "size":2, "operands": 3}}


    data = CleanData(data)

    tkdata = []

    for i in data:
        try:
            ins = keywords[i[0]]
            op = ins['type'].split('.')[1]
            opT = ins['type'].split('.')[0]

            match opT:

                case "reg":

                    if len(i) > ins["operands"]+1:
                        sys.exit(f"Too many Operands for Instruction: {i}")
                    elif len(i) < ins["operands"]+1:
                        sys.exit(f"Too Less Operands for Instruction: {i}")
                    
                    tmp = {}
                    tmp['ins'] = op
                    tmp['opA'] = i[1]
                    tmp['opB'] = i[2]
                    tkdata.append(tmp)

                case "int":

                    if len(i) > ins["operands"]+1:
                        sys.exit(f"Too many Operands for Instruction: {i}")
                    elif len(i) < ins["operands"]+1:
                        sys.exit(f"Too Less Operands for Instruction: {i}")
                    
                    tmp = {}
                    tmp['ins'] = op
                    tmp['opA'] = i[1]
                    tmp['opB'] = i[2]
                    tmp['opC'] = i[3]
                    tkdata.append(tmp)

        except KeyError:
            sys.exit(f"Invalid Instruction: {i}")

    return tkdata


with open("asm/prog.x16", 'r') as file:
    data = file.read()
    tokenize(data)
