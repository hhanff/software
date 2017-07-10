clc
clear all
close all

[a,descr] = xlsfinfo('Vane_Shear_r2.xls')

exl = actxserver('excel.application');

VS58_Data = xlsread( 'Vane_Shear_r2.xls', 'Max104582');


% % VS58_Data = xlsread('Vane_Shear_r2.xls', 'Max10458');
% % VS55_Data = xlsread('Vane_Shear_r2.xls', 'Max10455');


% % [VS58_Data] = xlsread('Vane_Shear_r2.xls', 'Max10458');
% % [VS55_Data] = xlsread('Vane_Shear_r2.xls', 'Max10455');


