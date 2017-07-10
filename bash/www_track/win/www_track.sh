#!/bin/sh
##############################################################################################################
# Program	:	www_track.sh
# Author	:	Hendrik HANFF
#			Hendrik.Hanff@xxx.de
# Company	:	
# Team		:	TCG Sophia
# Creation date	:	20.10.2008
# Description	:	- This script was made to observe changes on web-sites like the marketplace on http://Bremen.de
#					
#					- How to use it :
#						./www_track.sh
#	
#					With :
#
#					Example : 
#                                                             ./www_track.sh
#
#					Attention/Future Work:
#						- I would like to hand over the name of the web-site to as a command-line parameter to the script.
#                                                             - If wget does not work on win XP platform try the one from unixutils.
# History	:
#			who		when			what
#			hhanff	20.10.2008		created
#
###############################################################################################################
/bin/wget -r -k  "http://www.schwarzesbrett.bremen.de/sixcms/detail.php?template=01_markt_eintraege_d&id=28586&host=bremen"
echo "Download finnished"
mv  www.schwarzesbrett.bremen.de/sixcms/detail.php\@template\=01_markt_eintraege_d\&id\=28586\&host\=bremen .
#rm -Rf bremen.de
diff "detail.php@template=01_markt_eintraege_d&id=28586&host=bremen" old.html > diff.txt 

if less diff_old.txt | grep ">" | grep -i "Stuhl" 
then
    echo "FOUND!!!... sending mail..."
    cat "Found STUHL!"  | /usr/sbin/ssmtp.exe -v -f diff_old.txt -s test Hendrik.Hanff@xxx.de -au50901564  -apwo****
    echo "Done..."
fi

if less diff_old.txt | grep ">" | grep -i "Stühl" 
then
    echo "FOUND!!!... sending mail..."
    cat "Found STÜHLE"  | /usr/sbin/ssmtp.exe -v -f Hendrik.Hanff -s test Hendrik.Hanff@xxx.de -au50901564  -apwo****
    echo "Done..."
fi

echo "cleaning up..."
mv detail.php\@template\=01_markt_eintraege_d\&id\=28586\&host\=bremen old.html
#rm diff.txt
echo "Finnished."
