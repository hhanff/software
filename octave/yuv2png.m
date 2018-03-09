#! /usr/bin/octave -qf
##############################################################################
## Title       : yuv2png
## Project     : 
## Library:    : 
##############################################################################
## File name   : yuv2png
## Author      : hhanff
## Company     : 
## Platform    : lin
##############################################################################
## Purpose     : This is an Octave script. It's purpose is to read
## test-bench generated txt file which contains YUV data (centre
## coordinates and transform this data to a png image
##############################################################################
## Assumptions : centre_candidates was sorted with > sort
## Limitations :
## Known Errors:
##############################################################################
## Revision: 
## $Rev   :: 1391                                          $:  Revision of last commit
## $Author:: hhanff                                        $:  Author of last commit
## $Date  :: 2011-10-05 14:29:03 +0200 (Mi, 05. Okt 2011)  $:  Date of last commit
##############################################################################
# Generate RGB image to evaluate the results of the circle detection algorithm
##############################################################################
arg_list = argv ();
file_base_name=arg_list{1};
file_name=[file_base_name,'.png'];

PICSIZ_V = 200;

  rgb = imread (file_name);  # initialize new rgb picture to content of yuv picture
  #imwrite (yuv, "yuv.bmp"); # Write the image
  Y = 255;
  U = 255;
  V = 255;

#  CIRCLECENTERLOWERTHRESH = 60;
  CIRCLECENTERLOWERTHRESH = 0;
  
#  U_Value = 0;
  # Read simulation results
file_name=[file_base_name,'_centre_candidates.txt'];
centre_candidates = dlmread (file_name, ",");
  line_cnt = 1;
  while (line_cnt != length(centre_candidates))
				# get x- and y values for centre
				# candidate from line with number
				# line_cnt
    x_val = centre_candidates([line_cnt],[1])
    y_val = uint16(centre_candidates([line_cnt],[2]))
				# Draw crosses where centre candidates were found inside the picture.
    for y = -5:5
      if (y_val+y > 0 & y_val+y <PICSIZ_V+1) # Otherwise we might address negative matrix indices for small centre_candidates (y_val or x_val < 4)
	if (x_val > 0)
	  rgb(y_val+y, x_val, 1) = uint8(Y + 1.403 * V);             # red
	  rgb(y_val+y, x_val, 2) = uint8(Y - 0.344 * U - 0.714 * V); # green
	  rgb(y_val+y, x_val, 3) = uint8(Y + 1.770 * U);             # blue
	endif
      endif
    endfor

    for x = -5:5
      if (x_val+x > 0)
	rgb(y_val, x_val+x, 1) = uint8(Y + 1.403 * V);             # red
	rgb(y_val, x_val+x, 2) = uint8(Y - 0.344 * U - 0.714 * V); # green
	rgb(y_val, x_val+x, 3) = uint8(Y + 1.770 * U);             # blue
      endif
    endfor
    
    line_cnt = line_cnt + 1;
  endwhile

  line_cnt--;
  line_cnt
file_name=[file_base_name,'_out.png'];

imwrite (rgb, file_name);
