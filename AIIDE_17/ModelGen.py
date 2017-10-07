import sys
import Sketcher as s
import Realizer as r

if len(sys.argv) == 3:
    #We have a style
    fileName = sys.argv[1]
    style = sys.argv[2]
elif len(sys.argv) == 2:
    fileName = sys.argv[1]
    style = ''
else:
    print("Incorrect usage. Please provide exactly 1 or 2 arguments")
    exit()

s.sketch(fileName,style)
r.realizer(fileName)