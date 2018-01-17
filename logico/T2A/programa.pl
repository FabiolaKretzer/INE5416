/*
   Programacao Logica - Prof. Alexandre G. Silva - 30set2015
     Versao inicial     : 30set2015
     Ultima atualizacao : 12set2017

   RECOMENDACOES:

   - O nome deste arquivo deve ser 'programa.pl'

   - O nome do banco de dados deve ser 'desenhos.pl'

   - Dicas de uso podem ser obtidas na execucação:
     ?- menu.

   - Exemplo de uso:
     ?- load.
     ?- searchAll(id1).

   - Colocar o nome e matricula de cada integrante do grupo
     nestes comentarios iniciais do programa
     
     Nome: Fabíola Maria Kretzer    
     Matrícula: 16100725
*/

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
    retractall(xy(_,_,_)),
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
    listing(xy),  %listagem dos predicados 'xy'
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
% t2A
% -----------------------------------

% Questao 1 (resolvida)
% Monta lista <L> com ponto inicial e todos os deslocamentos de <Id>
searchId(Id,L) :- bagof([X,Y], xy(Id,X,Y), L).

% Questao 2
% Monta lista <L> com pontos iniciais de cada <Id>
searchFirst_aux(Id,R) :- searchId(Id,L), L = [R|_].
searchFirst(L) :- bagof(R,Id ^ searchFirst_aux(Id,R),L).

% Questao 3
% Monta lista <L> com pontos ou deslocamentos finais de cada <Id>
elementoFinal([E|[]], E):- !.
elementoFinal([H|T] , E):- elementoFinal(T, E).
searchLast_aux(Aux, Aux, Id) :-	\+searchId(Id, _), !.
searchLast_aux(L, Aux, Id) :-
                        	searchId(Id, List),
                        	New_id is Id +1,
                        	elementoFinal(List, B),
                        	append(Aux, [B], New_list),
                        	searchLast_aux(L, New_list, New_id).
searchLast(L) :- searchLast_aux(L, [], 1).

% Questao 4
% Remove todos os pontos ou deslocamentos do ultimo <Id>
maxId(Max) :- findall(Id,xy(Id,_,_),L), max_list(L,Max).
removeLast :- maxId(Max), retractall(xy(Max,_,_)).

% Questao 5
% Remove o ultimo ponto ou deslocamento de <Id>
lastList([Elem],Elem).
lastList([_|Cauda],Elem) :- last(Cauda,Elem).
removeLast(Id) :- findall(xy(Id,X,Y),xy(Id,X,Y),L),
                  lastList(L,R),
                  retract(R).

% Questao 6
% Determina um novo <Id> na sequencia numerica existente
newId(Id) :- maxId(Max), Id is Max + 1.

% Questao 7
% Duplica a figura com <Id> a partir de um nova posicao (X,Y)
% Deve ser criado um <Id_novo> conforme a sequencia (questao 6)
ultimoElemento([H|F], H).
removeUltimoElemento([H|T], T).
cloneId_aux(Id, []).
cloneId_aux(Id, [H|T]) :- [X_e, Y_e] = H, assert(xy(Id, X_e, Y_e)),	cloneId_aux(Id, T), !.
cloneId(Id,X,Y) :-
            	newId(New_id),
            	searchId(Id, List),
            	ultimoElemento(List, Element),
            	[X_e, Y_e] = Element,
            	X_clone is (X + X_e),
            	Y_clone is (Y + Y_e),
            	assert(xy(New_id, X_clone, Y_clone)),
            	removeUltimoElemento(List, New_list),
            	cloneId_aux(New_id, New_list),
            	!.
	 	  	 	     	    	     	 	     	    	      	 	
