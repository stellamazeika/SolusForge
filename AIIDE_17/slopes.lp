%This is file is included when we have Slopes involved (Specifically, sloped roofs, but others might come out to play as well)
%slopeAxis is the axis along which the slope varies heights

slopeType("TwinSlopeRoof"). slopeType("FlatTwinSlopeRoof").

slopeSlice(N, slice(A), height(3*(A-1)), side(1)) :- 
	volumeGroup(name(N), type("TwinSlopeRoof"), _), 
	slopeAxis(N, D), 
	groupSize(D1,X, N), 
	opposite(D,D1),
	slopeType(S),
	A = 1..(X+1)/2.
	
slopeSlice(N, slice(X-A), height(3*A), side(-1)) :- 
	volumeGroup(name(N), type("TwinSlopeRoof"), _), 
	slopeAxis(N, D), 
	groupSize(D1,X, N), 
	opposite(D,D1),
	slopeType(S),
	A = 0..(X-1)/2.

groupSize(y,H,(N,A)) :- slopeSlice(N, slice(A), height(H), _).
groupSize(D,1, (N,A)) :- slopeAxis(N, D1), slopeSlice(N, slice(A), height(H), _), opposite(D,D1).
groupSize(D,X, (N,A)) :- slopeAxis(N, D), groupSize(D,X, N), slopeSlice(N, slice(A), height(H), _).

groupPos(y,J, (N,A)) :- groupPos(y,J, N), slopeSlice(N, slice(A), height(H), _).
groupPos(D,X, (N,A)) :- slopeSlice(N, slice(A), height(H), _), groupPos(D,X,N), slopeAxis(N, D).
groupPos(D,X+A-1, (N,A)) :- groupPos(D,I, N), slopeSlice(N, slice(A), height(H), _),  groupPos(D,X, N), slopeAxis(N, D1), opposite(D,D1).

%Need to track which side of the slope that the slice is on
specialGroupSize(D,2, (N,A), type(slopePieces, S)) :- slopeSlice(N, slice(A), _, side(S)), groupSize(D,X, (N,A)), not slopeAxis(N, D), D != y.
specialGroupSize(y,3, (N,A), type(slopePieces, S)) :- slopeSlice(N, slice(A), _, side(S)).
specialGroupSize(D,X, (N,A), type(slopePieces, S)) :- slopeSlice(N, slice(A), _, side(S)), groupSize(D,X, (N,A)), slopeAxis(N, D).
specialGroupPos(D,X, (N,A), type(slopePieces, -1)) :- slopeSlice(N, slice(A), _, side(-1)), groupPos(D,X, (N,A)), D != y.
specialGroupPos(D,X, (N,A), type(slopePieces, 1)) :- slopeSlice(N, slice(A), _, side(1)), groupPos(D,X, (N,A)), slopeAxis(N, D).
specialGroupPos(D,X-1, (N,A), type(slopePieces, 1)) :- slopeSlice(N, slice(A), _, side(1)), groupPos(D,X, (N,A)), opposite(D,D1), slopeAxis(N, D1).
specialGroupPos(y,J+Y, (N,A), type(slopePieces, S)) :- slopeSlice(N, slice(A), _, side(S)), groupPos(y,J, (N,A)), groupSize(y,Y, (N,A)).

groupType("volume", (N,A)) :- slopeSlice(N, slice(A), _, _).

#show slopeAxis/2.