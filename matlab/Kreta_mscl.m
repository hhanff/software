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
homedir='C:\Dokumente und Einstellungen\Geolab\Desktop\Hanff\MSCL_new';
cd(homedir);

%Finds the Core Sight information from excell spreadsheet
% % date = '30.04.2006';
% % study_area = 'E';
% % ind = '-1';
% % Stat_No = '531-2';
% % Time = '16:00';
% % Latitude = ' 35° 26.73'' N';
% % Longitude = '025° 50.63'' E';
% % Water_depth = '479';
% % Wire_length = '507';
% % corer_length = '6';
% % Recovery_length = '4.00';

%Finds the folders for each core
core= dir('GeoB10406_1*');
% core = core.name;
% %core(1).name = 'GeoB10455';

count = 1;

% % filename_core_info = dir('POS336Event_modified_text.txt')
% % filename_core_info = filename_core_info(1).name
% % data_core_info = load(filename_core_info);

%filename_core_info = 'POS336Event_mod.txt';
%data_core_info = load(filename_core_info);
[study_area, label_event, date, Time, Latitude, Longitude, Recovery_length, Stat_No, Water_depth, Wire_Length, corer_length, ind]...
    = textread('POS336Event_mod.txt', '%s %s %s  %s  %s  %s  %f %s %f %s %f %s',23);

date_char = char(date);
study_area_char = char(study_area);
Stat_No_char = char(Stat_No);
Time_char = char(Time);
Latitude_char = char(Latitude);
Longitude_char = char(Longitude);
%Water_depth_char = char(Water_depth)
Wire_Length_char = char(Wire_Length);
%corer_length_char = char(corer_length);
%Recovery_length_char = char(Recovery_length);
ind_char = char(ind);

%filename_core_info = dir('POS336Event_modified_text.xls');


%Start loop for each core 
for c=1:length(core);
    cd(homedir)
    cd(core(c).name)
    disp(cd)
    clf
    cla
    hold off
    
    
    
    clear filename sb_depth sect_num sect_depth st pw_amp pw_vel den_1 ms_1 imp fp depth y_min y_max avg_st dev_st ii pwv_min pwv_max den_min den_max fp_min fp_max ms_min ms_max 
    
    %Finds the output data file in the core folder
    filename = dir('*.out');
    filename=filename(1).name;
    ind_name = find( filename == '.');
    core_name =filename(1:ind_name-1);
    
    data = load(filename);          %Loads data
    
    sb_depth = data (:,1);          %total core depth [cm]
    sect_num = data (:,2);          %section number [-]
    sect_depth = data (:,3);        %section depth [cm]
    st = data (:,4);                %core thickness [cm]
    pw_amp = data (:,5);            %pwave amplitude [-]
    pw_vel = data (:,6);            %pwave velocity [m/s]
    den_1 = data (:,7);             %density [gm/cc]
    ms_1 = data (:,8);              %magnetic susceptibility [SI]
    imp = data (:,9);               %impedance (calculated value) [?]
    fp = data (:,10);               %fractional porosity (calculated value) [%]
    
    %Defines the depth of the core
    depth = [1:length(sb_depth)]*.01;
    depth = depth';
    
    %sets y_max to the max depth of the core, y_mint to zero
    y_min = 0;
    y_max = depth(length(sb_depth));
    
    %Calculated the average section thickness and deviation
    avg_st = sum(st)/length(st);
    dev_st = std(st);
    
    %finds all data points greater than one deviation from the average
    ii = find(st > avg_st + .5*dev_st);
    st(ii) = NaN;
    
    sect_num_2 = sect_num;
    sect_depth_2 = sect_depth;
    pw_amp_2 = pw_amp;
    pw_vel_2 = pw_vel;
    den_1_2 =den_1;
    ms_1_2 = ms_1;
    imp_2 = imp;
    fp_2 = fp;
    
    %Replaces outlying points with NaN's
    %depth(ii) = NaN;
    sect_num_2(ii) = NaN;
    sect_depth_2(ii) = NaN;
    pw_amp_2(ii) = NaN;
    pw_vel_2(ii) = NaN;
    den_1_2(ii) = NaN;
    ms_1_2(ii) = NaN;
    imp_2(ii) = NaN;
    fp_2(ii) = NaN;
    
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
    
    % %     %Finds the Core Sight information from excell spreadsheet
    % %     date = data_core_info(count,7);
    % %     study_area = data_core_info(count,1);
    % %     Stat_No = data_core_info(count,19);
    % %     Time = data_core_info(count,8);
    % %     Latitude = data_core_info(count,11);
    % %     Longitude = data_core_info(count,12);
    % %     Water_depth = data_core_info(count,20);
    % %     Wire_length = data_core_info(count,21);
    % %     corer_length = data_core_info(count,22);
    % %     Recovery_length = data_core_info(count,17);
    % %     ind = data_core_info(count,23);
    % %     
    %Creates a figure with the outputs (figure 1),using A4 paper size
    figure(1)
    axis off;
    orient portrait;
    set(gcf, 'PaperType', 'A4','PaperUnits', 'normalized','PaperPosition', [0 0 1 1], 'PaperPositionMode', 'manual');
    
    %Title
    %title_position=axes('position', [3 23 10 3]);
    title_position=axes('position', [.12 .65 1 .3]);
    axes(title_position);  
    axis off;    
    %text(0,0.95,['POS 336 Core Log ' num2str(core_name) num2str(ind(c))],'Fontsize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');
    text(0,0.95,['POS 336 Core Log ' core_name num2str(ind_char(c,:))],'Fontsize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    text(0,0.85,['\bf Date: \rm' num2str(date_char(c,:)) ], 'Fontsize', 12, 'FontWeight', 'normal');
    text(0.57,0.95,['\bf Study Area: \rm' num2str(study_area_char(c,:)) ], 'Fontsize', 16, 'HorizontalAlignment', 'left', 'Fontweight', 'bold');
    text(0,0.8,['\bf Stat. No.: \rm' num2str(Stat_No_char(c,:)) ], 'Fontsize', 12);
    text(0,0.75,['\bf Time UTC @ BOKO: \rm' num2str(Time_char(c,:)) ], 'Fontsize', 12);
    text(0.29,0.85,['\bf Latitude: \rm' num2str(Latitude_char(c,:)) ], 'Fontsize', 12);
    text(0.29,0.8,['\bf Longitude: \rm' num2str(Longitude_char(c,:)) ], 'Fontsize', 12);
    text(0.29,0.75,['\bf Water depth: \rm' num2str(Water_depth(c,:)) 'm' ], 'Fontsize', 12);
    text(0.57, 0.85,['\bf Wire Length @ BOKO: \rm' num2str(Wire_Length_char(c,:)) 'm' ], 'Fontsize', 12);
    text(0.57,0.8,['\bf Gravity Corer Length: \rm' num2str(corer_length(c,:)) 'm' ], 'Fontsize', 12);
    text(0.57,0.75,['\bf Recovery Core Length: \rm' num2str(Recovery_length(c,:)) 'm' ], 'Fontsize', 12);
    
    %Break--Line
    % %     line_position = axes('position', [0 .75 1 0]);
    % %     axes(line_position);
    % %     axis off;
    % %     text(0, 0.75, [----------------------------------------------------------------------
    % % %   text_title = text(0.1,0, 'POS 336');
    % % %   set(text_title, 'FontSize', 16);
    % % %   set(title, 'visible', 'off');
    
    %Figure1--Core picture
    % %     figure1_position = axes('position', [0.12 .1 .05 .7]);
    figure1_position = axes('position', [0.12 .1 .175 .7]);
    axes(figure1_position);
    axis off;
    %cd('C:\Dokumente und Einstellungen\Geolab\Desktop\Hanff\MSCL\GeoB10455')
    fnam2 = dir('GeoB*whole_core.jpg');
    fnam2 = fnam2.name;
    %     iptsetpref('ImshowAxesVisible', 'off');
    %     iptsetpref('ImshowBorder', 'tight');
    figure_1 = imshow(fnam2); title (' ');
    
    %Plot1--Pwave Velocity
    plot1_position = axes('position', [.2 .1 .15 .7]);
    axes(plot1_position);
    axis off;
    plot(pw_vel, depth, '--r', pw_vel_2, depth); xlabel({'Pwave Velocity'; '[m/s]'}); %ylabel('Depth (m)'); 
    set(gca, 'YTick', []);
    set(gca, 'YLim', [y_min y_max]);
    set(gca, 'XLim', [pwv_min pwv_max]);
    set(gca, 'YDir', 'reverse');
    set(gca, 'GridLineStyle', 'none');
    hold on
    %text([pwv_min pwv_max], [min(depth(ii)), max(depth(ii))], 'BackgroundColor',  [0.2 0.2 0.2])
    
    
    %set(gca, 'Visible', 'off');
    
    %Plot2--Density
    plot2_position = axes('position', [.4 .1 .15 .7]);
    axes(plot2_position);
    axis off;
    plot(den_1, depth, '--r', den_1_2, depth); xlabel({'Density'; '[g/cm^{3}]'});
    set(gca, 'YTick', []);
    set(gca, 'YLim', [y_min y_max]);
    set(gca, 'XLim', [den_min den_max]);
    set(gca, 'YDir', 'reverse'); 
    
    kk=[]';
    cnt =1;
    for k = 1:length(ii);
        %m=1
        %while m<max(ii)
        if k==1  
            patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
                [depth(ii(k)),depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k)) depth(ii(k)),depth(ii(k))],...
                [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
            
        elseif k== length(ii)
            patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
                [depth(ii(k))+.01,depth(ii(k))+.01 depth(ii(k))+.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))+.01], ...
                [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);  
                
        elseif depth(ii(k))-depth(ii(k-1))== 0.01 && depth(ii(k+1))-depth(ii(k)) == 0.01
            patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
                [depth(ii(k)),depth(ii(k-1)) depth(ii(k-1)),depth(ii(k-1)) depth(ii(k-1)),depth(ii(k)) depth(ii(k)),depth(ii(k))],...
                [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
            kk(cnt)=k;   
               
            % %             elseif depth(ii(k))-depth(ii(k-1))== 0.01  
            % %                 patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
            % %                     [depth(ii(k)),depth(ii(k)) depth(ii(k)),depth(ii(k-1)) depth(ii(k-1)),depth(ii(k-1)) depth(ii(k-1)),depth(ii(k))], ...
            % %                     [0.7 0.7 0.7], 'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
            
        elseif depth(ii(k))-depth(ii(k-1))==0.01 && depth(ii(k+1))-depth(ii(k))> 0.01
            patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
                [depth(ii(k))+.01,depth(ii(k))+.01 depth(ii(k))+.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))+.01], ...
                [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
            
        elseif depth(ii(k)) - depth(ii(k-1)) > 0.01 && depth(ii(k+1)) - depth(ii(k)) > 0.01
            patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
                [depth(ii(k))+.01,depth(ii(k))+.01 depth(ii(k))+.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))+.01], ...
                [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
            
            cnt =cnt+1;
            
        elseif depth(ii(k))-depth(ii(k-1))>0.01 && depth(ii(k+1))-depth(ii(k))== 0.01
            patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min],...
                [depth(ii(k)),depth(ii(k)) depth(ii(k)),depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))-.01 depth(ii(k))-.01,depth(ii(k))], ...
                [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
            
            
            % %             elseif depth(ii(k+1))-depth(ii(k))>0.01 && depth(ii(k))-depth(ii(k-1))~= 0.01
            % %                 patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min], ...
            % %                     [depth(ii(1+1))-.01,depth(ii(1))-.01 depth(ii(1))-.01,depth(ii(1))-.01 depth(ii(1))-.01,depth(ii(1+1))-.01 depth(ii(1+1))-.01,depth(ii(1+1))-.01],...
            % %                     [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
        else
        end
        
        %end
    end
    
    % %         patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min], [depth(ii(1+1))-.01,depth(ii(1))-.01 depth(ii(1))-.01,depth(ii(1))-.01 depth(ii(1))-.01,depth(ii(1+1))-.01 depth(ii(1+1))-.01,depth(ii(1+1))-.01], [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
    % %         patch([den_min,den_min den_min,den_max den_max,den_max den_max,den_min], [depth(ii(6))+.01,depth(ii(6)) depth(ii(6)),depth(ii(6)) depth(ii(6)),depth(ii(6))+.01 depth(ii(6))+.01,depth(ii(6))+.01], [0.7 0.7 0.7],'EdgeAlpha', [0], 'FaceAlpha', [0.5], 'FaceColor', [0.7 0.7 0.7]);
    % %     
    %Plot3--Magnetic susceptibility
    plot3_position = axes('position', [.6 .1 .15 .7]);
    axes(plot3_position);
    axis off;
    plot(ms_1, depth, '--r', ms_1_2, depth); xlabel({'Magnetic Susceptibility'; '[SI]'});
    set(gca, 'XLim', [ms_min ms_max]);
    set(gca, 'YTick', []);
    set(gca, 'YLim', [y_min y_max]);
    set(gca, 'YDir', 'reverse');
    
    %Plot4--Fractional Porosity
    plot4_position = axes('position', [.8 .1 .15 .7]);
    axes(plot4_position);
    axis off;
    plot(fp, depth, '--r', fp_2, depth); xlabel({'Fractional Porosity'; '[%]'});
    set(gca, 'YTick', []);
    set(gca, 'YLim', [y_min y_max]);
    set(gca, 'XLim', [fp_min fp_max]);
    set(gca, 'YDir', 'reverse'); 
    
    %Depth Scale
    scale_position = axes('position', [0.12 0.1 0.01 0.7]);
    axes(scale_position);
    text([0 0], [0 length(depth)], '-');
    ylabel('Depth [m]');
    set(gca, 'YMinorTick', 'on');
    set(gca, 'XTick', []);
    set(gca, 'YLim', [y_min y_max]);
    set(gca, 'YDir', 'reverse');
    
    % %     end_cap_position = axes('position', [0 0 1 1]);
    % %     axes(end_cap_position)
    % %     for k = 1:length(ii)
    % %         text([0.12 0.95], [depth(ii(k)), depth(ii(k))], ' ');
    % %         k = k+1;
    % %     end
    % %     
    
    % %     %Names the file and saves the figure (jpeg)
    % %     fnam=(['Fig_' num2str(core_name) ]);
    % %     figure(1)
    % %     print('-djpeg', '-r300', fnam);
    
    %Names the file and saves the figure (matlab file)
    fnam=(['TestFig_' num2str(core_name) ]);
    figure(1)
    print('-djpeg','-r300',fnam);
    
    count = count+1;
    % %     clf
    % %     cla
    % %     hold off
end     %Ends loop for each core

cd ..
