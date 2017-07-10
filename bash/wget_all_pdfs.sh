#/bin/bash

for arg in {1..80}
do 
    wget http://www.xilinx.com/publications/archives/xcell/Xcell$arg.pdf; 
done
