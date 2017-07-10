#!/bin/bash
# Mit ripperx die CD rippen. Beim Rippren darauf achten, dass die Tracknummern mit geriptt werden
mkdir temp && for f in *.wav; do lame --vbr-new -V 3 "$f" ./temp/"${f%.wav}.mp3"; done
del *.wav && mv temp/*.mp3 . && del temp
