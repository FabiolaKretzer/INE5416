searchId(Id,L) :- bagof([X,Y], xy(Id,X,Y), L).

%------------------------------------
% t2B
% -----------------------------------

% Questao 1 (resolvida, mas pode ser alterada se necessario)
% Limpa os desenhos e reinicia no centro da tela (de 1000x1000)
tartaruga :-
    retractall(xy(_,_,_)),
    retractall(xylast(_,_,_)),
    retractall(angle(_)),
    retractall(active(_)),
    asserta(xylast(1, 500, 500)),
    assertz(angle(90)),
    assertz(active(1)).


% Questao 2
% Para frente N passos (conforme angulo atual)
parafrente(N) :-
            active(0),
        	angle(A),
            xylast(Id, Xl, Yl),
        	X is (-1) * N * cos(A*pi/180),
        	Y is (-1) * N * sin(A*pi/180),
        	Xlast is Xl + X,
        	Ylast is Yl + Y,
        	retractall(xylast(_, _, _)),
        	asserta(xylast(Id, Xlast, Ylast)),
        	!.

parafrente(N) :-
            active(1),
            xylast(Id, Xl, Yl),
            searchId(Id,L),
            length(L, Tam),
            Tam > 0,
            angle(A),
        	X is (-1) * N * cos(A*pi/180),
        	Y is (-1) * N * sin(A*pi/180),
        	Xlast is Xl + X,
        	Ylast is Yl + Y,
        	retractall(xylast(_, _, _)),
        	assert(xylast(Id, Xlast, Ylast)),
        	new(Id, X, Y),
        	!.

parafrente(N) :-
            active(1),
        	angle(A),
        	X is (-1) * N * cos(A*pi/180),
        	Y is (-1) * N * sin(A*pi/180),
        	xylast(Id, Xl, Yl),
        	Xlast is Xl + X,
        	Ylast is Yl + Y,
        	retractall(xylast(_, _, _)),
        	assert(xylast(Id, Xlast, Ylast)),
                new(Id, Xl, Yl),
        	new(Id, X, Y),
        	!.



% Questao 3
% Para tras N passos (conforme angulo atual)
paratras(N) :-
        	parafrente(-N).

% Questao 4
% Gira a direita G graus
giradireita(G) :-
            angle(Ang),
            New_Ang is (Ang + G) mod 360,
            retractall(angle(_)),
            asserta(angle(New_Ang)),
	    !.

% Questao 5
% Gira a esquerda G graus
giraesquerda(G) :-
            giradireita(-G).

% Questao 6
% Use nada (levanta lapis)
usenada :-
	    retractall(active(_)),
	    assertz(active(0)),
	    !.


% Questao 7
% Use lapis
uselapis :-
	    retractall(active(_)),
	    assertz(active(1)),
	    xylast(Id, X, Y),
	    NewID is Id + 1,
	    retractall(xylast(_, _, _)),
	    assertz(xylast(NewID, X, Y)),
	    !.
