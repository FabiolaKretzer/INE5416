:- consult('linguagens.pl').   %considere 'linguagens.pl' dado

% t1B
% -----------------------------------

% Questão 1 (resolvida)
lingnaosaopre(L) :- linguagem(L, _), \+predecessora(_, L).

% Escrever demais questões...

% Questão 2
lingprecomum(L1, L2, Lp) :- predecessora(L1, Lp), predecessora(L2, Lp), L1 \= L2.

% Questão 3
lingprepre(Lpp, Lp, L) :- predecessora(L, Lp), predecessora(Lp, Lpp).

% Questão 4
lingpredecada(Lp, L) :- predecessora(L, Lp), linguagem(L, A1), linguagem(Lp,A2), L \= Lp, A1 - A2 >= 10.

% Questão 5
lingdecada(L, D) :- linguagem(L,A), A - D >= 0, A - D < 10.

% Questão 6
lingcommultipre(L) :- predecessora(L,X), predecessora(L,Y), X \= Y .
