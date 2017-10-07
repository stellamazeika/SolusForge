
% Need to pick P somehow

containedIn(N,P) 
	:- pieceGroup(name(N), _, parent(P,_)).
containedIn(N,P) 
	:- volumeGroup(name(N), _, parent(P,_)).
containedIn(N,P) :- containedIn(N,P1), node(name(P1), parent(P,1)).

possibleParents(P) :- node(name(P), _).
possibleParents(P) :- node(_, parent(P,_)).

{node(name(N), parent(P,1)) : possibleParents(P)} = 1 
	:- nodeRef(name(N)).

{ connection(N1,N2) : containedIn(N1,P) } = 1
	:- focusGroup(N,N2), node(name(N), parent(P,_)).

% Need to pick N1 somehow
onTopOf(name1(N1), name2(N2)) 
	:- connection(N1,N2), focusGroup(N,N2), styleAdd(N, onTop,1).
insideOf(name1(N1), name2(N2)) 
	:- connection(N1,N2), focusGroup(N,N2), styleAdd(N, inside,1), volumeGroup(name(N1),_,_).
asideOf(name1(N1), name2(N2)) 
	:- connection(N1,N2), focusGroup(N,N2), styleAdd(N, onSide,1).

:- styleAdd(N2, inside,_), focusGroup(N,N2), not insideOf(name1(N), _).

pieceGroup(name(N), size(X,Y,Z,N), P) 
	:- pieceRef(size(X,Y,Z,N),P).

relativePos(name1(N1), name2(N2), dimension(x), diff(X))
	:- attachRef(N1,N2,(X,Y,Z)).
relativePos(name1(N1), name2(N2), dimension(y), diff(Y))
	:- attachRef(N1,N2,(X,Y,Z)).
relativePos(name1(N1), name2(N2), dimension(z), diff(Z))
	:- attachRef(N1,N2,(X,Y,Z)).

#show onTopOf/2.