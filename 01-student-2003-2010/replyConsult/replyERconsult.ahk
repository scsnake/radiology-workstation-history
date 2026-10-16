
#include <portallib>
#Persistent



askForPortalIdPw()
gosub main
settimer,main,% 10*60*1000
return



main:
if !checksid(sid)
	sid:=login(loginId,loginPw)

startDate:=a_now
if (a_hour=0)
	startDate+=-1,days

allConsults:=consultinfo(sid,"Dept",{DeptCode:"RAD",startYear: substr(startDate,1,4),startMonth: substr(startDate,5,2),startDay: substr(startDate,7,2)})

;~ toBeReplied:=[]

for k,v in allConsults {
	;~ if (v.type="急診" && instr(v.leftTime,":") && RegExReplace(v.leftTime,"(\d+:)?","")<10 && instr(v.status,"待回覆"))
	if (testConsult(v))
		replyConsult(sid, v.account, v.NotifyID,"","We will evaluate the patient soon.","We will evaluate the patient soon.","We will evaluate the patient soon.")
}
return



testConsult(v){
	if !instr(v.status,"待回覆")
		return 0
	if (instr(v.leftTime,":") && RegExReplace(v.leftTime,"(\d+:)?","")>=10)
		return 0
	if (v.type="指定")
		return 0
	if (v.type="急診")
		return 1
}


