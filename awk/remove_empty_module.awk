##############################################################################################################################################
# Program	:	remove_empty_module.awk
# Author	:	Marc BOIGEY
#			marc.boigey@philips.com
# Company	:	Philips Semiconductors Sophia
# Team		:	TC Sophia
# Creation date	:	07-03-2003
# Description	:	- Remove empty module in blocklevel PG netlist from  
#					First Encounter (2.3 usr4)
#					- This scripts is in two part :
#							1) Set the module name to remove in the list variable "name" 
#							The 20 first are set hardly and the other are automaticly find in 
#							the LEF file of the standard cells and iocells libraries
#							2) read the toplevel PG verilog with the empty module
#							and write the new verilog without the empty verilog contain in the 
#							list varialbe named "name"
#
#					- How to use it :
#						awk -f remove_empty_module.awk USER_DB=$USER_DB <source file> > <target file> 
#					With :
#						<source file> 		blocklevel verilog with powers&grounds and with empty module
#						<target file>		blocklevel verilog with powers&grounds  
#
# History	:
#			who	when		what
#			mpb	07/03/03	created
##############################################################################################################################################
BEGIN{

    name[1]="sram_20_4_32_usb"
    name[2]="sram"
    name[3]="rom"
    name[4]="ebram_2368b"
    name[5]="delay1"
    name[6]="rcosc"
    name[7]="ldo_top"
    name[8]="ltg_c090lp_l_bg1v2"
    name[9]="ltg_c090lp_pr"
    name[10]="ltg_c090lp_xo32k"
    name[11]="switch_usb"
    i=12
    while(getline <"/project/BlueTooth/SyncProjects/ROME/sync.Cadenv/.caddata/PcC090LPvcorelib/tools/fe/lef/vcorelib_5.5.lef" >0)
    {
        if($1=="MACRO")
        {
            i++
            name[i]=$2
        }
    }
    close("/project/BlueTooth/SyncProjects/ROME/sync.Cadenv/.caddata/PcC090LPvcorelib/tools/fe/lef/vcorelib_5.5.lef")
    while(getline <"/project/BlueTooth/SyncProjects/ROME/sync.Cadenv/.caddata/PcC090LPvcorelib_danger/tools/fe/lef/vcorelib_danger_5.5.lef" >0)
    {
        if($1=="MACRO")
        {
            i++
            name[i]=$2
        }
    }
    close("/project/BlueTooth/SyncProjects/ROME/sync.Cadenv/.caddata/PcC090LPvcorelib_danger/tools/fe/lef/vcorelib_danger_5.5.lef")
    while(getline <"/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/IO1V8/fe/lef/hliolib_p50_io1v8_5.5.lef " >0)
    {
        if($1=="MACRO")
        {
            i++
            name[i]=$2
        }
    }
    close("/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/IO1V8/fe/lef/hliolib_p50_io1v8_5.5.lef")
    while(getline <"/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/IO3V3/fe/lef/hliolib_p50_io3v3_5.5.lef" >0)
    {
        if($1=="MACRO")
        {
            i++
            name[i]=$2
        }
    }
    close("/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/IO3V3/fe/lef/hliolib_p50_io3v3_5.5.lef")
    while(getline <"/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/IOT5V/fe/lef/hliolib_p50_iot5v_5.5.lef" >0)
    {
        if($1=="MACRO")
        {
            i++
            name[i]=$2
        }
    }
    close("/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/IOT5V/fe/lef/hliolib_p50_iot5v_5.5.lef")
    while(getline <"/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/USB/fe/lef/hliolib_p50_usb_5.5.lef" >0)
    {
        if($1=="MACRO")
        {
            i++
            name[i]=$2
        }
    }
    close("/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/USB/fe/lef/hliolib_p50_usb_5.5.lef")
    while(getline <"/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/USIM/fe/lef/hliolib_p50_usim_5.5.lef" >0)
    {
        if($1=="MACRO")
        {
            i++
            name[i]=$2
        }
    }
    close("/project/TCG/CAJU/global/cadenv/.caddata/PcC090LPhliolib_p50/tools/USIM/fe/lef/hliolib_p50_usim_5.5.lef")
}
{
    if ($1 == "module")
    {
        ispresent = "no"
        for(j=1;j<=i;j++)
        {
            if ($2 == name[j])
            {
                ispresent = "yes"
            }
        }	
        if (ispresent == "yes")
        {
            isprint = "no"
        }
        else
        {
            isprint = "yes"
        }
    }
    if (isprint == "yes")
    {
        print($0)
    }
}
