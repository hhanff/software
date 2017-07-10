#! /bin/bash
export PASSPHRASE="*******"
SOURCE=/home/$USER/.emacs.d/
DESTINATION=file:////mnt/temp/HendrikH/

# doing a monthly full backup (1M)
duplicity --full-if-older-than 1M $SOURCE $DESTINATION

# cleaning the remote backup space (deleting backups older than 6 months (6M,
#alternatives would 1Y fo 1 year etc.)
#duplicity remove-older-than 6M --force  $SOURCE $DESTINATION

unset PASSPHRASE
unset FTP_PASSWORD
