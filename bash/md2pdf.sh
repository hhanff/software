#/bin/bash
pandoc --template eisvogel.tex --number-sections --toc  -V toc-title:"Table of Contents" README.md -o sdso_manual.pdf
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dColorImageDownsampleType=/Bicubic -dColorImageResolution=150 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=150 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=150 -dNOPAUSE -dBATCH  -dQUIET -sOutputFile=sdso_manual_screen.pdf sdso_manual.pdf
mv sdso_manual_screen.pdf sdso_manual.pdf
cp sdso_manual.pdf ~/ownCloud/SDSO\ Shared\ Project\ Folder/Documentation/A1703\ Prototype\ Field\ Test/
cp sdso_manual.pdf ~/ownCloud/Shared
