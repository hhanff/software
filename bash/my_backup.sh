#!/bin/bash
##-----------------------------------------------------------------------------
## Title       : my_backup
## Project     :
## Library:    :
##-----------------------------------------------------------------------------
## File name   : my_backup.sh
## Author      : hhanff
## Company     : DFKI
## Last update : 2010-05-04
## Platform    : lin
##-----------------------------------------------------------------------------
## Purpose     : Compress, encrypt and backup directories and files
##
##-----------------------------------------------------------------------------
## Assumptions :
## Limitations :
## Known Errors:
##-----------------------------------------------------------------------------
## Revisions   :
## Date        Version  Author          Description
## 2010-05-04  1.0      Hendrik Hanff	Created
##-----------------------------------------------------------------------------
# error on first failed command or unreferencing a undefined variable:
# set -eu
# set -x

HOME=~
REMOTE=/mnt/user/hanff
TMP_DIR=/tmp/backup.dir
EXCLUDE_FILE="/home/hhanff/Dropbox/src/scripts/my_backup.lst"

check_and_process_opts() {
    export STOP_ON_FIRST_NO
N_OPT="yes"
    local NO_OPTS TEMP PG

    # avoid the overhead of process-getopt if there are no options:
    NO_OPTS="yes"
    for i in "$@"; do
        case "$i" in
            -*)
                NO_OPTS=""
                break
                ;;
            *)
                [ "$STOP_ON_FIRST_NON_OPT" ] && break
                ;;
        esac
    done
    [ "$NO_OPTS" ] && return 1

    PG=$(type process-getopt |cut -d' ' -f 3)
    [ "$PG" ] || exit 1
    source $PG

    # These are the option helper functions that are called in response to
    # an option being found on the command line. They are called by
    # call_getopt with parameters set:
    # $1 = the option eg -c or --cdrom
    # $2 = any argument to the option, if present
    #
    # These helpers generally just set flags and store values
    #
    # Note that they are also called by add_opt (with no parameters)
    # to check for their existence, so make sure the are defined
    # _before_ calling add_opt:

    #CD_func()     { [ "${1:-""}" ] && echo "$PROG: got a CD option"; }
    #SLOT_func()   { [ "${1:-""}" ] && echo "$PROG: got a SLOT option = \"$2\""; }
    #TOKEN_func()  { [ "${1:-""}" ] && echo "$PROG: got a TOKEN option = \"$2\""; }
    #LONG_func()   { [ "${1:-""}" ] && echo "$PROG: got a LONG option"; }
    #SILENT_func() { [ "${1:-""}" ] && echo "$PROG: got a SILENT option"; }

    # Now we define the options:
    #add_opt CD "foobar" c "" cdrom
    #add_opt SLOT "option that takes a value" s n slot number
    #add_opt TOKEN "option that takes a value" t n token number
    #add_opt LONG "a long option without a short one" "" "" "long"
    #add_opt SILENT "" S # does not appear in help or man page
    # These would generate errors:
    # add_opt CD "foobar" c "" cdrom # re-use of option identifiers 'c/cdrom'
    # add_opt D "foobar" d "" delta # no D_func defined for this one
    # add_opt E-ffect "foobar" e # NAME must be [a-zA-Z0-9_]

    add_std_opts # define the standard options --help etc

    # delete any options we don't need:
    del_opt QUIET END_OPTIONS

    # process the command line, callback get called here:
    TEMP=$(call_getopt "$@") || exit 1
    eval set -- "$TEMP"
    process_opts "$@" || shift $?
    NEW_ARGS=( "$@" )
    return 0
}

##########################
#         M A I N        #
##########################
PROG=$(basename $0)
DIR=$(dirname $0)
VERSION="0.01"
VERBOSE="Hendrik Hanff"
ARGUMENTS="COMMANDS"
SHORT_DESC="This script compresses, encrypts and backups directories and files\
"
USAGE="This script is used in the FPGA department of the DFKI.
It can be called without any arguments.
To do: -
      "

NEW_ARGS=( )
check_and_process_opts "$@" && {
    if [ ${#NEW_ARGS[@]} -gt 0 ]; then
        set -- "${NEW_ARGS[@]}"
    else
        set --
    fi
}

#gpg --gen-key

if which process-getopt
then
    echo "process-getopt installed... continuing"
else
    echo "Error! process-getopt not installed. Please install it as described below:"
    echo "    cd /home/hhanff/Dropbox/bin/"
    echo "    wget http://downloads.sourceforge.net/project/process-getopt/process-getopt/1.6/process-getopt-1.6.tgz?use_mirror=kent"
    echo "    tar xvfz process-getopt-1.6.tgz"
    echo "    cd /usr/local/bin"
    echo "    sudo ln -s ~/Dropbox/bin/process-getopt-1.6/bin/process-getopt ."

exit
fi

echo "\nStarting backup"
cd $HOME
# # Clean up old files
# /bin/rm -rf $TMP_DIR /tmp/tar.log
# /bin/rm -rf ${HOME}/installed-software
# /bin/rm -rf ${HOME}/crontab_backup

# Capture some important information
# installed packages
sudo dpkg --get-selections > ${HOME}/installed-software
\ls -la | grep "\->" >> ${HOME}/symbolic_links
# my crontab
#crontab -l > ${HOME}/crontab_backup
rsync -a --delete --progress --exclude-from=$EXCLUDE_FILE /home/hhanff/ User/hanff/backup
# Backup project directories modified files
# Get all modified files in the svn directories and place a backup of the files in my User directory
mkdir ~/User/hanff/backup/svn_modified_files
mkdir ~/User/hanff/backup/svn_modified_files/FPGA_svn
cd proj/*FPGA*
svn status -u | grep -v ?  | grep "M " | grep -v " \* " | awk '{ print $3 }' | xargs -n 1 -P 8 -I% rsync -v -v --delete  --progress -a % $HOME/User/hanff/backup/svn_modified_files/FPGA_svn/
cd $HOME
mkdir User/hanff/backup/svn_modified_files/SeeGrip_svn
cd proj/*See*
svn status -u | grep -v ?  | grep "M " | grep -v " \* " | awk '{ print $3 }' | xargs -n 1 -P 8 -I% rsync -v -v --delete --progress -a % $HOME/User/hanff/backup/svn_modified_files/SeeGrip_svn/
cd $HOME

# # Create temporary backupdirectory
# # mkdir $TMP_DIR

# cp -r proj .* Downloads scratch $TMP_DIR
# echo "Files cached."

# cd /tmp
# # Files to be excluded from tar have to be added to my_backup.lst
# #tar -cvjf  home.tar.bz2 backup.dir -X$EXCLUDE_FILE >> /tmp/tar.log
# tar -cvjf  home.tar.bz2 backup.dir >> /tmp/tar.log
# echo "Files compressed."
# cd

# Clean up unneeded files
/bin/rm -rf ${HOME}/installed-software
/bin/rm -rf ${HOME}/crontab_backup
/bin/rm -rf ${HOME}/symbolic_links

# #sudo mount -a
# #encrypt
# openssl enc -aes-256-cbc -salt -in /tmp/home.tar.bz2 -out /tmp/home.enc
# echo "Encryption finished."
# #decrypt:
# #cd /mnt/use/hanff/backup && openssl enc -d -aes-256-cbc -salt -in home.enc -out home.tar.bz2
# #bunzip2 home.tar.bz2; tar xvf home.tar

# #remove
# /bin/rm -rf $TMP_DIR /tmp/home.tar.gz
# echo "Removing .tar.gz file finished."
# sudo mv  /tmp/home.enc /mnt/user/hanff/backup
# echo "Moving encrypted file to backup directory finished."
# /bin/rm -rf tar.log
echo $0 "\n********\nFinished\n********\n"
