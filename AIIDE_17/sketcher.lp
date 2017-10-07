#const length=16.
#const height=36. %Allows for 7-high first floor and 5-high roof
#const width=16.

dimension(x). dimension(y). dimension(z).
opposite(x,z). opposite(z,x).

simpleVolume("Hollow"). simpleVolume("Solid").

specialVolume(N) :- volumeGroup(name(N), type(T), _), not simpleVolume(T).

maxSize(x,length).
maxSize(y,height).
maxSize(z,width).

cells(D,V) :- maxSize(D,S), V = 1..S.

groupName(N) :- volumeGroup(name(N), _, _).
groupName(N) :- pieceGroup(name(N), _, _).

{groupPos(D,X, N) : cells(D,X)} = 1 :- anchor(N), not fixedPos(name(N), dimension(D), _), dimension(D).
groupPos(D,X, N) :- anchor(N), fixedPos(name(N), dimension(D), pos(X)).

:- groupPos(D,I, N), groupSize(D,X, N), maxSize(D,M), I+X-1 > M.

{groupSize(D,X, N) : X = X1..X2} = 1 :- volumeGroup(name(N), _, _), sizeRange(name(N), D,X1,X2).

groupSize(D,(X1+Y), N) :- relativeSize(name1(N), name2(N1), dimension(D), diff(Y)), groupSize(D,X1, N1).
groupPos(D,(X1+Y), N) :- relativePos(name1(N), name2(N1), dimension(D), diff(Y)), groupPos(D,X1, N1).

groupPos(D,I-V, N) :- overhang(name1(N), name2(N1), dimension(D), val(V)), groupPos(D,I, N1).

groupPos(y,Y+J, N) :- onTopOf(name1(N1), name2(N)), groupSize(y,Y, N1), groupPos(y,J, N1).

groupPos(x,X+I-1,N) :- asideOf(name1(N1), name2(N)), groupPos(x,X,N1), groupSize(x,I,N1).

{groupPos(D,X+1..X+I-I1-1,N) } = 1 :- groupPos(D,X,N1), groupSize(D,I,N1), insideOf(name1(N1), name2(N)), groupSize(D,I1,N).

:- not groupPos(D,X,N), fixedPos(name(N), dimension(D), pos(X)).

groupSize(y,Y,N) :- pieceGroup(name(N), size(X,Y,Z,_), _).
{groupSize(x,X,N); groupSize(x,Z,N)} = 1 :- pieceGroup(name(N), size(X,Y,Z,_), _).
{groupSize(z,X,N); groupSize(z,Z,N)} = 1 :- pieceGroup(name(N), size(X,Y,Z,_), _).

:- groupSize(x,X1,N), groupSize(z,X1,N), pieceGroup(name(N), size(X,Y,Z,_), _), X != Z.

%%%%%% INSET_IN %%%%%%%

groupSize(D,X, N) :- pieceGroup(name(N), size(X,Y,Z,_), _), insetIn(piece(N), volume(N1), side(D,_)).
groupSize(y,Y, N) :- pieceGroup(name(N), size(X,Y,Z,_), _), insetIn(piece(N), volume(N1), _).
groupSize(D1,Z, N) :- pieceGroup(name(N), size(X,Y,Z,_), _), insetIn(piece(N), volume(N1), side(D,_)), opposite(D,D1).

{groupPos(y,J, N) : J = J1..J1+Y1-Y-1 } =1 :- 
	insetIn(piece(N), volume(N1), _), 
	groupSize(y,Y1, N1), 
	groupPos(y,J1, N1), 
	groupSize(y,Y, N).

{groupPos(D,I, N) : I=I1+1..X1+I1-X-1 } =1 :- insetIn(piece(N), volume(N1), side(D,_)), 
	groupSize(D,X1, N1), groupPos(D,I1, N1), groupSize(D,X, N).

groupPos(D,K, N) :- insetIn(piece(N), volume(N1), side(D1,"-")), groupPos(D,K, N1), opposite(D,D1).
groupPos(D,K+Z-1, N) :- insetIn(piece(N), volume(N1), side(D1,"+")), groupPos(D,K, N1), groupSize(D,Z, N1), opposite(D,D1).

%%%%%% CONSTRAINTS

:- dimension(D), groupName(N), #count{X :groupPos(D,X,N)} > 1.
:- dimension(D), groupName(N), #count{X :groupSize(D,X,N)} > 1.

%%%%% PIECE INTERSECTION

intersectionAxis(D, N, N1) :- 
	dimension(D), N != N1,
	groupType("piece", N), groupType("piece", N1),
	groupPos(D,K, N), groupPos(D,K1, N1), 
	groupSize(D,X,N), groupSize(D,X1,N1),
	K <= K1, K1 <= K+X-1.

showPos(X,Y,Z,N) :- groupType("piece", N), groupPos(x,X,N), groupPos(y,Y,N), groupPos(z,Z,N).
showSize(X,Y,Z,N) :- groupType("piece", N), groupSize(x,X,N), groupSize(y,Y,N), groupSize(z,Z,N).

intersectionAxis(D,N1,N) :- intersectionAxis(D,N,N1).

:- groupType("piece", N), groupType("piece", N1), intersectionAxis(D,N,N1) : dimension(D).

%%% SHOW STATEMENTS

badSize(D,N) :- dimension(D), groupName(N), not groupSize(D,_,N).
badPos(D,N) :- dimension(D), groupName(N), not groupPos(D,_,N).

badCount(S,P) :- S = #count{D,N : badSize(D,N)}, P = #count{D,N : badPos(D,N)}.

groupType("volume", N) :- volumeGroup(name(N), _,_).
groupType("piece", N) :- pieceGroup(name(N), _, _).