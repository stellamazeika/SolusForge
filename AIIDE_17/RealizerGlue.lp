tempsize(N,X,Y,Z) :- groupSize(x,X,N),groupSize(y,Y,N),groupSize(z,Z,N).
temppos(N,X,Y,Z) :- groupPos(x,X,N),groupPos(y,Y,N),groupPos(z,Z,N).

empty(X..X+I-1, Y..Y+J-1, Z..Z+K-1) :- temppos(N,X,Y,Z), tempsize(N,I,J,K), groupType("piece",N).
toFill(X..X+I-1, Y..Y+J-1, Z..Z+K-1) :- temppos(N,X,Y,Z), tempsize(N,I,J,K), groupType("volume",N).

empty(X+S..X+I-1-S, Y..Y+J-1, Z+S..Z+K-1-S) :- temppos(N,X,Y,Z), tempsize(N,I,J,K), volumeGroup(name(N),type("Hollow",S),_).

pieceGroupData(N, type(T), loc(I,J,K), size(X,Y,Z)) 
	:- pieceGroup(name(N), size(_,_,_,T),_), 
	groupPos(x,I,N), groupPos(y,J,N), groupPos(z,K,N),
	groupSize(x,X,N), groupSize(y,Y,N), groupSize(z,Z,N).

#show pieceGroupData/4.