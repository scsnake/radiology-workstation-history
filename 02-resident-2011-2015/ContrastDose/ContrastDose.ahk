#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force

SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1

onexit,exitsub


gui,font,Verdana S16
gui,+lastfound
gui,add,text,section,體重
gui,add,edit,yp xp+80 w100 vBW,60
gui,add,text,yp xp+120,身高
gui,add,edit,yp xp+80 w100 vBH,170
gui,add,text,yp xp+120,性別
gui,add,radio,yp xp+60 vgender checked,男
gui,add,radio,yp xp+60,女

gui,add,text,xs,×1.2
gui,add,text,yp xp+100,×1.3
gui,add,text,yp xp+100,×1.4
gui,add,text,yp xp+100,×1.5
gui,add,text,yp xp+100,×1.6
gui,add,text,yp xp+100,×2.0

gui,add,edit,xs w80 ve11 r1,% floor(60*1.2)
gui,add,edit,yp xp+100 w80 ve12 r1,% floor(60*1.3)
gui,add,edit,yp xp+100 w80 ve13,% floor(60*1.4)
gui,add,edit,yp xp+100 w80 ve14,% floor(60*1.5)
gui,add,edit,yp xp+100 w80 ve15,% floor(60*1.6)
gui,add,edit,yp xp+100 w80 ve16,% floor(60*2)

gui,add,text,xs,by formula:
gui,add,edit,yp xp+140 w80 ve2,% floor((23.6*(170**0.725)*(60**0.425)-1229)*0.02)


gui,show,,Contrast Dose (Ultravist 370)

settimer,cal,333

return

cal:
gui,submit,nohide
IfWinNotActive,Contrast Dose
{
	guiStatus=0
	return
}
else if guiStatus=0
	guicontrol,focus,BW
guiStatus=1
	
if not BW is number
	return
if (BW=oldBW && BH=oldBH && gender=oldGender)
	return
oldBW:=BW,oldBH=BH,oldGender=gender

guicontrol,,e11,% floor(BW*1.2)
guicontrol,,e12,% floor(BW*1.3)
guicontrol,,e13,% floor(BW*1.4)
guicontrol,,e14,% floor(BW*1.5)
guicontrol,,e15,% floor(BW*1.6)
guicontrol,,e16,% floor(BW*2)

if gender=1
	guicontrol,,e2,% floor((23.6*(BH**0.725)*(BW**0.425)-1229)*0.02)
else
	guicontrol,,e2,% floor((24.8*(BH**0.725)*(BW**0.425)-1954)*0.02)

return


exitsub:
!q::
ExitApp
return