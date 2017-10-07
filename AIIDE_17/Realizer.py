import subprocess
import json
import renderer
import re

def realize(sketchFN, outFN, fileNameOffset):
    outputFileName = "Realized" + str(fileNameOffset) + ".json"
    with open(sketchFN) as json_data:
        d = json.load(json_data)
        s = d[0]
        for k in d[0].keys():
            group = s[k]
            if "flag" in group:
                a = 2#print "Special"
            else:
                if group["type"] == "volume":
                    print k
                    print group
    return None

def parse(jsonName):
     with open(jsonName) as json_data:
        d = json.load(json_data)
        pieceList = d['Call'][0]['Witnesses'][-1]['Value']
        outList = []
        for p in pieceList:
            if p.startswith("legoPiece"):
                #We have a brick that's getting placed
                matcher = '(legoPiece).*?(loc).*?(\\d+).*?(\\d+).*?(\\d+).*?(size).*?(\\d+).*?(\\d+).*?(\\d+)'
                rg = re.compile(matcher,re.IGNORECASE|re.DOTALL)
                m = rg.search(p)
                if m:
                    int1=m.group(3)
                    int2=m.group(4)
                    int3=m.group(5)
                    int4=m.group(7)
                    int5=m.group(8)
                    int6=m.group(9)
                    loc = [int(m.group(3)), int(m.group(4)), int(m.group(5))]
                    size = [int(m.group(7)), int(m.group(8)), int(m.group(9))]
                    outList.append({"type": "regular", "loc": loc, "size": size})
            elif p.startswith("slopePiece"):
                #We have a slopePiece from the slope engine
                matcher = '.*?([-+]?\\d+).*?..*?(.).*?(\\d+).*?(\\d+).*?(\\d+).*?(\\d+).*?(\\d+).*?(\\d+)'
                rg = re.compile(matcher,re.IGNORECASE|re.DOTALL)
                m = rg.search(p)
                if m:
                    orient = [m.group(1), m.group(2)]
                    loc = [int(m.group(3)),int(m.group(4)),int(m.group(5))]
                    size = [int(m.group(6)),int(m.group(7)),int(m.group(8))]
                    outList.append({"type": "slopePiece", "orientation": orient, "loc": loc, "size": size})
                a = 3 
            elif p.startswith("pieceGroupData"):
                #We have a piece group that needs to be handled.
                matcher = '.*?(".*?").*?(".*?").*?(\\d+).*?(\\d+).*?(\\d+).*?(\\d+).*?(\\d+).*?(\\d+)'
                rg = re.compile(matcher,re.IGNORECASE|re.DOTALL)
                m = rg.search(p)
                if m:
                    string1=m.group(2)[1:-1]
                    loc = [int(m.group(3)),int(m.group(4)),int(m.group(5))]
                    size = [int(m.group(6)),int(m.group(7)),int(m.group(8))]
                    outList.append({"type": "pieceGroup", "name": string1, "loc": loc, "size": size})
        return outList

def buildLP(jsonName,lpName):
    with open(jsonName) as json_data:
        d = json.load(json_data)
        pieceList = d['Call'][0]['Witnesses'][-1]['Value']
        with open(lpName, "w") as f:
            for p in pieceList:
                f.write(p + ".\n")

#realize("houseSketch.json", "houseReal.json", 1) #Will worry about that last parameter later.

def realizer(fileName):
    outputFile =  fileName + ".json"
    realizerLPName = fileName + "Sketch.lp"
    realOutJSON = fileName + "Real.json"

    buildLP(outputFile, realizerLPName)
    print "Start Realizer Clingo call"
    subprocess.call("clingo Realizer.lp slopeRealizer.lp RealizerGlue.lp "+ realizerLPName +" --opt-strategy=usc,0 --parallel-mode=4 --outf=2 > "+ realOutJSON +" & exit 0", shell=True)
    print "Clingo finished"
    parseList = parse(realOutJSON)
    renderer.render(parseList, fileName)