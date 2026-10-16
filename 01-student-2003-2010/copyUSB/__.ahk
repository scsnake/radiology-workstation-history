#SingleInstance ignore
#NoTrayIcon
DetectHiddenText,on
DetectHiddenWindows,on
settitlematchmode,2
pathindex=2							;copyppt.exe產生的gui的檔案路徑，在gui的control:static2,statics3,...
scriptstart=0						;只執行一次loop
;~ SetWorkingDir,%a_mydocuments%\test

~*lbutton::
~*enter::
if !scriptstart
{
	scriptstart=1

	Loop
	{
		process,exist,copyppt.exe 						;和copyppt.exe共存
		if !errorlevel
		{
			IfNotExist,%a_scriptdir%\copyppt.exe
			{
				send ^!+z
				exitapp
			}
			Else
			{
				run,copyppt.exe											
				process,wait,copyppt.exe
				send {lbutton}
			}
		}
		pathnow=								;變數們
		filename=
		filesize=
		diskspace=
		controlgettext,pathnow,static%pathindex%,copyppt,filestobecopy		;從gui取得檔案路徑
		if pathnow															;如果有路徑才動作
		{
			loop,parse,pathnow,\
			{
				filename=%a_loopfield%										;取得檔案名稱
			}
			if filename contains .pp
			{
				stringlen,filenamelength,filename
				StringTrimRight,pptdir,pathnow,%filenamelength%
				SetWorkingDir,%pptdir%										;將workingdir設定為ppt所在的資料夾
			}
			ifnotexist,%a_mydocuments%\test\*%filename%						;檔案不存在才動作
			{
				FileGetSize,filesize,%pathnow%,M							;磁碟空間是否足夠，不足夠則跳過這個檔案
				DriveSpaceFree,diskspace,%a_mydocuments%\test
				if diskspace<%filesize%
				{
					pathindex++
					Continue
				}
				filecopy,%pathnow%,%a_mydocuments%\test						;複製檔案
				pathindex++
			}
		}
		
		
		
		
		
		
		
		
		sleep 200
	}
}
return




~*^!+z::
exitapp