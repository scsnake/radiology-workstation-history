SetTitleMatchMode,2
settimer,subIMPAX,200
SetBatchLines,-1


sleep 300
if (Impax:=ImpaxState)[1]!=2
   exitapp

regexmatch(A_ScriptName,"(\w)\w{5}\d",match)
if match=
	exitapp

winactivate,% "ahk_id " id2:=Impax[2,2]|Impax[2,3]
bar:=ImpaxBar(id2)
wingetpos,,,,h,ahk_id %id2%
if !(bar.h>h-37)
	controlclick,,% "ahk_id " bar.hwnd
gosub selectChartNo
acc_objectfromwindow(impaxChartnoControl).accValue:=match
controlsend,,{enter},% "ahk_id " impaxChartnoControl
exitapp
return

selectChartNo:
for k,v in (impaxControls:=getcontrols(id2:=Impax[2,2]|Impax[2,3])){
    if k<2
        continue
    if instr(v.classNN,"WindowsForms10.EDIT.app") && ((impaxControls[k-1].text="病歷號碼" && impaxControls[k+2].text="檢查之日期") || (impaxControls[k-1].text="Patient ID" && impaxControls[k+2].text="Study Date")) {
        controlfocus,,% "ahk_id " impaxChartnoControl:=v.hwnd
        controlget,selectedText,Selected,,,% "ahk_id " impaxChartnoControl
        if !selectedText
			ControlClick,,% "ahk_id " impaxChartnoControl,,l,1
        break
   }
}
return


subIMPAX:
impaxState:=impaxOpened()
return


/* check if IMPAX opened
arr[1]=0	no IMPAX
arr[1]=1, arr[2,1]=hwnd of login window
arr[1]=2, arr[2,1]=hwnd of image window
arr[1]=2, arr[2,2]=hwnd of list & text window
arr[1]=2, arr[2,3]=hwnd of list window
arr[1]=2, arr[2,4]=which type of active IMPAX window (1:image, 2:list, 3:text)
arr[1]=2, arr[2,5]=which configuration of IMPAX windows (1 for one window, 2 for double window)
*/
ImpaxOpened()
{
	winget,ImpaxIdList,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098
	winget,activeWin,id,A
	arr:=[],ind1:=ind2:=ind3:=0,a1:=a2:=a3:=0
	arr[1]:=0
	loop 5
		arr[2,a_index]:=0
	
	
	loop % ImpaxIdList
	{
		id:=ImpaxIdList%a_index%
		wingettext,text,ahk_id %id%
		if ind:=instr(text,"STUDY_NAV_TOOLBAR0"){
			ind1:=ind,a1:=a_index,arr[2,1]:=id
			;~ if((arr[2,1]:=id)=activeWin)
				;~ arr[2,4]:=1
				
		}
		if((instr(text,"工作清單")&&instr(text,"相關性")&&instr(text,"更新"))||(instr(text,"Worklists")&&instr(text,"Relevance")&&instr(text,"Refresh"))){
			if((instr(text,"臨床資訊")&&instr(text,"RIS 狀態")&&instr(text,"病患 HIS 代碼"))||(instr(text,"Clinical Information")&&instr(text,"RIS Status")&&instr(text,"Patient HIS Code"))){
				ind2:=instr(text,"臨床資訊")|instr(text,"Clinical Information")
				a2:=a_index,arr[2,2]:=id
				;~ if((arr[2,2]:=id)=activeWin)
					;~ arr[2,4]:=2
			}else{
				ind3:=instr(text,"工作清單")|instr(text,"Worklists")
				a3:=a_index,arr[2,3]:=id
				;~ if((arr[2,3]:=id)=activeWin)
					;~ arr[2,4]:=3
					
			}
		}
		wingetpos,,,,h,ahk_id %id%
		if (maxH<h)
			maxH:=h
	}
	
	h:=maxH
	h-=41
	
	
	if (arr[2,1]||arr[2,2]||arr[2,3]){
		
		arr[1]:=2
		if(arr[2,1]=(arr[2,2]|arr[2,3])){
			arr[2,5]:=1
			
			if ((bar:=impaxBar(arr[2,2]|arr[2,3])).h>h){
				arr[2,4]:=2
			}else if(ind1<(ind2|ind3)){
				arr[2,4]:=1
			}else {
				arr[2,4]:=3
			}
			
			
		}else{
			arr[2,5]:=2
			
			;~ if(arr[2,4]>1&&(impaxBar(arr[2,2]|arr[2,3]).h>h)){
				;~ arr[2,4]:=2
			;~ }else if (arr[2,4]>1&&(impaxBar(arr[2,2]|arr[2,3]).h<=h)){
				;~ arr[2,4]:=3
			;~ }else{
				;~ arr[2,4]:=1
			;~ } 
			
			if(a1<(a2|a3)){
				arr[2,4]:=1
			}else if(impaxBar(arr[2,2]|arr[2,3]).h>h){
				arr[2,4]:=2
			}else{
				arr[2,4]:=3
			}
			
		
		}
		return arr
	}
		
	loop % ImpaxIdList
	{
		id:=ImpaxIdList%a_index%
		wingettext,text,ahk_id %id%
		if (instr(text,"登入") && instr(text,"密碼") && instr(text,"選項")) || (instr(text,"Login") && instr(text,"Options") && instr(text,"User ID"))
			return array(1,array(id))
	}
	
	return array(0,0)
}

/* 
return switch bar: hwnd, x,y,w,h
*/
ImpaxBar(hwnd){
    for k,v in (impaxControls:=getcontrols(hwnd)) {
        if ((v.text="登出"||v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(impaxControls[k-2].classNN,"WindowsForms10.Window.8.app")) {
            controlgetpos,x,y,w,h,,% "ahk_id " barId:=impaxControls[k-2].hwnd
            break
        }
    }
	return {hwnd:barId, x:x, y:y, w:w, h:h}
}

GetControls(hwnd)
{
	controls:=[]
	winget,classnn,ControlList,ahk_id %hwnd%
	winget,controlId,controllisthwnd,ahk_id %hwnd%
	loop,parse,classnn,`n
	{
		controls[a_index]:=[]
		controls[a_index]["ClassNN"]:=a_loopfield
	}
	
	loop,parse,controlId,`n
	{
		controls[a_index]["Hwnd"]:=a_loopfield
		controlgetText,txt,,ahk_id %a_loopfield%
		controls[a_index]["text"]:=txt
	}
	return controls
}

;------------------------------------------------------------------------------
; Acc.ahk Standard Library
; by Sean
; Updated by jethrow:
;------------------------------------------------------------------------------

Acc_Init()
{
	Static	h
	If Not	h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}


Acc_ObjectFromWindow(hWnd, idObject = -4)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return	ComObjEnwrap(9,pacc,1)
}