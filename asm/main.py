import tokenizer as tn
import sys

def assemble(filename, output):

    with open(filename, 'r') as file, open(output, 'w') as out:

        data = tn.tokenize(file.read())

        BinIns = {"add": 0b0001, "sub": 0b0001,
                  "xor": 0b0001, "or": 0b0001,
                  "and": 0b0001, "nand": 0b0001,
                  "addc": 0b0001, "cmp": 0b0001,

                  "addi": 0b0010, "subi": 0b0010,
                  "xori": 0b0010, "ori": 0b0010,
                  "andi": 0b0010, "nandi": 0b0010,
                  "addci": 0b0010, "cmpi": 0b0010,

                  "je": 0b0011, "ja": 0b0011,
                  "jb": 0b0011, "jne": 0b0011,
                  "jc": 0b0011}
        
        SubBinIns = {"add": 0b0000, "sub": 0b0001,
                     "xor": 0b0010, "or": 0b0011,
                     "and": 0b0100, "nand": 0b0101,
                     "addc": 0b0110, "cmp": 0b0111,

                     "addi": 0b1000, "subi": 0b1001,
                     "xori": 0b1010, "ori": 0b1011,
                     "andi": 0b1100, "nandi": 0b1101,
                     "addci": 0b1110, "cmpi": 0b1111,

                     "je": 0b1000, "ja": 0b1001,
                     "jb": 0b1010, "jne": 0b1011,
                     "jc": 0b1100}

        registers = {"r0": 0b0000, "r1": 0b0001,
                     "r2": 0b0010, "r3": 0b0011,
                     "r4": 0b0100, "r5": 0b0101,
                     "r6": 0b0110, "r7": 0b0111,}

        lables = {}
        tmp_data = data

        for i in range(0, len(data)-1):
            op = data[i]['ins']

            if (op == "lable"):
                lb = tmp_data.pop(i)
                lables[lb['name']] = lb['addr']
        data = tmp_data

        for i in data:
            try:
                subop = SubBinIns[i['ins']]
                op = BinIns[i['ins']]
                opd1 = registers[i['opA']]
                opd2 = registers[i['opB']]
            except KeyError:
                sys.exit(f"Invalid Instruction/Operands: {i}")

            FinalIns = 0b0000000000000000
            FinalIns = FinalIns | ((subop << 12) | (op << 8) | (opd1 << 4) | opd2)

            try:
                opd3 = i['opC']

                if str.startswith(opd3, '0x'):
                    try:
                        opd3 = int(opd3[2:], 16)
                    except ValueError:
                        sys.exit(f"Invalid Value type: {opd3} at: {i}")
                elif str.startswith(opd3, '0b'):
                    try:
                        opd3 = int(opd3[2:], 2)
                    except ValueError:
                        sys.exit(f"Invalid Value type: {opd3} at: {i}")
                else:
                    try:
                        opd3 = int(opd3)
                    except ValueError:
                        if lables.get(opd3) != None:
                            opd3 = lables[opd3]
                        else:
                            print(lables.get(opd3), opd3)
                            sys.exit(f"Invalid Value type: {opd3} at: {i}")

                FinalIns = (FinalIns << 16) | opd3
            except KeyError:
                pass

            ins = hex(FinalIns)[2:]
            if len(ins) > 4:
                out.write(ins[0:4]+'\n')
                out.write(ins[4:8]+'\n')
            else:
                out.write(ins+'\n')

if __name__ == "__main__":
    args = sys.argv
    assemble(args[1], args[2])