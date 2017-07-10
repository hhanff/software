#!/bin/bash
-------------------------------------------------------------------------------
-- Title       : git-howto.txt
-- Project     : 
-- Library:    : 
-------------------------------------------------------------------------------
-- File name   : 
-- Author      : hhanff
-- Company     : 
-- Last update : 
-- Platform    : 
-------------------------------------------------------------------------------
-- Purpose     : Function: Removes unnecessary files in the
--               configuration repository
-------------------------------------------------------------------------------
-- Assumptions : 
-- Limitations :
-- Known Errors:
-- Notes       : 
-------------------------------------------------------------------------------
-- Revisions   :
-- Date        Version  Author          Description
-- 2010-02-19  1.0      Hendrik Hanff	Created
-------------------------------------------------------------------------------
# error on first failed command or unreferencing a undefined variable:
set -eu

check_and_process_opts() {
    export STOP_ON_FIRST_NON_OPT="yes"
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
VERSION="1.0"
VERBOSE="Hendrik Hanff"
ARGUMENTS="COMMANDS"
SHORT_DESC="This script will recursively remove unnecessary files in the repository\
"
USAGE="This script is used in project folders to recursively scan the repository directories for all unnecessary files and delete these.
It can be called without any arguments.
To do: -
      "

TMP="/tmp/tmp$$.tmp"
trap "/bin/rm -f $TMP" EXIT 

NEW_ARGS=( )
check_and_process_opts "$@" && {
    if [ ${#NEW_ARGS[@]} -gt 0 ]; then
        set -- "${NEW_ARGS[@]}"
    else
        set --
    fi
}

REMOVE_FOLDERS="*backup* *AU_OLD*"
REMOVE_FILES="*backup* *.BAK *.bak *.*~*"

for f in $REMOVE_FOLDERS; do
    TMP=$( find . -type d -name $f )
    if  [ -n "$TMP" ] ; then
	find . -type d -name $f
	read -n1 -p "Shall this/these folder/s be removed [y/n]? "
	[ "$REPLY" = "yY" ] || rm  -rf `find . -type d -name $f`
	echo 
    fi
done

for f in $REMOVE_FILES; do
    TMP=$( find . -type f -name $f )
    if  [ -n "$TMP" ] ; then
	find . -type f -name $f
	read -n1 -p "Shall this/these files/s be removed [y/n]? "
	[ "$REPLY" = "yY" ] || rm -rf `find . -type f -name $f`
	echo 
    fi
done

echo $0 "Finished"
