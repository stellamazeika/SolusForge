brickList = {1 : {1 : "3005.DAT", 2 : "3004.DAT", 3 : "3622.DAT", 4 : "3010.DAT", 6 : "3009.DAT", 8 : "3008.DAT", 10: "6111.DAT"},
             2 : {2 : "3003.DAT", 3 : "3002.DAT", 4 : "3001.DAT", 6 : "2456.DAT", 8 : "3007.DAT"}}

plateList = {1 : {1 : "3024.DAT", 2 : "3023.DAT", 3 : "3623.DAT", 4 : "3710.DAT", 6 : "3666.DAT", 8 : "3460.DAT", 10 : "4477.DAT"},
             2 : {2 : "3022.DAT", 3 : "3021.DAT", 4 : "3020.DAT", 6 : "3795.DAT", 8 : "3034.DAT"}}

doorFrame = "60596.DAT"
door = "60623.DAT"
smallWindowFrame = "60593.DAT"
smallWindowPane = "60602.DAT"
largeWindowFrame = "60594.DAT"

grabber = "4085.DAT"
chest1 = "54195.DAT"
chest2 = "62623.DAT" #-16 Y
cannon = "2527C01.DAT"
pirateFlag = "2335P30.DAT"
pole = "3957.DAT"

redBrown = "192"

slopeList = {1 : "3040.DAT", 2 : "3039.DAT"}

rot0 = "1 0 0 0 1 0 0 0 1"
rot90 = "0 0 -1 0 1 0 1 0 0"
rot180 = "-1 0 0 0 1 0 0 0 -1"
rot270 = "0 0 1 0 1 0 -1 0 0"
rotFlip = "1 0 0 0 -1 0 0 0 1"

def getBrickID(a,b):
    if (a <= b):
        x = a
        y = b
    else:
        x = b
        y = a
    try: 
        return brickList[a][b]
    except:
        return ""

def getPlateID(a,b):
    if (a <= b):
        x = a
        y = b
    else:
        x = b
        y = a
    try: 
        return plateList[a][b]
    except:
        return ""

def printSlopePiece(f,piece):
    if "color" in piece:
        color = piece["color"]
    else:
        color = "320"
    xOffset = 0
    zOffset = 0
    dir = int(piece['orientation'][0])
    axis = piece['orientation'][1]
    if (dir == -1 and axis == "x"):
        rot = rot0
        zOffset = 10
    elif (dir == 1 and axis == "x"):
        rot = rot180
        zOffset = -10
    xPos = str(20 * (piece['loc'][0] - 1) + (10* (piece['size'][0])) + xOffset)
    yPos = str(-8*(piece['loc'][1] + piece['size'][1]))
    zPos = str(-20 * (piece['loc'][2] - 1) - (10* (piece['size'][2])) + zOffset)
    pos = xPos + " " + yPos + " " + zPos
    if piece['size'][0] != 2:
        pieceID = slopeList[piece['size'][0]]
    else:
        pieceID = slopeList[piece['size'][2]]
    f.write("1 "+ color + " " + pos + " " + rot + " "  + pieceID + "\n")


def printPieceGroup(f,p):
    name = p['name']
    print p
    if name == "4x6Door":
        printPieceByID(f,p,doorFrame,[0,0,0])
        p['color'] = '1'#'6'
        printPieceByID(f,p,door,[-30,0,5])
    elif name == "4x4Window":
        printPieceByID(f,p,largeWindowFrame,[0,0,0])
    elif name == "2x4Window":
        printPieceByID(f,p,smallWindowFrame,[0,0,0])
        p['color'] = '47'
        printPieceByID(f,p,smallWindowPane,[0,0,0])
    elif name == "TreasureChest":
        p['color'] = '6'
        printPieceByID(f,p,chest1,[0,16,0])
        printPieceByID(f,p,chest2,[0,0,0])
    elif name == "Cannon1":
        p['rot'] = True
        printPieceByID(f,p,cannon,[40,40,0])
    elif name == "Flagholder":
        p['color'] = '0'
        printPieceByID(f,p,grabber,[10,0,0])
    elif name == "Flagpole":
        p['color'] = '0'
        p['flip'] = True
        printPieceByID(f,p,pole,[0,0,0])
    elif name == "PirateFlag":
        printPieceByID(f,p,pirateFlag,[0,0,0])
    else:
        print name

def printPieceByID(f,piece,pieceID,offset):
    if "color" in piece:
        color = piece["color"]
    else:
        color = "0" 
    if (piece['size'][0] <= piece['size'][2]):
        pieceX = piece['size'][0]
        pieceY = piece['size'][2]
        rot = rot0 if 'rot' in piece else rot90
        offset[0], offset[2] = offset[2], offset[0]
    else:
        pieceX = piece['size'][2]
        pieceY = piece['size'][0]
        rot = rot90 if 'rot' in piece else rot0

    if 'flip' in piece:
        rot = rotFlip
    xPos = str(20 * (piece['loc'][0] - 1) + (10* (piece['size'][0])) + offset[0])
    yPos = str(-8*(piece['loc'][1] + piece['size'][1]) + offset[1])
    zPos = str(-20 * (piece['loc'][2] - 1) - (10* (piece['size'][2])) + offset[2])
    pos = xPos + " " + yPos + " " + zPos
    f.write("1 "+ color + " " + pos + " " + rot + " "  + pieceID + "\n")

def printPiece(f,piece):
    #print piece
    if "color" in piece:
        color = piece["color"]
    else:
        color = "4"#"7"
    xPos = str(20 * (piece['loc'][0] - 1) + (10* (piece['size'][0])))
    yPos = str(-8*(piece['loc'][1] + piece['size'][1]))
    zPos = str(-20 * (piece['loc'][2] - 1) - (10* (piece['size'][2])))
    pos = xPos + " " + yPos + " " + zPos
    if (piece['size'][0] <= piece['size'][2]):
        pieceX = piece['size'][0]
        pieceY = piece['size'][2]
        rot = rot90
    else:
        pieceX = piece['size'][2]
        pieceY = piece['size'][0]
        rot = rot0
    if (piece['size'][1] == 3):
        p = getBrickID(pieceX, pieceY)
    else:
        p = getPlateID(pieceX, pieceY)
    f.write("1 "+ color + " " + pos + " " + rot + " "  + p + "\n")

def setupOutput(f):
    f.write("0 untitled model\n")
    f.write("0 Name:\n")
    f.write("0 Author Jo Mazeika\n")

def render(pieceList, outName):
    fOut = open(outName + ".ldr", "w")
    setupOutput(fOut)
    for p in pieceList:
        if p["type"] == "regular":
            printPiece(fOut,p)
        elif p["type"] == "pieceGroup":
            printPieceGroup(fOut,p)
        elif p["type"] == "slopePiece":
            printSlopePiece(fOut,p)

list = [{"type": "regular", "color" : "4", "loc": [0,0,0], "size": [1,3,2]},
        {"type": "regular", "color" : "4", "loc": [0,3,0], "size": [4,3,1]},
        {"type": "regular", "color" : "25", "loc": [1,0,0], "size": [1,1,2]}, 
        {"type": "regular", "color" : "14", "loc": [1,1,0], "size": [1,1,2]}, 
        {"type": "regular", "color" : "2", "loc": [1,2,0], "size": [1,1,2]}, 
        {"type": "regular", "color" : "25", "loc": [0,3,1], "size": [2,1,1]}, 
        {"type": "regular", "color" : "14", "loc": [0,4,1], "size": [2,1,1]}, 
        {"type": "regular", "color" : "2", "loc": [0,5,1], "size": [2,1,1]}]

#render(list, "test")