from sys import exit

def tokenize(data):

    data = str.lower(data)
    keywords = {"add":{"type":"ins.reg.add", "operands":2,"size":1},
                "sub":{"type":"ins.reg.sub", "operands":2,"size":1},
                "xor":{"type":"ins.reg.xor", "operands":2,"size":1},
                "or":{"type":"ins.reg.or", "operands":2,"size":1},
                "and":{"type":"ins.reg.and", "operands":2,"size":1},
                "nand":{"type":"ins.reg.nand", "operands":2,"size":1},
                "addc":{"type":"ins.reg.addc", "operands":2,"size":1},
                
                "addi":{"type":"ins.int.addi", "operands":3,"size":2},
                "subi":{"type":"ins.int.subi", "operands":3,"size":2},
                "xori":{"type":"ins.int.xori", "operands":3,"size":2},
                "ori":{"type":"ins.int.ori", "operands":3,"size":2},
                "andi":{"type":"ins.int.andi", "operands":3,"size":2},
                "nandi":{"type":"ins.int.nandi", "operands":3,"size":2},
                "addci":{"type":"ins.int.addci", "operands":3,"size":2},
                
                "lb":{"type":"dir.lb", "operands":1, "size":0},

                "je":{"type":"ins.ci.je", "operands":1,"size":2},
                "ja":{"type":"ins.ci.ja", "operands":1,"size":2},
                "jb":{"type":"ins.ci.jb", "operands":1,"size":2},
                "jne":{"type":"ins.ci.jne", "operands":1,"size":2},
                "jc":{"type":"ins.ci.jc", "operands":1,"size":2},
                
                "//":{"type":"dir.cmt", "operands":2000, "size":0}
                }

    result=[]
    addr = 0
    data = data.split(";")

    data = [text.replace("\n", "") for text in data]

    while 1:
        try:
            data.remove('')
        except ValueError:
            break
    

    for i in data: 
        i = i.split(' ')
        while 1:
            try:
                i.remove('')
            except:
                break
        cmd = i[0]
        try:
            result.append([keywords[cmd], addr])
            addr += keywords[cmd]["size"]
        except KeyError:
            exit(f"Invalid Instruction: {cmd}")
    return result
