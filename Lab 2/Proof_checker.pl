/* Proof_Checker.pl
    This file written 2026 by Muhammad Shahwaiz Abbasi and Husien Jewad
 -----------------------------------------------------------------------
    How to Run all tests ⬇
    cd tests
    swipl -g "['run_all_tests.pl'], run_all_tests('../Proof_checker.pl')" -g halt

    How to Run specific test ⬇
    Test file that is SUPPOSED TO BE CORRECT
    swipl -s Proof_checker.pl -g "(verify('Correct proof.txt') -> writeln('TEST PASSED: Correct proof verified') ; writeln('TEST FAILED: Should have been valid, but failed')), halt."

    Test file that is SUPPOSED TO BE INCORRECT
    swipl -s Proof_checker.pl -g "(\+ verify('incorrect proof.txt') -> writeln('TEST PASSED: Error correctly caught') ; writeln('TEST FAILED: Incorrect proof was wrongly accepted')), halt."
*/

% Verify
verify(InputFileName) :- see(InputFileName),
                         read(Prems), read(Goal), read(Proof),
                         seen,
                         valid_proof(Prems, Goal, Proof).

% Valid proof
valid_proof(Prems, Goal, Proof) :-
    is_last(Proof, [_, LastFormula, _]),
    LastFormula = Goal, 
    check_lines(Prems, Proof, []). 

% Is last
is_last([X], X).
is_last([_|Rest], X) :-
    is_last(Rest, X).

% Is list
is_list([]).
is_list([_|_]).

% Check lines
check_lines(_, [], _). 

% Box Check
check_lines(Prems, [Box | Rest], Previous) :-
    is_list(Box), 
    Box = [AssumpLine | BoxLines],
    % Assumption
    AssumpLine = [_, _, assumption],
    check_lines(Prems, BoxLines, [AssumpLine | Previous]),  
    check_lines(Prems, Rest, [Box | Previous]).

% Check lines
check_lines(Prems, [Line | Rest], Previous) :- 
    check_line(Prems, Line, Previous), 
    check_lines(Prems, Rest, [Line | Previous]). 

% Premise 
check_line(Prems, [_, X, premise], _) :- 
    member(X, Prems).

% Copy 
check_line(_, [_, X, copy(A)], Previous) :- 
    member([A, X, _], Previous).

% And Introduction
check_line(_, [_, and(X,Y), andint(A,B)], Previous) :-
    member([A, X, _], Previous),
    member([B, Y, _], Previous).

% And Elimination 1
check_line(_, [_, X, andel1(A)], Previous) :-
    member([A, and(X,_), _], Previous).

% And Elimination 2
check_line(_, [_, X, andel2(A)], Previous) :-
    member([A, and(_,X), _], Previous).

% Or Introduction 1
check_line(_, [_, or(X,_), orint1(A)], Previous) :-
    member([A, X, _], Previous).

% Or Introduction 2
check_line(_, [_, or(_,Y), orint2(A)], Previous) :-
    member([A, Y, _], Previous).

% Or Elimination
check_line(_, [_, X, orel(A, B, C, D, E)], Previous) :-
    member([A, or(Y, Z), _], Previous),
    member(Box1, Previous),
    % Box Check
    Box1 = [[B, Y, assumption] | _],
    is_last(Box1, [C, X, _]),
    member(Box2, Previous),
    % Box Check
    Box2 = [[D, Z, assumption] | _],
    is_last(Box2, [E, X, _]).

% Implication Introduction
check_line(_, [_, imp(X,Y), impint(A,B)], Previous) :-
    member(Box, Previous),
    % Box Check
    Box = [[A, X, assumption] | _],
    is_last(Box, [B, Y, _]).

% Implication Elimination
check_line(_, [_, Y, impel(A,B)], Previous) :-
    member([A, X, _], Previous),
    member([B, imp(X,Y), _], Previous).

% Contradiction Elimination
check_line(_, [_, _, contel(A)], Previous) :-
    member([A, cont, _], Previous).

% Double negation Introduction
check_line(_, [_, neg(neg(X)), negnegint(A)], Previous) :-
    member([A, X, _], Previous).

% Double negation elimination
check_line(_, [_, X, negnegel(A)], Previous) :- 
    member([A, neg(neg(X)), _], Previous). 

% Negation elimination
check_line(_, [_, cont, negel(A,B)], Previous) :-
    member([A, X, _], Previous), 
    member([B, neg(X), _], Previous). 

% Negation Introduction
check_line(_, [_, neg(X), negint(A,B)], Previous) :-
    member(Box, Previous),
    % Box Check
    Box = [[A, X, assumption] | _],
    is_last(Box, [B, cont, _]). 

% Modus Tollens
check_line(_, [_, neg(X), mt(A,B)], Previous) :-
    member([A, imp(X,Y), _], Previous), 
    member([B, neg(Y), _], Previous). 

% Proof by Contradiction 
check_line(_, [_, X, pbc(A,B)], Previous) :-
    member(Box, Previous),
    % Box Check
    Box = [[A, neg(X), assumption] | _],  
    is_last(Box, [B, cont, _]).

% Law of Excluded Middle (LEM )
check_line(_, [_, or(X, neg(X)), lem], _).
