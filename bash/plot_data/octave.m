% This is to suppress the output of the function in the shell.
% -> makes script A LOT faster!!!
silent_functions = 1 

function f()                                   % define a function called f

  load temp4.dat                               % load the data-file temp4.dat and store the values in the matrix temp4
  [y] = length(temp4)                          % estimate the size of the matrix

  for i = 1:y                                  % do the processing
    temp4(i) =  asin((temp4(i)-2.5)/4)*180/pi
  endfor

  save temp5.dat temp4                         % save tha matrix

endfunction                                    % end the function

f()                                            % call the function
