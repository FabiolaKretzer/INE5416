/*
   Programacao Logica - Prof. Alexandre G. Silva - 30set2015
     Versao inicial     : 30set2015
     Adicao de gramatica: 15out2015
     Atualizacao        : 12out2016
     Atualizacao        : 10mai2017
     Ultima atualizacao : 12set2017

   RECOMENDACOES:
   
   - O nome deste arquivo deve ser 'programa.pl'
   - O nome do banco de dados deve ser 'desenhos.pl'
   - O nome do arquivo de gramatica deve ser 'gramatica.pl'
   
   - Dicas de uso podem ser obtidas na execucação: 
     ?- menu.
     
   - Exemplo de uso:
     ?- load.
     ?- searchAll(1).

   - Exemplos de uso da gramatica:
     ?- comando([pf, '10'], []).
     Ou simplesmente:
     ?- cmd("pf 10").
   
     ?- comando([repita, '5', '[', pf, '50', gd, '45', ']'], []).
     Ou simplesmente:
     ?- cmd("repita 5[pf 50 gd 45]").
     
   - Colocar o nome e matricula de cada integrante do grupo
     nestes comentarios iniciais do programa
     
     Nome: Fabíola Maria Kretzer    
     Matrícula: 16100725
*/

:- set_prolog_flag(double_quotes, codes).
:- initialization(load).

% Exibe menu principal
menu :-
    write('load.         -> Carrega todos os desenhos do banco de dados para a memoria'), nl,
    write('commit.       -> Grava alteracoes de todos os desenhos no banco de dados'), nl,
    write('new(Id,X,Y).  -> Insere ponto/deslocamento no desenho com identificador <Id>'), nl,
    write('search.       -> Consulta pontos/deslocamentos dos desenhos'), nl,
    write('remove.       -> Remove pontos/deslocamentos dos desenhos'), nl,
    write('svg.          -> Cria um arquivo de imagem vetorial SVG (aplica "commit." antes'), nl.

% Apaga os predicados 'xy' da memoria e carrega os desenhos a partir de um arquivo de banco de dados
load :-
    consult('gramatica.pl'),
    consult('t2b'),
    retractall(xy(_,_,_)),
    retractall(xylast(_,_,_)),
    retractall(angle(_)),
    retractall(active(_)),
    retractall(figureangle(_,_)),
    open('desenhos.pl', read, Stream),
    repeat,
        read(Stream, Data),
        (Data == end_of_file -> true ; assert(Data), fail),
        !,
        close(Stream).

% Grava os desenhos da memoria em arquivo
commit :-
    open('desenhos.pl', write, Stream),
    telling(Screen),
    tell(Stream),
    listing(xylast),  %listagem dos predicados 'xylast'
    listing(angle),   %listagem dos predicados 'angle'
    listing(active),  %listagem dos predicados 'active'
    listing(xy),      %listagem dos predicados 'xy'
    listing(figureangle),   %listagem dos predicados 'figureangle'
    tell(Screen),
    close(Stream).

% Ponto de deslocamento, se <Id> existente
new(Id,X,Y) :-
    xy(Id,_,_),
    assertz(xy(Id,X,Y)),
    !.

% Ponto inicial, caso contrario
new(Id,X,Y) :-
    asserta(xy(Id,X,Y)),
    !.

% Exibe opcoes de busca
search :-
    write('searchId(Id,L).  -> Monta lista <L> com ponto inicial e todos os deslocamentos de <Id>'), nl,
    write('searchFirst(L).  -> Monta lista <L> com pontos iniciais de cada <Id>'), nl,
    write('searchLast(L).   -> Monta lista <L> com pontos/deslocamentos finais de cada <Id>'), nl.

% Exibe opcoes de remocao
remove :-
    write('removeLast.      -> Remove todos os pontos/deslocamentos de <Id>'), nl,
    write('removeLast(Id).  -> Remove o ultimo ponto de <Id>'), nl.

% Grava os desenhos em SVG
svg :-
    commit,
    open('desenhos.svg', write, Stream),
    telling(Screen),
    tell(Stream),
    consult('db2svg.pl'),  %programa para conversao
    tell(Screen),
    close(Stream).

%------------------------------------
%Auxiliares 
%------------------------------------

maxId(Max) :- findall(Id,xy(Id,_,_),L), max_list(L,Max).

newId(Id) :- maxId(Max), Id is Max + 1.

ultimoElemento([_|_], _).

removeUltimoElemento([_|T], T).

%------------------------------------
% t2C
% -----------------------------------

% Questao 1 
% Duplica a figura <Id> (criando um novo identificador), 
% considerando a nova coordenada absoluta inicial como sendo <X,Y>

figuraclone_aux(Id, [H|T]) :-
	[X_aux, Y_aux] = H,
	assert(xy(Id, X_aux, Y_aux)),
	figuraclone_aux(Id, T),!.

figuraclone(Id, X, Y) :-  
	newId(NewId),
	searchId(Id, List),
	ultimoElemento(List, _),
	assert(xy(NewId, X, Y)),
	removeUltimoElemento(List, NewList),
	figuraclone_aux(NewId, NewList),
	!.

	


% Questao 2
% Translada a figura <Id> para <N> passos à frente (este predicado não cria
% um novo identificador; se esta for a intenção de uma aplicação, basta clonar antes)

figuraparafrente(Id,N) :-  
        angle(A),
	X is (-N) * cos(A*pi/180),
	Y is (-N) * sin(A*pi/180),
	searchId(Id, [[X_aux, Y_aux]|_]),
	Xl is X_aux + X,
	Yl is Y_aux + Y,
	retractall(xy(Id, X_aux, Y_aux)),
	asserta(xy(Id, Xl, Yl)),
	!.

% Questao 3
% Translada a figura <Id> para <N> passos para trás (este predicado não cria 
% um novo identificador; se esta for a intenção de uma aplicação, basta clonar antes)

figuraparatras(Id, N) :- figuraparafrente(Id, -N).


% Questao 4
% Rotaciona a figura <Id> em <A> graus no sentido horário a partir de sua 
% coordenada absoluta inicial (este predicado não cria um novo identificador; 
% se esta for a intenção de uma aplicação, basta clonar antes)

figuragiradireita_aux(Id, A, [H|T]) :-
	[X_aux, Y_aux] = H,                  
        X is (X_aux * cos(A * pi/360)) - (Y_aux * sin(A * pi/360)),
        Y is (X_aux * sin(A * pi/360)) + (Y_aux * cos(A * pi/360)),
	assertz(xy(Id, X, Y)),
	figuragiradireita_aux(Id, A, T).

figuragiradireita(Id, A) :-
	searchId(Id, List),
	retractall(xy(Id, _, _)),
	[F|Coord] = List,
	[X, Y] = F,
	assert(xy(Id, X, Y)),
	figuragiradireita_aux(Id, A, Coord),
	!.

% Questao 5
% Rotaciona a figura <Id> em <A> graus no sentido anti-horário a partir de sua
% coordenada absoluta inicial (este predicado não cria um novo identificador; 
% se esta for a intenção de uma aplicação, basta clonar antes)

figuragiraesquerda(Id,A) :- figuragiradireita(Id, -A).

fig1 :- cmd("repita 36 [ gd 150 repita 8 [ pf 50 ge 45 ] ]"), svg. %flor grande.

fig2 :- cmd("repita 72 [ ge 10 pf 5 ]"), svg. %circunferencia

fig3 :- cmd("repita 12 [ pf 100 gd 150 ]"), svg.   % estrela 

fig4 :- cmd("pf 100 gd 90 pf 200"), svg. % triangulo

teste1 :- cmd("figclone 1 250 750"), svg.

teste2 :- cmd("figpf 1 300"), svg.

teste3 :- cmd("figpt 1 350"), svg.

teste4 :- cmd("figgd 1 45"), svg.

teste5 :-  cmd("figge 1 90"), svg.

