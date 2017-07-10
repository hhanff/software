BEGIN{
istop = "no"
isheader = "no"
}
{
  print($0)
  if (($1 == ".SUBCKT")&&($2 == "usb_top"))
  {
	  istop = "yes"
	  isheader = "yes"
  }
  if ((istop == "yes")&&(($1 == "+")||($1 == ".SUBCKT")))
  {
	  isheader = "yes"
  }
  else
  {
	  isheader = "no"
  }
  if ((isheader == "no")&&(istop == "yes"))
  {
	  print ("*.CONNECT gnd gndmem")
	  istop = "no"
	  isheader = "no"	  
  }
}
