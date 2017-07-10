#!/bin/bash

# Copyright 2008-2009 Bob Hepple
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# http://sourceforge.net/projects/process-getopt
# http://process-getopt.sourceforge.net
# http://bhepple.freeshell.org/oddmuse/wiki.cgi/process-getopt

# $Id: example-script,v 1.11 2009/04/10 22:11:22 bhepple Exp $

# A tutorial example for process-getopt 

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

    CD_func()     { [ "${1:-""}" ] && echo "$PROG: got a CD option"; }
    SLOT_func()   { [ "${1:-""}" ] && echo "$PROG: got a SLOT option = \"$2\""; }
    TOKEN_func()  { [ "${1:-""}" ] && echo "$PROG: got a TOKEN option = \"$2\""; }
    LONG_func()   { [ "${1:-""}" ] && echo "$PROG: got a LONG option"; }
    SILENT_func() { [ "${1:-""}" ] && echo "$PROG: got a SILENT option"; }

    # Now we define the options:
    add_opt CD "foobar" c "" cdrom
    add_opt SLOT "option that takes a value" s n slot number
    add_opt TOKEN "option that takes a value" t n token number
    add_opt LONG "a long option without a short one" "" "" "long"
    add_opt SILENT "" S # does not appear in help or man page
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
VERSION="1.2"
VERBOSE=""
ARGUMENTS="COMMANDS"
SHORT_DESC="Short one-liner for man page. "
USAGE="Longer description for the help page and as a starting point for the \
man page. Try running this with the --help or --print-man-page options."

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

# At this point, all the options have been processed and removed from
# the arg list. We can now process $@ as arguments to the program.

# MAIN PROCESSING
echo "Remaining args:"
for arg in "$@"; do echo "\"$arg\""; done

EXPR="echo $PROG operating on these: $@"
[ "$VERBOSE" ] && echo $EXPR
eval $EXPR

# function ask()
# {
#     echo -n "$@" '[y/n] ' ; read ans
#     case "$ans" in
#         y*|Y*) return 0 ;;
#         *) return 1 ;;
#     esac
# }


