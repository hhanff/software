#! /usr/bin/octave -qf
##-----------------------------------------------------------------------------
## Title       : png2yuv
## Project     : 
## Library:    : 
##-----------------------------------------------------------------------------
## File name   : png2yuv
## Author      : hhanff
## Company     : 
## Platform    : lin
##-----------------------------------------------------------------------------
## Purpose     : This is an Octave script. It's purpose is to generate a stimuli
##               file containing yuv data. Input file is a png image
##               Ouput is yuv.dat for the vhdl testbench and a bitmap
##               file for yuv2png.m
##               
##-----------------------------------------------------------------------------
## Assumptions : 
## Limitations :
## Known Errors:
##-----------------------------------------------------------------------------
## Revision: 
## $Rev   :: 1391                                          $: Revision of last commit
## $Author:: hhanff                                        $: Author of last commit
## $Date  :: 2011-10-05 14:29:03 +0200 (Mi, 05. Okt 2011)  $: Date of last commit
##-----------------------------------------------------------------------------
DEBUG = 0;
arg_list = argv ();
printf ("\n");
# read input image
# I = imread ("unprocessed_camera_image_vga.png");
# Observe that the image contains at least one pixel which is not black/grey/white 
# to force imread treat the image as a color image 
file_base_name=arg_list{1};
file_name=[file_base_name,'.png'];
I = imread (file_name);

blue = I;
green = I;
red = I;
yuv = I;

#image_height = 480;
image_height = 200;
image_width = 640;

# Formulas for conversion
#    Y = 0.299R + 0.587G + 0.114B
#    U'= (B-Y)*0.565
#    V'= (R-Y)*0.713

# with reciprocal versions:
#    R = Y + 1.403V'
#    G = Y - 0.344U' - 0.714V'
#    B = Y + 1.770U'

####################
# Generate YUV image
####################
Y = 0;
U = 0;
V = 0;

file_name=[file_base_name,'.dat'];
fid = fopen(file_name, 'w'); 
if (fid < 0)
  printf("Couldn't open file");
else
  while image_height != 0
    while image_width != 0
      #############################################################################################
      # Picture needs to be colored. NOT B/W! Otherwise octave will exit with a matrix index error!
      #############################################################################################
      Y = uint8((0.299 * I(image_height, image_width, 1)) + (0.587 * I(image_height, image_width, 2)) + (0.114 * I(image_height, image_width, 3)) + 16); 
      if (mod(image_width, 2) == 0)
	U = uint8((I(image_height, image_width, 3)-Y)*0.565);
	fwrite(fid, U);
	yuv_txt(image_height, image_width*2) = U;
	yuv(image_height, image_width, 2) = U;
      else
	V = uint8((I(image_height, image_width, 1)-Y)*0.713);
	fwrite(fid, V);
	yuv_txt(image_height, image_width*2) = V;
	yuv(image_height, image_width, 2) = V; 
      endif
				# red = y
      yuv(image_height, image_width, 1) = Y;
      fwrite(fid, Y);
      yuv_txt(image_height, image_width*2-1) = Y;
				#blue = void
      yuv(image_height, image_width, 3) = 0; 
      image_width = image_width -1;
    endwhile
    image_width = 640;
    image_height = image_height -1;
  endwhile
endif
save_precision (3)
#save -ascii "yuv.txt" yuv_txt; # write YUV picture pixel information as ascii data
file_name=[file_base_name,'.txt'];
dlmwrite (file_name, yuv_txt, ",") # Same as above, but ',' separated
file_name=[file_base_name,'.bmp'];
imwrite (yuv, file_name); # Write the image, This image is needed by yuv2png

#################################################################
# Re-generate RGB image to evaluate the results of the conversion
#################################################################
DEBUG
if (DEBUG == 1)
  # yuv = imread ("yuv.bmp");

  rgb = yuv; # initialize new rgb picture to content of yuv picture

  image_height = 480;
  image_width = 640;

  while image_height != 0
    while image_width != 0
      if (mod(image_width, 2) == 0)
	U = yuv(image_height, image_width, 2);
	fwrite(fid, U);
      else
	V = yuv(image_height, image_width, 2);
	fwrite(fid, V);
      endif
      Y = yuv(image_height, image_width, 1);
      fwrite(fid, Y);
      
      rgb(image_height, image_width, 1) = uint8(Y + 1.403 * V);             # red
      rgb(image_height, image_width, 2) = uint8(Y - 0.344 * U - 0.714 * V); # green
      rgb(image_height, image_width, 3) = uint8(Y + 1.770 * U);             # blue
      
      image_width = image_width -1;
    endwhile
    image_width = 640;
    image_height = image_height -1;
  endwhile

file_name=[file_base_name,'.bmp'];
  imwrite (rgb, file_name);
endif
#save -binary rgb.mat rgb
