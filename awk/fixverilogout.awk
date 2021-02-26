##############################################################################################################################################
# Program	:	fixverilogout.awk
# Author	:	Marc BOIGEY
#			marc.boigey@philips.com
# Company	:	Philips Semiconductors Sophia
# Team		:	TC Sophia
# Creation date	:	07-03-2003
# Description	:	- Remove non active cells in the Source Spice Netlist (fron verilog)
# 					i.e. : 
#							+ Standards cells fillers
#							+ Pads cells fillers 
#							+ Pads cells split
#
#					- How to use it :
#						awk -f fixverilogout.awk <source file> > <target file> 
#					With :
#						<source file> 		Spice Netlist (from verilog) with non active element (as fillers and spiliters)
#						<target file>		Spice Netlist without non active elements
#
# History	:
#			who	when		what
#			mpb	07/03/03	created
##############################################################################################################################################
BEGIN{
    isprint = "yes"
}
{
    if( match($1,"X") == 1 )
    {
        if ((match($1,"Xfillercell") != 1)&&($2 != "iofiller1")&&($2 != "iofiller2")&&($2 != "iofiller4")&&($2 != "iofiller8")&&($2 != "iosplitvdde")&&($2 != "iosplitvdde5")&&($2 != "iosplitgnde"))
        {
            isprint = "yes"
        }
        else
        {
            isprint = "no"
        }
    }
    if ($1 == ".ENDS")
    {
        isprint = "yes"
    }
    if (isprint == "yes")
    {
        print($0)
    }

}
