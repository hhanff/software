#!/bin/sh
# 
# PlanAhead(TM)
# runme.sh: PlanAhead-generated Script for launching ISim application
# Copyright 1986-1999, 2001-2011 Xilinx, Inc. All Rights Reserved.
# 
if [ -z "$PATH" ]; then
  PATH=$XILINX/lib/$PLATFORM:$XILINX/bin/$PLATFORM:/opt/Xilinx/13.2/ISE_DS/ISE/bin/lin64:/opt/Xilinx/13.2/ISE_DS/common/bin/lin64
else
  PATH=$XILINX/lib/$PLATFORM:$XILINX/bin/$PLATFORM:/opt/Xilinx/13.2/ISE_DS/ISE/bin/lin64:/opt/Xilinx/13.2/ISE_DS/common/bin/lin64:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=$XILINX/lib/$PLATFORM:/opt/Xilinx/13.2/ISE_DS/ISE/lib/lin64:/opt/Xilinx/13.2/ISE_DS/common/lib/lin64
else
  LD_LIBRARY_PATH=$XILINX/lib/$PLATFORM:/opt/Xilinx/13.2/ISE_DS/ISE/lib/lin64:/opt/Xilinx/13.2/ISE_DS/common/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

#
# Setup env for Xilinx simulation libraries
#
XILINX_PLANAHEAD=/opt/Xilinx/13.2/ISE_DS/PlanAhead
export XILINX_PLANAHEAD
ExecStep()
{
   $*
   RETVAL=$?
   if [ $RETVAL -ne 0 ]
   then
       exit $RETVAL
   fi
}
ExecStep "fuse -intstyle pa -incremental --rangecheck -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip -o arbiter_tb.exe --prj "/home/hhanff/Dropbox/src/verilog/system_verilog/system_verilog.sim/sim_1/arbiter_tb.prj"  -top work.arbiter_tb  -top work.glbl"
