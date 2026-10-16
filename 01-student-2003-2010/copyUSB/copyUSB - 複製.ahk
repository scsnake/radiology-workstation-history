#NoEnv
#SingleInstance,off
;~ #NoTrayIcon
SetBatchLines,-1



Gui, Font, S8 CDefault q5, Verdana

gui,add,text,,1. 來源 (如果裝置已存在，按下"開始等待"後便開始複製!)
gui,add,DropDownList,vsource,A:|B:|C:|D:|E:|F:|G:|H:|I:|J:|K:|L:|M:|N:|O:|P:|Q:|R:|S:|T:|U:|V:|W:|X:|Z:
gui,add,text,section,2. 
gui,add,button,ys,目的地
gui,add,edit,xs ReadOnly vdisk_info w300,
gui,add,text,,3. 檔案類型 (以逗號分隔，空白表示複製所有檔案)
gui,add,edit,w300 vfile_ext,ppt,pptx,doc,docx,pdf
gui,add,text,Section,4. 延遲複製:
gui,add,edit,w50 vwait_time_1 ys number,5
gui,add,text,ys,分鐘
gui,add,text,xs,(↑ 偵側到USB 至 開始複製 的時間)
gui,add,text,xs section,5. 複製時間:
gui,add,edit,w50 vwait_time_2 ys number,45
gui,add,text,ys,分鐘
gui,add,text,xs,(↑ 開始複製 至 強制結束 的時間)
gui,add,text,xs,Alt+Q: 結束程式
gui,font,bold
gui,add,button,section,開始等待
gui,font,norm
gui,add,text,ys,% a_tab a_tab a_tab "made by scsnake"


Gui, show,, 乾坤大挪移



Return




button目的地:
FileSelectFolder,destination,::{20d04fe0-3aea-1069-a2d8-08002b30309d} 
destination := RegExReplace(destination, "\\$")
DriveSpaceFree,freespace,% destination
GuiControl,text,disk_info,% destination "\copyUSB, 磁碟剩餘: " freespace "MB"
return

button開始等待:
gui,submit

if (!source and !destination and (!wait_time_1 or wait_time_1=0) and !wait_time_2)
{
	gui,show
	msgbox 選項不齊全!
	return
}

counts=0
file_ext_arr:=array()
if !file_ext
{
	file_ext_arr[1]:="*"
	counts=1
}
else
{
	loop,parse,file_ext,`,,%a_space%%a_tab%\/:*?<>|"
	{
		file_ext_arr[A_Index]:=A_LoopField
		counts++
	}
}

SetTimer,check_usb,1000
return

check_usb:
if copied
{
	ExitApp
}
if copying
{
	DriveGet,drive_label,label,% source
	if errorlevel
		ExitApp
	else
		return
}
else
{
	DriveGet,drive_label,label,% source
	if errorlevel
		return
	else
		SetTimer,copy,% wait_time_1*60*1000
		copying=1
}
return

copy:
SetTimer,copy,off
SetTimer,kill,% wait_time_2*60*1000

SetWorkingDir,% source
loop,*,2,1
{
	FileCreateDir,%destination%\copyUSB\%a_loopfilefullpath%
}

loop % counts
{
	search:="*." file_ext_arr[A_Index]
	loop,%search%,,1
	{
		DriveSpaceFree,freespace,% destination
		FileGetSize,filesize,%a_loopfilefullpath%,K
		if (freespace>(filesize/1024))
			filecopy,%A_LoopFileFullPath%,%destination%\copyUSB\%A_LoopFileFullPath%
	}
}

copied=1
return

kill:
GuiClose:
~!q::
ExitApp
Return