#/bin/bash
rm -rf ./Kohltour_2011_*.pdf
##pdftk A=Geburtstag_30.pdf cat A1 output Geburtstag_30_1.pdf
##mv Geburtstag_30_1.pdf Geburtstag_30.pdf
#inkscape -f Flyer_Kohltour_2011_de.svg -A Flyer_Kohltour_2011_de.pdf
inkscape -f Flyer_Kohltour_2011_en.svg -A Flyer_Kohltour_2011_en.pdf

pdf2ps -sDEVICE=psgray Flyer_Kohltour_2011_de.pdf
#pdf2ps -sDEVICE=psgray Flyer_Kohltour_2011_en.pdf
ps2pdf Flyer_Kohltour_2011_de.ps
#ps2pdf Flyer_Kohltour_2011_en.ps

#pdftk Geburtstag_30.pdf Geburtstag_30.pdf Geburtstag_30.pdf Geburtstag_30.pdf  cat output Geburtstag_30_4pages.pdf
#pdfnup --nup 2x2 --column true Geburtstag_30_4pages.pdf
#rm -rf Geburtstag_30_4pages.pdf
#cp *.pdf /media/nfs/pic/Kerstin_Geburtstag/
#xpdf Geburtstag_30.pdf
#xpdf Geburtstag_30_sw.pdf
rm -rf *.ps
#convert -density 300 /media/nfs/pic/Kerstin_Geburtstag/Geburtstag_30.pdf /media/nfs/pic/Kerstin_Geburtstag/Geburtstag_30.jpg
#convert -density 300 /media/nfs/pic/Kerstin_Geburtstag/Geburtstag_30_sw.pdf /media/nfs/pic/Kerstin_Geburtstag/Geburtstag_30_sw.jpg
#rm -rf /media/nfs/pic/Kerstin_Geburtstag/Geburtstag_30_4pages.pdf 
#rm -rf /media/nfs/pic/Kerstin_Geburtstag/Geburtstag.pdf
