#persistent
#singleinstance,force

settimer,closeUpdate,200

return

closeUpdate:
if !(id:=winexist("Microsoft Office Activation Wizard ahk_class NUIDialog"))
	return
winactivate,ahk_id %id%
winwaitactive,ahk_id %id%,,1
winclose,ahk_id %id%
exitapp
return