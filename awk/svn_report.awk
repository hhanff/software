# Execute with:
# > svn info -R * | awk -f svd_report.awk
BEGIN { RS="";
        FS = "\n";
        printf("%-75s %10s %10s %-45s\n","Path","Cur Rev","Last Rev","Last Change Date"); }
/^Path:/ { n1 = split($1,path,":");
           n2 = split($6,curRev,":");
           n3 = split($9,lastRev,":");
           n4 = split($10,changeDate,": ");
           printf("%-75s %8s %8s %-45s\n", path[2], curRev[2], lastRev[2], changeDate[2]); }
