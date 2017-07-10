 < temp.txt
    more temp.txt | /usr/sbin/ssmtp -v -f Hendrik.Hanff -s  Hendrik.Hanff@xxx.de
    echo "Done."
else
echo "Found nothing."
fi

#if ( less diff.txt | grep ">" | grep -i "Stuehle" )
#then
#    echo "Match!!!. Sending mail."
#    cat mail.txt diff.txt > temp.txt
##    /usr/sbin/ssmtp -v Hendrik.Hanff@xxx.de -au50901564  -apwo**** < temp.txt
#     cat temp.txt | /usr/sbin/ssmtp -v -f Hendrik.Hanff -s Hendrik.Hanff@gxx.de
#    echo "Done."
#else
# echo "Found nothing."
#fi

echo "Cleaning up."
mv "detail.php?template=01_markt_eintraege_d&id=28582&host=bremen" old.html
echo "Finnished."
 cd ~
