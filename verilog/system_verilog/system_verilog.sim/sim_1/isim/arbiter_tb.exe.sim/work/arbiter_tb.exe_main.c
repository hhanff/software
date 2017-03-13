/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_06434613821682626241_4264101583_init();
    work_m_11382339290051345961_4109021394_init();
    work_m_10764087207863065690_2073120511_init();


    xsi_register_tops("work_m_11382339290051345961_4109021394");
    xsi_register_tops("work_m_10764087207863065690_2073120511");


    return xsi_run_simulation(argc, argv);

}
