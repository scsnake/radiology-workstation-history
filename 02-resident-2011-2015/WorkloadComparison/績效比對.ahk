#SingleInstance,ignore
#include <risimpax>
SetTitleMatchMode,2

gui,font,s12,Verdana

gui,add,text,,% "RIS搜尋（顯示醫令碼欄位）→EXCEL匯出"
gui,add,button,gRisDataClip vRisDataButtonClip,% "從剪貼簿匯入"
gui,add,button,gRisData vRisDataButton x+30,% "從RIS匯入(較慢)"
gui,add,text,,% " "


gui,add,text,xs,% "RIS→時限完成率→搜尋→EXCEL匯出"
gui,add,button,gFinishDataClip vFinishDataButtonClip,% "從剪貼簿匯入"
gui,add,button,gFinishData vFinishDataButton x+30,% "從RIS匯入(較慢)"
gui,add,text,,% " "
finishCol:=3

gui,add,text,xs,% "登入Portal→行政系統→企劃管理部→第四代績效作業"
gui,add,text,,% "→(左方選單)績效獎金查詢→醫師服務量→查詢年月→複製網頁文字"
gui,add,button,gPortalData  vPortalDataButton,% "Click me for page 1   "
gui,add,button,gReset x+30,% "Reset服務量"
PortalData:=[],page:=1
gui,add,text,,% " "

gui,add,button,xs gcompare vcompare,% "     開始比對     "

gui,show,autosize


return


compare:
if (portalData.maxindex()<1){
	msgbox 無服務量資料
	return
}
guicontrol,,compare,資料處理中...
loop {
	sleep 500
	;~ tooltip % ready
}until ready=1
guicontrol,,compare,比對中...
guicontrol,disable,compare
result:=[]
for k,v in RisData[1] {
	if v=醫令代碼
		idCol:=k
	else if v=診別
		clinicCol:=k
	else if v=檢查地
		hospitalCol:=k
	else if v=報告日
		reportCol:=k
}
resultTxt:="院區`t門住急`t醫令碼`t醫令名稱`t數量`t點數`t實際數量`t短少數`t短少點數`n"
for k,v in portalData {
	count:=0
	for x,y in RisData {
		if (y[idCol]=v[3] && instr(y[clinicCol],v[2]) && ifsameHos(y[hospitalCol],v[1]) && regexmatch(y[reportCol],"^" yr "\/?" mn))
			++count
	}
	for x,y in v
		resultTxt.=y "`t"
	;~ portalData[k,v.maxindex()+1]:=count
	resultTxt.= count "`t"
	resultTxt.= count-(v[5]+0) "`t"
	resultTxt.= (count-(v[5]+0))*(v[6]/v[5]) "`n"
}
filedelete,%yr%%mn%.txt
fileappend,% clipboard:=resultTxt,%yr%%mn%.txt,utf-8
run % yr mn ".txt"
guicontrol,,compare,開始比對
guicontrol,enable,compare
return

ifsameHos(a,b){
	if (a=b)
		return 1
	
	arr1:={N總院:"T0", B分院: "T2", J分院: "T3", H分院:"T4", ZD分院: "T5", Y分院: "Y0"}
	
	for k,v in arr1
		if (instr(a,k) || instr(a,v)){
			a1:=v
			break
		}
		
	for k,v in arr1
		if (instr(b,k) || instr(b,v)){
			b1:=v
			break
		}
	
	
	return (a1=b1)?1:0
}

evalNum(i){
	i:=RegExReplace(i,"\,","")
	return i+0
}

Reset:
page:=1
PortalData:=[]
guicontrol,,PortalDataButton,Click me for page %page%
guicontrol,enable,PortalDataButton

return

FinishData:
if !hwnd:=winexist("報告時限完成率 ahk_exe Menu.exe") {
	msgbox % "請先執行：RIS→報告時限完成率→搜尋"
	return
}
if !FinishHwnd:=getNetAcc(hnwd,"DataGridView1","WindowsForms10.Window",0,0) {
	Msgbox % "Can't find the grid control!"
	return
}
FinishData:=[]
guicontrol,,FinishDataButton,Parsing...
guicontrol,disable,FinishDataButton
parseDataGrid(FinishHwnd,FinishData)
guicontrol,,FinishDataButton,從RIS匯入(較慢)
guicontrol,enable,FinishDataButton
gosub combineData
return

FinishDataClip:
FinishData:=[]
guicontrol,,FinishDataButtonClip,Parsing...
guicontrol,disable,FinishDataButtonClip
temp:=clipboard
loop,parse,temp,`n,`r
{
	tmp:=[]
	loop,parse,a_loopfield,`t
		tmp.push(trim(a_loopfield))
	FinishData.push(tmp)
}
guicontrol,,FinishDataButtonClip,從剪貼簿匯入
guicontrol,enable,FinishDataButtonClip
gosub combineData
return

RisDataClip:
RisData:=[]
guicontrol,,RisDataButtonClip,Parsing...
guicontrol,disable,RisDataButtonClip
temp:=clipboard
loop,parse,temp,`n,`r
{
	tmp:=[]
	loop,parse,a_loopfield,`t
		tmp.push(trim(a_loopfield))
	RisData.push(tmp)
}
guicontrol,,RisDataButtonClip,從剪貼簿匯入
guicontrol,enable,RisDataButtonClip
gosub combineData
return

RisData:
if !hwnd:=RisOpened()[2] {
	msgbox % "請先執行RIS"
	return
}
RisData:=[]
guicontrol,,RisDataButton,Parsing...
guicontrol,disable,RisDataButton
parseDataGrid(getRisList(),RisData)
guicontrol,,RisDataButton,從RIS匯入(較慢)
guicontrol,enable,RisDataButton
gosub combineData
return

PortalData:
guicontrol,,PortalDataButton,Parsing...
guicontrol,disable,PortalDataButton
site:=Clipboard
RegExMatch(site,"(\d+)年 (\d+)月的服務量有",match)
yr:=match1
mn:=match2
RegExMatch(site,"is)院區 門住急 醫令碼 醫令名稱 數量 點數[^T]+(.+)前往第 頁請輸入頁數",match)
table:=match1
loop,parse,table,`n,`r
{
	;~ temp:=[]
	;~ loop,parse,a_loopfield,%a_space%
		;~ temp.push(trim(a_loopfield))
	if regexmatch(a_loopfield,"is)([tTyY]\w) ([^ ]+) (\w{8}) +(.+?) ([\d\,]+\.\d+) ([\d\,]+\.\d+)",match)
		PortalData.push([match1,match2,match3,match4,evalNum(match5),evalNum(match6)])
}
++page
guicontrol,,PortalDataButton,Click me for page %page%
guicontrol,enable,PortalDataButton

return

combineData:
critical
if (RisData.maxindex()<1 || FinishData.maxindex()<1)
	return
for k,v in RisData[1] {
	if (v="醫令代碼"){
		idCol:=k
	}else if(v="照會單號"){
		sidCol:=k
	}
}
if (!idCol || !sidCol) {
	msgbox RIS清單格式錯誤！
	return 
}
for k,v in FinishData[1] {
	if (v="報告日"){
		reportCol:=k
	}else if(v="照會單號"){
		sidCol2:=k
	}
}
if (!reportCol || !sidCol2) {
	msgbox RIS報告時限完成率格式錯誤！
	return
}
ready:=0
for k,v in RisData {
	;~ if (k=1){
		;~ RisData[k,v.maxIndex()+1]:="醫令代碼"
		;~ continue
	;~ }
	id:=v[idCol]
	sid:=v[sidCol]
	for x,y in FinishData
		if (sid=y[sidCol2]){
			RisData[k,v.maxIndex()+1]:=y[reportCol]
			break
		}
}
ready:=1
settimer,dump,-1
return



dump:
dump:=""
for k,v in RisData
{
	for x,y in v
		dump.=y "`t"
	dump.="`n"
}
FileDelete,reportData.txt
FileAppend,% dump,reportData.txt,utf-8
return

;~ esc::
guiclose:
exitapp
return


