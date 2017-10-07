nodeRef(name("Cannon")).
nodeRef(name("Flag")).
nodeRef(name("Chest")).

pieceRef(size(6,6,2,"TreasureChest"), parent("Chest")).

pieceRef(size(8,6,2, "Cannon1"), parent("Cannon")).

pieceRef(size(1,10,1,"Flagpole"), parent("Flag")).
pieceRef(size(2,1,1,"Flagholder"), parent("Flag")).
pieceRef(size(1,5,3,"PirateFlag"), parent("Flag")).

attachRef("Flagholder", "Flagpole", (1,1,0)).
attachRef("Flagpole", "PirateFlag", (0,5,1)).

focusGroup("Cannon","Cannon1").
focusGroup("Flag", "Flagholder").
focusGroup("Chest", "TreasureChest").

styleAdd("Cannon", onTop,1).

styleAdd("Chest", inside,1).

styleAdd("Flag", onTop, 1).
styleAdd("Flag", onSide, 1).

#show insideOf/2.

%Need to fix the position of the two parts of the Cannon relative to each other