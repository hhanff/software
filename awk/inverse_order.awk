#!/usr/bin/nawk -f
##############################################################################################################################################
# Program	:	tdf2vtdf.awk
# Author	:	Hendrik HANFF
#
# Company	:
# Team		:
# Creation date	:	10-04-2004
# Description	:	- This script was made to convert *.tdf to *.vtdf files because PCM (Package Constraints Manager) is not able to
#			  read TopLevelSignalNames from tdf Files.
#
#
#					- How to use it :
#
#						inverse_order.awk <source_file>
#						the file <inverse.tmp> pops up automatically and the inverted text can be copied
#
#
#					With :
#						<source file> 		File that shall be inverted
#
#					Example :
#						inverse_order.awk /project/TCG/hhanff/CZMI/awk/numbers.txt
#
#
#
#
#					Attention:
#						-
#
#
# History	:
#			who	when		what
#			hhanff	30/Apr/04	created
#
##############################################################################################################################################

BEGIN{
if (ARGC!=2){
	system ("clear")
	system("echo '============================================================='")
	system("echo   '\n'")
	system("echo 'This script inverses lists \nThe output file is <inverse.tmp> '")
	system("echo   '\n'")
	system("echo Usage:")
	system("echo '\t inverse_order.awk <inpput_file>'")

	system("echo Example:  ")
	system("echo '\t inverse_order.awk /project/TCG/hhanff/CZMI/awk/numbers.txt'")
	system("echo   '\n'")
	system("echo '============================================================='")
	system("echo   '\n'")


	exit -15
}


OFS="\t"
i=0
j=0
}
#system("wc -l input.tdf")

#printf("%i",lines)
{
while(getline < FILENAME > 0){
		a++
		line[a]=$0

}

}

END{

for(i=0;a>=0; a--){
	print (line[a]) > "inverse.tmp"
}
if (ARGC==2){
 	system("nc inverse.tmp")
}
}
