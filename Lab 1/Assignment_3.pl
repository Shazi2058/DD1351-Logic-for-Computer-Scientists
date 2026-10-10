partstring(List, L, F) :-
    append(_Prefix, Rest, List), % split the list where rest = F + suffix
    append(F, _Suffix, Rest), % split rest to get F
    my_length(F, L). % take the length of F
    
    my_length([],0).
    my_length([_|T],N) :- 
        length(T,N1), 
        N is N1+1.

% TO run this code, you can use the following query in SWI-Prolog:
% swipl Assignment_3.pl
% ?- partstring([a,b,c,d,e,f], 3, F).
% Result: F = [a, b, c] ; 
%         F = [b, c, d] ; 
%         F = [c, d, e] ; 
%         F = [d, e, f] ;
%         false.
% To exit type ctrl + d or use the command halt.