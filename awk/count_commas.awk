awk ' BEGIN { count=0; quote=0}
    { for (i=1;i<=length($0);i++)
      {
      	  if(substr($0,i,1)=="\"") { quote=!quote; continue};
          if(substr($0,i,1)=="," && quote==0) {count++;}
      }
    }
     END {print count} ' line