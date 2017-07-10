#! /bin/gawk -f
##############################################################################################################################################
# Program	:	clip_column.awk
# Author	:	Hendrik HANFF
#			hhanff@uni-bremen.de
# Company	:	University of Bremen
# Team		:	AG Kopf
# Creation date	:	080228
# Description	:	This script was made to exchange the 11th column of the inputfile by the value 2.5 if it matches a certain expression.
#					
#					
#			How to use it :
#			rm  <source file>
#			./clip_column <source file>
#						
#			With :
#			<source file> 		file which shall be processed
#
#			Example : 
#			rm  output.dat
#			./clip_column <source file>
#					
#			Attention:
#
# History	:
#			who	when		what
#			hhanff	28/Feb/08	created
#
##############################################################################################################################################
BEGIN{
# Input Field separator
    FS = " "
# Output Field Separators 
    OFS = " "

i = 0
j = 0
#    print("awk started...")
}

#========  ========#
{

    while(getline <"temp6.dat"   > 0) {
        name1[j]=$1
        j ++
    }

    while(getline <"output.dat"   > 0) {
        if(match($11,"?") == 0){ 
            print ($1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" " name1[i]" "$12" "$13" "$14" "$15)
        }
        else {
             print ($1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" " $11 " "$12" "$13" "$14" "$15)
        }
        
        i++
        
    }

#     for(i=0;i<j; i++){
# 	printf (name1[i]("\n"))
#     }

#     print ("$12" "$13" "$14" "$15")

}
END {

#    print ("awk finished...")		
    
}


	


