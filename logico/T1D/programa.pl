:- consult('linguagens.pl').   %considere 'linguagens.pl' dado

% t1D
% -----------------------------------

% Questão 1 (resolvida)
lingmaisantiga_aux([], _, L, L).
lingmaisantiga_aux([H|T], A1, L1, L) :- linguagem(H, A2), A1 =< A2, lingmaisantiga_aux(T, A1, L1, L).
lingmaisantiga_aux([H|T], A1, _ , L) :- linguagem(H, A2), A1 >= A2, lingmaisantiga_aux(T, A2, H , L).

lingmaisantiga(L) :- findall(L1, linguagem(L1, _), Lista), lingmaisantiga_aux(Lista, 9999, _, L).


% Escrever demais questões...


% Questão 2
lingmaisrecente_aux([], _, L, L).
lingmaisrecente_aux([H|T], A1, L1, L) :- linguagem(H, A2), A1 >= A2, !, lingmaisrecente_aux(T, A1, L1, L).
lingmaisrecente_aux([H|T], A1, _ , L) :- linguagem(H, A2), A1 =< A2, !, lingmaisrecente_aux(T, A2, H , L).

lingmaisrecente(L) :- findall(L1, linguagem(L1, _), Lista), lingmaisrecente_aux(Lista, 0, _, L).

% Questão 3
qsaopre(L, N) :- findall(L, predecessora(L,_),La), length(La,N).

lingcommaispre_aux([]   , _  , L, L).
lingcommaispre_aux([H|T], Q1, L1, L) :-	qsaopre(H, Q2), Q1 >= Q2, !, lingcommaispre_aux(T, Q1, L1, L).
lingcommaispre_aux([H|T], Q1, _ , L) :-	qsaopre(H, Q2), Q1 =< Q2, !, lingcommaispre_aux(T, Q2, H , L).

lingcommaispre(L) :- findall(L1, predecessora(L1, _), Lista), lingcommaispre_aux(Lista, 0, _, L).

% Questão 4
qsaosuscessora(L, N) :- findall(L, predecessora(_,L),La), length(La,N).

linginfluente_aux([]   , _  , L, L).
linginfluente_aux([H|T], Q1, L1, L) :-	qsaosuscessora(H, Q2), Q1 >= Q2 , linginfluente_aux(T, Q1, L1, L).
linginfluente_aux([H|T], Q1, _ , L) :-	qsaosuscessora(H, Q2),	Q1 =< Q2 , linginfluente_aux(T, Q2, H , L).

linginfluente(L) :- findall(L1, linguagem(L1, _), Lista), linginfluente_aux(Lista, 0, _, L).

% Questão 5
qano(A, N) :- findall(L, linguagem(L, A), La), length(La, N).

linganocriativo_aux([]   , _  , A, A).
linganocriativo_aux([H|T], Q1, A1, L) :- qano(H, Q2), Q1 >= Q2 , !, linganocriativo_aux(T, Q1, A1, L).
linganocriativo_aux([H|T], Q1, _ , L) :- qano(H, Q2), Q1 =< Q2 , !, linganocriativo_aux(T, Q2, H , L).

linganocriativo(A) :- findall(L1, linguagem(_, L1), Lista), linganocriativo_aux(Lista, 0, _, A).

% Questão 6
qdecada(D, N) :- findall(L, (linguagem(_, A), D // 10 =:= A // 10), Lista), length(Lista, N).

lingdecadacriativa_aux([]   , _  , D, D).
lingdecadacriativa_aux([H|T], Q1, D1, L) :-	qdecada(H, Q2), Q1 >= Q2, !, lingdecadacriativa_aux(T, Q1, D1, L).
lingdecadacriativa_aux([H|T], Q1, _ , L) :-	qdecada(H, Q2), Q1 =< Q2, !, lingdecadacriativa_aux(T, Q2, H , L).

lingdecadacriativa(A) :- findall(L1, linguagem(_, L1), Lista), lingdecadacriativa_aux(Lista, 0, _, A).

% Questão 7
linglistapre_aux(L, Aux, Lp) :- \+predecessora(L, _), !, flatten(Aux, Lp). %gera listas de listas pequenas 
linglistapre_aux(L, Aux, Lp) :- predecessora(L, P), linglistapre_aux(P, [Aux|[P]], Lp).
linglistapre(L , Lp) :- linglistapre_aux(L, [], Lp).
	 	  	 	     	    	     	 	     	    	      	 	
