slopeSize(X,Y,Z,N,(D,A)) :- 
	specialGroupSize(x,X,N,type(slopePieces,D)), 
	specialGroupSize(y,Y,N,type(slopePieces,D)), 
	specialGroupSize(z,Z,N,type(slopePieces,D)),
	slopeAxis(N,A).

slopePos(X,Y,Z,N,(D,A)) :- 
	specialGroupPos(x,X,N,type(slopePieces,D)), 
	specialGroupPos(y,Y,N,type(slopePieces,D)), 
	specialGroupPos(z,Z,N,type(slopePieces,D)),
	slopeAxis(N,A).

slopePieceRef(2,3,2).
slopePieceRef(1,3,2).
slopePieceRef(2,3,1). %Add back in to make sure we have orientation correct

slopeAxis((N,I),A) :- slopeAxis(N,A), specialGroupSize(x,X,(N,I),type(slopePieces,D)).

slopeFill(A,B,C,D) :- slopeSize(X,Y,Z,N,D), slopePos(I,J,K,N,D), A = I..I+X-1, B = J..J+Y-1, C = K..K+Z-1.

%slopeTarget(X,Y,Z,D) :- slopeFill(X,Y,Z,D), not target(X,Y,Z), not empty(X,Y,Z).

slopeTarget(X,Y,Z,D) :- slopeFill(X,Y,Z,D).

%Need to eventually figure out How To Corners
%Which will actually require some Pondering

{ blank((I,J,K)); slopePiece(D, loc(I,J,K), size(X,Y,Z)) : slopePieceRef(X,Y,Z)} = 1 :- slopeTarget(I,J,K,D).

slopeCoveredBy((I,J,K),I1,J1,K1) :- slopePiece(D, loc(I,J,K), size(X,Y,Z)), I1 = I..I+X-1, J1 = J..J+Y-1, K1 = K..K+Z-1.
slopeCovered(I,J,K) :- slopeCoveredBy(_,I,J,K).

:- slopeTarget(X,Y,Z,D), 2 { slopeCoveredBy(Ni,X,Y,Z) }.

:- slopeTarget(X,Y,Z,D), not slopeCovered(X,Y,Z).
:- slopeCovered(X,Y,Z), not slopeTarget(X,Y,Z,_).

#minimize {1@1,D,L,S: slopePiece(D,L,S)}.

#show slopeSize/5.
#show slopePos/5.

#show slopePiece/3.
#show slopeAxis/2.