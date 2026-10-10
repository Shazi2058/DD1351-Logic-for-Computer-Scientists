edge(1, 2).
edge(2, 3).
edge(3, 5).
edge(4, 5).
edge(4, 2).
edge(5, 6).

find_path(Start, Goal, Path) :-
    path(Start, Goal, [Start], Path). 

path(Goal, Goal, Visited, Visited). % if the current node = goal we are done

path(Node, Goal, Visited, Path) :-
    edge(Node, NextNode), % find our next node
    not_member(NextNode, Visited),             % do not go to a node we have already visited
    appendEl(NextNode, Visited, NewVisited),   % add our node to the list
    path(NextNode, Goal, NewVisited, Path).    % call recursively

not_member(X, List) :-
    member(X, List), !, fail. % if X exists, fail
not_member(_, _).

appendEl(X, [], [X]). % define the rule appendEl
appendEl(X, [H|T], [H|Y]) :-
    appendEl(X, T, Y).

% TO run this code, you can use the following query in SWI-Prolog:
% swipl Assignment_4.pl
% ?- find_path(1, 6, Path).
% Result: Path = [1, 2, 3, 5, 6] ;
%         false.
% To exit type ctrl + d or use the command halt.