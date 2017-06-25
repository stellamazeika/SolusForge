#const length=12.
#const height=6.
#const width=8.

#const gridSlots = width*height*length.

legoShape(4,2,4,"baseMid").
legoAdjoin(adjacent(-2,1,1,"baseMid"), shape(2,1,2,"baseFront")).
legoAdjoin(adjacent(-1,0,-1,"baseFront"), shape(1,1,4,"baseFrontEnd")).
legoAdjoin(adjacent(4,1,1,"baseMid"), shape(2,1,2,"baseBack")).
legoAdjoin(adjacent(2,0,-1,"baseBack"), shape(1,1,4,"baseBackEnd")).

:- not legoPiece(_,shape(2,1,2,"baseFront")).
:- not legoPiece(_,shape(2,1,2,"baseBack")).
:- not legoPiece(_,shape(1,1,4,"baseBackEnd")).
:- not legoPiece(_,shape(1,1,4,"baseFrontEnd")).

legoBelow(otherName("baseFrontEnd"), shape(1,1,4,"wheelsFront")).
:- not legoPiece(_,shape(1,1,4,"wheelsFront")).
legoAdjoin(adjacent(-1,0,-1,"wheelsFront"), shape(3,3,1,"wheelsFrontR")).
:- not groupName("wheelsFrontR").
legoAdjoin(adjacent(-1,0,4,"wheelsFront"), shape(3,3,1,"wheelsFrontL")).
:- not groupName("wheelsFrontL").

legoBelow(otherName("baseBackEnd"), shape(1,1,4,"wheelsBack")).
:- not legoPiece(_,shape(1,1,4,"wheelsBack")).
legoAdjoin(adjacent(-1,0,-1,"wheelsBack"), shape(3,2,1,"wheelsBackR")).
:- not groupName("wheelsBackR").
legoAdjoin(adjacent(-1,0,4,"wheelsBack"), shape(3,2,1,"wheelsBackL")).
:- not groupName("wheelsBackL").

legoAtop(otherName("baseFront"), shape(3,4,4, "windshield")).
:- not groupName("windshield").

legoAdjoin(adjacent(0,2,-1,"baseMid"), shape(6,1,2, "sidesR")).
:- not groupName("sidesR").	

legoAdjoin(adjacent(0,2,3,"baseMid"), shape(6,1,2, "sidesL")).
:- not groupName("sidesL").	

legoAtop(otherName("baseBack"), volume("back")).
:- not groupName("back").