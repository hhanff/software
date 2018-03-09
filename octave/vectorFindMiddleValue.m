#! /usr/bin/octave -qf
% This is to suppress the output of the function in the shell.
% -> makes script A LOT faster!!!
silent_functions = 1

function s = bubblesort(v)
  itemCount = length(v);
  do
    hasChanged = false;
    itemCount--;
    for i = 1:itemCount
      if ( v(i) > v(i+1) )
	v([i,i+1]) = v([i+1,i]);  % swap
	hasChanged = true;
      endif
    endfor
  until(hasChanged == false)
  s = v;
endfunction


function test(v, m)                                   % define a function called f
  s = bubblesort(v)

  if (s(2) == m)
    printf ("OK\n")
  else
    printf ("Fault @ %i\n", v)
    exit
  endif
endfunction                                    % end the function

A = [20, 20, 20]
test(A, 20)
A = [0,0,0]
test(A, 0)
A = [-10,0,10]
test(A, 0)
A = [-10,-10,-10]
test(A, -10)
A = [-10,-10,0]
test(A, -10)
A = [-10,0,-10]
test(A, -10)
A = [0,-10,-10]
test(A, -10)
A = [1,2,3]
test(A, 2)
A = [3,2,1]
test(A, 2)
