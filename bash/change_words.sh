#!/bin/sh

PROJECT_PATH_1=C:/Projects/DiscPack/busdriver/hdl/design/IICSlave; export PATH
#PROJECT_PATH_2=C:/Projects/DiscPack/busdriver/hdl/test; export PATH
PROJECT_PATH_3=C:/Projects/DiscPack/busdriver/project/IICSlave; export PATH
PROJECT_PATH_4=C:/Projects/DiscPack/syscontrol/hw/hdl/design/IICMaster; export PATH
PROJECT_PATH_5=C:/Projects/DiscPack/syscontrol/hw/hdl/test; export PATH
PROJECT_PATH_6=C:/Projects/DiscPack/syscontrol/hw/project/IICMaster; export PATH

echo "Project Path 1:" $PROJECT_PATH_1
#echo "Project Path 2:" $PROJECT_PATH_2
echo "Project Path 3:" $PROJECT_PATH_3
echo "Project Path 4:" $PROJECT_PATH_4
echo "Project Path 5:" $PROJECT_PATH_5
echo "Project Path 6:" $PROJECT_PATH_6

if [ $# -ne 2 ]; then
         echo 1>&2 Usage: $0 "<WORD_TO_CHANGE> <NEW_WORD>"
         exit 127
fi

echo "Ich weiﬂ nicht ob das funzt wegen $0 und $1..."
echo " "
echo "========= Processing ============"
echo " "
echo "=========Changing path  1============"
perl -pi.orig  -e "s/$1/$2/gi" $PROJECT_PATH_1/*.vhd
#echo "=========Changing path  2============"
#perl -pi.orig  -e "s/$1/$2/gi" $PROJECT_PATH_2/*.vhd
echo "=========Changing path  3============"
perl -pi.orig  -e "s/$1/$2/gi" $PROJECT_PATH_3/*.vhd
echo "=========Changing path  4============"
perl -pi.orig  -e "s/$1/$2/gi" $PROJECT_PATH_4/*.vhd
echo "=========Changing path  5============"
perl -pi.orig  -e "s/$1/$2/gi" $PROJECT_PATH_5/*.do
echo "=========Changing path  6============"
perl -pi.orig  -e "s/$1/$2/gi" $PROJECT_PATH_6/*.vhd
echo " "
echo "=========== Done =============="
echo " "
#http://www.softpanorama.org/Scripting/Perlorama/perl_in_command_line.shtml
#perl -pi.bak -e "s/Foo/Bar/g" <FileList>
#http://perldoc.perl.org/perlrun.html
#perl -p -i.orig -e "s/foo/bar/; ... "
#perl -pi'old/*.orig' -e 's/bar/baz/' fileA
#      i: ignore upper/lowercase
#     /s: substitute
#     /g: global matching
#     folders *.vhd: vhdl, tbench
#     folders *.do : sim, bin
