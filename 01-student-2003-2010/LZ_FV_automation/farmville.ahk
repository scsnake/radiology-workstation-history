/* 
scsnake@gmail.com 
scsnake @ ptt & ptt2
*/



#SingleInstance,off
#include Gdip.ahk             ;;; http://www.autohotkey.com/forum/topic32238.html
#NoEnv

coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LOADING
;~ IniRead,farm_interval,farmville.ini,options,farm_interval,1
;~ if farm_interval is not integer
;~ {
	;~ msgbox % "ini檔中farm_interval值錯誤"
	;~ exitapp
;~ }
;~ if farm_interval <=0
;~ {
	;~ msgbox % "ini檔中farm_interval值錯誤"
	;~ exitapp
;~ }

IniRead,scales,farmville.ini,options,scales,% "[[15.118,7.235,15.087,7.261]]"

IniRead,scale,farmville.ini,options,scale,1
if(scale<=0 or scale>array_size(scales))
{
	msgbox % "ini檔中scale值錯誤"
}
if scale is not integer
{
	msgbox % "ini檔中scale值錯誤"
}

scalex1 := array_get(scales,1,1)
scaley1 := array_get(scales,1,2)
scalex2 := array_get(scales,1,3)
scaley2 := array_get(scales,1,4)
;~ IniRead,click_ms,farmville.ini,options,click_ms,0
;~ if(click_ms<0)
;~ {
	;~ msgbox % "ini檔中click_ms值錯誤"
;~ }
stop=1
warning=0
free_scale=0
addfarm_ind=0
delfarm_ind=0
addfarm_toggle=1
start_pxl := "[]"
addfarm_pxl := "[]"
addfarm_coor := "[]"
freeadd_pxl := "[]"
freeadd_coor := "[]"
delfarm_pxl := "[]"
freefarm_pxl := "[]"
savefarm_pxl := "[]"
savefarm_coor := "[]"
clicking=0
farm_interval:="[[1,1]]"
accept_err=0
accept_stop=1
update_date:="20110226"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GUI
gui, +alwaysontop +Border 
gui, +lastfound
winget,gui_hwnd

Gui, Font, S8 CDefault, Verdana
Gui, Add, Tab2, x12 y10 w300 h350 vtab_choosen gtab_select, % "常規耕田|儲存模式|自由點擊|大採購!!|其他" 


Gui, Tab, 1,, 
Gui, Add, Text,section, % "1. 農田倍率縮到最小"
Gui, Add, Text,xs vstart_pxl, % "2. Alt+F1 設定起點: (" . startx . "," . starty . ")                "   
Gui, Add, GroupBox, xs section w250 h110, % "3. 耕田模式:"
gosub, gui_farm_mode_radio
Gui, Add, Picture, x57 y108, % "pic\1.png"
Gui, Add, Picture, x57 y145, % "pic\2.png"
Gui, Add, Picture, x159 y95, % "pic\3.png"
Gui, Add, Edit, x185 y150 w20 h20 vfarm_mode_other_y Limit1 number , 4
Gui, Add, text, x205 y153, % "×"
Gui, Add, Edit, x215 y150 w20 h20 vfarm_mode_other_x Limit1 number , 4
Gui, Add, Text, xs h20 vend_pxl section, % "4. Alt+F2 設定終點: (" . endx . "," . endy . ")                "    
gui, add, groupbox, section w100 h65, % "調整範圍:"
gui, add, GroupBox, ys w100 h65 , % "滑鼠中鍵拖曳:"
Gui, Add, Button, xs y290 w80 h49 Section, % "GO!!`n(Alt+F3)"
gui, add, button, ys w80 h49, % "清除範圍`n(Esc)"
gui, add ,text, ys Section, % "ESC: 中斷操作"
gui, add, text, xs, % "Alt+Q: 離開程式"
gui, add, text, xs, % "Alt+I: 開啟設定檔"
gui, add, Radio, x32 y237 Section Checked vfarm_add gadd_del_toggle, % "增加範圍"
gui, add, Radio, xs Section gadd_del_toggle, % "減少範圍"
gui, add, picture, x140 y237, % "pic\middle.png"


Gui, Tab, 2,,
gui, add, button, section w80 h40, % "儲存範圍1"
gui, add, button, ys w80 h40, % "儲存範圍2"
gui, add, button, xs section w80 h40, % "儲存範圍3"
gui, add, button, ys w80 h40, % "儲存範圍4"
gui, add, text, xs section
gui, add, text, xs  section vstart_pxl2, % "Alt+F1 設定起點(最左邊之點): (" . startx . "," . starty . ")                "
gui, add, button, xs section w80 h40, % "載入範圍1"
gui, add, button, ys w80 h40, % "載入範圍2"
;~ gui, add, button, x210 ys w80 h49, % "GO!!`n(Alt+F3)"
;~ gui, add, button, ys w80 h49, % "清除範圍`n(Esc)"
gui, add, button, xs section w80 h40, % "載入範圍3"
gui, add, button, ys w80 h40, % "載入範圍4"
;~ gui, add ,text, x240 y60 Section, % "ESC: 中斷操作"
;~ gui, add, text, xs, % "Alt+Q: 離開程式"
;~ gui, add, text, xs, % "Alt+I: 開啟設定檔"
gui ,add, text, xs section
Gui, Add, Button, xs y290 w80 h49 Section, % "GO!!`n(Alt+F3)"
gui, add, button, ys w80 h49, % "清除範圍`n(Esc)"
gui, add ,text, ys Section, % "ESC: 中斷操作"
gui, add, text, xs, % "Alt+Q: 離開程式"
gui, add, text, xs, % "Alt+I: 開啟設定檔"


Gui, Tab, 3
gui, add, groupbox, w250 h85 Section, % "1. 設定行列數:"
gui, add, groupbox, w250 h80 xs, % "2. 設定範圍(依序取3點): "
gui, add, groupbox, xs w100 h60 Section, % "Ctrl+Alt+Z :"
gui, add, text, ys, % "滑鼠點擊間隔:"
gui, add, edit, ys number limit4 w40 h20 vclick_ms,0
gui, add, text, ys, % "毫秒"
Gui, Add, Button, xs y290 w80 h49 Section, % "GO!!`n(Alt+F3)"
gui, add, button, ys w80 h49, % "清除範圍`n(Esc)"
gui, add ,text, ys Section, % "ESC: 中斷操作"
gui, add, text, xs, % "Alt+Q: 離開程式"
gui, add, text, xs, % "Alt+I: 開啟設定檔"
gui, add, picture, Section x32 y53, % "pic\harvest.png"
;~ gui, add, picture, xs y150, % "pic\parallel.png"
gui, add, text, section ys, % "x="
gui, add, edit, ys vfree_x limit3 number w40 h20,3
gui, add, text, xs section, % "y="
gui, add, edit, ys vfree_y limit3 number w40 h20,4
gui, add, picture, x32 y150 section, % "pic\parallel.png"
gui, add, text, ys section vparallel_pxl1, % "Ctrl+Alt+1: (" . parallel_x1 . "," . parallel_y1 . ")             "
gui, add, text, xs vparallel_pxl2, % "Ctrl+Alt+2: (" . parallel_x2 . "," . parallel_y2 . ")             "
gui, add, text, xs vparallel_pxl3, % "Ctrl+Alt+3: (" . parallel_x3 . "," . parallel_y3 . ")             "
;~ gui, add, groupbox, x290 y40 w100 h60, % "Ctrl+Alt+Z :"
gui, add, Text, x32 y233 Section Checked vfarm_add_text gadd_del_toggle, % "→增加範圍"
gui, add, text, xs  vfarm_del_text gadd_del_toggle, % "　減少範圍"



Gui, Tab, 4
gui, add, groupbox, section w250 h80, % "1. 物品大小:"
Gui, Add, Text,xs vstart_pxl3, % "2. Alt+F1 設定起點: (" . startx . "," . starty . ")                "   
Gui, Add, Text, xs section vend_pxl3, % "3. Alt+F2 設定終點: (" . endx . "," . endy . ")                " 
gui, add, groupbox, xs w250 h60, % "4. Ctrl+Alt+1 設定按鈕位置: "
gui, add, text, xs, % "Pause鍵: 開始/結束滑鼠連點"
gui, add, text, xs section, % " (點擊間隔"
gui, add, edit, ys limit8 number vclicks w80 h20, 500
gui, add, text, ys, % "毫秒)"
Gui, Add, Button, xs y290 w80 h49 Section, % "GO!!`n(Alt+F3)"
gui, add, button, ys w80 h49, % "清除範圍`n(Esc)"
gui, add, picture, x32 y53 Section, % "pic\fence.png"
gui, add, text, section ys, % "x="
gui, add, edit, ys vbuy_x limit3 number w40 h20,1
gui, add, text, xs section, % "y="
gui, add, edit, ys vbuy_y limit3 number w40 h20,4
gui, add, picture, x32 y180 section, % "pic\buy.png"
gui, add, text, ys vbuy_button_pxl, % "(" . buy_button_x . "," . buy_button_y . ")                "


gui, tab, 5
gui, add, text, Section , % "1. 連線至接收禮物頁面:"
gui, add, edit, xs h20 readonly hwndlink_accept section, % "http://www.facebook.com/reqs.php"
ControlSend,,{home}+{end},ahk_id %link_accept%
gui, add, button, ys, % "複製"
gui, add, text, xs , % "2. 滑鼠移至網頁內"
gui, add, text, xs, % "3. Ctrl+Alt+A : 接收全部farmville禮物"
gui, add, text, xs, % "----------------------------------------"
gui ,add, text, xs section, % "輪序點擊"
gui, add, edit, ys number vrounds, % "0"
gui, add, text, ys, % "回合"
gui, add, button, xs section, % "圖片1"
gui, add, edit, ys h20 w80 vpic1
gui, add, text, ys, % "×"
gui, add, edit, ys number vclicks1, % "1"
gui, add, text, ys, % "("
gui, add, edit, ys number vsleep1, % "100"
gui, add, text, ys, % "ms)"
gui, add, edit, xs number section vwait1, % "0"
gui, add, text, ys, % "ms"
gui, add, button, xs section, % "圖片2"
gui, add, edit, ys h20 w80 vpic2
gui, add, text, ys, % "×"
gui, add, edit, ys number vclicks2, % "1"
gui, add, text, ys, % "("
gui, add, edit, ys number vsleep2, % "100"
gui, add, text, ys, % "ms)"
gui, add, edit, xs number section vwait2, % "0"
gui, add, text, ys, % "ms"
gui, add, button, xs section, % "圖片3"
gui, add, edit, ys h20 w80 vpic3
gui, add, text, ys, % "×"
gui, add, edit, ys number vclicks3, % "1"
gui, add, text, ys, % "("
gui, add, edit, ys number vsleep3, % "100"
gui, add, text, ys, % "ms)"
gui, add, edit, xs number section vwait3, % "0"
gui, add, text, ys, % "ms"
gui, add, text, ys, % "                   "
gui, add, button, gcyclick ys, % "開始點擊"

;~ gui, add, text, xs, % "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
;~ gui, add, button, xs gfind_fallow_land, % "尋找Fallow Land`n(換到FV以外視窗可中斷)"
;~ gui, add, text, xs section, % "H: 偵測鐮刀&點擊"
;~ gui, add, picture, ys, % "pic\sickle2.png"
;~ gui, add, text, x150 y300, % "scsnake@gmail.com"


gui_x_coor := a_screenwidth-330
Gui, show,NoActivate yCenter x%gui_x_coor%, FV clicker (%update_date%)
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HOTKEY



~^!a::
gui,submit, nohide
if tab_choosen!=其他
	return
;~ accept_err=0
;~ if accept_stop=0
;~ {
	;~ accept_stop=1
	;~ SetTimer,click_accept,off	
	;~ SetTimer,click_yes,off
;~ }
;~ else if accept_stop=1
;~ {
	;~ accept_stop=0
	;~ MouseGetPos,,,accept_window
	;~ SetTimer,click_accept,500
	
;~ }
send !d
clipboard=javascript: var a=10; var elements=document.getElementsByTagName("input"); var current; var buttons =[]; var i; var j=0; var abort=0; var new_windows=[]; for(i=0; i<elements.length; i++){ if(j>=a){ break; } current=elements[i]; if(/inputbutton/.test(current.className) && /http:\/\/apps.facebook.com\/onthefarm\//.test(current.outerHTML.match)){ var url =current.name.slice(8,-1); new_windows.push(open(url)); if(new_windows[j]==null){alert("%E7%84%A1%E6%B3%95%E6%96%B0%E9%96%8B%E8%A6%96%E7%AA%97");break;} buttons.push(current); j++; } } for(i=0;i<j;i++){ buttons[i].click(); } void(0);
send ^v{enter}
clipboard=
return



~pause::
traytip
gui,submit, nohide
if (x:=!x)
{
	SetTimer, SpamClick,% clicks
	goto SpamClick
}
Else
{
	SetTimer, SpamClick, Off
	traytip,, 滑鼠連點停止,2
}

return


;~ ~h::
;~ harvest:=!harvest
;~ if harvest
;~ {
	;~ SetTimer,sickle_search,20
	;~ traytip,,開啟偵測鐮刀
;~ }
;~ else
;~ {
	;~ settimer,sickle_search,off
	;~ traytip,,關閉偵側鐮刀,3
;~ }
;~ return
	



~!q::
GuiClose:
Gdip_Shutdown(pToken)
ExitApp
return

~^!1::
gui,submit,nohide
if tab_choosen not contains 自由點擊,大採購
{
	return
}
mousegetpos,,,fv_window
;~ WinGetTitle,fv_window_title,ahk_id %fv_window%
;~ if fv_window_title not contains farmville
;~ {
;~ 	msgbox 非Farmville視窗！
;~ 	return
;~ }
if tab_choosen=自由點擊
{
	mousegetpos,parallel_x1,parallel_y1
	ToolTip, % "起點座標: " . parallel_x1 . "," . parallel_y1
	SetTimer, RemoveToolTip, 1500
	guicontrol,text,parallel_pxl1,% "Ctrl+Alt+1: (" . parallel_x1 . "," . parallel_y1 . ")             " 
}
else if tab_choosen contains 大採購
{
	mousegetpos,buy_button_x,buy_button_y
	tooltip, % "購買按鈕座標: " . buy_button_x . "," . buy_button_y
	settimer, removetooltip,1500
	guicontrol,text,buy_button_pxl, % "(" . buy_button_x . "," . buy_button_y . ")                "
}
return

~^!2::
gui,submit,nohide
if tab_choosen not contains 自由點擊
{
	return
}
mousegetpos,parallel_x2,parallel_y2
ToolTip, % "第二座標: " . parallel_x2 . "," . parallel_y2
SetTimer, RemoveToolTip, 1500
guicontrol,text,parallel_pxl2,% "Ctrl+Alt+2: (" . parallel_x2 . "," . parallel_y2 . ")             " 
return


~^!3::
gui,submit,nohide
if tab_choosen not contains 自由點擊
{
	return
}
if parallel_x1*parallel_x2=0
{
	msgbox 未選取前兩座標
	return
}
mousegetpos,parallel_x3,parallel_y3
ToolTip, % "第三座標: " . parallel_x3 . "," . parallel_y3
SetTimer, RemoveToolTip, 1500
guicontrol,text,parallel_pxl3,% "Ctrl+Alt+3: (" . parallel_x3 . "," . parallel_y3 . ")             " 
gosub, gui_renew_end
return


~MButton::

gui,submit,nohide
gosub,set_farminterval
if tab_choosen!=儲存模式
{
	if tab_choosen=自由點擊 and addfarm_toggle=1
	{
		return
	}
	MouseGetPos,frame_x1,frame_y1
	settimer,draw_frame,20
	previous_farmx := ""
	previous_farmy := ""
	settimer,update_farm_info,100
}
~!F1::
gui,submit,nohide
if (tab_choosen=自由點擊 and addfarm_toggle=1)
{
	return
}
mousegetpos,,,fv_window
;~ WinGetTitle,fv_window_title,ahk_id %fv_window%
;~ if fv_window_title not contains farmville
;~ {
;~ 	msgbox 非Farmville視窗！
;~ 	return
;~ }
mousegetpos,startx,starty
ToolTip, % "起點座標: " . startx . "," . starty, startx+20,starty+20
SetTimer, RemoveToolTip, 1500
gosub, gui_renew_start
gosub, gui_renew_start2
gosub, gui_renew_start3
return


~MButton Up::
gui,submit,nohide
if (tab_choosen=儲存模式 or (tab_choosen=自由點擊 and addfarm_toggle=1))
{
	return
}
tooltip
gui, 2: destroy
Gdip_Shutdown(pToken)
~!F2::
gui,submit,nohide
if (tab_choosen=儲存模式 or (tab_choosen=自由點擊 and addfarm_toggle=1))
{
	return
}

if startx
{
	
	if tab_choosen=自由點擊
	{
		free_x:=round(abs(free_x))
		free_y:=round(abs(free_y))
		if free_x=0 or free_y=0
		{
			msgbox 行列設定錯誤
			return
		}
	
		MouseGetPos,endx,endy
		ToolTip, % "終點座標: " . endx . "," . endy
		
		
	}
	else if tab_choosen=大採購!!
	{
		buy_x:=round(abs(buy_x))
		buy_y:=round(abs(buy_y))
		if buy_x=0 or buy_y=0
		{
			msgbox 行列設定錯誤
			return
		}
		mousegetpos,endx,endy
		ToolTip, % "終點座標: " . endx . "," . endy
		
	}
	else
	{
			gosub, set_farminterval
			mousegetpos,endx,endy
			farmx:=round((scaley2*endx+scalex2*endy-scaley2*startx-scalex2*starty)/(scalex1*scaley2+scalex2*scaley1))
			farmy:=round((scaley1*endx+scalex1*starty-scalex1*endy-scaley1*startx)/(scalex1*scaley2+scalex2*scaley1))
			ToolTip, % "終點座標: " . endx . "," . endy . "`n" . "點擊數: " . abs(farmx)+1 . " × " . abs(farmy)+1 . " = " . (abs(farmx)+1)*(abs(farmy)+1), endx+20,endy+20
	}
	
	SetTimer, RemoveToolTip, 1500
	gosub,gui_renew_end

	
}
Else
{
	Tooltip, % "先按Alt+F1選取起點"
	SetTimer, RemoveToolTip, 1500
}

Return



Button清除範圍(Esc):
~esc::
start_pxl := "[]"
savefarm_pxl := "[]"
gui, 3: destroy
stop=1
ToolTip,中斷操作
SetTimer, RemoveToolTip, 1500
gosub,gui_zero
TrayTip
return

~!i::
run, farmville.ini
return

~^1::
guicontrol,,clicks,100
return
~^5::
guicontrol,,clicks,500
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GOSUB
;~ sickle_search:
;~ WinGetTitle,now_window,A
;~ if now_window contains farmville,訊息
;~ {

;~ x=0
;~ y=0

;~ MouseGetPos,mouse_x,mouse_y
;~ ImageSearch,x,y,% mouse_x+9,mouse_y+18,mouse_x+23,mouse_y+28 , pic\sickle.png
;~ if errorlevel=0
;~ {
	;~ mouseclick,left
;~ }

;~ }
;~ return


;~ settimer,find_coop,200
;~ find_coop:
;~ coop_x=
;~ coop_y=
;~ ImageSearch,coop_x,coop_y,0,0,%a_screenwidth%,%a_screenheight%,pic\coop.png
;~ MouseClick,left,% coop_x+5,coop_y+10,1,0
;~ return



;~ find_fallow_land:
;~ gui,3: hide
;~ gui, hide
;~ sleep 200
;~ WinGetTitle,fv_window_title,A
;~ if fv_window_title not contains farmville
;~ {
	;~ msgbox 非Farmville視窗！
	;~ return
;~ }
;~ WinGet,fv_window,id,A
;~ Xo := 0
;~ Yo := 0
;~ list := "" ; ensure "list" is blank

;~ Xo:=Yo:=0, list:=""
;~ Loop, {
   ;~ ImageSearch, OutputVarX, OutputVarY, %Xo%, %Yo%, %A_ScreenWidth%, %A_ScreenHeight%, pic\plot2.png
   ;~ If InStr(list, "[" OutputVarX "," OutputVarY "]") {
      ;~ Xo := OutputVarX+1
      ;~ Continue
   ;~ }   
   ;~ If(OutputVarX="" || OutputVarY="")
      ;~ If Xo {
         ;~ Xo := 0, Yo := Yo+1
         ;~ Continue
      ;~ } Else Break
   ;~ list .= "[" OutputVarX "," OutputVarY "]," , Yo := OutputVarY
;~ }   

;~ StringTrimRight,list,list,1
;~ gosub,gui_zero
;~ savefarm_pxl := "[" list "]"
;~ gosub,draw_temp_farm
;~ gui, show
;~ WinActivate,ahk_id %fv_window%
;~ return


cyclick:
gui, submit, nohide


;~ if pic1=
	;~ pic1=pic\cyclick\use.bmp
;~ if pic2=
	;~ pic2=pic\cyclick\right_arrow.bmp



if pic1=
{
	msgbox % "未選取圖片"
	return
}


set_value(rounds,0)
set_value(clicks1,1)
set_value(clicks2,1)
set_value(clicks3,1)
set_value(sleep1,100)
set_value(sleep2,100)
set_value(sleep3,100)
set_value(wait1,0)
set_value(wait2,0)
set_value(wait3,0)


loop % rounds
{
	loop % clicks1
	{
		if not find_pic2(pic1)
		{
			msgbox % "未找到圖片，停止點擊"
			return
		}
	}

	if not pic2=
	{

		if wait1>sleep1
			sleep % wait1-sleep1

		loop % clicks2
		{
			if not find_pic2(pic2)
			{
				msgbox % "未找到圖片，停止點擊"
				return
			}
		}
	}

	if not pic3=
	{

		if wait2>sleep2
			sleep % wait1-sleep1

		loop % clicks3
		{
			if not find_pic2(pic3)
			{
				msgbox % "未找到圖片，停止點擊"
				return
			}
		}
	}
	
	if wait3>sleep3
		sleep % wait3-sleep3
}


return

tab_select:
gui,submit,nohide
gosub,gui_zero
if tab_choosen=大採購!!
{
	gui,3: destroy
	savefarm_pxl:="[]"
}
return

gui_zero:
startx=
starty=
endx=
endy=
addfarm_toggle=1
farm_interval:="[[1,1]]"
guicontrol,,farm_mode_1,1
parallel_x1=
parallel_y1=
parallel_x2=
parallel_y2=
parallel_x3=
parallel_y3=
buy_button_x=
buy_button_y=
gosub,addfarm
gosub,gui_renew_start
gosub,gui_renew_start2
gosub,gui_renew_start3
GuiControl,text,end_pxl,% "4. Alt+F2 設定終點: (" . endx . "," . endy . ")                "
GuiControl,text,end_pxl3,% "3. Alt+F2 設定終點: (" . endx . "," . endy . ")                " 
guicontrol,text,parallel_pxl1,% "Ctrl+Alt+1: (" . parallel_x1 . "," . parallel_y1 . ")             " 
guicontrol,text,parallel_pxl2,% "Ctrl+Alt+2: (" . parallel_x2 . "," . parallel_y2 . ")             " 
guicontrol,text,parallel_pxl3,% "Ctrl+Alt+3: (" . parallel_x3 . "," . parallel_y3 . ")             " 
guicontrol,text,buy_button_pxl,% "(" . buy_button_x . "," . buy_button_y . ")                "
return

gui_farm_mode_radio:
	Gui, Add, Radio, x32 y100 w20 h30 vfarm_mode_1 Hwndradio1hwnd checked,
	Gui, Add, Radio, x32 y145 w20 h30 vfarm_mode_2, 
	Gui, Add, Radio, x132 y100 w20 h30 vfarm_mode_3, 
	Gui, Add, Radio, x132 y145 w50 h30 vfarm_mode_4, 其他:
	;~ guicontrol,,test_radio,1
	;~ msgbox % errorlevel . radio1hwnd
return

set_farminterval:
gui,submit,nohide
if tab_choosen=常規耕田
{
	if farm_mode_1=1
	{
		farm_interval:="[[1,1]]"
	}
	else if farm_mode_2=1
	{
		farm_interval:="[[2,2]]"
	}
	else if farm_mode_3=1
	{
		farm_interval:="[[3,3]]"
	}
	else if farm_mode_4=1
	{
		if ((farm_mode_other_x and !farm_mode_other_y) or (!farm_mode_other_x and farm_mode_other_y))
		{
			farm_interval:="[[" . farm_mode_other_x+farm_mode_other_y . "," . farm_mode_other_x+farm_mode_other_y . "]]"
		}
		else if (!farm_mode_other_x)
		{
			msgbox % "耕田模式設定錯誤"
			return
		}
		else 
		{
			farm_interval:="[[" . farm_mode_other_x . "," . farm_mode_other_y . "]]"
		}
		
	}	
	scalex1 := array_get(scales,1,1)*array_get(farm_interval,1,1)
	scaley1 := array_get(scales,1,2)*array_get(farm_interval,1,1)
	scalex2 := array_get(scales,1,3)*array_get(farm_interval,1,2)
	scaley2 := array_get(scales,1,4)*array_get(farm_interval,1,2)
}
return


draw_frame:
GetKeyState,state,MButton
if state = U
{
	SetTimer,draw_frame,off
	gui, 2: destroy
	Gdip_Shutdown(pToken)
}
Else
{
	MouseGetPos,frame_x3,frame_y3
	frame_x2 := (12*frame_x1+12*frame_x3-25*frame_y1+25*frame_y3)/24
	frame_y2 := (12*frame_x3+25*frame_y1+25*frame_y3-12*frame_x1)/50
	frame_x4 := (12*frame_x1+12*frame_x3+25*frame_y1-25*frame_y3)/24
	frame_y4 := (12*frame_x1-12*frame_x3+25*frame_y1+25*frame_y3)/50
	
	points := ""
	loop 4
	{
		points := points . frame_x%a_index% . "," . frame_y%a_index% . "|"
	}
	points := points . frame_x1 . "," . frame_y1
	
;~ 	msgbox % points
	
	If !pToken := Gdip_Startup()
	{
		if warning=0
		{
			MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
			warning++
		}
		SetTimer,draw_frame,off
		return
	}
	
	Width := A_ScreenWidth, Height := A_ScreenHeight
	Gui, 2: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
	Gui, 2: Show, NA
	hwnd2 := WinExist()
	hbm := CreateDIBSection(Width, Height)
	hdc := CreateCompatibleDC()
	obm := SelectObject(hdc, hbm)
	pGraphics := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetSmoothingMode(pGraphics, 4)
	pPen := Gdip_CreatePen(0x660000FF, 2)
	Gdip_DrawLines(pGraphics, pPen, points)
	UpdateLayeredWindow(hwnd2, hdc, 0, 0, Width, Height)
	Gdip_DeletePen(pPen)
	SelectObject(hdc, obm)
	DeleteObject(hbm)
	DeleteDC(hdc)
	Gdip_DeleteGraphics(pGraphics)

}
Return

update_farm_info:
GetKeyState,state,MButton
if state = U
{
	SetTimer,update_farm_info,off
}
Else
{
	if tab_choosen not contains 大採購
	{
		buy_x=4
		buy_y=4
	}
	
	scalex1:=array_get(scales,1,1)*buy_x/4*array_get(farm_interval,1,1)
	scaley1:=array_get(scales,1,2)*buy_x/4*array_get(farm_interval,1,1)
	scalex2:=array_get(scales,1,3)*buy_y/4*array_get(farm_interval,1,2)
	scaley2:=array_get(scales,1,4)*buy_y/4*array_get(farm_interval,1,2)
	
	MouseGetPos,endx,endy
	farmx:=round((scaley2*endx+scalex2*endy-scaley2*startx-scalex2*starty)/(scalex1*scaley2+scalex2*scaley1))
	farmy:=round((scaley1*endx+scalex1*starty-scalex1*endy-scaley1*startx)/(scalex1*scaley2+scalex2*scaley1))
	if(previous_farmx!=farmx or previous_farmy!=farmy)
	{
		ToolTip, % "目前座標: " . endx . "," . endy . "`n" . "點擊數: " . abs(farmx)+1 . " × " . abs(farmy)+1 . " = " . (abs(farmx)+1)*(abs(farmy)+1), endx+20,endy+20
		previous_farmx := farmx
		previous_farmy := farmy
	}
}
Return

gui_renew_start:
GuiControl,text,start_pxl,% "2. Alt+F1 設定起點: (" . startx . "," . starty . ")                "
return

gui_renew_start2:
GuiControl,text,start_pxl2,% "Alt+F1 設定起點(最左邊之點): (" . startx . "," . starty . ")                "
return

gui_renew_start3:
GuiControl,text,start_pxl3, % "2. Alt+F1 設定起點: (" . startx . "," . starty . ")                " 
return


gui_renew_end:
if addfarm_toggle
{
	if tab_choosen contains 自由點擊
	{
		freeadd_pxl:="[]"
		free_scale_x1:=(parallel_x2-parallel_x1)/(free_x-1)
		free_scale_y1:=(parallel_y2-parallel_y1)/(free_x-1)
		free_scale_x2:=(parallel_x3-parallel_x2)/(free_y-1)
		free_scale_y2:=(parallel_y3-parallel_y2)/(free_y-1)
		
		loop % free_x
		{
			ind_x:=A_Index-1
			loop % free_y
			{
				ind_y:=A_Index-1
				freeadd_pxl:=array_join(freeadd_pxl,"[[" . parallel_x1+ind_x*free_scale_x1+ind_y*free_scale_x2 . "," . parallel_y1+ind_x*free_scale_y1+ind_y*free_scale_y2 . "]]")
			}
		}			
		;~ msgbox % freeadd_pxl
		savefarm_pxl := array_join(savefarm_pxl,array_diff(freeadd_pxl,savefarm_pxl))
	}
	else 
	{
		if array_size(start_pxl)=0
		{
			start_pxl := array_join(start_pxl,"[[" . startx . "," . starty . "]]")
		}
		addfarm_pxl := "[[" . startx . "," . starty . "," . endx . "," . endy . "]]"
		addfarm_coor := pxl_to_coor(addfarm_pxl,array_get(start_pxl,1,1),array_get(start_pxl,1,2))
		;~ msgbox % coor_to_pxl(addfarm_coor,array_get(start_pxl,1,1),array_get(start_pxl,1,2))
		savefarm_pxl := array_join(savefarm_pxl,array_diff(coor_to_pxl(addfarm_coor,array_get(start_pxl,1,1),array_get(start_pxl,1,2)),savefarm_pxl))
	}
	addfarm_ind+=1
	
}
Else
{		
	delete_farm()
		
	if array_size(savefarm_pxl)=0
	{
		start_pxl := "[]"
		gosub addfarm
	}
	delfarm_ind+=1
}
;~ 	msgbox % savefarm_coor
GuiControl,text,end_pxl,% "4. Alt+F2 設定終點: (" . endx . "," . endy . ")                "
GuiControl,text,end_pxl3,% "3. Alt+F2 設定終點: (" . endx . "," . endy . ")                " 
;~ 	msgbox % savefarm_coor
gosub, draw_temp_farm
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

draw_temp_farm:

If !pToken := Gdip_Startup()
{
	if warning=0
	{
		MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
		warning++
	}
	SetTimer,draw_frame,off
	return
}

gui, 3: destroy

Width := A_ScreenWidth, Height := A_ScreenHeight
Gui, 3: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop +Disabled
Gui, 3: Show, NA
hwnd3 := WinExist()
hbm := CreateDIBSection(Width, Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
pGraphics := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(pGraphics, 4)

if tab_choosen=大採購!!
{
	i=0
	radius=1
	pPen := Gdip_CreatePen(0xff000000, 1)
	loop,parse,savefarm_pxl,`,,[]
	{
		if i=0
		{
			temp:=A_LoopField
			i=1
		}
		else
		{
			Gdip_DrawArc(pGraphics, pPen, temp-3, a_loopfield-radius, 2*radius, 2*radius,0,360)
			i=0
		}
		
	}
	Gdip_DeletePen(pPen)
}
else
{
	i=0
	pen_thickness=1
	radius=3
	loop,parse,savefarm_pxl,`,,[]
	{
		if i=0
		{
			temp:=A_LoopField
			i=1
		}
		else
		{
			pPen := Gdip_CreatePen(0xffffFFFF, pen_thickness)
			Gdip_DrawArc(pGraphics, pPen, temp-3, a_loopfield-radius, 2*radius, 2*radius,0,120)
			Gdip_DeletePen(pPen)
			pPen := Gdip_CreatePen(0xff000000, pen_thickness)
			Gdip_DrawArc(pGraphics, pPen, temp-3, a_loopfield-radius, 2*radius, 2*radius,120,120)
			Gdip_DeletePen(pPen)
			pPen := Gdip_CreatePen(0xffFF0000, pen_thickness)
			Gdip_DrawArc(pGraphics, pPen, temp-3, a_loopfield-radius, 2*radius, 2*radius,240,120)
			Gdip_DeletePen(pPen)
			i=0
		}
		
	}
}
UpdateLayeredWindow(hwnd3, hdc, 0, 0, Width, Height)
Gdip_DeletePen(pPen)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(pGraphics)

Return


add_del_toggle:
~^!z::
if 1
{
	if addfarm_toggle=0
	{
		gosub,addfarm
	}
	;~ else If array_size(savefarm_pxl)=0
	;~ {
		;~ msgbox 未選取農田
		;~ return
	;~ }
	Else
	{
		gosub,delfarm
	}
}
return

addfarm:
If 1
{
	;~ if addfarm_toggle!=1
	;~ {
		addfarm_toggle=1
		guicontrol,,增加範圍,1
		guicontrol,text,farm_add_text,% "→增加範圍"
		guicontrol,text,farm_del_text,% "　減少範圍"
		
	;~ }
}
Return

delfarm:
If 1
{
		addfarm_toggle=0
		guicontrol,,減少範圍,1
		guicontrol,text,farm_add_text,% "　增加範圍"
		guicontrol,text,farm_del_text,% "→減少範圍"
		
	If array_size(savefarm_pxl)=0
	{
		gosub, addfarm
		return
	}
}
Return

Button儲存範圍1:
save_farm(1)
return

Button儲存範圍2:
save_farm(2)
return

Button儲存範圍3:
save_farm(3)
return

Button儲存範圍4:
save_farm(4)
return

Button載入範圍1:
read_farm(1)
return

Button載入範圍2:
read_farm(2)
return

Button載入範圍3:
read_farm(3)
return

Button載入範圍4:
read_farm(4)
return

Button複製:
clipboard:="http://www.facebook.com/reqs.php"
return


ButtonGO!!(Alt+F3):
~!F3::
gui,submit
gui, 3: hide
WinActivate,ahk_id %fv_window%
sleep 50
start_click(savefarm_pxl)
gui,show
gui, 3: show
WinActivate,ahk_id %fv_window%
return

Button圖片1:
gui, +OwnDialogs
FileSelectFile, selectedfile, 3, pic\cyclick, 選擇圖片, 圖片檔 (*.gif; *.jpg; *.jpeg; *.bmp; *.png; *.tif; *.tiff; *.wmf; *.ico; *.cur; *.ani)
if selectedfile=
{
	return
}
else 
{
	guicontrol,,pic1, % selectedfile
}
return
Button圖片2:
gui, +OwnDialogs
FileSelectFile, selectedfile, 3, pic\cyclick, 選擇圖片, 圖片檔 (*.gif; *.jpg; *.jpeg; *.bmp; *.png; *.tif; *.tiff; *.wmf; *.ico; *.cur; *.ani)
if selectedfile=
{
	return
}
else 
{
	guicontrol,,pic2, % selectedfile
}
return
Button圖片3:
gui, +OwnDialogs
FileSelectFile, selectedfile, 3, pic\cyclick, 選擇圖片, 圖片檔 (*.gif; *.jpg; *.jpeg; *.bmp; *.png; *.tif; *.tiff; *.wmf; *.ico; *.cur; *.ani)
if selectedfile=
{
	return
}
else 
{
	guicontrol,,pic3, % selectedfile
}
return

SpamClick:
traytip,,滑鼠點擊
Click
return

;~ click_accept:
	;~ if accept_err>15
	;~ {
		;~ SetTimer,click_accept,off
		;~ SetTimer,click_yes,off
		;~ accept_stop=1
		;~ accept_err=0
		;~ msgbox 終止
		;~ return
	;~ }
		;~ WinActivate, ahk_id %accept_window%
		;~ ImageSearch,x2,y2,0,0,%a_screenwidth%,%a_screenheight%, % "pic\accept.png"
		;~ if errorlevel=0
		;~ {
			;~ mouseclick,left,x2,y2,1,0
			;~ accept_err=0
			;~ SetTimer,click_accept,off
			;~ SetTimer,click_yes,500
			;~ return
		;~ }
		;~ else
		;~ {
			;~ send {pgdn}
			;~ accept_err++
		;~ }
;~ return




;~ click_yes:
;~ if accept_err>15
;~ {
	;~ WinActivate, ahk_id %accept_window%
	;~ send !d
	;~ clipboard:="http://www.facebook.com/reqs.php"
	;~ send ^v{enter}
	;~ accept_err=0
	;~ SetTimer,click_yes,off
	;~ sleep 1500
	;~ SetTimer,click_accept,500
	
	;~ return
;~ }

;~ WinActivate, ahk_id %accept_window%
		;~ ImageSearch,x2,y2,0,0,%a_screenwidth%,%a_screenheight%, %  "pic\yes.png"
		;~ if errorlevel=0
		;~ {
			;~ mouseclick,left,x2,y2,1,0
			;~ accept_err=0
			;~ SetTimer,click_accept,500
			;~ SetTimer,click_yes,off
			;~ return
		;~ }
		;~ else
		;~ {
			;~ send {pgdn}
			;~ accept_err++
		;~ }

;~ return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCTION
set_value(byref a,value)
{
	if a is not number
	{
		a:=value
		return
	}
}

getSize(pic)
{
    static
    Gui,9: Add, Picture, vpicture1, %pic%
    Gui,9: Show, NA,getSize
    ControlGetPos, x, y, w, h, Static1, getSize

    Gui,9: destroy
    return % w "," h
}


find_pic2(pic,clicks=1,ms=200,clickx="",clicky="",x1=0,y1=0,x2="",y2="",try=100)
{
	found=0
	if x2=
		x2:=A_ScreenWidth
	if y2=
		y2:=A_ScreenHeight
	
	if (clickx="") or (clicky="")
	{
		pic_size:=getSize(pic)
		StringSplit,pic_size,pic_size,`,
		clickx:=pic_size1
		clicky:=pic_size2
	}
	
	
	loop % try
	{
		imagesearch,x,y,x1,y1,x2,y2,*10 %pic%
		if errorlevel=0
		{
			found=1
			break
		}
		sleep % ms
	}
	
	if found=0
	{
		return false
	}
	else
	{
		if clicks>0 
		{
			mouseclick, left, % x+clickx, y+clicky, clicks, 1
		} 
		else 
		{
			mousemove,% x+clickx, y+clicky, 1
		}
		
		
		return true
	}
}

delete_farm()
{
	global savefarm_pxl,startx,starty,endx,endy
		
	coorx1 := (48*endx+100*endy-48*startx-100*starty)
	coory1 := (48*endx+100*starty-48*startx-100*endy)
	
	temp := "[]"
	i=1
	loop,parse,savefarm_pxl,`,,[]
	{
		if i=1
		{
			x:=A_LoopField
		}
		else
		{
			y:=A_LoopField
			coorx2 := (48*x+100*y-48*startx-100*starty)
			coory2 := (48*x+100*starty-48*startx-100*y)
			if not (abs(coorx2)+abs(coorx2-coorx1)=abs(coorx1) and abs(coory2)+abs(coory2-coory1)=abs(coory1))
			{
				temp := array_join(temp,"[[" . x . "," . y . "]]")
			}
			i=0
		}
		i++
	}
	
	savefarm_pxl := temp
	
	
	return
}

array_unique(x)
{
	y:="[]"
	if(array_size(x)=0 or array_size(x)=1)
	{
		return x
	}
;~ 	StringTrimRight,x,x,1
;~ 	x := x . ",["
	StringReplace,x,x,]`,[,z,a
	loop,parse,x,z,[]
	{
		if not instr(y,"[" . a_loopfield . "]")
		{
			y := array_join(y,"[[" . a_loopfield . "]]")
		}
	}
	return y
}



pxl_to_coor(arr,coor_startx,coor_starty)
{
	
;~ 	StringTrimRight,arr,arr,2
;~ 	StringTrimLeft,arr,arr,2
;~ 	StringReplace,arr,arr,]`,[,z,A
	
	
	global scalex1,scaley1,scalex2,scaley2,tab_choosen,buy_x,buy_y,farm_interval,scales
	if tab_choosen not contains 大採購
	{
		buy_x=4
		buy_y=4
	}


	scalex1:=array_get(scales,1,1)*buy_x/4*array_get(farm_interval,1,1)
	scaley1:=array_get(scales,1,2)*buy_x/4*array_get(farm_interval,1,1)
	scalex2:=array_get(scales,1,3)*buy_y/4*array_get(farm_interval,1,2)
	scaley2:=array_get(scales,1,4)*buy_y/4*array_get(farm_interval,1,2)
	
	MouseGetPos,endx,endy

	
	if array_size(arr)=0
	{
		return arr
	}
	
	
	out_arr := "[]"
	
	
;~ 		msgbox % arr

;~ 	StringTrimRight,out_arr,out_arr,1

	i=1
	loop,parse,arr,`,,[]
	{
		loop,parse,a_loopfield,`,
		{
			if i=1
			{
				x1 := A_LoopField
			}
			else if i=2
			{
				y1 := A_LoopField
			}
			else if i=3
			{
				x2 := A_LoopField
			}
			else
			{
				y2 := A_LoopField
				coorx1 := round((scaley2*x1+scalex2*y1-scaley2*coor_startx-scalex2*coor_starty)/(scalex1*scaley2+scalex2*scaley1))
				coory1 := round((scaley1*x1+scalex1*coor_starty-scaley1*coor_startx-scalex1*y1)/(scalex1*scaley2+scalex2*scaley1))
				coorx2 := round((scaley2*x2+scalex2*y2-scaley2*coor_startx-scalex2*coor_starty)/(scalex1*scaley2+scalex2*scaley1))
				coory2 := round((scaley1*x2+scalex1*coor_starty-scaley1*coor_startx-scalex1*y2)/(scalex1*scaley2+scalex2*scaley1))
;~ 				msgbox % x1
				loop % abs(coorx2-coorx1)+1
				{
					t2:=a_index
					loop % abs(coory2-coory1)+1
					{
						t3:=a_index
;~ 						out_arr := out_arr . "[" . coorx1+(t2-1)*round((coorx2-coorx1)/abs(coorx2-coorx1)) . "," . coory1+(t3-1)*round((coory2-coory1)/abs(coory2-coory1)) . "],"
						out_arr := array_join(out_arr, "[[" . coorx1+(t2-1)*round((coorx2-coorx1)/abs(coorx2-coorx1)) . "," . coory1+(t3-1)*round((coory2-coory1)/abs(coory2-coory1)) . "]]")
;~ 					msgbox % out_arr
					}
				}
				i=0
			}
			i+=1
		}
		
	}
	
;~ 	StringTrimRight,out_arr,out_arr,1
;~ 	out_arr := out_arr . "]"
	return out_arr
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  差集合
array_diff(x,y)
{
	if(array_size(y)=0 or array_size(x)=0)
	{
		return x
	}

	
	StringTrimRight,y,y,1
	y := y . ",["
	StringReplace,y,y,]`,[,z,a
	
	
	loop,parse,y,z,[]
	{
		StringReplace,x,x,% "[" . a_loopfield . "]",,a
		if errorlevel=0
		{
			StringReplace,x,x,% ",,",`,,A
			StringReplace,x,x,% "[,",[,A
			StringReplace,x,x,% ",]",],A
		}
	}
	return x
}

array_size(x)
{
	if x=[]
	{
		return 0
	}
	
	StringTrimLeft,x,x,2
	StringTrimRight,x,x,1
	x := x . ",["
	
	
	StringReplace,x,x,]`,[,z,useerrorlevel
	return errorlevel
	
}

array_join(x,y)
{
	if array_size(x)=0
	{
		return y
	}
	if array_size(y)=0
	{
		return x
	}
	
	StringTrimRight,x,x,1
	StringTrimLeft,y,y,1
	return % x . "," . y
}


array_get(arr,x,y="")
{
	if(x>array_size(arr))
	{
		Return false
	}
	
	StringTrimLeft,arr,arr,2
	StringTrimRight,arr,arr,1
	arr := arr . ",["
	StringReplace,arr,arr,]`,[,z,A
	
	loop,parse,arr,z
	{
		if a_index=%x%
		{
			if y
			{
				loop,parse,a_loopfield,`,
				{
					if a_index=%y%
					{
						return a_loopfield
					}
				}
			}
			Else
			{
				return a_loopfield
			}
			Break
		}
	}
	return false
}


coor_to_pxl(x,startx,starty)
 {
	global scalex1,scaley1,scalex2,scaley2,tab_choosen,buy_x,buy_y,scales,farm_interval
	
	if tab_choosen not contains 大採購
	{
		buy_x=4
		buy_y=4
	}
	
	scalex1:=array_get(scales,1,1)*buy_x/4*array_get(farm_interval,1,1)
	scaley1:=array_get(scales,1,2)*buy_x/4*array_get(farm_interval,1,1)
	scalex2:=array_get(scales,1,3)*buy_y/4*array_get(farm_interval,1,2)
	scaley2:=array_get(scales,1,4)*buy_y/4*array_get(farm_interval,1,2)

	
	
	if array_size(x)=0
	{
		return x
	}
	
	y := "[]"
	
	i=0
	loop,parse,x,`,,[]
	{
		if i=0
		{
			temp:=A_LoopField
			i=1
		}
		else
		{
			y := array_join(y,"[[" . startx+scalex1*temp+scalex2*a_loopfield . "," . starty+scaley1*temp-scaley2*a_loopfield . "]]")
			i=0
		}
		
	}
	return y
}

start_click(savefarm_pxl)
{
	global tab_choosen,buy_button_x,buy_button_y,click_ms,stop,fv_window
	
	if array_size(savefarm_pxl)=0
	{
		msgbox 未選取農田
		return
	}
	
	if(tab_choosen=大採購!! and round(buy_button_x)=0)
	{
		msgbox 未設定購買按鈕座標
		return
	}

	i=0
	loop,parse,savefarm_pxl,`,,[]
	{
		if i=0
		{
			x:=A_LoopField
			i=1
		}
		else
		{
			y:=A_LoopField
			farm_str := farm_str . x . "," . y . ","
			i=0
		}
		
	}
	StringTrimRight,farm_str,farm_str,1
;~ 	StringSplit,farm_arr,farm_str,`,
;~ msgbox % farm_str
	ToolTip
	TrayTip,,執行中，請勿移動滑鼠`nEsc: 中斷操作`nAlt+Q: 結束程式,30
	
	
	if tab_choosen=大採購!!
	{
	
		stop=0
		i=0
		temp:=""
		Loop,parse,farm_str,`,
		{
			if stop 
			{
				Return
			}
			
			mousegetpos,,,fv_window
;~ 			WinGetTitle,fv_window_title,ahk_id %fv_window%
;~ 			if fv_window_title contains farmville
;~ 			{
				if i=0
				{
					temp:=A_LoopField
					i=1
				}
				Else
				{
					if market_button:=find_pic("pic\market.png")
					{
						mouseclick,left,% array_get(market_button,1,1),array_get(market_button,1,2),1,0
					}
					else
					{
						msgbox 終止點擊!!
						return
					}
					if stop
						return
					if not wait_pic("pic\market2.png")
					{
						msgbox 終止點擊!!
						return
					}
					if stop
						return
					sleep 100
					mouseclick,left,% buy_button_x,buy_button_y,1,0
					if stop
						return
					if not wait_pic("pic\market2.png")
					{
						msgbox 終止點擊!!
						return
					}
					if stop
						return
					sleep 100
					mouseclick,left,% temp,a_loopfield,1,0
					sleep 100
					i=0
				}
				
;~ 			}
;~ 			Else
;~ 			{
;~ 				send,{esc}
;~ 				Traytip
;~ 				return
;~ 			}
		}
	}
	else
	{
		stop=0
		i=0
		temp:=""
		Loop,parse,farm_str,`,
		{
			if stop 
			{
				Return
			}
			
			mousegetpos,,,fv_window
;~ 			WinGetTitle,fv_window_title,ahk_id %fv_window%
;~ 			if fv_window_title contains farmville
;~ 			{
				if i=0
				{
					temp:=A_LoopField
					i=1
				}
				Else
				{
					mouseclick,left,% temp,a_loopfield,1,0
					i=0
					sleep % click_ms
				}
				
;~ 			}
;~ 			Else
;~ 			{
;~ 				send,{esc}
;~ 				Traytip
;~ 				return
;~ 			}
		}
	}
	Tooltip,完成！
	SetTimer,RemoveToolTip,1500
	TrayTip
	Return
}

save_farm(num)
{
	
	global savefarm_pxl
	
	if array_size(savefarm_pxl)=0
	{
		msgbox 未選取農田
		return
	}
	
	IniWrite,%savefarm_pxl%,farmville.ini,farm%num%,farm_coor
	if ErrorLevel
	{
		msgbox, 儲存錯誤
		Return
	}
	else 
	{
		;~ gui, 3: destroy
		;~ Gdip_Shutdown(pToken)
		msgbox, 儲存成功！
	}
	
		
	Return
}

read_farm(num)
{
	global startx,starty,savefarm_pxl
	
	;~ msgbox % array_size(start_pxl)
	if not startx
	{
		msgbox 未選擇起點
		return
	}
	
		
	IniRead,savefarm_pxl,farmville.ini,farm%num%,farm_coor,[]
	if array_size(savefarm_pxl)=0
	{
		msgbox 無儲存資料
		Return
	}

	x1:=A_ScreenWidth
	y1:=A_ScreenHeight
	i=1
	loop,parse,savefarm_pxl,`,,[]
	{
		if i=1
		{
			if x1-a_loopfield>0
			{
				x1:=a_loopfield
				i=998
			}
			else 
			{
				i=-1
			}
		}
		if i=999
		{
			y1:=a_loopfield
			i=0
		}
		i++
	}		
	
	new_farm:="[]"
	i=0
	loop,parse,savefarm_pxl,`,,[]
	{
		if i=0
		{
			x:=A_LoopField
			i=1
		}
		else
		{
			y:=A_LoopField
			new_farm := array_join(new_farm,"[[" . startx+x-x1 . "," . starty+y-y1 . "]]")
			i=0
		}
	}
	
	savefarm_pxl:=new_farm
	gosub, draw_temp_farm
	return
}

find_pic(path)
{
	Loop,75
	{
		ImageSearch,x,y,0,0,% a_screenwidth,a_screenheight, %path%
		if not errorlevel
		{
			return "[[" . x . "," . y . "]]"
		}
		sleep 200
	}
	return 0
}

wait_pic(path)
{
	loop,75
	{
		ImageSearch,x,y,0,0,% a_screenwidth,a_screenheight, %path%
		if not errorlevel
		{
			return 1
		}
		sleep 200
	}
	return 0
}