#!/bin/bash
for FILE in ./*; do
	dcraw -q 3 -w -c $FILE | convert -quality 95 -sharpen 5 - $FILE.jpg
done 

