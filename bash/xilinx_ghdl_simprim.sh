#!/bin/sh
#
XILINX="/mnt/daten/opt/Xilinx/10.1/ISE/"
if [ -z "$XILINX" ]
then
  echo "XILINX not defined"
  exit 1
fi
#
cd $XILINX
echo "============================================================"
echo "* Build ghdl SIMPRIM libs for $XILINX"
echo "============================================================"
#
if [ ! -d ghdl ]
then
  mkdir ghdl
fi
#
cd $XILINX/ghdl
if [ ! -d simprim  ]
then
  mkdir simprim
fi
#
cd $XILINX/ghdl/simprim
cp $XILINX/vhdl/src/simprims/simprim_Vcomponents.vhd .
cp $XILINX/vhdl/src/simprims/simprim_Vpackage.vhd .
#
if [ ! -d simprim_vital_chop  ]
then
  mkdir simprim_vital_chop
fi
cd simprim_vital_chop
xilinx_vhdl_chop $XILINX/vhdl/src/simprims/simprim_VITAL.vhd
#
cd ..
echo "# ghdl ... simprim_Vcomponents.vhd"
ghdl -a --ieee=synopsys --work=simprim simprim_Vcomponents.vhd
echo "# ghdl ... simprim_Vpackage.vhd"
ghdl -a --ieee=synopsys --work=simprim simprim_Vpackage.vhd
 
for file in `find simprim_vital_chop -name "*.vhd"`
do
  echo "# ghdl ... $file"
  ghdl -a -fexplicit --ieee=synopsys --work=simprim 2>&1 $file |\
      tee $file.ghdl.log
done
#
echo "--- scan for compilation errors:"
find simprim_vital_chop -name "*.ghdl.log" | xargs grep error
#
