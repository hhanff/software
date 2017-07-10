%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Kreta_mscl.m
%Created By:  Meghan Irving
%Created on:  11-07-06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots data collected from the MSCL (Multi Sensor Core Logger), Pwave
%Velocity, Density, Magnetic Susceptibility, and Fractional Porosity, as
%well as Jpeg image of whole core.  Saves each figure as a jpeg in the
%folder of each core.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Initialize MATLAB
clc
clear all 
close all

%Homedirectory
homedir='C:\Dokumente und Einstellungen\Geolab\Desktop\Meghan\MSCL_new';
cd(homedir);



clf
cla
hold off
% core = core.name;
% %core(1).name = 'GeoB10455';

[study_area, label_event, date, Time, Latitude, Longitude, Recovery_length, Stat_No, Water_depth, Wire_Length, corer_length, ind]...
    = textread('POS336Event_mod.txt', '%s %s %s  %s  %s  %s  %f %s %f %s %f %s',23);

date_char = char(date);
study_area_char = char(study_area);
Stat_No_char = char(Stat_No);
Time_char = char(Time);
Latitude_char = char(Latitude);
Longitude_char = char(Longitude);
Wire_Length_char = char(Wire_Length);
ind_char = char(ind);

d_55 =[5 25 45 60 80 95 105 125 145 165 185 195 205 225 245 265 285 325 345 365 385 395]';
shear_55 =[21.58045405 12.81135716 18.78781725 10.90975623 12.26804261 13.89798627 14.16964355 16.34290176 19.05947452 38.89045571 7.106554355 ...
        18.51615997 20.14610363 22.59101912 25.57924916 23.13433367 35.08725384 17.42953086 30.19742286 34.07668877 32.7075361 25.86177273];

d_58= [5 25 45 65 85 120 140 155 160 180 195]';
shear_58 =[3.17295699 11.22643099 30.45821385 17.03834439 9.008155291 9.008155291 52.47331954 16.61455903 37.80382661 85.36558259 49.21343222]'; 


clear filename sb_depth sect_num sect_depth st pw_amp pw_vel den_1 ms_1 imp fp depth y_min y_max avg_st dev_st ii pwv_min pwv_max den_min den_max fp_min fp_max ms_min ms_max 

%Finds the folders for each core
core_55= dir('GeoB10455*');
cd(core_55.name)
disp(cd)


%Finds the output data file in the core folder
filename_55 = dir('*.out');
filename_55=filename_55.name;
ind_name_55 = find( filename_55 == '.');
core_name_55 =filename_55(1:ind_name_55-1);

data_55 = load(filename_55);          %Loads data

sb_depth_55 = data_55 (:,1);          %total core depth [cm]
sect_num_55 = data_55 (:,2);          %section number [-]
sect_depth_55 = data_55 (:,3);        %section depth [cm]
st_55 = data_55 (:,4);                %core thickness [cm]
pw_amp_55 = data_55 (:,5);            %pwave amplitude [-]
pw_vel_55 = data_55 (:,6);            %pwave velocity [m/s]
den_1_55 = data_55 (:,7);             %density [gm/cc]
ms_1_55 = data_55 (:,8)';              %magnetic susceptibility [SI]
imp_55 = data_55 (:,9);               %impedance (calculated value) [?]
fp_55 = data_55 (:,10);               %fractional porosity (calculated value) [%]

%Defines the depth of the core
depth_55 = [1:length(sb_depth_55)]*.01;
depth_55 = depth_55';

%sets y_max to the max depth of the core, y_mint to zero
y_min_55 = 0;
y_max_55 = depth_55(length(sb_depth_55));

%Calculated the average section thickness and deviation
avg_st_55 = sum(st_55)/length(st_55);
dev_st_55 = std(st_55);

%finds all data points greater than one deviation from the average
ii_55 = find(st_55 > avg_st_55 + .5*dev_st_55);
st_55(ii_55) = NaN;

sect_num_2_55 = sect_num_55;
sect_depth_2_55 = sect_depth_55;
pw_amp_2_55 = pw_amp_55;
pw_vel_2_55 = pw_vel_55;
den_1_2_55 =den_1_55;
ms_1_2_55 = ms_1_55;
imp_2_55 = imp_55;
fp_2_55 = fp_55;

%Replaces outlying points with NaN's
%depth(ii) = NaN;
sect_num_2_55(ii_55) = NaN;
sect_depth_2_55(ii_55) = NaN;
pw_amp_2_55(ii_55) = NaN;
pw_vel_2_55(ii_55) = NaN;
den_1_2_55(ii_55) = NaN;
ms_1_2_55(ii_55) = NaN;
imp_2_55(ii_55) = NaN;
fp_2_55(ii_55) = NaN;

kk_55=find(den_1_2_55 < 1.5);
den_1_2_55(kk_55) = NaN;

% %    Depth of layers at actual depth 
% %   lith_1_55 = find(depth_55 <= .29);
% %   depth_55_lith_1=depth_55(lith_1_55);
% %   
% %   lith_2_55 =find( depth_55 > .30 & depth_55 < .49);
% %   depth_55_lith_2 = depth_55(lith_2_55);
% %   
% %   lith_3_55 =find( depth_55 > .50 & depth_55 < .74);
% %   depth_55_lith_3 = depth_55(lith_3_55);
% %   
% %   lith_4_55 =find(depth_55 > .75 & depth_55 < 2.95);
% %   depth_55_lith_4 = depth_55(lith_4_55);

%Depth of layers imposed onto each other
lith_1_55 = find(depth_55 <= .29);
depth_55_lith_1=[0.01:0.01:length(depth_55(lith_1_55))/100];
depth_55_lith_1=depth_55_lith_1;
depth_55_lith_1=depth_55_lith_1';
avg_den_lith_1_55 =sum(den_1_2_55(lith_1_55(2:end)))/length(den_1_2_55(lith_1_55(2:end)));

lith_2_55 =find( depth_55 > .30 & depth_55 < .49);
depth_55_lith_2 = [0.01:0.01:length(depth_55(lith_2_55))/100];
depth_55_lith_2=depth_55_lith_2;
depth_55_lith_2=depth_55_lith_2';
avg_den_lith_2_55 =sum(den_1_2_55(lith_2_55))/length(den_1_2_55(lith_2_55));

lith_3_55 =find( depth_55 > .50 & depth_55 < .74);
depth_55_lith_3 = [0.01:0.01:length(depth_55(lith_3_55))/100];
depth_55_lith_3=depth_55_lith_3;
depth_55_lith_3=depth_55_lith_3';
avg_den_lith_3_55 =sum(den_1_2_55(lith_3_55))/length(den_1_2_55(lith_3_55));

lith_4_55 =find(depth_55 > .75 & depth_55 < 1);
depth_55_lith_4 = [0.01:0.01:length(depth_55(lith_4_55))/100];
depth_55_lith_4=depth_55_lith_4;
depth_55_lith_4=depth_55_lith_4';
avg_den_lith_4_55 =sum(den_1_2_55(lith_4_55))/length(den_1_2_55(lith_4_55)); 

%Min/Max X-values for the pwave velocity
pwv_min = 1400;
pwv_max = 1600;

%Min/Max X-values for the density
den_min = 1.2;
den_max = 2.2;

%Min/Max X-values for the fractional porosity
fp_min = 0.3;
fp_max = 0.8;

%Min/max X-values for the magnetic susceptibility
ms_min = 0;
ms_max = 100;

cd(homedir)

core_58=dir('GeoB10458*');
cd(core_58.name);
disp(cd)  


%Finds the output data file in the core folder
filename_58 = dir('*.out');
filename_58=filename_58(1).name;
ind_name_58 = find( filename_58 == '.');
core_name_58 =filename_58(1:ind_name_58-1);

data_58 = load(filename_58);          %Loads data

sb_depth_58 = data_58 (:,1);          %total core depth [cm]
sect_num_58 = data_58 (:,2);          %section number [-]
sect_depth_58 = data_58 (:,3);        %section depth [cm]
st_58 = data_58 (:,4);                %core thickness [cm]
pw_amp_58 = data_58 (:,5);            %pwave amplitude [-]
pw_vel_58 = data_58 (:,6);            %pwave velocity [m/s]
den_1_58 = data_58 (:,7);             %density [gm/cc]
ms_1_58 = data_58 (:,8);              %magnetic susceptibility [SI]
imp_58 = data_58 (:,9);               %impedance (calculated value) [?]
fp_58 = data_58 (:,10);               %fractional porosity (calculated value) [%]

%Defines the depth of the core
depth_58 = [1:length(sb_depth_58)]*.01;
depth_58 = depth_58';

%sets y_max to the max depth of the core, y_mint to zero
y_min_58 = 0;
y_max_58 = depth_58(length(sb_depth_58));

%Calculated the average section thickness and deviation
avg_st_58 = sum(st_58)/length(st_58);
dev_st_58 = std(st_58);

%finds all data points greater than one deviation from the average
ii_58 = find(st_58 > avg_st_58 + .5*dev_st_58);
st_58(ii_58) = NaN;

sect_num_2_58 = sect_num_58;
sect_depth_2_58 = sect_depth_58;
pw_amp_2_58 = pw_amp_58;
pw_vel_2_58 = pw_vel_58;
den_1_2_58 =den_1_58;
ms_1_2_58 = ms_1_58;
imp_2_58 = imp_58;
fp_2_58 = fp_58;

%Replaces outlying points with NaN's
%depth(ii) = NaN;
sect_num_2_58(ii_58) = NaN;
sect_depth_2_58(ii_58) = NaN;
pw_amp_2_58(ii_58) = NaN;
pw_vel_2_58(ii_58) = NaN;
den_1_2_58(ii_58) = NaN;
ms_1_2_58(ii_58) = NaN;
imp_2_58(ii_58) = NaN;
fp_2_58(ii_58) = NaN;

% %   lith_1_58 = find(depth_58 < .79);
% %   depth_58_lith_1=depth_58(lith_1_58);
% %   
% %   lith_2_58 =find( depth_58 > .80 & depth_58 < 1.49);
% %   depth_58_lith_2 = depth_58(lith_2_58);
% %   
% %   lith_3_58 =find( depth_58 > 1.50 & depth_58 < 1.89);
% %   depth_58_lith_3 = depth_58(lith_3_58);
% %   
% %   lith_4_58 =find( depth_58 > 1.90);
% %   depth_58_lith_4 = depth_58(lith_4_58);  
% %     


lith_1_58 = find(depth_58 > .10 & depth_58 < .69);
depth_58_lith_1=[0.01:0.01:length(depth_58(lith_1_58))/100];
depth_58_lith_1=depth_58_lith_1./2.667;
depth_58_lith_1 =depth_58_lith_1';
avg_den_lith_1_58=sum(den_1_2_58(lith_1_58(2:end)))/length(den_1_2_58(lith_1_58(2:end)));

lith_2_58 =find( depth_58 > .78 & depth_58 < 1.51);
depth_58_lith_2 = [0.01:0.01:length(depth_58(lith_2_58))/100];
depth_58_lith_2=depth_58_lith_2./3.5;
depth_58_lith_2=depth_58_lith_2';
avg_den_lith_2_58=sum(den_1_2_58(lith_2_58))/length(den_1_2_58(lith_2_58));

lith_3_58 =find( depth_58 > 1.46 & depth_58 < 1.93);
depth_58_lith_3 = [0.01:0.01:length(depth_58(lith_3_58))/100];
depth_58_lith_3=depth_58_lith_3./1.6;
depth_58_lith_3=depth_58_lith_3';
avg_den_lith_3_58=sum(den_1_2_58(lith_3_58))/length(den_1_2_58(lith_3_58));

lith_4_58 =find( depth_58 > 1.90);
depth_58_lith_4 = [0.01:0.01:length(depth_58(lith_4_58))/100];
depth_58_lith_4=depth_58_lith_4./0.4;
depth_58_lith_4=depth_58_lith_4';
avg_den_lith_4_58=sum(den_1_2_58(lith_4_58))/length(den_1_2_58(lith_4_58));

disp(' ');
disp(' ');
disp('avg density 58   avg density 59\n');
%   disp('lith_1'); 
fprintf( '%g',avg_den_lith_1_58); fprintf('%f', avg_den_lith_1_55, '\n' )
%   disp('lith_2'); 
fprintf('%g',avg_den_lith_2_58); fprintf('%f',avg_den_lith_2_55,  '\n' )
%   disp('lith_3'); 
fprintf('%g',avg_den_lith_3_58); fprintf('%f',avg_den_lith_3_55, '\n' )
%   disp('lith_4'); 
fprintf('%g',avg_den_lith_4_58); fprintf('%f',avg_den_lith_4_55, '\n' )
disp(' ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% % %     %Creates a figure with the outputs (figure 1),using A4 paper size
% % %     figure(1)
% % %     axis off;
% % %     orient portrait;
% % %     set(gcf, 'PaperType', 'A5','PaperUnits', 'normalized','PaperPosition', [0 0 1 1], 'PaperPositionMode', 'manual');

% %     %Title
% %     %title_position=axes('position', [3 23 10 3]);
% %     title_position=axes('position', [.12 .65 1 .3]);
% %     axes(title_position);  
% %     axis off;    
% %     %text(0,0.95,['POS 336 Core Log ' num2str(core_name) num2str(ind(c))],'Fontsize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');
% %     text(0,0.95,['POS 336 Core Log ' core_name num2str(ind_char(c,:))],'Fontsize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
% %     text(0,0.85,['\bf Date: \rm' num2str(date_char(c,:)) ], 'Fontsize', 12, 'FontWeight', 'normal');
% %     text(0.57,0.95,['\bf Study Area: \rm' num2str(study_area_char(c,:)) ], 'Fontsize', 16, 'HorizontalAlignment', 'left', 'Fontweight', 'bold');
% %     text(0,0.8,['\bf Stat. No.: \rm' num2str(Stat_No_char(c,:)) ], 'Fontsize', 12);
% %     text(0,0.75,['\bf Time UTC @ BOKO: \rm' num2str(Time_char(c,:)) ], 'Fontsize', 12);
% %     text(0.29,0.85,['\bf Latitude: \rm' num2str(Latitude_char(c,:)) ], 'Fontsize', 12);
% %     text(0.29,0.8,['\bf Longitude: \rm' num2str(Longitude_char(c,:)) ], 'Fontsize', 12);
% %     text(0.29,0.75,['\bf Water depth: \rm' num2str(Water_depth(c,:)) 'm' ], 'Fontsize', 12);
% %     text(0.57, 0.85,['\bf Wire Length @ BOKO: \rm' num2str(Wire_Length_char(c,:)) 'm' ], 'Fontsize', 12);
% %     text(0.57,0.8,['\bf Gravity Corer Length: \rm' num2str(corer_length(c,:)) 'm' ], 'Fontsize', 12);
% %     text(0.57,0.75,['\bf Recovery Core Length: \rm' num2str(Recovery_length(c,:)) 'm' ], 'Fontsize', 12);

%Break--Line
% %     line_position = axes('position', [0 .75 1 0]);
% %     axes(line_position);
% %     axis off;
% %     text(0, 0.75, [----------------------------------------------------------------------
% % %   text_title = text(0.1,0, 'POS 336');
% % %   set(text_title, 'FontSize', 16);
% % %   set(title, 'visible', 'off');

% % %     %Figure1--Core picture
% % %     % %     figure1_position = axes('position', [0.12 .1 .05 .7]);
% % %     figure1_position = axes('position', [0.12 .1 .175 .7]);
% % %     axes(figure1_position);
% % %     axis off;
% % %     %cd('C:\Dokumente und Einstellungen\Geolab\Desktop\Meghan\MSCL\GeoB10455')
% % %     fnam2 = dir('GeoB*whole_core.jpg');
% % %     fnam2 = fnam2.name;
% % %     %     iptsetpref('ImshowAxesVisible', 'off');
% % %     %     iptsetpref('ImshowBorder', 'tight');
% % %     figure_1 = imshow(fnam2); title (' ');
% % %     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%Start Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Make the density values for 58 and 55 equal by setting the value of 1+1
%equal to the value before it (doubling the number of points in 58, except
%for lithology four, which doubles the values for 55.
den_add_lith_1_55 = [];
cnt_1 =1;
for i = 1:length(lith_1_55)
    
den_add_lith_1_55(cnt_1) = den_1_2_55(lith_1_55(i));
den_add_lith_1_55(cnt_1+1)=den_1_2_55(lith_1_55(i));
cnt_1 =length(den_add_lith_1_55)+1;

end

den_add_lith_2_55 = [];
cnt_2 =1;
for i = 1:length(lith_2_55)
    
den_add_lith_2_55(cnt_2) = den_1_2_55(lith_2_55(i));
den_add_lith_2_55(cnt_2+1)=den_1_2_55(lith_2_55(i));
den_add_lith_2_55(cnt_2+2)=den_1_2_55(lith_2_55(i));
den_add_lith_2_55(cnt_2+3)=den_1_2_55(lith_2_55(i));

cnt_2 =length(den_add_lith_2_55)+1;

end

den_add_lith_3_55 = [];
cnt_3 =1;
for i = 1:length(lith_3_55)
    
den_add_lith_3_55(cnt_3) = den_1_2_55(lith_3_55(i));
den_add_lith_3_55(cnt_3+1)=den_1_2_55(lith_3_55(i));
cnt_3 =length(den_add_lith_3_55)+1;

end


den_add_lith_4_58 = [];
cnt_4 =1;
for i = 1:length(lith_4_58)
    
den_add_lith_4_58(cnt_4) = den_1_2_58(lith_4_58(i));
den_add_lith_4_58(cnt_4+1)=den_1_2_58(lith_4_58(i));
cnt_4 =length(den_add_lith_4_58)+1;

end


% % ratio_lith_1 = den_1_2_58(lith_1_58)./den_1_2_55(lith_1_55);
% % ratio_lith_2 = den_1_2_58(lith_2_58)./den_1_2_55(lith_2_55);
% % ratio_lith_3 = den_1_2_58(lith_3_58)./den_1_2_55(lith_3_55);
% % ratio_lith_4 = den_1_2_58(lith_4_58)./den_1_2_55(lith_4_55);

y_min = 1.55;
y_max = 2.1;

x_min = 1.55;
x_max = 2.1;

plot(den_1_2_58(lith_1_58),den_add_lith_1_55, '.b', den_1_2_58(lith_2_58),den_add_lith_2_55, '*r',...
    den_1_2_58(lith_3_58),den_add_lith_3_55, 'dm', den_add_lith_4_58, den_1_2_55(lith_4_55),'^c'); xlabel([{'Density Core 58'; '[g/cm^{3}]'}]); ylabel([{'Density Core 55'; '[g/cm^{3}]'}]);...
    legend('Lithology 1', 'Lithology 2', 'Lithology 3', 'Lithology 4','Location', -1); set(gca, 'XLim', [x_min x_max]); set(gca, 'YLim', [y_min y_max]);%set(gca, 'YDir', 'reverse');
hold on

X= [0:0.1:2.1];
Y= [0:0.1:2.1];

plot(X,Y,'-k');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % %Make the density values for 58 and 55 equal by setting the value of 1+1
% % % %equal to the value before it (doubling the number of points in 58, except
% % % %for lithology four, which doubles the values for 55.
% % % ms_add_lith_1_55 = [];
% % % cnt_1 =1;
% % % for i = 1:length(lith_1_55)
% % %     
% % % ms_add_lith_1_55(cnt_1) = ms_1_2_55(lith_1_55(i));
% % % ms_add_lith_1_55(cnt_1+1)=ms_1_2_55(lith_1_55(i));
% % % cnt_1 =length(ms_add_lith_1_55)+1;
% % % 
% % % end
% % % 
% % % ms_add_lith_1_55=ms_add_lith_1_55';
% % % 
% % % ms_add_lith_2_55 = [];
% % % cnt_2 =1;
% % % for i = 1:length(lith_2_55)
% % %     
% % % ms_add_lith_2_55(cnt_2) = ms_1_2_55(lith_2_55(i));
% % % ms_add_lith_2_55(cnt_2+1)=ms_1_2_55(lith_2_55(i));
% % % ms_add_lith_2_55(cnt_2+2)=ms_1_2_55(lith_2_55(i));
% % % ms_add_lith_2_55(cnt_2+3)=ms_1_2_55(lith_2_55(i));
% % % 
% % % cnt_2 =length(ms_add_lith_2_55)+1;
% % % 
% % % end
% % % 
% % % ms_add_lith_2_55=ms_add_lith_2_55';
% % % 
% % % ms_add_lith_3_55 = [];
% % % cnt_3 =1;
% % % for i = 1:length(lith_3_55)
% % %     
% % % ms_add_lith_3_55(cnt_3) = ms_1_2_55(lith_3_55(i));
% % % ms_add_lith_3_55(cnt_3+1) = ms_1_2_55(lith_3_55(i));
% % % cnt_3 =length(ms_add_lith_3_55)+1;
% % % 
% % % end
% % % 
% % % ms_add_lith_3_55=ms_add_lith_3_55'
% % % 
% % % 
% % % ms_add_lith_4_58 = [];
% % % cnt_4 =1;
% % % for i = 1:length(lith_4_58)
% % %     
% % % ms_add_lith_4_58(cnt_4) = ms_1_2_58(lith_4_58(i));
% % % ms_add_lith_4_58(cnt_4+1)=ms_1_2_58(lith_4_58(i));
% % % cnt_4 =length(ms_add_lith_4_58)+1;
% % % 
% % % end
% % % 
% % % ms_add_lith_4_58 =ms_add_lith_4_58';
% % % 
% % % % % ratio_lith_1 = den_1_2_58(lith_1_58)./den_1_2_55(lith_1_55);
% % % % % ratio_lith_2 = den_1_2_58(lith_2_58)./den_1_2_55(lith_2_55);
% % % % % ratio_lith_3 = den_1_2_58(lith_3_58)./den_1_2_55(lith_3_55);
% % % % % ratio_lith_4 = den_1_2_58(lith_4_58)./den_1_2_55(lith_4_55);
% % % 
% % % y_min = 0;
% % % y_max = 20;
% % % 
% % % plot(ms_1_2_58(lith_1_58), ms_add_lith_1_55, '.b', ms_1_2_58(lith_2_58),ms_add_lith_2_55, '*r',...
% % %     ms_1_2_58(lith_3_58),ms_add_lith_3_55, 'dm', ms_add_lith_4_58, ms_1_2_55(lith_4_55),'^c'); xlabel([{'Magnetic Susceptibility'; '[SI]'}]); ylabel([{'Magnetic Suceptibiliy'; '[SI]'}]);
% % %     set(gca, 'YLim', [y_min y_max]);%set(gca, 'YDir', 'reverse');
% % %    %set(gca, 'XLim', [x_min x_max]); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ratio_lith_1_58 = den_1_2_58(lith_1_58)./depth_58_lith_1; 
% % ratio_lith_1_55 = den_1_2_55(lith_1_55)./depth_55_lith_1;
% % 
% % 
% % ratio_lith_2_58 = den_1_2_58(lith_2_58)./depth_58_lith_2; 
% % ratio_lith_2_55 = den_1_2_55(lith_2_55)./depth_55_lith_2;
% % 
% % ratio_lith_3_58 = den_1_2_58(lith_3_58)./depth_58_lith_3; 
% % ratio_lith_3_55 = den_1_2_55(lith_3_55)./depth_55_lith_3;
% % 
% % ratio_lith_4_58 = den_1_2_58(lith_4_58)./depth_58_lith_4; 
% % ratio_lith_4_55 = den_1_2_55(lith_4_55)./depth_55_lith_4;
% % 
% % x_min = 0;
% % x_max = 100;
% % 
% % y_min = 0;
% % y_max = 0.3;
% % 
% % subplot(1,4,1); plot(ratio_lith_1_58, depth_58_lith_1,'.r', ratio_lith_1_55, depth_55_lith_1,'db'); xlabel([{'Density'; '[g/cm^{3}]'}]); ylabel('depth (m)'); set(gca, 'YDir', 'reverse');set(gca, 'XLim', [x_min x_max]); set(gca, 'YLim', [y_min y_max]);
% % subplot(1,4,2); plot(ratio_lith_2_58, depth_58_lith_2,'.r', ratio_lith_2_55, depth_55_lith_2,'db'); xlabel([{'Density'; '[g/cm^{3}]'}]); set(gca, 'YDir', 'reverse');set(gca, 'XLim', [x_min x_max]); set(gca, 'YLim', [y_min y_max]);
% % subplot(1,4,3); plot(ratio_lith_3_58, depth_58_lith_3,'.r', ratio_lith_3_55, depth_55_lith_3,'db'); xlabel([{'Density'; '[g/cm^{3}]'}]); set(gca, 'YDir', 'reverse');set(gca, 'XLim', [x_min x_max]); set(gca, 'YLim', [y_min y_max]);
% % subplot(1,4,4); plot(ratio_lith_4_58, depth_58_lith_4,'.r', ratio_lith_4_55, depth_55_lith_4,'db'); xlabel([{'Density'; '[g/cm^{3}]'}]); set(gca, 'YDir', 'reverse');...
% %     set(gca, 'XLim', [x_min x_max]); set(gca, 'YLim', [y_min y_max]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % plot(ratio_lith_1_58, depth_58_lith_1,'xr', ratio_lith_1_55, depth_55_lith_1,'xb',...
% %     ratio_lith_2_58, depth_58_lith_2,'*r', ratio_lith_2_55, depth_55_lith_2,'*b',...
% %     ratio_lith_3_58, depth_58_lith_3,'dr', ratio_lith_3_55, depth_55_lith_3,'db',...
% %     ratio_lith_4_58, depth_58_lith_4,'+r', ratio_lith_4_55, depth_55_lith_4,'+b'); xlabel([{'Density'; '[g/cm^{3}]'}]); ylabel('depth [m]');set(gca, 'YDir', 'reverse');...
% %     set(gca, 'XLim', [x_min x_max]); set(gca, 'YLim', [y_min y_max]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %     set(gca, 'YTick', []);
% %     

% %     set(gca, 'YDir', 'reverse');
% %     set(gca, 'GridLineStyle', 'none');

% % % % % % plot(den_1_2_58(lith_1_58), depth_58_lith_1,'xr', den_1_2_55(lith_1_55), depth_55_lith_1,'xb',...
% % % % % %     den_1_2_58(lith_2_58), depth_58_lith_2,'.r', den_1_2_55(lith_2_55), depth_55_lith_2,'.b',...
% % % % % %     den_1_2_58(lith_3_58), depth_58_lith_3,'dr', den_1_2_55(lith_3_55), depth_55_lith_3,'db',...
% % % % % %     den_1_2_58(lith_4_58), depth_58_lith_4,'+r', den_1_2_55(lith_4_55), depth_55_lith_4,'+b');

% % % subplot(1,4,1); plot(den_1_2_58(lith_1_58), depth_58_lith_1,'xr', den_1_2_55(lith_1_55), depth_55_lith_1,'xb')
% % % subplot(1,4,2); plot(den_1_2_58(lith_2_58), depth_58_lith_2,'.r', den_1_2_55(lith_2_55), depth_55_lith_2,'.b')
% % % subplot(1,4,3); plot(den_1_2_58(lith_3_58), depth_58_lith_3,'dr', den_1_2_55(lith_3_55), depth_55_lith_3,'db')
% % % subplot(1,4,4);plot(den_1_2_58(lith_4_58), depth_58_lith_4,'+r', den_1_2_55(lith_4_55), depth_55_lith_4,'+b');


% %     subplot(1,4,1); plot(den_1_2_58(lith_1_58), depth_58_lith_1,'xr', den_1_2_55(lith_1_55), depth_55_lith_1,'xb')
% %     subplot(1,4,2); plot(den_1_2_58(lith_2_58), depth_58_lith_2,'.r', den_1_2_55(lith_2_55), depth_55_lith_2,'.b')
% %     subplot(1,4,3); plot(den_1_2_58(lith_3_58), depth_58_lith_3,'dr', den_1_2_55(lith_3_55), depth_55_lith_3,'db')
% %     subplot(1,4,4);plot(den_1_2_58(lith_4_58), depth_58_lith_4,'+r', den_1_2_55(lith_4_55), depth_55_lith_4,'+b');

% % 
% %     %Plot1--Pwave Velocity
% %     plot1_position = axes('position', [.2 .1 .15 .7]);
% %     axes(plot1_position);
% %     axis off;
% %     plot(pw_vel, depth, '--r', pw_vel_2, depth); xlabel({'Pwave Velocity'; '[m/s]'}); %ylabel('Depth (m)'); 
% %     set(gca, 'YTick', []);
% %     set(gca, 'YLim', [y_min y_max]);
% %     set(gca, 'XLim', [pwv_min pwv_max]);
% %     set(gca, 'YDir', 'reverse');
% %     set(gca, 'GridLineStyle', 'none');
% %     hold on
% %     %text([pwv_min pwv_max], [min(depth(ii)), max(depth(ii))], 'BackgroundColor',  [0.2 0.2 0.2])
% %     
% %     
% %     %set(gca, 'Visible', 'off');
% %     
% %     %Plot2--Density
% %     plot2_position = axes('position', [.4 .1 .15 .7]);
% %     axes(plot2_position);
% %     axis off;
% %     plot(den_1, depth, '--r', den_1_2, depth); xlabel({'Density'; '[g/cm^{3}]'});
% %     set(gca, 'YTick', []);
% %     set(gca, 'YLim', [y_min y_max]);
% %     set(gca, 'XLim', [den_min den_max]);
% %     set(gca, 'YDir', 'reverse'); 
% %     
% % % % % % % % %     kk=[]';
% % % % % % % % %     cnt =1;
% % % % % % % % %     for k = 1:length(ii);
% % % % % % % % %         %m=1
% % % % % % % % %         %while m<max(ii)
% % % % % % % % %         if k==1  
% % % % % % % % %             patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
% % % % % % % % %                 [depth(ii(k)),depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k)) depth(ii(k)),depth(ii(k))],...
% % % % % % % % %                 [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% % % % % % % % %             
% % % % % % % % %         elseif k== length(ii)
% % % % % % % % %             patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
% % % % % % % % %                 [depth(ii(k))+.01,depth(ii(k))+.01 depth(ii(k))+.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))+.01], ...
% % % % % % % % %                 [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);  
% % % % % % % % %                 
% % % % % % % % %         elseif depth(ii(k))-depth(ii(k-1))== 0.01 && depth(ii(k+1))-depth(ii(k)) == 0.01
% % % % % % % % %             patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
% % % % % % % % %                 [depth(ii(k)),depth(ii(k-1)) depth(ii(k-1)),depth(ii(k-1)) depth(ii(k-1)),depth(ii(k)) depth(ii(k)),depth(ii(k))],...
% % % % % % % % %                 [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% % % % % % % % %             kk(cnt)=k;   
% % % % % % % % %                
% % % % % % % % %             % %             elseif depth(ii(k))-depth(ii(k-1))== 0.01  
% % % % % % % % %             % %                 patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
% % % % % % % % %             % %                     [depth(ii(k)),depth(ii(k)) depth(ii(k)),depth(ii(k-1)) depth(ii(k-1)),depth(ii(k-1)) depth(ii(k-1)),depth(ii(k))], ...
% % % % % % % % %             % %                     [0.7 0.7 0.7], 'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% % % % % % % % %             
% % % % % % % % %         elseif depth(ii(k))-depth(ii(k-1))==0.01 && depth(ii(k+1))-depth(ii(k))> 0.01
% % % % % % % % %             patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
% % % % % % % % %                 [depth(ii(k))+.01,depth(ii(k))+.01 depth(ii(k))+.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))+.01], ...
% % % % % % % % %                 [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% % % % % % % % %             
% % % % % % % % %         elseif depth(ii(k)) - depth(ii(k-1)) > 0.01 && depth(ii(k+1)) - depth(ii(k)) > 0.01
% % % % % % % % %             patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
% % % % % % % % %                 [depth(ii(k))+.01,depth(ii(k))+.01 depth(ii(k))+.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))+.01], ...
% % % % % % % % %                 [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% % % % % % % % %             
% % % % % % % % %             cnt =cnt+1;
% % % % % % % % %             
% % % % % % % % %         elseif depth(ii(k))-depth(ii(k-1))>0.01 && depth(ii(k+1))-depth(ii(k))== 0.01
% % % % % % % % %             patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
% % % % % % % % %                 [depth(ii(k)),depth(ii(k)) depth(ii(k)),depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))], ...
% % % % % % % % %                 [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% % % % % % % % %             
% % % % % % % % %             
% % % % % % % % %             % %             elseif depth(ii(k+1))-depth(ii(k))>0.01 && depth(ii(k))-depth(ii(k-1))~= 0.01
% % % % % % % % %             % %                 patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min], ...
% % % % % % % % %             % %                     [depth(ii(1+1))-.01,depth(ii(1))-.01 depth(ii(1))-.01,depth(ii(1))-.01 depth(ii(1))-.01,depth(ii(1+1))-.01 depth(ii(1+1))-.01,depth(ii(1+1))-.01],...
% % % % % % % % %             % %                     [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% % % % % % % % %         else
% % % % % % % % %         end
% % % % % % % % %         
% % % % % % % % %         %end
% % % % % % % % %     end
% %     
% %     % %         patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min], [depth(ii(1+1))-.01,depth(ii(1))-.01 depth(ii(1))-.01,depth(ii(1))-.01 depth(ii(1))-.01,depth(ii(1+1))-.01 depth(ii(1+1))-.01,depth(ii(1+1))-.01], [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% %     % %         patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min], [depth(ii(6))+.01,depth(ii(6)) depth(ii(6)),depth(ii(6)) depth(ii(6)),depth(ii(6))+.01 depth(ii(6))+.01,depth(ii(6))+.01], [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
% %     % %     
% %     %Plot3--Magnetic susceptibility
% %     plot3_position = axes('position', [.6 .1 .15 .7]);
% %     axes(plot3_position);
% %     axis off;
% %     plot(ms_1, depth, '--r', ms_1_2, depth); xlabel({'Magnetic Susceptibility'; '[SI]'});
% %     set(gca, 'XLim', [ms_min ms_max]);
% %     set(gca, 'YTick', []);
% %     set(gca, 'YLim', [y_min y_max]);
% %     set(gca, 'YDir', 'reverse');
% %     
% %     %Plot4--Fractional Porosity
% %     plot4_position = axes('position', [.8 .1 .15 .7]);
% %     axes(plot4_position);
% %     axis off;
% %     plot(fp, depth, '--r', fp_2, depth); xlabel({'Fractional Porosity'; '[%]'});
% %     set(gca, 'YTick', []);
% %     set(gca, 'YLim', [y_min y_max]);
% %     set(gca, 'XLim', [fp_min fp_max]);
% %     set(gca, 'YDir', 'reverse'); 
% %     
% %     %Depth Scale
% %     scale_position = axes('position', [0.12 0.1 0.01 0.7]);
% %     axes(scale_position);
% %     text([0 0], [0 length(depth)], '-');
% %     ylabel('Depth [m]');
% %     set(gca, 'YMinorTick', 'on');
% %     set(gca, 'XTick', []);
% %     set(gca, 'YLim', [y_min y_max]);
% %     set(gca, 'YDir', 'reverse');
% %     
% %         end_cap_position = axes('position', [0 0 1 1]);
% %         axes(end_cap_position)
% %         for k = 1:length(ii)
% %             text([0.12 0.95], [depth(ii(k)), depth(ii(k))], ' ');
% %             k = k+1;
% %         end
% %         
% %     
% %     % %     %Names the file and saves the figure (jpeg)
% %     % %     fnam=(['Fig_' num2str(core_name) ]);
% %     % %     figure(1)
% %     % %     print('-djpeg', '-r300', fnam);
% %     
% %     %Names the file and saves the figure (matlab file)
% % % % % %     fnam=(['TestFig_' num2str(core_name) ]);
% % % % % %     figure(1)
% % % % % %     print('-djpeg','-r300',fnam);
% %     
% % % % % %     count = count+1;
% %     % %     clf
% %     % %     cla
% %     % %     hold off
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% % end     %Ends loop for each core
% % 
% % cd ..
