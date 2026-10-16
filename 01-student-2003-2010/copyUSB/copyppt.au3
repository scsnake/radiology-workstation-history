Opt("TrayIconHide",1)
Opt("WinTitleMatchMode", 2)
Opt("WinDetectHiddenText",1)

Global $paused
HotKeySet("{PAUSE}","_pausescript")
HotKeySet("^!z","_exitscript")

$log_path=@MyDocumentsDir&"\test\logppt.txt" ;記錄檔路徑

If Not FileExists($log_path) Then           ;如果記錄檔不存在則建立新檔
	FileClose(FileOpen($log_path,9))
EndIf


While WinExists("logppt")	;關閉開啟中的記錄檔
	WinClose("logppt")
WEnd

ShellExecute($log_path,"","","",@SW_HIDE)	;執行記錄檔(隱藏)
WinWait("logppt")

While 1
	
	If Not WinExists("error_monitor") Then
		ShellExecute("_error.exe")   		;au3->exe
		Sleep(100)
	EndIf

	
	If WinExists("PowerPoint") Then	;WinActive?
		$handle1=WinGetHandle("PowerPoint")
		Sleep(5000)
		$handle2=WinGetHandle("PowerPoint")
		If WinExists("PowerPoint") AND $handle1==$handle2 Then
			$oPPT = ObjGet("","PowerPoint.Application")			;取得檔案完整路徑
			For $o In $oPPT.Presentations         ;error occurs here !!
				$fullpath=$o.FullName
				$asc=StringTrimLeft(_SendUnicode($fullpath),1)	;轉成ASC格式(因controlsend不支援中文)
				If Not _SearchString("logppt","","Edit1",$fullpath) Then	;沒在記錄檔內的檔案才複製
					BlockInput(1)
					ControlSend("logppt","","Edit1","^{END}"&@YEAR&"/"&@MON&"/"&@MDAY&"-"&@HOUR&":"&@MIN&":"&@SEC&"{TAB}"&$asc&"{ENTER}^s")
					BlockInput(0)
					FileCopy($fullpath,@MyDocumentsDir&"\test\",8)
				EndIf
			Next
		EndIf
	EndIf
Sleep(100)
WEnd

Func  _SendUnicode($string)
    Local  $char
    Local  $code
    Local  $asc_string=.
   
    For  $i  =  1  to  StringLen($string)
        $char  =  StringMid($string,  $i,  1)
        $code  =  Asc($char)
        If  $code  >  127  Then
            $code  =  $code  *  256
            $i      =  $i  + 1
            $char  =  StringMid($string,  $i,  1)
            $code  =  $code +  Asc($char)
        EndIf
		$asc_string=$asc_string & "{ASC "  &  $code  &  "}"
    Next
	Return $asc_string
EndFunc

Func _SearchString($title,$text,$controlID,$string)
	Local $notepadtext
	$notepadtext=ControlGetText($title,$text,$controlID)
	$notepadtext=StringReplace(StringReplace($notepadtext,@CR,""),@LF,"")
	Return StringInStr($notepadtext,$string)
EndFunc

Func _pausescript()
	$paused = NOT $paused
	While $paused
		Sleep(100)
	WEnd
EndFunc

Func _exitscript()
	ShellExecute("_exit.exe")		;
	Exit
EndFunc