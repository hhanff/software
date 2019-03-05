# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/hhanff/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="false"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="false"

# Uncomment the following line to disable auto-setting terminal title.
export EMACS=emacs
DISABLE_AUTO_TITLE="false"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy/mm/dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  common-aliases # e.g. la or lt
  copyfile # Copies content of a file into clipboard
  git-extras
  emacs
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

function my_ros_env (){
    # unalias pwd;
    if [ -f /usr/share/gazebo-7/setup.sh ] ; then
    source /usr/share/gazebo-7/setup.sh
    fi
    if [ -f  /opt/ros/kinetic/setup.zsh ] ; then
    source /opt/ros/kinetic/setup.zsh
    fi
    if [ -f  $HOME/catkin_ws/devel/setup.zsh ] ; then
    source $HOME/catkin_ws/devel/setup.zsh
    
      #IP=$(ip add show wlp3s0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}' | sed -e s/\\/24//);
      # IP=$(hostname -i); export ROS_HOSTNAME=${IP};
      # export ROS_MASTER_URI=http://${IP}:11311
      # export ROS_MASTER_URI=http://localhost:11311
      # export ROS_MASTER_URI=http://$(hostname):11311
      # export ROS_HOSTNAME=192.168.128.221
      #export ROS_HOSTNAME=${IP};
      #export ROS_HOSTNAME=localhost;
      export ROS_HOSTNAME=$(hostname)
      echo "ROS_HOSTNAME = " $ROS_HOSTNAME
      echo "ROS_MASTER_URI = " $ROS_MASTER_URI
      export PYTHONPATH=$PYTHONPATH:/opt/deptool
    fi

}
my_ros_env

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
unalias history
export DISABLE_UNTRACKED_FILES_DIRTY=false
export DISABLE_AUTO_UPDATE=false
export DISABLE_UPDATE_PROMPT=false
# For my_start_terminalserver in zsh:
source ~/.profile_common