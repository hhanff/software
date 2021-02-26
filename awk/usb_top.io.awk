BEGIN {
print("######################################################")
print("#                                                    #")
print("#  Silicon Perspective, A Cadence Company            #")
print("#  FirstEncounter IO Assignment                      #")
print("#                                                    #")
print("######################################################\n")

print("Version: 2\n")
}

{
	if ($1=="*")	
		{
			print($1, $2, $3)		
		}
	if($1!="Offset:")	
	{
				
		if ($1=="Version")	
		{
			print($1, $2)		
		}
		
		if ($1=="Pin:")	
		{
			print($1, $2, $3="S")		
		}

		
	}
}


