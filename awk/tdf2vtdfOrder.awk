#
##############################################################################################################################################
# Program	:	tdf2vtdf.awk
# Author	:	Hendrik HANFF
#
# Company	:
# Team		:	TCG Sophia
# Creation date	:	10-04-2004
# Description	:	- This script was made to convert *.tdf to *.vtdf files because PCM (Package Constraints Manager) is not able to
#			  read TopLevelSignalNames from tdf Files.
#
#
#					- How to use it :
#						rm  <source file>
#						nawk -f tdf_order_2_vtdf_order.awk <source file> > <target file>
#						nc <target file>
#
#
#
#
#					With :
#						<source file> 		tdf file which shall be converted
#						<target file>		vtdf file which shall be produces
#
#					Example :
#						rm  output.vtdf
#						nawk -f tdf_order_2_vtdf_order.awk input.tdf > output.vtdf
#						nc output.vtdf
#
#
#
#
#					Attention:
#						- I could not manage to delete the '"' from the pad names. They have to be deleted manually
#						- Two lines are inserted by the script which have to be deleted manually
#
#
#
# History	:
#			who	when		what
#			hhanff	10/Apr/04	created
#
##############################################################################################################################################

BEGIN{
OFS="\t"
i=0
j=0

}


#======== HEADER SCHREIBEN ========#


{
    while(getline <"/project/TCG/hhanff/CZMI/ver_30/bst_czmi_30mf_13Apr2004_17h10.io.vtdf" >0){
        if(match($1,"pad") == 0 && $1 != "*"){
            print ($0)
        }
    }



#======== LEFT ========#

    if (match($3,"left") != 0  && match($2,"corner") == 0 && match($2,"iosplit") == 0){
        printf ($2 ("\t ? \t ? \t ? \t ? \t ? \t ? \t ? \t ? \t ;\n"))
    }

    else {
#======== TOP ========#

        if(match($3,"top") != 0  && match($2,"corner") == 0 && match($2,"iosplit") == 0){
            printf ($2 ("\t ? \t ? \t ? \t ? \t ? \t ? \t ? \t ? \t ;\n"))
        }
        else{
#======== RIGHT ========#

            if(match($3,"right") != 0  && match($2,"corner") == 0 && match($2,"iosplit") == 0){
                name1[i]=$2
                i++
            }
            else{
#======== BOTTOM ========#
                if(match($3 ,"bottom") != 0  && match($2,"corner") == 0 && match($2,"iosplit") == 0){
                    name2[j]=$2
                    j++
                }
            }

        }
    }


}


END{
#======== AUSGABE RIGHT ========#

    for(a=i;a>=0; a--){
	printf (name1[a]("\t ? \t ? \t ? \t ? \t ? \t ? \t ? \t ? \t ;\n"))
    }

#======== AUSGABE BOTTOM ========#
    for(b=j;b>=0; b--){
        printf (name2[b]("\t ? \t ? \t ? \t ? \t ? \t ? \t ? \t ? \t ;\n"))
    }
    print("end nodeinfo")
}

#BEGIN{
#while(getline <"/project/TCG/hhanff/CZMI/awk/output.vtdf" >0){
#		if($0 != "* 	 * 	 * 	 * 	 * 	 * 	 * 	 * 	 ;" ){
#			print ($0)
#		}
#
#
#}
#}
