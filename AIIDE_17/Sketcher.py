import subprocess
import json

def generateSketch(spec,count):
    setupSketchFile(spec)
    fileName = "sketchInfo.lp"
    outputFileName = "out.json"

    #Run Clingo, get count results and pipe it into a JSON file
     #Clingo gives exit code 10 for some reason, so we chain into "exit 0" to short circuit that issue
    subprocess.call("clingo sketchTemplate.lp "  + fileName + " --outf=2 " + str(count) + " > " + outputFileName + " & exit 0", shell=True)

    #Parse the output from Clingo
    return parseOutput(outputFileName, count)

def setupSketchFile(spec):
    return None

def parseOutput(fileName, count):
    with open(fileName) as json_data:
        d = json.load(json_data)
        retVal = []
        for i in range(count):
            solution = d['Call'][0]['Witnesses'][i]['Value']
            retVal.append(".\n".join(solution) + ".") #Store the solution in a format that we can just dump straight into the Realizer
        return retVal

def parseOutput2(fileName, count):
    with open(fileName) as json_data:
        d = json.load(json_data)
        retVal = []
        for i in range(count):
            vars = {}
            values = d['Call'][0]['Witnesses'][i]['Value']
            for item in values:
                if item.startswith("groupSize") or item.startswith("groupPos"):
                    type = item.split("(")[0]
                    parse = item.split("(")[1][:-1].split(",")
                    axis = parse[0]
                    axisIdx = 0 if (axis == 'x') else 1 if (axis == 'y') else 2
                    value = int(parse[1])
                    if len(parse) == 3:
                        name = parse[2][1:-1]
                    else: #We have a compound variable
                        name = item.split("(")[2][:-2].split(",")[0][1:-1] + " " + item.split("(")[2][:-2].split(",")[1]
                    if name in vars.keys():
                        vars[name][type][axisIdx] = value
                    else:
                        newEntry = {"groupPos":[-1,-1,-1], "groupSize":[-1,-1,-1]}
                        newEntry[type][axisIdx] = value
                        vars[name] = newEntry
                if item.startswith("groupType"):
                    type = item.split(",")[0].split("(")[1][1:-1]
                    if len(item.split("(")) == 2:
                        name = item.split(",")[1][1:-2]
                    else:
                        name = item.split("(")[2].split(",")[0][1:-1] + " " + item.split("(")[2].split(",")[1][:-2]
                    if name in vars.keys():
                        vars[name]["type"] = type
                    else:
                        newEntry = {"groupPos":[-1,-1,-1], "groupSize":[-1,-1,-1], "type" : type}
                        vars[name] = newEntry

                if item.startswith("specialGroup"):
                    type = item.split("(")[0].replace("specialGroup", "group")
                    parse = item.split("(")[1][:-1].split(",")
                    axis = parse[0]
                    axisIdx = 0 if (axis == 'x') else 1 if (axis == 'y') else 2
                    value = int(parse[1])
                    name = item.split("(")[2].split(")")[0].split(",")[0][1:-1] + " " + item.split("(")[2].split(")")[0].split(",")[1] + " special"
                    pieceType = item.split("(")[3].split(",")[0]
                    orientation = int(item.split("(")[3].split(",")[1][:-2])
                    #Now, we need to wrap this up for vars
                    if name in vars.keys():
                        vars[name][type][axisIdx] = value
                        vars[name]["orient"] = orientation
                        vars[name]["flag"] = "special"
                        vars[name]["pieceType"] = pieceType
                    else: 
                        newEntry = {"groupPos":[-1,-1,-1], "groupSize":[-1,-1,-1]}
                        newEntry[type][axisIdx] = value
                        vars[name] = newEntry


        retVal.append(vars)
    return retVal #Maybe append some metadata, especially if we get into a stage where we're outputing multiple sketches.

def sketch(fileName,styleName):
    lpName = fileName + "Model.lp"
    outPutFile =  fileName + ".json"
    sketchJSONname = fileName + "Sketch.json"
    styleFile = styleName + "Style.lp"

    subprocess.call("clingo sketcher.lp slopes.lp sketchShow.lp applyStyle.lp " + lpName + " " + styleFile + " --outf=2 > " + outPutFile + " & exit 0", shell=True)
    outText = parseOutput2(outPutFile, 1)
    with open(sketchJSONname, "w") as json_out:
        json_out.write(json.dumps(outText))