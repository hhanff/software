#!/bin/bash

#settings

#days to hold old backups
DAYS=7

#folder for backupfiles
BACKUPFOLDER=~/backups

#folders to back up
#use full path without leading /, different folders are seperated by spaces
FOLDERS=()

#Files or foloders that should be excluded from the FOLDERS above
#folders without leading and ending /
EXCLUDE_FILES=()

#Mail settings
#different Mailadresses are seperated by spaces
MAIL_FAILED_TO=(hendrik.hanff@dfki.de)
MAIL_SUCCESS_TO=(hendrik.hanff@dfki.de)

#SQL settings
BACKUPSQL="false"
SQLHOST="hhanff.zpdns.org"
SQLUSER="hhanff"
SQLPASSWD=""

#SVN settings
SVN_REPOS_FOLDERS=(home/hhanff/Projekte/ home/hhanff/Dokumente/)


#remote settings (latest backup is copied here) (publickey login required)
REMOTE_USER=hhanff
REMOTE_HOST=192.168.0.5
REMOTE_FOLDER=/home/hhanff/backup


#end of settings

X=$(date +%Y_%m_%d_%H%M)
SUCCESS="true"

echo Creating new Backup file: $BACKUPFOLDER/backup_$X.tar.
echo Creating new Backup file: $BACKUPFOLDER/backup_$X.tar. >> $BACKUPFOLDER/backup_$X.log

cd /

#creeate exclude parameter
for EXCLUDE_FILES in ${EXCLUDE_FILES[*]}; do
    EXCLUDE=" --exclude="$EXCLUDE_FILES" "$EXCLUDE
    echo $EXCLUDE
done


# back up folders...
for FOLDER in ${FOLDERS[*]}; do
    echo backing up $FOLDER...
    echo backing up $FOLDER... >> $BACKUPFOLDER/backup_$X.log

    TMP=$(echo $FOLDER | tr "/" "_")
    NAMES[${#NAMES[*]}]=backup_$TMP.tgz
    echo tar czf $BACKUPFOLDER/backup_$TMP.tgz $FOLDER $EXCLUDE;
    if tar czf $BACKUPFOLDER/backup_$TMP.tgz $FOLDER $EXCLUDE;
        then
        echo success >> $BACKUPFOLDER/backup_$X.log;
        echo success
        else
        SUCCESS="false"
        echo FAILED  >> $BACKUPFOLDER/backup_$X.log;
        echo FAILED
    fi
done

#SQL backup
if test $BACKUPSQL == "true";
then
        echo "Dumping SQL..."
        echo "Dumping SQL..." >> $BACKUPFOLDER/backup_$X.log

        NAMES[${#NAMES[*]}]=sql_dump.tgz
        if mysqldump -A -h $SQLHOST --user=$SQLUSER --password=$SQLPASSWD > $BACKUPFOLDER/sql_dump.sql && tar czf  $BACKUPFOLDER/sql_dump.tgz $BACKUPFOLDER/sql_dump.sql && rm $BACKUPFOLDER/sql_dump.sql;
            then
            echo success >> $BACKUPFOLDER/backup_$X.log
            echo success
        else
            SUCCESS="false"
            echo FAILED  >> $BACKUPFOLDER/backup_$X.log
            echo FAILED
        fi
fi


#svndump                                                                     
for FOLDER in ${SVN_REPOS_FOLDERS[*]}; do
        echo "Dumping SVN: $FOLDER..."
        echo "Dumping SVN: $FOLDER..." >> $BACKUPFOLDER/backup_$X.log
               
                TMP=$(echo $FOLDER | tr "/" "_")
                NAMES[${#NAMES[*]}]=svndump_$TMP.tgz
                echo $FOLDER;
        if svnadmin dump /$FOLDER > $BACKUPFOLDER/svndump_$TMP && tar czf $BACKUPFOLDER/svndump_$TMP.tgz $BACKUPFOLDER/svndump_$TMP && rm $BACKUPFOLDER/svndump_$TMP;
            then
            echo success >> $BACKUPFOLDER/backup_$X.log
            echo success
        else
            SUCCESS="false"
            echo FAILED  >> $BACKUPFOLDER/backup_$X.log
            echo FAILED
        fi
done


cd $BACKUPFOLDER
echo tar backups into one file... >> $BACKUPFOLDER/backup_$X.log;
echo tar backups into one file...
if tar cf backup_$X.tar ${NAMES[*]};
    then
    echo success >> $BACKUPFOLDER/backup_$X.log;
    echo success
    else
    SUCCESS="false"
    echo FAILED  >> $BACKUPFOLDER/backup_$X.log;
    echo FAILED
fi


if test $SUCCESS == "true"; then
    echo Copying to remote server...
    echo Copying to remote server... >> $BACKUPFOLDER/backup_$X.log
    if scp ./backup_$X.tar $REMOTE_USER@$REMOTE_HOST:$REMOTE_FOLDER/$(uname -n).tar;
    then
        echo success >> $BACKUPFOLDER/backup_$X.log;
        echo success
    else
        SUCCESS="false"
        echo FAILED  >> $BACKUPFOLDER/backup_$X.log;
        echo FAILED
    fi
fi



# Deletion of teporary and old files


echo deleting temporary files...
echo deleting temporary files... >> $BACKUPFOLDER/backup_$X.log
if rm ${NAMES[*]};
    then
    echo success >> $BACKUPFOLDER/backup_$X.log;
    echo success
    else
    echo FAILED  >> $BACKUPFOLDER/backup_$X.log;
    echo FAILED
fi


if test $SUCCESS == "true"; then
    echo Deleting files older than $DAYS days...
    echo Deleting files older than $DAYS days... >> $BACKUPFOLDER/backup_$X.log
    DELETEDATE=$(date +%s -d "-$DAYS day")

    for FILE in $BACKUPFOLDER/*; do

        FILEDATE=$(stat -c%Y $FILE)

        if (($FILEDATE < $DELETEDATE)); then
            echo deleteing $FILE...;
            echo deleteing $FILE...; >> $BACKUPFOLDER/backup_$X.log
            if rm -rf $FILE; then
                echo success >> $BACKUPFOLDER/backup_$X.log;
                echo success
            else
                echo FAILED  >> $BACKUPFOLDER/backup_$X.log;
                echo FAILED
            fi
        fi
    done

    if test ${#MAIL_SUCCESS_TO[*]} -gt 0; then
        SUBJECT="SUCCESSFUL backup  on "$HOSTNAME" by "$USER"  at: "$X
        cat $BACKUPFOLDER/backup_$X.log | mail -s "$SUBJECT" ${MAIL_SUCCESS_TO[*]}
    fi



else
#backup fehlerhaft
#cat /backup/backup_2004_03_04_2047.log | mail -s "Backup failed" hendrik.hanff@googlemail.com
    if test ${#MAIL_FAILED_TO[*]} -gt 0; then
        SUBJECT="FAILED backup on "$HOSTNAME" by "$USER"  at: "$X
        cat $BACKUPFOLDER/backup_$X.log | mail -s "$SUBJECT" ${MAIL_FAILED_TO[*]}
    fi

fi
