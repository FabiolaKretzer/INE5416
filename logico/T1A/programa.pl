:- consult('linguagens.pl').

% Questão 1 (resolvida)
lingcompre(L) :- predecessora(L, _).

% Escrever demais questões...

% Questão 2
lingprecompre(L) :- predecessora(L, _), predecessora(_, L).

% Questão 3
lingpreano(Lp, A) :- predecessora(F,Lp), linguagem(F,A).