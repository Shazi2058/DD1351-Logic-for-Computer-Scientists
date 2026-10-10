remove_duplicates(List, Result) :- 
    remove_duplicates(List, [], Result). % start with an empty list to remember which ones we've already seen

remove_duplicates([], _, []). % Empty list returns an empty list,  The base case

remove_duplicates([H|T], Seen, Result) :- % If we have already seen this element before in seen 
    member(H, Seen), !,                   % skip and proceed with the rest of the list 
    remove_duplicates(T, Seen, Result).

remove_duplicates([H|T], Seen, [H|Result]) :- % new element is saved in seen
    remove_duplicates(T, [H|Seen], Result).
  
  % TO run this code, you can use the following query in SWI-Prolog:
  % swipl Assignment_2.pl 
  % ?- remove_duplicates([1,2,3,2,4,1,3,4], E).
  % Result: E = [1, 2, 3, 4].
  % To exit type ctrl + d or use the command halt.

