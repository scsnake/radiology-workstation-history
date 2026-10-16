coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%
#SingleInstance,ignore
#NoEnv



~!f1::
mousegetpos,x1,y1
tooltip,% "禮物座標=(" x1 "," y1 ")",x1+20,y1+20
settimer,removetooltip,2000
return

~!f2::
mousegetpos,x2,y2
tooltip,% "禮物座標=(" x2 "," y2 ")",x2+20,y2+20
settimer,removetooltip,2000
return


removetooltip:
settimer,removetooltip,off
tooltip
return

h::
if (x1="") or (x2="")
{
    tooltip,% " 未選擇座標 "
    settimer,removetooltip,2000
    return
}

loop 15
{
    
    mouseclick,left,% x1,y1,1,0
    
    sleep 5000
    
    loop 2
    {
        mouseclick,left,% x2,y2,1,0
        sleep 200
    }
    
    
    
    sleep 200
}
return




~!q::exitapp