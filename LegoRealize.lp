row(1..length).
layer(1..height).
col(1..width).
pieceIndex(1..gridSlots).

%Goal: Fill in all of the toFill spaces that aren't empty

%Set up the pieces we're using
%legoCollectionBase(1,1,2).
legoCollectionBase(1,1,3).
legoCollectionBase(1,1,4).
legoCollectionBase(1,1,6).
legoCollectionBase(2,1,2).
legoCollectionBase(2,1,3).
legoCollectionBase(2,1,4).
legoCollectionBase(2,1,6).
legoCollection(Z,Y,X) :- legoCollectionBase(X,Y,Z).
legoCollection(X,Y,Z) :- legoCollectionBase(X,Y,Z).

1 { legoRef(X,Y,Z) : legoCollection(X,Y,Z) } 14.
1 { legoPiece(loc(I,J,K),shape(X,Y,Z)) : row(I), layer(J), col(K), I+X-1 <= length, J+Y-1 <= height, K+Z-1 <= width} gridSlots :- legoRef(X,Y,Z).

%Get the overlap constraint in place
:- legoPiece(loc(I,J,K),shape(X,Y,Z)), legoPiece(loc(I,J-1,K),shape(X,Y,Z)).

target(A,B,C) :- toFill(A,B,C), not empty(A,B,C).

covered(A,B,C) :- legoPiece(loc(I,J,K),shape(X,Y,Z)), A=I..I+X-1, B=J..J+Y-1, C=K..K+Z-1.
%covered(A,B,C) :- bad(A,B,C).

shadows((A,B,C),(I,J,K),(X,Y,Z)) :- legoPiece(loc(I,J,K),shape(X,Y,Z)), A=I..I+X-1, B=J..J+Y-1, C=K..K+Z-1.
cell((A,B,C)) :- row(A), layer(B), col(C).
:- cell(L), 2 { shadows(L,C,P) }.

:- not covered(A,B,C), target(A,B,C).
:- covered(A,B,C), not target(A,B,C).

:~ legoPiece(L,C). [1@0,L,C]

#show legoPiece/2.