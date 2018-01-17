:- consult('linguagens.pl').   %considere 'linguagens.pl' dado

% t1C
% -----------------------------------

% Questão 1 (resolvida)
qano(A, N) :- findall(L, linguagem(L, A), La), length(La, N).

% Escrever demais questões...

% Questão 2
qsaopre(L, N) :- findall(L, predecessora(L,_),La), length(La,N).

% Questão 3
qsaopre(N) :- findall(D, predecessora(Dpre, D), L), list_to_set(L, L1), length(L1, N).

% Questão 4
qtempre(N) :- findall(D, predecessora(D, Dpre), L), list_to_set(L, L1), length(L1, N).

% Questão 5
qdecada(D, N) :- findall(L, (linguagem(_, A), A - D >= 0, A - D < 10), Lista), length(Lista, N).

% Questão 6
qtotal(A1, A2, N) :- findall(L, (linguagem(_, A), A >= A1, A =< A2), Lista), length(Lista, N).
