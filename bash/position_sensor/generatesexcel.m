clc;
clear all;
close all;

%newobjs = instrfind ; fclose(newobjs); % closes all open serial ports incease they were not closed properly before

s = serial('COM3'); %assigns the object s to serial port

set(s, 'InputBufferSize', 6000); %number of bytes in inout bufferf
set(s, 'FlowControl', 'hardware');
set(s, 'BaudRate', 9600);
set(s, 'Parity', 'none');
set(s, 'DataBits', 8);
set(s, 'StopBit', 1);
set(s, 'Timeout',50);
%clc;

disp(get(s,'Name'));
prop(1)=(get(s,'BaudRate'));
prop(2)=(get(s,'DataBits'));
prop(3)=(get(s, 'StopBit'));
prop(4)=(get(s, 'InputBufferSize'));

disp(['Port Setup Done!!',num2str(prop)]);

fopen(s);           %opens the serial port
tic;
disp('Running');

sheet=1;
get(s,{'InputBufferSize','BytesAvailable','Status'})
t=1;
clk=0;


while(t > 0) %Runs for 10 cycles
    if (clk > 59)
        toc;
        a =fread(s,s.BytesAvailable,'int8'); %reads the data from the serial port and stores it to the matrix
        [stat msg] = xlswrite('tempplot3to1_4.xls',a, sheet);
        t=-5;
    end
    clk=toc;
    t=t+1;  
end
disp('closing serial port');
fclose(s); %close the serial port

