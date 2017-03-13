#! /bin/bash
rm -rf tmp* *.html
wget http://www.dielottozahlen.de/LOTTO/6AUS49/lottozahlen08.html
wget http://www.dielottozahlen.de/LOTTO/6AUS49/lottozahlen00.html
wget http://www.dielottozahlen.de/LOTTO/6AUS49/lottozahlen90.html
wget http://dielottozahlen.de/lotto/6aus49/6aus49.html
more 6aus49.html | grep Ziehungsreihenfolge >> tmp01
more 6aus49.html | grep Gewinnzahlen >> tmp01
more lottozahlen08.html | grep Ziehungsreihenfolge >> tmp01
more lottozahlen08.html | grep Gewinnzahlen >> tmp01
more lottozahlen00.html | grep Ziehungsreihenfolge >> tmp01
more lottozahlen00.html | grep Gewinnzahlen >> tmp01
more lottozahlen90.html | grep Ziehungsreihenfolge >> tmp01
more lottozahlen90.html | grep Gewinnzahlen >> tmp01
sed 's/[a-z]//g' tmp01 >tmp02 
sed 's/^.\{8\}//g' tmp02 > tmp03
sed 's/[</>]//g' tmp03 > tmp04
sed 's/-//g' tmp04 >tmp05 
awk '{print $1" "$2" "$3" "$4" "$5" "$6}' tmp05 >tmp06 
#./lotto
./lotto | sort -n
#rm -rf tmp* *.html
#6 24 29 30 36 49
