#const pieceLimit=100.

legoCollectionBase(1,1,1).
legoCollectionBase(1,1,2).
legoCollectionBase(1,1,3).
legoCollectionBase(1,1,4).
legoCollectionBase(1,1,6).
legoCollectionBase(2,1,2).
legoCollectionBase(2,1,3).
legoCollectionBase(2,1,4).
legoCollectionBase(2,1,6).
%%%%
legoCollectionBase(1,3,1).
legoCollectionBase(1,3,2).
legoCollectionBase(1,3,3).
legoCollectionBase(1,3,4).
legoCollectionBase(1,3,6).
legoCollectionBase(2,3,2).
legoCollectionBase(2,3,3).
legoCollectionBase(2,3,4).
legoCollectionBase(2,3,6).

legoCollection(Z,Y,X) :- legoCollectionBase(X,Y,Z).
legoCollection(X,Y,Z) :- legoCollectionBase(X,Y,Z).

target(X,Y,Z) :- toFill(X,Y,Z), not empty(X,Y,Z).
pos((X,Y,Z),X,Y,Z) :- target(X,Y,Z).

gridSlots(N) :- #count { X,Y,Z : target(X,Y,Z) } = N.

{ blank(N); legoPiece(N, loc(I,J,K), size(X,Y,Z)) : legoCollection(X,Y,Z), target(X+I-1,Y+J-1,Z+K-1)} = 1 :- pos(N,I,J,K).

coveredBy(N,I1,J1,K1) :- legoPiece(N, loc(I,J,K), size(X,Y,Z)), I1 = I..I+X-1, J1 = J..J+Y-1, K1 = K..K+Z-1.

covered(X,Y,Z) :- coveredBy(N,X,Y,Z).

blank(N1) :- legoPiece(N, loc(I,J,K), size(X,Y,Z)), I1 = I+1..I+X-1, J1 = J..J+Y-1, K1 = K..K+Z-1, pos(N1,I1,J1,K1).
blank(N1) :- legoPiece(N, loc(I,J,K), size(X,Y,Z)), I1 = I, J1 = J+1..J+Y-1, K1 = K..K+Z-1, pos(N1,I1,J1,K1).
blank(N1) :- legoPiece(N, loc(I,J,K), size(X,Y,Z)), I1 = I, J1 = J, K1 = K+1..K+Z-1, pos(N1,I1,J1,K1).

:- pos(N,X,Y,Z), 2 { coveredBy(Ni,X,Y,Z) }.

:- target(X,Y,Z), not covered(X,Y,Z).
:- covered(X,Y,Z), not target(X,Y,Z).

#minimize {1@1,N,L,S: legoPiece(N,L,S)}.

%Destroy the universe where 3 plates sit on top of each other.
:- legoPiece(N1, loc(I,J,K), size(X,1,Z)), legoPiece(N2, loc(I,J+1,K), size(X,1,Z)), legoPiece(N3, loc(I,J+2,K), size(X,1,Z)).

%Destroy the universe where 2 identical pieces sit on top of each other.
:- legoPiece(N1, loc(I,J,K), size(X,Y,Z)), legoPiece(N2, loc(I,J+Y,K), size(X,Y,Z)).

#show legoPiece/3.

