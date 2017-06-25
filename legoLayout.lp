row(1..length).
layer(1..height).
col(1..width).

1 { legoChoice(X,Y,Z,N); legoChoice(Z,Y,X,N) } 1 :- legoShape(X,Y,Z,N).

1 { legoPiece(loc(I,J,K),shape(X,Y,Z,N)) : row(I), layer(J), col(K), I+X-1 <= length, J+Y-1 <= height, K+Z-1 <= width } 1:- legoChoice(X,Y,Z,N). %Places the groups at valid positions
legoPiece(loc(I,J,K), shape(X,Y,Z,N)) :- I = X1 + I1, I > 0, J = Y1 + J1, J > 0, K = Z1 + K1, K > 0, I+X-1 <= length, J+Y-1 <= height, K+Z-1 <= width, legoAdjoin(adjacent(X1,Y1,Z1,N1), shape(X,Y,Z,N)), legoPiece(loc(I1,J1,K1), shape(X2,Y2,Z2,N1)).

1 {legoPiece(loc(I,J,K),shape(X,Y,Z,N)) : row(I), layer(J), col(K), I+X-1 <= length, I <= X1+I1-1, I1 <= X+I-1, J1+Y1-1 = J-1, J+Y-1 <= height,  K+Z-1 <= width, K <= Z1+K1-1, K1 <= Z+K-1} 1 :- legoAtop(otherName(N1), shape(X,Y,Z,N)), legoPiece(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)).
1 {legoPiece(loc(I,J,K),shape(X,Y,Z,N)) : row(I), layer(J), col(K), I+X-1 <= length, I <= X1+I1-1, I1 <= X+I-1, J1+Y1-1 = J-1, J+Y-1 <= height,  K+Z-1 <= width, K <= Z1+K1-1, K1 <= Z+K-1} 1 :- legoAtop(otherName(N1), shape(X,Y,Z,N)), legoVolume(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)).

1 {legoVolume(loc(I,J,K), shape(X,Y,Z,N)) : I = I1, K = K1, J1 + Y1 = J, X = X1, layer(Y), Z = Z1, J+Y-1 <= height} 1 :- legoAtop(otherName(N1), volume(N)), legoPiece(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)).

1 {legoPiece(loc(I,J,K),shape(X,Y,Z,N)) : row(I), layer(J), col(K), I+X-1 <= length, I <= X1+I1-1, I1 <= X+I-1, J+Y-1 = J1-1, J+Y-1 <= height,  K+Z-1 <= width, K <= Z1+K1-1, K1 <= Z+K-1} 1 :- legoBelow(otherName(N1), shape(X,Y,Z,N)), legoPiece(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)).
1 {legoPiece(loc(I,J,K),shape(X,Y,Z,N)) : row(I), layer(J), col(K), I+X-1 <= length, I <= X1+I1-1, I1 <= X+I-1, J+Y-1 = J1-1, J+Y-1 <= height,  K+Z-1 <= width, K <= Z1+K1-1, K1 <= Z+K-1} 1 :- legoBelow(otherName(N1), shape(X,Y,Z,N)), legoVolume(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)).

1 {legoPiece(loc(I,J,K),shape(X,Y,Z,N)) : row(I), layer(J), col(K), I1 < I, I+X-1 < I1+X1-1, J1 < J, J+Y-1 < J1+Y1-1, K1 < K, K+Z-1 < K1+Z1-1} 1 :- legoContained(volName(N1), shape(X,Y,Z,N)), legoVolume(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)).

1 {legoPiece(loc(I,J,K),shape(X,Y,Z,N)) : row(I), layer(J), col(K), I+X-1 <= length, J+Y-1 <= height, K+Z-1 <= width } 1 :- legoInset(volName(N1), shape(X,Y,Z,N)), legoVolume(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)).

1 { legoVolume(loc(I,J,K), shape(X,Y,Z,N)) : row(I), layer(J), col(K), I+X-1 <= length, J+Y-1 <= height, K+Z-1 <= width } 1 :- legoVolSize(X,Y,Z,N).

%Now we need to test constraints

%No intersection between Piece Groups
%Can rewrite to include |2*I2 + X2 - 2*I1 - X1| < X1 + X2. as the 'bad' case
:- legoPiece(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)), legoPiece(loc(I2,J2,K2), shape(X2,Y2,Z2,N2)), N1 != N2, I1 <= I2, K1 <= K2, I1 + X1 > I2, K1 + Z1 > K2, J1 <= J2, J1 + Y1 > J2.
:- legoPiece(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)), legoPiece(loc(I2,J2,K2), shape(X2,Y2,Z2,N2)), N1 != N2, I1 <= I2, K2 <= K1, I1 + X1 > I2, K2 + Z2 > K1, J1 <= J2, J1 + Y1 > J2.
:- legoPiece(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)), legoPiece(loc(I2,J2,K2), shape(X2,Y2,Z2,N2)), N1 != N2, I1 <= I2, K1 <= K2, I1 + X1 > I2, K1 + Z1 > K2, J2 <= J1, J2 + Y2 > J1.
:- legoPiece(loc(I1,J1,K1), shape(X1,Y1,Z1,N1)), legoPiece(loc(I2,J2,K2), shape(X2,Y2,Z2,N2)), N1 != N2, I1 <= I2, K2 <= K1, I1 + X1 > I2, K2 + Z2 > K1, J2 <= J1, J2 + Y2 > J1.

:- minHeight(N, V), legoPiece(loc(I,J,K),shape(X,Y,Z,N)), V > J.
:- maxHeight(N, V), legoPiece(loc(I,J,K),shape(X,Y,Z,N)), V < J.
:- heightDiff(PN, VN, DY),  legoPiece(loc(I1,J1,K1),shape(X1,Y1,Z1,PN)), legoVolume(loc(I2,J2,K2), shape(X2,Y2,Z2,VN)), abs(J1-J2) != DY.

groupName(N) :- legoPiece(loc(_,_,_), shape(_,_,_,N)).
groupName(N) :- legoVolume(loc(_,_,_), shape(_,_,_,N)).

legoPos(I,J,K) :- legoPiece(loc(I,J,K),_).
legoPos(I,J,K) :- legoVolume(loc(I,J,K),_).

:- not legoPos(1,_,_).
:- not legoPos(_,1,_).
:- not legoPos(_,_,1).   

#show legoPiece/2.
#show legoVolume/2.