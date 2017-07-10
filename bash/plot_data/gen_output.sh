#!/bin/sh
dos2unix *.sh *.m
FOLDERNAME0="../../../data_telemetrie/DashgilData-070630"
FOLDERNAME1="../../../data_telemetrie/DashgilData-070817"
FOLDERNAME2="../../../data_telemetrie/DashgilData-070823"
FOLDERNAME3="../../../data_telemetrie/DashgilData-071115"
FOLDERNAME4="../../../data_telemetrie/DashgilData-071130"
FOLDERNAME5="../../../data_telemetrie/DashgilData-071211"
##################
##
## 0th set of data
##
##################
echo "  "
echo "  "
echo "#############################"
echo "processing 0th set of data..."
echo "#############################"

## remove old files
rm -f *.DAT *.gif output.dat

## copy data from 1st set of files
    echo "copying *.DAT files..."
cp $FOLDERNAME0/*.DAT .

## concatenate all data files and create a temporary file
cat *.DAT > temp1.dat
echo "... start processing data"
## remomve all lines that contain a " as they are comments
sed '/"/d' temp1.dat > temp2.dat
## replace all occurences of "-999" by "?" as they represent invalid data and 
## gnuplot does for some inexplicable reason accept the command:  set datafile missing "-999" 
sed 's/-999/?/g' temp2.dat > temp3.dat
## replace all ',' separators by whitespaces to do data processing with octave
sed 's/,/ /g' temp3.dat > output.dat
## now the inclination in row 11 has to be turned from voltage to degree
## 1st step: exchange the '?' by '2.5' ans save the values in temp4.dat
./clip_column.awk output.dat > temp4.dat
## next do the calculations: arcsin((U-2.5)/4)*180°/pi
octave -q -i -V octave.m
## remomve all lines that contain a # as they are comments introduced by octave
sed '/#/d' temp5.dat > temp6.dat
./paste_column.awk output.dat > temp7.dat
echo "... end processing data"

## call the gnuplot script
echo "plotting the data..."
gnuplot ./Dashgil.plt

## copy the pictures
mv *.gif $FOLDERNAME0/
mv temp7.dat $FOLDERNAME0/
echo "gif pictures stored..."
echo "removing temporary data"
rm -f temp*.dat

##################
##
## 1st set of data
##
##################
echo "  "
echo "  "
echo "#############################"
echo "processing 1st set of data..."
echo "#############################"

## remove old files
rm -f *.DAT *.gif output.dat

## copy data from 1st set of files
    echo "copying *.DAT files..."
cp $FOLDERNAME1/*.DAT .

## concatenate all data files and create a temporary file
cat *.DAT > temp1.dat
echo "... start processing data"
## remomve all lines that contain a " as they are comments
sed '/"/d' temp1.dat > temp2.dat
## replace all occurences of "-999" by "?" as they represent invalid data and 
## gnuplot does for some inexplicable reason accept the command:  set datafile missing "-999" 
sed 's/-999/?/g' temp2.dat > temp3.dat
## replace all ',' separators by whitespaces to do data processing with octave
sed 's/,/ /g' temp3.dat > output.dat
## now the inclination in row 11 has to be turned from voltage to degree
## 1st step: exchange the '?' by '2.5' ans save the values in temp4.dat
./clip_column.awk output.dat > temp4.dat
## next do the calculations: arcsin((U-2.5)/4)*180°/pi
octave -q -i -V octave.m
## remomve all lines that contain a # as they are comments introduced by octave
sed '/#/d' temp5.dat > temp6.dat
./paste_column.awk output.dat > temp7.dat
echo "... end processing data"

## call the gnuplot script
echo "plotting the data..."
gnuplot ./Dashgil.plt

## copy the pictures
mv *.gif $FOLDERNAME1/
mv temp7.dat $FOLDERNAME1/
echo "gif pictures stored..."
echo "removing temporary data"
rm -f temp*.dat

##################
##
## 2nd set of data
##
##################
echo "  "
echo "  "
echo "#############################"
echo "processing 2nd set of data..."
echo "#############################"

## remove old files
rm -f *.DAT *.gif output.dat

## copy data from 1st set of files
    echo "copying *.DAT files..."
cp $FOLDERNAME2/*.DAT .

## concatenate all data files and create a temporary file
cat *.DAT > temp1.dat
echo "... start processing data"
## remomve all lines that contain a " as they are comments
sed '/"/d' temp1.dat > temp2.dat
## replace all occurences of "-999" by "?" as they represent invalid data and 
## gnuplot does for some inexplicable reason accept the command:  set datafile missing "-999" 
sed 's/-999/?/g' temp2.dat > temp3.dat
## replace all ',' separators by whitespaces to do data processing with octave
sed 's/,/ /g' temp3.dat > output.dat
## now the inclination in row 11 has to be turned from voltage to degree
## 1st step: exchange the '?' by '2.5' ans save the values in temp4.dat
./clip_column.awk output.dat > temp4.dat
## next do the calculations: arcsin((U-2.5)/4)*180°/pi
octave -q -i -V octave.m
## remomve all lines that contain a # as they are comments introduced by octave
sed '/#/d' temp5.dat > temp6.dat
./paste_column.awk output.dat > temp7.dat
echo "... end processing data"

## call the gnuplot script
echo "plotting the data..."
gnuplot ./Dashgil.plt

## copy the pictures
mv *.gif $FOLDERNAME2/
mv temp7.dat $FOLDERNAME2/
echo "gif pictures stored..."
echo "removing temporary data"
rm -f temp*.dat

##################
##
## 3rd set of data
##
##################
echo "  "
echo "  "
echo "#############################"
echo "processing 3rd set of data..."
echo "#############################"

## remove old files
rm -f *.DAT *.gif output.dat

## copy data from 1st set of files
    echo "copying *.DAT files..."
cp $FOLDERNAME3/*.DAT .

## concatenate all data files and create a temporary file
cat *.DAT > temp1.dat
echo "... start processing data"
## remomve all lines that contain a " as they are comments
sed '/"/d' temp1.dat > temp2.dat
## replace all occurences of "-999" by "?" as they represent invalid data and 
## gnuplot does for some inexplicable reason accept the command:  set datafile missing "-999" 
sed 's/-999/?/g' temp2.dat > temp3.dat
## replace all ',' separators by whitespaces to do data processing with octave
sed 's/,/ /g' temp3.dat > output.dat
## now the inclination in row 11 has to be turned from voltage to degree
## 1st step: exchange the '?' by '2.5' ans save the values in temp4.dat
./clip_column.awk output.dat > temp4.dat
## next do the calculations: arcsin((U-2.5)/4)*180°/pi
octave -q -i -V octave.m
## remomve all lines that contain a # as they are comments introduced by octave
sed '/#/d' temp5.dat > temp6.dat
./paste_column.awk output.dat > temp7.dat
echo "... end processing data"

## call the gnuplot script
echo "plotting the data..."
gnuplot ./Dashgil.plt

## copy the pictures
mv *.gif $FOLDERNAME3/
mv temp7.dat $FOLDERNAME3/
echo "gif pictures stored..."
echo "removing temporary data"
rm -f temp*.dat

##################
##
## 4th set of data
##
##################
echo "  "
echo "  "
echo "#############################"
echo "processing 4th set of data..."
echo "#############################"

## remove old files
rm -f *.DAT *.gif output.dat

## copy data from 1st set of files
    echo "copying *.DAT files..."
cp $FOLDERNAME4/*.DAT .

## concatenate all data files and create a temporary file
cat *.DAT > temp1.dat
echo "... start processing data"
## remomve all lines that contain a " as they are comments
sed '/"/d' temp1.dat > temp2.dat
## replace all occurences of "-999" by "?" as they represent invalid data and 
## gnuplot does for some inexplicable reason accept the command:  set datafile missing "-999" 
sed 's/-999/?/g' temp2.dat > temp3.dat
## replace all ',' separators by whitespaces to do data processing with octave
sed 's/,/ /g' temp3.dat > output.dat
## now the inclination in row 11 has to be turned from voltage to degree
## 1st step: exchange the '?' by '2.5' ans save the values in temp4.dat
./clip_column.awk output.dat > temp4.dat
## next do the calculations: arcsin((U-2.5)/4)*180°/pi
octave -q -i -V octave.m
## remomve all lines that contain a # as they are comments introduced by octave
sed '/#/d' temp5.dat > temp6.dat
./paste_column.awk output.dat > temp7.dat
echo "... end processing data"

## call the gnuplot script
echo "plotting the data..."
gnuplot ./Dashgil.plt

## copy the pictures
mv *.gif $FOLDERNAME4/
mv temp7.dat $FOLDERNAME4/
echo "gif pictures stored..."
echo "removing temporary data"
rm -f temp*.dat

##################
##
## 5th set of data
##
##################
echo "  "
echo "  "
echo "#############################"
echo "processing 5th set of data..."
echo "#############################"

## remove old files
rm -f *.DAT *.gif output.dat

## copy data from 1st set of files
    echo "copying *.DAT files..."
cp $FOLDERNAME5/*.DAT .

## concatenate all data files and create a temporary file
cat *.DAT > temp1.dat
echo "... start processing data"
## remomve all lines that contain a " as they are comments
sed '/"/d' temp1.dat > temp2.dat
## replace all occurences of "-999" by "?" as they represent invalid data and 
## gnuplot does for some inexplicable reason accept the command:  set datafile missing "-999" 
sed 's/-999/?/g' temp2.dat > temp3.dat
## replace all ',' separators by whitespaces to do data processing with octave
sed 's/,/ /g' temp3.dat > output.dat
## now the inclination in row 11 has to be turned from voltage to degree
## 1st step: exchange the '?' by '2.5' ans save the values in temp4.dat
./clip_column.awk output.dat > temp4.dat
## next do the calculations: arcsin((U-2.5)/4)*180°/pi
octave -q -i -V octave.m
## remomve all lines that contain a # as they are comments introduced by octave
sed '/#/d' temp5.dat > temp6.dat
./paste_column.awk output.dat > temp7.dat
echo "... end processing data"

## call the gnuplot script
echo "plotting the data..."
gnuplot ./Dashgil.plt

## copy the pictures
mv *.gif $FOLDERNAME5/
mv temp7.dat $FOLDERNAME5/
echo "gif pictures stored..."
echo "removing temporary data"
rm -f temp*.dat

##################
##
## All data sets
##
##################
echo "  "
echo "  "
echo "#############################"
echo "processing all data sets..."
echo "#############################"

## remove old files
rm -f *.DAT *.gif output.dat

## copy data from 1st set of files
echo "copying *.DAT files..."
cp $FOLDERNAME1/*.DAT .
cp $FOLDERNAME2/*.DAT .
cp $FOLDERNAME3/*.DAT .
cp $FOLDERNAME4/*.DAT .
cp $FOLDERNAME5/*.DAT .

## concatenate all data files and create a temporary file
cat *.DAT > temp1.dat
echo "... start processing data"
## remomve all lines that contain a " as they are comments
sed '/"/d' temp1.dat > temp2.dat
## replace all occurences of "-999" by "?" as they represent invalid data and 
## gnuplot does for some inexplicable reason accept the command:  set datafile missing "-999" 
sed 's/-999/?/g' temp2.dat > temp3.dat
## replace all ',' separators by whitespaces to do data processing with octave
sed 's/,/ /g' temp3.dat > output.dat
## now the inclination in row 11 has to be turned from voltage to degree
## 1st step: exchange the '?' by '2.5' ans save the values in temp4.dat
./clip_column.awk output.dat > temp4.dat
## next do the calculations: arcsin((U-2.5)/4)*180°/pi
octave -q -i -V octave.m
## remomve all lines that contain a # as they are comments introduced by octave
sed '/#/d' temp5.dat > temp6.dat
./paste_column.awk output.dat > temp7.dat
echo "... end processing data"

## call the gnuplot script
echo "plotting the data..."
gnuplot ./Dashgil.plt

## copy the pictures
mv *.gif ../../../data_telemetrie/
mv temp7.dat ../../../data_telemetrie/
echo "gif pictures stored..."
echo "removing temporary data"
rm -f temp*.dat *.DAT

