#/bin/bash

#cd $1/mpg
rm -rf ./*.mp3 ./*.wav
for file in `dir -d *` ; do
  file_basename=`basename "$file" .mpg`
#  mplayer -dumpaudio "$file" -dumpfile "$file_basename".mp3
  mplayer $file -vc null -vo null -ao pcm:fast
  twolame audiodump.wav  "$file_basename".mp3
  rm -rf audiodump.wav
#  mencoder "$file" -oac mp3lame -ovc copy -o "$file_basename".mp3
#  mv $1/mpg/*.mp3 $1/audio/
done
#cd ..
#rm -rf audio
#mkdir audio
#mv $1/*.mp3 audio
#cd audio
#find -name "* *" -type f | rename 's/.mpg././g'
