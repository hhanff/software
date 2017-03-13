@echo off


rem  PlanAhead(TM)
rem  runme.bat: a PlanAhead-generated ISim simulation Script
rem  Copyright 1986-1999, 2001-2011 Xilinx, Inc. All Rights Reserved.


set PATH=$XILINX/lib/$PLATFORM:$XILINX/bin/$PLATFORM;/opt/Xilinx/13.2/ISE_DS/ISE/bin/lin64:/opt/Xilinx/13.2/ISE_DS/common/bin/lin64;/opt/Xilinx/13.2/ISE_DS/ISE/lib/lin64:/opt/Xilinx/13.2/ISE_DS/common/lib/lin64;/opt/Xilinx/13.2/ISE_DS/PlanAhead/bin;%PATH%

set XILINX_PLANAHEAD=/opt/Xilinx/13.2/ISE_DS/PlanAhead

fuse -intstyle pa -incremental --rangecheck -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip -o arbiter_tb.exe --prj "/home/hhanff/Dropbox/src/verilog/system_verilog/system_verilog.sim/sim_1/arbiter_tb.prj"  -top work.arbiter_tb  -top work.glbl
if errorlevel 1 (
   cmd /c exit /b %errorlevel%
)
