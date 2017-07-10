BEGIN{
    ManufactureGrid=1*0.005
    width=7
    width_H=7
    spacing_H=1*1.5
    spacing=1*1.5
    offsetH=1*141.6
}

{
    if($1=="Head" && $2=="Box:"){
        H=sprintf("%.2f",1*$NF-1*$4)
        W=sprintf("%.2f",1*$5-1*$3)
        stripPitch=1*450
        stripOffset_1=125
        stripOffset_2 = 1465
        Vstrip=int(W/stripPitch)
        printf("uiSetTool specialRoute\n")
        printf("setEdit -nets {vdd gnd}\n")
        printf("setEdit -layer_horizontal M5\n")
        printf("setEdit -layer_vertical M4\n")
        printf("setEdit -width_horizontal %.3f\n",width_H)
        printf("setEdit -spacing_horizontal %.2f\n",spacing_H)
        printf("setEdit -width_vertical %.3f\n",width)
        printf("setEdit -spacing_vertical %.2f\n",spacing)
        printf("setEdit -extend_to_bdry 1\n")
        printf("setEdit -extend_start_wires 1\n")
        printf("setEdit -extend_end_wires 1\n")
        printf("setEdit -shape STRIPE\n")

        # Vstripes

        for(i=0;i<=0;i++){
            printf("editAddRoute %.2f %.2f\n",stripOffset_1+(i*stripPitch),-offsetH+1*H/2)
            printf("editCommitRoute %.2f %.2f\n",stripOffset_1+(i*stripPitch),offsetH+1*H/2)
            printf("editAutoCompleteNets\n")
        }


        printf("uiSetTool cancel\n")
    }
}
