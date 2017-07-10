#!/bin/sh
#
XILINX="/mnt/daten/opt/Xilinx/10.1/ISE/"
if [ -z "$XILINX" ]
then
  echo "XILINX not defined"
#  exit 1
fi
#
cd $XILINX
echo "============================================================"
echo "* Build ghdl UNISIM libs for $XILINX"
echo "============================================================"
#
if [ ! -d ghdl ]
then
  mkdir ghdl
fi
#
cd $XILINX/ghdl
if [ ! -d unisim  ]
then
  mkdir unisim
fi
#
cd $XILINX/ghdl/unisim
cp $XILINX/vhdl/src/unisims/unisim_VCOMP.vhd .
cp $XILINX/vhdl/src/unisims/unisim_VPKG.vhd .
#
if [ ! -d unisim_vital_chop  ]
then
  mkdir unisim_vital_chop
fi
cd unisim_vital_chop
xilinx_vhdl_chop $XILINX/vhdl/src/unisims/unisim_VITAL.vhd
#
cd ..
echo "# ghdl ... unisim_VCOMP.vhd"
ghdl -a --ieee=synopsys --work=unisim unisim_VCOMP.vhd
echo "# ghdl ... unisim_VPKG.vhd"
ghdl -a --ieee=synopsys --work=unisim unisim_VPKG.vhd
 
for file in `find unisim_vital_chop -name "*.vhd"`
do
  echo "# ghdl ... $file"
  ghdl -a -fexplicit --ieee=synopsys --work=unisim 2>&1 $file |\
      tee $file.ghdl.log
done
#
echo "--- scan for compilation errors:"
find unisim_vital_chop -name "*.ghdl.log" | xargs grep error
#
