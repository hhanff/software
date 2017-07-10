#!/bin/bash
sudo wget http://youtube-dl.org/downloads/2013.02.02/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+x /usr/local/bin/youtube-dl
youtube-dl -t --extract-audio --audio-format mp3  <YOUTUBE URL HERE>
ffmpeg -i <FILENAME HERE> -f mp3 -vn -acodec libmp3lame - > OUTPUT FILENAME.mp3

