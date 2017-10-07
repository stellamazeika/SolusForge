node(name("Cabin"), parent("Root",1)).
node(name("CabinSides"), parent("Cabin",1)).
pieceGroup(name("CabinFront"), type("Windshield"), parent("Cabin",1)).
volumeGroup(name("CabinBack"), type("SolidBrick"), parent("Cabin",1)).
pieceGroup(name("CabinLeft"), type("AngleSplayL"), parent("CabinSides",1)).
pieceGroup(name("CabinRight"), type("AngleSplayR"), parent("CabinSides",1)).

node(name("Wheels"), parent("Root",1)).
node(name("FrontWheels"), parent("Wheels",1)).
node(name("BackWheels"), parent("Wheels",1)).
pieceGroup(name("FrontPlate"), type("WheelPlate"), parent("FrontWheels",1)).
pieceGroup(name("LFrontTires"), type("WheelsTires"), parent("FrontWheels",1)).
pieceGroup(name("RFrontTires"), type("WheelsTires"), parent("FrontWheels",1)).
pieceGroup(name("BackPlate"), type("WheelPlate"), parent("BackWheels",1)).
pieceGroup(name("LBackTires"), type("WheelsTires"), parent("BackWheels",1)).
pieceGroup(name("RBackTires"), type("WheelsTires"), parent("BackWheels",1)).

pieceGroup(name("CarBase"), type("CarBase"), parent("Root",1)).

onTopOf(name1("CarBase"), name2("Cabin")).
atFront(name1("CarBase"), name2("CabinFront")).
atBack(name1("CarBase"), name2("CabinBack")).
atRight(name1("CarBase"), name2("CabinRight")).
atLeft(name1("CarBase"), name2("CabinLeft")).

onBottomOf(name1("CarBase"), name2("Wheels")).
atFront(name1("CarBase"), name2("FrontWheels")).
atBack(name1("CarBase"), name2("BackWheels")).

adjacentLeft(name1("LFrontTires"), name2("FrontPlate")).
adjacentRight(name1("RFrontTires"), name2("FrontPlate")).
adjacentLeft(name1("LBackTires"), name2("BackPlate")).
adjacentRight(name1("RBackTires"), name2("BackPlate")).

wheelAttach(wheels("FrontTires"), peg("FrontPlate")).
wheelAttach(wheels("BackTires"), peg("BackPlate")).

anchor("CarBase").
