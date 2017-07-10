#! /bin/sh
#wget -e -l2
wget -r -l1 A.htm http://members.aol.com/gysypub/adressen/adressen.htm
mv members.aol.com/gysypub/adressen/*.htm .
rm -r members.aol.com
echo "In 2008 neue.htm and neue2.htm was not present any more but the link existed"
rm neue.htm neue2.htm adressen.htm aktuell.htm eintrag.htm neue.htm
perl -wne'while(/[\w\.\-]+@[\w\.\-]+\w+/g){print "$&\n"}' *.htm | sort -u > tmp.txt
perl -wne'while(/[\w\.\-]+@[\w\.\-]+\w+/g){print "$&; "}' tmp.txt | sort -u > addressen-mit-lehrern.txt
mv lehrer.htm lehrer.html
rm tmp.txt
perl -wne'while(/[\w\.\-]+@[\w\.\-]+\w+/g){print "$&\n"}' *.htm | sort -u > tmp.txt
perl -wne'while(/[\w\.\-]+@[\w\.\-]+\w+/g){print "$&; "}' tmp.txt | sort -u > addressen-ohne-lehrer.txt
mv lehrer.html lehrer.htm
rm tmp.txt

wget -r -l1 --execute robots=off -H -t1 -nd -np -nh -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14" A.mp3 http://www.google.com/search?q="Kaiser+Chiefs"+-inurl:htm+-inurl:html+intitle:"index+of"+mp3+OR+ogg+OR+m4a+-reviews

wget -r -l1  --restrict-file-names=Windows --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" --header="Accept:text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" --header="Accept-Language: en-us,en;q=0.5" --header="Accept-Encoding: gzip,deflate" --header="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" --header="Keep-Alive: 300" -dnv http://www.google.com/search?q=%22Kaiser+Chiefs%22+-inurl%3Ahtm+-inurl%3Ahtml+intitle%3A%22index+of%22+mp3+OR+ogg+OR+m4a+-reviews

wget -r -l1 --execute robots=off -O Google.htm -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14" A .htm http://www.google.com/search?q="Kaiser+Chiefs"+-inurl:htm+-inurl:html+intitle:"index+of"+mp3+OR+ogg+OR+m4a+-reviews

wget -r -l1 -H -t1 -nd -N -np -A.mp3 -erobots=off -i mp3_sites.txt

wget -r -l1 --execute robots=off -H -t1 --force-directories -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14" A.mp3 http://www.google.com/search?q="Kaiser+Chiefs"+-inurl:htm+-inurl:html+intitle:"index+of"+mp3+OR+ogg+OR+m4a+-reviews

wget -r -l2 --execute robots=off -r -l1 -H -t1 -nd -N -np -A.mp3 -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14" A.mp3 http://www.google.com/search?q="Kaiser+Chiefs"+-inurl:htm+-inurl:html+intitle:"index+of"+mp3+OR+ogg+OR+m4a+-reviews
