%So this is a sample of a complete structure. Now we just gotta generate it

node(name("Cabin"), parent("Root",1)).
node(name("GroundFloor"), parent("Cabin",1)).
node(name("UpperFloor"), parent("Cabin",1)).
volumeGroup(name("Walls"), type("Hollow",1), parent("GroundFloor",1)). %1 is the wall thickness
volumeGroup(name("Roof"), type("TwinSlopeRoof"), parent("UpperFloor",1)). %TwinSlopeRoof has special rules for deriving the height
pieceGroup(name("Door1"), size(4,18,1,"4x6Door"), parent("GroundFloor",1)).

insetIn(piece("Door1"), volume("Walls"), side(x,"+")).

sizeRange(name("Walls"), x,6,6).
sizeRange(name("Walls"), y,21,24).
sizeRange(name("Walls"), z,6,6).
fixedPos(name("Walls"), dimension(y), pos(1)).

fixedPos(name("Door1"), dimension(y), pos(1)).

slopeAxis("Roof", x).

%This probably could be reduced down? But leave it for now.
relativeSize(name1("Roof"), name2("Walls"), dimension(x), diff(2)). %name1.dim - name2.dim == diff
relativeSize(name1("Roof"), name2("Walls"), dimension(z), diff(0)).
onTopOf(name1("Walls"), name2("Roof")). %Walls Y+J = Roof J
overhang(name1("Roof"), name2("Walls"), dimension(x), val(1)).
relativePos(name1("Roof"), name2("Walls"), dimension(z), diff(0)). %name1.dimPos - name2.dimPos == diff

anchor("Walls").