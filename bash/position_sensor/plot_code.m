%run('clean');
clear all;
close all;
cx = int16(0);
cy = int16(0);
t=1;
A = csvread('tempplot3to1_4-1.csv');
%disp(A);
j = 1;
rows_csv=rows(A)
for i=1:2:rows_csv-1
    % b=int8([A(i+1) A(i)]);
    % c(j)=typecast(b,'int16');
    t= bitshift((A(i+1)),8)
    cx=bitshift((A(i+1)),8) + (A(i));
    c(j)=cx; %typecast(cx, 'int16');
    c(j)=int8(A(i+1));
    % x=int8(A(i)); % first byte
    % y=int8(A(i+1)); % second byte
    % bytepack=int16(x);
    % bytepack=bitshift(bytepack,8);
    % % Put them together (here, 'y' is placed in lower 8 bits)
    % c(j)=bitor(bytepack,int16(y));

    j = j+1;
end
for i=1:2:rows_csv/2-1
    %disp(c(i));
    %disp(c(i+1));
    x_axis = c(i);
    y_axis = c(i+1);

    plot(x_axis,y_axis,'-o','LineWidth',1,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','g',...
            'MarkerSize',8);
        % axis([-1000 1000 -1000 300]);
        axis auto;
        grid on;
        hold on;
        drawnow;

end
pause(0.1);
disp('plotting ends')
disp('*************')