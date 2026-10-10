% Assignment 1 - unification in Prolog
% Consider the following query for a Prolog system:
?- T = f(a,Y,Z) , T = f(X,X,b).

% Answer: X = a, Y = a, Z = b so T = f(a,a,b).
% TO run this code, you can use the following query in SWI-Prolog:
% swipl Assignment_1.pl 
% ?- T = f(a,Y,Z) , T = f(X,X,b).
% To exit type ctrl + d or use the command halt.