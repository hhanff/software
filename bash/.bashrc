source ~/.profile_common

# Enable options:
#Enable suport of bash history across multiple bash sessions
#shopt -s histappend
export HISTFILESIZE=10000
export HISTSIZE=10000

#shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
#shopt -s mailwarn
shopt -s sourcepath
shopt -s no_empty_cmd_completion  # bash>=2.04 only
shopt -s cmdhist
#Enable suport of bash history across multiple bash sessions, don't overwrite it
shopt -s histappend histreedit histverify
shopt -s extglob      # Necessary for programmable completion
shopt -s autocd
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
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
# curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
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

# First test if we are in an interactive session to overcome bind errors
iatest=$(expr index "$-" i)
# Then do the actual bind
if [[ $iatest > 0 ]]; then bind '"…":"pushd ..\n"'; fi # AltGr .
if [[ $iatest > 0 ]]; then bind '"÷":"popd\n"'; fi #  # AltGr Shift .
alias h='history'
alias which='type -all'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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
#complete -F _make_targets -X '+($*|*.[cho])' make gmake pmake

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

# function my_ros_env (){
#     # unalias pwd;
#     if [ -f /usr/share/gazebo-7/setup.sh ] ; then
#     source /usr/share/gazebo-7/setup.sh
#     fi
#     if [ -f  /opt/ros/kinetic/setup.sh ] ; then
#     source /opt/ros/kinetic/setup.sh
#     fi
#     if [ -f  $HOME/catkin_ws/devel/setup.sh ] ; then
#     source $HOME/catkin_ws/devel/setup.sh
#       #IP=$(ip add show wlp3s0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}' | sed -e s/\\/24//);
#       IP=$(hostname -i); export ROS_HOSTNAME=${IP};
#       export ROS_MASTER_URI=http://127.0.0.1:11311
#       export ROS_MASTER_URI=http://localhost:11311
#       export ROS_MASTER_URI=http://${IP}:11311
#       export ROS_MASTER_URI=http://10.250.3.6:11311
#       export ROS_MASTER_URI=http://$(hostname):11311
#       export ROS_HOSTNAME=192.168.128.221
#       export ROS_HOSTNAME=${IP};
#       export ROS_HOSTNAME=localhost;
#       export ROS_HOSTNAME=$(hostname)


#       echo "ROS_HOSTNAME = " $ROS_HOSTNAME
#       echo "ROS_MASTER_URI = " $ROS_MASTER_URI
#     fi
# }
# my_ros_env

function _exit()	# function to run upon exit of shell
{
    echo -e "\e[1;31mHasta la vista, baby!!!\e[0m"
}
trap _exit EXIT


# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT="/home/hhanff/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh

