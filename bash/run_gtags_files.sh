#!/bin/sh
find ./ -type f \( -iname \*.vhd -o -iname \*.ucf \) -print > gtags.files
echo "done"


