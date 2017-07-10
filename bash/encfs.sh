#!/bin/bash
# set -eu
# set -x
#http://wiki.ubuntuusers.de/EncFS
# Install and grant user the necessary rights
#sudo apt-get install encfs
#sudo gpasswd -a $USER fuse
#newgrp fuse # Mount
encfs --idle 10 ~/Videos/.x /home/hhanff/Videos/x
#sudo bash
# Wait for keyboard input and delete bash content
read TRASH;
fusermount -u /home/hhanff/Videos/x
# Delete screen content
printf "\033c"
# Delete  items from bash history
cat /home/hhanff/.bash_history | grep -v mplayer > /tmp/.bash_history
# Delete bash history file
\rm -rf ~/.bash_history
# Delete bash history stack
history -c
# Reinstall history file
mv /tmp/.bash_history ~/.bash_history
# Copy new bash history file content to bash history stack
history -n
