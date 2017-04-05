#=================================================================
#
# PERSONAL $HOME/.bashrc FILE for bash-2.05a (or later)
#
# Last modified: Tue Apr 15 20:32:34 CEST 2003
#
# This file is read (normally) by interactive shells only.
# Here is the place to define your aliases, functions and
# other interactive features like your prompt.
#
# This file was designed (originallyfunc) for Solaris but based
# on Redhat's default .bashrc file
# --> Modified for Linux.
# The majority of the code you'll find here is based on code found
# on Usenet (or internet).
# This bashrc file is a bit overcrowded -- remember it is just
# just an example. Tailor it to your needs
#
#
#===============================================================
#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------
if [ -f /etc/bashrc ]; then
. /etc/bashrc # --> Read /etc/bashrc, if present.
fi
#-------------------------------------------------------------
# This works for linux - your mileage may vary....
# The problem is that different types of terminals give
# different answers to 'who am i'......
# I have not found a 'universal' method yet
#-------------------------------------------------------------
function get_xserver ()
{
    case $TERM in
       xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
            XSERVER=${XSERVER%%:*}
            ;;
        aterm | rxvt)
            ;;
    esac
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
        DISPLAY=":0.0"          # Display on local host.
    else
        DISPLAY=${XSERVER}:0.0 # Display on remote host
    fi
fi

export DISPLAY

source /etc/bash_completion

#if a command line is overwritten by itself instead of being scrolled to the right when a long command line is entered, create a file called ~/.inputrc with the following content:
#set horizontal-scroll-mode on
set -o notify
set -o noclobber
set -o ignoreeof
set -o nounset
#set -o xtrace        # Useful for debuging
set completion-ignore-case on


#set bell-style visible
#set prefer-visible-bell on

# Enable options:
#Enable suport of bash history across multiple bash sessions
#shopt -s histappend
export HISTFILESIZE=5000
#export HISTCONTROL=ignoredups

#shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
#shopt -s mailwarn
shopt -s sourcepath
shopt -s no_empty_cmd_completion  # bash>=2.04 only
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob      # Necessary for programmable completion
shopt -s autocd
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Disable options:
#shopt -u mailwarn
unset MAILCHECK       # I don't want my shell to warn me of incoming mail

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"
export HOSTFILE=$HOME/.hosts	# Put a list of remote hosts in ~/.hosts

#-----------------------
# Greeting, motd etc...
#-----------------------

# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
green='\e[0;32m'
GREEN='\e[1;32m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color

#---------------
# Shell Prompt
#---------------

#if [[ "${DISPLAY#$HOST}" != ":0.0" &&  "${DISPLAY}" != ":0" ]]; then
    HILIT=${red}   # remote machine: prompt will be partly red
    HILIT1=${red}   # remote machine: prompt will be partly red
#else
    HILIT2=${CYAN}  # local machine: prompt will be partly cyan
#fi

#  --> Replace instances of \W with \w in prompt functions below
#+ --> to get display of full path name.
    #  curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
    # echo "source ~/.git-prompt.sh" >> ~/.bash_profile; source ~/.bash_profile
function fastprompt() {
   case $TERM in
        *xterm | rxvt | eterm-*)
             #
             export PROMPT_COMMAND=""
             PS1='\[\e[1;37m\]\[\e[1;36m\][\u@\h]\[\e[0;39m\]\[\e[1;31m\][\W]\[\e[0;39m\]\[\e[1;32m\]$(__git_ps1 "[%s]")\[\e[0;39m\] \[\e[1;37m\]\[\e[0;39m\]';;
        linux )
             PS1="\[${HILIT2}\][\u@\h]\[${RED}\][\W]\[${NC}\] " ;;
        *)
             PS1='\[\e[1;37m\]\[\e[1;36m\][\u@\h]\[\e[0;39m\]\[\e[1;31m\][\W]\[\e[0;39m\]\[\e[1;32m\]$(__git_ps1 "[%s]")\[\e[0;39m\] \[\e[1;37m\]\[\e[0;39m\]'
             # Set bash title bar to pwd output
             # set_title='\[\e]0;\u@\h: \w\a\]';;
             # export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    esac

}
fastprompt



#===============================================================
# ALIASES AND FUNCTIONS
#===============================================================

#-------------------------------------------------------------
# Personal Funtions
#-------------------------------------------------------------
function cpstat()
{
      local pid="${1:-$(pgrep -xn cp)}" src dst
  [[ "$pid" ]] || return
  while [[ -f "/proc/$pid/fd/3" ]]; do
    read src dst < <(stat -L --printf '%s ' "/proc/$pid/fd/"{3,4})
    (( src )) || break
    printf 'cp %d%%\r' $((dst*100/src))
    sleep 1
  done
  echo

}
# Set focus to a window after the command execution has finished
function focus() {
  winID=`xprop -root |awk '/_NET_ACTIVE_WINDOW/ {print $5; exit;}'`
  $@;
  #wmctrl -a -i $winID;
  wmctrl -a 'sim';

}

function my_find_hosts_on_network (){
    #IP=(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}');
    IP=$(ip add show $1 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}');
    nmap  -sn $IP;
}

function my_info () {
    echo /etc/*_ver* /etc/*-rel*; cat /etc/*_ver* /etc/*-rel*
}

function my_ssh_dfki () {
  ssh hhanff@ricssh.hb.dfki.de -p 22222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -L 13021:hhanff-u.local:22 -f sleep 10 && \
  ssh localhost -p 13021 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -XC
}

function my_update(){
  sudo apt-get update && \
  sudo apt-get upgrade && \
  sudo apt-get dist-upgrade && \
  sudo apt-get autoremove && \
  sudo apt-get clean && \
  sudo apt-get autoclean
}

function my_scan_ocr(){
  /bin/rm -rf /tmp/scan_ocr.p*
  /bin/rm -rf /tmp/scan_ocr.tiff
  /bin/rm -rf /tmp/out.html
  /bin/rm -rf ./scan_ocr.p*
  #/bin/rm -rf /tmp/scan_ocr.tiff
  # scanimage -d epson2  --resolution=600 > /tmp/scan_ocr.tiff
  # scanimage -d epson2 --resolution=300 -p > /tmp/scan_ocr.pnm
  scanimage -d epson2 -x 215 -y 297 --resolution=300 -l 0 -t 0 --mode color -p > /tmp/scan_ocr.pnm
  tesseract /tmp/scan_ocr.pnm  /tmp/scan_ocr -l deu hocr
  #sudo apt-get install exactimage
  hocr2pdf -i /tmp/scan_ocr.pnm -o scan_ocr.pdf < /tmp/scan_ocr.html
#  pnmtops /tmp/scan_ocr.pnm > /tmp/scan_ocr.ps
#  ps2pdf /tmp/scan_ocr.ps
}

function my_scan_hq(){
  /bin/rm -rf /tmp/scan_hq.p*
  /bin/rm -rf ./scan_hq.p*
  scanimage -d epson2  -x 215 -y 297 -l 0 -t 0 --resolution=600 -p > /tmp/scan_hq.pnm
  #scanimage -d epson2  --resolution=600 --mode color -p > /tmp/scan_hq.pnm
  pnmtops /tmp/scan_hq.pnm > /tmp/scan_hq.ps
  ps2pdf /tmp/scan_hq.ps
 # mv /tmp/scan_hq.pdf scan_hq2.pdf
}
function my_scan_lq(){
    /bin/rm -rf /tmp/scan_lq.p*
    /bin/rm -rf ./scan_lq.p*
    scanimage -d epson2 -x 215 -y 297 -l 0 -t 0 --resolution=300 -p > /tmp/scan_lq.pnm
    #scanimage -d epson2  --resolution=600 --mode color -p > /tmp/scan_lq.pnm
    pnmtops /tmp/scan_lq.pnm > /tmp/scan_lq.ps
    pnmtopng /tmp/scan_lq.pnm > ./scan_lq.png
    ps2pdf /tmp/scan_lq.ps
#    mv /tmp/scan_lq.pdf .
}
function my_can_up()
{
#  sudo /sbin/ip link set can0 up type can bitrate 500000 restart-ms 2000
  sudo /sbin/ip link set can0 up type can bitrate 1000000 restart-ms 2000
}

function my_can_down()
{
  sudo /sbin/ip link set can0 down
}

function my_sshfs()
{
  echo "Eine Dateisystem via ssh einbinden::"
  echo "sshfs -o ssh_command='"'ssh -i ~/.ssh/id_dsa.pub'"' spielmeyerhanff.dyndns.org:/home/hhanff/sda1/backup/home/hhanff/ /mnt/sshfs"
  echo ""
  echo "Aushängen erfolgt mit umount"
}

function my_scp()
{
  echo "Eine Datei nach Host kopieren:"
  echo "scp VHDL.tgz hhanff@spielmeyerhanff.dyndns.org:/home/hhanff/sda1/backup/home/hhanff/ebooks/"
  echo ""
  echo "Eine Datei von Host kopieren:"
  echo "scp root@spielmeyerhanff.dyndns.org:/home/hhanff/sda1/backup/home/hhanff/ebooks/VHDL.tgz /home/DFKI/hhanff/ebooks/"
}

function my_tgz()
{
tar -czvf $1.tgz $1
}

function cg()
  {
    rsync -rv $1 $2 --progress
    echo Done
  }



function svndiff () { svn diff  -x -wp $@ | cdiff |less -R; }

#Open a file in the current running emacs
function ec
{
  emacsclient --no-wait "$@"
}
# The eco function requires a ecns bash script in /usr/bin containing the
# following two lines:
# sudo su echo '#!/bin/bash' > /usr/bin/ecns echo 'emacs
# -nw -fs --no-desktop -q -l ~/.emacs_eco.el "$1";' >> /usr/bin/ecns chmod a+x
# /usr/bin/ecns
function eco { emacsclient  -nw -c  -a "ecns" $1; }

function _exit()	# function to run upon exit of shell
{
    echo -e "${RED}Hasta la vista, baby!!!${NC}"
}
trap _exit EXIT

function ll()
{ ls -l "$@"| egrep "^d" ; ls -lXB "$@" 2>&-| egrep -v "^d|total "; }

#-------------------------------------------------------------
# find pattern in a set of files and highlight them:
function rgrep(){
find . \( -path \*/SCCS -o -path \*/RCS -o -path \*/CVS -o -path \*/MCVS -o -path \*/.svn -o -path \*/.git -o -path \*/.hg -o -path \*/.bzr -o -path \*/_MTN -o -path \*/_darcs -o -path \*/\{arch\} \) -prune -o  -type f \( -name \*.c \) -print0 | xargs -0 -e grep  -nH -e $1
}

# This function updated my TAGS file inside the proj folder
function my_update_tags()
{
#     cd ~/proj;
#     # Update tags for vhdl files
#     find ~/proj \( -path \*/FPGA \) -prune -o -name "*.vhd"
# -print0 | xargs -0 ctags -Re --language=none  --regex='/[ \t]*\(architecture\|configuration\) +[^ ]* +OF/'   --regex='/[ \t]*\(attribute\|entity\|function\|signal\|constant\|package\( body\)?\|procedure\|process\|type\)[ \t]+\([^\t(]+\)/\3/' --output=TAGS;
#     # Update tags for c/cpp and header files
#     find ~/proj \( -path \*/  \) -prune -o \( -name "*.c" -o -name
#	    "*.cpp"  -o -name "*.h" \) -print0  | xargs -0 ctags -Re --append  --output=TAGS;

#     cd -;
    find . | grep ".*\.\(hh\|hxx\|cc\|cpp\|h\|hpp\|c\)" | xargs etags -f TAGS
}

# Find a file with a pattern in name:
# This is replaced by ack.
# function ff(){ find . -type f -iname '*'$*'*' -ls ; }
# Find a file with pattern $1 in name and Execute $2 on it:

# function fe()
# { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }
# function fstr()
# {
#     OPTIND=1
#     local ignore_string=""
#     local usage="fstr: find string in files. Usage: fstr [-iI] \"pattern\" [\"filename pattern\"] "
#     while getopts :iI opt
#     do
#         case "$opt" in
#             i) ignore_string="-i " ;;
#	    I) ignore_binary="-I " ;;
#             *) echo "$usage"; return;;
#         esac
#     done
#     shift $(( $OPTIND - 1 ))
#     if [ "$#" -lt 1 ]; then
#         echo "$usage"
#         return;
#     fi
#     #local SMSO=$(tput smso)
#     #local RMSO=$(tput rmso)

#     find .  -type f -name "${2:-*}" -print0 | xargs -0 grep --color=auto -snH ${ignore_string} ${ignore_binary} "$1" 2>&- | sed "s/$1/${SMSO}\0${RMSO}/gI" | more | grep -v rdatei | grep -v TAGS | grep -v "\.svn" | grep -v "\.ncd"
# }


function ff(){\
    # Find files and find directories
    find . -type f -iname '*'$*'*';\
    find . -type d -iname '*'$*'*';
    #alias ff='ack -g'
}

# If the error "/dev/null: cannot overwrite existing file" occurs:
# > sudo su
# > rm /dev/null
# > mknod /dev/null c 1 3
# > chmod 666 /dev/null

function fstr_install {\
    # sudo apt-get install silversearcher-ag
    # If the error "/dev/null: cannot overwrite existing file" occurs:
    # > sudo su
    # > rm /dev/null
    # > mknod /dev/null c 1 3
    # > chmod 666 /dev/null
    if which ag >/dev/null; then
      alias fstr='ag --skip-vcs-ignores --unrestricted -i --stats  --hidden --depth 255'
    else
      alias  fstr='find . -type d \( -path \*/SCCS -o -path \*/RCS -o -path \*/CVS -o -path \*/MCVS -o -path \*/.svn -o -path \*/.git -o -path \*/.hg -o -path \*/.bzr -o -path \*/_MTN -o -path \*/_darcs -o -path \*/\{arch\} \) -prune -o \! -type d \( -name .\#\* -o -name \*.o -o -name \*\~ -o -name \*.bin -o -name \*.lbin -o -name \*.so -o -name \*.a -o -name \*.ln -o -name \*.blg -o -name \*.bbl -o -name \*.elc -o -name \*.lof -o -name \*.glo -o -name \*.idx -o -name \*.lot -o -name \*.fmt -o -name \*.tfm -o -name \*.class -o -name \*.fas -o -name \*.lib -o -name \*.mem -o -name \*.x86f -o -name \*.sparcf -o -name \*.dfsl -o -name \*.pfsl -o -name \*.d64fsl -o -name \*.p64fsl -o -name \*.lx64fsl -o -name \*.lx32fsl -o -name \*.dx64fsl -o -name \*.dx32fsl -o -name \*.fx64fsl -o -name \*.fx32fsl -o -name \*.sx64fsl -o -name \*.sx32fsl -o -name \*.wx64fsl -o -name \*.wx32fsl -o -name \*.fasl -o -name \*.ufsl -o -name \*.fsl -o -name \*.dxl -o -name \*.lo -o -name \*.la -o -name \*.gmo -o -name \*.mo -o -name \*.toc -o -name \*.aux -o -name \*.cp -o -name \*.fn -o -name \*.ky -o -name \*.pg -o -name \*.tp -o -name \*.vr -o -name \*.cps -o -name \*.fns -o -name \*.kys -o -name \*.pgs -o -name \*.tps -o -name \*.vrs -o -name \*.pyc -o -name \*.pyo \) -prune -o  -type f \( -name \*.cc -o -name \*.cxx -o -name \*.cpp -o -name \*.C -o -name \*.CC -o -name \*.c\+\+ \) -exec grep  -nH -e mpUi-\>speedInput {} +'
    fi
}
fstr_install;

function extract() # Handy Extract Program.
{
    if [ -f $1 ] ; then
	case $1 in
	    *.tar.bz2) tar xvjf $1 ;;
	    *.tar.gz) tar xvzf $1 ;;
	    *.bz2) bunzip2 $1 ;;
	    *.rar) unrar x $1 ;;
	    *.gz) gunzip $1 ;;
	    *.tar) tar xvf $1 ;;
	    *.tbz2) tar xvjf $1 ;;
	    *.tgz) tar xvzf $1 ;;
	    *.zip) unzip $1 ;;
	    *.Z) uncompress $1 ;;
	    *.7z) 7z x $1 ;;
	    *.tar.xz)  tar -xJf $1 ;;
	    *) echo "'$1' cannot be extracted via >extract<" ;;
	esac
    else
	echo "'$1' is not a valid file"
    fi
}

# ARCHIVE COMPRESS {{{
compress() {
    if [[ -n "$1" ]]; then
	FILE=$1
	case $FILE in
	    *.tar ) shift && tar cf $FILE $* ;;
	    *.tar.bz2 ) shift && tar cjf $FILE $* ;;
	    *.tar.gz ) shift && tar czf $FILE $* ;;
	    *.tgz ) shift && tar czf $FILE $* ;;
	    *.zip ) shift && zip $FILE $* ;;
	    *.rar ) shift && rar $FILE $* ;;
	esac
    else
	echo "usage: compress <foo.tar.gz> ./foo ./bar"
    fi
}

#-------------------------------------------------------------
# Process/system related functions:
#-----------------------------------

#Display process tree
function pp()
{ my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function my_ip() # Get IP adresses.
{
MY_IP=$(/sbin/ifconfig eth1 | awk '/inet Adresse/ { print $2 } ' | sed -e s/Adresse://)
MY_ISP=$(/sbin/ifconfig eth1 | awk '/P-t-P/ { print $3 } ' | sed -e s/P-t-P://)
}

function my_info()   # get current host related info
{
  echo -e "\nYou are logged on ${RED}$HOST"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo -e "\n${RED}Memory stats :$NC " ; free -h
  echo -e "\n${RED}Local IP Address :$NC" ; ifconfig 2>&-
  echo -e "\n${RED}Linux Version :$NC" ; cat /etc/*release
  echo -e "\n${RED}Battery Level : $NC" ; acpi -b
  echo -e "\n${RED}Debian Version : $NC"; cat /etc/debian_version ;
  echo
}


function my_wlan_off()
{
    sudo iwconfig wlan0 txpower off
}

function my_wlan_on()
{
    sudo iwconfig wlan0 txpower on
}

function comic()
{
    eog `wget -O - http://xkcd.com/ | grep 'png' | grep '<img src="http://imgs.xkcd.com/comics/' | sed s/title=\".*//g | sed 's/.png\"/.png/g' | sed 's/<img src=\"//g'`;
}

# To get both functions working please read doc/init/Linux-Unix/ssmtp/ssmtp_howto.txt
function quickmail_work() {
	echo "$*" | mail -s "$*" hendrik.hanff@dfki.de;
}
function quickmail_home() {
	echo "$*" | mail -s "$*" hendrik.hanff@googlemail.com;
}
#-------------------
# Personnal Aliases
#---------------------
alias TRANSTERRA='pushd /mnt/research/projects/ongoing/TransTerrA_15004/'
alias DAEDALUS='pushd /mnt/research/projects/ongoing/DAEDALUS_15078/'
alias LIMES='pushd /mnt/research/projects/ongoing/LIMES/'
alias SDSO='pushd /mnt/research/projects/ongoing/EIT-SDSO_18883'

# Create backup with date
bu() {
    # Remove trailing backslash from folders to overcome tar error: file changed as we read it
    TARGET=${@%/}
    cp -R $TARGET "$TARGET".backup-`date +%y%m%d`;
}
# Create a local back up and delete file/folder
bud() {
    # Remove trailing backslash from folders to overcome tar error: file changed as we read it
    TARGET=${@%/}
    mv $TARGET "$TARGET".backup-`date +%y%m%d`;
}
# Create backup with date and compress
buz ()
{
    # Remove trailing backslash from folders to overcome tar error: file changed as we read it
    TARGET=${@%/}
    \rm -rf /tmp/$TARGET /tmp/$TARGET.backup*;
    echo "Copying $TARGET to /tmp...";
    cp -i -R $TARGET /tmp;
    cd /tmp;
    echo "Compressing...";
    tar cvfz $TARGET.backup-`date +%y%m%d`.tar.gz $TARGET;
    cd -;
    echo "Moving result..."
    mv /tmp/$TARGET*.tar.gz .
}
# Create backup with date, compress it and delete the original folder
buzd ()
{
    # Remove trailing backslash from folders to overcome tar error: file changed as we read it
    TARGET=${@%/}
    \rm -rf /tmp/$TARGET /tmp/$TARGET.backup*;
    echo "Moving $TARGET to /tmp...";
    mv $TARGET /tmp;
    cd /tmp;
    echo "Compressing...";
    tar cvfz $TARGET.backup-`date +%y%m%d`.tar.gz $TARGET;
    cd -;
    echo "Moving result..."
    mv /tmp/$TARGET*.tar.gz .
}

alias pud="pushd"
alias pd="pushd"
alias pod="popd"
alias rsync="rsync -rv --progress"
alias my_stat="export LC_CTYPE=en_US.UTF-8; svn status -u | grep -v "\?""
function my_commit {
    DIR='\pwd'
    DIR_NEW=${PWD#$HOME/Projekte}
    LOG_MESSAGE="['$DIR_NEW']'$2'\n'$3"
    svn commit $1 --force-log -m $'\['$DIR_NEW']'$2' \n '$3''
}
alias wget="wget -k -E -l 8 --exclude-domains=del.icio.us,doubleclick.net"
alias diffuse='/usr/bin/diffuse -i -E -b -B -w '

alias ttyUSB0='sudo minicom -o ttyUSB0'
alias ttyUSB1='sudo minicom -o ttyUSB1'
alias ttyUSB2='sudo minicom -o ttyUSB2'
alias ttyS0='sudo minicom -o ttyS0'
alias ttyS1='sudo minicom -o ttyS1'

alias dush="du -xsm .[!.]* *  | sort -n | awk '{ printf(\"%4s MB ./\",\$1) ; for (i=1;i<=NF;i++) { if (i>1) printf(\"%s \",\$i) } ; printf(\"\n\") }' | tail "
alias rmsvn='find . -type d -name '*.svn*' -print0 | xargs -0 rm -rdf && la -R | grep svn'

alias m="rm -rf /tmp/playlist.tmp &&  find ~/mp3  -name *.mp3 -not -name 'Hörbücher' > /tmp/playlist.tmp && mplayer -playlist /tmp/playlist.tmp -shuffle -loop 0 | grep Playing"

alias my_backup="~/Dropbox/src/scripts/my_backup.sh"

alias top='htop'
alias my_vpn='sudo openvpn ~/Dokumente/Privat/Certificates/hhanff@hhanff.spdns.org.opvn '
alias my_vpn_work='sudo openconnect -b -u heha01 --authgroup=Anyconnect-MyDFKI --no-cert-check vpn.hb.dfki.de'

# First test if we are in an interactive session to overcome bind errors
iatest=$(expr index "$-" i)
# Then do the actual bind
if [[ $iatest > 0 ]]; then bind '"…":"pushd ..\n"'; fi # AltGr .
if [[ $iatest > 0 ]]; then bind '"÷":"popd\n"'; fi #  # AltGr Shift .

# Don't remove files immediately. Move them to /tmp/trash instead. They will
# be kept until the next reboot.
# hhanff
function del () {
    if [[ -z "$*" ]] ; then
	echo "Usage: del FILE_NAME "
    else
	# Test if /tmp/trash exists and proceed with deleting files if it
	# exists. If it does not exist, e.g. after a restart, create the
	# directory and proceed.
	if [ -d /tmp/trash ]
	then
	    echo "/tmp/trash exists. Proceeding." > /dev/null
	else
	    mkdir /tmp/trash
	fi

	# TBD: Do not move every file separately, but
	# mv all files at once... don't know how...
	while [ $# -ne 0 ]
	do
	    # Files will be prescedet with a timestamp.
	    # basetime=$(date "+%FT%T")
	    # basetime=$(date +%s%N)
	    basetime=$(date "+%Y%m%dT%H%M%S")
	    # Make whitespaces underscores
	    TRIMMED_1=`echo "$1" | sed 's/ /_/g'`
	    TRIMMED_2=$(basename $TRIMMED_1)
	    # Move files to /tmp/trash
	    mv "$1" /tmp/trash/"$basetime"-"$TRIMMED_2";
	    shift
	done
    fi
}

function my_tea_timer { sleep $1 && xmessage -center "Tea is ready!"; }

function my_ccleaner { sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"; }

function my_flash_pro_express {
    /usr/local/microsemi/Program_DebugV11.8/Program_Debug/bin/FPExpress &
}

function my_actel { \
   # Prerequisites: ##
   # cd /etc/init.d
   # sudo ln -s ~/Projekte/Software/scripts/flexlm .
   # cd /etc/rc5.d
   # ln -s ../init.d/flexlm S98flexlm
   # ln -s ../init.d/flexlm K98flexlm

   # https://help.ubuntu.com/community/LiberoSOC
   # sudo apt-get install libmotif3 libmotif-dev libmotif4:i386 nspluginwrapper lib32z1 libc6-i386 rpcbind xfonts-100dpi xfonts-75dpi ksh lsb


   # Obtain a flelmx gold license from Microsemi
   # > mv ~/Downloads/License.dat /opt/Linux_Licensing_Daemon/flexlm/
   # Change the header of License.dat matching your system.

   # For programming ensure that
   # > sudo cat /etc/udev/rules.d/70-microsemi.rules
   # SUBSYSTEM=="usb",ATTRS{idProduct}=="2008",ATTRS{idVendor}=="1514",MODE="0660 ",GROUP="plugdev",SYMLINK+="FlashPro5"
   # SUBSYSTEM=="usb",ATTRS{idProduct}=="6001",ATTRS{idVendor}=="0403",MODE="0660",GROUP="plugdev",SYMLINK+="FTDI232"
   unset LC_TIME
   unset LC_NUMERIC
   unset LC_CTYPE
   export LANG=en_US.ISO8859-1

   # export LANG=de_DE.UTF-8
   # export LOCALE=C
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/i386-linux-gnu/
   export FLASHPRO_DIR=/opt/Actel/Program_DebugV11.7
   export PATH=$FLASHPRO_DIR/FlashPro/bin:$PATH;
   # FPExpress &

   export LOCALE=C
   #export LD_LIBRARY_PATH=/opt/Actel/Libero_v11.7/
   LIBERO_INSTALLED_DIR=/opt/Actel/Libero_v11.7/; export LIBERO_INSTALLED_DIR

   PATH=$LIBERO_INSTALLED_DIR/Libero/bin:$PATH;
   PATH=$LIBERO_INSTALLED_DIR/Synplify/bin:$PATH;
   PATH=$LIBERO_INSTALLED_DIR/Model/modeltech/linuxacoem:$PATH; export PATH

   export LM_LICENSE_FILE=1702@$HOSTNAME:$LM_LICENSE_FILE
   export SNPSLMD_LICENSE_FILE=1702@$HOSTNAME:$SNPSLMD_LICENSE_FILE
   export DISPLAY=:0


   TEST=`ps ax |grep lmgrd |grep -v grep`

   echo $TEST

   if [ "$TEST" == "" ]; then
       echo "Starting license daemons."
       /opt/Linux_Licensing_Daemon/lmgrd -c   /opt/Linux_Licensing_Daemon/flexlm/License.dat /opt/Linux_Licensing_Daemon/license.log
   else
       echo "License daemons already running."
   fi

   libero &

}

function my_ise { \
    xilinx_set_preconditions; \
    source "/opt/Xilinx/"$1"/ISE_DS/settings64.sh"; \
    "/opt/Xilinx/"$1"/ISE_DS/ISE/bin/lin64/ise"; }

function xilinx_set_preconditions { \
    # export XILINX=/mnt/daten/opt/Xilinx/10.1/ISE/
    # export PATH=/mnt/daten/opt/Xilinx/10.1/ISE/bin/lin:$PATH
    export GDM_LANG=C \
    export LANG=C \
    # export LD_PRELOAD=/usr/lib/ure/lib/libusb-driver.so
    export XILINXD_LICENSE_FILE=2100@rlb-lic.dfki.uni-bremen.de;}

function my_ise { \
    xilinx_set_preconditions; \
    source "/opt/Xilinx/"$1"/ISE_DS/settings64.sh"; \
    "/opt/Xilinx/"$1"/ISE_DS/ISE/bin/lin64/ise"; }

function my_plan_ahead { \
    xilinx_set_preconditions; \
    source "/opt/Xilinx/"$1"/ISE_DS/settings64.sh"; \
    "/opt/Xilinx/"$1"/ISE_DS/PlanAhead/bin/planAhead"; }

function my_vivado { \
    xilinx_set_preconditions; \
    cd /opt/Xilinx/"$1"/Vivado/"$1"/; \
    #source ./settings32.sh;
    ./bin/vivado & \
    cd -;}

function my_unset_variables {
    if [ -n $XILINXD_LICENSE_FILE]; then
	unset XILINXD_LICENSE_FILE;
	echo "unset XILINXD_LICENSE_FILE"
    fi

    if [ -n $XILINX_DSP ]; then
	unset XILINX_DSP;
	echo "unset XILINX_DSP"
    fi
    if [ -n $LD_LIBRARY_PATH ]; then
	unset LD_LIBRARY_PATH;
	echo "unset LD_LIBRARY_PATH"
    fi
    if [ -n $XILINX_EDK ]; then
	unset XILINX_EDK;
	echo "unset XILINX_EDK"
    fi
    if [ -n $LMC_HOME ]; then
	unset LMC_HOME;
	echo "unset LMC_HOME"
    fi
    if [ -n $XILINX_PLANAHEAD ]; then
	unset XILINX_PLANAHEAD;
	echo "unset XILINX_PLANAHEAD"
    fi
    if [ -n $XILINX ]; then
	unset XILINX
	echo "unset XILINX"
    fi
}

function my_timestamp_converter { \
    echo "Please enter UNIX epoch in hex values:";
    read TIMESTAMP;
    echo $((0x$TIMESTAMP))|awk '{print strftime("%c",$1)}';
}

function my_test_ack_installed {\
    if which ack-grep >/dev/null; then
      echo "ack exists"  >/dev/null
    else
      echo "Please provide sudo password to install missing tool ack-grep"
      sudo apt-get install ack-grep;
    fi
}
my_test_ack_installed;

function my_generate_passwd { \
 cat /dev/urandom| tr -dc 'a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?=' | fold -w 12 | head -n 4
 read TRASH;
 printf "\033c"
}

# When using sudo, use alias expansion (otherwise sudo ignores your aliases)
# This is for making la, lk... visible for sudo
alias sudo='sudo '

# Radio über die Konsole
alias dlf='/usr/bin/mplayer -nocache -audiofile-cache 64 -prefer-ipv4 $(GET http://www.dradio.de/streaming/dlf.m3u|head -1)'
alias dlr='/usr/bin/mplayer -nocache -audiofile-cache 64 -prefer-ipv4 $(GET http://www.dradio.de/streaming/dkultur.m3u|head -1)'
alias nw='/usr/bin/mplayer -nocache -audiofile-cache 64 -prefer-ipv4 -playlist "http://httpmedia.radiobremen.de/nordwestradio.m3u" '
alias byte='/usr/bin/mplayer -nocache -audiofile-cache 64 -prefer-ipv4 -playlist "http://www.byte.fm/stream/bytefm.m3u"'
alias sv='/usr/bin/mplayer -nocache -audiofile-cache 64 -playlist "http://sverigesradio.se/topsy/direkt/132-hi-mp3.m3u"'
alias flux='/usr/bin/mplayer -nocache -audiofile-cache 64 -prefer-ipv4 $(GET http://www.fluxfm.de/wp-content/themes/motorfm/fluxfm.m3u |head -1)'

alias rm='echo "Use del instead!"'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias h='history'
alias which='type -all'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias path='echo -e ${PATH//:/\\n}'
alias print='/usr/bin/lp -o nobanner -d $LPDEST'
      # Assumes LPDEST is defined
alias pjet='enscript -h -G -fCourier9 -d $LPDEST'
      # Pretty-print using enscript
alias background='xv -root -quit -max -rmode 5'
      # Put a picture in the background

alias du='du -kh'
alias df='df -kTh'

alias multi='sudo multitail /var/log/syslog -R 2 -c -l "dmesg -T" /var/log/kern.log -R 2 -c -l "df -h"'

alias dmesg='dmesg -T'

# The 'ls' family (this assumes you use the GNU ls)
alias la='ls -Al --time-style=long-iso'               # show hidden files
alias ls='ls -hF --color'	# add colors for filetype recognition
alias lx='ls -lXB'              # sort by extension
alias lk='ls -lSr'              # sort by size
alias lc='ls -lcr'		# sort by change time
alias lu='ls -lur'		# sort by access time
alias lr='ls -lR'               # recursive ls
alias lt='ls -ltr'              # sort by date
alias ll='ls -l'                # long information
alias lm='ls -al |more'         # pipe through 'more'
alias tree='tree -CsuhD'		# nice alternative to 'ls'
alias l='la'

alias gl='git log --graph --pretty="format:%C(yellow)%h%Cgreen%d%Creset %s %C(cyan) %an , %Cred%ar%Creset"'

# Find a file with a pattern in name:
alias grep='grep --color=auto'

#alias more='less'
export PAGER='less'
export LESSCHARSET='latin1'

# Copy path to clipboard, paste with middle mouse button
alias pwd='pwd | xsel && pwd'

alias o='xdg-open'

iso-8859-1()
{
    # Diese Funktion wurde für die LIMES WP Docunebtation eingefügt.
    # Manchmal ist eine Datei so zerschossen, dass man den Konflikt händisch
    # mit diffuse auflösen muss. Manchmal hilft es aber auch mit iconv zu
    # arbeiten.
    iconv  -f UTF8 -t ISO-8859-1 $1>$1.iso-8859-1
}

# Auto completion stuff
shopt -s extglob        # necessary
set +o nounset          # otherwise some completions will fail

complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # currently same as builtins
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir
complete -A directory   -o default cd

# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
# Postscript,pdf,dvi.....
complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.pdf' evince acroread pdf2ps
complete -f -o default -X '!*.+(pdf|ps)' gv
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
# Multimedia
complete -f -o default -X '!*.+(jp*g|gif|xpm|png|bmp)' evince xv gimp
complete -f -o default -X '!*.+(mp3|MP3)' mplayer mpg123 mpg321
complete -f -o default -X '!*.+(ogg|OGG)' mplayer ogg123
# Other
complete -f -o default -X '!*.pl'  perl perl5
complete -o default -F _longopts_func configure bash
complete -o default -F _longopts_func wget id info a2ps ls recode
complete -F _make_targets -X '+($*|*.[cho])' make gmake pmake



# This is a 'universal' completion function - it works when commands have
# a so-called 'long options' mode , ie: 'ls --all' instead of 'ls -a'

_get_longopts ()
{
    $1 --help | sed  -e '/--/!d' -e 's/.*--\([^[:space:].,]*\).*/--\1/'| \
grep ^"$2" |sort -u ;
}

_longopts_func ()
{
    case "${2:-*}" in
	-*)	;;
	*)	return ;;
    esac

    case "$1" in
	\~*)	eval cmd="$1" ;;
	*)	cmd="$1" ;;
    esac
    COMPREPLY=( $(_get_longopts ${1} ${2} ) )
}

# Use bash-completion, if available
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Local Variables:
PLATFORM=lin

# PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#PROMPT_COMMAND='echo -ne "\033]0;${PWD/$HOME/~}\007"
#export PROMPT_COMMAND="history -a;history -r;$PROMPT_COMMAND"'

#---------------
# Path
#---------------
export FIGNORE=.svn
#export SVN_EDITOR="/usr/bin/nano -r 79"
export SVN_EDITOR='emacsclient -nw -c -a "ecns" $1'
export GIT_EDITOR='emacsclient -nw -c -a "ecns" $1'
export SYSTEMC="/usr/local/systemc-2.2"
#export VIMRUNTIME=~/.vimruntime


# JAVA_HOME="/usr/java/jre1.6.0_29"
# export JAVA_HOME
#export XILINXD_LICENSE_FILE=/opt/FLEXlm/xilinx.lic <-- This is the location of your license file. you should have put this file in this place before

# icecc and ccache related variables
# sudo apt-get install icecc
# sudo nano /etc/icecc/icecc.conf # ICECC_MAX_JOBS="4"
# sudo service iceccd restart
# icemon # Interessehalber den icecc Monitor starten
# Für die Anzahl der parallelen Aufträge kann die Faustregel "Anzahl der
# logischen Prozessoren mal 2" verwendet werden,  jedoch können Zahlen größer 15
# zu Problem führen. Im Falle von make sieht dies z.B. so aus:
# make -j15
# sudo  mkdir -p /opt/ccache/bin
# sudo  ln -s /usr/bin/ccache /opt/ccache/bin/g++
# sudo  ln -s /usr/bin/ccache /opt/ccache/bin/gcc
# Den folgenden Befehl ausführen wenn bei icemon keine Jobs rausgehen.
# cd; icecc --build-native
# Die Datei noch in icemon-build-native.tar.gz umbenennen.

 export CXX='/usr/lib/ccache/g++'
 export CC='/usr/lib/ccache/gcc'
 export CCACHE_PREFIX=icecc
 # # If the following archive is missing:
 # icecc --build-native
 # mv ~/9f91d6f187bd1ffeb1b6f7965a37c14f.tar.gz ~/icemon-build-native.tar.gz
 export ICECC_VERSION=~/icemon-build-native.tar.gz
 export PATH=/usr/lib/icecc/bin:$PATH
 #iceccd -d

QWT_ROOT=/usr/local/qwt-6.1.0/
QT_PLUGIN_PATH="${QWT_ROOT}/plugins:$QT_PLUGIN_PATH"
export QT_PLUGIN_PATH
QMAKEFEATURES="${QWT_ROOT}/features:$QTMAKEFEATURES"
export QMAKEFEATURES

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qwt-6.1.0/lib/
#-------------------------------
# New / Experimental
#-------------------------------

#-------------------------------
# Probably not needed
#-------------------------------

export PYTHONPATH="$PYTHONPATH:$HOME/.python"
# do ln -s $PWD ~/.python/ to add the current directory to your $PYTHONPATH
export PERL_LOCAL_LIB_ROOT="/home/hhanff/perl5";
export PERL_MB_OPT="--install_base /home/hhanff/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/hhanff/perl5";
export PERL5LIB="/home/hhanff/perl5/lib/perl5/i686-linux-gnu-thread-multi-64int:/home/hhanff/perl5/lib/perl5";

# To overcome the error
# svn: Can't convert string from 'UTF-8' to native encoding:
# while doing an svn up:
# export LC_MESSAGES LC_CTYPE

# Another good tip comes from this page which includes the tip that if you add
# "[ \t]*" to your HISTIGNORE variable you can make any command be ignored by
# starting it with a space. Good if you need a little extra privacy for some
# commands.
# export HISTIGNORE="[ \t]*:history:$HISTIGNORE"

# To over come those pesky "Can't set locale" warnings
#export LC_ALL=C
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# And then run
# sudo locale-gen en_US.UTF-8
# sudo dpkg-reconfigure locales # activate all missing languages here, usually en_US.UTF8, en_GB.UTF8 and de_DE.UTF8

export PATH=/opt:$PATH
export PATH=/opt/xmind/XMind_amd64/:$PATH
