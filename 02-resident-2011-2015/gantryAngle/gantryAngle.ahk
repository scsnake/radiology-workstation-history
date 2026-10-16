pi=3.141592653589793


gui,font,s12,Verdana

gui,add,text,,Lesion to rib
gui,add,edit,yp xp+170 vd1
gui,add,text,xs,Z-axis distance
gui,add,edit,yp xp+170 vd2
gui,add,text,xs,Angle
gui,add,edit,yp xp+170 vangle


gui,show,,Gantry angle

settimer,cal,500

return


cal:
gui,submit,nohide
if !(v1:=d1*1) || !(v2:=d2*1)
	return
guicontrol,,angle,% round(atan(v2/v1)*180/pi,1)
return

guiclose:
~!q::
ExitApp
return