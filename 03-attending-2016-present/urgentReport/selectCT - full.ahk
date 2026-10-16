﻿﻿﻿;--------------include: F:\scripts\Autohotkey\Lib\CreateScript.ahk------------


CreateScript(script,pw:=""){


  static mScript


  StringReplace,script,script,`n,`r`n,A


  StringReplace,script,script,`r`r,`r,A


  If RegExMatch(script,"m)^[^:]+:[^:]+|[a-zA-Z0-9#_@]+\{}$"){


    If !(mScript){


      If (A_IsCompiled){


         lib := DllCall("GetModuleHandle", "ptr", 0, "ptr")


        If !(res := DllCall("FindResource", "ptr", lib, "str", ">AUTOHOTKEY SCRIPT<", "ptr", Type:=10, "ptr"))


          If !(res := DllCall("FindResource", "ptr", lib, "str", ">AHK WITH ICON<", "ptr", Type:=10, "ptr")){


            MsgBox Could not extract script!!!!


            return


          }


        DataSize := DllCall("SizeofResource", "ptr", lib, "ptr", res, "uint")


        ,hresdata := DllCall("LoadResource", "ptr", lib, "ptr", res, "ptr")


        ,pData := DllCall("LockResource", "ptr", hresdata, "ptr")


				,UnZipRawMemory(pData,DataSize,Data2,pw)?pData:=&Data2:""


        If (DataSize){


          mScript:=StrGet(pData,"UTF-8")


          StringReplace,mScript,mScript,`n,`r`n,A


          StringReplace,mScript,mScript,`r,`r`n,A


          StringReplace,mScript,mScript,`r`r,`r,A


          StringReplace,mScript,mScript,`n`n,`n,A


          mScript :="`r`n" mScript "`r`n"


        }


      } else {


        FileRead,mScript,%A_ScriptFullPath%


        StringReplace,mScript,mScript,`n,`r`n,A


        StringReplace,mScript,mScript,`r`r,`r,A


        mScript := "`r`n" mScript "`r`n"


        Loop,Parse,mScript,`n,`r


        {


          If A_Index=1


            mScript:=""


          If RegExMatch(A_LoopField,"i)^\s*#include"){


            temp:=RegExReplace(A_LoopField,"i)^\s*#include[\s+|,]")


            If InStr(temp,"%"){


              Loop,Parse,temp,`%


              {


                If (A_Index=1)


                  temp:=A_LoopField


                else if !Mod(A_Index,2)


                  _temp:=A_LoopField


                else {


                  _temp:=%_temp%


                  temp.=_temp A_LoopField


                  _temp:=""


                }


              }


            }


            If InStr(FileExist(trim(temp,"<>")),"D"){


				SetWorkingDir % trim(temp,"<>")


				continue


			} else if InStr(FileExist(temp),"D"){


				SetWorkingDir % temp


				continue


			} else If (SubStr(temp,1,1) . SubStr(temp,0) = "<>"){


              If !FileExist(_temp:=A_ScriptDir "\lib\" trim(temp,"<>") ".ahk")


                If !FileExist(_temp:=A_MyDocuments "\AutoHotkey\lib\" trim(temp,"<>") ".ahk")


                  If !FileExist(_temp:=SubStr(A_AhkPath,1,InStr(A_AhkPath,"\",1,0)) "lib\" trim(temp,"<>") ".ahk")


                    If FileExist(_temp:=SubStr(A_AhkPath,1,InStr(A_AhkPath,"\",1,0)) "lib.lnk"){


                      FileGetShortcut,_temp,_temp


                      _temp:=_temp "\" trim(temp,"<>") ".ahk"


                    }


				FileRead,_temp,%_temp%


		        mScript.= _temp "`r`n"


            } else {


				FileRead,_temp,%temp%


				mScript.= _temp "`r`n"


			}


          } else mScript.=A_LoopField "`r`n"


        }


      }


    }


    Loop,Parse,script,`n,`r


    {


      If A_Index=1


        script=


      else If A_LoopField=


        Continue


      If (RegExMatch(A_LoopField,"^[^:\s]+:[^:\s=]+$")){


        StringSplit,label,A_LoopField,:


        If (label0=2 and IsLabel(label1) and IsLabel(label2)){


          script .=SubStr(mScript


            , h:=InStr(mScript,"`r`n" label1 ":`r`n")


            , InStr(mScript,"`r`n" label2 ":`r`n")-h) . "`r`n"


        }


      } else if RegExMatch(A_LoopField,"^[^\{}\s]+\{}$"){


        StringTrimRight,label,A_LoopField,2


        script .= SubStr(mScript


          , h:=RegExMatch(mScript,"i)\n" label "\([^\)\n]*\)\n?\s*\{")


          , RegExMatch(mScript "`r`n","\n}\s*\K\n",1,h)-h) . "`r`n"


      } else


        script .= A_LoopField "`r`n"


    }


  }


  StringReplace,script,script,`r`n,`n,All


  Return Script


}


;--------------include: F:\scripts\Autohotkey\Lib\WinVisible.ahk------------


WinVisible(hwnd)


{


	WinGet, Style, Style ,ahk_id %hwnd%


	Transform, Result, BitAnd, %Style%, 0x10000000 ; 0x10000000 is WS_VISIBLE. 


	if Result <> 0 ;Window is Visible


		Return 1


	Else  ;Window is Hidden


		Return 0


}





controlvisible(hwnd){


	controlget,v,visible,,,ahk_id %hwnd%


	return v


}





GetNextWindow(hwnd,next=1,visibleWin=1){


	result:=hwnd


	Loop {


		result:=DllCall("GetWindow", UInt, result, UINT, next?2:3, UINT)


		if(!result)


			return


		else if(visibleWin && !WinVisible(result))


			continue


		else


			return result


	}	


}





/*


return.array: full list


return.index: index of hwnd in list


*/


GetWindowOrder(hwnd="",visibleWin=1){


	if !hwnd


		hwnd:=winexist("ahk_pid " DllCall("GetCurrentProcessId"))


	


	arr1:=[]


	arr2:=[]


	


	hwndP:=hwnd


	loop {


		hwndP:=GetNextWindow(hwndP,1,visibleWin)


		if(hwndP=hwnd || !hwndP)


			break


		else


			arr1.push(hwndP)


	}


	


	hwndN:=hwnd


	loop {


		hwndN:=GetNextWindow(hwndN,1,visibleWin)


		if(hwndN=hwnd || !hwndP)


			break


		else


			arr2.push(hwndN)


	}


	


	arr:=[],max:=arr1.maxIndex()


	loop % max


		arr.push(arr1[max+1-a_index])


	for k,v in arr2


		arr.push(v)


	


	return {array: arr, index: max+1}


	


}





WinInsertAfter(hwnd, after){


	return DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", after, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)


}





;first=top


WinStack(ByRef arr){


	for k,v in arr {


		if(k=1)


			winactivate,% v


		else if (v)


			WinInsertAfter(v, last)


		last:=v?v:last


	


	}


}


;--------------include: F:\scripts\Autohotkey\Lib\Edit.ahk------------


/*


Title: Edit Library v1.1


Group: Introduction


    This library is designed for use on the standard edit control.


Group: Issues/Consideration 


    A few considerations...


 -  Although many of the functions work on all types of edit


    controls -- single-line, multiline, and combo boxes (contains a single-line


    edit control) -- there are several functions that only work on one type of


    edit control.  See the documentation for each function for more information.


 -  AutoHotkey supports the creation and manipulation of the standard edit


    control. For this reason, there are a small number functions that were


    intentionally left out of this library because they provide no additional


    value to what the standard AutoHotkey commands provide.


 -  The edit control does not support several key messages that are needed by


    this library.  Absent messages include EM_GETSELTEXT, EM_GETTEXTRANGE, and


    EM_FINDTEXT.  These messages have been replaced with AutoHotkey commands or


    with other messages.  Although the substitute code/messages are very


    capable, they are not quite as efficient (memory and/or speed) as the


    messages they replace (if they existed).  These inefficiencies are not


    really noticable if the control only contains a limited amount of text


    (~512K or less), but they become more pronounced with increasing text sizes.


    Efficiency also depends on the where work in the control is being done.  For


    example, extracting text from the top of the control uses less resources


    that extracting text from the end of the control.


Group: Credit


    This library was inspired by the Edit mini-library created by *Lexikos* and


    the HiEditor library created by *majkinetor*.  Some of the syntax and code


    ideas were extracted from these libraries.  Thank to these authors for


    sharing their work.


Group: Functions


*/








;-----------------------------


;


; Function: Edit_CanUndo


;


; Description:


;


;   Returns TRUE if there are any actions in the edit control's undo queue,


;   otherwise FALSE.


;


;


;-------------------------------------------------------------------------------


Edit_CanUndo(hEdit)


    {


    Static EM_CANUNDO:=0xC6


    SendMessage EM_CANUNDO,0,0,,ahk_id %hEdit%


    Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_CharFromPos


;


; Description:


;


;   Gets information about the character and/or line closest to a specified


;   point in the the client area of the edit control.


;


;


; Parameters:


;


;   X, Y - The coordinates of a point in the edit control's client area


;       relative to the upper-left corner of the client area.


;


;   r_CharPos - The zero-based index of the character nearest the specified


;       point. [Optional] This index is relative to the beginning of the


;       control, not the beginning of the line. If the specified point is beyond


;       the last character in the edit control, the return value indicates the


;       last character in the control.  See the Remarks section for more


;       information.


;


;   r_LineIdx - Zero-based index of the line that contains the character.


;       [Optional] For single-line edit controls, this value is zero. The index


;       indicates the line delimiter if the specified point is beyond the last


;       visible character in a line.  See the Remarks section for more


;       information.


;


;


; Returns:


;


;   The value of the r_CharPos variable.


;


;


; Remarks:


;


;   If the specified point is outside the bounds of the edit control, all output


;   variables (Return, r_CharPos, and r_LineIdx) are set to -1.


;


;-------------------------------------------------------------------------------


Edit_CharFromPos(hEdit,X,Y,ByRef r_CharPos="",ByRef r_LineIdx="")


    {


    Static EM_CHARFROMPOS:=0xD7


    SendMessage EM_CHARFROMPOS,0,(Y<<16)|X,,ahk_id %hEdit%





    ;-- Out of bounds?


    if (ErrorLevel=0xFFFFFFFF)


        {


        r_CharPos:=-1


        r_LineIdx:=-1


        Return r_CharPos


        }





    ;-- Extract values (UShort)


    r_CharPos:=ErrorLevel & 0xFFFF  ;-- LOWORD


    r_LineIdx:=ErrorLevel>>16       ;-- HIWORD





    ;-- Convert to UInt using known UInt values as reference


    FirstLine:=Edit_GetFirstVisibleLine(hEdit)-1


    if (FirstLine>r_LineIdx)


        r_LineIdx:=r_LineIdx+(65536*Floor((FirstLine+(65535-r_LineIdx))/65536))





    FirstCharPos:=Edit_LineIndex(hEdit,FirstLine<0 ? 0:FirstLine)


    if (FirstCharPos>r_CharPos)


        r_CharPos:=r_CharPos+(65536*Floor((FirstCharPos+(65535-r_CharPos))/65536))





    Return r_CharPos


    }











;-----------------------------


;


; Function: Edit_Clear


;


; Description:


;


;   Delete (clear) the current selection, if any, from the edit control.


;


;


; Remarks:


;


;   Undo can be used to reverse this action.


;


;-------------------------------------------------------------------------------


Edit_Clear(hEdit)


    {


    Static WM_CLEAR:=0x303


    SendMessage WM_CLEAR,0,0,,ahk_id %hEdit%


    }











;-----------------------------


;


; Function: Edit_Convert2DOS


;


; Description:


;


;   Converts Unix, DOS/Unix mix, and Mac file formats to DOS format.


;


;-------------------------------------------------------------------------------


Edit_Convert2DOS(p_Text)


    {


    StringReplace p_Text,p_Text,`r`n,`n,All     ;-- Convert DOS to Unix


    StringReplace p_Text,p_Text,`r,`n,All       ;-- Convert Mac to Unix


    StringReplace p_Text,p_Text,`n,`r`n,All     ;-- Convert Unix to DOS


    Return p_Text


    }











;-----------------------------


;


; Function: Edit_Convert2Mac


;


; Description:


;


;   Convert DOS, DOS/Unix mix, and Unix file formats to Mac format.


;


;-------------------------------------------------------------------------------


Edit_Convert2Mac(p_Text)


    {


    StringReplace p_Text,p_Text,`r`n,`r,All     ;-- Convert DOS to Mac


    StringReplace p_Text,p_Text,`n,`r,All       ;-- Convert Unix to Mac


    if StrLen(p_Text)


        if p_Text not Contains `r


            p_Text .= "`r"





    Return p_Text


    }











;-----------------------------


;


; Function: Edit_Convert2Unix


;


; Description:


;


;   Convert DOS, DOS/Unix mix, and Mac formats to Unix format.


;


;-------------------------------------------------------------------------------


Edit_Convert2Unix(p_Text)


    {


    StringReplace p_Text,p_Text,`r`n,`n,All     ;-- Convert DOS to Unix


    StringReplace p_Text,p_Text,`r,`n,All       ;-- Convert Mac to Unix


    if StrLen(p_Text)


        if p_Text not Contains `n


            p_Text .= "`n"





    Return p_Text


    }











;-----------------------------


;


; Function: Edit_ConvertCase


;


; Description:


;


;   Convert case of selected text.


;


;


; Parameters:


;


;   p_Case - Set to "Upper", "Lower", "Capitalize", or "Toggle".


;


;-------------------------------------------------------------------------------


Edit_ConvertCase(hEdit,p_Case)


    {


    ;-- Collect current select postions


    Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)


    if (l_StartSelPos=l_EndSelPos)  ;-- Nothing selected


        Return





    ;-- Collect selected text


    l_SelectedText:=Edit_GetSelText(hEdit)


    if l_SelectedText is Space


        Return





    ;-- Convert


    if p_Case in U,Upper,Uppercase


        StringUpper l_SelectedText,l_SelectedText


     else


        if p_Case in L,Lower,Lowercase


            StringLower l_SelectedText,l_SelectedText


         else


            if p_Case in C,Capitalize,Title,TitleCase


                StringLower l_SelectedText,l_SelectedText,T


             else


                if p_Case in T,Toggle,ToggleCase,I,Invert,InvertCase


                    {


                    t_SelectedText=


                    Loop Parse,l_SelectedText


                        {


                        t_Char:=A_LoopField


                        l_Asc:=Asc(t_Char)


                        if l_Asc between 65 and 90


                            t_Char:=Chr(l_Asc+32)


                         else


                            if l_Asc between 97 and 122


                                t_Char:=Chr(l_Asc-32)





                        t_SelectedText .= t_Char


                        }





                    l_SelectedText:=t_SelectedText


                    }





    ;-- Replace selected text with converted text


    Edit_ReplaceSel(hEdit,l_SelectedText)





    ;-- Reselect to the user's original positions


    Edit_SetSel(hEdit,l_StartSelPos,l_EndSelPos)


    }











;-----------------------------


;


; Function: Edit_Copy


;


; Description:


;


;   Copy the current selection to the clipboard in CF_TEXT format.


;


;-------------------------------------------------------------------------------


Edit_Copy(hEdit)


    { 


    Static WM_COPY:=0x301 


    SendMessage WM_COPY,0,0,,ahk_id %hEdit%


    } 











;-----------------------------


;


; Function: Edit_Cut


;


; Description:


;


;   Delete the current selection, if any, and copy the deleted text to the


;   clipboard in CF_TEXT format.


;


;-------------------------------------------------------------------------------


Edit_Cut(hEdit)


    { 


    Static WM_CUT:=0x300


    SendMessage WM_CUT,0,0,,ahk_id %hEdit%


    }











;-----------------------------


;


; Function: Edit_EmptyUndoBuffer


;


; Description:


;


;   Resets the undo flag of the edit control. The undo flag is set whenever an


;   operation within the edit control can be undone.


;


;-------------------------------------------------------------------------------


Edit_EmptyUndoBuffer(hEdit)


    {


    Static EM_EMPTYUNDOBUFFER:=0xCD


    SendMessage EM_EMPTYUNDOBUFFER,0,0,,ahk_id %hEdit%


    }











;-----------------------------


;


; Function: Edit_FindText


;


; Description:


;


;   Find text within the edit control.


;


;


; Parameters:


;


;   p_SearchText - Search text.


;


;   p_Min, p_Max -  Zero-based search range within the edit control. p_Min is


;       the character index of the first character in the range and p_Max is the


;       character index immediately following the last character in the range.


;       (Ex: To search the first 5 characters of the text, set p_Min to 0 and


;       p_Max to 5)  Set p_Max to -1 to search to the end of the text. To search


;       backward, the roles and descriptions of the p_Min and p_Max are


;       reversed. (Ex: To search the first 5 characters of the control in


;       reverse, set p_Min to 5 and p_Max to 0)


;


;   p_Flags - Valid flags are as follows:


;


;       (Start code)


;       Flag        Description


;       ----        -----------


;       MatchCase   Search is case sensitive.  This flag is ignored if the


;                   "RegEx" flag is also defined.


;


;       RegEx       Regular expression search.


;


;       Static      [Advanced feature]


;                   Text collected from the edit control remains in memory is


;                   used to satisfy the search request.  The text remains in


;                   memory until the "Reset" flag is used or until the


;                   "Static" flag is not used.


;


;                   Advantages: Search time is reduced 10 to 60 percent


;                   (or more) depending on the size of the text in the control.


;                   There is no speed increase on the first use of the "Static"


;                   flag.


;


;                   Disadvantages: Any changes in the edit control are not


;                   reflected in the search.


;


;                   Bottom line: Don't use this flag unless performing multiple


;                   search requests on a control that will not be modified


;                   while searching.


;


;                   


;       Reset       [Advanced feature]


;                   Clears the saved text created by the "Static" flag so that


;                   the next use of the "Static" flag will get the text directly


;                   from the edit control.  To clear the saved memory without


;                   performing a search, use the following syntax:


;


;                       Edit_FindText("","",0,0,"Reset")


;       (end)


;


;


;   r_RegExOutput - Variable that contains the part of the source text that


;       matched the RegEx pattern. [Optional]


;


;


; Returns:


;


;       Zero-based character index of the first character of the match or -1 if


;       no match is found.


;


;


; Programming Notes:


;


;   Searching using regular expressions (RegEx) can produce results that have a


;   dynamic number of characters.  For this reason, searching for the "next"


;   pattern (forward or backward) may produce different results from developer


;   developer depending on how values of p_Min and p_Max are determined.


;


;-------------------------------------------------------------------------------


Edit_FindText(hEdit,p_SearchText,p_Min=0,p_Max=-1,p_Flags="",ByRef r_RegExOut="")


    {


    Static s_Text





    ;-- Initialize


    r_RegExOut:=""


    if InStr(p_Flags,"Reset")


        s_Text:=""





    ;-- Anything to search?


    if StrLen(p_SearchText)=0


        Return -1





    l_MaxLen:=Edit_GetTextLength(hEdit)


    if (l_MaxLen=0)


        Return -1





    ;-- Parameters


    if (p_Min<0 or p_Max>l_MaxLen)


        p_Min:=l_MaxLen





    if (p_Max<0 or p_Max>l_MaxLen)


        p_Max:=l_MaxLen





    ;-- Anything to search?


    if (p_Min=p_Max)


        Return -1





    ;-- Get text


    if InStr(p_Flags,"Static")


        {


        if StrLen(s_Text)=0


            s_Text:=Edit_GetText(hEdit)





        l_Text:=SubStr(s_Text,(p_Max>p_Min) ? p_Min+1:p_Max+1,(p_Max>p_Min) ? p_Max:p_Min)


        }


     else


        {


        s_Text:=""


        l_Text:=Edit_GetTextRange(hEdit,(p_Max>p_Min) ? p_Min:p_Max,(p_Max>p_Min) ? p_Max:p_Min)


        }





    ;-- Look for it


    if InStr(p_Flags,"RegEx")=0  ;-- Not RegEx


        l_FoundPos:=InStr(l_Text,p_SearchText,InStr(p_Flags,"MatchCase"),(p_Max>p_Min) ? 1:0)-1


     else  ;-- RegEx


        {


        p_SearchText:=RegExReplace(p_SearchText,"^P\)?","",1)   ;-- Remove P or P)


        if (p_Max>p_Min)  ;-- Search forward


            {


            l_FoundPos:=RegExMatch(l_Text,p_SearchText,r_RegExOut,1)-1


            if ErrorLevel


                {


                outputdebug,


                   (ltrim join`s


                    Function: %A_ThisFunc% - RegExMatch error.


                    ErrorLevel=%ErrorLevel%


                   )





                l_FoundPos:=-1


                }


            }


         else  ;-- Search backward


            {


            ;-- Programming notes:


            ;


            ;    -  The first search begins from the user-defined minimum


            ;       position. This will  establish the true minimum position to


            ;       begin search calculations. If nothing is found, no


            ;       additional searching is necessary.


            ;


            ;    -  The RE_MinPos, RE_MaxPos, and RE_StartPos variables contain


            ;       1-based values.


            ;


            RE_MinPos     :=1


            RE_MaxPos     :=StrLen(l_Text)


            RE_StartPos   :=RE_MinPos


            Saved_FoundPos:=-1


            Saved_RegExOut:=""


            loop


                {


                ;-- Positional search.  Last found match (if any) wins


                l_FoundPos:=RegExMatch(l_Text,p_SearchText,r_RegExOut,RE_StartPos)-1


                if ErrorLevel


                    {


                    outputdebug,


                       (ltrim join`s


                        Function: %A_ThisFunc% - RegExMatch error.


                        ErrorLevel=%ErrorLevel%


                       )





                    l_FoundPos:=-1


                    Break


                    }





                ;-- If found, update saved and RE_MinPos, else update RE_MaxPos


                if (l_FoundPos>-1)


                    {


                    Saved_FoundPos:=l_FoundPos


                    Saved_RegExOut:=r_RegExOut


                    RE_MinPos     :=l_FoundPos+2


                    }


                else


                    RE_MaxPos:=RE_StartPos-1





                ;-- Are we done?


                if (RE_MinPos>RE_MaxPos or RE_MinPos>StrLen(l_Text))


                    {


                    l_FoundPos:=Saved_FoundPos


                    r_RegExOut:=Saved_RegExOut


                    Break


                    }





                ;-- Calculate new start position


                RE_StartPos:=RE_MinPos+Floor((RE_MaxPos-RE_MinPos)/2)


                }


            }


        }





    ;-- Adjust FoundPos


    if (l_FoundPos>-1)


        l_FoundPos += (p_Max>p_Min) ? p_Min:p_Max





    Return l_FoundPos


    }











;--- Clears the saved text created by the "Static" flag. 


Edit_FindTextReset()


    {


    Edit_FindText("","",0,0,"Reset")


    }











;-----------------------------


;


; Function: Edit_FmtLines


;


; Description:


;


;   Sets a flag that determines whether a multiline edit control includes soft


;   line-break characters. A soft line break consists of two carriage returns


;   and a line feed and is inserted at the end of a line that is broken because


;   of word wrapping.


;


;


; Parameters:


;


;   p_Flag - Set to TRUE to insert soft line-break characters characters, FALSE


;       to removes them.


;


;


; Returns:


;


;   The value of p_Flag.


;


;


; Remarks:


;


;   This message has no effect on the display of the text within the edit


;   control.  It affects the buffer returned by the EM_GETHANDLE message and


;   the text returned by the WM_GETTEXT message.  Since the WM_GETTEXT message


;   is used by other functions in this library, be sure to un-format the text as


;   soon as possible.  Example of use:


;


;       (Start code)


;       Edit_FmtLines(hEdit,True)


;       FormattedText:=Edit_GetText(hEdit)


;       Edit_FmtLines(hEdit,False)


;       (end)


;


;-------------------------------------------------------------------------------


Edit_FmtLines(hEdit,p_Flag)


    {


    Static EM_FMTLINES:=0xC8


    SendMessage EM_FMTLINES,p_Flag,0,,ahk_id %hEdit%


    Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_GetFirstVisibleLine


;


; Description:


;


;   Returns the zero-based index of the uppermost visible line.  For single-line


;   edit controls, the return value is the zero-based index of the first visible


;   character.


;


;-------------------------------------------------------------------------------


Edit_GetFirstVisibleLine(hEdit)


    {


	Static EM_GETFIRSTVISIBLELINE:=0xCE


	SendMessage EM_GETFIRSTVISIBLELINE,0,0,,ahk_id %hEdit%


	Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_GetLastVisibleLine


;


; Description:


;


;   Returns the zero-based line index of the last visible line on the edit


;   control.


;


;


; Remarks:


;


;   To calculate the total number of visible lines, use the following...


;


;       (start code)


;       Edit_GetLastVisibleLine(hEdit) - Edit_GetFirstVisibleLine(hEdit) + 1


;       (end)


;


;-------------------------------------------------------------------------------


Edit_GetLastVisibleLine(hEdit)


    { 


    Edit_GetRect(hEdit,Left,Top,Right,Bottom)


    Return Edit_LineFromPos(hEdit,0,Bottom-1)


    }











;-----------------------------


;


; Function: Edit_GetLimitText


;


; Description:


;


;   Returns the current text limit for the edit control.


;


;


; Remarks:


;


;   Windows NT+: The maximum text length is 0x7FFFFFFE characters for


;   single-line edit controls and -1 for multiline edit controls.


;


;-------------------------------------------------------------------------------


Edit_GetLimitText(hEdit)


    {


    Static EM_GETLIMITTEXT:=0xD5


    SendMessage EM_GETLIMITTEXT,0,0,,ahk_id %hEdit%


    Return ErrorLevel<<32>>32


    }











;-----------------------------


;


; Function: Edit_GetLine


;


; Description:


;


;   Get the text of the desired line from the edit control.


;


;


; Parameters:


;


;   p_LineIdx - The zero-based index of the line to retrieve. [Optional] Use


;       -1 (the default) to get the current line.  This parameter is ignored if


;       used for a single-line edit control.


;


;   p_Length - Length of the line or length of the text to be extracted.


;       [Optional] Use -1 (the default) to automatically determine the length


;       of the line.


;


;


; Returns:


;


;   The text of the specified line.  The return value is an empty string if the


;   line number specified by the p_LineIdx parameter is greater than the number


;   of lines in the Edit control.


;


;-------------------------------------------------------------------------------


;~ Edit_GetLine(hEdit,p_LineIdx=-1,p_Length=-1)


    ;~ {


    ;~ Static EM_GETLINE:=0xC4


    ;~ if (p_LineIdx<0)


        ;~ p_LineIdx:=Edit_LineFromChar(hEdit,Edit_LineIndex(hEdit))





    ;~ if (p_Length>-1)


        ;~ l_Length:=p_Length


     ;~ else


        ;~ l_Length:=Edit_LineLength(hEdit,p_LineIdx)





    ;~ if l_Length=0


        ;~ Return





    ;~ VarSetCapacity(l_Text,l_Length=1 ? 2:l_Length,0)


    ;~ NumPut(l_Length=1 ? 2:l_Length,l_Text,0,"UShort")


    ;~ SendMessage EM_GETLINE,p_LineIdx,&l_Text,,ahk_id %hEdit%


    ;~ Return l_Length=1 ? SubStr(l_Text,1,1):l_Text


    ;~ }








Edit_GetLine(hEdit, p_LineIdx=-1,p_Length=-1){


    if(p_LineIdx=-1)


        p_LineIdx:=Edit_GetCurrentLineCount(hEdit)


    if(p_LineIdx<0)


        return 


    


    WinGetClass, class, ahk_id %hEdit%


    if(class="Scintilla"){


        hEdit:=new RemoteScintilla(hEdit)


        Text:=hEdit.GetLine(p_LineIdx)


        return p_Length=-1?(Text):SubStr(Text,1, p_Length)


    }


    


    controlget,Text,line,% p_LineIdx+1,,% "ahk_id " hEdit


    if(p_Length!=-1)


        Text:=SubStr(Text,1,p_Length)


    return Text 


}





; 0-based


Edit_GetCurrentLineCount(hEdit){


    WinGetClass, class, ahk_id %hEdit%


    if(class="Scintilla"){


        hEdit:=new RemoteScintilla(hEdit)


        return hEdit.LineFromPosition()


    }


    ControlGet, line, CurrentLine,,,% "ahk_id " hEdit


    return line-1


}








;-----------------------------


;


; Function: Edit_GetLineCount


;


; Description:


;


;   Returns an integer specifying the total number of text lines in a multiline


;   edit control.  If the control has no text, the return value is 1.  The


;   return value will never be less than 1.


;


;


; Remarks:


;


;   The value returned is for the number of lines in the edit control. Very long


;   lines (>1024) or word wrap may introduce additional lines to the control.


;


;-------------------------------------------------------------------------------


Edit_GetLineCount(hEdit)


    {


	Static EM_GETLINECOUNT:=0xBA


   	SendMessage EM_GETLINECOUNT,0,0,,ahk_id %hEdit%


	Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_GetMargins


;


; Description:


;


;   Gets the widths of the left and right margins for the edit control.  If


;   defined, these values are returned in the r_LeftMargin and r_RightMargin


;   variables.


;


;


; Parameters:


;


;   r_LeftMargin - Left margin, in pixels. [Optional]


;   r_RightMargin - Right margin, in pixels. [Optional]


;


;


; Returns:


;


;   The edit control's left margin


;


;-------------------------------------------------------------------------------


Edit_GetMargins(hEdit,ByRef r_LeftMargin="",ByRef r_RightMargin="")


    {


    Static EM_GETMARGINS:=0xD4


    SendMessage EM_GETMARGINS,0,0,,ahk_id %hEdit%


    r_LeftMargin :=ErrorLevel & 0xFFFF      ;-- LOWORD of result


    r_RightMargin:=ErrorLevel>>16           ;-- HIWORD of result


    Return r_LeftMargin  ; ##### --------------------------------------- Really?


    }











;-----------------------------


;


; Function: Edit_GetModify


;


; Description:


;


;   Gets the state of the edit control's modification flag.  The flag indicates


;   whether the contents of the edit control have been modified.  Returns TRUE


;   if the control has been modified, otherwise FALSE.


;


;-------------------------------------------------------------------------------


Edit_GetModify(hEdit)


    {


    Static EM_GETMODIFY:=0xB8


    SendMessage EM_GETMODIFY,0,0,,ahk_id %hEdit%


    Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_GetRect


;


; Description:


;


;   Gets the formatting rectangle of the edit control.


;


;


; Parameters:


;


;   r_Left..r_Bottom - Output variables. [Optional]


;


;


; Returns:


;


;   Space separated rectangle.


;


;-------------------------------------------------------------------------------


Edit_GetRect(hEdit,ByRef r_Left="",ByRef r_Top="",ByRef r_Right="",ByRef r_Bottom="")


    {


    Static EM_GETRECT:=0xB2


    VarSetCapacity(RECT_Structure,16,0)


    SendMessage EM_GETRECT,0,&RECT_Structure,,ahk_id %hEdit%


    r_Left  :=NumGet(RECT_Structure,0,"Int")


    r_Top   :=NumGet(RECT_Structure,4,"Int")


    r_Right :=NumGet(RECT_Structure,8,"Int")


    r_Bottom:=NumGet(RECT_Structure,12,"Int")


    Return r_Left . A_Space . r_Top . A_Space . r_Right . A_Space . r_Bottom


    }











;-----------------------------


;


; Function: Edit_GetSel


;


; Description:


;


;   Gets the starting and ending character positions of the current selection in


;   the edit control.  If defined, these values are returned in


;   the r_StartSelPos and r_EndSelPos variables.


;


;


; Parameters:


;


;   r_StartSelPos - Starting position of the selection. [Optional]


;   r_EndSelPos - Ending position of the selection. [Optional]


;


;


; Returns:	


;


;   Starting position of the selection.


;


;-------------------------------------------------------------------------------


Edit_GetSel(hEdit,ByRef r_StartSelPos="",ByRef r_EndSelPos="", startBeforeEnd=true)


    {


        WinGetClass,class,ahk_id %hEdit%


        if (class="Scintilla") {


            hEdit:=new RemoteScintilla(hEdit)


            r_EndSelPos:=hEdit._getCurrentPos()


            r_StartSelPos:=hEdit._getAnchor() 


            


            


            


        }else{


            Static EM_GETSEL:=0xB0


            VarSetCapacity(l_StartSelPos,4,0)


            VarSetCapacity(l_EndSelPos,4,0)


            SendMessage EM_GETSEL,&l_StartSelPos,&l_EndSelPos,,ahk_id %hEdit%


            r_StartSelPos:=NumGet(l_StartSelPos)


            r_EndSelPos  :=NumGet(l_EndSelPos)


        }


        if(startBeforeEnd && r_EndSelPos<r_StartSelPos){


            swap:=r_StartSelPos


            r_StartSelPos:=r_EndSelPos


            r_EndSelPos:=swap


        }


        return r_StartSelPos


    


    }











;-----------------------------


;


; Function: Edit_GetSelText


;


; Description:


;


;   Returns the currently selected text (if any).


;


;


; Remarks:


;


;   Since the edit control does not support the EM_GETSELTEXT message, the


;   EM_GETLINE (if the selection is on one line) and the WM_GETTEXT messages are


;   used instead.


;


;-------------------------------------------------------------------------------


Edit_GetSelText(hEdit,l_startSelPos="",l_endSelPos="")


    {


        WinGetClass,class,ahk_id %hEdit%


        if (class="Scintilla") {


            hEdit:=new RemoteScintilla(hEdit)


            return hEdit.getSelText()


            


        }


    if l_startselpos= || l_endselpos=


        Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)


    if (l_StartSelPos=l_EndSelPos)


        Return





    ;-- Get line indexes of the selection


    l_FirstSelectedLine:=Edit_LineFromChar(hEdit,l_StartSelPos)


    l_LastSelectedLine :=Edit_LineFromChar(hEdit,l_EndSelPos)





    ;-- Get selected text


    l_FirstPos:=Edit_LineIndex(hEdit,l_FirstSelectedLine)


     if (l_FirstSelectedLine=l_LastSelectedLine)


    and (l_EndSelPos<=l_FirstPos+Edit_LineLength(hEdit,l_FirstSelectedLine))


        Return SubStr(Edit_GetLine(hEdit,l_FirstSelectedLine,l_EndSelPos-l_FirstPos),l_StartSelPos-l_FirstPos+1)


     else


        Return SubStr(Edit_GetText(hEdit,l_EndSelPos),l_StartSelPos+1)


    }











;-----------------------------


;


; Function: Edit_GetText


;


; Description:


;


;   Returns all text from the control up to p_Length length.  If p_Length=-1


;   (the default), all text is returned.


;


;


; Remarks:


;


;   This function is similar to the AutoHotkey *GUIControlGet* command (for AHK


;   GUI's) and the *ControlGetText* command except that end-of-line (EOL)


;   characters from the retrieved text are not automatically converted


;   (CR+LF to LF).  If needed, use the <Edit_Convert2Unix> function to convert


;   the text to the AutoHotkey text format.


;


;-------------------------------------------------------------------------------


Edit_GetText(hEdit,p_Length=-1)


    {


        WinGetClass,class,ahk_id %hEdit%


        if (class="Scintilla") {


            hEdit:=new RemoteScintilla(hEdit)


            return hEdit.GetText()


            


        }


    Static WM_GETTEXT:=0xD





    if (p_Length<0)


        p_Length:=Edit_GetTextLength(hEdit)





    VarSetCapacity(l_Text,p_Length+1,0)


    SendMessage WM_GETTEXT,p_Length+1,&l_Text,,ahk_id %hEdit%


    return l_Text


    }











;-----------------------------


;


; Function: Edit_GetTextLength


;


; Description:


;


;   Returns the length, in characters, of the text in the edit control.


;


;-------------------------------------------------------------------------------


Edit_GetTextLength(hEdit)


    {


	Static WM_GETTEXTLENGTH:=0xE


	SendMessage WM_GETTEXTLENGTH,0,0,,ahk_id %hEdit%


	Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_GetTextRange


;


; Description:


;


;   Get a range of characters.


;


;


; Parameters:


;


;   p_Min - Character position index immediately preceding the first character


;       in the range.


;


;   p_Max - Character position immediately following the last character in the


;       range.  Set to -1 to indicate the end of the text.


;


;


; Remarks:


;


;   Since the edit control does not support the EM_GETTEXTRANGE message, the


;   <Edit_GetText> function (WM_GETTEXT message) is used to collect the desired


;   range of characters.


;


;-------------------------------------------------------------------------------


Edit_GetTextRange(hEdit,p_Min=0,p_Max=-1)


    {


    Return SubStr(Edit_GetText(hEdit,p_Max),p_Min+1)


    }











;-----------------------------


;


; Function: Edit_IsMultiline


;


; Description:


;


;   Returns TRUE if the edit control is multiline, otherwise FALSE.


;


;-------------------------------------------------------------------------------


Edit_IsMultiline(hEdit)


    {


    Static ES_MULTILINE:=0x4


    Return Edit_IsStyle(hEdit,ES_MULTILINE)


    }











;-----------------------------


;


; Function: Edit_IsReadOnly


;


; Description:


;


;   Returns TRUE if the ES_READONLY style has been set, otherwise FALSE.


;


;-------------------------------------------------------------------------------


Edit_IsReadOnly(hEdit)


    {


    Static ES_READONLY:=0x800


    Return Edit_IsStyle(hEdit,ES_READONLY)


    }











;-----------------------------


;


; Function: Edit_IsStyle


;


; Description:


;


;   Returns TRUE if the specified style has been set, otherwise FALSE.


;


;


; Parameters:


;


;   p_Style - Style of the edit control.


;


;   Some common edit control styles...


;


;   (start code)


;   ES_LEFT       :=0x0         ;-- Can't actually check this style.  It's the lack of ES_CENTER or ES_RIGHT.


;   ES_CENTER     :=0x1


;   ES_RIGHT      :=0x2


;   ES_MULTILINE  :=0x4


;   ES_UPPERCASE  :=0x8


;   ES_LOWERCASE  :=0x10


;   ES_PASSWORD   :=0x20        ;-- Single-line edit control only


;   ES_AUTOVSCROLL:=0x40


;   ES_AUTOHSCROLL:=0x80


;   ES_NOHIDESEL  :=0x100


;   ES_COMBO      :=0x200


;   ES_OEMCONVERT :=0x400


;   ES_READONLY   :=0x800


;   ES_WANTRETURN :=0x1000


;   ES_NUMBER     :=0x2000


;   WS_TABSTOP    :=0______


;   WS_HSCROLL    :=0x100000


;   WS_VSCROLL    :=0x200000 


;   (end)


;


;-------------------------------------------------------------------------------


Edit_IsStyle(hEdit,p_Style)


    {


    Static GWL_STYLE:=-16


    ControlGet l_Style,Style,,,ahk_id %hEdit%


;;;;;    l_Style:=DllCall("GetWindowLong","Ptr",hEdit,"Int",GWL_STYLE)


    Return l_Style & p_Style ? True:False


    }











;-----------------------------


;


; Function: Edit_SetStyle


;


; Description:


;


;   Adds, removes, or toggles a style for an edit control.


;


;


; Parameters:


;


;   p_Style - Style to set.


;


;   p_Option - Use "+" (the default) to add, "-" to remove, and "^" to toggle.


;


;


; Returns:


;


;   TRUE if the request completed successfully, otherwise FALSE.


;


;


; Remarks:


;


; Styles that can be modified after the edit control has been created include


;   the following:


;


;       (start code)


;       ES_UPPERCASE  :=0x8 


;       ES_LOWERCASE  :=0x10


;       ES_PASSWORD   :=0x20    ;-- Use the Edit_SetPasswordChar function


;       ES_OEMCONVERT :=0x400


;       ES_READONLY   :=0x800   ;-- Use the Edit_SetReadOnly function


;       ES_WANTRETURN :=0x1000


;       ES_NUMBER     :=0x2000


;       (end)


;


; Use the <Edit_IsStyle> function to determine if a style is currently set.


;


;-------------------------------------------------------------------------------


Edit_SetStyle(hEdit,p_Style,p_Option="+")


    {


    Control Style,%p_Option%%p_Style%,,ahk_id %hEdit%


    Return ErrorLevel ? False:True


    }











;-----------------------------


;


; Function: Edit_LineFromChar


;


; Description:


;


;   Gets the index of the line that contains the specified character index.


;


;


; Parameters:


;


;   p_CharPos - The character index of the character contained in the line


;       whose number is to be retrieved. [Optional] If ?1 (the default), the


;       function retrieves either the line number of the current line (the line


;       containing the caret) or, if there is a selection, the line number of


;       the line containing the beginning of the selection.


;


;


; Returns:


;


;   The zero-based line number of the line containing the character index


;   specified by p_CharPos.


;


;-------------------------------------------------------------------------------


Edit_LineFromChar(hEdit,p_CharPos=-1)


    {


	Static EM_LINEFROMCHAR:=0xC9


   	SendMessage EM_LINEFROMCHAR,p_CharPos,0,,ahk_id %hEdit%


	Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_LineFromPos


;


; Description:


;


;   This function is the same as <Edit_CharFromPos> except the line index 


;   (r_LineIdx) is returned.


;


;-------------------------------------------------------------------------------


Edit_LineFromPos(hEdit,X,Y,ByRef r_CharPos="",ByRef r_LineIdx="")


    {


    Edit_CharFromPos(hEdit,X,Y,r_CharPos,r_LineIdx)


    Return r_LineIdx


    }











;-----------------------------


;


; Function: Edit_LineIndex


;


; Description:


;


;   Gets the character index of the first character of a specified line.


;


;


; Parameters:


;


;   p_LineIdx - Zero-based line number. [Optional] Use -1 (the default) for the


;       current line.


;


;


; Returns:


;


;   The character index of the specified line or -1 if the specified line is 


;   greater than the total number of lines in the edit control.


;


;-------------------------------------------------------------------------------


Edit_LineIndex(hedit,p_LineIdx=-1)


    {


    Static EM_LINEINDEX:=0xBB


    SendMessage EM_LINEINDEX,p_LineIdx,0,,ahk_id %hEdit%


    Return ErrorLevel<<32>>32


    }











;-----------------------------


;


; Function: Edit_LineLength


;


; Description:


;


;   Gets the length of a line.


;


;


; Parameters:


;


;   p_LineIdx - The zero-based line index of the desired line.  Use -1


;       (the default) for the current line.


;


;


; Returns:


;


;   The length, in characters, of the specified line.  If p_LineIndex is greater


;   than the total number of lines in the edit control, the length of the last


;   (or only) line is returned.


;


;-------------------------------------------------------------------------------


Edit_LineLength(hEdit,p_LineIdx=-1)


    {


	Static EM_LINELENGTH:=0xC1





    l_CharPos:=Edit_LineIndex(hEdit,p_LineIdx)


    if (l_CharPos<0)  ;-- Invalid p_LineIdx


        l_CharPos:=Edit_LineIndex(hEdit,Edit_GetTextLength(hEdit)-1)





	SendMessage EM_LINELENGTH,l_CharPos,0,,ahk_id %hEdit% 


	Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_LineScroll


;


; Description:


;


;   Scrolls the text in the edit control for the current file.


;


;


; Parameters:


;


;   xScroll - The number of characters to scroll horizontally.  Use a negative


;       number to scroll to the left and a positive number to scroll to the


;       right.


;


;   yScroll - The number of lines to scroll vertically.  Use a negative number


;       to scroll up and a positive number to scroll down.


;


;


; Returns:


;


;   TRUE if sent to a multiline edit control, otherwise FALSE.


;


;-------------------------------------------------------------------------------


Edit_LineScroll(hEdit,xScroll=0,yScroll=0)


    {


    Static EM_LINESCROLL:=0xB6


    SendMessage EM_LINESCROLL,xScroll,yScroll,,ahk_id %hEdit%


    Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_LoadFile


;


; Description:


;


;   Load the contents of a file to the edit control.


;


;


; Parameters:


;


;   p_FileName - The full path and name of the file.


;


;   p_Convert2DOS - If TRUE, the text will be converted from Unix, DOS/Unix mix,


;       or Mac format, to DOS format before it is loaded to the edit control.


;       [Optional]


;


;   r_FileFormat - Contains the file format variable. [Optional]  This variable


;       is set to the file format of loaded file - "DOS", "Unix", or "Mac".


;       This information is useful if the contents of the edit control will be


;       be converted back to the original file format when the file is saved.


;


;


; Returns:


;


;   TRUE if successful, otherwise FALSE.


;


;


; Remarks:


;


;   This request will replace the entire edit control with the contents of the


;   the requested file.  Consequently, the Undo buffer is flushed.


;


;-------------------------------------------------------------------------------


Edit_LoadFile(hEdit,p_FileName,p_Convert2DOS=False,ByRef r_FileFormat="")


    {


    IfNotExist %p_FileName%


        {


        outputdebug Function: %A_ThiSFunc% - File "%p_FileName%" not found


        Return False


        }





    ;-- Load contents of file into variable


    FileRead l_Text,%p_FileName%


    if ErrorLevel


        {


        outputdebug Function: %A_ThiSFunc% - Unable to read from "%p_FileName%"


        Return False


        }





    ;-- Determine file format


    if l_Text Contains `r`n


        {


        r_FileFormat:="DOS"


        outputdebug DOS file format detected


        }


     else


        if l_Text Contains `n


            {


            r_FileFormat:="UNIX"


            outputdebug Unix file format detected


            }


         else


            if l_Text Contains `r


                {


                r_FileFormat:="MAC"


                outputdebug Mac file format detected


                }


             else


                {


                r_FileFormat:="DOS"


                outputdebug NO EOL character detected. DOS file format assumed.


                }








    ;-- Convert file format?


    if p_Convert2DOS


        l_Text:=Edit_Convert2DOS(l_Text)





    ;-- Load text to edit control


    Return Edit_SetText(hEdit,l_Text)


    }











;-----------------------------


;


; Function: Edit_Paste


;


; Description:


;


;   Copies the current content of the clipboard to the edit control at the


;   current caret position.  Data is inserted only if the clipboard contains


;   data in CF_TEXT format.


;


;-------------------------------------------------------------------------------


Edit_Paste(hEdit)


    { 


    Static WM_PASTE:=0x302


    SendMessage WM_PASTE,0,0,,ahk_id %hEdit%


    } 











;-----------------------------


;


; Function: Edit_PosFromChar


;


; Description:


;


;   Gets the client area coordinates of a specified character in the edit


;   control.


;


;


; Parameters:


;


;   p_CharPos - The zero-based index of the character.


;


;   X, Y - These parameters, which must contain valid variable names, are used


;       to return the x/y-coordinates of a point in the Edit control's client


;       relative to the upper-left corner of the client area.


;


;


; Remarks:


;


;   If p_CharPos is greater than the index of the last character in the


;   control, the returned coordinates are of the position just past the last


;   character of the control.


;


;-------------------------------------------------------------------------------


Edit_PosFromChar(hEdit,p_CharPos,ByRef X,ByRef Y)


    {


    Static EM_POSFROMCHAR:=0xD6


    SendMessage EM_POSFROMCHAR,p_CharPos,0,,ahk_id %hEdit%


    X:=(ErrorLevel & 0xFFFF)<<48>>48


        ;-- LOWORD of result and converted from UShort to Short


    Y:=(ErrorLevel>>16)<<48>>48


        ;-- HIWORD of result and converted from UShort to Short


    }











;-----------------------------


;


; Function: Edit_ReplaceSel


;


; Description:


;


;   Replaces the selected text with the specified text.  If there is no


;   selection, the replacement text is inserted at the caret.


;


;


; Parameters:


;


;   p_Text - Text to replace selection with.


;   p_CanUndo - If TRUE (the default), replace can be undone.


;


;-------------------------------------------------------------------------------


Edit_ReplaceSel(hEdit,p_Text="",p_CanUndo=True)


    {


	Static EM_REPLACESEL:=0xC2


	SendMessage EM_REPLACESEL,p_CanUndo,&p_Text,,ahk_id %hEdit% 


    }











;-----------------------------


;


; Function: Edit_SaveFile


;


; Description:


;


;   Save the contents of the edit control to a file.  If the file does not


;   exist, it will be created.


;


;


; Parameters:


;


;   p_FileName - The full path and name of the file.


;


;   p_Convert - Convert file format. [Optional] Set to "M" or "Mac" to convert


;       to Mac.  Set to "U" or "Unix" to convert to Unix.


;


;


; Returns:


;


;   TRUE if successful, otherwise FALSE.


;


;-------------------------------------------------------------------------------


Edit_SaveFile(hEdit,p_FileName,p_Convert="")


    {


    ;-- Delete if file exists


    IfExist %p_FileName%


        {


        FileDelete %p_FileName%


        if ErrorLevel


            {


            outputdebug Function: %A_ThisFunc% - Unable to delete "%p_FileName%"


            Return False        


            }


        }





    ;-- Get text


    l_Text:=Edit_GetText(hEdit)





    ;-- If requested, convert file format


    if p_Convert in M,Mac


        l_Text:=Edit_Convert2Mac(l_Text)





    if p_Convert in U,Unix


        l_Text:=Edit_Convert2Unix(l_Text)





    ;-- Save it


    FileAppend %l_Text%,*%p_FileName%  ;-- Save in binary mode


    if ErrorLevel


        {


        outputdebug Function: %A_ThisFunc% - Unable to save to "%p_FileName%"


        Return False        


        }





    Return True


    }











;-----------------------------


;


; Function: Edit_Scroll


;


; Description:


;


;   Scrolls the text vertically in the edit control.


;


;


; Parameters:


;


;   p_Pages - The number of pages to scroll.  Use a negative number to scroll up


;       and a positive number to scroll down.


;


;   p_Lines - The number of lines to scroll.  Use a negative number to scroll up


;       and a positive number to scroll down.


;


;


; Returns:


;


;   The number of lines that the command scrolls. The value will be negative if


;   scrolling up and positive if scrolling down.


;


;-------------------------------------------------------------------------------


Edit_Scroll(hEdit,p_Pages=0,p_Lines=0)


    {


    Static EM_SCROLL  :=0xB5


          ,SB_LINEUP  :=0x0     ;-- Scroll up one line


          ,SB_LINEDOWN:=0x1     ;-- Scroll down one line


          ,SB_PAGEUP  :=0x2     ;-- Scroll up one page


          ,SB_PAGEDOWN:=0x3     ;-- Scroll down one page





    ;-- Initialize


    l_ScrollLines:=0





    ;-- Pages


    Loop % Abs(p_Pages)


        {


        SendMessage EM_SCROLL,(p_Pages>0) ? SB_PAGEDOWN:SB_PAGEUP,0,,ahk_id %hEdit%


        if not ErrorLevel


            Break





        l_ScrollLines:=l_ScrollLines+((ErrorLevel & 0xFFFF)<<48>>48)


            ;-- LOWORD of result and converted from UShort to Short


        }





    ;-- Lines


    Loop % Abs(p_Lines)


        {


        SendMessage EM_SCROLL,(p_Lines>0) ? SB_LINEDOWN:SB_LINEUP,0,,ahk_id %hEdit%


        if not ErrorLevel


            Break





        l_ScrollLines:=l_ScrollLines+((ErrorLevel & 0xFFFF)<<48>>48)


            ;-- LOWORD of result and converted from UShort to Short


        }





    Return l_ScrollLines


    }











;-----------------------------


;


; Function: Edit_ScrollCaret


;


; Description:


;


;   Scrolls the edit control until caret is visible.


;


;-------------------------------------------------------------------------------


Edit_ScrollCaret(hEdit)


    {


        WinGetClass,class,ahk_id %hEdit%


        if (class="Scintilla") {


            hEdit:=new RemoteScintilla(hEdit)


            hEdit.ScrollCaret()


            return


        }


	Static EM_SCROLLCARET:=0xB7


	SendMessage EM_SCROLLCARET,0,0,,ahk_id %hEdit% 


    }











;-----------------------------


;


; Function: Edit_SetLimitText


;


; Description:


;


;   Sets the text limit of the edit control.


;


;


; Parameters:


;


;   p_Limit - The maximum number of characters the user can enter.  


;       Windows NT+: If this parameter is zero, the text length is set to


;       0x7FFFFFFE characters for single-line edit controls or ?1 for multiline


;       edit controls.


;


;


; Remarks:


;


; - This message limits only the text the user can enter. It does not affect any


;   text already in the edit control when the message is sent, nor does it


;   affect the length of the text copied to the edit control by the WM_SETTEXT


;   message. For more information: 


;


;       <http://msdn.microsoft.com/en-us/library/bb761607(VS.85).aspx>


;


; - For AutoHotkey GUI's, use the +Limitnn and -Limit options.


;


; - Although this message can be sent to any edit control, not all programs will


;   respond well to a limit change.


;


;-------------------------------------------------------------------------------


Edit_SetLimitText(hEdit,p_Limit)


    {


    Static EM_LIMITTEXT:=0xC5


    SendMessage EM_LIMITTEXT,p_Limit,0,,ahk_id %hEdit%


    }











;-----------------------------


;


; Function: Edit_SetMargins


;


; Description:


;


;   Sets the width of the left and/or right margin (in pixels) for the edit


;   control. The message automatically redraws the control to reflect the new


;   margins.


;


;


; Parameters:


;


;   p_LeftMargin - Left margin, in pixels. If blank, the left margin is not set.


;       Specify the EC_USEFONTINFO value (0xFFFF or 65535) to set the left


;       margin to a narrow width calculated using the text metrics of the


;       control's current font. If no font has been set for the control, the


;       margin is set to zero.


;


;   p_RightMargin - Right margin, in pixels.  If blank, the right margin is not


;       set.  Specify the EC_USEFONTINFO value (0xFFFF or 65535) to set the


;       right margin to a narrow width calculated using the text metrics of the


;       control's current font. If no font has been set for the control, the


;       margin is set to zero.


;


;-------------------------------------------------------------------------------


Edit_SetMargins(hEdit,p_LeftMargin="",p_RightMargin="")


    {


    Static EM_SETMARGINS :=0xD3


          ,EC_LEFTMARGIN :=0x1


          ,EC_RIGHTMARGIN:=0x2


          ,EC_USEFONTINFO:=0xFFFF





    l_Margins:=0


    l_Flags  :=0


    if p_LeftMargin is Integer


        {


        l_Flags |= EC_LEFTMARGIN


        l_Margins |= p_LeftMargin       ;-- LOWORD


        }





    if p_RightMargin is Integer


        {


        l_Flags |= EC_RIGHTMARGIN


        l_Margins |= p_RightMargin<<16  ;-- HIWORD


        }





    if l_Flags


        SendMessage EM_SETMARGINS,l_Flags,l_Margins,,ahk_id %hEdit%


    }











;-----------------------------


;


; Function: Edit_SetModify


;


; Description:


;


;   Sets or clears the modification flag for the edit control. The modification


;   flag indicates whether the text within the control has been modified.


;


;


; Parameters:


;


;   p_Flag - Set to TRUE to set the modification flag. Set to FALSE to clear the


;       modification flag.


;


;-------------------------------------------------------------------------------


Edit_SetModify(hEdit,p_Flag)


    {


    Static EM_SETMODIFY:=0xB9


    SendMessage EM_SETMODIFY,p_Flag,0,,ahk_id %hEdit%


    }











;-----------------------------


;


; Function: Edit_SetPasswordChar


;


; Description:


;


;   Sets or removes the password character for a single-line edit control.


;


;


; Parameters:


;


;   p_Char - The character that is displayed in place of the characters typed by


;       the user. [Optional] The default is an asterisk ("*").  Set to null


;       ("") to remove the password character.


;


;


; Returns:


;


;   Documented: This message does not return a value.  Undocumented and/or does


;   not apply to all OS versions:  Returns TRUE if successful or "FAIL" if


;   unsuccessful.


;


;


; Remarks:


;


; - This request adds or removes the ES_Password style to/from a single-line


;   edit control.  Use the <Edit_IsStyle> function to determine if the


;   ES_PASSWORD style has been set.


;


; - Observation:  On Windows 2000+, the ES_Password style cannot be removed once


;   added unless the request is made from the same process that created the


;   control.


;


; - For AutoHotkey GUI's, use the +Password and -Password options to add/remove


;   ES_PASSWORD style unless a password character other than "*" is desired.


;


;-------------------------------------------------------------------------------


Edit_SetPasswordChar(hEdit,p_Char="*")


    {


    Static EM_SETPASSWORDCHAR:=0xCC


    SendMessage EM_SETPASSWORDCHAR,Asc(p_Char),0,,ahk_id %hEdit%


    Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_SetReadOnly


;


; Description:


;


;   Sets or removes the read-only style (ES_READONLY) of the edit control.


;


;


; Parameters:


;


;   p_Flag - Set to TRUE to add the ES_READONLY style.  Set to FALSE to remove


;       the ES_READONLY style.


;


;


; Returns:


;


;   TRUE if successful, otherwise FALSE.


;


;


; Remarks:


;   


;   For AutoHotkey GUIs, this is same as using the +ReadOnly or -ReadOnly 


;   option when creating the Edit control or using the GUIControl command after


;   the edit control has been created.  For example:


;


;       (start code)


;       GUIControl +ReadOnly,Edit1


;       (end code)


;


;-------------------------------------------------------------------------------


Edit_SetReadOnly(hEdit,p_Flag)


    {


    Static EM_SETREADONLY:=0xCF


    SendMessage EM_SETREADONLY,p_Flag,0,,ahk_id %hEdit%


    Return ErrorLevel ? True:False


    }











;-----------------------------


;


; Function: Edit_SetRect


;


; Description:


;


;   Sets the formatting rectangle of a multiline edit control. The formatting


;   rectangle is the limiting rectangle into which the control draws the text.


;   The limiting rectangle is independent of the size of the edit control


;   window.


;


;


; Parameters:


;


;   p_Left..p_Bottom - Coordinates.


;


;


; Remarks:


;


;   Advanced feature. For additional information, see the following...


;


;       <http://msdn.microsoft.com/en-us/library/bb761657(VS.85).aspx>


;


;-------------------------------------------------------------------------------


Edit_SetRect(hEdit,p_Left,p_Top,p_Right,p_Bottom)


    {


    Static EM_SETRECT:=0xB3





    VarSetCapacity(RECT_Structure,16,0)


    NumPut(p_Left,  RECT_Structure,0,"Int")


    NumPut(p_Top,   RECT_Structure,4,"Int")


    NumPut(p_Right, RECT_Structure,8,"Int")


    NumPut(p_Bottom,RECT_Structure,12,"Int")


    SendMessage EM_SETRECT,0,&RECT_Structure,,ahk_id %hEdit%


    }











;-----------------------------


;


; Function: Edit_SetTabStops


;


; Description:


;


;   Sets the tab stops in a multiline edit control. When text is copied to the


;   control, any tab character in the text causes space to be generated up to


;   the next tab stop.


;


;


; Parameters:


;


;   p_NbrOfTabStops - Number of tab stops. [Optional] Set to 0 (the default) to


;       set the tab stops to the system default.  Set to 1 to have all tab stops


;       set to the value of the p_DTU parameter or 32 if p_DTU is not defined.


;       Any value greater than 1 will set that number of tab stops.


;


;   p_DTU - Dialog Template Units. [Optional] If p_NbrOfTabStops=0, this


;       parameter is ignored.  If this parameter contains a single value


;       (Ex: 21), all tab stops will be set to a factor of this value


;       (Ex: 21, 42, 63, etc.).  Otherwise, this parameter should contain values


;       for all requested tab stops each separated by a comma ","


;       (Ex: "20,45,70,125").


;


;


; Returns:


;


;   TRUE if all the tabs are set, otherwise FALSE.


;


;-------------------------------------------------------------------------------


Edit_SetTabStops(hEdit,p_NbrOfTabStops=0,p_DTU=32)


    {


    Static EM_SETTABSTOPS:=0xCB


    


    VarSetCapacity(l_TabStops,p_NbrOfTabStops*4,0)


    if p_DTU contains ,,


        {


        Loop Parse,p_DTU,`,,%A_Space%


            if (A_Index<=p_NbrOfTabStops)


                Numput(A_LoopField+0,l_TabStops,(A_Index-1)*4,"UInt")


        }


     else


        Loop %p_NbrOfTabStops%


            NumPut(p_DTU*A_Index,l_TabStops,(A_Index-1)*4,"UInt")





    SendMessage EM_SETTABSTOPS,p_NbrOfTabStops,&l_TabStops,,ahk_id %hEdit%


    Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_SetText


;


; Description:


;


;   Set the text of the edit control.  Returns TRUE if successful, otherwise


;   FALSE.


;


;


; Remarks:


;


; - The system automatically resets the undo flag whenever an edit control


;   receives a WM_SETTEXT message.  Use the <Edit_SetSel> (select all) and


;   <Edit_ReplaceSel> functions to populate the control if undo is desired.


;


; - This function is the same as the AutoHotkey *ControlSetText* command except


;   there is no delay after the command has executed.


;


;-------------------------------------------------------------------------------


Edit_SetText(hEdit,p_Text)


    {


        WinGetClass,class,ahk_id %hEdit%


        if (class="Scintilla") {


            hEdit:=new RemoteScintilla(hEdit)


            return hEdit.SetText(p_Text)


            


        }


    Static WM_SETTEXT:=0xC


    SendMessage WM_SETTEXT,0,&p_Text,,ahk_id %hEdit%


    Return ErrorLevel


    }











;-----------------------------


;


; Function: Edit_SetSel


;


; Description:


;


;   Selects a range of characters.


;


;


; Parameters:


;


;   p_StartSelPos - Starting character position of the selection. If set to -1,


;       the current selection (if any) will be deselected.


;


;   p_EndSelPos	- Ending character position of the selection. Set to -1 to use


;       the position of the last character in the control.


;


;-------------------------------------------------------------------------------


Edit_SetSel(hEdit,p_StartSelPos=0,p_EndSelPos=-1)


    {


        WinGetClass,class,ahk_id %hEdit%


        if (class="Scintilla") {


            hEdit:=new RemoteScintilla(hEdit)


            return hEdit._SetSel(p_StartSelPos, p_EndSelPos)


            


        }


	Static EM_SETSEL:=0x0B1


	SendMessage EM_SETSEL,p_StartSelPos,p_EndSelPos,,ahk_id %hEdit%


    }











;-----------------------------


;


; Function: Edit_TextIsSelected


;


; Description:


;


;   Returns TRUE if text is selected, otherwise FALSE.


;


;-------------------------------------------------------------------------------


Edit_TextIsSelected(hEdit)


    {


    Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)


    Return (l_StartSelPos<>l_EndSelPos)


    }











;-----------------------------


;


; Function: Edit_Undo


;


; Description:


;


;   Undo the last operation.  Returns TRUE if the Undo operation succeeds,


;   otherwise FALSE.


;


;


; Returns:


;


;   For a single-line edit control, the return value is always TRUE.  For a


;   multiline edit control, the return value is TRUE if the undo operation is


;   successful, otherwise FALSE.


;


;-------------------------------------------------------------------------------


Edit_Undo(hEdit)


    {


	Static EM_UNDO:=0xC7


	SendMessage EM_UNDO,0,0,,ahk_id %hEdit%


	Return ErrorLevel


    }











;**************************


;*                        *


;*    Helper functions    *


;*                        *


;**************************





;-----------------------------


;


; Function: Edit_GetActiveHandles


;


; Description:


;


;   Finds the handles for the active control and active window.


;


;


; Parameters:


;


;   hEdit - Variable that contains the handle of the active edit control.  


;       [Optional] Value is zero if the active control is not an edit control.


;


;   hWindow - Variable that contains the handle of the active window. [Optional]


;


;   p_MsgBox - Display error message. [Optional] If TRUE, an error MsgBox is


;       displayed if the active control is not an edit control.


;


;


; Returns:


;


;   Handle of the active edit control or FALSE (0) if the active control is not


;   an edit control.


;


;-------------------------------------------------------------------------------


Edit_GetActiveHandles(ByRef hEdit="",ByRef hWindow="",p_MsgBox=False)


    {


    WinGet hWindow,ID,A


    ControlGetFocus l_Control,A


    if SubStr(l_Control,1,4)="Edit"


        {


        ControlGet hEdit,hWnd,,%l_Control%,A


        Return hEdit


        }





    if p_MsgBox


        MsgBox


            ,262160


                ;-- 262160 = 0 (OK button) + 16 ("Error" icon) + 262144 (AOT) 


            ,Error


            ,This request cannot be performed on this control.  %A_Space%


 


    Return False


    }





Edit_SelectLine(hEdit, line=0, include_newline=false)


{


    control:="",wintitle:="ahk_id " hEdit


    ControlGet, hwnd, Hwnd,, %Control%, %WinTitle%


    if (!WinExist("ahk_id " hwnd))


        return false


    if (line<1)


        ControlGet, line, CurrentLine


    SendMessage, 0xBB, line-1, 0


    offset := ErrorLevel


    SendMessage, 0xC1, offset, 0


    lineLen := ErrorLevel


    if (include_newline) {


        WinGetClass, class


        lineLen += (class="Edit") ? 2 : 1


    }


    SendMessage, 0xB1, offset, offset+lineLen


    Edit_SCROLLCARET(hEdit)


    return (ErrorLevel != "FAIL")


}





Edit_InsertText(hEdit, ByRef Text, pos=-1){


    WinGetClass, class, ahk_id %hEdit%


    if(class="Scintilla"){


        hEdit:=new RemoteScintilla(hEdit)


        hEdit._InsertText(Text, pos)


        return 


    }


    Edit_GetSel(hEdit, s, e)


    oldText:=Edit_GetText(hEdit)


    if(pos=-1)


        pos:=StrLen(oldText)


    Edit_SetText(hEdit, SubStr(oldText,1,pos) Text (pos=-1?"":SubStr(oldText,pos+1)))


    Edit_SetSel(hEdit, s<=pos?s:s+pos, e>=pos?e+pos:e)


    


}


;--------------include: F:\scripts\Autohotkey\Lib\SetTimerF.ahk------------


/* 32bit


SetTimerF( Function, Period=0, ParmObject=0, Priority=0 ) { 


 Static current,tmrs:=Object() ;current will hold timer that is currently running


 If IsFunc( Function ) {


    if IsObject(tmr:=tmrs[Function]) ;destroy timer before creating a new one


       ret := DllCall( "KillTimer", UInt,0, UInt, tmr.tmr)


       , DllCall("GlobalFree", UInt, tmr.CBA)


       , tmrs.Delete(Function) 


    if (Period = 0 || Period ? "off")


       return ret ;Return as we want to turn off timer


	 ; create object that will hold information for timer, it will be passed trough A_EventInfo when Timer is launched


    tmr:=tmrs[Function]:=Object("func",Function,"Period",Period="on" ? 250 : Period,"Priority",Priority


								,"OneTime",(Period<0),"params",IsObject(ParmObject)?ParmObject:Object()


								,"Tick",A_TickCount)


    tmr.CBA := RegisterCallback(A_ThisFunc,"F",4,&tmr)


    return !!(tmr.tmr  := DllCall("SetTimer", UInt,0, UInt,0, UInt


								, (Period && Period!="On") ? Abs(Period) : (Period := 250)


								, UInt,tmr.CBA)) ;Create Timer and return true if a timer was created


				, tmr.Tick:=A_TickCount


 }


 tmr := Object(A_EventInfo) ;A_Event holds object which contains timer information


 if IsObject(tmr) {


	 DllCall("KillTimer", UInt,0, UInt,tmr.tmr) ;deactivate timer so it does not run again while we are processing the function


	 If (!tmr.active && tmr.Priority<(current.priority ? current.priority : 0)) ;Timer with higher priority is already current so return


		 Return (tmr.tmr:=DllCall("SetTimer", UInt,0, UInt,0, UInt, 100, UInt,tmr.CBA)) ;call timer again asap


	 current:=tmr


	 tmr.tick:=ErrorLevel :=Priority ;update tick to launch function on time


	 tmr.func(tmr.params*) ;call function


	 current= ;reset timer


    if (tmr.OneTime) ;One time timer, deactivate and delete it


       return DllCall("GlobalFree", UInt,tmr.CBA)


				 ,tmrs.Delete(tmr.func)


	 tmr.tmr:= DllCall("SetTimer", UInt,0, UInt,0, UInt ;reset timer


				,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), UInt,tmr.CBA)


 }


}


*/








SetTimerF( Function, Period=0, ParmObject=0, Priority=0 ) { 


 Static current,tmrs:=[] ;current will hold timer that is currently running


 If IsFunc( Function ) {


    if IsObject(tmr:=tmrs[Function]) ;destroy timer before creating a new one


       ret := DllCall( "KillTimer", PTR,0, PTR, tmr.tmr)


       , DllCall("GlobalFree", PTR, tmr.CBA)


       , tmrs.Delete(Function) 


    if (Period = 0 || Period = "off")


       return ret ;Return as we want to turn off timer


	 ; create object that will hold information for timer, it will be passed trough A_EventInfo when Timer is launched


    tmr:=tmrs[Function]:={func:Function,Period:Period="on" ? 250 : Period,Priority:Priority


								,OneTime:Period<0,params:IsObject(ParmObject)?ParmObject:Object()


								,Tick:A_TickCount}


    tmr.CBA := RegisterCallback(A_ThisFunc,"F",4,&tmr)


    return !!(tmr.tmr  := DllCall("SetTimer", PTR,0, PTR,0, UInt


								, (Period && Period!="On") ? Abs(Period) : (Period := 250)


								, PTR,tmr.CBA,"PTR")) ;Create Timer and return true if a timer was created


				, tmr.Tick:=A_TickCount


 }


 tmr := Object(A_EventInfo) ;A_Event holds object which contains timer information


 if IsObject(tmr) {


	 DllCall("KillTimer", PTR,0, PTR,tmr.tmr) ;deactivate timer so it does not run again while we are processing the function


	 If (current && tmr.Priority<current.priority) ;Timer with higher priority is already current so return


		 Return (tmr.tmr:=DllCall("SetTimer", PTR,0, PTR,0, UInt, 100, PTR,tmr.CBA,"PTR")) ;call timer again asap


	 current:=tmr


	 ,tmr.tick:=ErrorLevel :=Priority ;update tick to launch function on time


	 ,tmr.func(tmr.params*) ;call function


    if (tmr.OneTime) ;One time timer, deactivate and delete it


       return DllCall("GlobalFree", PTR,tmr.CBA)


				 ,tmrs.Delete(tmr.func)


	 tmr.tmr:= DllCall("SetTimer", PTR,0, PTR,0, UInt ;reset timer


				,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), PTR,tmr.CBA,"PTR")


	 current= ;reset timer


 }


}





class SetTimerF_class {


SetTimer( Function, Period=0, ParmObject=0, Priority=0 ) { 


    Static tmrs:=[] ; will hold timers that are currently running


    If IsFunc( Function ) {


      if IsObject(tmr:=tmrs[this]) ;destroy timer before creating a new one


        ret := DllCall( "KillTimer", "UInt",0, "UInt", tmr.tmr)


        , DllCall("GlobalFree", "UInt", tmr.CBA)


        , ObjRemove(tmrs,this)


      if (Period = 0 || Period = "off")


        return ret ;Return as we want to turn off timer


      ; create object that will hold information for timer, it will be passed trough A_EventInfo when Timer is launched


      tmr:=tmrs[this]:={func:Function,ref:this,Period:Period="on" ? 250 : Period,Priority:Priority


                        ,OneTime:Period<0,params:IsObject(ParmObject)?ParmObject:[],Tick:A_TickCount}


      ,tmr.CBA := RegisterCallback(this.base.SetTimer,"F",4,&tmr)


      return !!(tmr.tmr  := DllCall("SetTimer", "UInt",0, "UInt",0, "UInt"


            , (Period && Period!="On") ? Abs(Period) : (Period := 250)


            , "UInt",tmr.CBA)) ;Create Timer and return true if a timer was created


            , tmr.Tick:=A_TickCount


   }


  if IsObject(tmr := Object(A_EventInfo)) { ;A_Event holds object which contains timer information


    DllCall("KillTimer", "UInt",0, "UInt",tmr.tmr) ;deactivate timer so it does not run again while we are processing the function


    ,tmr.tick:= ErrorLevel := A_TickCount ;update tick to launch function on time


    ,func:=tmr.func,%func%(tmr.ref,tmr.params*) ; call function


    if (tmr.OneTime) ;One time timer, deactivate and delete it


      return DllCall("GlobalFree", "UInt",tmr.CBA)


            ,ObjRemove(tmrs,tmr.ref?tmr.ref:tmr.func)


   tmr.tmr := DllCall("SetTimer", "UInt",0, "UInt",0, "UInt" ;reset timer


            ,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), "UInt",tmr.CBA)


  }


  }


}


;--------------include: F:\scripts\Autohotkey\Lib\WM_COPYDATA.ahk------------








Send_WM_COPYDATA(Hwnd, dwData, lpData="") {


; dwData = Command


; cbData = String lenght


; lpData = String


	static WM_COPYDATA := 0x4A


	VarSetCapacity(COPYDATASTRUCT, 3*A_PtrSize, 0)


		,cbData := (StrLen(lpData) + 1) * (A_IsUnicode ? 2 : 1)


		,NumPut(dwData,  COPYDATASTRUCT, 0*A_PtrSize)


		,NumPut(cbData,  COPYDATASTRUCT, 1*A_PtrSize)


		,NumPut(&lpData, COPYDATASTRUCT, 2*A_PtrSize)


	


	SendMessage, WM_COPYDATA, 0, &COPYDATASTRUCT,, ahk_id %Hwnd%


	return ErrorLevel == "FAIL" ? false : true


}











/*


On_WM_COPYDATA(wParam, lParam, msg, hwnd) {


; dwData = Command


; cbData = String lenght


; lpData = String


	dwData := NumGet(lParam+0, 0)


	,cbData := NumGet(lParam + A_PtrSize)


	,lpData := NumGet(lParam + 2*A_PtrSize)


	,lpData := StrGet(lpData)


	


	;~ str:=lpData


	


	If  (dwData = 0x50000007) ; CMD_CURRENTPOSITION


	{


		


		For example if you Send:


                Send_WM_COPYDATA(Hwnd, 0x50000007, "Something")


                Then you receive here in lpData "something" String


		


	}


}


*/


;~ esc::ExitApp





;--------------include: F:\scripts\Autohotkey\Lib\ImpaxContextServer.ahk------------





DetectHiddenWindows,on





ImpaxContextServer_Init(hwnd=""){


	static prvHwnd


	if WinExist("ahk_id " hwnd) || WinExist("ahk_id " hwnd:=prvHwnd){


		winget,ProcessName,ProcessName,ahk_id %hwnd%


		if(ProcessName="ImpaxContextServer.exe")


			return hwnd


	}


	


	process,Exist,ImpaxContextServer.exe


	if (!ErrorLevel){


		root:=SubStr(A_ScriptDir, 1, 2)


		if  FileExist(path:=root "\scripts\Radiology\MammoSR\ImpaxContextServer\ImpaxContextServer.exe")


			;~ || FileExist(path:=root "\send string by windows message\bin\Release\ImpaxContextServer.exe")


			|| fileexist(path:=A_ScriptDir "\ImpaxContextServer.exe")


			|| fileexist(path:=A_ScriptDir "\ImpaxContextServer\ImpaxContextServer.exe")


			||  fileexist(path:=a_mydocuments "\ImpaxContextServer\ImpaxContextServer.exe") 


			contextServerPath:=path


		run % contextServerPath


		winwait,ahk_exe ImpaxContextServer.exe,,5


		winminimize,ahk_exe ImpaxContextServer.exe


	}


	return (h:=WinExist("ahk_exe ImpaxContextServer.exe"))?(prvHwnd:=h):0


}





ImpaxContextServer_SendCommand(str, hwnd=""){


	Send_WM_COPYDATA(ImpaxContextServer_Init(hwnd), 0, str)


}





ImpaxContextServer_Show(AccNo, hwnd=""){


	ImpaxContextServer_SendCommand("SYNC_DISPLAY || " Trim(AccNo) " || ", hwnd)


}





ImpaxContextServer_Add(AccNo, withPrior=false, hwnd=""){


	ImpaxContextServer_SendCommand("ADD_TO_DISPLAY_LIST" (withPrior?"_WITH_PRIORS":"") " || " Trim(AccNo) " || ", hwnd)


}


;--------------include: F:\scripts\Autohotkey\Lib\Control_GetClassNN.ahk------------


Control_GetClassNN(hWndWindow,hWndControl){


	DetectHiddenWindows, On


	WinGet, ClassNNList, ControlList, ahk_id %hWndWindow%


	Loop, PARSE, ClassNNList, `n


	{


		ControlGet, hwnd, hwnd,,%A_LoopField%,ahk_id %hWndWindow%


		if (hWnd = hWndControl)


			return A_LoopField


	}


}


;--------------include: F:\scripts\Autohotkey\Lib\ACC.ahk------------


;------------------------------------------------------------------------------


; Acc.ahk Standard Library


; by Sean


; Updated by jethrow:


; 	Modified ComObjEnwrap params from (9,pacc) --> (9,pacc,1)


; 	Changed ComObjUnwrap to ComObjValue in order to avoid AddRef (thanks fincs)


; 	Added Acc_GetRoleText & Acc_GetStateText


; 	Added additional functions - commented below


; 	Removed original Acc_Children function


; last updated 2/25/2010


;------------------------------------------------------------------------------





; #include <COM>


; RoleText object:


; ind, 1 = text


; ind, 2 = n-th match 


; ind, 3 = find at exactly n-th element


findAccByRoleText(acc, RoleText, depth=0){


	thisRoleText:=RoleText[depth+1]


	,which=thisRoleText[2]


	,findAt=thisRoleText[3]


	


	;~ if(which="" && findAt="")


		;~ which=1


	


	i:=0, found:=false


	if(which!=""){


		


		for ch in Acc_EnumChildren(acc)


			if (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]) && (++i=which){


				found:=ch


				break


			}


		if(found)


			if IsObject(RoleText[depth+2])


				return findAccByRoleText(ch, RoleText, depth+1)


			else


				return ch


		else 


			return false


	}else if (findAt!=""){


		for ch in Acc_EnumChildren(acc)


			if(A_Index=findAt && (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]))


				if IsObject(RoleText[depth+2])


					return findAccByRoleText(ch, RoleText, depth+1)


				else


					return ch


			else 


				return false


	}else{


		for ch in Acc_EnumChildren(acc)


			if (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]){


				if IsObject(RoleText[depth+2])


					found:=findAccByRoleText(ch, RoleText, depth+1)


				else


					found:=ch


				


				if(found)


					return found


			}


		return false


	}


}





findAccByValue(byref acc,val,this_path=""){


	static arr:=[]


	static path:=""


	static record:=""


	for k,v in acc_children(acc) {


		if (IsObject(v) && instr(v.accValue,val)) || (!IsObject(v) && InStr(acc_get("value", "", k, acc), val))


			arr.push([v.clone(),this_path "," k])


		findAccByValue(v,val,this_path "," k)


	}


	record.=this_path "`n"


	return [arr,record]


}


findAccByName(byref acc,val,this_path=""){


	static arr:=[]


	static path:=""


	static record:=""


	for k,v in acc_children(acc) {


	if instr(v.accName,val)


		arr.push([v.clone(),this_path "," k])


		findAccByName(v,val,this_path "," k)


	}


	record.=this_path "`n"


	return [arr,record]


}


findAccBy(byref acc,val,by="value",this_path=""){


	static arr:=[]


	static path:=""


	static record:=""


	for k,v in acc_children(acc) {


	if instr(acc_get(by,"",0,v),val)


		arr.push([v.clone(),this_path "," k])


		findAccBy(v,val,by,this_path "," k)


	}


	record.=this_path "`n"


	return [arr,record]


}


accControl(Control,WinTitle=""){


	if (Control="A" && WinTitle="") { ; Control is "A", use focused control.


        ControlGetFocus, Control, A


        WinTitle = A


    } else if (Control+0!="" && WinTitle="") {  ; Control is numeric, assume its a ahk_id.


        WinTitle := "ahk_id " . Control


        Control =


    }





	controlget,hwnd,hwnd,,%control%,%WinTitle%


	return acc_objectfromwindow(hwnd)


}











Acc_Init()


{


	Static	h


	If Not	h


		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")


}


Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild)


{


	Acc_Init()


	If	DllCall("oleacc\AccessibleObjectFromEvent", "Ptr", hWnd, "UInt", idObject, "UInt", idChild, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0


	Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")


}





Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "")


{


	Acc_Init()


	If	DllCall("oleacc\AccessibleObjectFromPoint", "Int64", x==""||y==""?0*DllCall("GetCursorPos","Int64*",pt)+pt:x&0xFFFFFFFF|y<<32, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0


	Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")


}





Acc_ObjectFromWindow(hWnd, idObject = -4)


{


	Acc_Init()


	If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0


	Return	ComObjEnwrap(9,pacc,1)


}


Acc_ObjectFromWindow2(hWnd, idObject = -4)


{


	;~ Acc_Init()


	


	If DllCall(AccessibleObjectFromWindowProc, "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0


	Return	ComObjEnwrap(9,pacc,1)


}


Acc_WindowFromObject(pacc)


{


	If	DllCall("oleacc\WindowFromAccessibleObject", "Ptr", IsObject(pacc)?ComObjValue(pacc):pacc, "Ptr*", hWnd)=0


	Return	hWnd


}





Acc_GetRoleText(nRole)


{


	nSize := DllCall("oleacc\GetRoleText", "Uint", nRole, "Ptr", 0, "Uint", 0)


	,VarSetCapacity(sRole, (A_IsUnicode?2:1)*nSize)


	,DllCall("oleacc\GetRoleText", "Uint", nRole, "str", sRole, "Uint", nSize+1)


	Return	sRole


}





Acc_GetStateText(nState)


{


	nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)


	,VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)


	,DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)


	Return	sState


}





Acc_SetWinEventHook(eventMin, eventMax, pCallback)


{


	Return	DllCall("SetWinEventHook", "Uint", eventMin, "Uint", eventMax, "Uint", 0, "Ptr", pCallback, "Uint", 0, "Uint", 0, "Uint", 0)


}





Acc_UnhookWinEvent(hHook)


{


	Return	DllCall("UnhookWinEvent", "Ptr", hHook)


}


/*	Win Events:





	pCallback := RegisterCallback("WinEventProc")


	WinEventProc(hHook, event, hWnd, idObject, idChild, eventThread, eventTime)


	{


		Critical


		Acc := Acc_ObjectFromEvent(_idChild_, hWnd, idObject, idChild)


		; Code Here:





	}


*/





; Written by jethrow


Acc_Role(Acc, ChildId=0) {


	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetRoleText(Acc.accRole(ChildId)):"invalid object"


}


Acc_State(Acc, ChildId=0) {


	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateText(Acc.accState(ChildId)):"invalid object"


}


Acc_Location(Acc, ChildId=0, byref Position="") { ; adapted from Sean's code


	try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)


	catch


		return


	Position := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")


	return	{x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")}


}


Acc_Parent(Acc) { 


	try parent:=Acc.accParent


	return parent?Acc_Query(parent):


}


Acc_Child(Acc, ChildId=0) {


	try child:=Acc.accChild(ChildId)


	return child?Acc_Query(child):


}


Acc_Query(Acc) { ; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530


	try return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)


}


Acc_Error(p="") {


	static setting:=0


	return p=""?setting:setting:=p


}


Acc_Children(Acc) {


	if ComObjType(Acc,"Name") != "IAccessible"


		ErrorLevel := "Invalid IAccessible Object"


	else {


		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]


		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {


			Loop %cChildren%


				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.push(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):


			return Children.MaxIndex()?Children:


		} else


			ErrorLevel := "AccessibleChildren DllCall Failed"


	}


	if Acc_Error()


		throw Exception(ErrorLevel,-1)


}


Acc_ChildrenByRole(Acc, Role) {


	if ComObjType(Acc,"Name")!="IAccessible"


		ErrorLevel := "Invalid IAccessible Object"


	else {


		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]


		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {


			Loop %cChildren% {


				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i)


				if NumGet(varChildren,i-8)=9


					AccChild:=Acc_Query(child), ObjRelease(child), Acc_Role(AccChild)=Role?Children.push(AccChild):


				else


					Acc_Role(Acc, child)=Role?Children.push(child):


			}


			return Children.MaxIndex()?Children:, ErrorLevel:=0


		} else


			ErrorLevel := "AccessibleChildren DllCall Failed"


	}


	if Acc_Error()


		throw Exception(ErrorLevel,-1)


}


Acc_Get(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {


	static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}


	AccObj :=   IsObject(WinTitle)? WinTitle


			:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )


	if ComObjType(AccObj, "Name") != "IAccessible"


		ErrorLevel := "Could not access an IAccessible Object"


	else {


		StringReplace, ChildPath, ChildPath, _, %A_Space%, All


		AccError:=Acc_Error(), Acc_Error(true)


		Loop Parse, ChildPath, ., %A_Space%


			try {


				if A_LoopField is digit


					Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output in else-statement


				else


					RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)


				if Not Children.HasKey(m2)


					throw


				AccObj := Children[m2]


			} catch {


				ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)


				if Acc_Error()


					throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)


				return


			}


		Acc_Error(AccError)


		StringReplace, Cmd, Cmd, %A_Space%, , All


		properties.HasKey(Cmd)? Cmd:=properties[Cmd]:


		try {


			if (Cmd = "Location")


				AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)


			  , ret_val := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")


			else if (Cmd = "Object")


				ret_val := AccObj


			else if Cmd in Role,State


				ret_val := Acc_%Cmd%(AccObj, ChildID+0)


			else if Cmd in ChildCount,Selection,Focus


				ret_val := AccObj["acc" Cmd]


			else


				ret_val := AccObj["acc" Cmd](ChildID+0)


		} catch {


			ErrorLevel := """" Cmd """ Cmd Not Implemented"


			if Acc_Error()


				throw Exception("Cmd Not Implemented", -1, Cmd)


			return


		}


		return ret_val, ErrorLevel:=0


	}


	if Acc_Error()


		throw Exception(ErrorLevel,-1)


}





;~ acc:=new AccObj(0x1840f32)


;~ msgbox % clipboard:=acc.childrenTreeStr()


;~ exitapp


Class AccObj {


	__New(hwnd){


		if !hwnd


			return 


		setformat,integer,h


		if isobject(hwnd) {


			


			this.hwnd:=acc_windowfromobject(hwnd)


			this.acc:=hwnd


		}else{


			this.hwnd:=hwnd


			this.acc:=acc_objectfromwindow(hwnd)


		}


		setformat,integer,d


	}


	


	


	loc(childId=0, byref pos=""){


		return Acc_Location(this.Acc, childId, pos)


	}


	


	get(Cmd, ChildPath="", ChildID=0,WinTitle="", WinText="", ExcludeTitle="", ExcludeText=""){


		if (WinTitle WinText ExcludeTitle ExcludeText="")


			wintitle:=this.acc


		get:=Acc_Get(Cmd, ChildPath, ChildID, WinTitle, WinText, ExcludeTitle, ExcludeText)


		return isobject(get)?(new AccObj(get)):get


	}


	


	parent(){


		return new AccObj(acc_parent(this.acc))


	}


	


	children(ind=""){


		ret:=[]


		ch:=acc_children(this.acc)


		if (ind=""){


			


			if ch.maxindex() {


			for k,v in acc_children(this.acc)


				ret.push(new AccObj(v))


			}


		}else{


			ret:=new AccObj(acc_children(this.acc)[ind])


		}





		return ret


	}


	


	__Get(childrenCount){


		ret:=acc_children(this.acc)


		return (ret.maxIndex()?ret.maxIndex():0)


	}


	


	childrenTree(obj=""){


		arr:=[]


		if (obj="")


			obj:=this


		arr[0]:=obj


		ch:=obj.children()


		if ch.maxIndex() {


			for k,v in ch


				arr.push(obj.childrenTree(v))


		}


		return arr


	}





	childrenTreeStr(byref node="",win=""){


		;~ if (controls=""){


			;~ a:=this


			;~ loop


				;~ a:=a.parent()


			;~ until a.parent().hwnd=a.hwnd


			;~ controls:=this.getControls(a.hwnd)


		;~ }


		


		if win=


			win:=this.belongWin()


		;~ for k,v in controls


			;~ if (v.hwnd=this.hwnd) {


		/*


		setformat,integer,h	


		controlgettext,text,,% "ahk_id " this.hwnd


				str:=this.hwnd "|" Control_GetClassNN(win,this.hwnd) "|" text "`n"


				;~ break


			;~ }


		setformat,integer,d


		;~ controls:=this.getControls()


		ch:=this.children()


		loop % ch.maxIndex()


			str.="`t" ch[a_index].childrenTreeStr(win)


			


			*/


		if node=


			node:=this.childrenTree()


		controlgettext,text,,% "ahk_id " node[0].hwnd


		str:=node[0].hwnd "|" Control_GetClassNN(win,node[0].hwnd) "|" text "`n"


		for k,v in node {


			if k


				str.="`t" this.childrenTreeStr(v,win)


		}


		


		return str


	}


	


	GetControls(hwnd="")


	{


		if hwnd=


			hwnd:=this.hwnd


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


	


	belongWin(){


		WinGet, all, list


		DetectHiddenWindows,on


		


		Loop, %all%


		{


			setformat,integer,d


            v := all%A_Index%


			winget,controls,controllisthwnd,ahk_id %v%


			setformat,integer,h


			hwnd:=this.hwnd


			if regexmatch(controls,"\b" hwnd "\b") {


				


			;~ for x,y in controls:=this.getControls(v) 


				;~ if (y.hwnd=this.hwnd){


					found:=v


					break


				}


		}


		return found?found:0


	}


}





Acc_Children2(pacc, cChildren, ByRef varChildren)


{


	Acc_Init()


	If	DllCall("oleacc\AccessibleChildren", "Ptr", IsObject(pacc)?ComObjValue(pacc):pacc, "Int", 0, "Int", cChildren, "Ptr", VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*", cChildren)=0


	Return	cChildren


}





Acc_EnumChildren(Acc) {


	Children := []


	Loop, % Acc_Children2(Acc, Acc.accChildCount, varChildren)


		i := (A_Index-1)*(A_PtrSize*2+8)+8


	  , child := NumGet(varChildren,i)


	  , Children.push(NumGet(varChildren,i-8)=3?child:ComObj(9,child,1))


	return, {	Items:		Children


			,	_NewEnum:	Func("Acc_Enum_NewEnum")


			,	Next:		Func("Acc_Enum_Next")	


			,	base:		{__Get:Func("Acc_Enum_Get")}	}


}


Acc_Enum_NewEnum(obj) {


	return, obj


}


Acc_Enum_Next(obj, byref child, byref type="") {


	If Not obj.HasKey("child")


		obj.child:=child, obj.type:=type


	If Not obj.Items.MaxIndex() {


		child:=obj.child, type:=obj.type


		return, false


	} else {


		child:=obj.Items.Delete(1), type:=IsObject(child)?9:3


		return, true


	}


}


Acc_Enum_Get(obj, key) {


	return, obj.Items[key]


}





;--------------include: F:\scripts\Autohotkey\Lib\CharWordPos.ahk------------








;~ SetFormat,integer,h








;~ n := StrPutVar("■", UTF8, "UTF-8")


;~ MsgBox % n-1


;~ ExitApp





;~ MsgBox % MultiByteChars("一二三四五")





;~ controlget,hwnd,hwnd,,Scintilla1,simple RIS


;~ s:=new RemoteScintilla(hwnd)


;~ MsgBox % StrPut("■", "utf-8")


;~ MsgBox % Asc("■")


;~ s._setsel(0,8)


;~ ExitApp





;~ UTF16 := "■" 


;~ n := StrPutVar(UTF16, UTF8, "UTF-8")


;~ MsgBox % MCode_Bin2Hex(&UTF8, n-1)





MCode_Bin2Hex(addr, len) {


    Static fun


    If (fun = "") {


        If Not A_IsUnicode


        h=


        ( LTrim Join


            8B54240C85D2568B7424087E3A53578B7C24148A07478AC8C0E90480F9090F97C3F6


            DB80E30702D980C330240F881E463C090F97C1F6D980E10702C880C130880E464A75


            CE5F5BC606005EC3


        )


        Else


        h=


        ( LTrim Join


            8B44240C8B4C240485C07E53568B74240C578BF88A168AC2C0E804463C090FB6C076


            066683C037EB046683C03066890180E20F83C10280FA09760C0FB6D26683C2376689


            11EB0A0FB6C26683C03066890183C1024F75BD33D25F6689115EC333C0668901C3


        )


        VarSetCapacity(fun, n := StrLen(h)//2)


        Loop % n


            NumPut("0x" . SubStr(h, 2 * A_Index - 1, 2), fun, A_Index - 1, "Char")


    }


    VarSetCapacity(hex, A_IsUnicode ? 4 * len + 2 : 2 * len + 1)


    DllCall(&fun, "Ptr", &hex, "Ptr", addr, "Ptr", len, "cdecl")


    VarSetCapacity(hex, -1) ;update StrLen


    Return hex


}





;~ MsgBox % MultiByteChars("■")


;~ MsgBox % Asc("■") "," ord("■")


;~ ExitApp


MultiByteChars(ByRef str){


	a:=0


	Loop,Parse,str


		;~ a+= (c:=Asc(A_LoopField))>0xFFFFFF?4:c>0xFFFF?3:c>0xFF?2:1


		a+= StrPutVar(A_LoopField, UTF8:="", "UTF-8")-1


	return a


}














CharToWordPos(ByRef str, ByRef start, ByRef end="", swap=0){


	


	if(End="")


		End:=start


	


	if(start=0 && End=0){


		start:=0, End:=0


		return


	}


	


	if(start>End)


		start0:=End, End0:=start, swap:=1


	else


		start0:=start, End0:=End


	;~ }else{


		_start:=_end:=""





		,CharPos:=0


		Loop,Parse,str


		{


			if (CharPos>start0 && CharPos>End0)


				break


			;~ CharPos+= Asc(A_LoopField)<=0xFF?1:Asc(A_LoopField)<=0xFFFF?2:Asc(A_LoopField)<=0xFFFFFF?3:4


			CharPos+= StrPutVar(A_LoopField, UTF8, "UTF-8")-1


			if (CharPos>=start0 && _start="")


				_start:=A_Index


			if (CharPos>=End0 && _end="")


				_End:=A_Index


			ind:=A_Index


		}


	;~ }


	


	if(!swap)


		start:=_start?_start:ind, End:=_end?_end:ind


	else


		start:=_end?_end:ind, End:=_start?_start:ind





}





WordToCharPos(ByRef str, ByRef start, ByRef end="", swap=0){


	if(End="")


		End:=start


	


	if(start=0 && End=0){


		start:=0, End:=0


		return


	}


	


	if(start>End)


		start0:=End, End0:=start, swap:=1


	else


		start0:=start, End0:=End


		;~ _start:=End, _End:=start


		;~ ret:=WordToCharPos(str, _End, _start, 1)


		;~ _start:=ret.1, _End:=ret.2


	;~ }else{


	


		_start:=_end:=""


		;~ ,CharPos:=0


		


		,_start:=MultiByteChars(SubStr(str, 1, start0)), _End:=_start+MultiByteChars(SubStr(str, start0+1, End0-start0))


		


	;~ }


	


	if(!swap)


		return [start:=_start, End:=_End]


	else


		return [start:=_End, End:=_start]


	


	/*


	Loop,Parse,str


	{


		if (A_Index>start && A_Index>End)


			break


		;~ CharPos+= Asc(A_LoopField)<=0xFF?1:Asc(A_LoopField)<=0xFFFF?2:Asc(A_LoopField)<=0xFFFFFF?3:4


		CharPos+= StrPutVar(A_LoopField, UTF8, "UTF-8")-1


		if (A_Index=start && _start="")


			_start:=CharPos


		if (A_Index=End && _end="")


			_End:=CharPos


	}


	start:=_start?_start:CharPos, End:=_end?_end:CharPos


	*/


}


;--------------include: F:\scripts\Autohotkey\Lib\SCI.ahk------------


; Title: Scintilla Wrapper for AHK





class scintilla {


    hwnd            := 0        ; Component Handle


    ,notify          := ""       ; Name of the function that will handle the window messages sent by the control





                                ; Messages which set this variables.


                                ; ---------------------------------------------------------------------------------------------------------------


    ,idFrom          := 0        ; The handle from which the notification was sent


    ,scnCode         := 0        ; The SCN_* notification code


    ,position        := 0        ; SCN_STYLENEEDED, SCN_DOUBLECLICK, SCN_MODIFIED, SCN_MARGINCLICK


                                ; SCN_NEEDSHOWN, SCN_DWELLSTART, SCN_DWELLEND, SCN_CALLTIPCLICK


                                ; SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK, SCN_HOTSPOTRELEASECLICK


                                ; SCN_INDICATORCLICK, SCN_INDICATORRELEASE


                                ; SCN_USERLISTSELECTION, SCN_AUTOCSELECTION





    ,ch              := 0        ; SCN_CHARADDED, SCN_KEY


    ,modifiers       := 0        ; SCN_KEY, SCN_DOUBLECLICK, SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK


                                ; SCN_HOTSPOTRELEASECLICK, SCN_INDICATORCLICK, SCN_INDICATORRELEASE





    ,modType         := 0        ; SCN_MODIFIED


    ,text            := 0        ; SCN_MODIFIED, SCN_USERLISTSELECTION, SCN_AUTOCSELECTION, SCN_URIDROPPED


    ,length          := 0        ; SCN_MODIFIED


    ,linesAdded      := 0        ; SCN_MODIFIED


    ,macMessage      := 0        ; SCN_MACRORECORD


    ,macwParam       := 0        ; SCN_MACRORECORD


    ,maclParam       := 0        ; SCN_MACRORECORD


    ,line            := 0        ; SCN_MODIFIED


    ,foldLevelNow    := 0        ; SCN_MODIFIED


    ,foldLevelPrev   := 0        ; SCN_MODIFIED


    ,margin          := 0        ; SCN_MARGINCLICK


    ,listType        := 0        ; SCN_USERLISTSELECTION


    ,x               := 0        ; SCN_DWELLSTART, SCN_DWELLEND


    ,y               := 0        ; SCN_DWELLSTART, SCN_DWELLEND


    ,token           := 0        ; SCN_MODIFIED with SC_MOD_CONTAINER


    ,annotLinesAdded := 0        ; SCN_MODIFIED with SC_MOD_CHANGEANNOTATION


    ,updated         := false    ; SCN_UPDATEUI





    __new(params*){


        if (params.MaxIndex())


            __SCI(this.hwnd := __Add(params*), this)


        else


            return this


    }


    





    


    __call(msg, ByRef wParam=0, ByRef lParam=0, params*){


        if (msg = "Add")


            __SCI(this.hwnd := __Add(wParam, lParam, params*), this)


        else


        {


            (wParam && !(wParam+0) && !isObject(wParam)) ? (VarSetCapacity(wParamA, StrPut(wParam, "UTF-8"))


                                                           ,StrPut(wParam, &wParamA, "UTF-8")


                                                           ,wParam:=&wParamA) : nullValue





            (lParam && !(lParam+0) && !isObject(lParam)) ? (VarSetCapacity(lParamA, StrPut(lParam, "UTF-8"))


                                                           ,StrPut(lParam, &lParamA, "UTF-8")


                                                           ,lParam:=&lParamA) : nullValue





            /*


              Special Operations


              Due to the fact that some functions require the user to manually prepare bufferst to store text


              I decided to make most of those operations internally to have cleaner code later on.


            */





            (msg = "GetText") ? (VarSetCapacity(lParam, wParam * (a_isunicode ? 2 : 1)+8), lParam := &lParam, buf:=true) : nullValue


            (msg = "GetLine") ? (VarSetCapacity(lParam, this.linelength(wParam)+1 * (a_isunicode ? 2 : 1)),lParam := &lParam, buf:=true) : nullValue


	    (msg = "GetCurLine") ? (VarSetCapacity(lParam, this.linelength(wParam)+1 * (a_isunicode ? 2 : 1)), lParam := &lParam, buf:=true) : nullValue


            (msg = "GetTextRange") ? (range:=abs(wParam.1 - wParam.2)+1, dSize :=  __sendEditor(this.hwnd, "GetLength")


                                     ,VarSetCapacity(lParam, range > dSize ? (dSize, wParam.2 := dSize) : range)


                                     ,VarSetCapacity(textRange, 12, 0)


                                     ,NumPut(wParam.1,textRange,0,"UInt")


                                     ,NumPut(wParam.2,textRange,4,"UInt")


                                     ,NumPut(&lParam,textRange,8,"UInt")


                                     ,blParam := &lParam, wParam := false,lParam := &textRange, buf:=true) : nullValue





            __isHexColor(lParam, msg) ? lParam := (lParam & 0xFF) <<16 | (lParam & 0xFF00) | (lParam >>16) : nullValue


            __isHexColor(wParam, msg) ? wParam := (wParam & 0xFF) <<16 | (wParam & 0xFF00) | (wParam >>16) : nullValue





            res := __sendEditor(this.hwnd, msg, wParam, lParam)





            ; Retrieve Text from buffer


            ; I must switch lParam to another variable when using GetTextRange because lParam cant be overwriten


            ; It has the pointer to the TextRange Structure


            buf ? (lParam := StrGet((msg = "GetTextRange") ? blParam : &lParam, "UTF-8"), buf:=false) : nullValue ; convert the text from ANSI


            return res


        }


    }


}





class sciCharRange {





    __new(_cMin=0, _cMax=0){





        this.cMin := _cMin


        this.cMax := _cMax


    }


}


class sciTextRange {





    __new(_chrg=0, _pStr=0){





        if (!isObject(_chrg)){


            Msgbox % 0x0


                   , % "sciTextRange Object Error"


                   , % "The first parameter must match a sciCharRange object"


            Exit


        }





        this.chrg := _chrg ? _chrg : new sciCharRange


        this.pStr := _pStr


    }


}


class sciTextToFind {





    __new(_chrg=0, _text="", _found=0){





        if (!isObject(_chrg) || !isObject(_found)) {


            Msgbox % 0x0


                   , % "sciTextToFind Object Error"


                   , % "The first and last parameters must match a sciCharRange object"


            Exit


        }





        this.chrg   := _chrg ? _chrg : new sciCharRange


        this.text   := _text


        this.found  := _found ? _found : new sciCharRange


    }


}


class sciRectangle {





    __new(_left=0, _top=0, _right=0, _bottom=0){





        this.left    := _left


        this.top     := _top


        this.right   := _right


        this.bottom  := _bottom


    }


}


class sciRangeToFormat {





    __new(_hdc=0, _hdcTarget=0, _rc=0, _rcPage=0, _chrg=0){


        this.hdc         := _hdc                                        ; The Surface ID we print to


        this.hdcTarget   := _hdcTarget                                  ; The Surface ID we use for measuring (may be same as hdc)


        this.rc          := _rc ? _rc : new sciRectangle                ; Rectangle in which to print


        this.rcPage      := _rcPage ? _rcPage : new sciRectangle        ; Physically printable page size


        this.chrg        := _chrg ? _chrg : new sciCharRange            ; Range of characters to print


    }


}





; | Internal Functions |





/*


    Function: __Add


    Creates a Scintilla component and adds it to the Parent GUI.





    This function initializes the Scintilla Component.


    See <http://www.scintilla.org/Steps.html> for more information on how to add the component to a GUI/Control.





    Parameters:


    __Add(hParent, [x, y, w, h, DllPath, Styles])





    hParent     -   Hwnd of the parent control who will host the Scintilla Component


    x           -   x position for the control (default 5)


    y           -   y position for the control (default 5)


    w           -   Width of the control (default 590)


    h           -   Height of the control (default 390)


    DllPath     -   Path to the SciLexer.dll file, if omitted the function looks for it in *a_scriptdir*.


    Styles      -   List of window style variable names separated by spaces.


                    The WS_ prefix for the variables is optional.


                    Full list of Style names can be found at


                    <http://msdn.microsoft.com/en-us/library/czada357.aspx>.





    Returns:


    HWND        -   Component handle.





    Examples:


    (start code)





    #singleinstance force





    ;---------------------


    ; This script adds a component with default values.


    ; If no path was specified when creating the object it expects scilexer.dll to be on the script's location.


    ; The default values are calculated to fit optimally on a 600x400 GUI/Control





    Gui +LastFound


    sci := new scintilla(WinExist())





    Gui, show, w600 h400


    return





    GuiClose:


        exitapp





    ;---------------------





    #singleinstance force





    ; Add multiple components.





    Gui +LastFound


    hwnd:=WinExist()





    sci1 := new scintilla(hwnd, 0, 0, 590, 190) ; you can put the parameters here


    sci2 := new scintilla





    sci2.add(hwnd, 0, 200, 590, 190) ; or you can use the add function like this





    Gui, show, w600 h400


    return





    GuiClose:


        exitapp





    ;---------------------





    #singleinstance force





    ; Here we add a component embedded in a tab.


    ; If the variables "x,w,h" are empty the default values are used.





    Gui, add, Tab2, HWNDhwndtab x0 y0 w600 h420 gtabHandler vtabLast,one|two





    sci := new scintilla


    sci.Add(hwndtab, x, 25, w, h, a_scriptdir "\scilexer.dll")





    Gui, show, w600 h420


    return





    ; This additional code is for hiding/showing the component depending on which tab is open


    ; In this example the Tab named "one" is the one that contains the control.


    ; If you switch the words "show" and "hide" the component will be shown when the tab called "two" is active.





    tabHandler:                                 ; Tab Handler for the Scintilla Control


    Gui, submit, Nohide


    action := tabLast = "one" ? "Show" : "Hide" ; decide which action to take


    Control,%action%,,, % "ahk_id " sci.hwnd


    return





    GuiClose:


        exitapp


    (end)


*/


__Add(hParent=0, x=5, y=5, w=590, h=390, DllPath="", Styles=""){


    static WS_OVERLAPPED:=0x00000000,WS_POPUP:=0x80000000,WS_CHILD:=0x40000000,WS_MINIMIZE:=0x20000000


    ,WS_VISIBLE:=0x10000000,WS_DISABLED:=0x08000000,WS_CLIPSIBLINGS:=0x04000000,WS_CLIPCHILDREN:=0x02000000


    ,WS_MAXIMIZE:=0x01000000,WS_CAPTION:=0x00C00000,WS_BORDER:=0x00800000,WS_DLGFRAME:=0x00400000


    ,WS_VSCROLL:=0x00200000,WS_HSCROLL:=0x00100000,WS_SYSMENU:=0x00080000,WS_THICKFRAME:=0x00040000


    ,WS_GROUP:=0x00020000,WS_TABSTOP:=0x00010000,WS_MINIMIZEBOX:=0x00020000,WS_MAXIMIZEBOX:=0x00010000


    ,WS_TILED:=0x00000000,WS_ICONIC:=0x20000000,WS_SIZEBOX:=0x00040000,WS_EX_CLIENTEDGE:=0x00000200


    ,GuiID:=311210,init:=false, nullValue:=0





    DllPath := !DllPath ? "SciLexer.dll" : inStr(DllPath, ".dll") ? DllPath : DllPath "\SciLexer.dll"


    if !init        ;  WM_NOTIFY = 0x4E


        old:=OnMessage(0x4E,"__sciNotify"),init:=true





    if !SCIModule:=DllCall("LoadLibrary", "Str", DllPath, "Ptr")


        return debug ? A_ThisFunc "> Could not load library: " DllPath : 1





    hStyle := WS_CHILD | (VISIBILITY := InStr(Styles, "Hidden") ? 0 : WS_VISIBLE) | WS_TABSTOP





    if Styles


        Loop, Parse, Styles, %a_tab%%a_space%, %a_tab%%a_space%


            hStyle |= %a_loopfield%+0 ? %a_loopfield% : WS_%a_loopfield% ? WS_%a_loopfield% : 0





    hSci:=DllCall("CreateWindowEx"


                 ,Uint ,WS_EX_CLIENTEDGE                ; Ex Style


                 ,Str  ,"Scintilla"                     ; Class Name


                 ,Str  ,""                              ; Window Name


                 ,UInt ,hStyle                          ; Window Styles


                 ,Int  ,x ? x : 5                       ; x


                 ,Int  ,y ? y : 5                       ; y


                 ,Int  ,w ? w : 590                     ; Width


                 ,Int  ,h ? h : 390                     ; Height


                 ,Ptr ,hParent ? hParent : WinExist()  ; Parent HWND


                 ,Ptr ,GuiID                           ; (HMENU)GuiID


                 ,Ptr ,nullValue                            ; hInstance


                 ,Ptr ,nullValue, "Ptr")                   ; lpParam





                 ,__sendEditor(hSci)                    ; initialize sendEditor function





    return hSci


}





/*


    Function : __sendEditor


    Posts the messages used to modify the control's behaviour.





    *This is an internal function and it is not needed in normal situations. Please use the scintilla object to call all functions.


    They call this function automatically*





    Parameters:


    __sendEditor(hwnd, msg, [wParam, lParam])





    hwnd    -   The hwnd of the control that you want to operate on. Useful for when you have more than 1


                Scintilla components in the same script. The wrapper will remember the last used hwnd,


                so you can specify it once and only specify it again when you want to operate on a different


                component.


                *Note: This is converted internally by the wrapper from the object calling method. It is recommended that you dont use this function.*


    msg     -   The message to be posted, full list can be found here:


                <http://www.scintilla.org/ScintillaDoc.html>


    wParam  -   wParam for the message


    lParam  -   lParam for the message





    Returns:


    Status code of the DllCall performed.





    Examples:


    (Start Code)


    __sendEditor(hSci1, "SCI_SETMARGINWIDTHN",0,40)  ; Set the margin 0 to 40px on the first component.


    __sendEditor(0, "SCI_SETWRAPMODE",1,0)           ; Set wrap mode to true on the last used component.


    __sendEditor(hSci2, "SCI_SETMARGINWIDTHN",0,50)  ; Set the margin 0 to 50px on the second component.


    (End)


*/


__sendEditor(hwnd, msg=0, wParam=0, lParam=0){


    static





    hwnd := !hwnd ? oldhwnd : hwnd, oldhwnd := hwnd, msg := !(msg+0) ? "SCI_" msg : msg





    if !%hwnd%_df


	{


        SendMessage, SCI_GETDIRECTFUNCTION,0,0,,ahk_id %hwnd%


        %hwnd%_df := ErrorLevel


        SendMessage, SCI_GETDIRECTPOINTER,0,0,,ahk_id %hwnd%


        %hwnd%_dp := ErrorLevel


	}





    if !msg && !wParam && !lParam   ; called only with the hwnd param from SCI_Add


        return                      ; Exit because we did what we needed to do already.





    ; The fast way to control Scintilla


    return DllCall(%hwnd%_df            ; DIRECT FUNCTION


                  ,"Ptr" ,%hwnd%_dp    ; DIRECT POINTER


                  ,"Ptr" ,!(msg+0) ? %msg% : msg


                  ,"Int"  ,inStr(wParam, "-") ? wParam : (%wParam%+0 ? %wParam% : wParam) ; handles negative ints


                  ,"Int"  ,%lParam%+0 ? %lParam% : lParam, "Ptr")


}





/*


    Function : __sciNotify


    This is the default function which will be called when the WM_NOTIFY message has been received. The message is tracked as soon as you


    add a new scintilla component.








    Parameters:


    __sciNotify(wParam, lParam, msg, hwnd)





    wParam  -   wParam for the message


    lParam  -   lParam for the message


    msg     -   The message which triggered this function


    hwnd    -   The hwnd of the control which sent the message





    Returns:


    This function sets some variables on the sciObject to which the component belongs to and procedes to call your user defined notify function


    which can be set in sciObj.notify.





    It will pass wParam, lParam, msg and hwnd to that function so make sure you define it that way.


    Returns nothing.





    Examples:


*/


__sciNotify(wParam, lParam, msg, hwnd){





    ; fix int for x64 bit systems


    __sciObj                 := __SCI(NumGet(lParam + 0))               ; Returns original object


    ,__sciObj.idFrom          := NumGet(lParam + a_Ptrsize * 1)


    ,__sciObj.scnCode         := NumGet(lParam + a_Ptrsize * 2)





    ,__sciObj.position        := NumGet(lParam + a_Ptrsize * 3)


    ,__sciObj.ch              := NumGet(lParam + a_Ptrsize * 4)


    ,__sciObj.modifiers       := NumGet(lParam + a_Ptrsize * 5)


    ,__sciObj.modType         := NumGet(lParam + a_Ptrsize * 6)


    ,__sciObj.text            := NumGet(lParam + a_Ptrsize * 7)


    ,__sciObj.length          := NumGet(lParam + a_Ptrsize * 8)


    ,__sciObj.linesAdded      := NumGet(lParam + a_Ptrsize * 9)





    ,__sciObj.macMessage      := NumGet(lParam + a_Ptrsize * 10)


    ,__sciObj.macwParam       := NumGet(lParam + a_Ptrsize * 11)


    ,__sciObj.maclParam       := NumGet(lParam + a_Ptrsize * 12)





    ,__sciObj.line            := NumGet(lParam + a_Ptrsize * 13)


    ,__sciObj.foldLevelNow    := NumGet(lParam + a_Ptrsize * 14)


    ,__sciObj.foldLevelPrev   := NumGet(lParam + a_Ptrsize * 15)


    ,__sciObj.margin          := NumGet(lParam + a_Ptrsize * 16)


    ,__sciObj.listType        := NumGet(lParam + a_Ptrsize * 17)


    ,__sciObj.x               := NumGet(lParam + a_Ptrsize * 18)


    ,__sciObj.y               := NumGet(lParam + a_Ptrsize * 19)





    ,__sciObj.token           := NumGet(lParam + a_Ptrsize * 20)


    ,__sciObj.annotLinesAdded := NumGet(lParam + a_Ptrsize * 21)


    ,__sciObj.updated         := NumGet(lParam + a_Ptrsize * 22)





    ,__sciObj.notify(wParam, lParam, msg, hwnd, __sciObj)                ; Call user defined Notify Function and passes object to it as last parameter


    return __sciObj := ""                                               ; free object


}





__isHexColor(hex, msg){


    if (RegexMatch(hex, "^0x[0-9a-fA-F]{6}$"))


        return true


    else


        return false


}





__SCI(var, val=""){


    static





    if (RegExMatch(var,"i)[ `n-\.%,(\\\/=&^]")) ; Check if it is a valid variable name


        return





	lvar := %var%, val ? %var% := val : nullValue


    return lvar


}





; Global scintilla variables


{


global INVALID_POSITION:=-1, unused := 0 ; Some messages dont use one of their parameters. You can use this variable for them.





; Main Scintilla Functions


{


global SCI_DELETERANGE:=2645


global SCI_ADDTEXT:=2001,SCI_ADDSTYLEDTEXT:=2002,SCI_INSERTTEXT:=2003,SCI_CLEARALL:=2004,SCI_CLEARDOCUMENTSTYLE:=2005,SCI_GETLENGTH:=2006


,SCI_GETCHARAT:=2007,SCI_GETCURRENTPOS:=2008,SCI_GETANCHOR:=2009,SCI_GETSTYLEAT:=2010,SCI_REDO:=2011,SCI_SETUNDOCOLLECTION:=2012


,SCI_SELECTALL:=2013,SCI_SETSAVEPOINT:=2014,SCI_GETSTYLEDTEXT:=2015,SCI_CANREDO:=2016,SCI_MARKERLINEFROMHANDLE:=2017


,SCI_MARKERDELETEHANDLE:=2018,SCI_GETUNDOCOLLECTION:=2019,SCI_GETVIEWWS:=2020,SCI_SETVIEWWS:=2021,SCI_POSITIONFROMPOINT:=2022


,SCI_POSITIONFROMPOINTCLOSE:=2023,SCI_GOTOLINE:=2024,SCI_GOTOPOS:=2025,SCI_SETANCHOR:=2026,SCI_GETCURLINE:=2027,SCI_GETENDSTYLED:=2028


,SCI_CONVERTEOLS:=2029,SCI_GETEOLMODE:=2030,SCI_SETEOLMODE:=2031,SCI_STARTSTYLING:=2032,SCI_SETSTYLING:=2033,SCI_GETBUFFEREDDRAW:=2034


,SCI_SETBUFFEREDDRAW:=2035,SCI_SETTABWIDTH:=2036,SCI_GETTABWIDTH:=2121,SCI_SETCODEPAGE:=2037,SCI_SETUSEPALETTE:=2039,SCI_MARKERDEFINE:=2040


,SCI_MARKERSETFORE:=2041,SCI_MARKERSETBACK:=2042,SCI_MARKERADD:=2043,SCI_MARKERDELETE:=2044,SCI_MARKERDELETEALL:=2045,SCI_MARKERGET:=2046


,SCI_MARKERNEXT:=2047,SCI_MARKERPREVIOUS:=2048,SCI_MARKERDEFINEPIXMAP:=2049,SCI_MARKERADDSET:=2466,SCI_MARKERSETALPHA:=2476


,SCI_SETMARGINTYPEN:=2240,SCI_GETMARGINTYPEN:=2241,SCI_SETMARGINWIDTHN:=2242,SCI_GETMARGINWIDTHN:=2243,SCI_SETMARGINMASKN:=2244


,SCI_GETMARGINMASKN:=2245,SCI_SETMARGINSENSITIVEN:=2246,SCI_GETMARGINSENSITIVEN:=2247,SCI_STYLECLEARALL:=2050,SCI_STYLESETFORE:=2051


,SCI_STYLESETBACK:=2052,SCI_STYLESETBOLD:=2053,SCI_STYLESETITALIC:=2054,SCI_STYLESETSIZE:=2055,SCI_STYLESETFONT:=2056


,SCI_STYLESETEOLFILLED:=2057,SCI_STYLEGETFORE:=2481,SCI_STYLEGETBACK:=2482,SCI_STYLEGETBOLD:=2483,SCI_STYLEGETITALIC:=2484


,SCI_STYLEGETSIZE:=2485,SCI_STYLEGETFONT:=2486,SCI_STYLEGETEOLFILLED:=2487,SCI_STYLEGETUNDERLINE:=2488,SCI_STYLEGETCASE:=2489


,SCI_STYLEGETCHARACTERSET:=2490,SCI_STYLEGETVISIBLE:=2491,SCI_STYLEGETCHANGEABLE:=2492,SCI_STYLEGETHOTSPOT:=2493,SCI_STYLERESETDEFAULT:=2058


,SCI_SETCARETSTYLE:=2512


,SCI_STYLESETUNDERLINE:=2059,SCI_STYLESETCASE:=2060,SCI_STYLESETCHARACTERSET:=2066,SCI_STYLESETHOTSPOT:=2409,SCI_SETSELFORE:=2067


,SCI_SETSELBACK:=2068,SCI_GETSELALPHA:=2477,SCI_SETSELALPHA:=2478,SCI_SETCARETFORE:=2069,SCI_ASSIGNCMDKEY:=2070,SCI_CLEARCMDKEY:=2071


,SCI_CLEARALLCMDKEYS:=2072,SCI_SETSTYLINGEX:=2073,SCI_STYLESETVISIBLE:=2074,SCI_GETCARETPERIOD:=2075,SCI_SETCARETPERIOD:=2076


,SCI_SETWORDCHARS:=2077,SCI_BEGINUNDOACTION:=2078,SCI_ENDUNDOACTION:=2079,SCI_INDICSETSTYLE:=2080,SCI_INDICGETSTYLE:=2081


,SCI_INDICSETFORE:=2082,SCI_INDICGETFORE:=2083,SCI_SETWHITESPACEFORE:=2084,SCI_SETWHITESPACEBACK:=2085,SCI_SETSTYLEBITS:=2090


,SCI_GETSTYLEBITS:=2091,SCI_SETLINESTATE:=2092,SCI_GETLINESTATE:=2093,SCI_GETMAXLINESTATE:=2094,SCI_GETCARETLINEVISIBLE:=2095


,SCI_SETCARETLINEVISIBLE:=2096,SCI_GETCARETLINEBACK:=2097,SCI_SETCARETLINEBACK:=2098,SCI_STYLESETCHANGEABLE:=2099,SCI_AUTOCSHOW:=2100


,SCI_AUTOCCANCEL:=2101,SCI_AUTOCACTIVE:=2102,SCI_AUTOCPOSSTART:=2103,SCI_AUTOCCOMPLETE:=2104,SCI_AUTOCSTOPS:=2105


,SCI_AUTOCSETSEPARATOR:=2106,SCI_AUTOCGETSEPARATOR:=2107,SCI_AUTOCSELECT:=2108,SCI_AUTOCSETCANCELATSTART:=2110


,SCI_AUTOCGETCANCELATSTART:=2111,SCI_AUTOCSETFILLUPS:=2112,SCI_AUTOCSETCHOOSESINGLE:=2113,SCI_AUTOCGETCHOOSESINGLE:=2114


,SCI_AUTOCSETIGNORECASE:=2115,SCI_AUTOCGETIGNORECASE:=2116,SCI_USERLISTSHOW:=2117,SCI_AUTOCSETAUTOHIDE:=2118,SCI_AUTOCGETAUTOHIDE:=2119


,SCI_AUTOCSETDROPRESTOFWORD:=2270,SCI_AUTOCGETDROPRESTOFWORD:=2271,SCI_REGISTERIMAGE:=2405,SCI_CLEARREGISTEREDIMAGES:=2408


,SCI_AUTOCGETTYPESEPARATOR:=2285,SCI_AUTOCSETTYPESEPARATOR:=2286,SCI_AUTOCSETMAXWIDTH:=2208,SCI_AUTOCGETMAXWIDTH:=2209


,SCI_AUTOCSETMAXHEIGHT:=2210,SCI_AUTOCGETMAXHEIGHT:=2211,SCI_SETINDENT:=2122,SCI_GETINDENT:=2123,SCI_SETUSETABS:=2124,SCI_GETUSETABS:=2125


,SCI_SETLINEINDENTATION:=2126,SCI_GETLINEINDENTATION:=2127,SCI_GETLINEINDENTPOSITION:=2128,SCI_GETCOLUMN:=2129,SCI_SETHSCROLLBAR:=2130


,SCI_GETHSCROLLBAR:=2131,SCI_SETINDENTATIONGUIDES:=2132,SCI_GETINDENTATIONGUIDES:=2133,SCI_SETHIGHLIGHTGUIDE:=2134


,SCI_GETHIGHLIGHTGUIDE:=2135,SCI_GETLINEENDPOSITION:=2136,SCI_GETCODEPAGE:=2137,SCI_GETCARETFORE:=2138,SCI_GETUSEPALETTE:=2139


,SCI_GETREADONLY:=2140,SCI_SETCURRENTPOS:=2141,SCI_SETSELECTIONSTART:=2142,SCI_GETSELECTIONSTART:=2143,SCI_SETSELECTIONEND:=2144


,SCI_GETSELECTIONEND:=2145,SCI_SETPRINTMAGNIFICATION:=2146,SCI_GETPRINTMAGNIFICATION:=2147,SCI_SETPRINTCOLORMODE:=2148


,SCI_GETPRINTCOLORMODE:=2149,SCI_FINDTEXT:=2150,SCI_FORMATRANGE:=2151,SCI_GETFIRSTVISIBLELINE:=2152,SCI_GETLINE:=2153


,SCI_GETLINECOUNT:=2154,SCI_SETMARGINLEFT:=2155,SCI_GETMARGINLEFT:=2156,SCI_SETMARGINRIGHT:=2157,SCI_GETMARGINRIGHT:=2158


,SCI_GETMODIFY:=2159,SCI_SETSEL:=2160,SCI_GETSELTEXT:=2161,SCI_GETTEXTRANGE:=2162,SCI_HIDESELECTION:=2163,SCI_POINTXFROMPOSITION:=2164


,SCI_POINTYFROMPOSITION:=2165,SCI_LINEFROMPOSITION:=2166,SCI_POSITIONFROMLINE:=2167,SCI_LINESCROLL:=2168,SCI_SCROLLCARET:=2169


,SCI_SCROLLRANGE:=2569


,SCI_REPLACESEL:=2170,SCI_SETREADONLY:=2171,SCI_NULL:=2172,SCI_CANPASTE:=2173,SCI_CANUNDO:=2174,SCI_EMPTYUNDOBUFFER:=2175,SCI_UNDO:=2176


,SCI_CUT:=2177,SCI_COPY:=2178,SCI_PASTE:=2179,SCI_CLEAR:=2180,SCI_SETTEXT:=2181,SCI_GETTEXT:=2182,SCI_GETTEXTLENGTH:=2183


,SCI_GETDIRECTFUNCTION:=2184,SCI_GETDIRECTPOINTER:=2185,SCI_SETOVERTYPE:=2186,SCI_GETOVERTYPE:=2187,SCI_SETCARETWIDTH:=2188


,SCI_GETCARETWIDTH:=2189,SCI_SETTARGETSTART:=2190,SCI_GETTARGETSTART:=2191,SCI_SETTARGETEND:=2192,SCI_GETTARGETEND:=2193


,SCI_REPLACETARGET:=2194,SCI_REPLACETARGETRE:=2195,SCI_SEARCHINTARGET:=2197,SCI_SETSEARCHFLAGS:=2198,SCI_GETSEARCHFLAGS:=2199


,SCI_CALLTIPSHOW:=2200,SCI_CALLTIPCANCEL:=2201,SCI_CALLTIPACTIVE:=2202,SCI_CALLTIPPOSSTART:=2203,SCI_CALLTIPSETHLT:=2204


,SCI_CALLTIPSETBACK:=2205,SCI_CALLTIPSETFORE:=2206,SCI_CALLTIPSETFOREHLT:=2207,SCI_CALLTIPUSESTYLE:=2212,SCI_VISIBLEFROMDOCLINE:=2220


,SCI_DOCLINEFROMVISIBLE:=2221,SCI_WRAPCOUNT:=2235,SCI_SETFOLDLEVEL:=2222,SCI_GETFOLDLEVEL:=2223,SCI_GETLASTCHILD:=2224


,SCI_GETFOLDPARENT:=2225,SCI_SHOWLINES:=2226,SCI_HIDELINES:=2227,SCI_GETLINEVISIBLE:=2228,SCI_SETFOLDEXPANDED:=2229


,SCI_GETFOLDEXPANDED:=2230,SCI_TOGGLEFOLD:=2231,SCI_ENSUREVISIBLE:=2232,SCI_SETFOLDFLAGS:=2233,SCI_ENSUREVISIBLEENFORCEPOLICY:=2234


,SCI_SETTABINDENTS:=2260,SCI_GETTABINDENTS:=2261,SCI_SETBACKSPACEUNINDENTS:=2262,SCI_GETBACKSPACEUNINDENTS:=2263,SCI_SETMOUSEDWELLTIME:=2264


,SCI_GETMOUSEDWELLTIME:=2265,SCI_WORDSTARTPOSITION:=2266,SCI_WORDENDPOSITION:=2267,SCI_SETWRAPMODE:=2268,SCI_GETWRAPMODE:=2269


,SCI_SETWRAPVISUALFLAGS:=2460,SCI_GETWRAPVISUALFLAGS:=2461,SCI_SETWRAPVISUALFLAGSLOCATION:=2462,SCI_GETWRAPVISUALFLAGSLOCATION:=2463


,SCI_SETWRAPSTARTINDENT:=2464,SCI_GETWRAPSTARTINDENT:=2465,SCI_SETLAYOUTCACHE:=2272,SCI_GETLAYOUTCACHE:=2273,SCI_SETSCROLLWIDTH:=2274


,SCI_GETSCROLLWIDTH:=2275,SCI_TEXTWIDTH:=2276,SCI_SETENDATLASTLINE:=2277,SCI_GETENDATLASTLINE:=2278,SCI_TEXTHEIGHT:=2279


,SCI_SETVSCROLLBAR:=2280,SCI_GETVSCROLLBAR:=2281,SCI_APPENDTEXT:=2282,SCI_GETTWOPHASEDRAW:=2283,SCI_SETTWOPHASEDRAW:=2284


,SCI_TARGETFROMSELECTION:=2287,SCI_LINESJOIN:=2288,SCI_LINESSPLIT:=2289,SCI_SETFOLDMARGINCOLOR:=2290,SCI_SETFOLDMARGINHICOLOR:=2291


,SCI_ZOOMIN:=2333,SCI_ZOOMOUT:=2334,SCI_MOVECARETINSIDEVIEW:=2401,SCI_LINELENGTH:=2350,SCI_BRACEHIGHLIGHT:=2351,SCI_BRACEBADLIGHT:=2352


,SCI_BRACEMATCH:=2353,SCI_GETVIEWEOL:=2355,SCI_SETVIEWEOL:=2356,SCI_GETDOCPOINTER:=2357,SCI_SETDOCPOINTER:=2358,SCI_SETMODEVENTMASK:=2359


,SCI_GETEDGECOLUMN:=2360,SCI_SETEDGECOLUMN:=2361,SCI_GETEDGEMODE:=2362,SCI_SETEDGEMODE:=2363,SCI_GETEDGECOLOR:=2364,SCI_SETEDGECOLOR:=2365


,SCI_SEARCHANCHOR:=2366,SCI_SEARCHNEXT:=2367,SCI_SEARCHPREV:=2368,SCI_LINESONSCREEN:=2370,SCI_USEPOPUP:=2371,SCI_SELECTIONISRECTANGLE:=2372


,SCI_SETZOOM:=2373,SCI_GETZOOM:=2374,SCI_CREATEDOCUMENT:=2375,SCI_ADDREFDOCUMENT:=2376,SCI_RELEASEDOCUMENT:=2377,SCI_GETMODEVENTMASK:=2378


,SCI_SETFOCUS:=2380,SCI_GETFOCUS:=2381,SCI_SETSTATUS:=2382,SCI_GETSTATUS:=2383,SCI_SETMOUSEDOWNCAPTURES:=2384,SCI_GETMOUSEDOWNCAPTURES:=2385


,SCI_SETCURSOR:=2386,SCI_GETCURSOR:=2387,SCI_SETCONTROLCHARSYMBOL:=2388,SCI_GETCONTROLCHARSYMBOL:=2389,SCI_SETVISIBLEPOLICY:=2394


,SCI_SETXOFFSET:=2397,SCI_GETXOFFSET:=2398,SCI_CHOOSECARETX:=2399,SCI_GRABFOCUS:=2400,SCI_SETXCARETPOLICY:=2402,SCI_SETYCARETPOLICY:=2403


,SCI_SETPRINTWRAPMODE:=2406,SCI_GETPRINTWRAPMODE:=2407,SCI_SETHOTSPOTACTIVEFORE:=2410,SCI_SETHOTSPOTACTIVEBACK:=2411


,SCI_SETHOTSPOTACTIVEUNDERLINE:=2412,SCI_SETHOTSPOTSINGLELINE:=2421,SCI_POSITIONBEFORE:=2417,SCI_POSITIONAFTER:=2418


,SCI_COPYRANGE:=2419,SCI_COPYTEXT:=2420,SCI_SETSELECTIONMODE:=2422,SCI_GETSELECTIONMODE:=2423,SCI_GETLINESELSTARTPOSITION:=2424


,SCI_GETLINESELENDPOSITION:=2425,SCI_SETWHITESPACECHARS:=2443,SCI_SETCHARSDEFAULT:=2444,SCI_AUTOCGETCURRENT:=2445,SCI_ALLOCATE:=2446


,SCI_TARGETASUTF8:=2447,SCI_SETLENGTHFORENCODE:=2448,SCI_ENCODEDFROMUTF8:=2449,SCI_FINDCOLUMN:=2456,SCI_GETCARETSTICKY:=2457


,SCI_SETCARETSTICKY:=2458,SCI_TOGGLECARETSTICKY:=2459,SCI_SETPASTECONVERTENDINGS:=2467,SCI_GETPASTECONVERTENDINGS:=2468


,SCI_SETCARETLINEBACKALPHA:=2470,SCI_GETCARETLINEBACKALPHA:=2471,SCI_STARTRECORD:=3001,SCI_STOPRECORD:=3002,SCI_SETLEXER:=4001


,SCI_GETLEXER:=4002,SCI_COLORISE:=4003,SCI_SETPROPERTY:=4004,SCI_SETKEYWORDS:=4005,SCI_SETLEXERLANGUAGE:=4006,SCI_LOADLEXERLIBRARY:=4007


,SCI_GETPROPERTY:=4008,SCI_GETPROPERTYEXPANDED:=4009,SCI_GETPROPERTYINT:=4010,SCI_GETSTYLEBITSNEEDED:=4011,SCI_AUTOCSETCASEINSENSITIVEBEHAVIOUR:=2634,SCI_AUTOCGETCASEINSENSITIVEBEHAVIOUR:=2635


}





; Styles, Markers and Indicators


{


global MARKER_MAX:=31,STYLE_DEFAULT:=32,STYLE_LINENUMBER:=33,STYLE_BRACELIGHT:=34,STYLE_BRACEBAD:=35,STYLE_CONTROLCHAR:=36


,STYLE_INDENTGUIDE:=37,STYLE_CALLTIP:=38,STYLE_LASTPREDEFINED:=39,STYLE_MAX:=127,INDIC_MAX:=7,INDIC_PLAIN:=0,INDIC_SQUIGGLE:=1,INDIC_TT:=2


,INDIC_DIAGONAL:=3,INDIC_STRIKE:=4,INDIC_HIDDEN:=5,INDIC_BOX:=6,INDIC_ROUNDBOX:=7,INDIC0_MASK:=0x20,INDIC1_MASK:=0x40,INDIC2_MASK:=0x80


,INDICS_MASK:=0xE0,SCI_START:=2000,SCI_OPTIONAL_START:=3000,SCI_LEXER_START:=4000,SCWS_INVISIBLE:=0,SCWS_VISIBLEALWAYS:=1


,SCWS_VISIBLEAFTERINDENT:=2,SC_EOL_CRLF:=0,SC_EOL_CR:=1,SC_EOL_LF:=2,SC_CP_UTF8:=65001,SC_CP_DBCS:=1,SC_MARK_CIRCLE:=0,SC_MARK_ROUNDRECT:=1


,SC_MARK_ARROW:=2,SC_MARK_SMALLRECT:=3,SC_MARK_SHORTARROW:=4,SC_MARK_EMPTY:=5,SC_MARK_ARROWDOWN:=6,SC_MARK_MINUS:=7,SC_MARK_PLUS:=8


,SC_MARK_VLINE:=9,SC_MARK_LCORNER:=10,SC_MARK_TCORNER:=11,SC_MARK_BOXPLUS:=12,SC_MARK_BOXPLUSCONNECTED:=13,SC_MARK_BOXMINUS:=14


,SC_MARK_BOXMINUSCONNECTED:=15,SC_MARK_LCORNERCURVE:=16,SC_MARK_TCORNERCURVE:=17,SC_MARK_CIRCLEPLUS:=18,SC_MARK_CIRCLEPLUSCONNECTED:=19


,SC_MARK_CIRCLEMINUS:=20,SC_MARK_CIRCLEMINUSCONNECTED:=21,SC_MARK_BACKGROUND:=22,SC_MARK_DOTDOTDOT:=23,SC_MARK_ARROWS:=24


,SC_MARK_PIXMAP:=25,SC_MARK_FULLRECT:=26,SC_MARK_CHARACTER:=10000,SC_MARKNUM_FOLDEREND:=25,SC_MARKNUM_FOLDEROPENMID:=26


,SC_MARKNUM_FOLDERMIDTAIL:=27,SC_MARKNUM_FOLDERTAIL:=28,SC_MARKNUM_FOLDERSUB:=29,SC_MARKNUM_FOLDER:=30,SC_MARKNUM_FOLDEROPEN:=31


,SC_MASK_FOLDERS:=0xFE000000,SC_MARGIN_SYMBOL:=0,SC_MARGIN_NUMBER:=1


}





; Character Sets and Printing


{


global SC_CHARSET_ANSI:=0,SC_CHARSET_DEFAULT:=1,SC_CHARSET_BALTIC:=186


,SC_CHARSET_CHINESEBIG5:=136,SC_CHARSET_EASTEUROPE:=238,SC_CHARSET_GB2312:=134,SC_CHARSET_GREEK:=161,SC_CHARSET_HANGUL:=129


,SC_CHARSET_MAC:=77,SC_CHARSET_OEM:=255,SC_CHARSET_RUSSIAN:=204,SC_CHARSET_CYRILLIC:=1251,SC_CHARSET_SHIFTJIS:=128


,SC_CHARSET_SYMBOL:=2,SC_CHARSET_TURKISH:=162,SC_CHARSET_JOHAB:=130,SC_CHARSET_HEBREW:=177,SC_CHARSET_ARABIC:=178,SC_CHARSET_VIETNAMESE:=163


,SC_CHARSET_THAI:=222,SC_CHARSET_8859_15:=1000, SC_CASE_MIXED:=0,SC_CASE_UPPER:=1,SC_CASE_LOWER:=2,SC_PRINT_NORMAL:=0,SC_PRINT_INVERTLIGHT:=1


,SC_PRINT_BLACKONWHITE:=2,SC_PRINT_COLORONWHITE:=3,SC_PRINT_COLORONWHITEDEFAULTBG:=4


}





; Search Flags


{


global SCFIND_WHOLEWORD:=2,SCFIND_MATCHCASE:=4


,SCFIND_WORDSTART:=0x00100000,SCFIND_REGEXP:=0x00200000,SCFIND_POSIX:=0x00400000


}





; Folding


{


global SC_FOLDLEVELBASE:=0x400,SC_FOLDLEVELWHITEFLAG:=0x1000


,SC_FOLDLEVELHEADERFLAG:=0x2000,SC_FOLDLEVELBOXHEADERFLAG:=0x4000,SC_FOLDLEVELBOXFOOTERFLAG:=0x8000,SC_FOLDLEVELCONTRACTED:=0______


,SC_FOLDLEVELUNINDENT:=0______,SC_FOLDLEVELNUMBERMASK:=0x0FFF,SC_FOLDFLAG_LINEBEFORE_EXPANDED:=0x0002,SC_FOLDFLAG_LINEBEFORE_CONTRACTED:=0x0004


,SC_FOLDFLAG_LINEAFTER_EXPANDED:=0x0008,SC_FOLDFLAG_LINEAFTER_CONTRACTED:=0x0010,SC_FOLDFLAG_LEVELNUMBERS:=0x0040,SC_FOLDFLAG_BOX:=0x0001


}





; Keys


{


global SCMOD_NORM:=0, SCMOD_SHIFT:=1,SCMOD_CTRL:=2,SCMOD_ALT:=4, SCK_DOWN:=300,SCK_UP:=301,SCK_LEFT:=302,SCK_RIGHT:=303,SCK_HOME:=304,SCK_END:=305


,SCK_PRIOR:=306,SCK_NEXT:=307,SCK_DELETE:=308,SCK_INSERT:=309,SCK_ESCAPE:=7,SCK_BACK:=8,SCK_TAB:=9,SCK_RETURN:=13,SCK_ADD:=310,SCK_SUBTRACT:=311


,SCK_DIVIDE:=312


}





; Lexing


{


global SCLEX_CONTAINER:=0,SCLEX_NULL:=1,SCLEX_PYTHON:=2,SCLEX_CPP:=3,SCLEX_HTML:=4,SCLEX_XML:=5,SCLEX_PERL:=6,SCLEX_SQL:=7,SCLEX_VB:=8


,SCLEX_PROPERTIES:=9,SCLEX_ERRORLIST:=10,SCLEX_MAKEFILE:=11,SCLEX_BATCH:=12,SCLEX_XCODE:=13,SCLEX_LATEX:=14,SCLEX_LUA:=15,SCLEX_DIFF:=16


,SCLEX_CONF:=17,SCLEX_PASCAL:=18,SCLEX_AVE:=19,SCLEX_ADA:=20,SCLEX_LISP:=21,SCLEX_RUBY:=22,SCLEX_EIFFEL:=23,SCLEX_EIFFELKW:=24


,SCLEX_TCL:=25,SCLEX_NNCRONTAB:=26,SCLEX_BULLANT:=27,SCLEX_VBSCRIPT:=28,SCLEX_BAAN:=31,SCLEX_MATLAB:=32,SCLEX_SCRIPTOL:=33


,SCLEX_ASM:=34,SCLEX_CPPNOCASE:=35,SCLEX_FORTRAN:=36,SCLEX_F77:=37,SCLEX_CSS:=38,SCLEX_POV:=39,SCLEX_LOUT:=40,SCLEX_ESCRIPT:=41


,SCLEX_PS:=42,SCLEX_NSIS:=43,SCLEX_MMIXAL:=44,SCLEX_CLW:=45,SCLEX_CLWNOCASE:=46,SCLEX_LOT:=47,SCLEX_YAML:=48,SCLEX_TEX:=49


,SCLEX_METAPOST:=50,SCLEX_POWERBASIC:=51,SCLEX_FORTH:=52,SCLEX_ERLANG:=53,SCLEX_OCTAVE:=54,SCLEX_MSSQL:=55,SCLEX_VERILOG:=56,SCLEX_KIX:=57


,SCLEX_GUI4CLI:=58,SCLEX_SPECMAN:=59,SCLEX_AU3:=60,SCLEX_APDL:=61,SCLEX_BASH:=62,SCLEX_ASN1:=63,SCLEX_VHDL:=64,SCLEX_CAML:=65


,SCLEX_BLITZBASIC:=66,SCLEX_PUREBASIC:=67,SCLEX_HASKELL:=68,SCLEX_PHPSCRIPT:=69,SCLEX_TADS3:=70,SCLEX_REBOL:=71,SCLEX_SMALLTALK:=72


,SCLEX_FLAGSHIP:=73,SCLEX_CSOUND:=74,SCLEX_FREEBASIC:=75,SCLEX_INNOSETUP:=76,SCLEX_OPAL:=77,SCLEX_SPICE:=78,SCLEX_D:=79,SCLEX_CMAKE:=80


,SCLEX_GAP:=81,SCLEX_PLM:=82,SCLEX_PROGRESS:=83,SCLEX_ABAQUS:=84,SCLEX_ASYMPTOTE:=85,SCLEX_R:=86,SCLEX_MAGIK:=87,SCLEX_POWERSHELL:=88


,SCLEX_MYSQL:=89,SCLEX_PO:=90,SCLEX_TAL:=91,SCLEX_COBOL:=92,SCLEX_TACL:=93,SCLEX_SORCUS:=94,SCLEX_POWERPRO:=95,SCLEX_NIMROD:=96,SCLEX_SML:=97


,SCLEX_MARKDOWN:=98,SCLEX_TXT2TAGS:=99,SCLEX_A68K:=100,SCLEX_MODULA:=101,SCLEX_COFFEESCRIPT:=102,SCLEX_TCMD:=103,SCLEX_AVS:=104,SCLEX_ECL:=105


,SCLEX_OSCRIPT:=106,SCLEX_VISUALPROLOG:=107,SCLEX_LITERATEHASKELL:=108,SCLEX_AHKL:=109


,SCE_AHKL_NEUTRAL:=0,SCE_AHKL_IDENTIFIER:=1,SCE_AHKL_COMMENTDOC:=2,SCE_AHKL_COMMENTLINE:=3,SCE_AHKL_COMMENTBLOCK:=4,SCE_AHKL_COMMENTKEYWORD:=5


,SCE_AHKL_STRING:=6,SCE_AHKL_STRINGOPTS:=7,SCE_AHKL_STRINGBLOCK:=8,SCE_AHKL_STRINGCOMMENT:=9,SCE_AHKL_LABEL:=10,SCE_AHKL_HOTKEY:=11


,SCE_AHKL_HOTSTRING:=12,SCE_AHKL_HOTSTRINGOPT:=13,SCE_AHKL_HEXNUMBER:=14,SCE_AHKL_DECNUMBER:=15,SCE_AHKL_VAR:=16,SCE_AHKL_VARREF:=17


,SCE_AHKL_OBJECT:=18,SCE_AHKL_USERFUNCTION:=19,SCE_AHKL_DIRECTIVE:=20,SCE_AHKL_COMMAND:=21,SCE_AHKL_PARAM:=22,SCE_AHKL_CONTROLFLOW:=23


,SCE_AHKL_BUILTINFUNCTION:=24,SCE_AHKL_BUILTINVAR:=25,SCE_AHKL_KEY:=26,SCE_AHKL_USERDEFINED1:=27,SCE_AHKL_USERDEFINED2:=28,SCE_AHKL_ESCAPESEQ:=30


,SCE_AHKL_ERROR:=31,AHKL_LIST_DIRECTIVES:=0,AHKL_LIST_COMMANDS:=1,AHKL_LIST_PARAMETERS:=2,AHKL_LIST_CONTROLFLOW:=3,AHKL_LIST_FUNCTIONS:=4


,AHKL_LIST_VARIABLES:=5,AHKL_LIST_KEYS:=6,AHKL_LIST_USERDEFINED1:=7,AHKL_LIST_USERDEFINED2:=8,SCLEX_AUTOMATIC=1000


}





; Notifications


{


global SCEN_CHANGE:=768,SCEN_SETFOCUS:=512,SCEN_KILLFOCUS:=256, SCN_STYLENEEDED:=2000,SCN_CHARADDED:=2001


,SCN_SAVEPOINTREACHED:=2002,SCN_SAVEPOINTLEFT:=2003,SCN_MODIFYATTEMPTRO:=2004,SCN_KEY:=2005,SCN_DOUBLECLICK:=2006,SCN_UPDATEUI:=2007


,SCN_MODIFIED:=2008,SCN_MACRORECORD:=2009,SCN_MARGINCLICK:=2010,SCN_NEEDSHOWN:=2011,SCN_PAINTED:=2013,SCN_USERLISTSELECTION:=2014


,SCN_URIDROPPED:=2015,SCN_DWELLSTART:=2016,SCN_DWELLEND:=2017,SCN_ZOOM:=2018,SCN_HOTSPOTCLICK:=2019,SCN_HOTSPOTDOUBLECLICK:=2020


,SCN_CALLTIPCLICK:=2021,SCN_AUTOCSELECTION:=2022


}





; Other


{


global SCI_LINEDOWN:=2300,SCI_LINEDOWNEXTEND:=2301,SCI_LINEDOWNRECTEXTEND:=2426


,SCI_LINESCROLLDOWN:=2342,SCI_LINEUP:=2302,SCI_LINEUPEXTEND:=2303,SCI_LINEUPRECTEXTEND:=2427,SCI_LINESCROLLUP:=2343,SCI_PARADOWN:=2413


,SCI_PARADOWNEXTEND:=2414,SCI_PARAUP:=2415,SCI_PARAUPEXTEND:=2416,SCI_CHARLEFT:=2304,SCI_CHARLEFTEXTEND:=2305,SCI_CHARLEFTRECTEXTEND:=2428


,SCI_CHARRIGHT:=2306,SCI_CHARRIGHTEXTEND:=2307,SCI_CHARRIGHTRECTEXTEND:=2429,SCI_WORDLEFT:=2308,SCI_WORDLEFTEXTEND:=2309,SCI_WORDRIGHT:=2310


,SCI_WORDRIGHTEXTEND:=2311,SCI_WORDLEFTEND:=2439,SCI_WORDLEFTENDEXTEND:=2440,SCI_WORDRIGHTEND:=2441,SCI_WORDRIGHTENDEXTEND:=2442


,SCI_WORDPARTLEFT:=2390,SCI_WORDPARTLEFTEXTEND:=2391,SCI_WORDPARTRIGHT:=2392,SCI_WORDPARTRIGHTEXTEND:=2393,SCI_HOME:=2312


,SCI_HOMEEXTEND:=2313,SCI_HOMERECTEXTEND:=2430,SCI_HOMEDISPLAY:=2345,SCI_HOMEDISPLAYEXTEND:=2346,SCI_HOMEWRAP:=2349


,SCI_HOMEWRAPEXTEND:=2450,SCI_VCHOME:=2331,SCI_VCHOMEEXTEND:=2332,SCI_VCHOMERECTEXTEND:=2431,SCI_VCHOMEWRAP:=2453,SCI_VCHOMEWRAPEXTEND:=2454


,SCI_LINEEND:=2314,SCI_LINEENDEXTEND:=2315,SCI_LINEENDRECTEXTEND:=2432,SCI_LINEENDDISPLAY:=2347,SCI_LINEENDDISPLAYEXTEND:=2348


,SCI_LINEENDWRAP:=2451,SCI_LINEENDWRAPEXTEND:=2452,SCI_DOCUMENTSTART:=2316,SCI_DOCUMENTSTARTEXTEND:=2317,SCI_DOCUMENTEND:=2318


,SCI_DOCUMENTENDEXTEND:=2319,SCI_PAGEUP:=2320,SCI_PAGEUPEXTEND:=2321,SCI_PAGEUPRECTEXTEND:=2433,SCI_PAGEDOWN:=2322,SCI_PAGEDOWNEXTEND:=2323


,SCI_PAGEDOWNRECTEXTEND:=2434,SCI_STUTTEREDPAGEUP:=2435,SCI_STUTTEREDPAGEUPEXTEND:=2436,SCI_STUTTEREDPAGEDOWN:=2437


,SCI_STUTTEREDPAGEDOWNEXTEND:=2438,SCI_DELETEBACK:=2326,SCI_DELETEBACKNOTLINE:=2344,SCI_DELWORDLEFT:=2335,SCI_DELWORDRIGHT:=2336


,SCI_DELLINELEFT:=2395,SCI_DELLINERIGHT:=2396,SCI_LINEDELETE:=2338,SCI_LINECUT:=2337,SCI_LINECOPY:=2455,SCI_LINETRANSPOSE:=2339


,SCI_LINEDUPLICATE:=2404,SCI_LOWERCASE:=2340,SCI_UPPERCASE:=2341,SCI_CANCEL:=2325,SCI_EDITTOGGLEOVERTYPE:=2324,SCI_NEWLINE:=2329


,SCI_FORMFEED:=2330,SCI_TAB:=2327,SCI_BACKTAB:=2328,SCI_SELECTIONDUPLICATE:=2469,SCI_SCROLLTOSTART:=2628,SCI_SCROLLTOEND:=2629


,SCI_DELWORDRIGHTEND:=2518,SCI_VERTICALCENTRECARET:=2619,SCI_MOVESELECTEDLINESUP:=2620,SCI_MOVESELECTEDLINESDOWN:=2621


,SC_TIME_FOREVER:=10000000,SC_WRAP_NONE:=0,SC_WRAP_WORD:=1,SC_WRAP_CHAR:=2,SC_WRAPVISUALFLAG_NONE:=0x0000,SC_WRAPVISUALFLAG_END:=0x0001


,SC_WRAPVISUALFLAG_START:=0x0002,SC_WRAPVISUALFLAG_MARGIN:=0x0004, SC_WRAPVISUALFLAGLOC_DEFAULT:=0x0000,SC_WRAPVISUALFLAGLOC_END_BY_TEXT:=0x0001


,SC_WRAPVISUALFLAGLOC_START_BY_TEXT:=0x0002,SC_CACHE_NONE:=0,SC_CACHE_CARET:=1,SC_CACHE_PAGE:=2,SC_CACHE_DOCUMENT:=3,EDGE_NONE:=0,EDGE_LINE:=1


,EDGE_BACKGROUND:=2,SC_CURSORNORMAL:=-1,SC_CURSORWAIT:=4,VISIBLE_SLOP:=0x01,VISIBLE_STRICT:=0x04,CARET_SLOP:=0x01,CARET_STRICT:=0x04


,CARET_JUMPS:=0x10,CARET_EVEN:=0x08,SC_SEL_STREAM:=0,SC_SEL_RECTANGLE:=1,SC_SEL_LINES:=2,SC_ALPHA_TRANSPARENT:=0,SC_ALPHA_OPAQUE:=255


,SC_ALPHA_NOALPHA:=256,KEYWORDSET_MAX:=8,SC_MOD_INSERTTEXT:=0x1,SC_MOD_DELETETEXT:=0x2,SC_MOD_CHANGESTYLE:=0x4,SC_MOD_CHANGEFOLD:=0x8


,SC_PERFORMED_USER:=0x10,SC_PERFORMED_UNDO:=0x20,SC_PERFORMED_REDO:=0x40,SC_MULTISTEPUNDOREDO:=0x80,SC_LASTSTEPINUNDOREDO:=0x100


,SC_MOD_CHANGEMARKER:=0x200,SC_MOD_BEFOREINSERT:=0x400,SC_MOD_BEFOREDELETE:=0x800,SC_MULTILINEUNDOREDO:=0x1000,SC_MODEVENTMASKALL:=0x1FFF


,SC_WEIGHT_NORMAL:=400, SC_WEIGHT_SEMIBOLD:=600, SC_WEIGHT_BOLD:=700


}   





}





SCI_GETTEXT(ByRef sci){


    if(len:=sci.GetLength())=0


        return ""


    sci.GetText(len+4, t:="")


    return t


}





SCI_SETTEXT(ByRef sci, txt){


    if (txt="")


        sci.clearall()


    else


        sci.settext(unused, t:=txt)


}


;--------------include: F:\scripts\Autohotkey\Lib\_RemoteBuf.ahk------------


; Remote Buffer Class, thanks to majkinetor for RemoteBuf() http://www.autohotkey.com/community/viewtopic.php?f=2&t=12251





; Don't forget to #include <_RemoteBuf> in your script.





; - How Create new Remote Buffer


;    Buffer := new _RemoteBuf(WindowOrControlHandle,SizeOfRemoteBuffer:=0)


; - How to read buffer


;    Buffer.Read([BytesToRead])


; - How to write buffer


;    Buffer.Write(StringOrBuffer[,Offset=0,Encoding:="CP0"]) ; Encoding = same values as used by StrPut


;    Buffer.NumPut(Number[,Offset=0,Type:="UInt"]) ; Type = same values as used by NumPut


; - How to free buffer


;    Buffer:=""





Class _RemoteBuf {


	pid:=0,RemoteBuf:=0,size:=0,hProc:=0,LocalBuf:=0,Encoding:="UTF-8"


	__New(hwnd,size=0){


		this.Open(size,hwnd) ; open remote buffer


	}


	__Delete(){ ; delete memory used by remote buffer when it gets released


		static MEM_RELEASE:=0x8000


		If !this.hProc ; no process open = no memory allocated


			Return


		If this.RemoteBuf ; only free if buffer exists


			If !DllCall("VirtualFreeEx","PTR",this.hProc,"PTR",this.RemoteBuf,"PTR",0,"uint",MEM_RELEASE)


				return DllCall("MessageBox","PTR",0,"Str","Unable to free memory (" A_LastError ")","Str","OpenProcess Failed","UInt",0)


		DllCall( "CloseHandle", "PTR", this.hProc) ;close remote buffer handle


	}


	Open(size="",hwnd=0){ ; opens new remote buffer


		static MEM_COMMIT:=0x1000,PAGE_READWRITE:=4,MEM_RELEASE:=0x8000


		If (!this.hProc||hwnd) { ; no buffer opened yet or new handle specified


			If this.RemoteBuf ; we have a new handle and need to delete old buffer


				DllCall("VirtualFreeEx","PTR",this.hProc,"PTR",this.RemoteBuf,"PTR",0,"uint",MEM_RELEASE)


			If this.hProc ; we have a new handle, close process


				DllCall( "CloseHandle", "PTR", this.hProc)


			DetectHiddenWindows % DetectHidden:=A_DetectHiddenWindows?"On":"On"


			WinGet, pid, PID,% "ahk_id " hwnd ; we need the pid of process to open remote buffer


			DetectHiddenWindows % DetectHidden


			If !this.hProc:=DllCall("OpenProcess","uint",0x38,"int",0,"uint",pid,"Ptr") ;0x38 = PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE


				return DllCall("MessageBox","PTR",0,"Str","Unable to open process (" A_LastError ")","Str","OpenProcess Failed","UInt",0)


      this.size:=0 ; default size to 0


		} else if !this.hProc


			Return DllCall("MessageBox","PTR",0,"Str","No open process and no hWnd was given.","Str","OpenProcess Failed","UInt",0)


		If (size<>""&&size>this.size){ ; no size given = no buffer will be allocated


			this.size:=size ; new size


  		If this.RemoteBuf ; we already allocated buffer, free it now.


  			DllCall("VirtualFreeEx","PTR",this.hProc,"PTR",this.RemoteBuf,"PTR",0,"uint",MEM_RELEASE)


 			; Allocate new buffer


			If !this.RemoteBuf := DllCall("VirtualAllocEx","PTR",this.hProc,"PTR",0,"PTR",size,"uint",MEM_COMMIT,"uint",PAGE_READWRITE)


				return DllCall("MessageBox","PTR",0,"Str","Unable to allocate memory (" A_LastError ")","Str","OpenProcess Failed","UInt",0),this.hProc:=0


    }


		Return this.size


	}


	Read(size=0,offset=0){ ; Read remote buffer


		If !this.hProc


			return DllCall("MessageBox","PTR",0,"Str","Invalid remote buffer handle","Str","Handle is NULL","UInt",0)


		If (offset>this.size)


			DllCall("MessageBox","PTR",0,"Str","Offset (" offset ") is bigger then size (" this.size ")","Str","Offset bigger than size","UInt",0)


		this.SetCapacity("buffer",size?size:this.size) ; set internal capacity


		return DllCall("ReadProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",this.LocalBuf:=this.GetAddress("buffer"),"uint",(size?size:this.size)+1,"uint",0)


	}


	Write(value,offset=0,CP=""){ ; Write Remote Buffer


		If !this.hProc


			return DllCall("MessageBox","PTR",0,"Str","Invalid remote buffer handle","Str","Handle is NULL","UInt",0)


		If (offset>this.size)


			return DllCall("MessageBox","PTR",0,"Str","Offset (" offset ") is larger then size (" this.size ")","Str","Offset bigger than size","UInt",0)


		If (value=""){ ; Write empty string


			return DllCall("WriteProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",&value,"uint",4,"uint",0)


		} else {


			If (this.size<Strlen(value)*(CP="CP0"?1:2)) ; buffer to small, open new remote buffer


				this.Open(StrLen(value)*(CP="CP0"?1:2))


		}


		return DllCall("WriteProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",&value,"uint",(StrLen(value)+1)*((CP="CP0"||this.Encoding="CP0")||CP=""?2:4),"uint",0)


	}


	NumPut(value=0,offset=0,Type="UInt"){


		If !this.hProc


			return DllCall("MessageBox","PTR",0,"Str","Invalid remote buffer handle","Str","Handle is NULL","UInt",0)


		If (offset>this.size)


			return DllCall("MessageBox","PTR",0,"Str","Offset (" offset ") is larger then size (" this.size ")","Str","Offset bigger than size","UInt",0)


		; Write value to remoteBuf


		this.SetCapacity("buffer",this.size),NumPut(value,this.LocalBuf:=this.GetAddress("buffer"),Type)


		return DllCall("WriteProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",this.LocalBuf,"uint",A_PtrSize,"uint",0)


	}


	BinWrite(ByRef data,datasize,offset=0){


		If !this.hProc


			return DllCall("MessageBox","PTR",0,"Str","Invalid remote buffer handle","Str","Handle is NULL","UInt",0)


		If (offset>this.size)


			return DllCall("MessageBox","PTR",0,"Str","Offset (" offset ") is larger then size (" this.size ")","Str","Offset bigger than size","UInt",0)


		; Write value to remoteBuf


		this.SetCapacity("buffer",this.size),DllCall("RtlMoveMemory","PTR",this.LocalBuf:=this.GetAddress("buffer"),"PTR",&data,"PTR",datasize)


		return DllCall("WriteProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",this.LocalBuf,"uint",datasize,"uint",0)


	}


}


;--------------include: F:\scripts\Autohotkey\Lib\RemoteScintilla.ahk------------














;~ controlget,hwnd,hwnd,,Scintilla1,8-lex


;~ controlget,hwnd,hwnd,,Scintilla1,simple RIS


;~ rs:=new RemoteScintilla(hwnd)


    





;~ Loop 


;~ {


    ;~ ToolTip % rs.GetText()


;~ }








;~ return 





;~ esc::


;~ ExitApp


;~ return


;~ MsgBox % rs.GetText2()


;~ MsgBox % rs.GetLine(2)


;~ ExitApp


;~ ToolTip % rs.SetText("test測試")


;~ Sleep 1000


;~ exitapp


;~ return





class RemoteScintilla {


    __New(hwnd){


        this.hwnd:=hwnd


        this.Buf:=new _RemoteBuf(this.hwnd)


        


    }


    





    GetText() { ; SCI_GETLENGTH := 2006, SCI_GETTEXT := 2182


        if(len:=this.GetTextLength())>0{


            Buf:=new _RemoteBuf(this.hwnd,len+1)


            ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETTEXT,"UPTR",Buf.size,"PTR",Buf.RemoteBuf, "Ptr")


            ,Buf.Read()


            Return StrGet(Buf.LocalBuf,"UTF-8")


        }else{


            return ""


        }


    }


    SetText(Text){


        if(Text="")


            return this.ClearAll()


        else{


            ret:=StrPutVar(Text,str:="", "UTF-8")


            ,Buf:= new _RemoteBuf(this.hwnd, ret)


            ,Buf.Write(str,0,"UTF-8")


            ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SETTEXT,"PTR",0,"PTR",Buf.RemoteBuf, "Ptr")


            


            return ret


        }


    }


    InsertText(Text, pos=-1){


        if(Text="")


            return -1


        ret:=StrPutVar(Text,str:="", "UTF-8")


        ,Buf:= new _RemoteBuf(this.hwnd, ret)


        ,Buf.Write(str,0,"UTF-8")


        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_INSERTTEXT,"PTR",pos,"PTR",Buf.RemoteBuf, "Ptr")


        


    }


    _InsertText(Text, pos=-1){


        if(Text="")


            return -1


        WordToCharPos(oldText:=this.GetText(), pos=-1?(pos:=StrLen(oldText)):pos)


        ,ret:=StrPutVar(Text,str:="", "UTF-8")


        ,Buf:= new _RemoteBuf(this.hwnd, ret)


        ,Buf.Write(str,0,"UTF-8")


        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_INSERTTEXT,"PTR",pos,"PTR",Buf.RemoteBuf, "Ptr")


        


    }


    AddText(Text){ ;current position, move caret


        if(Text="")


            return -1


        ret:=StrPutVar(Text,str:="", "UTF-8")


        ,Buf:= new _RemoteBuf(this.hwnd, ret)


        ,Buf.Write(str,0,"UTF-8")


        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ADDTEXT,"PTR",StrLen(Text),"PTR",Buf.RemoteBuf, "Ptr")


        


    }


    


    DeleteRange(pos, len){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_DELETERANGE,"PTR", pos,"PTR", len, "PTR")


    }


    


    GetSelectionStart(){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETSELECTIONSTART,"PTR",0,"PTR")


    }


    GetSelectionEnd(){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETSELECTIONEND,"PTR",0,"PTR")


    }


    GetCurrentPos(){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetCurrentPos,"PTR",0,"PTR")


    }


    GetAnchor(){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetAnchor,"PTR",0,"PTR")


    }


    GetSel(ByRef s="", ByRef e=""){


        s:=this.GetAnchor()


        ,e:=this.GetCurrentPos()


        return {start:s, End:e}


    }


    


    _GetSelectionStart(){


        ;~ if Strlen(Text:=this.GetText())!=this.GetLength(){


            ;~ return this.GetSelectionStart()


        ;~ }


        s:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETSELECTIONSTART,"PTR",0,"PTR")


        ,CharToWordPos(Text:=this.GetText(), s)


        return s


    }


    _GetSelectionEnd(){


        ;~ if Strlen(Text:=this.GetText())!=this.GetLength(){


            ;~ return this.GetSelectionEnd()


        ;~ }


        e:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETSELECTIONEND,"PTR",0,"PTR")


        ,CharToWordPos(Text:=this.GetText(), e)


        return e


    }


    _GetCurrentPos(){


        ;~ if Strlen(Text:=this.GetText())!=this.GetLength(){


            ;~ return this.GetCurrentPos()


        ;~ }


        s:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetCurrentPos,"PTR",0,"PTR")


        ,CharToWordPos(Text:=this.GetText(), s)


        return s


    }


    _GetAnchor(){


        ;~ if Strlen(Text:=this.GetText())!=this.GetLength(){


            ;~ return this.GetAnchor()


        ;~ }


        e:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetAnchor,"PTR",0,"PTR")


        ,CharToWordPos(Text:=this.GetText(), e)


        return e


    }


    _GetSel(ByRef s="", ByRef e=""){


        ;~ if Strlen(Text:=this.GetText())!=this.GetLength(){


            ;~ return this.GetSel()


        ;~ }


        s:=this.GetAnchor()


        ,e:=this.GetCurrentPos()


        ,CharToWordPos(Text:=this.GetText(), s, e)


        return {start:s, End:e}


    }


    


    GetSelText(){


        if(len:=this.GetTextLength())>0 {


            Buf:=new _RemoteBuf(this.hwnd,this.GetTextLength()+4)


            ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetSelText,"UPTR",Buf.size,"PTR",Buf.RemoteBuf, "Ptr")


            ,Buf.Read()


            Return StrGet(Buf.LocalBuf,"UTF-8")


        }else{


            return ""


        }


    }


    


    StyleGetFont(styleNumber){


        Buf:=new _RemoteBuf(this.hwnd,32)


        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_StyleGetFont,"UPTR",styleNumber,"PTR",Buf.RemoteBuf, "Ptr")


        ,Buf.Read()


        Return StrGet(Buf.LocalBuf,"UTF-8")


      


    }


    


    GetLine(line=""){


        if(line="" || line=-1)


            line:=this.LINEFROMPOSITION()


        Buf:=new _RemoteBuf(this.hwnd,this.LineLength(line)+1)


        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetLine,"PTR",line,"PTR",Buf.RemoteBuf, "Ptr")


        ,Buf.Read()


        Return StrGet(Buf.LocalBuf,"UTF-8")


    }


    


    ;~ GetStyleAt(Pos){


        ;~ Buf:=new _RemoteBuf(this.hwnd,32)


        ;~ ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetStyleAt,"PTR", pos,"PTR",Buf.RemoteBuf, "Ptr")


        ;~ ,Buf.Read()


        ;~ Return StrGet(Buf.LocalBuf,"UTF-8")


    ;~ }


    


    ;~ GetCharAt(Pos){


        ;~ Buf:=new _RemoteBuf(this.hwnd,32)


        ;~ ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetCharAt,"PTR", pos,"PTR",Buf.RemoteBuf, "Ptr")


        ;~ ,Buf.Read()


        ;~ Return StrGet(Buf.LocalBuf,"UTF-8")


    ;~ }


    


    LineLength(line=""){


        if(line="" || line=-1)


            line:=this.LineFromPosition()


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_LineLength,"PTR",line,"PTR")


    }


    LineFromPosition(pos=""){


        if(pos="")


            pos:=this.GetCurrentPos()


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_LINEFROMPOSITION,"PTR",pos,"PTR")


    }


    


    


    SetSelectionStart(s){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSELECTIONSTART,"PTR",s,"PTR")


    }


    SetSelectionEnd(e){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSELECTIONEND,"PTR",e,"PTR")


    }


    SetCurrentPos(s){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetCurrentPos,"PTR",s,"PTR")


    }


    SetAnchor(e){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetAnchor,"PTR",e,"PTR")


    }


    SetSel(s="", e=""){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSel,"PTR",s,"PTR",e, "PTR")


    }


    


    


    _SetSelectionStart(s){


        if Strlen(Text:=this.GetText())=this.GetLength(){


            return this.SetSelectionStart(s)


        }


        WordToCharPos(Text, s)


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSELECTIONSTART,"PTR",s,"PTR")


    }


    _SetSelectionEnd(e){


        if Strlen(Text:=this.GetText())=this.GetLength(){


            return this.SetSelectionEnd(e)


        }


        WordToCharPos(Text, e)


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSELECTIONEND,"PTR",e,"PTR")


    }


    _SetCurrentPos(s){


        if Strlen(Text:=this.GetText())=this.GetLength(){


            return this.SetCurrentPos(s)


        }


        WordToCharPos(Text, s)


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetCurrentPos,"PTR",s,"PTR")


    }


    _SetAnchor(e){


        if Strlen(Text:=this.GetText())=this.GetLength(){


            return this.SetAnchor(e)


        }


        WordToCharPos(Text, e)


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetAnchor,"PTR",e,"PTR")


    }


    _SetSel(s="", e=""){


        if Strlen(Text:=this.GetText())=this.GetLength(){


            return this.SetSel(s,e)


        }


        WordToCharPos(Text, s, e)


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSel,"PTR",s,"PTR",e, "PTR")


    }


    


    


    SelAll(){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SELECTALL,"PTR")


    }   


    


    GetLength(){


        return this.GetTextLength()


    }


    GetTextLength(){


        Return DllCall("SendMessage","PTR",this.hwnd,"UInt",SCI_GETTEXTLENGTH,"PTR",0,"PTR",0,"PTR")


    }


    ScrollCaret(){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ScrollCaret,"PTR")


    }


    ScrollRange(secondary="", primary=""){


        this.GetSel(s, e)


        if(primary="")


            primary:=e


        if(secondary="")


            secondary:=s


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ScrollRange,"PTR",secondary, "PTR", primary,"PTR")


    }


    ClearAll(){


        return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ClearAll,"PTR")


    }


    Do(command){


        if command is not integer


            command:=%command%


        try


            return DllCall("SendMessage","PTR",this.hwnd,"UINT", command,"PTR")


    }


}





;--------------include: F:\scripts\Autohotkey\Lib\.NetGetControl.ahk------------





;~ #include <getControlNameByHwnd64>








hModuleKernel := DllCall("LoadLibrary", "Str", "Kernel32.dll", "Ptr")  





listAccChildProperty(hwnd){


	


}	





;~ #include <risimpax>


;~ MsgBox % getControlNameByHwnd(RisOpened()[2],0xC1BC8)


;~ ExitApp





getControlNameByHwnd(winHwnd,controlHwnd, tried=0){


	;~ if(A_Is64bitOS){


		;~ if WinExist("ahk_exe getControlNameByHwnd64.exe")


			;~ return getControlNameByHwnd64(winHwnd, controlHwnd)


	;~ }


	bufSize:=1024


	winget,processID,pid,ahk_id %winHwnd%


	VarSetCapacity(var1,bufSize)


	getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )


	if(ErrorLevel || !getName)


		goto getControlNameByHwnd_FAIL


	


	;~ dwResult:=DllCall("GetWindowThreadProcessId", "Ptr", winHwnd)


	;~ if(ErrorLevel && ErrorLevel!="A-4" )


		;~ goto getControlNameByHwnd_FAIL


	


	hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID, "Ptr")


	if(ErrorLevel || !hProcess)


		goto getControlNameByHwnd_FAIL


	


	otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")


	if(ErrorLevel || !otherMem)


		goto getControlNameByHwnd_FAIL





	SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %controlHwnd%


	if(ErrorLevel="FAIL")


		goto getControlNameByHwnd_FAIL


	


	DllCall("ReadProcessMemory","Ptr",hProcess,"Ptr",otherMem,"Str",var1,"UInt",bufSize,"Ptr",0)


	,DllCall("VirtualFreeEx","Ptr", hProcess,"Ptr",otherMem,"UInt", 0, "UInt", 0x8000)


	,DllCall("CloseHandle","Ptr",hProcess)


	return var1


getControlNameByHwnd_FAIL:


	;~ ToolTip % "A_LastError: " A_LastError


	if(tried>2)


		return A_LastError


	else


		return getControlNameByHwnd(winHwnd, controlHwnd, ++tried)


}





getControlNameByHwnd64(winHwnd, controlHwnd){


	return


	SetBatchLines,-1


	DetectHiddenWindows,on


	process,Exist,getControlNameByHwnd64.exe


	if(!ErrorLevel){


		ToolTip % "Please run ""getControlNameByHwnd64.exe""!"


		return


	}


	


	processID:=ErrorLevel


	


	bufSize=65536


	VarSetCapacity(var1,bufSize)


	getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )


	if(ErrorLevel || !getName)


		return A_LastError


	


	


	;~ dwResult:=DllCall("GetWindowThreadProcessId", "Ptr", winHwnd)


	;~ if(!dwResult)


		;~ return A_LastError


	


	hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID, "Ptr")


	if(ErrorLevel || !hProcess)


		return A_LastError


	


	otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")


	if(ErrorLevel || !otherMem)


		return A_LastError





	SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %controlHwnd%


	if(ErrorLevel="FAIL")


		return


	DllCall("ReadProcessMemory","Ptr",hProcess,"Ptr",otherMem,"Str",var1,"UInt",bufSize,"Ptr",0)


	,DllCall("VirtualFreeEx","Ptr", hProcess,"Ptr",otherMem,"UInt", 0, "UInt", 0x8000)


	,DllCall("CloseHandle","Ptr",hProcess)


	return var1


	


}








getControlNameByHwnd2(_, controlHwnd){


	UIAutomation := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")


	,DllCall(NumGet(NumGet(UIAutomation+0)+6*A_PtrSize), "Ptr", UIAutomation, "Ptr", controlHwnd, "Ptr*", IUIAutomationElement)


	,DllCall(NumGet(NumGet(IUIAutomationElement+0)+29*A_PtrSize), "Ptr", IUIAutomationElement, "Ptr*", automationId)


	,ret := StrGet(automationId,, "UTF-16")


	,DllCall("oleaut32\SysFreeString", "Ptr", automationId)


	,ObjRelease(IUIAutomationElement)


	,ObjRelease(UIAutomation)


	return ret


}





;~ a:=A_TickCount


;~ Loop 100


	;~ ToolTip % getByControlName2(RisOpened()[2],"EXAMITEM")[1]


;~ MsgBox % A_TickCount-a


;~ ExitApp





; search by control name


; return hwnd 


getByControlName(winHwnd,name){


	winget,controlList,controlListhwnd,ahk_id %winHwnd%


    arr:=[]


    ,bufSize=1024


	winget,processID,pid,ahk_id %winHwnd%


	VarSetCapacity(var1,bufSize)


	if !(getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )) || ErrorLevel


        return []


	dwResult:=DllCall("GetWindowThreadProcessId", "Ptr", winHwnd)


      


	if !(hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID), "Ptr") || ErrorLevel


        return []


    if !(otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")) || ErrorLevel


        return []


    


	loop,parse,controlList,`n


	{


        SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %a_loopfield%


        if errorlevel=FAIL


            return []


        if !DllCall("ReadProcessMemory","Ptr",hProcess,"Ptr",otherMem,"Str",var1,"UInt",bufSize,"Ptr",0)


            return []


        if (var1=name)


            arr.push(a_loopfield)


            ,var1:=""


	}


    


    DllCall("VirtualFreeEx","Ptr", hProcess,"Ptr",otherMem,"UInt", 0, "UInt", 0x8000)


	,DllCall("CloseHandle","Ptr",hProcess)


    return arr


}





getByControlName2(winHwnd,name){


	winget,controlList,controlListhwnd,ahk_id %winHwnd%


    arr:=[], UIAutomation := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")


	Loop,Parse,controllist,`n


	{


		controlHwnd:=A_LoopField


		,DllCall(NumGet(NumGet(UIAutomation+0)+6*A_PtrSize), "Ptr", UIAutomation, "Ptr", controlHwnd, "Ptr*", IUIAutomationElement)


		,DllCall(NumGet(NumGet(IUIAutomationElement+0)+29*A_PtrSize), "Ptr", IUIAutomationElement, "Ptr*", automationId)


		,controlName := StrGet(automationId,, "UTF-16")


		


		if(controlName = name){


			;~ ret:=controlHwnd


			;~ break


			arr.push(controlHwnd)


		}


	}


	


	if (automationId)


		DllCall("oleaut32\SysFreeString", "Ptr", automationId)


	if (IUIAutomationElement)


		ObjRelease(IUIAutomationElement)


	ObjRelease(UIAutomation)


	return arr


	


}

















controlGetText(hwnd){


	if IsObject(hwnd) {


		if (hwnd.__Class="Scintilla") {


			Text:=""


			if (len:=hwnd.GetTextLength())>0


				hwnd.GetText(hwnd.GetTextLength()+4, Text)


		}else if (hwnd.__Class="RemoteScintilla"){


			Text:=hwnd.GetText()


		}


		return Text


	}


	


	WinGetClass,class,ahk_id %hwnd%


	if (class="scintilla") {


		hwnd:=new RemoteScintilla(hwnd)


		return hwnd.GetText()


	}else {


		controlgettext,t,,ahk_id %hwnd%


	}


	return t


}





winGetClass(hwnd){


	WinGetClass,cl,ahk_id %hwnd%


	return cl


}








getNetAcc(winHwnd,controlName,classNN,shift=0,acc=true,name="",text="", getNonEmpty=false){


	ret:=getNetControl2(winHwnd,text,controlName,name,classNN,"","","",shift)


	


	if(getNonEmpty || InStr(classNN,"Edit"))


		ret:=getNonEmptyControl(ret)


	


	if (acc){


		return acc_objectfromwindow(ret[1])


	}else 


		return ret[1]


}





/*


param[n].winHwnd


param[n].text


...


*/





getNetControls(ByRef param){


	ret:=[]


	,winHwndControls:=[]


	


	for k,v in param {


		if !IsObject(v) {


			oneParam:=true


			v:=param


		}


		if (winHwnd:=v.winHwnd) && WinExist("ahk_id " winHwnd) {


			if(winHwndControls.hasKey(winHwnd))


				list:=winHwndControls[winHwnd]


			else{


				winget,list,controllisthwnd,ahk_id %winHwnd%


				winHwndControls[winHwnd]:=list


			}


		}else{


			continue


		}


		


		for x,y in ["text", "ClassNN", "controlName", "accName", "accHelp", "accRole", "style", "shift", "getNonEmpty"]


			%y%:=v[y]


		if(shift="")


			shift:=0


		arr:=[],controlArr:=[]


		loop,parse,list,`n 


		{


			controlArr.push(a_loopfield)


			if (text="" || instr(controlgettext(a_loopfield),text)) && (classNN="" || instr(winGetClass(a_loopfield),classNN)) && (controlName="" || getControlNameByHwnd(winHwnd,a_loopfield)=controlName) && (accName="" || instr((acc:=acc_objectfromwindow(a_loopfield)).accName,accName)) && (accHelp="" || instr(acc.accHelp,accHelp)) && (accRole="" || instr(acc.accRole,accRole)) && (!style || DllCall("GetWindowLong",Ptr,a_loopfield,Int,-16)=style)


				arr[a_index]:=a_loopfield


		}


		result:=[]


		


		for k,v in arr


			if (r:=controlArr[k+shift])


				result.push(r)


		


		


		


		if(oneParam)


			return getNonEmpty?getNonEmptyControl(result):result


		else{


			ret.push(getNonEmpty?getNonEmptyControl(result):result)


		}


	}


	return ret


	


}





;getNetControl2(syngoViaState[2],"","myHostedTextbox","","WindowsForms10.EDIT","","","",0)[1]


;~ getSyngoCommonContainerWindows(){


		;~ winget,list,list,ahk_exe syngo.Common.Container.exe


		;~ arr:=[]


		;~ loop % list


			;~ arr.push(list%a_index%)


		;~ return arr


	;~ }


;~ getNetAcc(getSyngoCommonContainerWindows(),"OncologyTask_CP_Oncology@ShowHideLungCAD","Button",0,0)


getNetControl2(winHwnd,text="",controlName="",accName="",classNN="",accHelp="",accRole="",style="",shift=0, result="", getNonEmpty=false){


	if !isobject(result)


		result:=[]


	


	if isobject(winHwnd){


		


		for k,v in winHwnd


			getNetControl2(v,text,controlName,accName,classNN,accHelp,accRole,style,shift,result)


		return getNonEmpty?getNonEmptyControl(result):result


	}


	


	winget,list,controllisthwnd,ahk_id %winHwnd%


	arr:=[],controlArr:=[]


	loop,parse,list,`n 


	{


		controlArr.push(a_loopfield)


		;~ if(getControlNameByHwnd(winHwnd,a_loopfield)=controlName){


			;~ MsgBox % winGetClass(a_loopfield)


		;~ }


		if (text="" || instr(controlgettext(a_loopfield),text)) && (classNN="" || instr(winGetClass(a_loopfield),classNN)) && (controlName="" || getControlNameByHwnd(winHwnd,a_loopfield)=controlName) && (accName="" || instr((acc:=acc_objectfromwindow(a_loopfield)).accName,accName)) && (accHelp="" || instr(acc.accHelp,accHelp)) && (accRole="" || instr(acc.accRole,accRole)) && (!style || DllCall("GetWindowLong",Ptr,a_loopfield,Int,-16)=style)


			arr[a_index]:=a_loopfield


	}


	;~ result:=[]


	


	for k,v in arr


		if (r:=controlArr[k+shift])


			result.push(r)


	


	return getNonEmpty?getNonEmptyControl(result):result


}





getNonEmptyControl(ByRef arr, acc=false){


	ret:=[]


	if(!acc){


		for k,v in arr


			if ControlGetText(v)!=""


				ret.push(v)


	}else{


		for k,v in arr


			if (v.accValue!="")


				ret.push(v)


	}


	return ret.maxindex()>0?ret:[arr[1]]


}





getNetControlGlobal(text="",controlName="",accName="",classNN="",accHelp="",accRole="",style="",shift=0){


	ret:=[],win=[]


	DetectHiddenWindows,on


	winget,lst,list


	loop % lst {


		winhwnd:=lst%a_index%


		a:=getNetControl2(winHwnd,text,controlName,accName,classNN,accHelp,accRole,style,shift)


		if (a.maxindex()){


			for k,v in a


				ret.push(v)


			b:=[]


			b["" winHwnd]:=a


			win.push(b)


		}


	}


	return [ret,win]


}


	





; search for specific control


; return hwnd


getNetControl(winHwnd,controlName="",accName="",classNN="",accHelp=""){


	winget,list,controllisthwnd,ahk_id %winHwnd%


	


	bufSize=1024


	winget,processID,pid,ahk_id %winHwnd%


	VarSetCapacity(var1,bufSize)


	getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )


	if(ErrorLevel || !getName)


		return A_LastError


	


	;~ dwResult:=DllCall("GetWindowThreadProcessId", "Ptr", winHwnd)


	;~ if(ErrorLevel || !dwResult)


		;~ return A_LastError


	


	hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID, "Ptr")


	if(ErrorLevel || !hProcess)


		return A_LastError


	


	otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")


	if(ErrorLevel || !otherMem)


		return A_LastError





	count=0


	;~ static hModule := DllCall("LoadLibrary", "Str", "oleacc", "Ptr")


	;~ static hModule2 := DllCall("LoadLibrary", "Str", "Kernel32", "Ptr")


	;~ static AccessibleObjectFromWindowProc := DllCall("GetProcAddress", Ptr, DllCall("GetModuleHandle", Str, "oleacc", "Ptr"), AStr, "AccessibleObjectFromWindow", "Ptr")


	;~ static ReadProcessMemoryProc:=DllCall("ReadProcessMemory", Ptr, DllCall("GetModuleHandle", Str, "Kernel32", "Ptr"), AStr, "AccessibleChildren", "Ptr")


	;~ msgbox % AccessibleObjectFromWindowProc


	;~ static idObject:=-4


	loop,parse,list,`n


	{


		SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %a_loopfield%


        if !DllCall("ReadProcessMemory","Ptr",hProcess,"Ptr",otherMem,"Str",var1,"UInt",bufSize,"UInt *",0) || ErrorLevel


			continue


		


		;~ acc:=acc_objectfromwindow2(a_loopfield)


		


		;~ if !DllCall(AccessibleObjectFromWindowProc, "Ptr", a_loopfield, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)


			;~ acc:=ComObjEnwrap(9,pacc,1)


		;~ else


			;~ acc:=""


		


		


		


		


	;&&(accParentHwnd=""||acc_windowfromobject(acc.accParent)=accParentHwnd)


		if ((var1&&var1=controlName)&&(accName=""||(acc:=Acc_ObjectFromWindow(a_loopfield)).accName=accName)){


			WinGetClass,cl,ahk_id %a_loopfield%


			if(instr(cl,classNN)=1&&(accHelp=""||acc.accHelp=accHelp)) {


				ret:=a_loopfield


				break


			}


		}


		


		var1:=""


	}


	


    DllCall("VirtualFreeEx","Ptr", hProcess,"Ptr",otherMem,"UInt", 0, "UInt", 0x8000)


	,DllCall("CloseHandle","Ptr",hProcess)


	,DllCall("FreeLibrary", "Ptr", hModule)


	return ret


	


}





;~ clipboard:=getControlDescription(0x27048E,0x680532)


;~ clipboard:=getControlDescription(0x3e0784,0x380CA4)


getControlDescription(winHwnd,controlHwnd){


	return "getNetControl2(RisState[2],""" controlgettext(controlHwnd) """,""" getControlNameByHwnd(winHwnd,controlHwnd) """,""" (acc:=acc_objectfromwindow(controlHwnd)).accName """,""" winGetClass(controlHwnd) """,""" acc.accHelp """,""" acc.accRole """,""" DllCall("GetWindowLong",Ptr,controlHwnd,Int,-16) """,0)"	


}








;--------------include: F:\scripts\Autohotkey\Lib\RisImpax.ahk------------





;~ #include <WM_COPYDATA>








;~ #include <EditFunctions>














DetectHiddenWindows,on





;~ SendMessage,4388,,,,ahk_id 0x4c2fc0





;~ SetTitleMatchMode,2


;~ clipboard:=ListControls(2______)


;~ ExitApp


;~ msgbox % risopened()[2]


;~ clipboard:=listcontrols(impaxopened()[2,1])








/*


*/


RisImpaxLoadPw(){


	static fileName:="RisImpaxPw.ini"


	ret:={Ris:[], Impax:[]}


	if FileExist(path:=A_ScriptDir "\" fileName)


		|| FileExist(path:=A_ScriptDir "\..\" fileName)


		|| FileExist(path:=SubStr(A_ScriptDir,1,1) ":scripts\Radiology\" fileName) {


		loop {


			IniRead,user,% path,Ris,% "user" A_Index,% "$%^&*"


			IniRead,pw,% path,Ris,% "pw" A_Index


			if(user!="$%^&*")


				ret.Ris.push({user: user, pw: pw})


			else


				break


		}


		


		loop {


			IniRead,user,% path,Impax,% "user" A_Index,% "$%^&*"


			IniRead,pw,% path,Impax,% "pw" A_Index


			if(user!="$%^&*")


				ret.Impax.push({user: user, pw: pw})


			else


				break


		}


		


		return ret


	}


	


}





RisImpaxPollingInit(){


	static exeNAme:="RisImpaxPolling.exe"


	if (hwnd:=WinExist("RisImpaxPolling_Main ahk_class AutoHotkeyGUI")) || (hwnd:=WinExist("ahk_exe " exeName))


		return hwnd


	if FileExist(path:=A_ScriptDir "\" exeName) || FileExist(path:=A_ScriptDir "\..\" exeName) || FileExist(path:=A_ScriptDir "\RisImpaxPolling\" exeName) || FileExist(path:=A_ScriptDir "\..\RisImpaxPolling\" exeName) || FileExist(path:=SubStr(A_ScriptDir,1,1) ":\scripts\Radiology\RisServer\" exeName)  || FileExist(path:=A_ScriptDir "\..simpleRIS\" exeName) {


		Run % path


		winwait,% "ahk_exe " exeName,,3


		if !ErrorLevel


			return RisImpaxPollingInit()


	}


	return 0


}





/*


infoJson := [ {app: "Ris", type: "State/AccNo/OldReport", hwnd: thisHwnd, msg: {msg: returnMsg, wParam: returnWParam, lParam: returnLParam}} 


					, {app: "Impax", type: "State/AccNo", hwnd: thisHwnd, msg: {msg: returnMsg, wParam: returnWParam, lParam: returnLParam}} ]


*/


RisImpaxRegister(infoJson){


	if !(hwnd:=RisImpaxPollingInit())


		return 1


	


	Send_WM_COPYDATA(hwnd, 0, JXON_Dump(infoJson))


	SetTimerF("RisImpaxRegisterMonitor", 30000, [hwnd, infoJson])


}





RisImpaxRegisterMonitor(hwnd, infoJson){


	if !WinExist("ahk_id " hwnd)


		if (hwnd:=RisImpaxPollingInit())


			Send_WM_COPYDATA(hwnd, 0, JXON_Dump(infoJson))


			,SetTimerF("RisImpaxRegisterMonitor", 0)


			,SetTimerF("RisImpaxRegisterMonitor", 30000, [hwnd, infoJson])


}





RisImpaxMsgProtocol(){


	global


	local k,v


	registerRisChangeMsg:=[0x1000, 0x1003]


	,registerRisChangeItem:=["ris", "risAcc", "risReport", "risOldReport"]


	,registerImpaxChangeMsg:=[0x2000,0x2001]


	,registerImpaxChangeItem:=["impax", "impaxAcc"]


	,RisImpaxChangeMsg2Item:=[]


	,RisImpaxChangeItem2Msg:=[]


	


	loop % registerRisChangeMsg.2-registerRisChangeMsg.1+1 {


		RisImpaxChangeMsg2Item[registerRisChangeMsg.1+A_Index-1]:=registerRisChangeItem[A_Index]


		,RisImpaxChangeItem2Msg[registerRisChangeItem[A_Index]]:=registerRisChangeMsg.1+A_Index-1


	}


	loop % registerImpaxChangeMsg.2-registerImpaxChangeMsg.1+1 {


		RisImpaxChangeMsg2Item[registerImpaxChangeMsg.1+A_Index-1]:=registerImpaxChangeItem[A_Index]


		,RisImpaxChangeItem2Msg[registerImpaxChangeItem[A_Index]]:=registerImpaxChangeMsg.1+A_Index-1


	}





}








checkRIS(byref RisState,refresh=1){


	SetTitleMatchMode,2


	winget,winList,list,放射線資訊管理系統(Radiology Information System)


	match:=0


	loop % winList


	{


		wingetclass, winClass,% "ahk_id " id:=winList%a_index%


		if instr(winClass,"WindowsForms10.Window.8.app.") && id=RisState[2] {


			match:=1


			break


		}


	}


	if (!match && refresh){


		if !IsObject(RisState)


			RisState:=[]


		for k,v in RisOpened()


			RisState[k]:=v


	}


	return match


}











/* check if RIS opened


	[0, 0]: no


	[1, HWND]: wait for login


	[2, HWND]: opened


	


	


	for multiple RIS


		1: [HWNDs]


	2: [HWNDs]


*/


;~ risopened()[1]


;~ msgbox % dllcall("IsHungAppWindow", "UInt", risopened()[2])





RisOpened(allRis=0)


{


	if (A_TitleMatchMode!=2){


		oldTitleMatchMode:=A_TitleMatchMode


		SetTitleMatchMode,2


	}


	if( A_DetectHiddenWindows!="on" ){


		oldDetectHiddenWindows:=A_DetectHiddenWindows


		detectHiddenWindows,on


	}	


	


	


	if(allRis=0){


		


		winget,winList,list,放射線資訊管理系統(Radiology Information System)


		winget,activeWin,id,A


		loop % winList


		{


			wingetclass, winClass,% "ahk_id " winList%a_index%


			if instr(winClass,"WindowsForms10.Window.8.app."){


				return array(2,winList%a_index%)


				


			}


		}


		


		winget,winList,list,RIS系統登入<<陽明資訊>>


		loop % winList


		{


			wingetclass, winClass,% "ahk_id " winList%a_index%


			if instr(winClass,"WindowsForms10.Window.8.app."){


				return array(1,winList%a_index%)


				


			}


		}


		


		return array(0,0)


	}else{


		


		


		ret:=[]


		arr1:=[], arr2:=[]


		winget,winList,list,放射線資訊管理系統(Radiology Information System) ahk_exe Menu.exe


		loop % winList


			if dllcall("IsHungAppWindow", "Ptr", winList%a_index%)


				process,close,% "ahk_id " winList%a_index%


		else if(winvisible(winList%a_index%))


			arr1.push(winList%a_index%)


		else


			arr2.push(winList%a_index%)


		


		ret[2]:=[]


		for k,v in arr1


			ret[2].push(v)


		for k,v in arr2


			ret[2].push(v)


		


		ret[1]:=[]


		winget,winList,list,RIS系統登入<<陽明資訊>> ahk_exe Menu.exe


		loop % winList


			ret[1].push(winList%a_index%)


		


		


	}


	


	if(oldTitleMatchMode)


		SetTitleMatchMode,% oldTitleMatchMode


	if(oldDetectHiddenWindows)


		DetectHiddenWindows,% oldDetectHiddenWindows


	


	


	return ret


	


	


}





GetControls(hwnd, controls="")


{


	if !isobject(controls)


		controls:=[]


	


	if isobject(hwnd){


		for k,v in hwnd 


			controls:=GetControls(v, controls)


		return controls


	}


	


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





GetOtherControl(refHwnd,shift,controls,type="hwnd"){


	for k,v in controls


		if v[type]=refHwnd


			return controls[k+shift].hwnd


}





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





GetControlIdByText(byref arr,RefControlText,offset=0,UseRegEx=0)


{


	if !isobject(arr)||!arr.maxIndex()


		return


	k=0


	if UseRegEx


	{


		for k,v in arr


			if RegExMatch(v.text,RefControltext)


				break


	}


	else


	{


		for k,v in arr


			if v.text=RefControltext


				break


		if !k


			for k,v in arr


				if instr(v.text,RefControltext)


					break


	}


	


	if !offset


		i:=k


	else


	{


		i:=k+offset


		l:=arr.MaxIndex()


		while i>l


			i-=l


		while i<1


			i+=l


	}


	return (k=0 ? 0 : arr[i]["Hwnd"])


	


}





;~ run % GetRisPath(1)


GetRisPath(direct=0){


	if(direct=0){


		if fileexist(path:=a_desktop "\放射線資訊管理系統(Radiology Information System).appref-ms")


			return path


		


		if fileexist(path:=a_desktop "\RIS.appref-ms")


			return path


		


		if fileexist(path:=A_StartMenu "\Programs\放射線資訊管理系統(Radiology Information System).appref-ms")


			return path


		if fileexist(path:=A_StartMenu "\程式集\放射線資訊管理系統(Radiology Information System).appref-ms")


			return path


		if fileexist(path:=A_StartMenu "\Programs\陽明資訊\RIS.appref-ms")


			return path


		if fileexist(path:=A_StartMenu "\程式集\陽明資訊\RIS.appref-ms")


			return path


	}


	


	loop,HKCU,Software\Microsoft\Windows\ShellNoRoam\MUICache


		if instr(a_loopregname,"Menu.exe") && fileexist(a_loopregname)


			return a_loopregname


	loop,HKCU,Software\Microsoft\Internet Explorer\TypedURLs


	{


		regread,v


		if instr(a,"Menu.exe") && fileexist(v)


			return v


	}


	if (a:=searchFile("Menu.exe",substr(a_windir,1,3) "Documents and Settings\" a_username "\Local Settings\Apps\2.0")).maxindex()


		return a[a.maxindex()]


	


	


	return 0


	


}





;~ if (a:=searchFile("Menu.exe",substr(a_windir,1,3) "Documents and Settings\" a_username "\Local Settings\Apps\2.0")).maxindex()


		;~ clipboard:= a[1]





ListControls(hwnd, obj=0, arr="")


{


	if !isobject(arr)


		arr:=[]


	


	if isobject(hwnd){


		for k,v in hwnd


			arr:=ListControls(v, 1, arr)


		goto ListControlsReturn


	}


		


	str=


	arr:=GetControls(hwnd)


ListControlsReturn:


	if obj


		return arr


	


	for k,v in arr


		str.="""" v["Hwnd"] """,""" v["ClassNN"] """,""" v["text"] """,""" getControlNameByHwnd(hwnd,v["Hwnd"]) """`n"


	return str


}





/* 


	return switch bar: hwnd, x,y,w,h


*/


ImpaxBar(impaxStateOrHwnd){


	if isobject(impaxStateOrHwnd)


		hwnd:=impaxStateOrHwnd[2,2] | impaxStateOrHwnd[2,3]


	else


		hwnd:=impaxStateOrHwnd


	


	for k,v in (impaxControls:=getcontrols(hwnd)) {


		if ((v.text="登出"||v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(impaxControls[k-2].classNN,"WindowsForms10.Window.8.app")) {


			controlgetpos,x,y,w,h,,% "ahk_id " barId:=impaxControls[k-2].hwnd


			break


		}


	}


	return {hwnd:barId, x:x, y:y, w:w, h:h}


}





/*


	ImpaxStateArr[1]=image window (in  monitor), ImpaxStateArr[2]=search window


	which=0, switch to search page


	which=1, switch to image page


*/


ImpaxSwitchPage(ImpaxStateArr,which=0,bar=""){


	if !bar


		bar:=ImpaxBar(ImpaxStateArr[2])


	wingetpos,winx,winy,,,% "ahk_id " ImpaxStateArr[2]


	if (which=0){


		winactivate,% "ahk_id " ImpaxStateArr[2]


		controlclick,,% "ahk_id " bar.hwnd


	} else if (which=1) {


		if(ImpaxState[1]) {


			winactivate,% "ahk_id " ImpaxStateArr[1]


		}else if !(bar.h>100) {


			mouseclick,,% winx+bar.x+bar.w/3,% winy+bar.y+10,,0


		}


		


	}


}





/*


	arr[1,1]=main findings


	arr[1,2]=main impression


	arr[1,3]=main suggestion


	arr[2,1]=prior findings


	arr[2,2]=prior impression


	arr[2,3]=prior suggestion


	to be editted!!


*/


;~ msgbox % controlgettext(getRisReports(RisOpened()[2])[1,1])


;~ ExitApp


getRisReports(risHwnd=""){


	if !WinExist(RisHwnd)


		RisHwnd:=risOpened()[2]


	


	arr:=[]


	for k,v in risControls:=getcontrols(risHwnd) {


		if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {


			temp:=k


			break


		}


	}


	for k,v in risControls {


		if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app")) {


			if(abs(k-temp)<18){


				arr[1]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"],risControls[k+7]["hwnd"])


			}else if (risControls[k-13,"text"]="歷史報告") || (risControls[k-12,"text"]="歷史報告") {


				arr[2]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"],risControls[k+7]["hwnd"])


			}else if (risControls[k-12,"text"]="報告版本查詢") || (risControls[k-11,"text"]="報告版本查詢") {


				arr[3]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"])


			}


		}


	}


	return arr


}





getRisReportsHwnd(risHwnd){


	for k,v in risControls:=getcontrols(risHwnd) {


		if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {


			temp:=k


			break


		}


	}


	for k,v in risControls {


		if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && abs(k-temp)<13) {


			return array(risControls[k+1]["hwnd"])


			break


		}


		


	}	


	return []


	


}














getTextByHwnd(id){


	controlgettext,t,,ahk_id %id%


	return t


}





;~ getChartNo(id){


	;~ for k,v in risControls:=getcontrols(id) {


		;~ if RegExMatch(v.text,"(\w)\w{5}\d") && instr(v.classNN,"WindowsForms10.EDIT.app") && risControls[k-1].text="???" && risControls[k+2].text="??" {


			;~ return v.text


		;~ }


	;~ }


;~ }


;~ info:=getImpaxInfo("",["chartNo"])


;~ b=1


getImpaxInfo(ByRef impaxState, ByRef items){


	params:=[]


	if !IsObject(impaxState)


		for k,v in impaxOpened()


			if isobject(v)


				for x,y in v


					impaxState[k,x]:=y


			else


				impaxState[k]:=v


	for k,v in items


		if IsFunc(FuncName:="getImpax" v){


			func:=func(FuncName), param:=[impaxState]


			Loop % func.MaxParams-2


				param.push("")


			param.push(true)


			,params.push(func.call(param*))


		}


	result:=getNetControls(params)


	info:=[]


	for k,v in items


		info[v]:=ControlGetText(result[k].1)


	return info


	


}





getImpaxChartNo(impaxStateOrHwnd="", returnFilter=false){


	


	if isobject(impaxStateOrHwnd)


		hwnd:=impaxStateOrHwnd[2,1] 


	else if (impaxStateOrHwnd)


		hwnd:=impaxStateOrHwnd 


	else


		hwnd:=impaxopened()[2,1]


	if (returnFilter)


		return {winHwnd: hwnd, controlName: "patientIdLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}


	


	controlgettext,chartNo,,% "ahk_id " getNetControl2(hwnd,"","patientIdLabel","","WindowsForms10.STATIC.app","","","",0)[1]


	


	if(chartNo="")


		return


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	return chartNo


}


getImpaxUserId(impaxStateOrHwnd="", returnFilter=false){


	


	if isobject(impaxStateOrHwnd)


		hwnd:=impaxStateOrHwnd[2,2] | impaxStateOrHwnd[2,3]


	else if (impaxStateOrHwnd)


		hwnd:=impaxStateOrHwnd 


	else


		hwnd:=impaxopened()[2,1]


	if (returnFilter)


		return {winHwnd: hwnd, controlName: "userIDLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}


	controlgettext,UserId,,% "ahk_id " getNetControl2(hwnd,"","userIDLabel","","WindowsForms10.STATIC.app","","","",0)[1]


	


	return UserId


}





;~ msgbox % getImpaxAccNo()





getImpaxAccNo(impaxStateOrHwnd="",leftUpper=1, returnFilter=false){


	if isobject(impaxStateOrHwnd)


		hwnd:=impaxStateOrHwnd[2,1] 


	else if (impaxStateOrHwnd)


		hwnd:=impaxStateOrHwnd 


	else


		hwnd:=impaxopened()[2,1]


	if (returnFilter)


		return {winHwnd: hwnd, controlName: "accessionNumberLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}


	


	


	if(leftUpper="")


		leftUpper:=1


	


	con:=getNetControl2(hwnd,"","accessionNumberLabel","","WindowsForms10.STATIC.app","","","",0)


	controlgettext,AccNo,,% "ahk_id " selectControlByPos(con)


	


	return AccNo


}


;~ getTopParent(0x1C0BB2)


;~ winget,class,processname,ahk_id 1______


;~ msgbox % class


;~ getTopParent(hwnd){


	;~ while (hwnd!=(parent:=DllCall("GetParent", "int" , hwnd))) && parent


		;~ hwnd:=parent


	;~ return hwnd


;~ }





selectControlByPos(byref controlArr,mostLeft=1,mostUpper=0,first=1){


	selected:=[],ind:=1


	selected[ind]:=controlArr[1]


	controlgetpos,cx,cy,,,,% "ahk_id " controlArr[1]


	


	if(mostLeft=0&&mostUpper=0)


		mostLeft:=1


	


	for k,v in controlArr {


		if k=1


			continue


		controlgetpos,x,y,,,,ahk_id %v%


		if (x=cx && y=cy)


			selected[++ind]:=v


		else if  (((mostLeft=1 && x<cx) || (mostLeft=-1 && x>cx)) && mostUpper=0)


			|| (((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)) && mostLeft=0)


			|| (((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)) && ((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)))


			|| ((x=cx) && mostUpper=0 && y<cy)


			|| ((y=cy) && mostLeft=0 && x<cx)


			selected:=[],ind:=1,selected[1]:=v


		


		


		cx:=x,cy:=y


	}


	


	if(first)


		return selected[1]


	else


		return selected


	


}








;~ msgbox % getRisChartNo(RisOpened()[2])


;~ ExitApp


getChartNo(id){


	return getRisChartNo(id)


}


getRisChartNo(hwnd){


	;~ controlgettext,chartNo,,% "ahk_id " (ids:=getNetControl2(hwnd,"???","FID_LABEL","???","WindowsForms10.STATIC.app.0.378734a","","","",1))[2]


	;~ if chartNo=


		;~ controlgettext,chartNo,,% "ahk_id " ids[1]


	;~ while strlen(chartNo)<7


		;~ chartNo:="0" chartNo


	


	;~ return chartno


	


	static prvHwnd


	for k,v in controls:=getcontrols(hwnd)


		if RegExMatch(v.text,"^\w{6}\d$") && controls[k-1].text="病歷號"


			chartNo:=v.text, prvHwnd:=v.hwnd


	


	if(chartNo="")


		chartNo:=ControlGetText(prvHwnd)


	


	if chartNo!=


		while strlen(chartNo)<7 


			chartNo:="0" chartNo


	


	return chartNo


	


	for k,v in getcontrols(hwnd)


		if instr(v.classNN,"WindowsForms10.EDIT") && acc_objectfromwindow(v.hwnd).accName="病歷號"


		{


			controlgettext,str,,% "ahk_id " v.hwnd


			return str


		}


}


getRisChartNoHwnd(hwnd){


	static prvHwnd


	for k,v in controls:=getcontrols(hwnd)


		if RegExMatch(v.text,"^\w{6}\d$") && controls[k-1].text="病歷號"


			chartNo:=v.text,prvHwnd:=id:=v.hwnd


	


	;~ if chartNo!=


		;~ while strlen(chartNo)<7 


			;~ chartNo:="0" chartNo


	


	return prvHwnd


	


	for k,v in getcontrols(hwnd)


		if instr(v.classNN,"WindowsForms10.EDIT") && acc_objectfromwindow(v.hwnd).accName="病歷號"


		{


			;~ controlgettext,str,,% "ahk_id " v.hwnd


			return v.hwnd


		}


	


}





getRisAccNo(hwnd){


	return getRisSheetNo(hwnd)


}


getRisSheetNo(hwnd){


	static prvHwnd


	for k,v in controls:=getcontrols(hwnd)


		if controls[k-1].text="照會單號" && regexmatch(v.text,"^\w{11}$") && instr(v.classNN,"WindowsForms10.EDIT")


		{


			;~ controlgettext,str,,% "ahk_id " v.hwnd


			prvHwnd:=v.hwnd


			return v.text


		}


		


	return ControlGetText(prvHwnd)


}





getRisAccNoHwnd(risHwnd){


	static prvHwnd


	for k,v in controls:=getcontrols(risHwnd)


		if controls[k-1].text="照會單號" && regexmatch(v.text,"^\w{11}$") && instr(v.classNN,"WindowsForms10.EDIT")


		{


			;~ controlgettext,str,,% "ahk_id " v.hwnd


			return prvHwnd:=v.hwnd


		}


	return prvHwnd


}








getRisHistoryId(hwnd){


	static prvHwnd


	for k,v in controls:=getControls(hwnd)


		if (instr(v.classNN,"WindowsForms10.Window.8.app") && v.text="歷史報告" && instr(controls[k+3,"classNN"],"WindowsForms10.Window.8.app")){


			if (controlId:=controls[k+3,"hwnd"])


				return prvHwnd:=controlId


			


		}


	return prvHwnd


}





/*


	getRisHistory(hwnd,byref arr="",n=""){


		if !isobject(arr)


			arr:=[]


		


	;~ if !controlId:=getNetControl(hwnd,controlName:="dgHisReport",accName:="DataGridView",classNN:="WindowsForms",accHelp:="")


		;~ return arr


		


	;~ for k,v in controls:=getControls(hwnd)


		;~ if (instr(v.classNN,"WindowsForms10.Window.8.app") && v.text="????" && instr(controls[k+3,"classNN"],"WindowsForms10.Window.8.app")){


			;~ controlId:=controls[k+3,"hwnd"]


			;~ break


		;~ }


		


		if !(controlId:=getRisHistoryId(hwnd)) || !(acc:=acc_objectfromwindow(controlId))


			return


		


		acc:=acc_objectfromwindow(controlId)


		


		colNo:=[]


		loop % acc_children(acc_get("Object",1,0,acc)).maxindex()-1


			colNo["" acc_get("Value","1." a_index+1,0,acc)]:=a_index+1


		


		loop % (n=""?(acc_children(acc).maxindex()-1):1) {


			i:=(n=""?(a_index+1):n),arr2:=[]


			arr2["ExamDate"]:="" acc_get("Value",i "." colNo["???"],0,acc)


			arr2["DrName"]:="" acc_get("Value",i "." colNo["????"],0,acc)


			arr2["ExamName"]:="" acc_get("Value",i ".4" colNo["????"],0,acc)


			arr2["SheetNo"]:="" acc_get("Value",i ".5" colNo["????"],0,acc)


			arr2["ChartNo"]:="" acc_get("Value",i ".6" colNo["????"],0,acc)


			arr2["ReportIndex"]:="" acc_get("Value",i ".7" colNo["????"],0,acc)


			arr2["Hospital"]:="" acc_get("Value",i ".8" colNo["??"],0,acc)


			arr.push(arr2.clone())


		}


	;~ arr[0]:=acc


		return arr


	}


*/


getRisHistoryIndex(dgHisReportAcc,rowAcc){


	loop % acc_children(dgHisReportAcc).maxIndex()-1 {


		check:=true


		i:=a_index+1


		loop % acc_children(acc_get("Object",1,0,dgHisReportAcc)).maxindex()-1 {


			j:=A_Index


			check:=check & (acc_get("Value",i "." j,0,dgHisReportAcc)=acc_get("Value",j,0,rowAcc))


		}


		if (check)


			return i


	}	


	return 0


}





searchFile(f,dir){


	arr:=[]


	originalWorkingDir:=A_WorkingDir


	SetWorkingDir,% dir


	loop,% f,0,1


		arr.push(a_loopfilelongpath)


	SetWorkingDir,% originalWorkingDir


	return arr


}








searchRisChartNo(hwnd,AccNoOrChartNo, chartNo=""){


	static prvHwnd


	for k,v in controls:=getControls(hwnd)


		if (instr(v.text,"查詢單號") && instr(v.classNN,"WindowsForms10.STATIC")){


			thisHwnd:=prvHwnd:=controls[k+1].hwnd


			break


		}


	


	if(!thisHwnd)


		for k,v in controls


			if (instr(v.text,"病歷號") && instr(v.classNN,"WindowsForms10.STATIC") && !instr(controls[k-3].text,"照會單號")){


				thisHwnd:=prvHwnd:=controls[k+1].hwnd


				, useChartNo:=true


				break


			}


		


	if(!thisHwnd || (thisHwnd:=prvHwnd)){


		controlfocus,,% "ahk_id " thisHwnd


		controlsettext,,% useChartNo&&chartNo!=""?chartNo:AccNoOrChartNo,% "ahk_id " thisHwnd


		controlsend,,{Enter},% "ahk_id " thisHwnd


		return true


	}


	return false


}


; limit can be range: [2, 5] or [7, ] or [8]


; callback: func(rowIndex, rowAcc, cellsAcc)








parseDataGrid(hwnd,byref output="",is_acc=0,limit=0,sleep=0,start="",callback=""){


	


	if(is_acc=0)


		acc:=acc_ObjectFromWindow(hwnd)


		,rows:=acc_children(acc)


	else if(is_acc=1)


		rows:=hwnd


	rowsCount:=rows.maxIndex()


	;~ callback:=func(callback)


	


	if (output="")


		output:=[]


	;~ tmpArr:=[]


	;~ msgbox % start.1 "," 0+start.1 "," start.2


	;~ msgbox % acc_children(acc).maxindex()


	if (isobject(start) && !isobject(limit)){


		for k,v in rows {


			;~ if(!controlexist(hwnd,is_acc) && !acc_windowfromobject(acc_parent(hwnd[1]))){


				;~ OutputDebug, % "Data grid not exist!"


				;~ return output


			;~ }


			


			cells:=acc_children(v)


			if(cells[0+start.1].accValue=start.2)


				found:=k


			else if(limit && found && k-found>limit-1) 


				break


			


			tmp:=[]


			for x,y in cells


				tmp[x]:=y.accValue


			output[x,y]:=tmp


			%callback%(k, v, cells, tmp)


			


			if (sleep)


				sleep % sleep


		}


	}else if (!isobject(limit)){


		if (start="" || start=0)


			start:=1


		;~ for k,v in rows:=acc_children(acc) {


		


		loop {


			if (limit && a_index>limit)


				break


			


			;~ if(!controlexist(hwnd) && !acc_windowfromobject(acc_parent(hwnd[1]))){


				;~ OutputDebug,  % "Data grid not exist!"


				;~ return output


			;~ }


			


			if (k:=start+a_index-1)>rowsCount


				break


			;~ if (limit && k<=limit){


			tmp:=[]


			for x,y in cells:=acc_children(row:=rows[k])


				tmp[x]:=y.accValue


			output[k]:=tmp


			;~ }


			%callback%(k, row, cells, tmp)


			


			if (sleep)


				sleep % sleep


		}


	}else{


		


		k1:=limit.1&&limit.1>=1&&limit.1<=rows.maxIndex()?limit.1:1


		if(limit.maxIndex()=1)


			k2:=k1


		else


			k2:=limit.2&&limit.2<=rows.maxindex()&&limit.2>=1?limit.2:rows.maxIndex()


		loop % abs(k2-k1)+1 {


			;~ if(!controlexist(hwnd) && !acc_windowfromobject(acc_parent(hwnd[1]))){


				;~ msgbox % "Data grid not exist!"


				;~ return output


			;~ }


			


			ind:=k2>=k1?a_index-1+k1:k1-a_index+1


			if (ind> rowsCount)


				break


			tmp:=[]


			for x,y in cells:=acc_children(row:=rows[ind])


				tmp[x]:=y.accValue


			output[ind]:=tmp


			


			%callback%(ind, row, cells, tmp)


			if(sleep)


				sleep % sleep


		}


		


	}


	


	return rowsCount


}


;~ msgbox % getRisMenu()


getRisMenu(){


	global menuHwnd=0


	EnumAddress := RegisterCallback("EnumProc") 


	DllCall("EnumWindows", "Ptr", EnumAddress, "Ptr", 0)


	return menuHwnd


}





EnumProc(hwnd, lParam)


{


	global menuHwnd


	


	if (DllCall("GetWindowLong",Ptr,hwnd,Int,-20)=0______){


		;~ msgbox % hwnd "," acc_children(acc_objectfromwindow(hwnd))[1].accName


		;~ STYLE:=DllCall("GetWindowLong",Ptr,hwnd,Int,-16)


		if ((acc:=acc_children(acc_objectfromwindow(hwnd))).maxindex()=6 && acc[1].accName="瀏覽影像"){


			menuHwnd:=hwnd


			;~ msgbox % DllCall("GetWindowLong",Ptr,hwnd,Int,-16)


			return false


		}


	}


	


	return true  ; Tell EnumWindows() to continue until all windows have been enumerated.


}





getRisExamItems(hwnd){


	;~ arr:=[]


	;~ if !controlId:=getNetControl(hwnd,controlName:="EXAMITEM",accName:="DataGridView",classNN:="WindowsForms",accHelp:="")


		;~ return arr


	static prvHwnd


	for k,v in getcontrols(hwnd) {


		;~ if instr(name:=getControlNameByHwnd(hwnd,v.hwnd),"EXAM"){


		if (instr(name:=getControlNameByHwnd(hwnd,v.hwnd),"EXAMITEM")) {


			return prvHwnd:=v.hwnd


			;~ acc:=acc_objectFromWindow(v.hwnd)


			;~ break


		}


	}	


	


	return prvHwnd


	


	


	;~ ExitApp


	


	;~ controlgetpos,x,y,w,h,,ahk_id %controlId%


	;~ winactivate,ahk_id %hwnd%


	;~ mousemove,% x,% y


	;~ mousemove,% x+w,% y+h


	;~ pause


	


}





/*


	arr[1]: active exams done this time


	arr[2]: all exams done this time


*/


parseRisExamItems(hwnd){


	arr:=[[],[]]


	


	acc:=acc_objectFromWindow(hwnd)


	


	if !acc


		return arr


	


	loop % acc_children(acc).maxindex()-1 {


		i:=a_index+1


		str:=acc_get("Value",i ".2",0,acc)


		if(str="")


			continue


		if instr(str,"※")


			arr[1].push(RegExReplace(str,"※"))


		arr[2].push(RegExReplace(str,"※"))


	}


	return arr


}


parseRisHistory(hwnd){


	arr:=[]


	


	if !acc:=acc_objectfromwindow(hwnd)


		return arr


	


	;~ col:=[]


	;~ for k,v in acc_children(acc_get("Object",1,0,acc))


		;~ col[k]:="" acc_get("Value","1." k+1,0,acc)


	


	


	for i,j in rows:=acc_children(acc) {


		if i=1


			continue


		for x,y in acc_children(v)


			arr[i-1,x]:=y.accValue


	}


	


	


	;~ loop % acc_children(acc).maxIndex()-1 {


		;~ i:=a_index+1


		;~ loop % k


			;~ arr[a_index,"" col[k]]:=acc_get("Value",i "." k,0,acc)


	;~ }


	return arr


	


}








getRisHistory(hwnd){


	


	;~ if !controlId:=getNetControl(hwnd,controlName:="dgHisReport",accName:="DataGridView",classNN:="WindowsForms",accHelp:="")


		;~ return arr


	static prvHwnd


	for k,v in getcontrols(hwnd) {


		if (getControlNameByHwnd(hwnd,v.hwnd)="dgHisReport") {


			return prvHwnd:=v.hwnd


			


		}


	}	


	return prvHwnd


	


	


}











LineBreakConvert(str){


	return regexreplace(regexreplace(str,"\r",""),"\n","`r`n")


}





getSEIM(ImpaxState=""){


	if !impaxstate


		impaxstate:=impaxOpened()


	if IsObject(impaxState)


		impaxImageHwnd:=impaxState[2,1]


	else 


		impaxImageHwnd:=impaxState


	


	SEIM:=getNetControl2(impaxImageHwnd,"","DicomImageNumbers","","WindowsForms10.STATIC.app","","","",0)


	for k,v in SEIM


		if text:=controlgettext(v)


			break


	;~ controlgettext,t,,ahk_id %impaxImageHwnd%


	;~ msgbox % t


	RegExMatch(text,"i)S:\s+(\d+)\s+I:\s+(\d+)",match)


	return [match1,match2]


}








RisExamEditInfo(RisHwnd="",RisExamHwnd=""){


	if !rishwnd && !risexamhwnd


		risHwnd:=risOpened()[2]


	


	if !risexamhwnd


		risexamhwnd:=getRisReports(risHwnd)[1,1]


	


	Edit_GetSel(risexamhwnd,start,end)


	


	return {id: risexamhwnd, start: start,end: end}


	


}





getReportHint(risHwnd){


	static prvHwnd


	return ControlGetText((h:=acc_windowfromobject(getNetAcc(risHwnd,"REPORT_HINT","WindowsForms10.STATIC")))?(prvHwnd:=h):prvHwnd)


}





getIndication(RisHwnd,filter=1){


	static prvHwnd


	


	thisHnwd:=(indication:=getNetControl2(RisHwnd,"","REPORT_HINT","","WindowsForms10.STATIC.app","","","",0))[1]?indication[1]:prvHwnd


	


	if regexmatch(controlgettext(thisHwnd),"Indication:([^\n\r]*)",match) {


		str:=match1


	}else{


	


		for k,v in getControls(RisHwnd)


			if regexmatch(v.text,"Indication:([^\n\r]*)",match) {


				str:=match1


				break


			}


	}


	


	str:=RegExReplace(trim(str),"[^\w\+\)]+$","")


	


	if(filter=1){


		str:=RegExReplace(str,"is)(.+?)(有.+)?","$1")


	}


	return trim(str)


}





getRisClinicalInfoHwnd(RisHwnd){


	static prvHwnd


	return (h:=getNetControl2(risHwnd,"","txtALL","","WindowsForms10.EDIT.app","","","",0)[1])?(prvHwnd:=h):prvHwnd


}











getIndicationText(RisHwnd){


	clinicalHx:=getClinicalInfo(RisHwnd)


	indication:=getIndication(RisHwnd)


	if(indication="" && RegExMatch(clinicalHx,"is)\[The Others\]:([^\r\n\※]+)",match)){


		indication:=Trim(match1)


	}


	if(indication="")


		indication:="N/A"


	return indication


	


}











;~ a:=getSeriesList()


;~ for k,v in a


	;~ msgbox % acc_location(a.1).x


/*


	return arr:	(screen1): [hwnd of series window, hwnd of series control]


	(screen2):


*/


getSeriesList(){


	winget,impaxList,list,ahk_exe impax-client-main.exe ahk_class #32770,Slider1


	SeriesList:=[]


	loop % impaxList {


		;~ acc:=acc_objectfromwindow(id:=impaxList%a_index%)


		;~ if (acc_children(acc).maxindex()=10)


			SeriesList.push(id:=impaxList%a_index%)


	}


	


	if impaxList && !seriesList.maxIndex() 


		return -1


	


	


	;~ sysget,mon,monitor,2


	;~ sysget,mon2,monitor,3


	monitorInfo:=monitorInfo()


	


	List:=[]  


	;~ Series:=[]


	for k,v in SeriesList {


		for x,y in getControls(v)


			if (y.ClassNN="SysListView321" && y.text="List1") {


				WinGetPos,x,y,,,% "ahk_id " hwnd:=y.hwnd


							


				Loop % (monitorInfo.maxIndex())


					if(x<=monitorInfo[a_index].r && x>=monitorInfo[a_index].l && y>=monitorInfo[a_index].t && y<=monitorInfo[a_index].b){


						List[A_Index]:=[v, hwnd]


						break, 2


					}


		


				;~ wingetpos,x,,,,% "ahk_id " y.hwnd


				;~ if (x<=monRight)


					;~ List[1]:=[v,y.hwnd]


				;~ else


					;~ List[2]:=[v,y.hwnd]


				;~ break


			}


	}


	


	;simple sort of two screen list according to x 


	;~ pos:=[]


	;~ for k,v in List {


		;~ wingetpos,x,y,,,ahk_id %v%


		;~ pos.push(x)


	;~ }


	;~ sortedList:=[]


	;~ if pos[2]<pos[1]


		;~ sortedList:=[List[2],List[1]]


	;~ else


		;~ sortedList:=List


	


	return List


	


}





;~ a:=getSeriesName()


;~ b:=1





getSeriesName(list="",screen=2){


	if list=


		list:=getSeriesList()


	


	if isobject(list)


		listAcc:=acc_objectfromwindow(listHwnd:=list[screen,2])


	else  


		listAcc:=acc_objectfromwindow(list)


	


	seriesName:=[],ch:=acc_children(listAcc),count:=ch.maxindex()


	for k,v in ch {


		if (k=count)


			break


		RegExMatch(acc_get("Name","",k,listAcc),"is)(\d+)\s*:\s*(\d+)\s*:\s*(.*)",match)


		seriesName.push([match3,match2])


	}


	return seriesName


}








;~ a:=getViewFrame("",2)


;~ b=1


/*


	axis:


	(1,1) (1,2)


	(2,1) (2,2)


	


	return arr:	screen:	hwnd of frame at (x,y)


*/


getViewFrame(ImpaxHwnd="", whichScreen=""){


	if impaxHwnd=


		impaxHwnd:=impaxOpened()[2,1]


	


	if !impaxHwnd


		return


	


	if(whichScreen="")


		whichScreen:=[1,2]


	


	arr:=[]


	;~ screen:=0,x:=0,y:=0,xMax:=0,yMax:=0


	for k,v in getControls(impaxHwnd)


		if RegExMatch(v.ClassNN,"AfxWnd90u\d+") && RegExMatch(v.text,"Screen_(\d+)_format_\d+_Position_(\d)_(\d)",match) {


			screen:=match1+1,x:=match2+1,y:=match3+1


			if (!IsObject(whichScreen) && screen!=whichScreen) 


				|| (IsObject(whichScreen) && !eleInArr(screen, whichScreen))


				continue


			if !isobject(arr[screen])


				arr[screen]:=[]


			arr[screen,x,y]:=v.hwnd


		}


	


	return arr


}





eleInArr(e, a){


	for k,v in a


		if(v=e)


			return true


	return false


}


;~ CoordMode,mouse,screen


;~ dragSeries(9,1,2,2)





/*


	seriesInd: 0 as cursor position


	frameX, frameY: axis of frame, one dimension axis if frameY=0


*/





dragSeries(frameX,frameY=0,seriesInd=0,screen=2,ByRef seriesList="",frame=""){


	CoordMode,mouse,screen


	if (frame="")


  		frame:=getViewFrame()


	if (seriesList="")


		seriesList:=getSeriesList()


	


	frameFlat:=[]


	for k,v in frame[screen]


		for m,n in v


			frameFlat.push(n)


	


	if !(frameHwnd:=frame[screen,frameX,frameY]) && !(frameHwnd:=frameFlat[frameX+frameY])


		return


	


	listAcc:=acc_objectfromwindow(listHwnd:=seriesList[screen,2])


	,listWin:=seriesList[screen,1]


	mousegetpos,mX,mY


	


	


	if(seriesInd=0){


		seriesLoc:={x:mX,y:mY,w:0,h:0}


	}else if IsObject(seriesInd){


		seriesLoc:={x: seriesInd.x, y: seriesInd.y}


	}else{


		seriesLoc:=acc_location(listAcc,seriesInd)


		if (!seriesLoc.x || !seriesLoc.y)


			return


	}


	


	


	


	if (seriesInd!=0 && !IsObject(seriesInd)){


		wingetpos,x,y,w,h,ahk_id %listWin%


		


		xMax:=0,columns:=0


		loop % (seriesNum:=acc_children(listAcc).maxindex()-1) {


			loc:=acc_location(listAcc,a_index)


			;~ if loc.x>xMax


				;~ xMax:=loc.x


			if(loc.x>xMax){


				xMax:=loc.x


			}else{


				columns:=a_index-1


				break


			}


		}


		


		controlsend,,{home},ahk_id %listHwnd%


		Loop % floor(seriesInd/columns)


			controlsend,,{down},ahk_id %listHwnd%


		sleep 500


		seriesLoc:=acc_location(listAcc,seriesInd)


	}


	


	


	wingetpos,fX,fY,fW,fH,% "ahk_id " frameHwnd


	


	;~ sysget,mon1,monitor,% screen


	;~ sysget,mon2,monitor,% screen+1


	;~ if (fX<mon2Left){


		;~ fX+=mon1Right-mon1Left


	;~ }


	winactivate,ahk_id %listWin%


	mousemove,% seriesLoc.x+seriesLoc.w/2,% seriesLoc.y+seriesLoc.h/2,0


	;~ controlsend,,{lbutton down},ahk_id %listHwnd%


	send {lbutton down}


	sleep 100


	


	mousemove,% fX+fW/2,% fY+20,2


	;~ controlsend,,{lbutton up},ahk_id %frameHwnd%


	send {lbutton up}


	


	mousemove,% mX,% mY,0


	


}


mouseDragSeries(originalXY, originalWin, targetFrame){


	WinActivate,ahk_id %originalWin%


	mousemove,% originalXY.x,% originalXY.y,0


	send {LButton Down}


	Sleep 100


	WinGetPos,x,y,w,h,ahk_id %targetFrame%


	MouseMove, % x+w/2, % y+20,2


	send {LButton up}





}








;~ Sleep 1000





;~ toggleSeriesList("", "toggle", "mouse")


;~ Sleep 1000


;~ toggleSeriesList("", "on", 2)


;~ esc::ExitApp


;~ ExitApp


/*


action="on", "off", "toggle"


for="all", 1, 2, "mouse"


return= seriesListStored


*/





toggleSeriesList(impaxState="", action="toggle", for="all", ByRef monitorInfo="", activate=false){


	static seriesListStored:=[] ; button1, seriesList1, button2, seriesList2


	


	if !IsObject(impaxState)


		impaxState:=impaxOpened()


	


	if !WinExist("ahk_exe impax-client-main.exe") || (impaxState[1]!=2 && impaxState[2,4]!=1)


		return


	


	if IsObject(for){


		for k,v in for


			ret:=toggleSeriesList(impaxState, action, v, monitorInfo, activate)


		return ret


	}


	


	screenNo:=(for+0)*2-1


	if screenNo is number


	{


		if WinExist("ahk_id " seriesListStored[screenNo]) && winvisible(seriesListStored[screenNo]) && WinExist("ahk_id " seriesListStored[screenNo+1]) {


			if (((winvisible(seriesListStored[screenNo+1]))=(action="off")) || (action="toggle")){


				ControlClick,,% "ahk_id " seriesListStored[screenNo]


				;~ ToolTip test


			}


			return seriesListStored


		}else{


	


			if !IsObject(monitorInfo)


				monitorInfo:=monitorInfo()


			


			winget,impaxList,list,ahk_exe impax-client-main.exe


			seriesListButton:=[]


			loop % impaxList {


				impaxId:=impaxList%a_index%


				for k,v in (impaxControls:=getcontrols(impaxId)){


					if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {


						


						WinGetPos,x,y,,,% "ahk_id " v.hwnd


							


						Loop % (monitorInfo.maxIndex())


							if(x<=monitorInfo[a_index].r && x>=monitorInfo[a_index].l && y>=monitorInfo[a_index].t && y<=monitorInfo[a_index].b){


								seriesListButton[A_Index]:=v.hwnd


								break


							}


						


					}


				}


			}


			for k,v in seriesListButton


				seriesListStored[k*2-1]:=v


			for k,v in seriesList:=getSeriesList()


				seriesListStored[2*k]:=v.1


			


			if (winvisible(sHwnd:= seriesListStored[screenNo+1])=(action="off")) || (action="toggle") {


				ControlClick,,% "ahk_id " seriesListStored[screenNo]


				if(action="off")


					WinHide, % "ahk_id " sHwnd


				else if(action="on")


					WinShow, % "ahk_id " sHwnd


			}


			return seriesListStored


		}


		


	}else{


		if !IsObject(monitorInfo)


				monitorInfo:=monitorInfo()


		


		whichMonitor:=whichMonitor("","",monitorInfo)


		,which:=whichMonitor.1


		


		 if (for="mouse"){


		


			return toggleSeriesList(impaxState, action, which+0, monitorInfo, activate)


		}else if(for="all"){


			ret:=toggleSeriesList(impaxState, action, which+0, monitorInfo, activate)


			,others:=[]


			Loop % monitorInfo.maxIndex()-1


				if(A_Index+1!=which){


					others.push(A_Index+1)


					


				;~ toggleSeriesList(impaxState, action, A_Index+1, monitorInfo, activate)	


				}


			SetTimerF("toggleSeriesList", -1, [impaxState, action, others, monitorInfo, activate])


			return ret


		}


		return


	}


	


	if(activate)


		winactivate,% "ahk_id " ImpaxState[2,1]





}





monitorInfo(){


	sysget,monitorCount,monitorCount


	arr:=[],sorted:=[]


	loop % monitorCount {


		sysget,mon,monitor,% a_index


		arr.push({l:monLeft,r:monRight,b:monBottom,t:monTop,w:monRight-monLeft+1,h:monBottom-monTop+1,ind: A_Index})


		k:=a_index


		while strlen(k)<3


			k:="0" k


		sorted[monLeft k]:=a_index


	}


	arr2:=[]


	for k,v in sorted


		arr2.push(arr[v])


	return arr2


}





/*


	return [current monitor, monitor count]


*/


whichMonitor(x="",y="",byref monitorInfo=""){


	CoordMode,mouse,screen


	if (x="" || y="")


		mousegetpos,x,y


	if !IsObject(monitorInfo)


		monitorInfo:=monitorInfo()


	


	for k,v in monitorInfo


		if (x>=v.l&&x<=v.r&&y>=v.t&&y<=v.b)


			return [k,monitorInfo.maxIndex()]


}





;~ a:=parseDataGrid(getRisList())


;~ b=1


;~ msgbox % getRisList()


getRisList(hwnd=""){


	if !hwnd


		hwnd:=risOpened()[2]


	


	static prvHwnd


	


	return (h:=getNetAcc(hwnd,"DataGridView1","WindowsForms",0,0,"",""))?(prvHwnd:=h):prvHwnd


	


}





RisAddToDisplayList(risHwnd="",list=""){


	if !risHwnd


		risHwnd:=risOpened()[2]


	


	if !list || !isobject(list)


		list:=parseDataGrid(getRisList(risHwnd))


	


	str:=""


	i:=list.maxIndex()


	


	for k,v in list.1


		if (v="照會單號") {


			ind:=k


			break 


		}


	


	if !ind


		return


	arr:=[]


	for k,v in list


		if (k!=1 && k!=i)


			str.="ADD_TO_DISPLAY_LIST """" " v[ind] " """" "


	,arr.push(v[ind])


	


	str.="SYNC_DISPLAY """" " list[2,ind] " """""


	


	return arr


	


}


;~ impaxCyclicListDo()


impaxCyclicListDo(next=1,hwnd=""){


	if !hwnd


		hwnd:=impaxOpened()[2,1]


	controlclick,,% "ahk_id " getNetAcc(hwnd,next=1?"nextButton":"previousButton","WindowsForms10.BUTTON",0,0,"","")


}





controlexist(hwnd, acc=false){


	if !hwnd


		return 


	if acc


		hwnd:=acc_windowfromobject(hwnd)





	controlget,id,hwnd,,,ahk_id %hwnd%


	return id


}








RisSearchResultCount(risHwnd){


	static RisSearchResultTextHwnd


	if !controlexist(RisSearchResultTextHwnd)


		RisSearchResultTextHwnd:=getNetAcc(risHwnd,"lblSearchResult","WindowsForms10.STATIC",0,0,"","")


	text:=controlgettext(RisSearchResultTextHwnd)


	regexmatch(text,"共搜尋到\s*(\d+)\s*筆資料",match)


	return match1


	


}





getRisExamDate(risHwnd){


	if IsObject(risHwnd)


		risHwnd:=risHwnd[2]


	static prvHwnd


	return ControlGetText((h:=getNetControl2(risHwnd,"","EXAM_DATE_TIME","","WindowsForms10.EDIT")[1])?(prvHwnd:=h):prvHwnd)


}





getImpaxListAcc(impaxState){


	impaxHwnd:=impaxState[2,2] | impaxState[2,3]


	return getNetAcc(impaxHwnd, "grid", "windowsForms")


}





;~ acc:=getImpaxList(impaxOpened())


;~ parseDataGrid(acc_children(acc), arr:=[], 1)





;~ ExitApp


;~ MsgBox % getRisLoginName(risOpened()[2])


;~ ExitApp








getRisLoginName(risHwnd){


	WinGetTitle,title,% "ahk_id " risHwnd


	RegExMatch(title,"^([^\-])+", match)


	return match


}





resetRisReports(RisHwnd="", RisReports=""){


	


	if(RisReports=""){


		if !WinExist("ahk_id " RisHwnd)


			RisHwnd:=risOpened()[2]


	


		RisReports:=getRisReports(RisHwnd)


	}


	


	


	


	ControlSetText,,,% "ahk_id " RisReports[1,1]


	ControlSetText,,,% "ahk_id " RisReports[1,2]


}





; replaceFindings: 0->two new lines, 1->replace, -1->append


setReportText(findings, impression, RisReports="", replaceFindings=0, replaceImpression=true, caretToEnd=true){


	if (RisReports="" || !IsObject(RisReports)) || !WinExist("ahk_id " RisReports[1,1])


		RisReports:=getRisReports(risOpened()[2])


	if(simpleRis:=WinExist("ahk_exe simpleRIS.exe")){


		controlget,EditHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI


	}


	


	oldReport:=EditHwnd?edit_getText(EditHwnd):ControlGetText(RisReports[1,1])


	


	if (replaceFindings=0)


		findings:=oldReport (oldReport=""?"":"`n`n") findings


	else if (replaceFindings=-1)


		findings:=(oldReport) findings


	if !(replaceImpression)


		impression:=Trim(ControlGetText(RisReports[1,2])) "`n" impression


	


	findings:=Trim(RegExReplace(findings, "(?<!\r)\n", "`r`n"))


	


	if (EditHwnd)


		Edit_SetText(EditHwnd, findings)


	


	ControlSetText,,% findings,% "ahk_id " RisReports[1,1]


	ControlSetText,,% impression:=Trim(RegExReplace(impression, "(?<!\r)\n", "`r`n")),% "ahk_id " RisReports[1,2]


	


	if(caretToEnd){


		Edit_SetSel(RisReports[1,1], len:=StrLen(findings), len)


		Edit_SetSel(RisReports[1,2], len:=StrLen(impression), len)


	}


}





getRisTechName(risHwnd){


	static prvHwnd


	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"放射師","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue


}





getRisPtName(risHwnd){


	static prvHwnd


	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"姓名","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue


}


getRisPtGender(risHwnd){


	static prvHwnd


	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"性別","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue


}


getRisPtAge(risHwnd){


	static prvHwnd


	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"年齡","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue


}





getRisStudyState(risHwnd){


	static prvHwnd


	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"狀態","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue


}





getClinicalInfo(RisHwnd){


	static prvHwnd


	return (h:=getNetControl2(risHwnd,"","txtALL","","WindowsForms10.EDIT.app","","","",0)[1])?controlgettext(prvHwnd:=h):ControlGetText(prvHwnd)


}





getImpaxContextServerPath(){


	if FileExist(path:=A_ScriptDir "\ImpaxContextServer.exe")


		return path


	else if FileExist(path:=A_ScriptDir "\ImpaxContextServer\ImpaxContextServer.exe")


		return path


	else if FileExist(path:=RegExReplace(A_ScriptDir, "is)[\/\\][^\/\\]+$", "") "\ImpaxContextServer\ImpaxContextServer.exe")


		return path


	


}


;~ risSendReport(risOpened()[2])


;~ ExitApp





;~ MsgBox % acc_windowfromobject(getNetAcc(risOpened()[2],"cmdRunSave","WindowsForms10.BUTTON",0,true))


;~ ExitApp


risSendReport(risHwnd, type=3){


	static prvHwnd1, prvHwnd2, prvHwnd3


	if !WinExist("ahk_id " risHwnd)


		risHwnd:=risOpened()[2]


	while !(button:=getNetAcc(risHwnd,type=1?"cmdRunSave":type=2?"cmdRunVerify":"cmdRunVerifySend","WindowsForms10.BUTTON",0,true))


	&& !(button:=acc_objectfromwindow(getNetControl2(risHwnd,type=1?"暫存":type=2?"存檔":"存檔發送" ,"","","WindowsForms10.BUTTON")[1])) && !controlexist(prvHwnd%type%) && A_Index<4


		Sleep 50


	if(!button){


		if controlexist(prvHwnd%type%)


			button:=acc_ObjectFromWindow(prvHwnd%type%)


		else {


			MsgBox,,,% "Can't get RIS button, suggest re-open RIS!",3


			return 1


		}


	}


	


	prvHwnd%type%:=acc_windowfromobject(button)


	return button.accDoDefaultAction()


}





;~ MsgBox % !( openImpax:=getNetAcc(risOpened()[2],"cmdDs3000","WindowsForms10.BUTTON"))


;~ risOpenStudyImpax(RisOpened()[2])


;~ ExitApp


risOpenStudyImpax(risHwnd=""){


	static prvHwnd


	if !WinExist("ahk_id " risHwnd)


		risHwnd:=risOpened()[2]


	while !(openImpax:=getNetAcc(risHwnd,"cmdDs3000","WindowsForms10.BUTTON")) && !(openImpax:=acc_objectfromwindow(getNetControl2(risHwnd,"IMPAX6","","","WindowsForms10.BUTTON")[1])) && !controlexist(prvHwnd) && A_Index<4


		Sleep 50


	


	if(!openImpax){


		if controlexist(prvHwnd)


			openImpax:=acc_ObjectFromWindow(prvHwnd)


		else{


			MsgBox,,,% "Can't get RIS button, suggest re-open RIS!",3


			return 1


		}


	}





	prvHwnd:=acc_windowfromobject(openImpax)


	return openImpax.accDoDefaultAction()


}





RisHistoryQueryByAccNo(AccNo, RisHwnd="", RisHistoryAcc=""){


	static prvRisHistoryAcc, prvRisHwnd


	if (!RisHistoryAcc) && !controlexist(acc_windowfromobject(RisHistoryAcc:=prvRisHistoryAcc)) {


		if !WinExist(RisHwnd) && !WinExist(RisHwnd:=prvHwnd)


			prvHwnd:=RisHwnd:=risOpened()[2]


		prvRisHistoryAcc:=RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(prvHwnd:=RisHwnd))


	}


	prvRisHistoryAcc:=RisHistoryAcc


	


	for k,v in rows:=acc_children(RisHistoryAcc){ 


		cells:=acc_children(v)


		if(k=1){


			for x,y in cells {


				if (y.accValue="照會單號"){


					AccNoCol:=x


				}else if (y.accValue="檢查日"){


					examDateCol:=x


				}else if (y.accValue="檢查名稱"){


					examNameCol:=x


				}


			}


		}else if (cells[AccNoCol].accValue=AccNo){


			return {examDate: cells[examDateCol].accValue, examName: cells[examNameCol].accValue}


		}


	}


}





;~ risOpenOldStudy(RisOpened()[2])


;~ ExitApp


risOpenOldSingleStudy(AccNo, ExamDate="", ExamName="", RisHwnd="", RisHistoryAcc=""){


	static prvRisHistoryAcc, prvRisHwnd


	if (!RisHistoryAcc) && !controlexist(acc_windowfromobject(RisHistoryAcc:=prvRisHistoryAcc)) {


		if !WinExist(RisHwnd) && !WinExist(RisHwnd:=prvHwnd)


			prvHwnd:=RisHwnd:=risOpened()[2]


		prvRisHistoryAcc:=RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(prvHwnd:=RisHwnd))


	}


	prvRisHistoryAcc:=RisHistoryAcc


	


	if(examDate="" || examName="")


		res:=RisHistoryQueryByAccNo(AccNo, RisHwnd, RisHistoryAcc)


		, examDate:=res.examDate, examName:=res.examName


	


	examType:=InStr(examName,"CT")?"CT":InStr(examName,"MRI")?"MRI":examName


	


	for k,v in rows:=acc_children(RisHistoryAcc){ 


		cells:=acc_children(v)


		if(k=1){


			for x,y in cells {


				if (y.accValue="照會單號"){


					AccNoCol:=x


				}else if (y.accValue="檢查日"){


					examDateCol:=x


				}else if (y.accValue="檢查名稱"){


					examNameCol:=x


				}


			}


		}else if InStr(cells[examNameCol].accValue, examType) && (Trim(cells[examDateCol].accValue)=examDate){


			ImpaxContextServer_Add(Trim(cells[AccNoCol].accValue))


		}


	}


}





/*


origin.x .y .z: upper left corner of first slice


spacing.x .y .z


coord.x .y .z: lesion


dimension.x .y


framePos.x .y .w .h


*/


coordToPacs(framePos, coord, dicomInfo){


	origin:=dicomInfo.origin


	, spacing:=dicomInfo.spacing


	, dimension:=dicomInfo.dimension


	


	if IsObject(coord.pacsPos)


		pacsPos:=coord.pacsPos


	else{	


		pacsPos:=coordToPacsPos(origin, coord, spacing)


	}


	


	target:=[]


	if(framePos.w/framePos.h > dimension.x*spacing.x/dimension.y/spacing.y){ ;image height = frame height


		target.y:=Floor(framePos.h * pacsPos.y / dimension.y ) + framePos.y -1


		, imageW:=framePos.h * dimension.x / dimension.y


		, target.x:=Floor(imageW * pacsPos.x / dimension.x ) + framePos.x -1 


	}else{ ;image width = frame width


		target.x:=Floor(framePos.w * pacsPos.x / dimension.x ) + framePos.x -1


		, imageH:=framePos.w * dimension.y / dimension.y


		, target.y:=Floor(imageH * pacsPos.y / dimension.y ) + framePos.y -1 


	}


	


	return {x: target.x, y: target.y}


	;~ impaxSelectImage(pacsPos.z, seriesNo, {x: target.x, y: target.y})


}





coordToPacsPos(origin, coord, spacing){


	pacsPos:=[]


	for k,v in coord


		pacsPos[k]:=Floor((v-origin[k])/spacing[k])+1


	return pacsPos


}


PacsToCoord(impaxHwnd="", aspectRatio=1){


	if !WinExist("ahk_id " impaxHwnd)


		if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])


			return


	static clientImNoReg:="i)S: \d+\/(\d+) +I: \d+\/(\d+)"


	MouseGetPos,mX,mY,win,frameHwnd,2


	SEIM:=getSEIM(impaxHwnd)


	


	;~ for k,v in clientImNo:=getNetControl2(impaxHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)


		;~ if ((t:=ControlGetText(v))!="" && RegExMatch(t, clientImNoReg, match)){


			;~ allImNo:=match2


			;~ break


		;~ }	


	WinGetPos,fX,fY,fW,fH,ahk_id %frameHwnd%


	if(fW/fH > aspectRatio){ ; image height = frame height


		coordY:=(mY-fY)/fH


		,coordX:=(mX - (fW-fH*aspectRatio)/2) / (fH*aspectRatio)


	}else{


		coordX:=(mX-fX)/fW


		,coordY:=(mY-(fH-fW/aspectRatio)/2) / (fW/aspectRatio)


	}


	SEIM.push(Floor(coordX*1024)), SEIM.push(Floor(coordY*1024))


	return SEIM


}





getImpaxAllImNo(impaxHwnd){


	static clientImNoReg:="i)S: \d+\/(\d+) +I: \d+\/(\d+)"


	if !WinExist("ahk_id " impaxHwnd)


		if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])


			return


	


	for k,v in getNetControl2(impaxHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)


		if ((t:=ControlGetText(v))!="" && RegExMatch(t, clientImNoReg, match)){


			return match2


		}	


	


}





;~ impaxSelectImage(35,8)


;~ a:=1


;~ esc::ExitApp





/*


move to series (using nextKey, prvKey), scroll to specific image


MouseMoveCoord default = {x: 0.8, y: 0.5} (relative to frame width/height of that series)


*/





impaxSelectImage(im, SeriesNoOrFrameCoord="", MouseMoveCoord="", whichScreen="", impaxHwnd="", nextKey="{Right}", prvKey="{Left}"){


	CoordMode,mouse,screen


	static SEIMReg:="i)DICOM S: (\d+) +I: (\d+)", clientImNoReg:="i)S: (\d+)\/\d+ +I: (\d+)\/(\d+)"


	static lastFoundFrameHwnd


	


	if !WinExist("ahk_id " impaxHwnd)


		if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])


			return


	


	winactivate, % "ahk_id " impaxHwnd


	WinGetPos,wx,wy,,,% "ahk_id " impaxHwnd


	


	SEIM:=getNetControl2(impaxHwnd,"","DicomImageNumbers","","WindowsForms10.STATIC.app","","","",0)


	,clientImNo:=getNetControl2(impaxHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)


	if IsObject(seriesNoOrFrameCoord){


		frameHwnd:=getViewFrame(impaxHwnd)[seriesNoOrFrameCoord[1], seriesNoOrFrameCoord[2], seriesNoOrFrameCoord[3]]


		if !frameHwnd


			return


		ControlGetPos,cx,cy,cw,ch,,% "ahk_id " frameHwnd


		ControlFocus,,% "ahk_id " frameHwnd


		MouseMove,% mX:=wx+cx+Floor(cw*3/4),% wy+cy+Floor(ch/2),0


		Sleep 50


	}else{ ;specify SE


		se:=seriesNoOrFrameCoord, matched:=false, recordFrameSe:=""


		Loop 15 {


			if controlexist(lastFoundFrameHwnd){


			


				v3:=lastFoundFrameHwnd


			


				ControlGetPos,cx,cy,cw,ch,,% "ahk_id " v3


				ControlFocus,,% "ahk_id " v3


				MouseMove,% mX:=wx+cx+Floor(cw*3/4),% mY:=wy+cy+Floor(ch/2),0


				Sleep 100


				


				for k,v in SEIM


					if ((t:=ControlGetText(v))!=""){


						if RegExMatch(t, SEIMReg, match){


							;~ if(recordFrameSe=match1) ; full loop, not found


								;~ return


							;~ if (LoopInd=2 && recordFrameSe="")


								;~ recordFrameSe:=match1


							if(match1=se){


								frameHwnd:=v3, matched:=true


								break, 2


							}


						}


						break


					}


			}


			


			LoopInd:=A_Index


			for k1,v1 in frames:=getViewFrame(impaxHwnd, whichScreen)


				for k2,v2 in v1


					for k3,v3 in v2 {


						;~ if(v3=lastFoundFrameHwnd)


							;~ continue


						


						ControlGetPos,cx,cy,cw,ch,,% "ahk_id " v3


						ControlFocus,,% "ahk_id " v3


						MouseMove,% mX:=wx+cx+Floor(cw*3/4),% mY:=wy+cy+Floor(ch/2),0


						Sleep 100


						


						for k,v in SEIM


							if ((t:=ControlGetText(v))!=""){


								if RegExMatch(t, SEIMReg, match){


									;~ if(recordFrameSe=match1) ; full loop, not found


										;~ return


									;~ if (LoopInd=2 && recordFrameSe="")


										;~ recordFrameSe:=match1


									if(match1=se){


										lastFoundFrameHwnd:=frameHwnd:=v3, matched:=true


										break, 5


									}


								}


								break


							}


							


						for k,v in clientImNo


						if ((t:=ControlGetText(v))!=""){


							if RegExMatch(t, clientImNoReg, match){


								if(recordFrameSe=match1) ; full loop, not found


									return


								if (LoopInd=2 && recordFrameSe="")


									recordFrameSe:=match1


								


							}


							break


						}


					}


			


			if(!matched){


				winactivate,% "ahk_id " impaxHwnd


				ControlFocus,,ahk_id %v3%


				send % nextKey


				Sleep 200


			}


		}


	}


	


	if(!matched)


		return


	


	;~ for k,v in SEIM


		;~ if ((t:=ControlGetText(v))!=""){


			;~ SEIMhwnd:=v


			;~ ,SEIMtext:=t


			;~ break


		;~ }


		


	for k,v in clientImNo


		if ((t:=ControlGetText(v))!=""){


			clientImNoHwnd:=v


			,clientImNoText:=t


			break


		}	


	


	


	if RegExMatch(clientImNoText, clientImNoReg, match){


		allImNo:=match3


		send {LButton Down}


		


		MouseMove,% mX, % mY:=impaxImNoToMousePos(im, wy+cy, ch, allImNo),3


		send {LButton up}


	}


	


	winactivate,% "ahk_id " impaxHwnd


	ControlFocus,,ahk_id %frameHwnd%


	wheelWay:=1, dist:=0


	loop {


		if !RegExMatch(ControlGetText(clientImNoHwnd), clientImNoReg, match)


			break


		if(match2=im)


			break


		if(dist && Abs(match2-im)>dist)


			wheelWay:=!wheelWay


		if (match2-im)*(wheelWay-0.5)>0


			send {WheelUp}


		else


			send {WheelDown}


		dist:=Abs(match2-im)


	}


	


	if(MouseMoveCoord="" || !MouseMoveCoord.x || !MouseMoveCoord.y)


		MouseMoveCoord:={x:0.8, y:0.5}


	


	; assume square image, eg 512*512


	WinGetPos,fX,fY,fW,fH,ahk_id %frameHwnd%


	if(fW>=fH)


		MoveCoordX:=Floor(fX+(fW-fH)/2+fH*MouseMoveCoord.x)


		,MoveCoordY:=Floor(fY+fH*MouseMoveCoord.y)


	else


		MoveCoordY:=Floor(fY+(fH-fW)/2+fW*MouseMoveCoord.y)


		,MoveCoordX:=Floor(fX+fW*MouseMoveCoord.x)


	mousemove,% MoveCoordX,% MoveCoordY,1


}





;~ a:=impaxMousePosToImNo(469, 1, 936,21)


;~ b:=impaxMousePosToImNo(468, 1, 936,21)


;~ MsgBox % a "," b


;~ a:=impaxImNoToMousePos(1, 1, 936, 21, true)


;~ MsgBox % a.1 "," a.2


;~ ExitApp





impaxMousePosToImNo(mouseY, frameY, frameH, allImNo){


	return Floor((mouseY-frameY)*allImNo/frameH + 0.5)+1


}


impaxImNoToMousePos(k, frameY, frameH, allImNo, interval=false){


	range:=[k=1?frameY:impaxImNoToMousePos(k-1, frameY, frameH, allImNo)+1,k=allImNo?frameY+frameH-1:Ceil(frameH*(2*k-1)/2/allImNo)+frameY-1]


	if !interval


		return Floor((range.1 + range.2)/2)


	else 


		return range


}








risOpenOldStudy(risHwnd){


	;~ static openOldStudyRule:={CT:{}, MR: {}, XR:{}, other:{}}


	


	regEx:=""


	for k,v in (ExamItems:=parseRisExamItems(getRisExamItems(RisHwnd)))[1]


		if RegExMatch(v, "i)(CT|MRI)[^-]+-+([\w ]+)", match)


			regEx.="((CT|MRI)[^-]+-+" match2 ")|"


		else if (v="Perfusion CT")


			regEx.="((CT|MRI)[^-]+-+Brain)|(Perfusion CT)|"


		


		


	regEx:="i)" SubStr(regEx,1,-1)


	if(regEx="")


		return





	examDate:=getRisExamDate(risHwnd)


	;~ ,thisAccNo:=getRisAccNo(risHwnd)


	


	for k,v in rows:=acc_children(RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(RisHwnd))){ 


		if(k=1){


			for x,y in cells:=acc_children(v) {


				if (y.accValue="照會單號"){


					AccNoCol:=x


				}else if (y.accValue="檢查日"){


					examDateCol:=x


				}else if (y.accValue="檢查名稱"){


					examNameCol:=x


				}


			}


		}else if regexmatch(ExamName:=acc_children(v)[examNameCol].accValue, regEx) {


			priorDate:=acc_children(v)[examDateCol].accValue


			if RegExReplace(priorDate,"\W","")>SubStr(RegExReplace(examDate,"\W",""),1,8)


				continue


			else if RegExReplace(priorDate,"\W","")=SubStr(RegExReplace(examDate,"\W",""),1,8){


				isSameStudy:=false


				for x,y in ExamItems[1]


					if(y=ExamName){


						isSameStudy:=true


						break


					}


				if(isSameStudy)


					continue


			}


			


			


			v.accSelect(ComObj(3,3),0)


			


			if(impaxContextServerHwnd:=winexist("ahk_exe ImpaxContextServer.exe")){


			;~ if(0){


				;~ sendStr:="SYNC_DISPLAY || " thisAccNo " || "


				ImpaxContextServer_Add(Trim(acc_children(v)[AccNoCol].accValue))


				Loop {


					if !(RegExReplace(priorDate,"\W","")=RegExReplace(test:=(nearRow:=acc_children(rows[k-A_Index]))[examDateCol].accValue,"\W","") && InStr(test2:=nearRow[examNameCol].accValue,"CT"))


						break


					ImpaxContextServer_Add(Trim(nearRow[AccNoCol].accValue))


				}


				Loop {


					if !(RegExReplace(priorDate,"\W","")=RegExReplace((nearRow:=acc_children(rows[k+A_Index]))[examDateCol].accValue,"\W","") && InStr(nearRow[examNameCol].accValue,"CT"))


						break


					ImpaxContextServer_Add(Trim(nearRow[AccNoCol].accValue))


				}


				;~ sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " thisAccNo " || "


				;~ SetTimerFn("cmdContextServer", -1, [sendStr, impaxContextServerHwnd])


				;~ Send_WM_COPYDATA(impaxContextServerHwnd, 0, sendStr)


			}else{


				sleep 200


				loc:=Acc_Location(v)


				mouseclick,r,% loc.x+50,% loc.y+5,1,0


				sleep 200


				mouseclick,l,10,10,1,0,,R


			}


			break


		}


	}


	


}





;~ MsgBox % ExploreObj(parseOldSEIM())


;~ ExitApp





parseOldSEIM(RisHwnd=""){


	if !WinExist("ahk_id " RisHwnd)


		RisHwnd:=risOpened()[2]


	


	RisReports:=getRisReports(RisHwnd)


	, oldReportText:=ControlGetText(RisReports[2,1])


	, ret:=[]


	if Trim(oldReportText)=""


		return ret


	


	i:=0, j:=1


	while i:=RegExMatch(oldReportText, "i)\(([^\)\n]+)\)", match, j) {


		thisSE:=""


		if (k:=RegExMatch(match1, "i)SE *(\d+) *[\/\\]?", SE)) || (k:=RegExMatch(match1, "i)^(\d+) *[\/\\]", SE)) 


			IMtext:=SubStr(match1, k+StrLen(SE)), thisSE:=SE1


		else 


			IMtext:=match1


		


		if (k:=InStr(IMtext, "IM")) && (RegExReplace(IMtext:=SubStr(IMtext,k), "i)IM|[\,\; ]", "") ~= "^\d+$"){


			IMs:=RegExReplace(IMtext, "i)IM|[\,\; ]", ","), IMarr:=[]


			loop,parse,IMs,`,


				if RegExMatch(A_LoopField, "\d+", imMatch)


					IMarr.push(imMatch)


			


			if (IMarr.maxIndex()>0){


				if !(thisSE ~= "^\d+$")


					thisSE:=lastSE


				


				if thisSE!=


					for x,im in IMarr


						ret.push([thisSE, im])


					


				lastSE:=thisSE


			}


		}


		


		j:=i+StrLen(match)


	}


	return ret


	


}


/*


class RisClass extends Polling {


	


	refresh(){


		this.base.state:=RisOpened()


		if this.compareState() && this.callback


			this.callback.call()


	}


}





;~ Ris:=CriticalObject(new Ris), Impax:=CriticalObject(new Impax), RisChanged:=false


;~ ,Ris.changeCallback("t")


;~ ,impax.StartPoll()





;~ th:=ahkthread("


;~ (%


;~ #Persistent


;~ Ris:=CriticalObject(" (&Ris) ")


;~ settimer,test,500


;~ return


;~ test:


;~ ToolTip % "","" Ris.state[1,2]


;~ return


;~ )")


;~ i:=CriticalObject(new Ris)


;~ i.changeCallback("t")





;~ t(){


	;~ MsgBox


;~ }


;~ esc::ExitApp


class ImpaxClass extends Polling  {


	


	refresh(){


		this.base.state:=impaxOpened()


		if this.compareState() && this.callback


			this.callback.call()


	}


	


}





class Polling {


	__New(){


		this.callback:=""


		,this.base.state:=[]


		,this.base.priorState:=[]


		,this.refresh()


		


	}


StartPoll(interval=500, timeout=-1) {


		this.StopPoll()


		,this.refresh()


		,this.SetTimer(this.base.refresh,interval,[AllRis])


		if(timeout>0){


			 this.SetTimer(this.base.StopPoll, Floor(timeout)*(-1))


		}


	}


	


  StopPoll() {


    this.SetTimer(this.base.refresh)


	,this.SetTimer(this.base.StopPoll)


  }


  changeCallback(func, interval=500, timeout=-1){


		this.callback:=IsObject(func)?func:func(func)


		,this.base.priorState:=this.base.state


		,this.StartPoll(interval, timeout)


	}


	


	


  compareState(){


		state1:=this.base.state, state2:=this.base.priorState


		,ret:=true


		for k,v in state1


			if IsObject(v)


				for x,y in v


					ret&= (y=state2[k][x])


			else


				ret &= (v=state2[k])


		this.base.priorState:=this.base.state


		return !ret


	}


  SetTimer( Function, Period=0, ParmObject=0, Priority=0 ) { 


    Static tmrs:=[] ; will hold timers that are currently running


    If IsFunc( Function ) {


      if IsObject(tmr:=tmrs[this]) ;destroy timer before creating a new one


        ret := DllCall( "KillTimer", "Ptr",0, "UPtr", tmr.tmr)


        , DllCall("GlobalFree", "Ptr", tmr.CBA)


        , ObjRemove(tmrs,this)


      if (Period = 0 || Period = "off")


        return ret ;Return as we want to turn off timer


      ; create object that will hold information for timer, it will be passed trough A_EventInfo when Timer is launched


      tmr:=tmrs[this]:={func:Function,ref:this,Period:Period="on" ? 250 : Period,Priority:Priority


                        ,OneTime:Period<0,params:IsObject(ParmObject)?ParmObject:[],Tick:A_TickCount}


      ,tmr.CBA := RegisterCallback(this.base.SetTimer,"F",4,&tmr)


      return !!(tmr.tmr  := DllCall("SetTimer", "Ptr",0, "Ptr",0, "UInt"


            , (Period && Period!="On") ? Abs(Period) : (Period := 250)


            , "Ptr",tmr.CBA)) ;Create Timer and return true if a timer was created


            , tmr.Tick:=A_TickCount


   }


  if IsObject(tmr := Object(A_EventInfo)) { ;A_Event holds object which contains timer information


    DllCall("KillTimer", "Ptr",0, "UPtr",tmr.tmr) ;deactivate timer so it does not run again while we are processing the function


    ,tmr.tick:= ErrorLevel := A_TickCount ;update tick to launch function on time


    ,func:=tmr.func,%func%(tmr.ref,tmr.params*) ; call function


    if (tmr.OneTime) ;One time timer, deactivate and delete it


      return DllCall("GlobalFree", "Ptr",tmr.CBA)


            ,ObjRemove(tmrs,tmr.ref?tmr.ref:tmr.func)


   tmr.tmr := DllCall("SetTimer", "Ptr",0, "Ptr",0, "UInt" ;reset timer


            ,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), "Ptr",tmr.CBA)


  }


  }





}


*/


;--------------include: F:\scripts\Autohotkey\Lib\StrPutVar.ahk------------


StrPutVar(string,ByRef var,encoding){


VarSetCapacity(var,StrPut(string,encoding)


*((encoding="utf-16"||encoding="cp1200")?2:1),00)


return StrPut(string,&var,encoding),VarSetCapacity(var,-1)


}





/*


StrPutVar(string, ByRef var, encoding)


{


    ; Ensure capacity.


    VarSetCapacity( var, StrPut(string, encoding)


        ; StrPut returns char count, but VarSetCapacity needs bytes.


        * ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) )


    ; Copy or convert the string.


    return StrPut(string, &var, encoding),VarSetCapacity(var,-1)


}


*/


;--------------include: F:\scripts\Autohotkey\Lib\SetTimerFn.ahk------------


SetTimerFn(FuncName, Period, param="", Priority=0, autoFree=true){


	static toBeFree:=[]


	if IsFunc(FuncName){


		fn:=Func(FuncName).Bind(param*)


	}else if IsBoundFunc(FuncName)


		fn:=FuncName


	else if (FuncName+0=FuncName && Period="Delete"){


		if (fn:=toBeFree[FuncName]){


			try{


				SetTimer,% fn, Delete


				SetTimer,, Delete


			}


			toBeFree.delete(FuncName)


			return


		}


	}


	try


		SetTimer,% fn,% Period,% Priority


	if(autoFree && Period!="Delete"){


		if(Period=0 || Period="off")


			try


				SetTimer,% fn,Delete


		else if (Period<0){


			self:=Func("SetTimerFn").Bind(t:=A_TickCount, "Delete")


			,toBeFree[t]:=fn


			try


				SetTimer,% self,% Period-1000,% Priority


		}


	}


	return fn


}











IsBoundFunc(obj) {


	static dummy := Func("Abs").Bind(1) ; dummy BoundFunc object


	return NumGet(&obj) == NumGet(&dummy)


}





;~ t(i){


	;~ ToolTip % i


;~ }


;~ #Persistent


;~ s:=SetTimerFn("t", 1000, [1])


;~ SetTimerFn("t", 300, [2])


;~ Sleep 3000


;~ SetTimerFn(s, "off")





;~ esc::ExitApp


;--------------include: F:\scripts\Autohotkey\Lib\XML.ahk------------


;~ x:=new xml("<MammoSR/>")


;~ x.addElement("a", "MammoSR")


;~ x.addElement("b", "//a", "1")


;~ x.addElement("b", "//a", "2")


;~ x.addElement("b", "//a", "3")


;~ y:=x.selectNodes("/MammoSR/a")


;~ MsgBox % y.item(0).selectSingleNode("//b[last()]").Text


;~ esc::


;~ ExitApp


/*


___________________________________________________________________________________





***THE FOLLOWING METHOD(s) ARE USING SIMILAR ROUTINES AND ARE CALLED DYNAMICALLY.


THEY REDIRECT TO INTERNAL METHOD(s), THUS, DOCUMENTATION IS STATED HERE***


____________________________________________________________________________________





METHOD(s): addElement/insertElement


DEFINITION: Appends or inserts an element node


PARAMETER(s):


    element -   Tag name(string or an IXMLDOMNode object)


    ps      -   If the user is calling the "addElement" method,


                this contains the parent node. Otherwise, if it's


                the "insertElement" method, this contains the


                reference node, the element will be inserted to


                the left of this node.


                Can be an XPath expression or an  IXMLDOMNode object


    prm*    -   Attributes and text. see Remarks


USAGE:


    e := xmlObj.addElement("Node", "//Parent", {name: "Element"}, "Text")


    e := xmlObj.insertElement("Node", "//Sibling", {name: "Element"}, {att: "Value"})


RETURN VALUE: An object. Returns the new element node


REMARKS:


    FOR THE 'PRM' PARAMETER:





    To assign/associate an attribute(s), specify an object with the 'key'


    as the attribute name and the 'value' as the attribute value.


    Specify multiple arrays if you want to retain order, internally


    it does a for-loop thus keys are re-arranged in the output.


	


    To add a text node, specify a string.


	


    Since this is a variadic parameter, the 'text' node must be specified last.


	


    E.G.:


    (Attribute and text)


    x.addElement("Node", "//Parent", {name: "Element"}, "Text")


    (Multiple attributes and a text node)


    x.addElement("Node", "//Parent", {name: "Element"}, {att: "value"}, "Text")


    (Text only)


    x.addElement("Node", "//Parent", "Text")


    (Attribute(s) only, note that 1 object[with multiple members] is passed)


    x.addElement("Node", "//Parent", {name: "Element", att: "Value"})


____________________________________________________________________________________





METHOD(s): addChild/insertChild


DEFINITION: Appends or inserts a new child node as the last child of the node.


PARAMETER(s):


    ps      -   If the user is calling the "addChild" method,


                this contains the parent node. Otherwise, if it's


                the "insertChild" method, this contains the


                reference node, the element will be inserted to


                the left of this node.


                can be an XPath expression or an IXMLDOMNode object


    type    -   The type of node to append.


                A value that uniquely identifies the node type.


                Specify the 'nodeType'(http://msdn.microsoft.com/en-us/library/ms753745(v=vs.85).aspx)


                or 'nodeTypeString'(http://msdn.microsoft.com/en-us/library/ms757895(v=vs.85).aspx)


                property of the node to be appended. A short-hand way is to use an


                acronym(see remarks).


                NODE TYPES: http://msdn.microsoft.com/en-us/library/ms766473(v=vs.85).aspx


    params* -   value(s) is dependent on the type of node to be appended. See remarks.


USAGE:


    xmlObj.addChild("//Node", 1, "Tag_Name") ; 'nodeType'


    xmlObj.addChild("//Parent", "element", "Tag_Name") ; 'nodeTypeString'


    xmlObj.addChild("//Parent", "e", "Tag_Name") ; Short-hand(acronym)


RETURN VALUE:   If successful this method returns an object representing the


                newly added node, otherwise it returns 'false'


REMARKS:


    =======================================================================


    NODE TYPES


    [nodeType, nodeTypeString, Short-hand]


    1       element                 'e'


    3       text                    't'


    4       cdatasection            'cds'


    5       entityreference         'er'


    6       entity                  'en'


    7       processinginstruction   'pi'


    8       comment                 'c'


    10      documenttype            'dt'


    11      documentfragment        'df'


    12      notation                'n'


    =======================================================================


    PARAMS* Value


    element             A string specifying the name for the new element node.


                        The name is case-sensitive.


    text                String specifying the value to be supplied to the new


                        text object's nodeValue property.


    cdatasection        same as 'text'


    entityreference     A string specifying the name of the entity referenced.


    entity


        params[1]       The name of the entity.


        params[2]       (Optional) The namespace URI. If specified, the node


                        is created in the context of the namespaceURI parameter


                        with the prefix specified on the node name. If the name


                        parameter does not have a prefix, this is treated as


                        the default namespace.


    processinginstruction


        params[1]       A string specifying the target part of the processing instruction.


        params[2]       A string specifying the rest of the processing instruction


                        preceding the closing ?> characters.


    comment             same as 'text'


    documenttype        same as 'entity'


    documentfragment    No parameters


    notation            same as 'entity'


    =======================================================================


____________________________________________________________________________________





*/





class xml


{


	


	/*


	METHOD: __New


	DEFINITION: Constructor for the class


	PARAMETER(s):


	    source  -  can be a string containing XML string or a 


	               filepattern specifying the location of an XML resource.


	               Omit to start off with an empty document.


	USAGE: Use the 'new' keyword


	    xmlDoc := new xml("<root><child/></root>") ; XML string


	    xmlDoc := new xml("MyFile.xml") ; XML file


	RETURN VALUE: A derived object


	REMARKS: Throws an exception


	*/


	


	__New(src:="") {


		static MSXML := "MSXML2.DOMDocument" (A_OSVersion ~= "WIN_(7|8)" ? ".6.0" : "")


		


		; Create object to store "file" property


		; this is to make sure that __Set() is always called everytime


		; there's an attempt to alter the property's value


		ObjInsert(this, "_", []) ; ByPass __Set()/__Call()?


		


		; Create IXMLDOMDocument object


		this.doc := ComObjCreate(MSXML)


		, this.setProperty("SelectionLanguage", "XPath")


		


		if src {


			if (src ~= "s)^<.*>$")  ; XML string


				this.loadXML(src)


			else if (src ~= "[^<>:""/\\|?*]+\.[^<>:""/\\|?*\s]+$") {


				if FileExist(src) ; Path/URL to XML file/resource


					this.load(src)


				this.file := ""


			} else throw Exception("The parameter '" src "' is neither an XML file "


				. " nor a string containing XML string.`n", -1, src)


			


			; Get last parsing error


			if (pe := this.parseError).errorCode {


				m := pe.url ? ["file", "load"] : ["string", "loadXML"]


				


				; throw exception


				throw Exception("Invalid XML " m.1 ".`nError Code: " pe.errorCode


				. "`nFilePos: " pe.filePos "`nLine: " pe.line "`nLinePos: " pe.linePos


				. "`nReason: " pe.reason "`nSource Text: " pe.srcText


				. "`nURL: " pe.url "`n", -1, m.2)


			}


			


			if (this.file <> false)


				this.file := src


		}


		


	}


	


	__Delete() {


		ObjRelease(Object(this.doc)) ; Is this necessary??


		OutputDebug, % "Object freed."


	}


	


	__Set(property, value) {


		if (property ~= "i)^(doc|file)$") { ; Class property


			if (property = "file") {


				if (value ~= "(^$|[^<>:""/\\|?*]+\.[^<>:""/\\|?*\s]+$)")


					return this._[property] := value


				else return false


			}


		} else { ; XML DOM property


			try return (this.doc)[property] := value


			catch


				return false


		}


	}


	


	__Get(property) {


		if !ObjHasKey(this, property) { ; Redundant??


			if (property = "file")


				return this._.HasKey(property)


					? this._[property]


					: false


			else {


				try return (this.doc)[property]


				catch


					; Allow user to select a node by providing an


					; XPath expression as key (short-hand way)


					; e.g. xmlObj["//Element/Child"] is equivalent


					; to xmlObj.selectSingleNode("//Element/Child")


					try return this.selectSingleNode(property)


			}


		}


	}


	


	__Call(method, params*) {


		static BF := "i)^(Insert|Remove|(Min|Max)Index|(Set|Get)Capacity"


			. "|GetAddress|_NewEnum|HasKey|Clone)$"


		


		if !ObjHasKey(xml, method) {


			if RegExMatch(method, "iJ)^(add|insert)((?P<_>E)lement|(?P<_>C)hild)$", m)


				return this["addInsert" m_](method, params*)


			else {


				try return (this.doc)[method](params*)


				catch e


					if !(method ~= BF)


						throw e


			}


		}


	}


	


	/*


	METHOD: rename


	DEFINITION: Renames an element node


	PARAMETER(s):


	    node    -   the element node to be renamed


	                can be an XPath expression or an IXMLDOMNode object


	    newName -   A string, the new name of the element node


	USAGE:


	    node := xmlObj.rename("//Node", "New_Name")


	RETURN VALUE:   An object


	*/


	


	rename(node, newName) {


		new := this.createElement(newName)


		, old := IsObject(node) ? node : this.selectSingleNode(node)


		


		while old.hasChildNodes()


			new.appendChild(old.firstChild)


		


		while (old.attributes.length > 0)


			new.setAttributeNode(old.removeAttributeNode(old.attributes[0]))


		


		old.parentNode.replaceChild(new, old)


		


		return new


	}


	


	/*


	METHOD: setAtt


	DEFINITION: Sets the attribute for an element node


	PARAMETER(s):


	    element -   the element node


	                can be an XPath expression or an IXMLDOMNode object


	    att     -   Attribute nodes to be associated with the element node


	                Specify an associative array with the key as the 'attribute name'


	                and the value as the 'attribute value'.


	USAGE:


	    xmlObj.setAtt("//Node", {name: "Name", age: "20"}) or


	    xmlObj.setAtt("//Node", {name: "Name"}, {age: "20"})


	RETURN VALUE: None


	*/


	


	setAtt(element, att*) {


		e := IsObject(element) ? element : this.selectSingleNode(element)


		


		for a, b in att {


			if !IsObject(b)


				continue


			for x, y in b


				e.setAttribute(x, y)


		}


	}


	


	/*


	METHOD: getAtt


	DEFINITION: Gets the value of the attribute.


	PARAMETER(s):


	    element -   the element node


	                can be an XPath expression or an IXMLDOMNode object


	    name    -   A string specifying the name of the attribute to return.


	USAGE:


	    xmlObj.getAtt("//Node", "name")


	RETURN VALUE:   The string that contains the attribute value.


	*/


	


	getAtt(element, name) {


		e := IsObject(element) ? element : this.selectSingleNode(element)


		return e.getAttribute(name)


	}


	


	/*


	METHOD: setText


	DEFINITION: Sets the text of an element node


	PARAMETER(s):


	    element -   the element node


	                can be an XPath expression or an IXMLDOMNode object


	    text    -   A string specifying the 'nodeValue' property of the child


	                'text' node associated with the specified 'element' node.


	                If blank the 'text' node(if any) will be removed.


	    idx     -   The index of the particular 'text' node whose value


	                will be set. Defaults to the first 'text' node.


	                *Though not a best-practice, it is very possible


	                to append multiple 'text' nodes to an element.


	                This parameter is for those cases only.


	USAGE:


	    xmlObj.setText("//Node", "New Text")


	    xmlObj.setText("//Node", "") ; removes/clears the 'text' node


	RETURN VALUE:   If the 'text' node exists and its value is altered


	                or cleared this method returns 'true'. Otherwise


	                this method creates a 'text' node and sets it value


	                to the one specified and then it returns an object


	                representing the newly added 'text' node


	*/


	


	setText(element, text:="", idx:=1) {


		e := IsObject(element) ? element : this.selectSingleNode(element)


		


		if (t := this.getChild(e, "t", idx)) {


			text <> "" ? t.nodeValue := text : e.removeChild(t)


			return true


		} else {


			t := this.createTextNode(text)


			, c := this.getChild(e, "", idx)


			return c ? e.insertBefore(t, c) : e.appendChild(t)


		}


	}


	


	/*


	METHOD: getText


	DEFINITION: Gets the 'nodeValue' property of the child 'text' node


	            of the specified element node


	PARAMETER(s):


	    element -   the element node


	                can be an XPath expression or an IXMLDOMNode object


	    idx     -   The index of the particular 'text' node whose value


	                will be retrieved . Defaults to the first 'text' node.


	                *Though not a best-practice, it is very possible


	                to append multiple 'text' nodes to an element.


	                This parameter is for those cases only. 


	USAGE:


	    xmlObj.getText("//Node")


	RETURN VALUE:   The string that contains the value


	*/


	


	getText(element, idx:=1) {


		e := IsObject(element) ? element : this.selectSingleNode(element)


		t := this.getChild(e, "t", idx)


			return t.text


	}


	


	/*


	METHOD: getChild


	DEFINITION: Gets the child node(of the specifiied 'type')


	            of the specified node.


	PARAMETER(s):


	    node    -   the parent node


	                can be an XPath expression or an IXMLDOMNode object


	    type    -   The type of node to get


	                see 'addChild' method for value(s)


	    idx     -   The index of the child node to be retrieved


	                Defaults to the first of its type 


	USAGE:


	    xmlObj.getChild("//Node", "element") ; 1st 'element' child


	    xmlObj.getChild("//Node", "element", 2) ; 2nd 'element' child


	RETURN VALUE:   An object representing the child node


	*/


	


	getChild(node, type:="element", idx:=1) {


		if !idx


			return


		n := IsObject(node) ? node : this.selectSingleNode(node)


		if !type


			return n.childNodes.item(idx-1)


		cn := this.getChildren(n, type)


		return ObjHasKey(cn, idx) ? cn[idx] : (idx<0 ? cn[cn.MaxIndex()+idx+1] : false)


	}


	


	/*


	METHOD: getChildren


	DEFINITION: Returns a list of children(of the specified 'type')


	            of the specified node


	PARAMETER(s):


	    node    -   the parent node


	                can be an XPath expression or an IXMLDOMNode object


	    type    -   The type of node to get


	                see 'addChild' method for value(s) 


	USAGE:


	    xmlObj.getChildren("//Node", "element")


	    xmlObj.getChildren("//Node", "text")


	RETURN VALUE:   An object containing a list of children


	                Each item in the list is an IXMLDOMNode object


	*/


	


	getChildren(node, type:="element") {


		static nts := {e:"element", t:"text", cds:"cdatasection"


		, er:"entityreference", en:"entity", pi:"processinginstruction"


		, c:"comment", dt:"documenttype", df:"documentfragment"


		, n:"notation"} ; nodeTypeString


		


		static _NT := "nodeType" , _NTS := "nodeTypeString"


		


		n := IsObject(node) ? node : this.selectSingleNode(node)


		if !n.hasChildNodes()


			return false


		cn := n.childNodes


		


		if (type ~= "^(1($|0|1|2)|[3-8])$")


			nType := _NT


		else if (type ~= "^[[:alpha:]]+$") {


			if (t := (StrLen(type)<=3))


				nType := ObjHasKey(nts, type) ? _NTS : false


			else {


				for a, b in nts


					continue


				until (nType := (type = b) ? _NTS : false)


			}


		} else return false


		


		if !nType


			return false


		


		c := []


		Loop, % cn.length {


			if (cn.item(A_Index-1)[nType] == (t ? nts[type] : type))


				c[(i := i ? i : 1)] := cn.item(A_Index-1), i+=1


		}


		return c


	}


	


	saveXML() {


		if this.file


			return this.save(this.file)


	}


	


	transformXML() {


		this.transformNodeToObject(this.style(), this.doc)


	}


	


	toEntity(ByRef str) {


		static e := [["&", "&amp;"], ["<", "&lt;"], [">", "&gt;"], ["'", "&apos;"], ["""", "&quot;"]]


		


		for a, b in e


			str := RegExReplace(str, b.1, b.2)


		return !(str ~= "s)([<>'""]|&(?!(amp|lt|gt|apos|quot);))")


	}


	


	toChar(ByRef str) {


		static e := [["<", "&lt;"], [">", "&gt;"], ["'", "&apos;"], ["""", "&quot;"], ["&", "&amp;"]]


		


		for a, b in e


			str := RegExReplace(str, b.2, b.1)


		return true


	}


	


	viewXML(ie:=true) {


		static dir := (FileExist(A_ScriptDir) ? A_ScriptDir : A_Temp)


		static _v := []


		


		dhw := A_DetectHiddenWindows


		DetectHiddenWindows, On


		


		if !this.documentElement


			return


		if WinExist("ahk_id " _v[this].hwnd)


			return


		if ie {


			this.save((f := dir "\tempXML_" A_TickCount ".xml"))


			if !FileExist(f)


				return


		} else (f := this.xml)


		


		if (hwnd := this._view(f)) {


			_v[this] := {hwnd: hwnd, res:f}


			WinWaitClose, % "ahk_id " hwnd


			ObjRemove(_v, this)


		}


		if (ie ? FileExist(f) : false)


			FileDelete, % f


		DetectHiddenWindows, % dhw


	}


	


	style(){


		static xsl


		


		if !IsObject(xsl) {


			RegExMatch(ComObjType(this.doc, "Name"), "IXMLDOMDocument\K(?:\d|$)", m)


			MSXML := "MSXML2.DOMDocument" (m < 3 ? "" : ".6.0")


			xsl := ComObjCreate(MSXML)


			style =


			(LTrim


			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


			<xsl:output method="xml" indent="yes" encoding="UTF-8"/>


			<xsl:template match="@*|node()">


			<xsl:copy>


			<xsl:apply-templates select="@*|node()"/>


			<xsl:for-each select="@*">


			<xsl:text></xsl:text>


			</xsl:for-each>


			</xsl:copy>


			</xsl:template>


			</xsl:stylesheet>


			)


			xsl.loadXML(style), style := NULL


		}


		return xsl


	}


	


	; ###################################


	;  INTERNAL METHOD(s) - DO NOT USE


	; ###################################


	


	addInsertE(m, en, pr:="", prm*) {


		n := pr


			? (IsObject(pr) ? pr : this.selectSingleNode(pr))


			: (m = "addElement" ? this.doc : false)


		e := IsObject(en) ? en : this.createElement(en)


		


		if prm.1 {


			if !IsObject(prm[prm.maxIndex()]) {


				t := prm.Delete(prm.maxIndex())


				if prm.1


					this.setAtt(e, prm*)


				if (t <> "")


					e.text := t


			} else this.setAtt(e, prm*)


		}


		


		if (m = "addElement")


			return n.appendChild(e)


		if (m = "insertElement")


			return n ? n.parentNode.insertBefore(e, n) : n


		


	}


	


	addInsertC(m, pr, type:="element", prm*) {


		static ntm := {1:"createElement", 3:"createTextNode", 4:"createCDATASection"


		, 5: "createEntityReference", 6:"createNode", 7:"createProcessingInstruction"


		, 8:"createComment", 10:"createNode", 11:"createDocumentFragment"


		, 12:"createNode"}


		


		static nt := {element:1, text:3, cdatasection:4, entityreference:5, entity:6


		, processinginstruction:7, comment:8, documenttype:10, documentfragment:11


		, notation:12, e:1, t:3, cds:4, er:5, en:6, pi:7, c:8, dt:10, df:11, n:12}


		


		n := IsObject(pr) ? pr : this.selectSingleNode(pr)


		


		if (type ~= "^(1($|0|1|2)|[3-8])$")


			_m := ntm[t := type]


		else if (type ~= "^[[:alpha:]]+$")


			_m := ntm[t := nt[type]]


		else return false


		


		if !_m


			return false


		


		if (_m == "createNode")


			_n := this[_m](t, prm*)


		else (_n := this[_m](prm*))


		


		if (m = "addChild")


			return _n ? n.appendChild(_n) : false


		if (m = "insertChild")


			return _n ? n.parentNode.insertBefore(_n, n) : false


		


	}


	


	_view(p*) {


		static _v := []


		


		if !ObjHasKey(_v, p.1) {


			if (p.1 ~= "^(\Q" A_ScriptDir "\E|\Q" A_Temp "\E)\\tempXML_\d+\.xml$")


				f := true


			else if (p.1 ~= "s)^<.*>$")


				f := false


			else return


			Gui, New


			Gui, +LastFound +LabelviewXML +Resize


			hwnd := WinExist()


			_v[hwnd] := {button:"", res: (f ? p.1 : false), xv:""}


			Gui, Margin, 0, 12


			Gui, Font, s10, Consolas


			Gui, Color, % f ? "" : 0xFFFFFF


			Gui, Add, % f ? "ActiveX" : "Edit"


			, % "y0 w600 h400 HwndhXV" (f ? "" : " HScroll -Wrap ReadOnly T8")


			, % f ? "Shell.Explorer" : p.1


			if f {


				GuiControlGet, IE,, % hXV


				IE.Navigate((_v[hwnd].res))


			}


			Gui, Add, Button, y+12 x+-100 w88 h26 Default HwndhBtn gviewXMLClose, OK


			Gui, Show,, % A_ScriptName " - viewXML"


			if !f


				SendMessage, 0x00B1, 0, 0,, % "ahk_id " hXV ; EM_SETSEL


			_v[hwnd].xv := hXV , _v[hwnd].button := hBtn


			return hwnd


		} else {


			if (p.2 == "viewXMLClose") {


				if (_v[p.1].res ? FileExist(_v[p.1].res) : false)


					FileDelete, % _v[p.1].res


				Gui, % p.1 ":Destroy"


				_v.Delete(p.1, "")


			}


			if (p.2 == "viewXMLSize") {


				if (A_EventInfo == 1) ; Minimized, do nothing


					return


				


				DllCall("SetWindowPos", "Ptr", _v[p.1].button, "Ptr", 0


				, "UInt", (A_GuiWidth-100), "UInt", (A_GuiHeight -38) ; x|y


				, "Uint",  88, "UInt", 26 ; w|h (ignored in this case)


				, "UInt", 0x0010|0x0001|0x0004) ; SWP_NOACTIVATE|SWP_NOSIZE|SWP_NOZORDER


				


				DllCall("SetWindowPos", "Ptr", _v[p.1].xv, "Ptr", 0


				, "UInt", 0, "UInt", 0 ; x|y (ignored in this case)


				, "Uint",  A_GuiWidth, "UInt", (A_GuiHeight-50) ; w|h


				, "UInt", 0x0010|0x0002|0x0004) ; SWP_NOACTIVATE|SWP_NOMOVE|SWP_NOZORDER


				


			}


		}


		return


		viewXMLSize:


		viewXMLClose:


		xml._view(A_Gui, A_ThisLabel)


		return


	}


	


}


;--------------include: F:\scripts\Autohotkey\Lib\JXON.ahk------------


Jxon_Load(ByRef src, args*)


{


	static q := Chr(34)





	key := "", is_key := false


	stack := [ tree := [] ]


	is_arr := { (tree): 1 }


	next := q . "{[01234567890-tfn"


	pos := 0


	while ( (ch := SubStr(src, ++pos, 1)) != "" )


	{


		if InStr(" `t`n`r", ch)


			continue


		if !InStr(next, ch, true)


		{


			ln := ObjLength(StrSplit(SubStr(src, 1, pos), "`n"))


			col := pos - InStr(src, "`n",, -(StrLen(src)-pos+1))





			msg := Format("{}: line {} col {} (char {})"


			,   (next == "")      ? ["Extra data", ch := SubStr(src, pos)][1]


			  : (next == "'")     ? "Unterminated string starting at"


			  : (next == "\")     ? "Invalid \escape"


			  : (next == ":")     ? "Expecting ':' delimiter"


			  : (next == q)       ? "Expecting object key enclosed in double quotes"


			  : (next == q . "}") ? "Expecting object key enclosed in double quotes or object closing '}'"


			  : (next == ",}")    ? "Expecting ',' delimiter or object closing '}'"


			  : (next == ",]")    ? "Expecting ',' delimiter or array closing ']'"


			  : [ "Expecting JSON value(string, number, [true, false, null], object or array)"


			    , ch := SubStr(src, pos, (SubStr(src, pos)~="[\]\},\s]|$")-1) ][1]


			, ln, col, pos)





			throw Exception(msg, -1, ch)


		}





		is_array := is_arr[obj := stack[1]]





		if i := InStr("{[", ch)


		{


			val := (proto := args[i]) ? new proto : {}


			is_array? ObjPush(obj, val) : obj[key] := val


			ObjInsertAt(stack, 1, val)


			


			is_arr[val] := !(is_key := ch == "{")


			next := q . (is_key ? "}" : "{[]0123456789-tfn")


		}





		else if InStr("}]", ch)


		{


			ObjRemoveAt(stack, 1)


			next := stack[1]==tree ? "" : is_arr[stack[1]] ? ",]" : ",}"


		}





		else if InStr(",:", ch)


		{


			is_key := (!is_array && ch == ",")


			next := is_key ? q : q . "{[0123456789-tfn"


		}





		else ; string | number | true | false | null


		{


			if (ch == q) ; string


			{


				i := pos


				while i := InStr(src, q,, i+1)


				{


					val := StrReplace(SubStr(src, pos+1, i-pos-1), "\\", "\u005C")


					static end := A_AhkVersion<"2" ? 0 : -1


					if (SubStr(val, end) != "\")


						break


				}


				if !i ? (pos--, next := "'") : 0


					continue





				pos := i ; update pos





				  val := StrReplace(val,    "\/",  "/")


				, val := StrReplace(val, "\" . q,    q)


				, val := StrReplace(val,    "\b", "`b")


				, val := StrReplace(val,    "\f", "`f")


				, val := StrReplace(val,    "\n", "`n")


				, val := StrReplace(val,    "\r", "`r")


				, val := StrReplace(val,    "\t", "`t")





				i := 0


				while i := InStr(val, "\",, i+1)


				{


					if (SubStr(val, i+1, 1) != "u") ? (pos -= StrLen(SubStr(val, i)), next := "\") : 0


						continue 2





					; \uXXXX - JSON unicode escape sequence


					xxxx := Abs("0x" . SubStr(val, i+2, 4))


					if (A_IsUnicode || xxxx < 0x100)


						val := SubStr(val, 1, i-1) . Chr(xxxx) . SubStr(val, i+6)


				}





				if is_key


				{


					key := val, next := ":"


					continue


				}


			}





			else ; number | true | false | null


			{


				val := SubStr(src, pos, i := RegExMatch(src, "[\]\},\s]|$",, pos)-pos)


				


				static nullVar := "" ; for #Warn


				if InStr(",true,false,null,", "," . val . ",", true) ; if var in


					val := %val%


				else if (Abs(val) == "") ? (pos--, next := "#") : 0


					continue


				


				val := val + 0, pos += i-1


			}


			


			is_array? ObjPush(obj, val) : obj[key] := val


			next := obj==tree ? "" : is_array ? ",]" : ",}"


		}


	}





	return tree[1]


}





Jxon_Dump(obj, indent:="", lvl:=1)


{


	static q := Chr(34)





	if IsObject(obj)


	{


		static Type := Func("Type")


		if Type ? (Type.Call(obj) != "Object") : (ObjGetCapacity(obj) == "")


			throw Exception("Object type not supported.", -1, Format("<Object at 0x{:p}>", &obj))





		is_array := 0


		for k in obj


			is_array := k == A_Index


		until !is_array





		static integer := "integer"


		if indent is %integer%


		{


			if (indent < 0)


				throw Exception("Indent parameter must be a postive integer.", -1, indent)


			spaces := indent, indent := ""


			Loop % spaces


				indent .= " "


		}


		indt := ""


		Loop, % indent ? lvl : 0


			indt .= indent





		lvl += 1, out := "" ; Make #Warn happy


		for k, v in obj


		{


			if IsObject(k) || (k == "")


				throw Exception("Invalid object key.", -1, k ? Format("<Object at 0x{:p}>", &obj) : "<blank>")


			


			if !is_array


				out .= ( ObjGetCapacity([k], 1) ? Jxon_Dump(k) : q . k . q ) ;// key


				    .  ( indent ? ": " : ":" ) ; token + padding


			out .= Jxon_Dump(v, indent, lvl) ; value


			    .  ( indent ? ",`n" . indt : "," ) ; token + indent


		}





		if (out != "")


		{


			out := Trim(out, ",`n" . indent)


			if (indent != "")


				out := "`n" . indt . out . "`n" . SubStr(indt, StrLen(indent)+1)


		}


		


		return is_array ? "[" . out . "]" : "{" . out . "}"


	}





	; Number


	else if (ObjGetCapacity([obj], 1) == "")


		return obj





	; String (null -> not supported by AHK)


	if (obj != "")


	{


		  obj := StrReplace(obj,  "\",    "\\")


		, obj := StrReplace(obj,  "/",    "\/")


		, obj := StrReplace(obj,    q, "\" . q)


		, obj := StrReplace(obj, "`b",    "\b")


		, obj := StrReplace(obj, "`f",    "\f")


		, obj := StrReplace(obj, "`n",    "\n")


		, obj := StrReplace(obj, "`r",    "\r")


		, obj := StrReplace(obj, "`t",    "\t")





		static needle := (A_AhkVersion<"2" ? "O)" : "") . "[^\x20-\x7e]"


		while RegExMatch(obj, needle, m)


			obj := StrReplace(obj, m[0], Format("\u{:04X}", Ord(m[0])))


	}


	


	return q . obj . q


}


;--------------include: F:\scripts\Autohotkey\Lib\json.ahk------------


#Escapechar \


#CommentFlag //








// Static initialization for stdlib, by fincs at autohotkey.com forums      //


__json_init()


{


   global


   static _ := __json_init()


   $$ := Object()


   JSON_init()


}








// Simple access to global variable $$                                      //


jQ(path, val = "") {





    global $$


    tempobj := $$





    last := (instr(path, ".")


        ? substr(path, 1+instr(path, ".", false, -1))


        : path)





    Loop, Parse, path, \.


    {


        if (val != "") {


            if (last = A_loopfield){


                tempObj[A_loopfield] := val


                continue


            } else if (!tempObj[A_Loopfield])


                tempObj[A_loopfield] := Object()


        } else if (!tempObj)


            break


        tempObj := tempObj[A_loopfield]


    }





    if (! tempObj)


        JSON_error("Cannot find or set entry " . path )


    else


        return (val = "" ?  tempObj : 0 )


}





//  Save JSON string to file                                              //


JSON_save(obj, filename, spacing=35, block="    ", level=1) {





    file         := FileOpen(filename, "w")


    jsonString   := JSON_to(obj, spacing, block, level) "\n"


    bytesWritten := file.write(jsonString)


    file.close()





    if (bytesWritten <= 0)


        JSON_error("Cannot write file " . filename)


    else


        return bytesWritten


}





//  Load JSON string from file                                            //


JSON_load(filename) {


    file := FileOpen(filename, "r")


    jsonString := file.read()


    file.close()


    if (jsonString == "")


        JSON_error("No file found, or blank file.")


    return JSON_from(jsonString)


}





//  Error handling                                                        //


JSON_error(s){


    Msgbox, % "[" . A_now . "] " . s


    Exit


}





//  Escape / unescape json keys and values                                //


JSON_escape(s){


    StringReplace, s, s, \\, \\\\, All


    StringReplace, s, s, ', \\',   All


    StringReplace, s, s, ", \\",   All


    return s


}


JSON_unescape(s){


    StringReplace, s, s, \\\\, \\, All


    StringReplace, s, s, \\', ',   All


    StringReplace, s, s, \\", ",   All


    return s


}





// Turns an object to a JSON string                                      //


JSON_to(obj, spacing = 50, block = "    ", level = "1" ) {





    s := ""


    for k, v in obj


    {


        // New line                        //


        if (s != "")


            s .= ","


        s .= "\n"





        // Indent key                      //


        Loop, %level%


            s .= block





        // Escape key and value            //


        k := JSON_escape(k)


        v := JSON_escape(v)





        // Write key                       //


        s .= """" k """: "





        // If object, do recursion         //


        if (isobject(v)) {


            s .= JSON_to(v, spacing, block, level + 1 )


        } else {


 


            // LeftAlign the second column      //


            totalKeyLength := level * strlen(block) + strlen(k) + 2


            if (spacing >= totalKeyLength ) {


                valueIndent := spacing - totalKeyLength


                loop, %valueIndent%


                    s .= " "


            }


            // Quote non-number values          //


            if v is not number


                v := """" v """"





            // New line                         //


            s .= v


        }


    }





    // Return                          //


    if ( (s == "") && !isobject(obj) ) {


        s := Object()


    } else if ( (s == "") && isobject(obj) ) {


        s := "{}"


    } else {


        s := "{" s "\n"


        level -= 1


        Loop, %level%


            s .= block


        s .= "}"


    }


    return s





}





//  Initialize the shift-reduce tables                                       //


JSON_init(){





    #EscapeChar `


    global JSON_regexps, JSON_rules





    //  symbol : regexp          //


    JSON_regexps := Object( ""


        . " " , "(\s+)"


        , "{" , "({)"


        , "[" , "(\[)"


        , "]" , "(\])"


        , "}" , "(})"


        , "Q" , "'([^'\\]*(\\.[^'\\]*)*)'"


        , "S" , """([^""\\]*(\\.[^""\\]*)*)"""


        , "N" , "([+\-]?\d+([.,]\d+)?)"


        , "D" , "(true|false|null)"


        , ":" , "(:)"


        , "," , "(,)" 


    . "" )





    //  1) Match "key" in the symbol stack                                   //


    //  2) Replace with "sub" in the symbol stack                            //


    //  3) Remove len("key") from the result stack                           //


    //  4) Append the result of function "func" on the result stack          //


    JSON_rules    := Object()


    JSON_rules[0] := Object( "key", "(\s+)",                             "sub", "" , "func", "JSON_reduce_spaces"   )


    JSON_rules[1] := Object( "key", "([QS]:[QSNOAD])",                   "sub", "_", "func", "JSON_reduce_keyvalue" )


    JSON_rules[2] := Object( "key", "(\[(([QSNOAD](,[QSNOAD])*\])|\]))", "sub", "A", "func", "JSON_reduce_array"    )


    JSON_rules[3] := Object( "key", "({}|{_(,_)*})",                     "sub", "O", "func", "JSON_reduce_object"   )





    #Escapechar \





}





// Reducing functions                                                       //


// Space                           //


JSON_reduce_spaces(c)  { 


    return ""


}


// Key-value pair                  //


JSON_reduce_keyvalue(c){


    return Object(c[3], c[1])


}


// Array                           //


JSON_reduce_array(c){


    ret := Object()





    new_idx := (c.maxindex() - 1) \/\/ 2


    for old_idx, token in c {


        if (mod(old_idx,2) == 0) {


            ret[new_idx] := token


            new_idx -= 1


        }


    }


    return ret


}


// Objects                         //


JSON_reduce_object(c){


    ret := Object()


    for old_idx, key_val in c {


        if (mod(old_idx,2) == 0) {


            for key, val in key_val {


                ret[key] := val


            }


        }


    }


    return ret


}











// Main parsing method                                                                      //


JSON_from(s){





    ret     := Object()


    pos     := 1


    symbols := ""


    len     := strLen(s)





    //   Loop over the tokens         //


    while (pos <= len) {





        // Shift a token                 //


        t := JSON_shift(s,pos,symbols,ret)





        // Reduce                       //


        symbols := JSON_reduce(t["symbols"],ret), pos := t["pos"]





    }





    // If succesfully reduced, return the object/array    //


    if (symbols == "O" || symbols == "A")


        return ret[""]


    else


        JSON_error("Invalid JSON string, cannot convert to object.")


}











//  Read a token and shift in symbol to the stack                                          //


JSON_shift(s, pos, symbols, ret){





    global JSON_regexps





    for symbol,regexp in JSON_regexps {





        // match 1 includes quotes, match 2 doesn't       //


        RegexMatch(s, "PSi)(" . regexp . ")", match_, pos)


        if (match_pos1 == pos){





            // Add current state to the symbol stack          //


            symbols .= symbol





            // Update position                                //


            pos  += match_len1





            // Insert the value in the value stack            //


            ret.push( JSON_unescape(substr(s, match_pos2, match_len2)) )





            // Return the updated symbol stack and pos        // 


            return Object("symbols", symbols, "pos", pos)


        }


    }





    // If there is nothing to shift, error  //


    JSON_error("Error at pos:" pos "\n" substr(s,pos-4))


    exit


}











//  Reduces groups of symbols into others according to the rule table                       //


JSON_reduce(symbols, ret){





    global JSON_regexps, JSON_rules





    rule_idx := 0





    // Loop over rules, to check if it's possible to reduce tokens //


    while (rule_idx <= JSON_rules.maxIndex()) {





        children    := Object()


        rule        := JSON_rules[rule_idx]


        old_symbols := rule["key"]


        new_symbol  := rule["sub"]


        reduce_func := rule["func"]





        // Find something to reduce //


        Regexmatch(symbols, "PSi)" . old_symbols . "$", match_)





        // If you find nothing, continue to the next rule //


        if ( match_pos1 < 1 ) {


            rule_idx += 1


            continue


        }





        // If you find something, remove the symbols from the symbols stack  //


        // and reduce the tokens in the result stack                         //


        Loop, %match_len1% {


            if (ryle_idx != 0 )


                children.push( ret[ret.maxindex()] )


            ret.pop()


            stringtrimright, symbols, symbols, 1


        }





        // Append the reduced symbol to the symbol stack  //


        symbols .= new_symbol


        rule_idx := 0





        // Reduce the tokens into a new one  //


        if ((new_token := %reduce_func%(children)) != "")


            ret[ret.maxindex()+1] := new_token





    }





    return symbols





}





#Escapechar `


#CommentFlag ;





;--------------include: F:\scripts\Autohotkey\Lib\binaryIO.ahk------------


Bin2Hex(ByRef h, ByRef b, n=0)      ; n bytes binary data -> stream of 2-digit hex


{                                   ; n = 0: all (SetCapacity can be larger than used!)


   format = %A_FormatInteger%       ; save original integer format


   SetFormat Integer, Hex           ; for converting bytes to hex





   m := VarSetCapacity(b)


   If (n < 1 or n > m)


       n := m


   Address := &b


   h =


   Loop %n%


   {


      x := *Address                 ; get byte in hex


      StringTrimLeft x, x, 2        ; remove 0x


      x = 0%x%                      ; pad left


      StringRight x, x, 2           ; 2 hex digits


      h = %h%%x%


      Address++


   }


   SetFormat Integer, %format%      ; restore original format


}





Hex2Bin(ByRef b, h, n=0)            ; n hex digit-pairs -> binary data


{                                   ; n = 0: all. (Only ByRef can handle binaries)


   m := Ceil(StrLen(h)/2)


   If (n < 1 or n > m)


       n := m


   Granted := VarSetCapacity(b, n, 0)


   IfLess Granted,%n%, {


      ErrorLevel = Mem=%Granted%


      Return


   }


   Address := &b


   Loop %n%


   {


      StringLeft  x, h, 2


      StringTrimLeft h, h, 2


      x = 0x%x%


      DllCall("RtlFillMemory", "UInt", Address, "UInt", 1, "UChar", x)


      Address++


   }


}





/* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BinWrite ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


|  - Open binary file


|  - (Over)Write n bytes (n = 0: all)


|  - From offset (offset < 0: counted from end)


|  - Close file


|  (Binary)data -> file[offset + 0..n-1], rest of file unchanged


|  Return #bytes actually written


*/ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





BinWrite(file, ByRef data, n=0, offset=0)


{


   ; Open file for WRITE (0x40..), OPEN_ALWAYS (4): creates only if it does not exists


   h := DllCall("CreateFile","str",file,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)


   IfEqual h,-1, SetEnv, ErrorLevel, -1


   IfNotEqual ErrorLevel,0,Return,0 ; couldn't create the file





   m = 0                            ; seek to offset


   IfLess offset,0, SetEnv,m,2


   r := DllCall("SetFilePointerEx","Uint",h,"Int64",offset,"UInt *",p,"Int",m)


   IfEqual r,0, SetEnv, ErrorLevel, -3


   IfNotEqual ErrorLevel,0, {


      t = %ErrorLevel%              ; save ErrorLevel to be returned


      DllCall("CloseHandle", "Uint", h)


      ErrorLevel = %t%              ; return seek error


      Return 0


   }





   m := VarSetCapacity(data)        ; get the capacity ( >= used length )


   If (n < 1 or n > m)


       n := m


   result := DllCall("WriteFile","UInt",h,"Str",data,"UInt",n,"UInt *",Written,"UInt",0)


   if (!result or Written < n)


       ErrorLevel = -3


   IfNotEqual ErrorLevel,0, SetEnv,t,%ErrorLevel%





   h := DllCall("CloseHandle", "Uint", h)


   IfEqual h,-1, SetEnv, ErrorLevel, -2


   IfNotEqual t,,SetEnv, ErrorLevel, %t%-%ErrorLevel%





   Return Written


}





/* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BinRead ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


|  - Open binary file


|  - Read n bytes (n = 0: file size)


|  - From offset (offset < 0: counted from end)


|  - Close file


|  (Binary)data (replaced) <- file[offset + 0..n-1]


|  Return #bytes actually read


*/ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





BinRead(file, ByRef data, n=0, offset=0)


{


   h := DllCall("CreateFile","Str",file,"Uint",0x80000000,"Uint",3,"UInt",0,"UInt",3,"Uint",0,"UInt",0)


   IfEqual h,-1, SetEnv, ErrorLevel, -1


   IfNotEqual ErrorLevel,0,Return,0 ; couldn't open the file





   m = 0                            ; seek to offset


   IfLess offset,0, SetEnv,m,2


   r := DllCall("SetFilePointerEx","Uint",h,"Int64",offset,"UInt *",p,"Int",m)


   IfEqual r,0, SetEnv, ErrorLevel, -3


   IfNotEqual ErrorLevel,0, {


      t = %ErrorLevel%              ; save ErrorLevel to be returned


      DllCall("CloseHandle", "Uint", h)


      ErrorLevel = %t%              ; return seek error


      Return 0


   }





   m := DllCall("GetFileSize","UInt",h,"Int64 *",r)


   If (n < 1 or n > m)


       n := m


   Granted := VarSetCapacity(data, n, 0)


   IfLess Granted,%n%, {


      ErrorLevel = Mem=%Granted%


      Return 0


   }





   result := DllCall("ReadFile","UInt",h,"Str",data,"UInt",n,"UInt *",Read,"UInt",0)





   if (!result or Read < n)


       t = -3


   IfNotEqual ErrorLevel,0, SetEnv,t,%ErrorLevel%





   h := DllCall("CloseHandle", "Uint", h)


   IfEqual h,-1, SetEnv, ErrorLevel, -2


   IfNotEqual t,,SetEnv, ErrorLevel, %t%-%ErrorLevel%





   Return Read


}


;--------------include: F:\scripts\Autohotkey\Lib\Crypt_AES.ahk------------


Crypt_AES(pData, nSize, sPassword, SID = 256, bEncrypt = True)


{


	CALG_AES_256 := 1 + CALG_AES_192 := 1 + CALG_AES_128 := 0x660E


	CALG_SHA1 := 1 + CALG_MD5 := 0x8003


	DllCall("advapi32\CryptAcquireContextA", "UintP", hProv, "Uint", 0, "Uint", 0, "Uint", 24, "Uint", 0xF0000000)


	DllCall("advapi32\CryptCreateHash", "Uint", hProv, "Uint", CALG_SHA1, "Uint", 0, "Uint", 0, "UintP", hHash)


	DllCall("advapi32\CryptHashData", "Uint", hHash, "Uint", &sPassword, "Uint", StrLen(sPassword), "Uint", 0)


	DllCall("advapi32\CryptDeriveKey", "Uint", hProv, "Uint", CALG_AES_%SID%, "Uint", hHash, "Uint", SID<<16, "UintP", hKey)


	DllCall("advapi32\CryptDestroyHash", "Uint", hHash)


	If	bEncrypt


		DllCall("advapi32\CryptEncrypt", "Uint", hKey, "Uint", 0, "Uint", True, "Uint", 0, "Uint", pData, "UintP", nSize, "Uint", nSize+16)


	Else	DllCall("advapi32\CryptDecrypt", "Uint", hKey, "Uint", 0, "Uint", True, "Uint", 0, "Uint", pData, "UintP", nSize)


	DllCall("advapi32\CryptDestroyKey", "Uint", hKey)


	DllCall("advapi32\CryptReleaseContext", "Uint", hProv, "Uint", 0)


	Return	nSize


}





;~ Crypt_AES(pData, nSize, sPassword, SID = 256, bEncrypt = True)


;~ {


   ;~ CALG_AES_256 := 1 + CALG_AES_192 := 1 + CALG_AES_128 := 0x660E


   ;~ CALG_SHA1 := 1 + CALG_MD5 := 0x8003


   ;~ DllCall("advapi32\CryptAcquireContext", "UPtr*", hProv, "UPtr", 0, "UPtr", 0, "UPtr", 24, "UPtr", 0xF0000000)


   ;~ DllCall("advapi32\CryptCreateHash", "UPtr", hProv, "UPtr", CALG_SHA1, "UPtr", 0, "UPtr", 0, "UPtr*", hHash)


   ;~ DllCall("advapi32\CryptHashData", "UPtr", hHash


   ;~ , "UPtr", &sPassword


   ;~ , "UPtr", (A_IsUnicode ? StrLen(sPassword)*2 : StrLen(sPassword)), "UPtr", 0)


   ;~ DllCall("advapi32\CryptDeriveKey", "UPtr", hProv, "UPtr", CALG_AES_%SID%, "UPtr", hHash, "UPtr", SID<<16, "UPtr*", hKey)


   ;~ DllCall("advapi32\CryptDestroyHash", "UPtr", hHash)


   ;~ bEncrypt


   ;~ ? DllCall("advapi32\CryptEncrypt", "UPtr", hKey, "UPtr", 0, "UPtr", True, "UPtr", 0


    ;~ , (A_PtrSize = 8 ? "UInt64" : "UInt"), pData, (A_PtrSize = 8 ? "UInt64P" : "UIntP"), nSize, "UPtr", nSize+16)


   ;~ : DllCall("advapi32\CryptDecrypt", "UPtr", hKey, "UPtr", 0, "UPtr", True, "UPtr", 0


    ;~ , (A_PtrSize = 8 ? "UInt64" : "UInt"), pData, (A_PtrSize = 8 ? "UInt64P" : "UIntP"), nSize)


   ;~ DllCall("advapi32\CryptDestroyKey", "UPtr", hKey)


   ;~ DllCall("advapi32\CryptReleaseContext", "UPtr", hProv, "UPtr", 0)


   ;~ Return   nSize


;~ }


;--------------include: F:\scripts\Autohotkey\Lib\Hex2Bin.ahk------------


Bin_Hex(ByRef Bin,Len,Chunks=32, Div="|") {


	; Bin2Hex - Convert Binary data in a variable to hex, good for displaying data from a DLL call


	;	Bin   = The data,


	;	Len	  = The size in bytes


	;	Chunks= How many bits to insert a divider, set to zero for no divider


	;	Div	  = Character/String to divide chunks


	; Returns - String with Hex characters and chunks dividers


	;	e.g.  - "EC010100|00000000|0______|60EB6D04"


	bytes:=Chunks/8


	strint:=A_FormatInteger


	SetFormat, IntegerFast, H


	line:=""


	Loop, %Len% {


		chunk:=NumGet(Bin,A_Index-1, "UChar") 


		chunk:=SubStr("00" . SubStr(chunk,3), -1) 


		if (!Mod(A_Index-1,bytes) && Chunks!=0)


			line.=Div


		line.=chunk


	}


	SetFormat, IntegerFast, %strint%


	Return line


}





Hex_Bin(ByRef bin, hex) { ; Hex2Bin(fun,"8B4C24") = MCode(fun,"8B4C24")


   Static fun


   If (fun = "") {


      h:="568b74240c8a164684d2743b578b7c240c538ac2c0e806b109f6e98ac802cac0e104880f8"


       . "a164684d2741a8ac2c0e806b309f6eb80e20f02c20ac188078a16474684d275cd5b5f5ec3"


      VarSetCapacity(fun,StrLen(h)//2)


      Loop % StrLen(h)//2


         NumPut("0x" . SubStr(h,2*A_Index-1,2), fun, A_Index-1, "Char")


   }


   VarSetCapacity(bin,StrLen(hex)//2)


   dllcall( &fun, "uint",&bin, (A_IsUnicode ? "AStr" : "Str"),hex, "cdecl" )


}


;--------------include: F:\scripts\Autohotkey\Lib\httprequest.ahk------------


/*


###############################################################################################################


###                                       HTTPRequest. Version: 2.42                                        ###


###############################################################################################################





Copyright ɠ2011-2012 [VxE]. All rights reserved.





Redistribution and use in source and binary forms, with or without modification, are permitted provided that


the following conditions are met:





1. Redistributions of source code must retain the above copyright notice, this list of conditions and the


following disclaimer.





2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the


following disclaimer in the documentation and/or other materials provided with the distribution.





3. The name "[VxE]" may not be used to endorse or promote products derived from this software without specific


prior written permission.





THIS SOFTWARE IS PROVIDED BY [VxE] "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED


TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT


SHALL [VxE] BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES


(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR


BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR


TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF


THE POSSIBILITY OF SUCH DAMAGE.


*/





HTTPRequest( URL, byref In_POST__Out_Data="", byref In_Out_HEADERS="", Options="" ) { ; -----------------------


; Function by [VxE], compatible with AHK v1.0.48.05 (basic), v1.1.00.00 (AHK-L ANSI, Unicode, x64) and later.


; Special thanks to derRaphael and everyone who reported bugs and/or suggested improvements.


; Source is freely available at: http://www.autohotkey.com/forum/viewtopic.php?t=66290


; MUFL-Info: http://dl.dropbox.com/u/13873642/mufl_httprequest.txt


; Submits one request to the specified URL with optional POST data and custom headers. Upon success, returns


; the number of bytes downloaded OR the number of characters in the response. Otherwise, returns zero and a


; description of the error is placed in 'In_Out_HEADERS'. The response body and headers are placed into


; 'In_POST__Out_Data' and 'In_Out_HEADERS' respectively, and text data is converted from the codepage stated in


; the header to the script's ANSI codepage OR to UTF-16 for unicode versions of AHK.


; "ErrorLevel" is set to '0' if there is a problem, otherwise it is set to the HTTP response code.





	Static version := "2.42", Ptr, PtrSize, IsUnicode, MyACP, MyCharset, Default_Agent, WorA := ""


	, Default_Accept_Types := "text/xml, text/json; q=0.4, text/html; q=0.3, text/*; q=0.2, */*; q=0.1"


; This list of content subtypes is not official, I just globbed together a few MIME subtypes to use


; as a whitelist for converting downloaded text to the script's codepage. If the Content-Type


; response header IS "text/..." OR one of these subtypes follows the "/", then the data is treated


; as text. Otherwise, the data is treated as binary and the user must deal with it as binary.


	, Text_Content_Subtypes := "/atom/html/json/rss/soap/xhtml/xml/x-www-form-urlencoded"


; The list of internet flags and values has been condensed and obfuscated for version (09-10-2011).


; Flag values may be found here > http://msdn.microsoft.com/en-us/library/aa383661%28v=vs.85%29.aspx


	, internet_flags_list := "


( LTRIM JOIN|INTERNET_FLAG_


	....


	NEED_FILE


	MUST_CACHE_REQUEST|.


	FWD_BACK|.


	FORMS_SUBMIT|..


	PRAGMA_NOCACHE|.


	NO_UI|.


	HYPERLINK|.


	RESYNCHRONIZE|.


	IGNORE_CERT_CN_INVALID|.


	IGNORE_CERT_DATE_INVALID|.


	IGNORE_REDIRECT_TO_HTTPS|.


	IGNORE_REDIRECT_TO_HTTP|..


	RESTRICTED_ZONE|.


	NO_AUTH|.


	NO_COOKIES|.


	READ_PREFETCH|.


	NO_AUTO_REDIRECT|.


	KEEP_CONNECTION|.


	SECURE|.


	FROM_CACHE


	OFFLINE|.


	MAKE_PERSISTENT|.


	DONT_CACHE|...


	NO_CACHE_WRITE|.


	RAW_DATA|.


	RELOAD|


)"


; Update (12-10-2011): The list of security flags and values is condensed and obfuscated.


; Flag values may be found here > http://msdn.microsoft.com/en-us/library/aa385328%28v=VS.85%29.aspx


	, security_flags_list := "


( LTRIM JOIN|SECURITY_FLAG_


	SECURE|.


	SSL|.


	SSL3|.


	PCT|.


	PCT4|.


	IETFSSL4|..


	IGNORE_REVOCATION|.


	IGNORE_UNKNOWN_CA|.


	IGNORE_WRONG_USAGE|...


	IGNORE_CERT_CN_INVALID|.


	IGNORE_CERT_DATE_INVALID|.


	IGNORE_REDIRECT_TO_HTTPS|.


	IGNORE_REDIRECT_TO_HTTP|............


	FORTEZZA|.


	40BIT


	NORMALBITNESS


	STRENGTH_WEAK|.


	128BIT


	STRENGTH_STRONG|.


	56BIT


	STRENGTH_MEDIUM|.


	UNKNOWNBIT|


)"


	, Codepage_Charsets := "|


; Codepage list taken from here > http://msdn.microsoft.com/en-us/library/dd317756%28v=vs.85%29.aspx


( LTRIM JOIN|


	00037=IBM037|00437=IBM437|00500=IBM500|00708=ASMO-708|00720=DOS-720|00737=ibm737


	00775=ibm775|00850=ibm850|00852=ibm852|00855=IBM855|00857=ibm857|00858=IBM00858|00860=IBM860


	00861=ibm861|00862=DOS-862|00863=IBM863|00864=IBM864|00865=IBM865|00866=cp866|00869=ibm869


	00870=IBM870|00874=windows-874|00875=cp875|00932=shift_jis|00936=gb2312|00949=ks_c_5601-1987


	00950=big5|01026=IBM1026|01047=IBM01047|01140=IBM01140|01141=IBM01141|01142=IBM01142


	01143=IBM01143|01144=IBM01144|01145=IBM01145|01146=IBM01146|01147=IBM01147|01148=IBM01148


	01149=IBM01149|01200=utf-16|01201=unicodeFFFE|01250=windows-1250|01251=windows-1251


	01252=Windows-1252|01253=windows-1253|01254=windows-1254|01255=windows-1255


	01256=windows-1256|01257=windows-1257|01258=windows-1258|01361=Johab|10000=macintosh


	10001=x-mac-japanese|10002=x-mac-chinesetrad|10003=x-mac-korean|10004=x-mac-arabic


	10005=x-mac-hebrew|10006=x-mac-greek|10007=x-mac-cyrillic|10008=x-mac-chinesesimp


	10010=x-mac-romanian|10017=x-mac-ukrainian|10021=x-mac-thai|10029=x-mac-ce


	10079=x-mac-icelandic|10081=x-mac-turkish|10082=x-mac-croatian|12000=utf-32|12001=utf-32BE


	20000=x-Chinese-CNS|20001=x-cp20001|20002=x-Chinese-Eten|20003=x-cp20003|20004=x-cp20004


	20005=x-cp20005|20105=x-IA5|20106=x-IA5-German|20107=x-IA5-Swedish|20108=x-IA5-Norwegian


	20127=us-ascii|20261=x-cp20261|20269=x-cp20269|20273=IBM273|20277=IBM277|20278=IBM278


	20280=IBM280|20284=IBM284|20285=IBM285|20290=IBM290|20297=IBM297|20420=IBM420|20423=IBM423


	20424=IBM424|20833=x-EBCDIC-KoreanExtended|20838=IBM-Thai|20866=koi8-r|20871=IBM871


	20880=IBM880|20905=IBM905|20924=IBM00924|20932=EUC-JP|20936=x-cp20936|20949=x-cp20949


	21025=cp1025|21866=koi8-u|28591=iso-8859-1|28592=iso-8859-2|28593=iso-8859-3|28594=iso-8859-4


	28595=iso-8859-5|28596=iso-8859-6|28597=iso-8859-7|28598=iso-8859-8|28599=iso-8859-9


	28603=iso-8859-13|28605=iso-8859-15|29001=x-Europa|38598=iso-8859-8-i|50220=iso-2022-jp


	50221=csISO2022JP|50222=iso-2022-jp|50225=iso-2022-kr|50227=x-cp50227|51932=euc-jp


	51936=EUC-CN|51949=euc-kr|52936=hz-gb-2312|54936=GB18030|57002=x-iscii-de|57003=x-iscii-be


	57004=x-iscii-ta|57005=x-iscii-te|57006=x-iscii-as|57007=x-iscii-or|57008=x-iscii-ka


	57009=x-iscii-ma|57010=x-iscii-gu|57011=x-iscii-pa|65000=utf-7|65001=utf-8|


)"





; Step 1: Initialize internal variables, including the static variables for unknown constants.


	If ( WorA = "" )


	{


		If ( A_PtrSize = "" ) ; Check for 64 bit environment


			PtrSize := 4, Ptr := "UInt"


		Else PtrSize := A_PtrSize, Ptr := "Ptr"


		If !( IsUnicode := 1 = A_IsUnicode ) ; Check for unicode (wide char) environment


		; GetACP > http://msdn.microsoft.com/en-us/library/ms905215.aspx


			WorA := "A", MyACP := SubStr( 100000.0 + DllCall("GetACP"), 2, 5 )


		Else WorA := "W", MyACP := "01200" ; UTF-16


		; Detect the active codepage and look up the charset identifier for it (default = UTF-8)


		MyCharset := ( 7 = pos := 7 + InStr( Codepage_Charsets, "|" MyACP "=" ) ) ? "UTF-8"


		: SubStr( Codepage_Charsets, pos, InStr( Codepage_Charsets, "|", 0, pos ) - pos )


		SplitPath, A_ScriptName,,,, Default_Agent


		Default_Agent .= "/1.0 (Language=AutoHotkey/" A_AhkVersion "; Platform=" A_OSVersion ")"


	}





; Initialize local variables


	Internet_Open_Type := 1 ; INTERNET_OPEN_TYPE_DIRECT = 1 ; _PRECONFIG = 0 ; _PROXY = 3


	Security_Flags := Security_Flags_Add := Security_Flags_Nix := 0


	Response_Code := "0"


	Do_Callback := 0


	Do_NonBinary_Up := 0


	Do_Binary_Down := 0


	Do_Up_MD5_Hash := 0


	Do_Dn_MD5_Hash := 0


	Do_File_Upload := 0


	Do_Multipart := 0


	Do_Download_To_File := 0


	Do_Download_Resume := 0


	Do_Legacy_Dual_Output := 0


	Agent := Default_Agent


	Accept_Types := Default_Accept_Types


	Multipart_Boundary := ""


	proxy_bypass := ""


	Method_Verb := ""


	MyErrors := ""


	dbuffsz := 0


	port := 0


	dtsz := 0


	Convert_POST_To_Codepage := MyACP





; Initialize typical flags for a normal request. These can be modified with the 'Options' parameter.


	Internet_Flags := 0


	| 0x400000 ; INTERNET_FLAG_KEEP_CONNECTION


	| 0x80000000 ; INTERNET_FLAG_RELOAD


	| 0x20000000 ; INTERNET_FLAG_NO_CACHE_WRITE





	StringLen, Content_Length, In_POST__Out_Data ; predetermine the content-length.


	Content_Length <<= IsUnicode





; Step 2: Crack the url into its components. WinINet\InternetCrackURL limits the url to about 2060


; characters, which is unacceptable, especially for a function designed to service web APIs.





	hbuffer := "The provided url could not be parsed: """ URL """" ; pre-generate the bad-url error





; Crack the scheme (setting it to 'http' if omitted, allowing a url like "www.***.com")


	If ( pos := InStr( URL, "://" ) )


	{


		StringLeft, scheme, URL, pos - 1


		StringLower, scheme, scheme


		StringTrimLeft, URL, URL, pos + 2


		If ( scheme = "https" ) ; Connect using SSL. Add the following internet flags:


			Internet_Flags |= 0x1000 ; INTERNET_FLAG_IGNORE_CERT_CN_INVALID


						| 0x2000   ; INTERNET_FLAG_IGNORE_CERT_DATE_INVALID


						| 0x800000 ; INTERNET_FLAG_SECURE ; Technically, this is redundant for https


		Else If ( scheme != "http" )


			Return 0, ErrorLevel := 0, In_Out_HEADERS := "HTTPRequest does not support '" scheme "' type connections."


	}


	Else scheme := "http"





; Crack the path and query (leave them joined as one string because that's how HttpOpenRequest accepts them).


	StringLeft, host, URL, pos := InStr( URL "/", "/" ) - 1


	StringTrimLeft, URL, URL, pos





; Crack the username and password from the host (if present).


	If ( pos := InStr( host, "@" ) )


	{


		StringLeft, user, host, pos - 1


		StringTrimLeft, host, host, pos


		If ( pos := InStr( user, ":" ) )


		{


			StringTrimLeft, pass, user, pos


			StringLeft, user, user, pos - 1


		}


		Else pass := ""


	}


	Else user := pass := ""





; Crack the port from the host. If the host looks like a bracketed IP literal, look for the colon


; to the right of the close-bracket. Default port is 80 for HTTP and 443 for HTTPS


	If ( pos := InStr( host, ":", 0, InStr( host, "[" ) = 1 ? InStr( host, "]" ) + 1 : 1 ) )


	&& ( 0 < port := 0 | SubStr( host, pos + 1 ) ) && ( port < 65536 )


	{


		StringTrimLeft, port, host, pos


		StringLeft, host, host, pos - 1


	}


	Else port := scheme = "https" ? 443 : 80





; Return error if the host is blank (don't check for other format errors).


	If ( host = "" )


		Return 0, ErrorLevel := 0, In_Out_HEADERS := hbuffer





; Step 3: Parse the request headers so we can copy them to an internal buffer, make them pretty, and


; handle special headers (like acceptable mime types, user agent and content specs).


	StringLen, pos, In_Out_HEADERS


	VarSetCapacity( hbuffer, 1 + pos << IsUnicode )


	hbuffer := "`r`n"


	Loop, Parse, In_Out_HEADERS, `n


	{


		StringReplace, rbuffer, A_LoopField, :, `n


		Loop, Parse, rbuffer, `n, % "`t`r "


			If ( A_Index = 1 )


				rbuffer := A_LoopField


			Else If ( A_LoopField = "" )


				If ( rbuffer = "Content-MD5" )


					Do_Up_MD5_Hash := 1


				Else Continue


			Else If ( rbuffer = "Accept" )


				Accept_Types := A_LoopField


			Else If ( rbuffer = "Content-Length" ) && ( 0 < 1 | A_LoopField )


				Content_Length := A_LoopField


			Else If ( rbuffer = "Content-Type" )


			{


				hbuffer .= "Content-Type: " A_LoopField "`r`n"


				StringReplace, Multipart_Boundary, A_LoopField, % ",", % ";", A


				If ( 7 != pos := 7 + InStr( Multipart_Boundary, "charset=" ) )


				&& ( pos := InStr( Codepage_Charsets, SubStr( Multipart_Boundary, pos


					, InStr( Multipart_Boundary ";" , ";", 0, pos ) - pos ) "|" ) )


					StringMid, Convert_POST_To_Codepage, Codepage_Charsets, pos - 5, 5





				; NOT YET IMPLEMENTED: detect multipart content and determine the boundary


				Multipart_Boundary := ( InStr( A_LoopField, "Multipart/" ) != 1


					|| 9 = pos := 9 + InStr( Multipart_Boundary, "boundary=" ) ) ? ""


				: SubStr( Multipart_Boundary, pos, InStr( Multipart_Boundary ";", ";" ) - pos )


			}


			Else If ( rbuffer = "Referrer" )


				hbuffer .= "Referer: " A_LoopField "`r`n"


			Else If ( rbuffer = "User-Agent" )


				Agent := A_LoopField


			Else hbuffer .= rbuffer ": " A_LoopField "`r`n"


	}


; Automatically add the 'no cookies' flag if the user specified a custom cookie. The flag actually tells


; wininet not to automatically handle cookies (which 'automatically' ignores custom cookie headers).


	IfInString, hbuffer, % "`r`nCookie: "


		options .= "`n+NO_COOKIES"





; Step 4: Extract the multipart envelope from the options parameter, then parse the options normally.


	If ( Multipart_Boundary != "" ) && ( pos := InStr( options, "--" Multipart_Boundary ) )


	&& ( ( 4 + StrLen( Multipart_Boundary ) ) != ( Multipart_Boundary := 4


	+ StrLen( Multipart_Boundary ) + InStr( options, "--" Multipart_Boundary "--", 0, 0 ) ) )


	{


		StringMid, Multipart_Envelope, options, pos, Multipart_Boundary - pos


		options := SubStr( options, 1, pos - 1 ) SubStr( options, Multipart_Boundary )


;		Do_Multipart := 1 ; NOT YET IMPLEMENTED


	}


	Loop, Parse, options, `n


	{


		If InStr( A_LoopField, ">" ) + 3 >> 2 = 1


		{


		; Handle the legacy output-file syntax


			Loop, Parse, A_LoopField, >, % "`t`n`r "


				If ( A_Index = 1 )


					options := ( InStr( A_LoopField, "R" ) ? "RESUME`n" : "SAVEAS`n" )


					, Do_Legacy_Dual_Output := !!InStr( A_LoopField, "N" )


				Else options .= A_LoopField


		}	


		Else IfInString, A_LoopField, :


			StringReplace, options, A_LoopField, :, `n


		Else If InString, A_LoopField, =


			StringReplace, options, A_LoopField, =, `n


		Else options := A_LoopField "`n"


		Loop, Parse, options, `n, % "`t`r "


			If ( A_Index = 1 )


				StringUpper, options, A_LoopField


		; AutoProxy option: use IE's proxy configuration


			Else If ( options = "AUTOPROXY" )


				Internet_Open_Type := !!A_LoopField || A_LoopField = "" ? 0 : 1


		; Binary option: do not attempt to convert downloaded data to the script's codepage.


			Else If ( options = "BINARY" )


				Do_Binary_Down := !!A_LoopField || A_LoopField = ""


		; Callback option: inform a function in the script about the transaction progress


			Else If ( options = "CALLBACK" )


			{


				If ( pos := InStr( A_LoopField, "," ) ) || ( pos := InStr( A_LoopField, ";" ) )


				|| ( pos := InStr( A_LoopField, "`t" ) ) || ( pos := InStr( A_LoopField, " " ) )


				{


					StringLeft, Do_Callback_Func, A_LoopField, pos - 1


					StringTrimLeft, Do_Callback_3rdParam, A_LoopField, pos


					Loop, Parse, Do_Callback_3rdParam, `n, % "`t`r " ; explicit trim


						Do_Callback_3rdParam := A_LoopField


				}


				Else Do_Callback_Func := A_LoopField





				Do_Callback := IsFunc( Do_Callback_Func ) + 3 >> 2 = 1


			}


		; Charset option: convert POST text's codepage before uploading it


			Else If ( options = "CHARSET" )


				Do_NonBinary_Up := !( pos := InStr( Codepage_Charsets, "=" A_LoopField "|" ) ) ? Convert_POST_To_Codepage


				: SubStr( Codepage_Charsets, pos - 5, 5 )


		; CheckMD5 option: use the indicated URL as the proxy server for this request.


			Else If ( options = "CHECKMD5" ) || ( options = "CHECK MD5" )


				Do_Dn_MD5_Hash := 1


		; Codepage option: convert POST text's codepage before uploading it


			Else If ( options = "CODEPAGE" )


				Do_NonBinary_Up := ( A_LoopField | 0 < 1 || A_LoopField >> 16 ) ? Convert_POST_To_Codepage


				: ( Convert_POST_To_Codepage := SubStr( A_LoopField + 100000.0, 2, 5 ) )


		; Flags option: add or remove flags


			Else If InStr( options, "+" ) = 1 || InStr( options, "-" ) = 1


			{


			; When handling flag options, first determine whether the flag is being added or removed.


				StringLeft, flag_plus_or_minus, options, 1


				Loop, Parse, options, +-, % "`t`n`r _" ; explicit trim


					options := A_LoopField





			; For backwards compatibility, support the "+FLAG: <flag id>" syntax.


				If ( options = "FLAG" )


					StringUpper, options, A_LoopField





			; Determine whether the flag is a security flag or a regular flag and get its value


				If ( pos := InStr( internet_flags_list, "|" options "|" ) )


				|| ( pos := InStr( internet_flags_list, "|INTERNET_FLAG_" options "|" ) )


				{


					StringLeft, options, internet_flags_list, pos


					StringReplace, options, options, ., ., UseErrorLevel


					If ( flag_plus_or_minus = "+" )


						Internet_Flags |= 1 << ErrorLevel


					Else Internet_Flags &= ~( 1 << ErrorLevel )


				}


			; Look in the security flags for one with this name (or this short name)


				Else If ( pos := InStr( security_flags_list, "|" options "|" ) )


					|| ( pos := InStr( security_flags_list, "|SECURITY_FLAG_" options "|" ) )


				{


					StringLeft, options, security_flags_list, pos


					StringReplace, options, options, ., ., UseErrorLevel


					If ( flag_plus_or_minus = "+" )


						Security_Flags_Add |= 1 << ErrorLevel


					Else Security_Flags_Nix |= 1 << ErrorLevel


				}


			; If the first letter is an 'S', and the rest is an INT power of 2, it's a security flag


				Else If ( InStr( options, "S" ) = 1 ) && ( 0 < pos := Abs( SubStr( options, 2 ) ) )


					&& ( pos = 1 << Round( Ln( pos ) / Ln(2) ) )


				{


					If ( flag_plus_or_minus = "+" )


						Security_Flags_Add |= pos


					Else Security_Flags_Nix |= pos


				}


			; If it is an INT power of 2, treat it as an internet flag


				Else If ( 0 < pos := Abs( options ) ) && ( pos = 1 << Round( Ln( pos ) / Ln(2) ) )


					If ( flag_plus_or_minus = "+" )


						Internet_Flags |= pos


					Else Internet_Flags &= ~pos


			}


		; Method option: use a different verb when creating the request


			Else If ( options = "METHOD" ) && InStr( "|GET|HEAD|POST|PUT|DELETE|OPTIONS|TRACE|", "|" A_LoopField "|" )


				StringUpper, Method_Verb, A_LoopField


		; Proxy option: use the indicated URL as the proxy server for this request.


			Else If ( options = "PROXY" )


				Internet_Open_Type := 3, proxy_url := A_LoopField


		; Proxy Bypass option: the URL should not beaccessed through the proxy.


			Else If ( options = "PROXY BYPASS" )


				proxy_bypass .= A_LoopField "`r`n"


		; Resume OR SaveAs options: download the data to the hard drive and NOT to memory


			Else If ( options = "RESUME" ) || ( options = "SAVEAS" ) || ( options = "SAVE AS" )


			{


				file_ext := FileExist( output_file_path := A_LoopField )


				If ( file_ext = "" )


				{


				; The file does not exist, so make sure the folder it belong to DOES exist


					If !( pos := InStr( output_file_path, "\", 0, 0 ) )


					|| FileExist( SubStr( output_file_path, 1, pos - 1 ) )


						Do_Download_To_File := 1


					Else MyErrors .= "`nThe file path """ output_file_path """ is not valid. The folder can't be found."


				}


				Else If InStr( file_ext, "D" )


				{


				; The user only gave us a path to a folder. We'll have to figure out the filename from the url


					file_ext := "V://x/E/" url


					SplitPath, file_ext, file_ext


					StringLeft, file_ext, file_ext, InStr( file_ext "?", "?" ) - 1


					output_file_path .= ( SubStr( output_file_path, 0 ) = "\" ? "" : "\" )


					. ( file_ext = "" ? "HTTPRequest " A_Year "-" A_MM "-" A_DD "_" SubStr( A_Now A_MSec, 9 ) ".txt" : file_ext )


				}


				Else


				; The file exists, so the path is OK. Check if the user wants to resume a download.


					If ( options = "RESUME" )


						FileGetSize, Do_Download_Resume, % output_file_path


			}


		; Upload option: use a file on the disk as the data source for the file upload.


			Else If ( options = "UPLOAD" )


			{


				If ( pos := InStr( A_LoopField, "*", 0, 0 ) )


				{


					Upload_File_Path := SubStr( A_LoopField, 1, pos - 1 ) "`n" SubStr( A_LoopField, pos + 1 )


					Loop, Parse, Upload_File_Path, `n, % "`t`r " ; explicit trim


						If ( A_Index = 1 )


							Upload_File_Path := A_LoopField


						Else If ( 0 < 0 | A_LoopField )


							Do_File_Upload := !FileExist( Upload_File_Path ) ? 0 : 0 | 1 + A_LoopField


				}


				Else Do_File_Upload := !FileExist( Upload_File_Path := A_LoopField ) ? 0 : 1





				If ( Do_File_Upload )


				{


					FileGetsize, Content_Length, % Upload_File_Path


;					If ( Content_Length < Do_File_Upload )


;						MyErrors .= "`nThe range specified for the partial file upload is invalid: file size (" Content_Length ") is less than " Do_File_Upload - 1 "."


;					Else If ( 1 < Do_File_Upload )


				 ; NYI: append a '*' then a number to the upload file path to SKIP the first N bytes when uploading.


;						hbuffer .= "Content-Range: bytes " Do_File_Upload - 1 "-" Content_Length - 1 "/" Content_Length "`r`n"


				}


				Else MyErrors .= "`nFile upload failed: the file """ Upload_File_Path """ could not be found."


			}


	}


	StringTrimRight, proxy_bypass, proxy_bypass, 2





; Step 5: copy the POST data from the input variable to a local buffer. This is to protect the data


; from being altered or released during the upload (which may take a while). Also check whether


; the user wants to change the character encoding of text-type data (e.g: from UTF-16 to UTF-8).


; Also, even if we're uploading from a file, 'dbuffsz' must be the number of bytes in the data.


	If ( 0 < Content_Length )


	{


		If ( Do_File_Upload )


		{


		; If we're doing a file upload, do NOT copy the files contents to a buffer yet. DO make


		; sure the content-type header is present.


			VarSetCapacity( dbuffer, 4096, 0 )


			dbuffsz := Content_Length := SubStr( Content_Length + 0.0, 1, 1 + FLOOR( LOG( Content_Length )))


			hbuffer .= "Content-Length: " Content_Length "`r`n"


			IfNotInString, hbuffer, % "`r`nContent-Type: "


			{


				SplitPath, Upload_File_Path,,, file_ext


				hbuffer .= "Content-Type: " ( file_ext = "xml" ? "text/xml"


					: file_ext = "txt" ? "application/x-www-form-urlencoded"


					: "application/octet-stream" ) "`r`n"


			}


		; Add an MD5 hash to the headers if that option is used


			If ( Do_Up_MD5_Hash )


				hbuffer .= "Content-MD5: " HTTPRequest_MD5( hbuffer, Upload_File_Path ) "`r`n"


		}


		Else If !( Do_NonBinary_Up ) || ( Do_NonBinary_Up = MyACP ) || ( Do_Multipart )


		{


		; Either the POST is binary data or is already in the desired encoding, so just copy it.


			VarSetCapacity( dbuffer, dbuffsz := Content_Length, 0 )


			DllCall( "RtlMoveMemory", Ptr, &dbuffer, Ptr, &In_POST__Out_Data, "Int", Content_Length )


			Content_Length := SubStr( Content_Length + 0.0, 1, 1 + FLOOR( LOG( Content_Length )))


			hbuffer .= "Content-Length: " Content_Length "`r`n"


			IfNotInString, hbuffer, % "`r`nContent-Type: "


				hbuffer .= "Content-Type: " ( InStr( dbuffer, "<?xml" ) + 3 >> 2 = 1 ? "text/xml"


					: "application/x-www-form-urlencoded" ) "; charset=" MyCharset


		}


		Else


		{


		; Change the character encoding while copying the POST data into the local buffer.


			IfNotInString, hbuffer, % "`r`nContent-Type: "


			{


				hbuffer .= "Content-Type: " ( InStr( dbuffer, "<?xml" ) + 3 >> 2 = 1 ? "text/xml"


					: "application/x-www-form-urlencoded" )


				If ( 7 != pos := 7 + InStr( Codepage_Charsets, "|" Do_NonBinary_Up "=" ) )


					hbuffer .= "; charset=" SubStr( Codepage_Charsets, pos, InStr( Codepage_Charsets, "|", 0, pos ) - pos )


				hbuffer .= "`r`n"


			}


			If ( IsUnicode )


				pos := &In_POST__Out_Data, rbuffsz := Content_Length >> 1


			Else


			{


			; If this isn't a UTF-16 environment, convert the POST data to UTF-16. rbuffsz = bytes


				If ( 0 < rbuffsz := DllCall( "MultiByteToWideChar", "UInt", MyACP, "UInt", 0, Ptr, &In_POST__Out_Data, "Int", Content_Length, Ptr, 0, "Int", 0 ) )


				{


					VarSetCapacity( rbuffer, rbuffsz + 1 << 1, 0 )


				; MultiByteToWideChar > http://msdn.microsoft.com/en-us/library/dd319072%28v=vs.85%29.aspx


					DllCall( "MultiByteToWideChar", "UInt", MyACP, "UInt", 0, Ptr, &In_POST__Out_Data, "Int", Content_Length, Ptr, pos := &rbuffer, "Int", rbuffsz )


				}


				Else MyErrors .= "`nThere was a problem converting codepage " MyACP " to " Convert_POST_To_Codepage ". 'MultiByteToWideChar' failed: Return value = " rbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


			}


		; Convert the UTF-16 string to a multi-byte string in the chosen codepage


			If ( 0 < rbuffsz ) ; a zero or negative length here indicates a prior error


				If ( 0 < dbuffsz := DllCall( "WideCharToMultiByte", "UInt", Do_NonBinary_Up, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0 ) )


				{


					VarSetCapacity( dbuffer, dbuffsz + 1, 0 )


				; WideCharToMultiByte > http://msdn.microsoft.com/en-us/library/dd374130%28v=vs.85%29.aspx


					DllCall( "WideCharToMultiByte", "UInt", Do_NonBinary_Up, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, &dbuffer, "Int", dbuffsz, Ptr, 0, Ptr, 0 )


					Content_Length := SubStr( dbuffsz + 0.0, 1, 1 + FLOOR( LOG( dbuffsz )))


					hbuffer .= "Content-Length: " Content_Length "`r`n"


				}


				Else MyErrors .= "`nThere was a problem converting codepage " MyACP " to " Convert_POST_To_Codepage ". 'WideCharToMultiByte' failed: Return value = " dbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


			VarSetCapacity( rbuffer, 0 ) ; free this temporary buffer


		; Add an MD5 hash to the headers if that option is used


			If ( Do_Up_MD5_Hash )


				hbuffer .= "Content-MD5: " HTTPRequest_MD5( dbuffer, dbuffsz ) "`r`n"


		}


	; Set up an INTERNET_BUFFERS structure in preparation for calling HttpSendRequestEx


		VarSetCapacity( INTERNET_BUFFERS, 28 + PtrSize * 3, 0 )


		NumPut( 28 + PtrSize * 3, INTERNET_BUFFERS, 0, "Int" )


		NumPut( Content_Length, INTERNET_BUFFERS, 16 + PtrSize * 3, "Int" )


	}





; Update (future): assemble multipart/form-data here by combining the text from 'options' with


; the data the user wants to upload. How it works: the text portion of the multipart data is split


; at the first instance of "<MY DATA GOES HERE>", and the data buffer is expanded to account for the


; length of the data plus the (codepage converted) lengths of the two portions. The, the first


; portion is copied or converted and placed into the front of the data buffer. The data is copied


; to the right of that, and finally, the second portion is copied or converted to the right of that.


/*


	If ( Do_Multipart )


	{


	; The multipart envelope is baked here. The text is split at "<MY DATA GOES HERE>" and the two


	; parts are converted to the desired codepage. When the upload begins, the first chunk(s) begin


	; with the first part of the envelope, and the last chunk(s) end with the second. Doing it


	; piecemeal like this is the simplest way to support disk and memory sources for the data.


	; NOTE: when doing file-uploads WITH multipart/form-data, do NOT cache the file's data, instead


	; modify the first and last chunk to begin and end with the respective parts of the envelope.


	; Store the length of the first part of the envelope in "Do_Multipart"


	; Don't forget to change the Content-Length to the real size of the eventual data.





		StringGetPos, Do_Multipart, Multipart_Envelope, <MY DATA GOES HERE>


	}


*/





; Step  6: Build the pointer array for the accept types string


; The trick to this step is actually leaving all of the accept types in one string, then building


; the pointer array using the address + position of each member, then inserting nulls to make it


; look like a collection of independent null-terminated strings.


; First thing is to replace delimiting commas with newlines (but not quoted literal commas).


	Loop, Parse, Accept_Types, "


		If ( A_Index = 1 )


			StringReplace, Accept_Types, A_LoopField, `,, `n, A


		Else If ( A_Index & 1 )


		{


			StringReplace, Accept_PtrArray, A_LoopField, `,, `n, A


			Accept_Types .= Accept_PtrArray


		}


		Else Accept_Types .= """" A_LoopField """"





; Then trim whitespace around the delimiters and count how many accept-types there are


	Loop, Parse, Accept_Types, `n, % "`t`r "


		If ( 1 = pos := A_Index )


			Accept_Types := A_LoopField


		Else Accept_Types .= "`n" A_LoopField





; Wipe the variable we'll use as the pointer array. The array itself should be null-terminated, so add an extra member.


	VarSetCapacity( Accept_PtrArray, pos * PtrSize + PtrSize, 0 )


	pos := 0


; For each member, put the address + offset into the pointer array, then end it with a null.


	Loop, Parse, Accept_Types, `n


	{


		NumPut( &Accept_Types + pos, Accept_PtrArray, A_Index * PtrSize - PtrSize, Ptr )


		pos += 1 + StrLen( A_LoopField ) << IsUnicode


		NumPut( 0, Accept_Types, pos - 1 - IsUnicode, IsUnicode ? "UShort" : "UChar" )


	}





; Set the default HTTP verb to 'POST' if there is data to upload, 'GET' otherwise.


	Method_Verb := Method_Verb != "" ? Method_Verb : 0 < Content_Length ? "POST" : "GET"


; Trim the leading CRLF from the headers buffer.


	StringTrimLeft, hbuffer, hbuffer, 2





; Do an error check before we load WinINet. If we have errors, don't continue.


; Afterwards, if we encounter errors, don't simply return but continue to the cleanup step.


	If InStr( MyErrors, "`n" )


		Return 0, In_Out_HEADERS := SubStr( MyErrors, 2 ), ErrorLevel := oel


	


; Step 7: Load WinINet.dll and initialize the internet connection and request.


; Kernel32.dll\LoadLibrary > http://msdn.microsoft.com/en-us/library/ms684175%28v=VS.85%29.aspx


	If !( hModule := DllCall( "LoadLibrary" WorA, "Str", "WinINet.dll", Ptr ) )


		MyErrors .= "`nThere was a problem loading WinINet.dll. 'LoadLibrary" WorA "' failed: Return value = " hModule ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





; Initialize WinINet. InternetOpen > http://msdn.microsoft.com/en-us/library/aa385096%28v=VS.85%29.aspx


	Else	If !( hInternet := Internet_Open_Type != 3 ? DllCall( "WinINet\InternetOpen" WorA, Ptr, &Agent, "UInt", Internet_Open_Type, Ptr, 0, Ptr, 0, "UInt", 0, Ptr )


	: DllCall( "WinINet\InternetOpen" WorA, Ptr, &Agent, "UInt", 3, ptr, &proxy_url, Ptr, proxy_bypass = "" ? 0 : &proxy_bypass, "UInt", 0, Ptr ) )


		MyErrors .= "`nThere was a problem initializing WinINet. 'WinINet\InternetOpen" WorA "' failed: Return value = " hInternet ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





; Open a HTTP session. InternetConnect > http://msdn.microsoft.com/en-us/library/aa384363%28v=VS.85%29.aspx


; dwService -> INTERNET_SERVICE_HTTP = 3


	Else If !( hConnection := DllCall( "WinINet\InternetConnect" WorA, Ptr, hInternet, Ptr, &Host, "UInt", Port, Ptr, &User, Ptr, &Pass, "UInt", 3, "UInt", Internet_Flags, "UInt", 0, Ptr ) )


		MyErrors .= "`nThere was a problem opening a HTTP session. 'WinINet\InternetConnect" WorA "' failed: Return value = " hConnection ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





; Create a HTTP request. HttpOpenRequest > http://msdn.microsoft.com/en-us/library/aa384233%28v=VS.85%29.aspx


	Else If !( hRequest := DllCall( "WinINet\HttpOpenRequest" WorA, Ptr, hConnection, Ptr, &Method_Verb, Ptr, &URL, "Str", "HTTP/1.1", Ptr, 0, Ptr, &Accept_PtrArray, "UInt", Internet_Flags, Ptr ) )


		MyErrors .= "`nThere was a problem creating a HTTP request. 'WinINet\HttpOpenRequest" WorA "' failed: Return value = " hRequest ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





; Add headers. HttpAddRequestHeaders > http://msdn.microsoft.com/en-us/library/aa384227%28v=VS.85%29.aspx


; dwModifiers = (HTTP_ADDREQ_FLAG_ADD = 0x20000000) + (HTTP_ADDREQ_FLAG_REPLACE = 0x80000000)


	Else If ( hbuffer != "" ) && !DllCall( "WinINet\HttpAddRequestHeaders" WorA, Ptr, hRequest, Ptr, &hbuffer, "UInt", StrLen( hbuffer ), "UInt", 0xA0000000 )


		MyErrors .= "`nThere was a problem adding one or more headers to the request. 'WinINet\HttpAddRequestHeaders" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`nHeaders: `n" hbuffer





; Update (12-28-2011): Added security flags support. Security flags may be added/removed like normal flags


; InternetQueryOption > http://msdn.microsoft.com/en-us/library/aa385101%28v=VS.85%29.aspx


	Else If ( Security_Flags_Add || Security_Flags_Nix ) && !DllCall( "WinINet\InternetQueryOption" WorA, Ptr, hRequest, "UInt", 31, "UInt*", Security_Flags, "UInt*", 4 )


		MyErrors .= "`nThere was a problem retrieving the security flags. 'WinINet\InternetQueryOption" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





; InternetSetOption > http://msdn.microsoft.com/en-us/library/aa385114%28v=VS.85%29.aspx


	Else If ( Security_Flags_Add || Security_Flags_Nix ) && !DllCall( "WinINet\InternetSetOption" WorA, Ptr, hRequest, "UInt", 31, "UInt*", pos := ( ~Security_Flags_Nix & Security_Flags ) | Security_Flags_Add, "UInt*", 4 )


		MyErrors .= "`nThere was a problem setting the security flags. 'WinINet\InternetSetOption" WorA "' failed: Flags value = " pos ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





; Step 8a: If there is no data to upload, submit the request via HttpSendRequest.


; HttpSendRequest > http://msdn.microsoft.com/en-us/library/aa384247%28v=VS.85%29.aspx


	Else If !( 0 < Content_Length ) && !DllCall( "WinINet\HttpSendRequest" WorA, Ptr, hRequest, Ptr, 0, "UInt", 0, Ptr, 0, "UInt", 0 )


		MyErrors .= "`nThere was a problem sending the " Method_Verb " request. 'WinINet\HttpSendRequest" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





; Step 8b: If there is data to upload, begin submitting the request via HttpSendRequestEx, upload the data


; using InternetWriteFile, then end the request with HttpEndRequest.


; HttpSendRequestEx > http://msdn.microsoft.com/en-us/library/aa384318%28v=VS.85%29.aspx


	Else If ( 0 < Content_Length ) && !DllCall( "WinINet\HttpSendRequestEx" WorA, Ptr, hRequest, Ptr, &INTERNET_BUFFERS, "UInt", 0, Ptr, 0, "UInt", 0 )


		MyErrors .= "`nThere was a problem sending the " Method_Verb " request. 'WinINet\HttpSendRequestEx" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


	Else If ( 0 < Content_Length )


	{


	; Here, we have a connection open to a remote resource and we should write data to it.


	; But first, notfy the callback function that we are about to upload data by passing '-1' to it.


		If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( -1, Content_Length, Do_Callback_3rdParam ) )


			MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. Zero bytes were uploaded."


	; Then, if we're uploading from a file, open the file with GENERIC_READ permission (0x80000000)


		Else	If ( Do_File_Upload ) && !( Do_File_Upload := DllCall( "CreateFile" WorA, Ptr, &Upload_File_Path, "UInt", 0x80000000, "UInt", 0, Ptr, 0, "UInt", 4, "UInt", 0, Ptr, 0, Ptr ) )


			MyErrors .= "`nThere was a problem opening the file to upload """ Upload_File_Path """. 'CreateFile" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


		Else


		{


		; Loop until the size of the data uploaded is equal or greater than the Content-Length.


		; Actually, 'equal to' is the end condition, the 'greater than' is just good programming.


			size := 0 ; 'size' tracks the number of bytes actually uploaded so far.


			Loop


				If ( Content_Length <= size )


					Break


				Else IfInString, MyErrors, `n


					Break


				Else


				{


				; Define the first data chunk of up to 4096 bytes (put the address into 'pos')


				; NOTE: except with multipart data, 'dbuffsz' and 'Content-Length' are equal.


					If ( size < Do_Multipart )


					{


						; Upload the first part of the multipart envelope.


						pos := &rbuffer


						dtsz := Do_Multipart - size < 4096 ? Do_Multipart - size : 4096


					}


					Else If ( Do_Multipart + dbuffsz <= size )


					{


						; Upload the second part of the multipart envelope.


						pos := &rbuffer + Do_Multipart


						dtsz := Content_Length - size < 4096 ? Content_Length - size : 4096


					}


					; ReadFile > http://msdn.microsoft.com/en-us/library/aa365467%28v=VS.85%29.aspx


					Else If ( Do_File_Upload ) && !DllCall( "ReadFile", Ptr, Do_File_Upload, Ptr, pos := &dbuffer, "UInt", dbuffsz - size < 4096 ? dbuffsz - size : 4096, "Int*", dtsz, Ptr, 0 )


					{


						; Upload from a file AND we couldn't read from the file


						MyErrors .= "`nThere was a problem reading from the file """ Upload_File_Path """. 'ReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


						Break


					}


					Else


					{


						; Upload from memory


						pos := &dbuffer + size


						dtsz := dbuffsz - size < 4096 ? dbuffsz - size : 4096


					}





				; Upload the chunk, and then increment 'size' by how many bytes were uploaded.


				; InternetWriteFile > http://msdn.microsoft.com/en-us/library/aa385128%28v=VS.85%29.aspx


					If !DllCall( "WinINet\InternetWriteFile", Ptr, hRequest, Ptr, pos, "UInt", dtsz + 0, "Int*", dtsz )


						MyErrors .= "`nThere was a problem uploading the POST data. 'WinINet\InternetWriteFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


					Else


					{


						size += dtsz


	


					; If we have a callback function, tell it what percent has been uploaded


						If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( size / Content_Length - 1, Content_Length, Do_Callback_3rdParam ) )


							MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. " size " bytes were uploaded."


					}


				}


		; Close the file handle (if the data was uploaded from a file).


		; CloseHandle > http://msdn.microsoft.com/en-us/library/ms724211%28v=vs.85%29.aspx


			If ( Do_File_Upload ) && !DllCall( "CloseHandle", Ptr, Do_File_Upload )


				MyErrors .= "`nThere was a problem closing the file """ Upload_File_Path """. 'CloseHandle' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


		}


		; We're done uploading data, so end the request.


		; HttpEndRequest > http://msdn.microsoft.com/en-us/library/aa384230%28v=VS.85%29.aspx


		DllCall( "WinINet\HttpEndRequest" WorA, Ptr, hRequest, Ptr, 0, "UInt", 0, Ptr, 0 )


	}





; Step 9: Wait until data is available, then get the response headers.


	Content_Length := size := rbuffsz := 0


	If InStr( MyErrors, "`n" )


		hbuffer := ""


	Else


	{


		; InternetQueryDataAvailable > http://msdn.microsoft.com/en-us/library/aa385100%28v=VS.85%29.aspx


		DllCall( "WinINet\InternetQueryDataAvailable", Ptr, hRequest, "Int*", Content_Length, "UInt", 0, Ptr, 0 )





		; Get the response headers separated by CRLF. The first line has the HTTP response code


		; HttpQueryInfo > http://msdn.microsoft.com/en-us/library/aa384238%28v=VS.85%29.aspx


		; HTTP_QUERY_RAW_HEADERS_CRLF = 22. First-try buffer size = 4K


		If VarSetCapacity( hbuffer, hbuffsz := 4096, 0 )


		&& !DllCall( "WinINet\HttpQueryInfo" WorA, Ptr, hRequest, "UInt", 22, Ptr, &hbuffer, "Int*", hbuffsz, Ptr, 0 )


		&& VarSetCapacity( hbuffer, hbuffsz, 0 )


		&& !DllCall( "WinINet\HttpQueryInfo" WorA, Ptr, hRequest, "UInt", 22, Ptr, &hbuffer, "Int*", hbuffsz, Ptr, 0 )


			MyErrors .= "`nThere was a problem reading the response headers. 'WinINet\HttpQueryInfo" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


		Else


		{


			; We've got the response headers, but don't copy them to the output var yet.


			; Replace CRLF with LF, get the response code, and see if there's a Content-Length.


			VarSetCapacity( hbuffer, -1 )


			StringReplace, hbuffer, hbuffer, `r`n, `n, A


			StringMid, Response_Code, hbuffer, InStr( hbuffer, " " ) + 1, 3


			If ( 17 != pos := 17 + InStr( hbuffer, "`nContent-Length: " ) )


				StringMid, Content_Length, hbuffer, pos, InStr( hbuffer, "`n", 0, pos ) - pos


		}


	}





; Step 10: Download the response data


	If ( Content_Length ) && !InStr( MyErrors, "`n" )


	{


	; If we're downloading to a file, try to open the target file with GENERIC_WRITE (0x40000000) permission.


	; CreateFile > http://msdn.microsoft.com/en-us/library/aa363858%28v=vs.85%29.aspx


		If ( Do_Download_To_File ) && !( Do_Download_To_File := DllCall( "CreateFile" WorA, Ptr, &output_file_path, "UInt", 0x40000000, "UInt", 0, Ptr, 0, "UInt", 4, "UInt", 0, Ptr, 0, Ptr ) )


			MyErrors .= "`nThere was a problem opening/creating the output file for writing data: """ output_file_path """. 'CreateFile" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


	; Then, if we're resuming a download, move the write-pointer to the end of the file.


	; SetFilePointerEx > http://msdn.microsoft.com/en-us/library/aa365542%28v=VS.85%29.aspx


		Else If ( Do_Download_Resume ) && !DllCall( "SetFilePointerEx", Ptr, Do_Download_To_File, "Int64", Do_Download_Resume, Ptr, 0, "UInt", 0 )


			MyErrors .= "`nThere was a problem seeking to the end of the output file for resuming the download. 'SetFilePointerEx' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


	; If we have a callback function, inform it that we're about to begin downloading data.


		Else If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( Do_Download_Resume, Content_Length + Do_Download_Resume, Do_Callback_3rdParam ) )


			MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. Zero bytes were downloaded."


		Else


		{


		; Download the response data. Initialize the d-buffer to hold the reported content length plus 4K


			VarSetCapacity( dbuffer, dbuffsz := Do_Download_To_File ? 4096 : 4096 + Content_Length, 0 )


			Loop


				IfInString, MyErrors, `n


					Break


				Else


				{


; Update (1-8-2012): the data downloading loop no longer uses dynamic variables. Instead, if the d-buffer is


; too small, make space in the r-buffer to hold 4K plus the data in the d-buffer and download to the end of the


; r-buffer. If data was downloaded, copy the data from the d-buffer to the r-buffer, expand the d-buffer, and


; copy all of the data (old + new) back to the d-buffer. If ever InternetReadFile fails, or downloads zero


; bytes, that means we're done.





					If ( Do_Download_To_File )


						pos := &dbuffer


					Else If ( size + 4096 < Content_Length )


						pos := &dbuffer + size


					Else


					{


						VarSetCapacity( rbuffer, rbuffsz := size + 4096 + 1, 0 )


						pos := &rbuffer + size


					}





				; Now that the target buffer has been determined, download the next chunk.


				; InternetReadFile > http://msdn.microsoft.com/en-us/library/aa385103%28v=VS.85%29.aspx


					If !DllCall( "WinINet\InternetReadFile", Ptr, hRequest, Ptr, pos, "UInt", 4096, "Int*", dtsz )


						MyErrors .= "`nThere was a problem downoading data. 'WinINet\InternetReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


					Else If !dtsz


					{


						If ( Do_Callback )


							%Do_Callback_Func%( 1, Content_Length + Do_Download_Resume, Do_Callback_3rdParam )


						Break


					}


				; WriteFile > http://msdn.microsoft.com/en-us/library/aa365747%28v=vs.85%29.aspx


					Else If ( Do_Download_To_File ) && !DllCall( "WriteFile", Ptr, Do_Download_To_File, Ptr, pos, "UInt", dtsz, "Int*", 0, Ptr, 0 )


						MyErrors .= "`nThere was a problem writing data to the disk. 'WriteFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


					Else If !( Do_Download_To_File ) && ( size < rbuffsz )


					{


						DllCall( "RtlMoveMemory", Ptr, &rbuffer, Ptr, &dbuffer, "Int", size )


						VarSetCapacity( dbuffer, Content_Length := 4096 + ( size += dtsz ), 0 )


						DllCall( "RtlMoveMemory", Ptr, &dbuffer, Ptr, &rbuffer, "Int", size )


						rbuffsz := 0


					}


					Else size += dtsz





					If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( ( size + Do_Download_Resume ) / ( Content_Length + Do_Download_Resume ), Content_Length + Do_Download_Resume, Do_Callback_3rdParam ) )


						MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. " size " bytes were uploaded."


				}


			If ( Do_Download_To_File )


			{


				If ( Do_Legacy_Dual_Output )


				{


					VarSetCapacity( dbuffer, size + 1, 0 )


					If !DllCall( "ReadFile", Ptr, Do_Download_To_File, Ptr, &dbuffer, "UInt", size, Ptr, 0, Ptr, 0 )


						MyErrors .= "`nThere was a problem reading the file """ output_file_path """. 'ReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





				}


				If !DllCall( "CloseHandle", Ptr, Do_Download_To_File )


					MyErrors .= "`nThere was a problem closing the file """ output_file_path """. 'CloseHandle' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


			}


		}


	}





; Step 11: Close handles, free the dll, and add the MD5 hash check if called for.


; InternetCloseHandle > http://msdn.microsoft.com/en-us/library/aa384350%28v=VS.85%29.aspx


	DllCall( "WinINet\InternetCloseHandle", Ptr, hRequest )


	DllCall( "WinINet\InternetCloseHandle", Ptr, hConnection )


	DllCall( "WinINet\InternetCloseHandle", Ptr, hInternet )


	DllCall( "FreeLibrary", Ptr, hModule )





	If ( Do_Dn_MD5_Hash ) && InStr( hbuffer, "`nContent-MD5: " )


		If ( Do_Download_To_File )


			hbuffer .= "`nComputed-MD5: " HTTPRequest_MD5( rbuffer, output_file_path )


		Else hbuffer .= "`nComputed-MD5: " HTTPRequest_MD5( dbuffer, size )





; Step 12: Copy the response data and headers into the output buffers, respecting the pertinent options.


	If ( size ) && ( !( Do_Download_To_File ) || ( Do_Legacy_Dual_Output ) )


	{


	; First, detect the content type to see whether we CAN treat it like text.


		If ( 15 != pos := 15 + InStr( hbuffer, "`nContent-Type: " ) )


			StringMid, Content_Type, hbuffer, pos, InStr( hbuffer "`n", "`n", 0, pos ) - pos


		Else Content_Type := "text/plain; charset=" MyCharset





	; Extract the charset information, if it's present


		If ( 7 != pos := 7 + InStr( Content_Type, "charset=" ) )


		&& ( pos := InStr( Codepage_Charsets, SubStr( Content_Type, pos


			, InStr( Content_Type ";" , ";", 0, pos ) - pos ) "|" ) )


			StringMid, Convert_POST_To_Codepage, Codepage_Charsets, pos - 5, 5


		Else Convert_POST_To_Codepage := IsUnicode ? "65001" : MyACP





	; Then, determine whether we should convert the data to a different codepage or not.


		StringLeft, Content_Type, Content_Type, InStr( Content_Type ";", ";" ) - 1


		If !( pos := InStr( Content_Type, "text/" ) = 1 )


			Loop, Parse, Text_Content_Subtypes, /


				If ( pos |= 0 < InStr( Content_Type, "/" A_LoopField ) )


					Break





	; So, now we know whether or not to treat the data as text, or as binary


		If ( Do_Binary_Down ) || !( pos ) || ( Convert_POST_To_Codepage = MyACP )


		{


			VarSetCapacity( In_POST__Out_Data, size + 2, 0 )


			DllCall( "RtlMoveMemory", Ptr, &In_POST__Out_Data, Ptr, &dbuffer, "Int", size )


			If ( pos )


				VarSetCapacity( In_POST__Out_Data, -1 )


		}


		Else


		{


		; convert the text data's codepage to whatever codepage the script is using.


			If ( Convert_POST_To_Codepage = "01200" )


			{


			; the downloaded data is in UTF-16 already (I don't know if this ever happens IRL).


				pos := &dbuffer


				rbuffsz := size >> 1


			}


			Else If ( 0 < rbuffsz := DllCall( "MultiByteToWideChar", "UInt", Convert_POST_To_Codepage, "UInt", 0, Ptr, &dbuffer, "Int", size, Ptr, 0, "Int", 0 ) )


			{


				VarSetCapacity( rbuffer, rbuffsz + 1 << 1 )


				DllCall( "MultiByteToWideChar", "UInt", Convert_POST_To_Codepage, "UInt", 0, Ptr, &dbuffer, "Int", size, Ptr, pos := &rbuffer, "Int", rbuffsz )


			}


			Else MyErrors .= "`nThere was a problem converting codepage " Convert_POST_To_Codepage " to " MyACP ". 'MultiByteToWideChar' failed: Return value = " rbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError





			If ( IsUnicode )


			{


				VarSetCapacity( In_POST__Out_Data, rbuffsz + 1 << 1, 0 )


				DllCall( "RtlMoveMemory", Ptr, &In_POST__Out_Data, Ptr, &rbuffer, "Int", rbuffsz << 1 )


				VarSetCapacity( In_POST__Out_Data, -1 )


			}


			Else If ( 0 < rbuffsz ) && ( 0 < dbuffsz := DllCall( "WideCharToMultiByte", "UInt", MyACP, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0 ) )


			{


				VarSetCapacity( In_POST__Out_Data, dbuffsz + 1, 0 )


				DllCall( "WideCharToMultiByte", "UInt", MyACP, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, &In_POST__Out_Data, "Int", dbuffsz, Ptr, 0, Ptr, 0 )


				size := dbuffsz


				VarSetCapacity( In_POST__Out_Data, -1 )


			}


			Else MyErrors .= "`nThere was a problem converting codepage " Convert_POST_To_Codepage " to " MyACP ". 'WideCharToMultiByte' failed: Return value = " dbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError


		}


	}


	; If there was no data downloaded, AND there were no errors so far, clear the data output var.


	Else


		In_POST__Out_Data := ""





	In_Out_HEADERS := SubStr( hbuffer, 1, -1 ) . SubStr( MyErrors, 1 + ( hbuffer = "" ) )


	Return size, dbuffer := "", hbuffer := "", rbuffer := "", ErrorLevel := Response_Code


} ; HTTPRequest( URL, byref In_POST__Out_Data="", byref In_Out_HEADERS="", Options="" ) -----------------------








HTTPRequest_MD5( byref data, length=-1 ) { ; ------------------------------------------------------------------


; Computes the MD5 hash of a data blob of length 'length'. If 'length' is less than zero, this function assumes


; that 'data' is a null-terminated string and determines the length automatically. If length is the path to a


; file, this function returns the  Static variables and constants r[0~63], encoded here as bytes with an offset


; of 64 ( that means the real value is the byte value minus 64, e.g: r[0] = 7, so 7 + 64 = 71 = 'G' )


	Static s, k, pty, u, p:=0, r := "GLQVGLQVGLQVGLQVEINTEINTEINTEINTDKPWDKPWDKPWDKPWFJOUFJOUFJOUFJOU"


	; Initialize the block buffer S and constants p and k[0~63]


	If !( p )


	{


		VarSetCapacity( k, 256 )


		VarSetCapacity( S, 64, 0 )


		u := !!A_IsUnicode


		pty := A_PtrSize = "" ? "UInt" : "Ptr"


		Loop, 64


			NumPut( i := Floor(Abs(Sin(A_Index)) * 0x100000000 ), k, A_Index - 1 << 2, "UInt" )


	}





	If length IS NOT NUMBER


		IfExist, % length ; use file-MD5 mode.


		{


			hFile := DllCall( "CreateFile" ( u ? "W" : "A" ), "Str", length


				, "UInt", 0x80000000 ; GENERIC_READ = 0x80000000


 				, "UInt", 0, pty, 0


				, "UInt", 4 ; OPEN_ALWAYS = 4


				, "UInt", 0, pty, 0, Ptr )


			VarSetCapacity( l, 8 )


			DllCall( "GetFileSizeEx", pty, hFile, pty, &l )


			length := NumGet( l, 0, "Int64" )


		}





	; autodetect message length if it's not specified (or is not positive)


	If Round( length ) < 1


		length := StrLen( dat ) << u





	; initialize running accumulators


	ha := 0x67452301, hb := 0xEFCDAB89, hc := 0x98BADCFE, hd := 0x10325476





	; Begin rolling the message. This loop does 1 iteration for each 64 byte block such that the


	; last block has fewer than 55 bytes in it ( to leave room for the terminator and data length )


	Loop % length + 72 >> 6


	{


		If ( f := length - 64 > ( e := A_Index - 1 << 6 ) ? 64 : length > e ? length - e : 0 )


			If ( hFile )


				DllCall( "ReadFile", pty, hFile, pty, &s, "UInt", f, pty, &l, pty, 0 )


			Else DllCall( "RtlMoveMemory", pty, &s, pty, &data + e, "UInt", f ) ; copy the block


		If ( f != 64 && e <= length ) ; append the terminator to the message


			NumPut( 128, s, f, "UChar" )


		If ( f < 56 )


			Loop 8 ; if this is the real last block, insert the data length in BITS


				NumPut( ( ( length << 3 ) >> ( A_Index - 1 << 3 ) ) & 255, s, 55 + A_Index, "UChar" )





		a := ha, b := hb, c := hc, d := hd ; copy running accumulators to intermediate variables





		Loop 64 ; begin rolling the block. These operations have been condensed and obfuscated.


		{


			e := NumGet( r, ( i := A_Index - 1 ) << u, "UChar" ) & 31


			f := 0 = ( j := i >> 4 ) ? (b&c)|(~b&d) : j=1 ? (d&b)|(~d&c) : j=2 ? b^c^d : c^(~d|b)


			g := &s + (( i * ( 3817 >> j * 3 & 7 ) + ( 328 >> j * 3 & 7 ) & 15 ) << 2 )


			w := (*(g+3) << 24 | *(g+2) << 16 | *(g+1) << 8 | *g) + a + f + NumGet(k,i<<2,"UInt")


			a := d, d := c, c := b, b += w << e | (( w & 0xFFFFFFFF ) >> ( 32 - e ))





		}


		; add the intermediate variables to the running accumlators (making sure to mod by 2**32)


		ha := ha+a&0xFFFFFFFF, hb := hb+b&0xFFFFFFFF, hc := hc+c&0xFFFFFFFF, hd := hd+d&0xFFFFFFFF


		VarSetCapacity( S, 64, 0 ) ; zero the block


	}


	If ( hFile )


		DllCall( "CloseHandle", pty, hFile )


	Loop 32 ; convert the running accumulators into 32 hex digits


		g:=1&(i:=A_Index-1), e:=Chr(97+(i>>3))


		, f:=15&(h%e%>>((!g-g+i&7)<<2)), s.=Chr(48+f+39*(9<f))


	s .= "0000"


	Loop 6


		Loop, % 4+0*(g := Abs("0x" SubStr( s,A_Index*6-5,6)))


			i:=(g>>6*(4-A_Index))&63, s.=i=63 ? "/" : i=62 ? "+" : Chr(i<26 ? i+65 : i<52 ? i+71 : i-4)


	Return SubStr( s, 37, 22 ) "==" ; return the base 64 encoded MD5 hash.


} ; HTTPRequest_MD5( byref data, length=-1 ) ------------------------------------------------------------------





;--------------include: F:\scripts\Autohotkey\Lib\portallib.ahk------------
































portalUrl:="http://portal.hospital-n.local"





;~ portalStatus("http://www.google.com")


;~ portalStatus(url="http://portal.hospital-n.local"){


	;~ try {


		;~ httprequest(url,post,header)


	;~ } catch {


		;~ msgbox test


	;~ }


	;~ msgbox % header


;~ }





#(byref pwb,id){


	return pwb.document.getElementById(id)


}


$(byref dom,id){


	return dom.getElementById(id)


}





/*


function as getElementById(identifier).value


return false if no id match


return "" if value=""





future rewrite: <(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>


*/


get(byref html,identifier,from="id",get="value"){


	dom:=ComObjCreate("HtmlFile")


	


	dom.write(regexreplace(html,"is)(<\/html>).*$","$1"))


		if(from="id"){


			return dom.getElementById(identifier)[get]


		}else if (from="name"){


			return dom.all[identifier][get]


		}


	


}





getText(byref html){


	html:=RegExReplace(html,"[\n\r\t]+","")


	


	html:=regexreplace(html,"\s{2,}<"," <")


	html:=regexreplace(html,">\s{2,}","> ")


	html:=regexreplace(html,">\s+<","><")


	


	html:=RegExReplace(html,"is)<script[^>]*>.*?<\s*\/\s*script\s*>","")





	html:=regexreplace(html,"<[^<>]+>","")


	html:=regexreplace(html,"i)&nbsp;"," ")


	return html


}








getHtmlById(byref html,id,outer=false){


	RegExMatch(html,"is)<([^>\s]+)[^>]*\sid=(?:(?:""" id """)|(?:'" id "')|(?:" id "))[^>]*>(.*?)<\s*\/\s*\1\s*>",match)


	return outer ? match : match2


}





getTextById(byref html,id,trim=true){


	return trim ? trim(s:=getText(getHtmlById(html,id))) : s


}





getHtmlByTagName(byref html,tagName,outer=false){


	arr:=[]


	i:=0


	while i:=regexmatch(html,"is)<" tagName "(?:\s[^>]*)?>(.*?)<\s*\/\s*" tagName "\s*>",match,i+1)


		outer ? arr.push(match) : arr.push(match1)


	return arr


}





getTextByTagName(byref html,tagName,trim=true){


	arr:=getHtmlByTagName(html,tagName)


	arr2:=[]


	for k,v in arr


		trim ? arr2.push(trim(s:=getText(v))) : arr2.push(s)


	return arr2


}





;~ msgbox % getUserName(loginId,"2B4124D6A69E491BB08F47AF9F1D367A")


getUserName(userId,sid){


	if !checkSid(sid)


		return


	global portalUrl


	


	httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx?SESSION=" sid,html:="",header:="")


	


	RegExMatch(header,"ASP.NET_SessionId=(\w+)",match)


	


	


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " match


	


	post:="scrollLeft=&scrollTop=&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&NWeb1%24QueryInPatientPersonAccountControl1%24DropListHosp=T0&NWeb1%24QueryInPatientPersonAccountControl1%24DropListWard=&NWeb1%24QueryInPatientPersonAccountControl1%24SearchDayRangeTextBox=4&NWeb1%24QueryInPatientPersonAccountControl1%24PersonIDInput=&NWeb1%24QueryInPatientPersonAccountControl1%24AccountIDSEInput=&NWeb1%24QueryInPatientPersonAccountControl1%24tbxChartNoInput=&NWeb1%24QueryInPatientPersonAccountControl1%24PatientBasicInfoQueryByName1%24ctl00=&NWeb1%24QueryInPatientPersonAccountControl1%24OperationRoomInput=&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24IDInputTextBox=" getUserId(sid) "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24CheckBoxShowDrMainColumn=on&NWeb1%24QueryInPatientPersonAccountControl1%24ShowIntraReportCheck=on&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24ChartNoTextBox=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24LNameInput=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24FNameInput=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24BirthDayInput=&NWeb1%24QueryInPatientPersonAccountControl1%24HiddenFieldIntraReport=&NWeb1%24Group=BySelectPrint&NWeb1%24ConditionLevelDropList=%23&NWeb1%24DateExecuteSwitchDate%24YearInput=" a_yyyy "&NWeb1%24DateExecuteSwitchDate%24MonthInput" 0+a_mm "&NWeb1%24DateExecuteSwitchDate%24DayInput" 0+a_dd "&NWeb1%24OriginalUserID=&NWeb1%24TransferUserID=&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=" userId "&NWeb1%24QueryDrIDInfoByDrName1%24QueryByID=ID%E6%9F%A5%E5%A7%93%E5%90%8D&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24YearInput=" a_yyyy "&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24MonthInput" 0+a_mm "&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24DayInput" 0+a_dd "&NWeb1%24PrintStartDate%24YearInput=1500&NWeb1%24PrintStartDate%24MonthInput=1&NWeb1%24PrintStartDate%24DayInput=1&NWeb1%24PrintEndDate%24YearInput=" a_yyyy "&NWeb1%24PrintEndDate%24MonthInput" 0+a_mm "&NWeb1%24PrintEndDate%24DayInput" 0+a_dd


	 


	httprequest(url,post,header,"charset: utf-8")


	


	


	


	regexmatch(getTextById(post,"NWeb1_QueryDrIDInfoByDrName1_EmpNoLabel"),"姓名：([^\s　]+)",match)


	return match1


	


	


}





getUserId(sid){


	if !checkSid(sid)


		return


	global portalUrl


	httprequest(portalUrl "/General/Redirect.aspx?SESSION=" sid,page)


	RegExMatch(page,"Portal_UserID=([^\']+)\'",match)


	return match1


}








;~ msgbox % getText(clipboard,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelStatusName")





/*


check if sid valid for portal


return 1 if valid 


return 0 if invalid


*/


;~ checksid("46CB9A66F388CB4568AF5D448DD97223F8")


checkSid(sid){


	global portalUrl


	if !RegExMatch(sid,"i)^[A-Z\d]+$")


		return 0


	httprequest(portalUrl "/General/Redirect.aspx?SESSION=" sid,page)


	return instr(page,sid) ? 1 : 0


}





/*


return valid sid


*/


renewSid(sid,loginId,loginPw){


	if checkSid(sid)


		return sid


	else


		return login(loginId,loginPw)


}





getPortalAspId(){


	global portalUrl, portalAspId


	httprequest(url:=portalUrl "/General/Login.aspx",html:="", header:="")


	,RegExMatch(header,"(?<=ASP.NET_SessionId=)[^;]+", portalAspId)


}





;~ MsgBox % login(loginId, loginPw)


;~ ExitApp


login(loginId,loginPw,HospitalCode=0){


	global portalUrl, portalAspId


	


	httprequest(url:=portalUrl "/General/Login.aspx",html:="", header:="")


	,inputs:=[]


	,inputs[s:="__VIEWSTATE"]:="" get(html,s)


	,inputs[s:="__EVENTVALIDATION"]:="" get(html,s)


	,inputs["txtUserID"]:="" loginId


	,inputs["txtPass"]:="" md5(loginpw)


	,inputs["ddlHospital"]:="T" hospitalCode


	,inputs["rdblQuickMenu"]:="H"


	,RegExMatch(header,"(?<=ASP.NET_SessionId=)[^;]+", portalAspId)


	str=


	for k,v in inputs


	  str.= encodeurl(k) "=" encodeurl(v) "&"


	


	post:=str "imgBtnSubmitNew.x=0&imgBtnSubmitNew.y=0"


	;~ header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://portal/General/Login.aspx`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: portal`nConnection: Close`nPragma: no-cache"


	,header:=""


	


	,httprequest(url,post,header,"charset: utf-8")


	,RegExMatch(post,"i)SESSION=([A-Z\d]+)",match)


	


	return match1 ? match1 : ""


}








logout(sid,portalAspId){


	global portalUrl


	


	httprequest(url:="http://portal.hospital-n.local/General/Redirect.aspx?SESSION=" sid,html:="")


	


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: http://portal.hospital-n.local/General/Redirect.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: portal.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=" getUserId(sid) "&SessionKey=" sid "&LoginPosCode=H&LoginPosCodeIndex=0; ASP.NET_SessionId=" portalAspId


	


	post:="__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&ibtnLogOut.x=63&ibtnLogOut.y=22"


	


	httprequest(url,post,header,"charset: utf-8")


	


	


}











;~ a:=patientBasicInfo(chartNo,"2D0DDD9CDE7E4EB0A33D3FCD04D55718")


patientBasicInfo(chartNo,sid,byref html=""){


	if !checkSid(sid)


		return []


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	if !regexmatch(chartNo,"(\w)\w{5}\d")


		return


	


	if(html=""){


		httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx?QueryBySelf=N&SESSION=" sid,html:="")


		,inputs:=[]


		,inputs[s:="__VIEWSTATE"]:="" get(html,s)


		,inputs[s:="__EVENTVALIDATION"]:="" get(html,s)


		,inputs["NWeb1$PatientBasicInfoQueryByIDAndName1$ctl01"]:="" chartNo


		,inputs["NWeb1$PatientBasicInfoQueryByIDAndName1$ctl09"]:="查詢"


		post=


		for k,v in inputs


			post.= encodeurl(k) "=" encodeurl(v) "&"


		header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " url "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"


		


		httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")


	}else {


		post:=html


	}


	;~ clipboard:=post


	ptInfo:=[]


	,RegExMatch(post,"<[^>]+\sid=""NWeb1_PatAccountListRecord1_PatBasicDescription""[^>]*>([^\(]+)\(([^\,])\,(\d+)\/(\d+)\/(\d+)\,([^\)]+)\)",match)


	,ptInfo.name:=match1


	,ptInfo.gender:=match2


	,ptInfo.birthYear:=match3


	,ptInfo.birthMonth:=match4


	,ptInfo.birthDay:=match5


	,ptInfo.age:=match6


	,ptInfo.personId:=get(post,"NWeb1_PatAccountListRecord1_personidHidden")


	


	if (instr(post,"住院中")||instr(post,"已住院登記")||(trim(txt:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelStatusName"))&&(!instr(txt,"已出院"))))


		ptInfo.ward:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelWardName") " " getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelRoomName") "-" getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelBedName")


	else if s:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewEmergencyContent_ctl02_LabelEmerTempBedID")


		ptInfo.ward:="ER " s


	else if (trim(txt:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewEmergencyContent_ctl02_LabelEmerStatusName"))&&txt!="已離部")


		ptInfo.ward:="ER"


	else


		ptInfo.ward:="OPD"


	return ptInfo


}





patientLabDataRecent(personId,sid){


	if !checkSid(sid)


		return


	


	url:= "http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/ReportResultQuery.aspx?SESSION=" sid "&PatClass=I&PersonID=" personId "&Hosp=T0&DefaultQuery=EMRContent"


	


	httprequest(url,data,header,"charset: utf-8`n+NO_COOKIES")


	arr:=new portalLib_patientLabDataRecent(getHtmlById(data,"TablePatientLabResult"))


	return arr


}











class portalLib_patientLabDataRecent {


	__New(html){


		i:=0,arr:=[]


		while i:=RegExMatch(html,"is)<td>([^<]*)<\/td>",match,i+1) {


			if a_index<10


				continue


			


			if mod(a_index,3)=1


				item:=match1


			else if mod(a_index,3)=2


				value:=match1


			else {


				date:=match1


				arr[item,"" date]:=value


			}


		}


		this.lab:=arr


	}


	


	getValue(labName){


		value:=[]


		for k,v in this.lab {


			if (isobject(labName)) {


				for m,n in labName


					if(k=n)


						for x,y in v


							value.push(array(x,y))


			}else if(k=labName)


				for x,y in v


					value.push(array(x,y))


		}


		return value


	}


	


}




















; http://portal/DigReport/CheckUser_report.asp?'+a[1]+'&myurl=DigReport/Lab/NewQuery.asp'+b


;~ msgbox % patientBasicInfo(chartNo,"EE041FCC02C947A9B7009BE5A6D72444")


;~ msgbox % getText(clipboard,"NWeb1_PatAccountListRecord1_GridViewEmergencyContent_ctl02_LabelEmerTempBedID")





/* ;~ old site is closed on 2012/10/1 


patientLabDataRecent(chartno,sid){


	global portalUrl


	if !checkSid(sid)


		return 


	url:= portalUrl "/DigReport/CheckUser_report.asp?SESSION=" sid "&myurl=DigReport/Lab/NewQuery.asp?chartno=" chartNo


	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: portal`nCookie: chartno=; _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=loginId&SessionKey=MOCK_SESSION_KEY&LoginPosCode=H&LoginPosCodeIndex=0; ASP.NET_SessionId=mock_asp_session_id; ASPSESSIONIDCCRABSBD=MOCK_ASP_SESSION_ID"


	


	httprequest(url,data,header,"charset: utf-8`n+NO_COOKIES")


	return data


}


*/


/* ;~ old site is closed on 2012/10/1 


patientLabDataAll(chartno,sid){


	global portalUrl


	


	if !checkSid(sid)


		return


	


	patientLabDataRecent(chartno,sid)


	


	url:=portalUrl "/DigReport/Lab/NewQuery_notsure.asp"


	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://portal/DigReport/Lab/NewQuery.asp?chartno=" chartno "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: portal`nConnection: Close`nCookie: chartno=; _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=loginId&SessionKey=MOCK_SESSION_KEY&LoginPosCode=H&LoginPosCodeIndex=0; ASP.NET_SessionId=mock_asp_session_id; ASPSESSIONIDCCRABSBD=MOCK_ASP_SESSION_ID"


	


	httprequest(url,data:="",header,"charset: utf-8`n+NO_COOKIES")


	return lab:=new portalLib_parseLabData(data)


	


}


*/











/*


return 0: time out


return 1


*/


waitLoaded(byref pwb,judge="",waitSeconds=30,firstDelay=200){


	sleep % firstDelay


	if !isobject(judge) {


		while pwb.busy {


			if (a_index>waitSeconds*10)


				return 0


			sleep 100


		}


		return 1


	}else{


		while !judge.(pwb) {


			if (a_index>waitSeconds*10)


				return 0


			sleep 100


		}


		return 1


	}


}





IEGet2(Name="",matchMode="1")      ;Retrieve pointer to existing IE window/tab


	{


		Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs" : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )


		


		if(matchMode="1"){


			For Pwb in ComObjCreate( "Shell.Application" ).Windows


				If ( RegExMatch(Pwb.LocationName,"^" Name) && InStr( Pwb.FullName, "iexplore.exe" ))


					Return Pwb


		}else if(matchMode="2"){


			For Pwb in ComObjCreate( "Shell.Application" ).Windows


				If ( instr(Pwb.LocationName,Name) && InStr( Pwb.FullName, "iexplore.exe" ))


					Return Pwb


		}else if(matchMode="3"){


			For Pwb in ComObjCreate( "Shell.Application" ).Windows


				If ( Pwb.LocationName=Name) && InStr( Pwb.FullName, "iexplore.exe" )


					Return Pwb


		}else if(matchMode="RegEx"){


			For Pwb in ComObjCreate( "Shell.Application" ).Windows


			If ( RegExMatch(Pwb.LocationName,Name) && InStr( Pwb.FullName, "iexplore.exe" ))


				Return Pwb


	}


	


	return ""


} 








/*


return array with key=(innerText), value=(id)


*/


labOrderList(byref pwb,divId="NWeb1_OrderSearch1_pnlSearchOrders"){


	arr:=[]


	if instr(pwb.document.getElementById(divId).innerText,"查無醫令")


		return arr


	tr:=pwb.document.getElementById(divId).getElementsByTagName("a")


	


	loop % tr.length


		if RegExMatch(tr[a_index-1].id,"NWeb1_OrderSearch1_dlsOrders_ctl\d+_lbnName")


			arr[tr[a_index-1].innerText]:=tr[a_index-1].id


	


	return arr


}





/*


return array with key=(academic name), value=(business name)


*/


medOrderList(pwb,divId="NWeb1_MedicationDrugSearchBox_pnlControl"){


	arr:=[]


	


	


	


	tr:=pwb.document.getElementById(divId).rows


	


	loop % tr.length-1 {


		name:=tr[a_index].cells[1].innerText


		arr[name,"id"]:=tr[a_index].getElementsByTagName("input")[0].id


		arr[name,"bName"]:=tr[a_index].cells[2].innerText


	}


	


	return arr


}











class portalLib_parseLabDataRegex


{


	__New(html){


		if !html


			return ""


		labTable:=getHtmlByTagName(html,"table")[2]


		labTableRows:=getHtmlByTagName(labTable,"tr")


		lab:=[]


		loop % labTableRows.maxIndex()


		{


			i:=a_index


			labTableRowText:=getText(labTableRows[i])


			if(i=1){


				RegExMatch(labTableRowText,"病歷號:(\w{6}\d)\s+姓名:([^\n]+)(?:先生|小姐)\s+生日:\s民國\s([^\s]+)",match)


				if !match1


					break


				lab.chartNo:="" match1


				lab.name:="" match2


				lab.birthDate:="" match3


				continue


			}


			if (!labTableRowText)


				continue


			if(regexmatch(labTableRowText,"登記\s([^\s]+)\s+([^\s]+)\s+([^\n]+\s+)([^\s]+)\s+No:([^\s]+)\s+(?:詳細資料\s+)?報告\s([^\s]+)\s+([^\s]+)",match)){


				labNo:=match5


				lab[labNo]:=[]


				lab[labNo].registerDate:="" match1


				lab[labNo].registerTime:="" match2


				lab[labNo].sample:="" trim(match3)


				lab[labNo].examRoom:="" match4


				lab[labNo].reportDate:="" match6


				lab[labNo].reportTime:="" match7


				continue


			}


			


			if(instr(labTableRowText,"檢查項目")){


				labNameCol:=labValueCol:=labUnitCol:=labRangeCol:=labInfoCol:=""


				loop % getHtmlByTagName(labTableRows[i],"td").maxIndex() 


				{


					labTableCellText:=getText(getHtmlByTagName(labTableRows[i],"td")[a_index])


					if instr(labTableCellText,"檢查項目")


						labNameCol:=a_index


					else if instr(labTableCellText,"數值")


						labValueCol:=a_index


					else if instr(labTableCellText,"單位")


						labUnitCol:=a_index


					else if instr(labTableCellText,"標準值")


						labRangeCol:=a_index


					else if instr(labTableCellText,"說明")


						labInfoCol:=a_index


				}


				continue


			}


			


			if !labNameCol || !labNo


				continue


			else


			{


				labTableCells:=getHtmlByTagName(labTableRows[i],"td")


				labName:=trim(getText(labTableCells[labNameCol]))


				lab[labNo][labName]:=[]


				if labValueCol


					lab[labNo][labName].value:="" trim(getText(labTableCells[labValueCol]))


				if labUnitCol


					lab[labNo][labName].unit:="" trim(getText(labTableCells[labUnitCol]))


				if labRangeCol


					lab[labNo][labName].range:="" trim(getText(labTableCells[labRangeCol]))


				if labInfoCol


					lab[labNo][labName].info:="" trim(getText(labTableCells[labInfoCol]))


			}


		}


		


		labHxTable:=getHtmlByTagName(html,"table")[3]


		labHxTableRows:=getHtmlByTagName(labHxTable,"tr")


		labHx:=[]


		loop % labHxTableRows.maxIndex()-1


		{


			labHxTableRow:=labHxTableRows[a_index+1]


			labHx[a_index]:=[]


			labHx[a_index].account:="" getText(getHtmlByTagName(labHxTableRow,"td")[2])


			labHx[a_index].ptFrom:="" getText(getHtmlByTagName(labHxTableRow,"td")[3])


			labHx[a_index].earliest:="" getText(getHtmlByTagName(labHxTableRow,"td")[4])


			labHx[a_index].last:="" getText(getHtmlByTagName(labHxTableRow,"td")[5])


			labHx[a_index].newest:="" getText(getHtmlByTagName(labHxTableRow,"td")[6])


			RegExMatch(getHtmlByTagName(labHxTableRow,"td")[2],"href=""([^""]+)""",match)


			labHx[a_index].link:="" match1


			


		}


		


		lab["labHx"]:=labHx


		this.lab:=lab	


	}


	


	


	/* result:


	(index)


		1


			register date and time in format of 100.01.01 00:00


		2


			value


	*/


	getValue(labName,sample="BLOOD"){


		StringUpper,sample,sample


		result:=[]


		for k,v in this.lab


		{


			if k is not number


				continue


			


			if !(v.sample=sample)


				continue


			


			


			for i,j in v


			{


				if !isobject(j)


					continue


				


				if(i=labName)


					result.push(array("" v.registerDate " " v.registerTime,"" j.value))


			}


		}


		


		return result


	}


}





; parse lab data (old website) webpage html into object


/* structure:


name: patient name


chartNo: patient chart no.


birthDate: patient birthday in format of 74.01.01


(labNo): 7 digits of number


	examRoom


	registerDate


	registerTime


	reportDate


	reportTime


	(labName)


		value


		unit


		range


		info


labHx	


	(index)


		account


		earliest


		last


		link


		newest


		ptFrom


		


future rewrite: use regex to parse


*/


class portalLib_parseLabData


{


	__New(html){


		if !html


			return ""


		doc := ComObjCreate("{25336920-03F9-11CF-8FD0-00AA00686F13}")


		doc.write(html)


		labTable:=doc.getElementsByTagName("table")[1]


		labTableRows:=labTable.rows


		lab:=[]


		loop % labTableRows.length


		{


			i:=a_index-1


			labTableRowText:=labTableRows[i].innerText


			if(!i){


				RegExMatch(labTableRowText,"病歷號:(\w{6}\d)\s+姓名:([^\n]+)(?:先生|小姐)\s+生日:\s民國\s([^\s]+)",match)


				if !match1


					break


				lab.chartNo:="" match1


				lab.name:="" match2


				lab.birthDate:="" match3


				continue


			}


			if (!labTableRowText)


				continue


			if(regexmatch(labTableRowText,"登記\s([^\s]+)\s+([^\s]+)\s+([^\n]+\s+)([^\s]+)\s+No:([^\s]+)\s+(?:詳細資料\s+)?報告\s([^\s]+)\s+([^\s]+)",match)){


				labNo:=match5


				lab[labNo]:=[]


				lab[labNo].registerDate:="" match1


				lab[labNo].registerTime:="" match2


				lab[labNo].sample:="" trim(match3)


				lab[labNo].examRoom:="" match4


				lab[labNo].reportDate:="" match6


				lab[labNo].reportTime:="" match7


				continue


			}


			


			if(instr(labTableRowText,"檢查項目")){


				labNameCol:=labValueCol:=labUnitCol:=labRangeCol:=labInfoCol:=""


				loop % labTableRows[i].cells.length 


				{


					labTableCellText:=labTableRows[i].cells[a_index-1].innerText


					if instr(labTableCellText,"檢查項目")


						labNameCol:=a_index-1


					else if instr(labTableCellText,"數值")


						labValueCol:=a_index-1


					else if instr(labTableCellText,"單位")


						labUnitCol:=a_index-1


					else if instr(labTableCellText,"標準值")


						labRangeCol:=a_index-1


					else if instr(labTableCellText,"說明")


						labInfoCol:=a_index-1


				}


				continue


			}


			


			if !labNameCol || !labNo


				continue


			else


			{


				labTableCells:=labTableRows[i].cells


				labName:=trim(labTableCells[labNameCol].innerText)


				lab[labNo][labName]:=[]


				if labValueCol


					lab[labNo][labName].value:="" trim(labTableCells[labValueCol].innerText)


				if labUnitCol


					lab[labNo][labName].unit:="" trim(labTableCells[labUnitCol].innerText)


				if labRangeCol


					lab[labNo][labName].range:="" trim(labTableCells[labRangeCol].innerText)


				if labInfoCol


					lab[labNo][labName].info:="" trim(labTableCells[labInfoCol].innerText)


			}


		}


		


		labHxTable:=doc.getElementsByTagName("table")[2]


		labHxTableRows:=labHxTable.rows


		labHx:=[]


		loop % labHxTableRows.length-1


		{


			labHxTableRow:=labHxTableRows[a_index]


			labHx[a_index]:=[]


			labHx[a_index].account:="" labHxTableRow.cells[1].innerText


			labHx[a_index].ptFrom:="" labHxTableRow.cells[2].innerText


			labHx[a_index].earliest:="" labHxTableRow.cells[3].innerText


			labHx[a_index].last:="" labHxTableRow.cells[4].innerText


			labHx[a_index].newest:="" labHxTableRow.cells[5].innerText


			labHx[a_index].link:="" labHxTableRow.cells[1].getElementsByTagName("a")[0].href


			


		}


		


		lab["labHx"]:=labHx


		this.lab:=lab


		


	}


	


	/* result:


	(index)


		1


			register date and time in format of 100.01.01 00:00


		2


			value


	*/


	getValue(labName,sample="BLOOD"){


		StringUpper,sample,sample


		result:=[]


		for k,v in this.lab


		{


			if k is not number


				continue


			


			if !(v.sample=sample)


				continue


			


			


			for i,j in v


			{


				if !isobject(j)


					continue


				


				if(i=labName)


					result.push(array("" v.registerDate " " v.registerTime,"" j.value))


			}


		}


		


		return result


	}


	


}





MD5( V ) { ; www.autohotkey.com/forum/viewtopic.php?p=376840#376840


 VarSetCapacity( MD5_CTX,104,0 ), DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )


 DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, A_IsUnicode ? "AStr" : "Str",V


 , UInt,StrLen(V) ), DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )


 Loop % StrLen( Hex:="123456789ABCDEF0" )


  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)


stringlower,MD5,md5


return md5


}





EncodeURL( p_data, p_reserved=true, p_encode=true )


{


   old_FormatInteger := A_FormatInteger


   SetFormat, Integer, hex





   unsafe = 


      ( Join LTrim


         25000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F20


         22233C3E5B5C5D5E607B7C7D7F808182838485868788898A8B8C8D8E8F9091929394


         95969798999A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A9AAABACADAEAFB0B1B2B3B4B5B6


         B7B8B9BABBBCBDBEBFC0C1C2C3C4C5C6C7C8C9CACBCCCDCECFD0D1D2D3D4D5D6D7D8


         D9DADBDCDDDEDF7EE0E1E2E3E4E5E6E7E8E9EAEBECEDEEEFF0F1F2F3F4F5F6F7F8F9


         FAFBFCFDFEFF


      )


      


   if ( p_reserved )


      unsafe = %unsafe%24262B2C2F3A3B3D3F40


   


   if ( p_encode )


      loop, % StrLen( unsafe )//2


      {


         StringMid, token, unsafe, A_Index*2-1, 2


         StringReplace, p_data, p_data, % Chr( "0x" token ), `%%token%, all 


      }


   else


      loop, % StrLen( unsafe )//2


      {


         StringMid, token, unsafe, A_Index*2-1, 2


         StringReplace, p_data, p_data, `%%token%, % Chr( "0x" token ), all


      }


      


   SetFormat, Integer, %old_FormatInteger%





   return, p_data


}





DecodeURL( p_data )


{


   return, EncodeURL( p_data, true, false )


}





;~ getLab4New("5______","7B41E7A37F49482D9C79CCEC9C8F8C68")


;~ getLab4New(chartNo,sid,days=90){


	;~ url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?SESSION=" sid "&PatClass=I&WardCode=09B&ChartNo=" chartNo "&HospitalCode=T0&Seed=" a_now "&IntervalDay=-" days


	;~ httprequest(url,html:="","","charset: utf-8")


	;~ clipboard:=html


;~ }





;~ findLab4New(getLab4New("3______","BE164D69C80A490AB37529824EF16D13",20),"T-BIL")


getLab4New(chartNo,sid,days=10){


	global lab4portalAspId


	url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?PatClass=I&WardCode=03C1&ChartNo=" chartNo "&HospitalCode=T0&Seed=" a_now "&IntervalDay=-" days-1 "&SESSION=" sid


	


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; GTB7.5; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nCookie: CK_MedicalReportOpen_PatientQueryCookie=SelectPatListTypeCookieIPatList=&SelectPatListTypeCookieEPatList=&SelectPatListTypeCookieOPatList=&SelectPatListTypeCookieLabPatList=&SelectPatListTypeCookieSpeList=&SelectPatListTypeCookie=IPatList;"


	


	httprequest(url,post:="",header,"charset: utf-8")


	RegExMatch(header,"is).+ASP.NET_SessionId=(\w{24}).+",match)


	lab4portalAspId:=match1


	


	url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?PatClass=I&WardCode=03C1&ChartNo=" chartNo "&HospitalCode=T0&Seed=" a_now "&IntervalDay=-" days-1 "&SESSION=" sid


	


	


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; GTB7.5; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nCookie: CK_MedicalReportOpen_PatientQueryCookie=SelectPatListTypeCookieIPatList=&SelectPatListTypeCookieEPatList=&SelectPatListTypeCookieOPatList=&SelectPatListTypeCookieLabPatList=&SelectPatListTypeCookieSpeList=; ASP.NET_SessionId=" lab4portalAspId


	


	httprequest(url,post:="",header,"charset: utf-8")


	


	dom:=ComObjCreate("HtmlFile")


	dom.write(post)


	return parseLab4New(dom)


}








parseLab4New(byref dom){


	arr:=[]


	loop % (spans:=$(dom,"lReportTab_lsvReportBody_ctrl0_ctl00_LabDetailedSheetControl1_SpanSort").parentNode.childNodes).length-1 {


		specimen:=[]


		span:=spans[a_index]


		


		RegExMatch(text:=span.firstChild.innerText,"isO)([^:\d]+?):(.+?)\s([^:\d]+?):(\d+?)\s(.+)\s([^:\d]+?):(.+?)\s([^:\d]+?):(.+?)\s([^:\d]+?):(.+?)$",match)


		specimen["Info","" trim(match.1)]:=trim(match.2)


		specimen["Info","" trim(match.3)]:=trim(match.4)


		specimen["Info","SpecimenName"]:=trim(match.5)


		specimen["Info","" trim(match.6)]:=trim(match.7)


		specimen["Info","" trim(match.8)]:=trim(match.9)


		specimen["Info","" trim(match.10)]:=trim(match.11)


		


		table:=span.getElementsByTagName("TABLE")[0]


		titles:=[]


		loop % (tds:=table.rows[0].childNodes).length


			titles.push(trim(tds[a_index-1].innerText))


		loop % (trs:=table.childNodes[1].childNodes).length {


			item:=[],i:=a_index


			for k,v in titles


				item["" v]:="" trim(regexreplace(trs[i-1].childNodes[k-1].innerText,"歷$"))


			specimen.push(item.clone())


		}


		arr.push(specimen.clone())


	}


	return arr


}





findLab4New(byref lab,itemName,specimenName="BLOOD"){


	arr:=[],itemNameText:="檢驗項目",sort:=[],foundCount:=0


	for i,specimen in lab


		for k,item in specimen {


			if (k="Info" || !(item[itemNameText]=itemName))


				continue


			


			if (time:=regexreplace(specimen["info","採檢"],"\D")) {


			}else if (time:=regexreplace(specimen["info","登入"],"\D")) {


			}else 


				time:=regexreplace(specimen["info","最後報告"],"\D")


			


			sort[time]:=(++foundCount)


			found:=item.clone()


			for m,n in specimen.Info


				found["" m]:="" n


			arr.push(found.clone())


		}


	


	sortedArr:=[]


	for k,v in sort


		sortedArr[foundCount+1-a_index]:=arr[v].clone()


	return sortedArr


}





searchLab4(chartNo,sid){


	if !checksid(sid)


		return


	


	;~ global portalUrl


	httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?SESSION=" sid,html:="")


	inputs:=[]


	inputs["__LASTFOCUS"]:=""


	inputs["__EVENTTARGET"]:=""


	inputs["__EVENTARGUMENT"]:=""


	inputs[s:="__VIEWSTATE"]:="" get(html,s)


	inputs["__VIEWSTATEENCRYPTED"]:=""


	inputs[s:="__PREVIOUSPAGE"]:="" get(html,s)


	inputs[s:="__EVENTVALIDATION"]:="" get(html,s)


	inputs["hdfDelayedAction"]:=""


	inputs["hdfAction"]:=""


	inputs["hdfSplitted"]:="false"


	inputs["hdfSelectPatientList"]:=""


	inputs["hdfPatientInfoStaus"]:=""


	inputs["CleanCookie"]:="false"


	inputs["HeaderTemplate1$hdfSelectedFilter"]:=""


	inputs["HeaderTemplate1$hdfIsFilterSetModified"]:="False"


	inputs["sltexample4"]:="LabReport"


	inputs["sltexample4"]:="XrayTextReport"


	inputs["sltexample4"]:="UltraSonicReport"


	inputs["sltexample4"]:="ECGReport"


	inputs["sltexample4"]:="CECGReport"


	inputs["sltexample4"]:="TreadmillReport"


	inputs["sltexample4"]:="ABPMReport"


	inputs["sltexample4"]:="LungFunctionReport"


	inputs["sltexample4"]:="ExerciseLungReport"


	inputs["sltexample4"]:="GEEndoScopeReport"


	inputs["sltexample4"]:="EchocardiogramExternalReport"


	inputs["sltexample4"]:="EchocardiogramReport"


	inputs["sltexample4"]:="HolterReport"


	inputs["sltexample4"]:="HealthyCenterReport"


	inputs["sltexample4"]:="PathologyReport"


	inputs["sltexample4"]:="PapTestReport"


	inputs["sltexample4"]:="SLP"


	inputs["sltexample4"]:="UBTReport"


	inputs["sltexample4"]:="UltraSoundReport"


	inputs["sltexample4"]:="EEGReport"


	inputs["sltexample4"]:="ConductionReport"


	inputs["sltexample4"]:="EvokeReport"


	inputs["sltexample4"]:="RTNoteReport"


	inputs["sltexample4"]:="GeneticReport"


	inputs["sltexample4"]:="ChromosomesReport"


	inputs["sltexample4"]:="PEDEEGReport"


	inputs["sltexample4"]:="PEDHEARTSONOReport"


	inputs["sltexample4"]:="01400-4-601266"


	inputs["sltexample4"]:="01400-4-601197"


	inputs["sltexample4"]:="01400-4-601267"


	inputs["sltexample4"]:="01400-4-601431"


	inputs["multiselect_sltReportFilter"]:="LabReport"


	inputs["multiselect_sltReportFilter"]:="XrayTextReport"


	inputs["multiselect_sltReportFilter"]:="UltraSonicReport"


	inputs["multiselect_sltReportFilter"]:="ECGReport"


	inputs["multiselect_sltReportFilter"]:="CECGReport"


	inputs["multiselect_sltReportFilter"]:="TreadmillReport"


	inputs["multiselect_sltReportFilter"]:="ABPMReport"


	inputs["multiselect_sltReportFilter"]:="LungFunctionReport"


	inputs["multiselect_sltReportFilter"]:="ExerciseLungReport"


	inputs["multiselect_sltReportFilter"]:="GEEndoScopeReport"


	inputs["multiselect_sltReportFilter"]:="EchocardiogramExternalReport"


	inputs["multiselect_sltReportFilter"]:="EchocardiogramReport"


	inputs["multiselect_sltReportFilter"]:="HolterReport"


	inputs["multiselect_sltReportFilter"]:="HealthyCenterReport"


	inputs["multiselect_sltReportFilter"]:="PathologyReport"


	inputs["multiselect_sltReportFilter"]:="PapTestReport"


	inputs["multiselect_sltReportFilter"]:="SLP"


	inputs["multiselect_sltReportFilter"]:="UBTReport"


	inputs["multiselect_sltReportFilter"]:="UltraSoundReport"


	inputs["multiselect_sltReportFilter"]:="EEGReport"


	inputs["multiselect_sltReportFilter"]:="ConductionReport"


	inputs["multiselect_sltReportFilter"]:="EvokeReport"


	inputs["multiselect_sltReportFilter"]:="RTNoteReport"


	inputs["multiselect_sltReportFilter"]:="GeneticReport"


	inputs["multiselect_sltReportFilter"]:="ChromosomesReport"


	inputs["multiselect_sltReportFilter"]:="PEDEEGReport"


	inputs["multiselect_sltReportFilter"]:="PEDHEARTSONOReport"


	inputs["multiselect_sltReportFilter"]:="01400-4-601266"


	inputs["multiselect_sltReportFilter"]:="01400-4-601197"


	inputs["multiselect_sltReportFilter"]:="01400-4-601267"


	inputs["multiselect_sltReportFilter"]:="01400-4-601431"


	inputs["q"]:=""


	inputs["HeaderTemplate1$txbIDInput"]:="" chartNo


	inputs["HeaderTemplate1$TextBoxWatermarkExtender1_ClientState"]:=""


	inputs["HeaderTemplate1$btnQueryAction"]:="查詢"


	inputs["PatientListTemplate1$rblPatList"]:="IPatList"


	inputs["PatientListTemplate1$ddlBedHosp"]:="T0"


	inputs["PatientListTemplate1$ddlWard"]:=""


	


	post=


	for k,v in inputs


	  post.= encodeurl(k) "=" encodeurl(v) "&"


	


	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: InPatientWardDefaultQuery=T0|0000|00|; WardListColumnSelect=DR; ASP.NET_SessionId=MOCK_SESSION_ID


	


	httprequest(url,post,header,"charset: utf-8")


	return header "`n`n" post


}





LabIn10Days(chartNo,sid,personId=""){


	if !checksid(sid)


		return


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	if !personId


		personId:=patientBasicInfo(chartNo,sid).personId


	


	seed:=a_now


	


	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" seed "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: portal.hospital-n.local`nConnection: Close`nCookie: _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=" getUserId(sid) "&SessionKey=" sid "&LoginPosCode=H&LoginPosCodeIndex=0"


	


	httprequest("http://portal.hospital-n.local/new_digreport/Lab/NewQuery.asp?result_latest=Y&chartno=" chartNo,post:="",header,"charset: utf-8")


	lab:=new portalLib_patientLabIn10Days(post)


	return lab


}





class portalLib_patientLabIn10Days {


	__New(html){


		i:=0,arr:=[],labNo:=""


		dom:=ComObjCreate("HtmlFile")


		dom.write(html)


		


		


		loop % (tables:=dom.getElementsByTagName("TABLE")).length {


			v:=tables[a_index-1]


			


			if RegExMatch(v.innerText,"[^\s]+\s+([^\n]+)\s+No:(\d+)\s+\(\s+(\d+).(\d+).(\d+)\s+(\d+:\d+)[^\(]+\((\d+).(\d+).(\d+)\s+(\d+:\d+)",match){


				labNo:=match2


				arr["" labNo,"sample"]:="" trim(match1)


				arr["" labNo,"regDate"]:=(match3+1911) match4 match5


				arr["" labNo,"regTime"]:="" match6


				arr["" labNo,"reportDate"]:=(match7+1911) match8 match9


				arr["" labNo,"reportTime"]:="" match10


				


				continue


			}


			


			if !labNo


				continue





			if(v.getElementsByTagName("TABLE").length)


				continue


			


			


			loop % (tr:=v.rows).length {


				if(a_index=1)


					continue


				


				


				if (td:=tr[a_index-1].cells).length<6


					continue


				


				labName:="" trim(td[1].innerText)


				arr["" labNo,"" labName,"value"]:="" trim(td[2].innerText)


				arr["" labNo,"" labName,"unit"]:="" trim(td[3].innerText)


				arr["" labNo,"" labName,"range"]:="" trim(td[4].innerText)


				arr["" labNo,"" labName,"condition"]:="" trim(td[5].innerText)


				


			}


			labNo:=""


			


		}


		


		this.lab:=arr


	}


	


	getValue(byref labName,sample="BLOOD"){


		result:=[]


		StringUpper,sample,sample


		


		for k,v in this.lab {


			if (!isobject(v) || v.sample!=sample)


				continue


			if (isobject(labName))


				for m,n in labName


					if(isobject(v[n]))


						result[v.reportDate]:=v[n]


			else if (isobject(v[labName]))


				result[v.reportDate]:=v[labName]


			


		}


		return result


	}


	


}





/*


StrPutVar(string, ByRef var, encoding)


{


    ; Ensure capacity.


    VarSetCapacity( var, StrPut(string, encoding)


        ; StrPut returns char count, but VarSetCapacity needs bytes.


        * ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) )


    ; Copy or convert the string.


    return StrPut(string, &var, encoding),VarSetCapacity(var,-1)


}


*/





;~ a:=new portalLib_patientLabIn10Days(labin10days("5______","6F7FEA74511B4A84984B2BFB85E17C24"))


;~ msgbox % a["1______","HB","value"]


;~ fileappend,% test,test.txt











patientBasicInfoTree(chartNo,sid,function="",personId=""){


	if !function


		return


	if !checkSid(sid)


		return


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	if !personId


		personId:=patientBasicInfo(chartNo,sid).personId


	


	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now


	header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"


	httprequest(url,page:="",header,"charset: utf-8`n+NO_COOKIES")


	RegExMatch(page,"i)http:[^']+?SimpleInfoShowUsingPlaceHolder[^']+?Func=" function "&[^']+?Seed=\d+",match)


	return (match?RegExReplace(match,"&amp;","&"):"")








}








patientBasicInfoWeb(chartNo,sid,personId="",medicalPrivacy="C5"){


	if !checkSid(sid)


		return


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	if !personId


		personId:=patientBasicInfo(chartNo,sid).personId


	


	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now


	header2:=header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"


	httprequest(url,page:="",header,"charset: utf-8`n+NO_COOKIES")


	


	if(instr(page,"確認非醫療業務執行期間開檔申請")){


		RegExMatch(page,"<form[^>]+action=""[^>]+ReturnPath=(\w+)[^>]+>",match)


		url2:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/MedicalManagementAuthor.aspx?SESSION=" sid "&PersonID=" personId "&ReturnPath=" match1


		header2:="Accept: */*`nAccept-Language: zh-tw`nReferer: " url2 "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"


		post2:="ScriptManager1=UpdatePanelContent%7CConfirmButton&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(page,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(page,"__EVENTVALIDATION")) "&SelectCodeValue=" medicalPrivacy "&RBList=" medicalPrivacy "&OtherReason=&__ASYNCPOST=true&ConfirmButton=%E7%A2%BA%E8%AA%8D%E7%94%B3%E8%AB%8B%E9%96%8B%E6%AA%94"


		httprequest(url2,post2,header2,"charset: utf-8`n+NO_COOKIES")


		;~ regexmatch(post2,"pageRedirect\|\|([^\|]+)\|",match)


		;~ httprequest(match1,page:="",header2,"charset: utf-8`n+NO_COOKIES")


		


		url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now


		header2:=header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"


		httprequest(url,page:="",header,"charset: utf-8`n+NO_COOKIES")





		


		


	}








	return page


}





patientBasicInfoWebTree(html,recursing="",returnClass=1){


	;~ if !IsObject(html) {


		;~ dom:=ComObjCreate("HtmlFile")


		;~ ,dom.write(html)


		;~ ,page:=dom


	;~ }else{


		;~ page:=html.clone()


	;~ }


	


	if(!recursing){


		static dom:=ComObjCreate("HtmlFile")


		dom.write(html)


		,page:=dom.getElementById("TreeViewItemn0Nodes")


	}else{


		page:=dom.getElementById(recursing)


	}


	


	arr:=[]


	Loop % (children:=page.childNodes).length {


		v:=children[A_Index-1]


		if(v.tagName="table"){


			node:=[],a:=v.getElementsByTagName("a"),a:=a[a.length-1]


			node.innerText:=Trim(a.innerText)


			node.id:=a.id


			node.href:="" a.href


			if(v.nextSibling.tagName!="div"){


				arr.push(node)


			}


		}else if(v.tagName="div"){


			


			node.childNodes:=patientBasicInfoWebTree(html, v.id)


			arr.push(node)


		}


	}


	if (returnClass && !recursing){


		return new portalLib_patientBasicInfoWebTree(arr)


	}else


		return arr


	


}





class portalLib_patientBasicInfoWebTree {


	__New(ByRef arr){


		this.arr:=arr


	}


	


	getNodeByNames(params*){


		thisNode:=this.arr


		for k,v in params {


			found:=0


			for m,n in thisNode {


				if (n.innerText=v){


					thisNode:=n.childNodes, found:=1


					break


				}


			}


			if(!found)


				return []


		}


		


		return new portalLib_patientBasicInfoWebTree(thisNode)


	}


}











patientBriefMedicalRecord(chartNo,sid,personId=""){


	if !checkSid(sid)


		return


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	if !personId


		personId:=patientBasicInfo(chartNo,sid).personId


	


	url:=patientBasicInfoTree(chartNo,sid,"PatientBriefMedicalRecord",personId)


	httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")


	arr:=[]


	RegExMatch(page,"體重:([.\d]+)",match)


	arr["BW"]:="" (match1?"" match1:"")


	RegExMatch(page,"身高:([.\d]+)",match)


	arr["BH"]:="" (match1?"" match1:"")


	


	return arr


	


	


}





;~ a:=patientBWBH("4______","B631ABFB65014E259ED4C30B4D5EDCEE")


patientBWBH(chartNo,sid,personId=""){


	if !checkSid(sid)


		return


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	if !personId


		personId:=patientBasicInfo(chartNo,sid).personId


	


	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientBasicExaminationInfo.aspx?SESSION=" sid "&PersonID=" personId "&Hosp=T0&PatClass=E"


	httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")


	arr:=[]


	arr["BH"]:="" regexreplace(getTextById(page,"TextBoxInputArea_ctl00_Label1"),"i)上次記錄 : ([\d.]+|nil|NA)","$1")


	arr["BW"]:="" regexreplace(getTextById(page,"TextBoxInputArea_ctl01_Label1"),"i)上次記錄 : ([\d.]+|nil|NA)","$1")


	arr["UpdateDate"]:="" RegExReplace(getTextById(page,"ErrorMessage"),"is).+?([\d\/]+).*?","$1")


	return arr


}





;~ k:=patientLabHistory(chartNo,"850F789FB5444D5990EA80650603459F")


;~ k.getValue("TSH")





patientLabHistory(chartNo,sid,personId=""){


	if !checkSid(sid)


		return


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	if !personId


		personId:=patientBasicInfo(chartNo,sid).personId


	


	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&PersonID=" personId "&Func=LabResultHistory&Seed=" a_now


	httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")


	


	return o:=new portalLib_patientLabHistory(page)


	


	


}





fill0(str,n=2,fill="0"){


	while strlen(str)<n


		str:=fill str


	


	return str


}





;~ getRisSchedule("F568CE2492064B999D3979B690657BD4","","CHCT","2013/03/04")


;~ html:=getRisPatientMainPage("F568CE2492064B999D3979B690657BD4",11)


;~ a:=parseRisPatientMainPage(html)


parseRisPatientMainPage(html){


	arr:=[]


	


	html:=RegExReplace(html,"is)<input type=""hidden"" name=""__VIEWSTATE"" id=""__VIEWSTATE"" value="".+?"" \/>")


	


	dom:=comobjcreate("HtmlFile")


	dom.write(html)


	


	arr["OrderName"]:=$(html,"NWeb1_OrderScheduleInfo1_OrderNameLabel").innerText


	arr["CreatePersonName"]:=$(html,"NWeb1_OrderScheduleInfo1_lblCreateName").innerText


	arr["AccountNo"]:=$(html,"NWeb1_OrderScheduleInfo1_lblAccountNo").innerText


	arr["SheetNo"]:=$(html,"NWeb1_OrderScheduleInfo1_RequestSheetLabel").innerText


	arr["OrderStatus"]:=$(html,"NWeb1_OrderScheduleInfo1_OrderStatusLabel").innerText


	arr["ConfirmPersonName"]:=$(html,"NWeb1_OrderScheduleInfo1_LabelConfirmEmp").innerText


	arr["OrderTime"]:=$(html,"NWeb1_OrderScheduleInfo1_lblCreateDateTime").title


	arr["RegisterTime"]:=$(html,"NWeb1_OrderScheduleInfo1_RegisterTimeLabel").title


	arr["LoginTime"]:=$(html,"NWeb1_OrderScheduleInfo1_LoginDateTimeLabel").title


	arr["NotPerformReason"]:=$(html,"NWeb1_OrderScheduleInfo1_NotPerformReasonList").value


	arr["SpecialInstruction"]:=$(html,"NWeb1_OrderScheduleInfo1_SpecialInstructionLabel").innerText


	arr["ExecuteDr"]:=$(html,"NWeb1_OrderScheduleInfo1_ExecuteDrListLabel").innerText


	arr["CCC"]:=$(html,"NWeb1_OrderScheduleInfo1_lblExecuteCCC").innerText


	arr["ReportDr"]:=$(html,"NWeb1_OrderScheduleInfo1_ReportDrListLabel").innerText


	arr["Technician"]:=$(html,"NWeb1_OrderScheduleInfo1_TechnicianList").innerText


	arr["Machine"]:=$(html,"NWeb1_OrderScheduleInfo1_ExecuteMachineList").innerText


	arr["ExecuteRecord"]:=$(html,"NWeb1_OrderScheduleInfo1_ExcuteRecordInfo").innerText


	arr["ReportTime"]:=$(html,"NWeb1_OrderScheduleInfo1_txbReportDateTime").value


	arr["ShouldPayAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblShouldPayAmount").innerText


	arr["PaidAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblPaidAmount").innerText


	arr["NeedToPayAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblNeedToPayAmount").innerText


	arr["LastPaidDate"]:=$(html,"NWeb1_OrderScheduleInfo1_lblLastPaidDate").innerText


	arr["LastPaidDate"]:=$(html,"NWeb1_OrderScheduleInfo1_lblLastPaidDate").innerText


	


	loop % (tr:=$(html,"NWeb1_AppendCreateOrders1_grvTreOrders").rows).length {


		arr["CreateOrders",a_index,"class"]:=(td:=tr[a_index+1].cells)[2].innerText


		arr["CreateOrders",a_index,"code"]:=td[3].innerText


		arr["CreateOrders",a_index,"name"]:=td[4].innerText


		arr["CreateOrders",a_index,"amount"]:=td[5].innerText


		arr["CreateOrders",a_index,"ifEmergent"]:=td[6].innerText


		arr["CreateOrders",a_index,"accountType"]:=td[7].innerText


		arr["CreateOrders",a_index,"executeTime"]:=td[8].innerText


	}


	


	return arr


	


	


}





;~ getAccountIdFromAccNo("B728452E2D45454E8E527099157D5648","T__________")


getAccountIdFromAccNo(sid, AccNo){


	global __VIEWSTATE,__EVENTVALIDATION,portalAspId


	


	


	url:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid


	


	if (__VIEWSTATE="" || __EVENTVALIDATION="" || portalAspId=""){


		httprequest(url, post:="",header:="", "charset: utf-8")


		RegExMatch(header,"i)(?<=ASP.NET_SessionId=)\w+",portalAspId)


		renewPortalState(post)


	}


	


	


	StartDate:=substr(a_now,1,4) "/" substr(a_now,5,2) "/" substr(a_now,7,2)





	header=


	(LTrim


	Accept: */*


	Accept-Language: zh-tw


	Referer: %url%


	Host: hisaw.hospital-n.local


	Cookie: 3=1; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y&IsShowBarCode=N; ASP.NET_SessionId=%portalAspId%; JSESSIONID=null


	Connection: Keep-Alive


	x-microsoftajax: Delta=true


	Content-Type: application/x-www-form-urlencoded; charset=utf-8


	Cache-Control: no-cache


	Accept-Encoding: gzip, deflate


	User-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322; .NET4.0C; .NET4.0E)


	Pragma: no-cache


	)


	post:="NWeb1%24ScriptManager1=NWeb1%24uPnlQuery%7CNWeb1%24btnQueryByPatient&scrollLeft=&scrollTop=&__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__VIEWSTATEGENERATOR=377EE134&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=BDE1&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=&NWeb1%24ddlPatClass=&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=1&NWeb1%24txbRequestSheetNo=" AccNo "&NWeb1%24txbPersonID=&NWeb1%24txbAccountNo=&NWeb1%24txbChartNo=&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&__ASYNCPOST=true&NWeb1%24btnQueryByPatient=%E7%97%85%E4%BA%BA%E6%9F%A5%E8%A9%A2"


	;~ clipboard:=post


	httprequest(url, post, header1:=header, "charset: utf-8")


	if !instr(post,AccNo)


		return -1


	


	


	renewPortalState(post)


	post:="NWeb1%24ScriptManager1=NWeb1%24uPnlOrders%7CNWeb1%24grvPatientOrderList%24ctl02%24lbnSelect&scrollLeft=&scrollTop=&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=BDE1&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=&NWeb1%24ddlPatClass=&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=1&NWeb1%24txbRequestSheetNo=" AccNo "&NWeb1%24txbPersonID=&NWeb1%24txbAccountNo=&NWeb1%24txbChartNo=&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&NWeb1%24txbExecuteDate=" encodeurl(StartDate) " " substr(a_now,9,2) "%3A" substr(a_now,11,2) "&NWeb1%24ddlNotPerformReasonList=&NWeb1%24ddlFunctionType=&NWeb1%24ddlFunctionType2=&__LASTFOCUS=&__EVENTTARGET=NWeb1%24grvPatientOrderList%24ctl02%24lbnSelect&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION="  encodeurl(__EVENTVALIDATION) "&__AjaxControlToolkitCalendarCssLoaded=&__ASYNCPOST=true&"


	httprequest(url,post,header1:=header,"charset: utf-8")


	


	if !instr(post,"pageRedirect")


		return -1


	


	url:="http://hisaw.hospital-n.local/WebApplication/Radiology/PatientMainPage.aspx?SESSION=" sid


	


	httprequest(url,post:="",header,"charset: utf-8")


	


	if !instr(post,AccNo)


		return -1


	


	dom:=comobjcreate("HtmlFile")


	dom.write(post)


	


	return dom.getElementById("NWeb1_OrderScheduleInfo1_lblAccountNo").innerText


}





renewPortalState(post){


	global __VIEWSTATE,__EVENTVALIDATION,__VIEWSTATEGENERATOR


	if !VIEWSTATE:=get(post,"__VIEWSTATE")


		regexmatch(post,"i)(?<=__VIEWSTATE\|)[^\|]+",VIEWSTATE)


	if (VIEWSTATE!="")


		__VIEWSTATE:=VIEWSTATE


		


	if !EVENTVALIDATION:=get(post,"__EVENTVALIDATION")


		regexmatch(post,"i)(?<=__EVENTVALIDATION\|)[^\|]+",EVENTVALIDATION)


	if (EVENTVALIDATION!="")


		__EVENTVALIDATION:=EVENTVALIDATION


	


	if !VIEWSTATEGENERATOR:=get(post,"__VIEWSTATEGENERATOR")


		regexmatch(post,"i)(?<=__VIEWSTATEGENERATOR\|)[^\|]+",VIEWSTATEGENERATOR)


	if (VIEWSTATEGENERATOR!="")


		__VIEWSTATEGENERATOR:=VIEWSTATEGENERATOR


}





addPortalState(post){


	global __VIEWSTATE,__EVENTVALIDATION,__VIEWSTATEGENERATOR


	if !InStr(post, "__VIEWSTATE")


		post.=(post=""?"":"&") "__VIEWSTATE=" encodeurl(__VIEWSTATE)


	if !InStr(post, "__EVENTVALIDATION")


		post.=(post=""?"":"&") "__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION)


	if !InStr(post, "__VIEWSTATEGENERATOR")


		post.=(post=""?"":"&") "__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR)


	return post


}





getRisPatientMainPage(sid,which="",ChartNo="",UnitList="X",StartDate="",ShiftType="",PatClass="",QueryDays=1,SheetNo="",PersonID="",AccountNo=""){


	global __VIEWSTATE,__EVENTVALIDATION,portalAspId


	if portalAspId=


		portalAspId=3aq1hx55dvooyqyzlp0nod22


	


	if which=


		which:="02"


	else


		which:=fill0(which+1)


	


	if (StartDate="")


		StartDate:=substr(a_now,1,4) "/" substr(a_now,5,2) "/" substr(a_now,7,2)





	


	


	url:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid


	


	if (__VIEWSTATE="" || __EVENTVALIDATION=""){


		header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/Default.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"





		httprequest(url,post:="",header,"charset: utf-8")


		


		__VIEWSTATE:=get(post,"__VIEWSTATE")


		__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")


	}





	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"


	


	post:="NWeb1%24ScriptManager1=NWeb1%24uPnlOrders%7CNWeb1%24grvPatientOrderList%24ctl" which "%24lbnSelect&scrollLeft=0&scrollTop=99&__LASTFOCUS=&__EVENTTARGET=NWeb1%24grvPatientOrderList%24ctl" which "%24lbnSelect&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=CHCT&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=&NWeb1%24ddlPatClass=&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=1&NWeb1%24txbRequestSheetNo=&NWeb1%24txbPersonID=&NWeb1%24txbAccountNo=&NWeb1%24txbChartNo=&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&NWeb1%24txbExecuteDate=" encodeurl(StartDate) " " substr(a_now,9,2) "%3A" substr(a_now,11,2) "&NWeb1%24ddlNotPerformReasonList=&NWeb1%24ddlFunctionType=&NWeb1%24grvPatientOrderList%24ctl" which "%24cbxSelect=on&NWeb1%24ddlFunctionType2=&__ASYNCPOST=true&"


	


	httprequest(url,post,header,"charset: utf-8")


	


	


	


	url:="http://hisaw.hospital-n.local/WebApplication/Radiology/PatientMainPage.aspx?SESSION=" sid


	


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"


	


	httprequest(url,post:="",header,"charset: utf-8")


	


	return post


	


}


;~ comobjerror(false)


;~ a:=getRisSchedule("5B30E0DF6ACE41C8B7EE837E989C9E93","5______")


;~ b:=new portalLib_parseRisSchedule(a)


;~ d:=b.query([["Date","2015/04/13"]])


;~ c:=1


class portalLib_parseRisSchedule{





	__New(html){


		arr:=[]


		dom:=comobjcreate("HtmlFile")


		dom.write(html)


		


		table:=$(dom,"NWeb1_grvPatientOrderList")


		loop % table.rows.length-1 {


			row:=table.rows[a_index]


			exam:=[]


			exam.Date:=trim(row.cells[2].firstChild.title)


			exam.Shift:=trim(row.cells[3].innerText)


			exam.ExamOrder:=trim(row.cells[4].innerText)


			exam.ChartNo:=trim(row.cells[5].innerText)


			exam.Name:=trim(row.cells[6].innerText)


			exam.IdBirth:=trim(row.cells[6].firstChild.title)


			exam.Gender:=trim(row.cells[7].innerText)


			exam.Dept:=trim(row.cells[8].innerText)


			exam.Dept1:=trim(row.cells[8].firstChild.title)


			exam.BillType:=trim(row.cells[9].innerText)


			exam.OrderName:=trim(row.cells[10].innerText)


			exam.SheetNo:=trim(row.cells[10].firstChild.title)


			exam.Status:=trim(row.cells[11].innerText)


			exam.AccountStatus:=trim(row.cells[12].innerText)


			exam.ArriveTime:=trim(row.cells[13].innerText)


			exam.Emergent:=trim(row.cells[14].innerText)


			exam.Portable:=trim(row.cells[15].innerText)


			arr.push(exam.clone())


		}


			


		this.schedule:=arr


	}


	


	filter(byref exam,filterName,filterValue,fitType=0){


		if instr(exam.Status,"刪除")


			return 0


		if(fitType=1)


			return exam[filterName]=trim(filterValue)?1:0


		else if(fitType=0 || fitType="")


			return instr(exam[filterName],trim(filterValue))?1:0


		else if(fitType=2)


			return regexmatch(exam[filterName],trim(filterValue))?1:0


	}


	


	query(param){


		arr:=[]


		


		for k,v in this.schedule {


			match:=true


			for x,y in param


				if !(match:=match && this.filter(v,y.1,y.2,y.3))


					break


			if match


				arr.push(v.clone())


		}


		return arr


	}


	


}





getRisSchedule(sid,ChartNo="",UnitList="CTE1",StartDate="",ShiftType="",PatClass="",QueryDays=1,SheetNo="",PersonID="",AccountNo=""){


	global __VIEWSTATE,__EVENTVALIDATION,portalAspId


	


	;~ if portalAspId=


		;~ portalAspId=3aq1hx55dvooyqyzlp0nod22


		


	loop % 7-strlen(chartNo)


		chartNo:="0" chartNo


	


	url:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid


	


	


	if (__VIEWSTATE="" || __EVENTVALIDATION="" || !portalAspId){


		;~ header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/Default.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"





		httprequest(url,post:="",header,"charset: utf-8")


		portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")


		__VIEWSTATE:=get(post,"__VIEWSTATE")


		__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")


	}


	


	


	


	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"


	


	if (StartDate="")


		formattime,StartDate,% a_now,yyyy/MM/dd


		;~ StartDate:=substr(a_now,1,4) "/" substr(a_now,5,2) "/" substr(a_now,7,2)


	


	queryType:="NWeb1$uPnlQuery"


	


	if chartNo!=


		queryType.="|NWeb1$btnQueryByPatient"


	if UnitList!=X


		queryType.="|NWeb1$ddlUnitList"


	


	formattime,now,% a_now,yyyy/MM/dd hh:mm


	


	;~ post:="NWeb1%24ScriptManager1=" queryType "&scrollLeft=&scrollTop=&__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=" encodeurl(UnitList) "&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=" encodeurl(ShiftType) "&NWeb1%24ddlPatClass=" encodeurl(PatClass) "&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=" encodeurl(QueryDays) "&NWeb1%24txbRequestSheetNo=" encodeurl(SheetNo) "&NWeb1%24txbPersonID=" encodeurl(PersonID) "&NWeb1%24txbAccountNo=" encodeurl(AccountNo) "&NWeb1%24txbChartNo=" encodeurl(ChartNo) "&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&__ASYNCPOST=true&NWeb1%24cbxIsShowChartNo=on&NWeb1%24ddlFunctionType=&NWeb1%24ddlFunctionType2=&NWeb1%24ddlNotPerformReasonList=&NWeb1%24txbExecuteDate=" encodeurl(now) "&__AjaxControlToolkitCalendarCssLoaded="


	post:="NWeb1%24ScriptManager1=" encodeurl(queryType) "&scrollLeft=&scrollTop=&__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=" encodeurl(UnitList) "&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=" encodeurl(ShiftType) "&NWeb1%24ddlPatClass=" encodeurl(PatClass) "&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=" encodeurl(QueryDays) "&NWeb1%24txbRequestSheetNo=" encodeurl(SheetNo) "&NWeb1%24txbPersonID=" encodeurl(PersonID) "&NWeb1%24txbAccountNo=" encodeurl(AccountNo) "&NWeb1%24txbChartNo=" encodeurl(ChartNo) "&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&__ASYNCPOST=true"





	if chartNo!=


		post.="&NWeb1%24btnQueryByPatient=%E6%8E%92%E7%A8%8B%E6%9F%A5%E8%A9%A2"





	httprequest(url,post,header,"charset: utf-8")


	return post


}








class portalLib_patientLabHistory {


	__New(html){


		arr:=[]


		,ComObjError(false)


		,dom:=ComObjCreate("HtmlFile")


		,dom.write(html)


		


		loop % (tr:=dom.getElementById("TableLabHistoryNote").rows).length {


			if (td:=tr[a_index-1].cells).length <=1


				continue


			labName:=td[1].innerText


			


			ind=0


			loop % (i:=td[2].cells).length {


				if(ind:=!ind){


					RegExMatch(i[a_index-1].innerText,"is)(.+)\s([^\s]+?)$",match)


					,labValue:=match1


					,labUnit:=match2


				}else{


					labDate:=i[a_index-1].innerText


					if !isobject(arr["" labName,"" labDate]) 


						arr["" labName,"" labDate]:=[]


					arr["" labName,"" labDate].push(array("" labValue,"" labUnit))


				}


			}	


			


		}


		


		


		this.lab:=arr


	}


	


	getValue(labName){


		result:=[]


		if(!isobject(this.lab[labName]))


			return result


		


		for k,v in this.lab[labName] 


			result[k]:=v


		return result


	}


	


}





getPathoAspId(sid){


	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/MedicalReportQuery/PathExam.aspx?SESSION=" sid


	


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Keep-Alive`nHost: ihisaw.hospital-n.local`nCookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y&%u5831%u544a%u67e5%u8a62=Y"


	


		


	httprequest(url,post:="",header)


	


	RegExMatch(header,"ASP.NET_SessionId=(\w{24})",match)


	


	return match1


}





;~ getPatho("97CDB02E597943BFAC35E57968A1354E","5______")


getPatho(sid,chartNo){


	global pathoportalAspId


	


	if !pathoportalAspId


		pathoportalAspId:=getPathoAspId(sid)


		


	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/MedicalReportQuery/PathExam.aspx"


	


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: " url "?`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y&%u5831%u544a%u67e5%u8a62=Y; ASP.NET_SessionId=" pathoportalAspId ";"


	


	httprequest(url "?SESSION=" sid,html:="",h:=header)


	


	


	post:="__EVENTTARGET=&__EVENTARGUMENT=&ctl07_ExpandState=eununnunnnnununnunnunnnnnununnunnn&ctl07_SelectedNode=&ctl07_PopulateLog=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&QueryByChartNo1%24txbPatChar=" chartNo "&QueryByChartNo1%24btnPerIDPatChar=%E6%9F%A5%E8%A9%A2"


	


	httprequest(url,post,header,"charset: utf-8")


	


	dom:=ComObjCreate("HtmlFile")


	dom.write(post)


	arr:=[]


	


	loop % (rows:=dom.getElementById("PathExam_Control1_GridViewPathExamno").rows).length


	{


		if a_index=1


			continue


		cells:=rows[i:=a_index-1].cells


		arr[i,"Name"]:=trim(cells[0].innerText)


		arr[i,"PathoNo"]:=trim(cells[1].innerText)


		arr[i,"Department"]:=trim(cells[2].innerText)


		arr[i,"Ward"]:=trim(cells[3].innerText)


		arr[i,"Specimen"]:=trim(cells[4].innerText)


		arr[i,"getDate"]:="" trim(convertTaiwanDateToWestern(cells[5].innerText))


		arr[i,"reportDate"]:="" trim(convertTaiwanDateToWestern(cells[6].innerText))


		arr[i,"linkId"]:=trim(cells[7].firstChild.id)


		


	}


	


	return arr


	


}





;~ arr:=getPatho2("3______")


;~ a=1


getPatho2(chartNo){


	url:="http://converws.hospital-n.local/WebApplication/PathologyReportWS/PathologyReportWS.asmx"





	header:="SOAPAction: ""http://PathologyReportWS.hospital-n.local/GetPathReportListByChartNo""`nHost: converws.hospital-n.local`nContent-Type: text/xml; charset=utf-8"





	post=


	(


	<?xml version="1.0" encoding="utf-8"?>


	<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">


	  <soap:Body>


		<GetPathReportListByChartNo xmlns="http://PathologyReportWS.hospital-n.local/">


		  <chartNo>%chartNo%</chartNo>


		</GetPathReportListByChartNo>


	  </soap:Body>


	</soap:Envelope>


	)





	httprequest(url,post,header,"charset: utf-8")


	


	;~ try


		;~ res:=new XML(clipboard:=post)


	;~ catch e


		;~ return []


	


	


	


	


	i:=0,arr:=[]


	while (i:=regexmatch(post,"is)<Table.+?<PATHCODE>(.+?)</PATHCODE><CHARTNO>" chartNo "</CHARTNO><SPECIMENGETDATE>(.+?)</SPECIMENGETDATE><REPORTDATETIME>(.+?)</REPORTDATETIME><ORGSOURCE>(.+?)</ORGSOURCE>(?:<CHECKREPORT>(.+?)</CHECKREPORT>)?</Table>",match,i+1)) {


		arr[a_index,"" "pathCode"]:="" match1


		arr[a_index,"" "getDate"]:="" dateTimeParse1(match2).str


		arr[a_index,"" "reportDate"]:="" dateTimeParse1(match3).str


		arr[a_index,"" "resource"]:="" match4


		arr[a_index,"" "report"]:="" match5


	}


	return arr


}





getLabValue(byref Lab2Arr,ItemName,SpecimenName="BLOOD"){


	arr:=[],sort:=[],newArr:=[],foundCount:=0





		if(isobject(ItemName)){


			for k,v in Lab2Arr


				for m,n in ItemName


					if (v.ItemName=n && v.SpecimenName=SpecimenName) {


						arr.push(v.clone())


						


						if ((time:=regexreplace(v.LogDateTime,"\D"))&&floor(substr(time,1,1))>1){


						}else


							time:=regexreplace(v.ReleaseDateTime,"\D")


						


						sort["" time (++foundCount)]:=(foundCount)


						


					}


						


		}else {


			for k,v in Lab2Arr


				if (v.ItemName=ItemName && v.SpecimenName=SpecimenName) {


					arr.push(v.clone())


					if ((time:=regexreplace(v.LogDateTime,"\D"))&&floor(substr(time,1,1))>1){


					}else


						time:=regexreplace(v.ReleaseDateTime,"\D")


					


					sort["" time (++foundCount)]:=(foundCount)


					


				


				}


		}


	


	for k,v in sort


		newArr[foundCount+1-a_index]:=arr[v].clone()


	


	


	return newArr


}








;~ a:=getLab2("3______","C99A5756CF684B2BB7A5B653E1D7094A")


;~ b:=1


getLab2(chartNo,sid="",startDays=14,endDays=0,startTime="",endTime=""){


	global ptInfo,birthday,userId


	url:="http://converws.hospital-n.local/WebApplication/MedicalReportWS/MedicalReportSelectedLabItemReportWS.asmx"





	header:="SOAPAction: ""http://tempuri.org/QueryLabReportWithNormalRange""`nHost: converws.hospital-n.local`nContent-Type: text/xml; charset=utf-8"


	


	while(strlen(chartNo)<7)


		chartNo:="0" chartNo


	


	;~ if !ptInfo


		;~ ptInfo:=patientBasicInfo(chartNo,sid)


	;~ if !birthDay


		;~ birthDay:=ptInfo.birthYear "-" ptInfo.birthMonth "-" ptInfo.birthDay "T00:00:00"


	;~ if !userId


		;~ userId:=getUserId(sid)


	


	if (startTime=""){


		date:=a_now


		date+=-%startDays%,d


		FormatTime,startTime,% date,yyyy-MM-ddTHH:mm:ss


	}


	


	if (endTime=""){


		date:=a_now


		date+=-%endDays%,d


		FormatTime,endTime,% date,yyyy-MM-ddTHH:mm:ss


	}


	


	post=


	(


	<?xml version="1.0" encoding="utf-8"?>


	<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">


	  <soap:Body>


		<QueryLabReportWithNormalRange xmlns="http://tempuri.org/">


		  <chartNo>%chartNo%</chartNo>


		  <birthday>1900-01-01T00:00:00</birthday>


		  <loginEmpNo>000000</loginEmpNo>


		  <startTime>%startTime%</startTime>


		  <endTime>%endTime%</endTime>


		</QueryLabReportWithNormalRange>


	  </soap:Body>


	</soap:Envelope>


	)





	httprequest(url,post,header,"charset: utf-8")


	;~ clipboard:=post


	


	


	itemName:=["SybaseAcc","PortalAcc","DeptCode","Value","itemCode","LoginNo","ItemName","UnitName","ItemNameShort","OrderCode","ACMGroupName","OrderSeqNo","SpecimenName","SpecimenCode","LogDate","LogDateTime","ReleaseDateTime","Description","ViewCondition","OperatorDefineRange","RangeResult","MaxValue","MinValue","PatientClassCode"]


	


	i:=0,arr:=[]


	while i:=RegExMatch(post,"is)<LabItem>(.+?)</LabItem>",m,i+1) {


		j:=a_index


		for k,v in itemName {


			RegExMatch(m1,"<" v ">(.+?)</" v ">",match)


			StringReplace,match1,match1,&gt;,>


			StringReplace,match1,match1,&lt;,<


			StringReplace,match1,match1,&nbsp;,%a_space%


			StringReplace,match1,match1,&quot;,"


			StringReplace,match1,match1,&amp;,&


			arr[j,v]:=match1


		}


	}


	


	


	return arr


	


	/*


	


	*/


	


	


	


	/* response-------------------------------------------


	<?xml version="1.0" encoding="utf-8"?>


<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">


  <soap:Body>


    <QueryLabReportWithNormalRangeResponse xmlns="http://tempurf.org/">


      <QueryLabReportWithNormalRangeResult>


        <_LabItemList>


          <LabItem>


            <ChartNo>string</ChartNo>


            <SybaseAcc>string</SybaseAcc>


            <PortalAcc>string</PortalAcc>


            <DeptCode>string</DeptCode>


            <Value>string</Value>


            <itemCode>string</itemCode>


            <LoginNo>string</LoginNo>


            <ItemName>string</ItemName>


            <UnitName>string</UnitName>


            <ItemNameShort>string</ItemNameShort>


            <OrderCode>string</OrderCode>


            <ACMGroupName>string</ACMGroupName>


            <OrderSeqNo>string</OrderSeqNo>


            <SpecimenName>string</SpecimenName>


            <SpecimenCode>string</SpecimenCode>


            <LogDate>string</LogDate>


            <LogDateTime>dateTime</LogDateTime>


            <ReleaseDateTime>dateTime</ReleaseDateTime>


            <Description>string</Description>


            <ViewCondition>string</ViewCondition>


            <OperatorDefineRange>string</OperatorDefineRange>


            <RangeResult>Normal or Over or Below or Unknown</RangeResult>


            <MaxValue>string</MaxValue>


            <MinValue>string</MinValue>


            <PatientClassCode>string</PatientClassCode>


          </LabItem>


          <LabItem>


            <ChartNo>string</ChartNo>


            <SybaseAcc>string</SybaseAcc>


            <PortalAcc>string</PortalAcc>


            <DeptCode>string</DeptCode>


            <Value>string</Value>


            <itemCode>string</itemCode>


            <LoginNo>string</LoginNo>


            <ItemName>string</ItemName>


            <UnitName>string</UnitName>


            <ItemNameShort>string</ItemNameShort>


            <OrderCode>string</OrderCode>


            <ACMGroupName>string</ACMGroupName>


            <OrderSeqNo>string</OrderSeqNo>


            <SpecimenName>string</SpecimenName>


            <SpecimenCode>string</SpecimenCode>


            <LogDate>string</LogDate>


            <LogDateTime>dateTime</LogDateTime>


            <ReleaseDateTime>dateTime</ReleaseDateTime>


            <Description>string</Description>


            <ViewCondition>string</ViewCondition>


            <OperatorDefineRange>string</OperatorDefineRange>


            <RangeResult>Normal or Over or Below or Unknown</RangeResult>


            <MaxValue>string</MaxValue>


            <MinValue>string</MinValue>


            <PatientClassCode>string</PatientClassCode>


          </LabItem>


        </_LabItemList>


        <ChartNo>string</ChartNo>


        <StartTime>dateTime</StartTime>


        <EndTime>dateTime</EndTime>


      </QueryLabReportWithNormalRangeResult>


      <errMsg>string</errMsg>


    </QueryLabReportWithNormalRangeResponse>


  </soap:Body>


</soap:Envelope>


	*/


}











dateTimeParse1(str,delim="-"){


	arr:=[]


	RegExMatch(str,"(\d{4})" delim "(\d{2})" delim "(\d{2})T(\d{2}):(\d{2}):(\d{2})((?:\+|-)(?:\d{2}):(?:\d{2}))",match)


	arr.year:=match1


	arr.month:=match2


	arr.day:=match3


	arr.hour:=match4


	arr.minute:=match5


	arr.second:=match6


	arr.zone:=match7


	arr.dateStr:=match1 fill0(match2) fill0(match3)


	arr.timeStr:=fill0(match4) fill0(match5) fill0(match6)


	arr.str:=arr.dateStr arr.timeStr


	return arr


}





convertTaiwanDateToWestern(tw,delim="/"){


	RegExMatch(tw,"(\d+)\" delim "(\d+)\" delim "(\d+)",match)


	return (match1<200?(1911+match1):match1) fill0(match2) fill0(match3)


}


;~ sid:=login(loginId,loginPw)


;~ msgbox % portalMessage(sid,"0900000000","test")


portalMessage(sid,phoneNos,msg,msgType=3){


	global portalAspId


	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/CriticalVentilator/MessageSend.aspx?SESSION=" sid


	


	if (msgType=2)


		category:="rdbUnNormal"


	else if (msgType=1)


		category:="rdbCritical"


	else


		category:="rdbNormal"


	


	


	


	httprequest(url,html:="")


	


	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " url "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E; Sleipnir/2.9.14)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"


	


	str:="`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null;"


	


	post:="scrollLeft=&scrollTop=&__EVENTTARGET=NWeb1%24btnSendSMSAndEmail&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&NWeb1%24PersonIDInput=&NWeb1%24txbwardno=&NWeb1%24QueryInputByDr=&NWeb1%24PHSSendSeqNo=&NWeb1%24PHSTelNo=" phoneNos "&NWeb1%24txbEmail=&NWeb1%24MessageContent=" encodeurl(msg) "&NWeb1%24Category=" category "&NWeb1%24txbSearchID=loginId&NWeb1%24txbStartDate=2013%2F4%2F29&NWeb1%24txbEndDate=2013%2F5%2F2"


	


	httprequest(url,post,header str,"charset: utf-8")


	


	;~ clipboard:=header "`n`n" post


	


	return RegExMatch(post,"is)<script>alert.+?簡訊發送完成\\n")?true:false


	


}





;~ getOpHistory("5AC650F058384DE2BFB90BA005E3E433","3______")


getOpHistory(sid,chartNo,personId=""){


	if(personId=""){


		personId:=patientBasicInfo(chartNo,sid).personId


	}


	httprequest("http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&PersonID=" personId "&Func=OPNoteList&Seed=" a_now,html:="")


	


	dom:=ComObjCreate("HtmlFile")


	dom.write(html)


	arr:=[]


	


	loop {


		if((t:=getTextById(html,"TreeViewItemt" a_index-1))="")


			break


		RegExMatch(t,"is)(.+)_(\d+)\/(\d+)\/(\d+)",match)


		arr["" match2 match3 match4]:=match1


	}


	


	return arr


}








;~ sid:=login(loginId,loginPw)


;~ clipboard:=searchLab4(chartNo,sid)


;~ getLab4(sid,chartNo)





getLab4(sid,chartNo){


	global portalAspId


	


	httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx?SESSION=" sid,html:="",header:="Cookie: ASP.NET_SessionId=" portalAspId)


	


	url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx"


	header:="Cookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y; ASP.NET_SessionId=" portalAspId


	


	


}





htmlEscapeBack(str){


	static escapeCode:="&euro;,&nbsp;,&quot;,&amp;,&lt;,&gt;,&iexcl;,&cent;,&pound;,&curren;,&yen;,&brvbar;,&sect;,&uml;,&copy;,&ordf;,&not;,&reg;,&macr;,&deg;,&plusmn;,&sup2;,&sup3;,&acute;,&micro;,&para;,&middot;,&cedil;,&sup1;,&ordm;,&raquo;,&frac14;,&frac12;,&frac34;,&iquest;,&Agrave;,&Aacute;,&Acirc;,&Atilde;,&Auml;,&Aring;,&AElig;,&Ccedil;,&Egrave;,&Eacute;,&Ecirc;,&Euml;,&Igrave;,&Iacute;,&Icirc;,&Iuml;,&ETH;,&Ntilde;,&Ograve;,&Oacute;,&Ocirc;,&Otilde;,&Ouml;,&times;,&Oslash;,&Ugrave;,&Uacute;,&Ucirc;,&Uuml;,&Yacute;,&THORN;,&szlig;,&agrave;,&aacute;,&acirc;,&atilde;,&auml;,&aring;,&aelig;,&ccedil;,&egrave;,&eacute;,&ecirc;,&euml;,&igrave;,&iacute;,&icirc;,&iuml;,&eth;,&ntilde;,&ograve;,&oacute;,&ocirc;,&otilde;,&ouml;,&divide;,&oslash;,&ugrave;,&uacute;,&ucirc;,&uuml;,&yacute;,&thorn;"


	static characters:="€ ""&<>¡¢£¤¥¦§¨©ª¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþ"


	


	i:=0


	s:=str


	while RegExMatch(s,"&([\w\d#]+?);",m,i+1) {


		if RegExMatch(m,"#(\d+)",n) {


			s:=RegExReplace(s,m,chr(n1))


		}else {


			loop,parse,escapeCode,`,


				if(a_loopfield=m) {


					s:=RegExReplace(s,m,substr(characters,a_index,1))


					break


				}


		}


	}


	


	


	return s


	


}





OpdHxArrToCSV(byref arr,chartNo){


	


	


	csv:=""


	csv.="""病歷號"",""性別"",""生日年"",""生日月"",""生日日"",""姓名"",""門診日期"",""診斷"",""處方"",""醫令"",""年齡"",""帳號"",""院區"",""部門"",""主治醫師"",""Subjective"",""Objective"",""未來影像檢查排程"",""未來其他檢查排程"",""未來門診預約""`n"


	


	for k,v in arr {


		


		csv.=OpdHxToCSV(v,chartNo)


		


	}


	


	return csv


	


}





escapeQuote(str){


	return trim(RegExReplace(str,"""",""""""))


}





OpdHxToCSV(html,chartNo){


	v:=parseOpdHx(html)


	csv:=""


	


	csv.= """" escapeQuote(chartNo) ""","


	csv.= """" escapeQuote(v.gender) ""","


	RegExMatch(v.birthDay,"(\d+)\/(\d+)\/(\d+)",match)


	csv.= """" escapeQuote(match1) ""","


	csv.= """" escapeQuote(match2) ""","


	csv.= """" escapeQuote(match3) ""","


	csv.= """" escapeQuote(v.name) ""","


	csv.= """" escapeQuote(v.OpdDate) ""","


	


	str:=""


	for x,y in v.diagnosis


		str.= y.1 "," y.2 "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","


	


	str:=""


	for x,y in v.drug


		str.= y.name " | " y.dose " | " y.frequency " | " y.duration " | " y.totalAmount " | " y.ifChronic " | " y.orderDate " | " y.specialOrder "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","	


	


	str:=""


	for x,y in v.order


		str.= y "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","		


	


	


	csv.= """" escapeQuote(v.age) ""","


	csv.= """" escapeQuote(v.account) ""","


	csv.= """" escapeQuote(v.hospital) ""","


	csv.= """" escapeQuote(v.department) ""","


	csv.= """" escapeQuote(v.VS) ""","


	csv.= """" escapeQuote(v.subjective) ""","


	csv.= """" escapeQuote(v.objective) ""","


	


	str:=""


	for x,y in v.imageSchedule


		str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","	


	


	str:=""


	for x,y in v.examSchedule


		str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","	


	


	str:=""


	for x,y in v.FutureSchedule


		str.= y.date " | " y.timeShift " | " y.department " | " y.OpdNo " | " y.number " | " y.VS "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) """`n"	


	


	return csv


}








parseOpdHx(byref html){


	arr:=[]


	


	dom:=ComObjCreate("HtmlFile")


	dom.write(html)


	


	str:=$(dom,"TablePatientBasic").rows[1].innerText


	regexmatch(str,regex:="is)([^\s]+)\s+?\((\w),\s+?(\w+),\s+?([^)]+)\)",match)


	arr.name:=match1


	arr.gender:=match2


	arr.age:=match3


	arr.birthDay:=match4


	


	str:=$(dom,"TablePatientBasic").rows[2].innerText


	regexmatch(str,regex:="is)([^\s]+)\s+?([^\s]+)\s+?([^\s]+)\s+?主治醫師：([^\s]+)\s+?看診日期：([\d\/]+)",match)


	arr.account:=match1


	arr.hospital:=match2


	arr.department:=match3


	arr.VS:=match4


	arr.OpdDate:=match5


	


	arr.subjective:=htmlEscapeBack($(dom,"TableSubjectContent").rows[1].innerText)


	arr.objective:=htmlEscapeBack($(dom,"TableObjectContent").rows[1].innerText)


	


	dx:=[]


	loop % $(dom,"TableDiagnosis").rows.length {


		RegExMatch($(dom,"TableDiagnosis").rows[a_index-1].innerText,"is)([^,]+),\s+?(.+)",match)


		dx.push(array("" match1, "" htmlEscapeBack(match2)))


	}


	arr.diagnosis:=dx


	


	if $(dom,"TablePlanningContent").rows[1].getElementsByTagName("TABLE").length=0


		arr.plan:=$(dom,"TablePlanningContent").rows[1].innerText


	


	drug:=[]


	loop % (tr:=$(dom,"TableDrugData").rows).length-2 {


		d:=[],td:=tr[a_index+1].cells


		if ((name:=htmlEscapeBack(td[0].innerText))="") || td.length<8 {


			drug[drug.maxIndex(),"specialOrder"]:="" tr[a_index+1].innerText


			continue


		}


		d.name:="" name


		d.dose:="" td[1].innerText


		d.frequency:="" td[2].innerText


		d.duration:="" td[3].innerText


		d.totalAmount:="" td[4].innerText


		d.ifChronic:="" td[5].innerText


		d.orderDate:="" td[6].innerText


		drug.push(d.clone())


	}


	arr.drug:=drug


	


	order:=[]


	loop % (tr:=$(dom,"TableOrderInfo").rows).length-1 {


		contents:=RegExReplace(tr[a_index].cells[0].innerHTML,"is)<br\s*(\/)?>","ω")


		loop,parse,contents,ω


		{


			;~ ifDC:=""


			;~ if regexmatch(a_loopfield,"is)<span\s+?style=""?text-decoration\:\s*?line\-through""?[^>]*?>(.+)<\/span>",match)


				;~ ifDC:="(DC!)",a_loopfield:=decodeurl(match1)


			if ((txt:=trim(htmlEscapeBack(regexreplace(a_loopfield,"is)<span[^>]+?line-through[^>]+?>.+?<\/span>"))))!="")


				order.push(RegExReplace(txt,",$"))


		}


	}


	arr.order:=order


	


	


	imageSchedule:=[]


	loop % (tr:=dom.getElementById("TableImageSchedule").rows).length-2 {


		i:=[],td:=tr[a_index+1].cells


		if(instr(tr.innerText,"未來一般檢查排程")||instr(tr.innerText,"日期"))


			continue


		i.date:=td[0].innerText


		i.timeShift:=td[1].innerText


		i.examRoom:=htmlEscapeBack(td[2].innerText)


		i.number:=td[3].innerText


		i.orderName:=htmlEscapeBack(td[4].innerText)


		imageSchedule.push(i.clone())


	}


	arr.imageSchedule:=imageSchedule


	


	if ((table:=dom.getElementById("TableImageSchedule").nextSibling).tagName="TABLE"&&instr(table.innerText,"未來一般檢查排程")) {


		examSchedule:=[]


		loop % (tr:=table.rows).length-2 {


			e:=[],td:=tr[a_index+1].cells


			e.date:=td[0].innerText


			e.timeShift:=td[1].innerText


			e.examRoom:=htmlEscapeBack(td[2].innerText)


			e.number:=td[3].innerText


			e.orderName:=htmlEscapeBack(td[4].innerText)


			examSchedule.push(e.clone())


		}


		arr.examSchedule:=examSchedule


	}


	


	


	


	FutureSchedule:=[]


	loop % (tr:=$(dom,"TableFutureSchedule").rows).length-2 {


		f:=[],td:=tr[a_index+1].cells


		f.date:=td[0].innerText


		f.timeShift:=td[1].innerText


		f.department:=htmlEscapeBack(td[2].innerText)


		f.OpdNo:=td[3].innerText


		f.number:=td[4].innerText


		f.VS:=td[5].innerText


		FutureSchedule.push(f.clone())


	}


	arr.FutureSchedule:=FutureSchedule


	


	return arr


}


parseOldOpdHx(byref html){


	arr:=[]


	


	dom:=ComObjCreate("HtmlFile")


	dom.write(html)


	loop % (elm:=dom.body.childNodes).length {


		title:=trim((tr:=elm[a_index-1].firstChild.childNodes)[0].innerText)


		if(title="基本資料"){


			RegExMatch(tr[1].innerText,"([^\s]+)\s*?\((\w),([\d\/]+)\)\s*?\(電話\)([^\s]*?)\s*?\(手機\)([^\s]*?)\s*?\(住址\)([^\n]*)",match)


			arr.name:=match1


			arr.gender:=match2


			arr.birthDay:=match3


			arr.phone:=match4


			arr.cellPhone:=match5


			arr.address:=match6


		}else if(title="帳號資料"){


			RegExMatch(tr[1].innerText,"N醫院([^\s]+) 科部：([^\s]+) 主治醫師：([^\s]+) 看診時間：([\d\/]+)",match)


			arr.hospital:=match1


			arr.department:=match2


			arr.VS:=match3


			arr.OpdDate:=match4


		}else if(title="病歷內容"){


			arr.chart:=htmlEscapeBack(tr[1].innerText)


		}else if(title="診斷內容"){


			dx:=[],text:=tr[1].innerText


			StringReplace,text,text,`,(,¢


			temp:=""


			loop,parse,text,¢


			{


				if(RegExMatch(a_loopfield,"^\w)")){


					if(temp)


						dx.push(htmlEscapeBack(temp)),temp:=A_LoopField


				}else{


					temp.=a_loopfield


				}


			}


			dx.push(RegExReplace(htmlEscapeBack(temp),",\s?$"))


			arr.diagnosis:=dx


		}else if(title="處方內容"){


			drug:=[]


			loop % tr.length-2 {


				d:=[]


				name:=(td:=tr[a_index+1].childNodes)[0].innerText


				d.route:=td[1].innerText


				d.dose:=td[2].innerText


				d.frequency:=td[3].innerText


				d.duration:=td[4].innerText


				d.totalAmount:=td[5].innerText


				d.ifChronic:=td[6].innerText


				d.specialOrder:=htmlEscapeBack(td[7].innerText)


				drug["" name]:=d


			}


			arr.drug:=drug


		}else if(title="醫令內容"){


			order:=[]


			loop % tr.length-1 {


				order.push(htmlEscapeBack(tr[a_index].innerText))


			}


			arr.order:=order


		}


		


	}


	return arr


	


}





OldOpdHxToCSV(byref html,chartNo){


	v:=parseOldOpdHx(html)


	csv:=""


	


	csv.= """" escapeQuote(chartNo) ""","


	csv.= """" escapeQuote(v.gender) ""","


	RegExMatch(v.birthDay,"(\d+)\/(\d+)\/(\d+)",match)


	csv.= """" escapeQuote(match1) ""","


	csv.= """" escapeQuote(match2) ""","


	csv.= """" escapeQuote(match3) ""","


	csv.= """" escapeQuote(v.name) ""","


	csv.= """" escapeQuote(v.OpdDate) ""","


	


	;;


	str:=""


	for x,y in v.diagnosis


		str.= y "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","


	


	str:=""


	for x,y in v.drug


		str.= x " | " y.dose " | " y.frequency " | " y.duration " | " y.totalAmount " | " y.ifChronic " |  | " y.route " | " y.specialOrder "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","	


	


	str:=""


	for x,y in v.order


		str.= y "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","		


	


	


	csv.= """" escapeQuote(v.age) ""","


	csv.= """" escapeQuote(v.account) ""","  ;;;


	csv.= """" escapeQuote(v.hospital) ""","


	csv.= """" escapeQuote(v.department) ""","


	csv.= """" escapeQuote(v.VS) ""","


	;~ csv.= """" escapeQuote(v.subjective) ""","  ;;;


	csv.= """" escapeQuote(v.chart) ""","  ;;;


	csv.= """" escapeQuote(v.objective) ""","  ;;;


	


	return csv ","""","""",""""`n"


	


	str:=""


	for x,y in v.imageSchedule


		str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","	


	


	str:=""


	for x,y in v.examSchedule


		str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","	


	


	str:=""


	for x,y in v.FutureSchedule


		str.= y.date " | " y.timeShift " | " y.department " | " y.OpdNo " | " y.number " | " y.VS "`n"


	csv.= """" escapeQuote(regexreplace(str,"\n?$")) """`n"	


	


	


}








;~ replyConsult(sid,AccountIDSE,NotifyIDSE,ReplyContent,Diagnosis,Suggestion){


	;~ global __VIEWSTATE,__EVENTVALIDATION,portalAspId


	


	;~ url:="http://tihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" AccountIDSE "&NotifyIDSE=" NotifyIDSE


	


	;~ httprequest(url,html:="",header:="","charset: utf-8")


	


	;~ RegExMatch(header,"i)ASP\.NET_SessionId=\w{24}",portalAspId)


	


	;~ header:="Referer: " url "`nHost: tihisaw.hospital-n.local`nCookie: " portalAspId


	


	;~ post:="__EVENTTARGET=NWeb1%24btnRecordFisrtAnalysisTime&__VIEWSTATE=" encodeurl(__VIEWSTATE:=get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")) "&NWeb1%24TextboxReplyContent=" ReplyContent "&NWeb1%24TextboxDiagnosis=" Diagnosis "&NWeb1%24TextboxSuggestion=" Suggestion "&hiddenInputToUpdateATBuffer_CommonToolkitScripts=1"


	


	;~ httprequest(url,post,header,"charset: utf-8")





;~ }





/* 


params:


startYear


startMonth


startDay


endYear


endMonth


endDate


DeptCode


userId


ward


hospital


patientId


*/


consultInfo(sid,queryBy="",byref params="",html="",parse=1){


	if (params="")


		params:=[]


	if (queryBy="")


		queryBy:="NWeb1$QueryNotifyContent"


	


	if queryBy=Dept


		queryBy=NWeb1$ButtonQueryByDept


	


	


	


	global __VIEWSTATE,__EVENTVALIDATION,portalAspId,__VIEWSTATEGENERATOR


	


	if (__VIEWSTATE="" || __EVENTVALIDATION="" || portalAspId="" || __VIEWSTATEGENERATOR="")


		httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/QueryNotifyRecordByDr.aspx?SESSION=" sid,html:="",header:="","charset: utf-8")	


		,RegExMatch(header,"i)ASP\.NET_SessionId=\w{24}",portalAspId)


	


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: " url "`nAccept-Language: zh-tw`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nPragma: no-cache`nCookie: " portalAspId 


	


	


	endDate:=startDate:=a_now


	if(!params.endYear)


		params.endYear:=substr(endDate,1,4)


	if(!params.endMonth)


		params.endMonth:=substr(endDate,5,2)*1


	if(!params.endDay)


		params.endDay:=substr(endDate,7,2)*1


	


	startDate+=-3,D


	if(!params.startYear)


		params.startYear:=substr(startDate,1,4)


	if(!params.startMonth)


		params.startMonth:=substr(startDate,5,2)*1


	if(!params.startDay)


		params.startDay:=substr(startDate,7,2)*1


	


	


	if (queryBy="NWeb1$ButtonQueryByDept"){


		post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=" encodeurl("NWeb1$NotDepartSelectionObj$ddlDeptCode") "&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE:=get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")) "&NWeb1%24DateTextBoxYearMonthDayStart%24YearInput=" params.startYear "&NWeb1%24DateTextBoxYearMonthDayStart%24MonthInput=" params.startMonth "&NWeb1%24DateTextBoxYearMonthDayStart%24DayInput=" params.startDay "&NWeb1%24DateTextBoxYearMonthDayEnd%24YearInput=" params.endYear "&NWeb1%24DateTextBoxYearMonthDayEnd%24MonthInput=" params.endMonth "&NWeb1%24DateTextBoxYearMonthDayEnd%24DayInput=" params.endDay "&NWeb1%24NotDepartSelectionObj%24ddlHospitalCode=" ((hospital:=params.hospital)?hospital:"T0") "&NWeb1%24NotDepartSelectionObj%24ddlDeptCode=" params.DeptCode "&NWeb1%24DropDownListPatClass=&NWeb1%24PersonIDInput=" ((id:=params.userId)?id:getUserid(sid)) "&NWeb1%24DropDownListWardCode=" params.ward "&NWeb1%24txbChartNo=" params.chartNo "&NWeb1%24txbPatientPID=" params.patientId "&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=&NWeb1%24HiddenFieldHospitalCode=T0&NWeb1%24NotDepartSelectionObj%24ddlSubDept=&__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR:=get(html,"__VIEWSTATEGENERATOR"))


    	httprequest(url,html:=post,header1:=header,"charset: utf-8")





	}


	


	


	post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=" encodeurl(queryBy) "&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE:=get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")) "&NWeb1%24DateTextBoxYearMonthDayStart%24YearInput=" params.startYear "&NWeb1%24DateTextBoxYearMonthDayStart%24MonthInput=" params.startMonth "&NWeb1%24DateTextBoxYearMonthDayStart%24DayInput=" params.startDay "&NWeb1%24DateTextBoxYearMonthDayEnd%24YearInput=" params.endYear "&NWeb1%24DateTextBoxYearMonthDayEnd%24MonthInput=" params.endMonth "&NWeb1%24DateTextBoxYearMonthDayEnd%24DayInput=" params.endDay "&NWeb1%24NotDepartSelectionObj%24ddlHospitalCode=" ((hospital:=params.hospital)?hospital:"T0") "&NWeb1%24NotDepartSelectionObj%24ddlDeptCode=" params.DeptCode "&NWeb1%24DropDownListPatClass=&NWeb1%24PersonIDInput=" ((id:=params.userId)?id:getUserid(sid)) "&NWeb1%24DropDownListWardCode=" params.ward "&NWeb1%24txbChartNo=" params.chartNo "&NWeb1%24txbPatientPID=" params.patientId "&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=&NWeb1%24HiddenFieldHospitalCode=T0&NWeb1%24NotDepartSelectionObj%24ddlSubDept=&__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR:=get(html,"__VIEWSTATEGENERATOR"))


	


	httprequest(url,post,header,"charset: utf-8")


	


	if !parse


		return post


	


	dom:=ComObjCreate("HtmlFile")


	dom.write(post)


	arr:=[]


	


	if !(table:=$(dom,"NWeb1_NotifyDrRecord"))


		return arr


	


	vsName:=getUserName(params.userId,sid)


	


	loop % (tr:=table.rows).length-1 {


		if(instr(tr[a_index].innerHTML,"line-through"))


			continue


		


		vs:="" trim((td:=tr[a_index].cells)[9].innerText)


		R:="" trim(td[10].innerText)


		replyBy:="" trim(td[11].innerText)


		GCA:="" trim(td[12].innerText)


		if(params.userId && vsName!=vs && vsName!=R && vsName!=replyBy && vsName!=GCA)


			continue


		if !(time:=trim(RegExReplace(td[4].firstChild.title,"[\/\s:]")))


			continue


		


		row:=[]


		RegExMatch(td[1].firstChild.title,"is)T0-(.+)分機:(.+)",match)


		row.department:="" (d:=RegExReplace(match1,"\s"))?d:td[1].innerText


		row.departmentPhone:="" trim(match2)


		row.chartNo:="" trim(td[2].innerText)


		row.notifyId:="" td[2].firstChild.title


		row.account:="" trim(td[3].firstChild.title)


		RegExMatch(td[3].innerText,"is)([^\(]+)\((\w),([^\)]+)\)",match)


		row.name:=match1,row.gender:=match2,row.age:=match3


		row.time:=time


		row.type:="" trim(td[5].innerText)


		row.type2:=td[5].firstChild.title


		row.consulter:="" trim(td[6].innerText)


		RegExMatch(td[6].firstChild.title,"\d+",match)


		row.consulterPhone:=match


		row.purpose:=td[7].firstChild.title


		row.consulted:="" trim(td[8].innerText)


		row.VS:=vs


		RegExMatch(td[9].firstChild.title,"\d+",match)


		row.Rphone:=match


		row.R:=R


		RegExMatch(td[10].firstChild.title,"\d+",match)


		row.Rphone:=match


		row.replyBy:=replyBy


		row.GCA:=GCA


		row.status:="" trim(td[13].innerText)


		row.leftTime:="" trim(td[14].innerText)


		


		arr.push(row.clone())


	}


	


	return arr


}





getConsult(sid,accountIDSE,notifyIDSE,PatClass){


	seed2:=(substr(a_now,9,2)<12?"上午":"下午") " " substr(a_now,11,2) ":" substr(a_now,13,2) ":" substr(a_now,15,2)


	url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed2


	


	httprequest(url,html:="",header:="","charset: utf-8`n+NO_COOKIES")


	return html


	


}








replyConsult(sid,accountIDSE,notifyIDSE,PatClass,replyContent,diagnosis,suggestion,byref params=""){


	


	seed1:=(substr(a_now,9,2)<12?"%ufffdU%ufffd%ufffd":"%ufffdU%ufffd%ufffd") "+" substr(a_now,11,2) "%3a" substr(a_now,13,2) "%3a" substr(a_now,15,2)


	seed2:=(substr(a_now,9,2)<12?"上午":"下午") " " substr(a_now,11,2) ":" substr(a_now,13,2) ":" substr(a_now,15,2)


	


	url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed1


	


	referer:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed2


	


	


	html:=getConsult(sid,accountIDSE,notifyIDSE,PatClass)


	


	


	


	dom:=ComObjCreate("HtmlFile")


	dom.write(html)


	


	


	


	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " referer "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"


	


	post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=NWeb1%24btnRecordFisrtAnalysisTime&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl($(dom,"__VIEWSTATE").value) "&__EVENTVALIDATION=" encodeurl($(dom,"__EVENTVALIDATION").value) "&NWeb1%24TextboxMainPurpose=" regexreplace(encodeurl($(dom,"NWeb1_TextboxMainPurpose").value),"%20","+") "&NWeb1%24TextboxDescription=" regexreplace(encodeurl($(dom,"NWeb1_TextboxDescription").value),"%20","+") "&NWeb1%24TextboxReplyContent=" regexreplace(encodeurl(replyContent),"%20","+") "&NWeb1%24TextboxDiagnosis=" regexreplace(encodeurl(diagnosis),"%20","+") "&NWeb1%24TextboxSuggestion=" regexreplace(encodeurl(suggestion),"%20","+") "&NWeb1%24atxbGCAEmpNo%24txbContent=" (params.VS?params.VS:$(dom,"NWeb1_atxbGCAEmpNo_txbContent").value) "&NWeb1%24TextboxCostCenterInput=" (params.costCenter?params.costCenter:$(dom,"NWeb1_TextboxCostCenterInput").value) "&hiddenInputToUpdateATBuffer_CommonToolkitScripts=1&__VIEWSTATEGENERATOR=" encodeurl($(dom,"__VIEWSTATEGENERATOR").value)


	


	httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")


	


	return 1


	;~ return !!(instr(post,"<script>alert(""成功產生照會醫令") || instr(post,"<script>alert(""\n初次評估完成"");"))


	


		


	


}





;~ loginId:=loginId,loginPw:MOCK_PASSWORD


;~ askForPortalIdPw()


;~ ExitApp





askForPortalIdPw(opt=0, check_valid=true){


	global loginId,loginPw,sid


	priorSid:=Sid


	


	if fileexist("portal.ini")


		path:="portal.ini"


	else if fileexist((dir:=regexreplace(a_scriptdir,"[/\\][^/\\]+$")) "\portal.ini")


		path:=dir "\portal.ini"


	


	static AES_pw:="scsnakePortalLib"


	if(!opt){


		enc_dec:=""


		if(loginId=""&&loginPw=""&&fileexist(path)){


			iniread,loginId,% path,login,loginId


			iniread,loginPw,% path,login,loginPw


			Hex_Bin(enc_dec,loginPw)


			size:=Crypt_AES(&enc_dec, floor(strlen(loginPw)/2), AES_pw, 256, 0)


			loginPw:MOCK_PASSWORD,1,size),1,size-16)


		}


		priorPw:=loginPw


		priorId:=loginId


	}else{


		priorPw:=loginPw


		priorId:=loginId


		loginId:="",loginPw:MOCK_PASSWORD""


	}


	if !(check_valid)


		return


	


	ToolTip % "Login portal..."


	while !checkSid(sid:=Login(loginId,loginPw)) {


		ToolTip % "Login portal..."


		if (a_index>50) {


			msgbox % Can not login Portal !!


			exitapp


		}


		


		loop {


			ToolTip


			inputbox,loginId,Portal login ID,,,300,150,,,,,% (loginId="ERROR")?"":loginId


			if (errorlevel && !opt)


				exitapp


			else if (errorlevel) {


				loginId:=priorId,loginPw:MOCK_PASSWORD,Sid:=priorSid


				return


			}


		} until loginId!=""


		


		loop {


			inputbox,loginPw,Portal login password,,Hide,300,150


			if (errorlevel && !opt)


				exitapp


			else if (errorlevel){


				loginId:=priorId,loginPw:MOCK_PASSWORD,Sid:=priorSid


				return


			}


		} until loginPw!=""


		sleep 200


	}


	ToolTip 


	enc_dec:=loginPw "0123456789abcdef"


	size:=Crypt_AES(&enc_dec, strlen(enc_dec), AES_pw, 256, 1)


	encloginPw:MOCK_PASSWORD,size,32,"")


	


	if !fileexist(path)


		path:="portal.ini"


	


	if(opt||priorId!=loginId||priorPw!=loginPw){


		iniwrite,% loginId,% path,login,loginId


		iniwrite,% encloginPw,% path,login,loginPw


	}


	return sid


}





getOptionByText(byref el,str){


	if(el.tagName="select"){


		loop % el.options.length {


			if instr(el.options[a_index-1].innerText,str)


				return object("index",a_index-1,"value",el.options[a_index-1].value)


		}


	}


}





;~ clipboard:=queryDigiSign("D85480B694014C5781DE6D3E81E29FB8",loginId)


queryDigiSign(sid,id){


	global __VIEWSTATE,__EVENTVALIDATION,portalAspId


	


	url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DSQuery.aspx?SESSION=" sid


	if (!__VIEWSTATE || !__EVENTVALIDATION || !portalAspId) {


		header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive"


		


		httprequest(url,html:="",header,"charset: utf-8")


		portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")


		__VIEWSTATE:=get(html,"__VIEWSTATE")


		__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")


	}


	


	while strlen(id)<6


		id:="0" id


	


	formattime,date,% a_now,yyyy/MM/dd


	


	header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nReferer: http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DSQuery.aspx?SESSION=" sid "`nConnection: close`nCookie: 5=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null"


	


	post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=NWeb1%24txbEmpNO&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24txbEmpNO=" id "&NWeb1%24txbPinCode=&NWeb1%24txtSDateChar=" encodeurl(date) "&NWeb1%24txtSDateChar_MaskedEditExtender_ClientState=&NWeb1%24txtEDateChar=" encodeurl(date) "&NWeb1%24txtEDateChar_MaskedEditExtender_ClientState="


	


	httprequest(url,post,header,"charset: utf-8")


	


	return post


	


}


;~ clipboard:=queryDigiSignN("7B0931CBC4F74860A8093D6C76AD8004","000000")


queryDigiSignN(sid,id){


	global __VIEWSTATE,__EVENTVALIDATION,portalAspId,loginId


	


	url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DrugGivenDS.aspx?SESSION=" sid


	if (!__VIEWSTATE || !__EVENTVALIDATION || !portalAspId) {


		header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive"


		


		httprequest(url,html:="",header,"charset: utf-8")


		portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")


		__VIEWSTATE:=get(html,"__VIEWSTATE")


		__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")


	}


	


	while strlen(id)<6


		id:="0" id


	


	formattime,date,% a_now,yyyy/MM/dd


	


	header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nReferer: http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DrugGivenDS.aspx?SESSION=" sid "`nConnection: close`nCookie: 5=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null"


	


	d:=A_Now


	d+=-6,days


	


	post:="NWeb1%24ScriptManager1=NWeb1%24UpdatePanel1%7CNWeb1%24BtnGetEmgPatientListByDoctor&scrollLeft=0&scrollTop=0&hiddenHl7Reg=http%3A%2F%2Fihiswsvc.hospital-n.local%2FHL7Central_IIS%2FCentral.asmx-" sid "-" loginId "-" A_IPAddress1 "-DigitalSignature%2FDrugGivenDS&NWeb1%24txbEmpNO=" id "&NWeb1%24txtSDateChar=" substr(d,1,4) "%2F" substr(d,5,2) "%2F" substr(d,7,2) "&NWeb1%24txtSDateChar_MaskedEditExtender_ClientState=&NWeb1%24txtEDateChar=" a_yyyy "%2F" a_MM "%2F" a_dd "&NWeb1%24txtEDateChar_MaskedEditExtender_ClientState=&NWeb1%24txbPinCode=&NWeb1%24hiddenPin=undefind&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&__AjaxControlToolkitCalendarCssLoaded=&hiddenRecord=000000-" loginId "-T0&__ASYNCPOST=true&NWeb1%24BtnGetEmgPatientListByDoctor=%E6%9F%A5%E8%A9%A2"


	


	httprequest(url,post,header,"charset: utf-8")


	


	return post


	


}





;~ a:=EMRViewerMobile("777C5B94A94B4A3C97F61C6C5345442E",chartNo)


;~ b:=EMRgetRadExams(a)


;~ a.getReport("PA View","20130808")


EMRViewerMobile(sid,chartNo){


	global __VIEWSTATE,__EVENTVALIDATION,portalAspId,reportpageguid


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	if !(__VIEWSTATE && __EVENTVALIDATION && reportpageguid){


		url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx?SESSION=" sid


		header:="Host: ihisaw.hospital-n.local`nConnection: Keep-Alive"		


		httprequest(url,post:="",header,"charset: utf-8")


		


		RegExMatch(post,"reportpageguid=([\w\-]+)",match)


		reportpageguid:=match1


		__VIEWSTATE:=get(post,"__VIEWSTATE")


		__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")


	}


	


	;~ url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" reportpageguid


	;~ header:="Host: ihisaw.hospital-n.local`nConnection: Keep-Alive"


	;~ httprequest(url,post:="",header,"charset: utf-8")


	


	url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid="reportpageguid


	header:="Referer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" reportpageguid "`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"


	post:="__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&txbIDInput=" chartNo "&btnQueryAction=%E6%9F%A5%E8%A9%A2"


	httprequest(url,post,header,"charset: utf-8")


	


	RegExMatch(post,"reportpageguid=([\w\-]+)",match)


	reportpageguid:=match1


	__VIEWSTATE:=get(post,"__VIEWSTATE")


	__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")


	


	


	return new portalLib_EMRViewerMobile(post)


}





EMRgetRadExams(EMRViewerMobile){


	radExams:=[]


	sorting:=[],i:=0


	for k,v in EMRViewerMobile.EMR


		if instr(v.title,"影核醫") {


			for x,y in v


				if x is number


				{


					regexmatch(y.param,"([^_]+)_([^_]+)_([^_]+)",match)


					radExams.push({ExamName: RegExReplace(y["報告類別"],"i) \(V\d+\)$","") 


						,ExamDate: y["檢查日期"] ;yyyy/mm/dd


						,Hospital: match1 ;T0


						,AccessNo: match3


						,ReportDate: y["報告日期"]}) ;yyyymmdd


					sorting[RegExReplace(y["檢查日期"],"\D","") match3]:=++i


				}


		}


	sorted:=[]


	for k,v in sorting


		sorted.push(radExams[v])


	return sorted


}





class portalLib_EMRViewerMobile {


	__New(html){


		dom:=ComObjCreate("HtmlFile")


		dom.write(html)


		


		ret:=[]


		


		loop % $(dom,"MobileMenu").childNodes.length


		{	


			arr:=[]


			group:=$(dom,"MobileMenu").childNodes[a_index-1]


			arr["title"]:=group.firstChild.firstChild.nodeValue


			col:=[]


			loop % group.childNodes[1].firstChild.firstChild.childNodes.length


				col.push(trim(group.childNodes[1].firstChild.firstChild.childNodes[a_index-1].innerText))


			


			loop % group.childNodes[1].childNodes[1].childNodes.length {


				i:=a_index


				item:=[]


				item["param"]:=trim(group.childNodes[1].childNodes[1].childNodes[i-1].param)


				loop % group.childNodes[1].childNodes[1].childNodes[i-1].childNodes.length {


					j:=a_index


					if (col[j]="開報告"){


						regexmatch(group.childNodes[1].childNodes[1].childNodes[i-1].childNodes[j-1].firstChild.href,"WebForm_PostBackOptions\(""([^""]+)",match)


						item["" col[j]]:="" trim(match1)


					}else{


						item["" col[j]]:="" trim(group.childNodes[1].childNodes[1].childNodes[i-1].childNodes[j-1].innerText)


					}


				}


				arr.push(item.clone())


			}


			ret.push(arr.clone())


		}


		this.EMR:=ret	


		


		RegExMatch(html,"reportpageguid=([\w\-]+)",match)


		this.reportpageguid:=match1


		this.__VIEWSTATE:=get(html,"__VIEWSTATE")


		this.__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")


		


		this.chartNo:=get(html,"txbIDInput")


	}


	


	getReport(reportNameSubStr,examDate,titleSubStr="影核醫",Number=0,reportDate=""){


		if (reportNameSubStr="" || titleSubStr="")


			return []


		


		arr:=[],arr2:=[]


		


		if isobject(reportNameSubStr) {


			for k,v in this.EMR {


				if instr(v.title,titleSubStr) {


					for x,y in v {


						if x is not number


							continue


						if reportNameSubStr.(y["報告類別"]) && instr(RegExReplace(y["檢查日期"],"\D",""),RegExReplace(examDate,"\D","")){ 


							arr2.push(y["開報告"])


							if (reportDate="" || instr(RegExReplace(y["報告日期"],"\D",""),RegExReplace(reportDate,"\D","")))


								arr.push(y["開報告"])


						}


					}


					break


				}


			}


		}else{


			for k,v in this.EMR {


				if instr(v.title,titleSubStr) {


					for x,y in v {


						if x is not number


							continue


						if instr(y["報告類別"],reportNameSubStr) && instr(RegExReplace(y["檢查日期"],"\D",""),RegExReplace(examDate,"\D","")){


							arr2.push(y["開報告"])


							if (reportDate="" || instr(RegExReplace(y["報告日期"],"\D",""),RegExReplace(reportDate,"\D","")))


								arr.push(y["開報告"])


						}


					}


					break


				}


			}


		}


		


		if !arr.maxIndex()


			arr:=arr2.clone()


		


		if !arr.maxIndex()


			return 0


		arr2:=[]


		


		for k,v in arr {


			if (number>0&&a_index>number)


				break


			arr2.push(this.getReportByLink(v))


		}


		return arr2


	}


	


	getReportByLink(linkId){


		url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" this.reportpageguid


		header:="Referer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" this.reportpageguid "`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"


		post:="__LASTFOCUS=&__EVENTTARGET=" encodeUrl(linkId) "&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(this.__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(this.__EVENTVALIDATION) "&ddlPatChartNo=" encodeUrl(this.chartNo) "&txbIDInput=" encodeUrl(this.chartNo) "&txtEndDate=&txtStartDate="


		httprequest(url,post,header,"charset: utf-8")


		


		url:=RegExReplace(get(post,"Reportifrm","id","src"),"&amp;","&")


		httprequest(url,post:="",header:="","charset: utf-8")


		


		return post


	}


	


	radReportText(html){


		dom:=ComObjCreate("HtmlFile")


		dom.write(html)


		


		table1:=$(dom,"rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay").previousSibling.childNodes[5].firstChild


		table2:=$(dom,"rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay")


		str:=""


		


		loop % table1.firstChild.childNodes.length {


			i:=a_index


			loop % table1.firstChild.childNodes[i-1].childNodes.length {


				j:=a_index


				str.=trim(table1.firstChild.childNodes[i-1].childNodes[j-1].innerText) " "


			}


			str.="`n"


		}


		loop % table2.firstChild.childNodes.length {


			i:=a_index


			loop % table2.firstChild.childNodes[i-1].childNodes.length {


				j:=a_index


				if(table2.firstChild.childNodes[i-1].childNodes[j-1].getElementsByTagName("textarea").length>0)


					str.=trim(table2.firstChild.childNodes[i-1].childNodes[j-1].firstChild.firstChild.innerText) " "


				else


					str.=trim(table2.firstChild.childNodes[i-1].childNodes[j-1].innerText) " "


			}


			str.="`n"


		}


		


		return str


		


	}


	


	


}





/*


arr[1]


	醫令


	報告醫師


	影像時間 (format=2015/10/19 17:29)


	醫令碼


	報告時間


arr[2]	report


arr[3]	impression


*/


parseRisReport2Yr(html){


	dom:=ComObjCreate("HtmlFile")


	dom.write(html)


	


	table:=$(dom,"TableRISReport")


	


	arr:=[]


	loop % table.rows.length-1 {


		row:=table.rows[a_index]


		text:=row.innerText


		if regexmatch(text,"is)^醫令: (.+?) 報告醫師: (.+?) 影像時間: (.+?) \(([^\)]+)\) 發報告時間: (.+?)",match)


			tmp:=[],tmp.push([trim(match1), trim(match2), trim(match3), trim(match4), trim(match5)])


		else if regexmatch(text,"is)^報告內容: (.+)",match) || regexmatch(text,"is)^Impression: (.+)",match)


			tmp.push(trim(match1))


		else if regexmatch(text,"^症狀: ",match)


			arr.push(tmp)


	}


	return arr


}


;~ sid:="46384ABC44F2944279B48905EA5A126A9F"


;~ chartNo:="Y______"


;~ b:=RisReport2Yr(sid,chartNo)


;~ c:=parseRisReport2Yr(b)


;~ d:=1


;~ ExitApp


RisReport2Yr(sid,chartNo, hospital=""){


	if !checksid(sid){


		return -1


	}


	


	if hospital!=


		hospitalSpecified:=true


	


	if StrLen(chartNo)!=10 {


		if SubStr(chartNo,1,1)="H" 


			hospital=T4


		else if SubStr(chartNo,1,1)="Y" 


			;~ hospital=Y0


			return


	}


	


	;~ if hospital!=


		hospital:="&Hosp=" hospital


	


	if RegExMatch(chartNo,"i)(t|T|y|Y)\w{9}\d"){


		personId:=chartNo


	}else {


		while strlen(chartNo)<7


			chartNo:="0" chartNo


		personId:=patientBasicInfo(chartNo,sid).personId


	}


	


	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&Func=RISReport&AccountIDSE=&PersonID=" personid "&WinPup=True&Seed=" a_hour a_min a_sec hospital


	,header:="Referer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personid "&Seed=" a_now "`nHost: ihisaw.hospital-n.local"


	,httprequest(url,post:="",header,"charset: utf-8")


		


	return post


	


}





AppendAspInfo(post,html){


	global __VIEWSTATE,__EVENTVALIDATION


	post:=RegExReplace(post,"i)&?(__VIEWSTATE|__EVENTVALIDATION)=[^&]+","")


	post:=RegExReplace(post,"i)(__VIEWSTATE|__EVENTVALIDATION)=[^&]+&?","")


	


	if (post!="")


		post.="&"


	if (__VIEWSTATE="")


		__VIEWSTATE:=get(html,"__VIEWSTATE")


	if (__EVENTVALIDATION="")


		__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")


	


	return post "__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&__VIEWSTATE=" encodeurl(__VIEWSTATE)


}





ExtractHeaderCookie(responseHeader){


	i:=0,match:=str:=""


	while i:=regexmatch(responseHeader,"i)Set-Cookie: ([^\n]+)",match,i+strlen(match)+1)


		str.=match1


	


	return str:=RegExReplace(str,"(path=\/|HttpOnly|expires=[^;]+);?","")


}





queryInjectionRecords(sid,chartno){


	global __VIEWSTATE,__EVENTVALIDATION,portalAspId


	url:="http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx?SESSION=" sid


	if (!__VIEWSTATE || !__EVENTVALIDATION || !portalAspId) {


		header:="Host: hisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive`nCookie: CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=IsShowChartNo=Y; CK_Clinics_OrderSearch=IsShowOrderCode=N;"


		httprequest(url,html:="",header,"charset: utf-8")


		portalAspId:=RegExReplace(header,"s)^.+ASP\.NET_SessionId=([^;]+);.+$","$1")


		__VIEWSTATE:=get(html,"__VIEWSTATE")


		__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")


	}


	header:="Host: hisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive`nCookie: CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=IsShowChartNo=Y; CK_Clinics_OrderSearch=IsShowOrderCode=N;ASP.NET_SessionId=" portalAspId ";"


	httprequest(url,html:="",header,"charset: utf-8")


	ToolkitScriptManager1_HiddenField:=RegExReplace(html,"is)^.+\/WebApplication\/InspectionReport\/ReportOfCase\.aspx\?_TSM_HiddenField_=ToolkitScriptManager1_HiddenField&amp;_TSM_CombinedScripts_=([^""]+).+$","$1")


	ucQueryHandler_QueryTab_ClientState:=RegExReplace(get(html,"ucQueryHandler_QueryTab_ClientState"),"i)&quot;","""")


	__VIEWSTATE:=get(html,"__VIEWSTATE")


	__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")


	while strlen(chartno)<6


		chartno:="0" chartno


	formattime,startDate,% a_now,yyyy/M/d


	header:="Host: hisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nReferer: http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx?`nConnection: keep-alive`nCookie: ASP.NET_SessionId=" portalAspId "; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y; CK_Clinics_OrderSearch=IsShowOrderCode=N;"


	post:="ToolkitScriptManager1_HiddenField=" ToolkitScriptManager1_HiddenField "&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&ucQueryHandler_QueryTab_ClientState=" encodeurl("{""ActiveTabIndex"":1,""TabEnabledState"":[true,true],""TabWasLoadedOnceState"":[true,false]}") "&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__SCROLLPOSITIONX=0&__SCROLLPOSITIONY=0&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&ucQueryHandler%24ddlSystem=17&ucQueryHandler%24QueryTab%24QueryFromScheduling%24ddlOrder=CHMRX&ucQueryHandler%24QueryTab%24QueryFromScheduling%24txbDateStart=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryFromScheduling%24ddlShiftType=&ucQueryHandler%24QueryTab%24QueryFromScheduling%24txbQueryPat=&ucQueryHandler%24QueryTab%24QueryFromScheduling%24TextBoxWatermarkExtender2_ClientState=&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbChartNoOrPersonId=" encodeurl(chartNo) "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24TextBoxWatermarkExtender1_ClientState=&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbStartDate=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbEndDate=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24btnQueryFilled=%E6%9F%A5%E8%A9%A2&isMenuVisible=true"


	httprequest("http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx",post,header,"charset: utf-8")


	return new portalLib_FoundInjectionRecords(post)


}


class portalLib_FoundInjectionRecords {


	__New(post){


		dom:=ComObjCreate("HtmlFile")


		dom.write(post)


		this.ToolkitScriptManager1_HiddenField:=RegExReplace(post,"is)^.+\/WebApplication\/InspectionReport\/ReportOfCase\.aspx\?_TSM_HiddenField_=ToolkitScriptManager1_HiddenField&amp;_TSM_CombinedScripts_=([^""]+).+$","$1")


		this.ucQueryHandler_QueryTab_ClientState:=RegExReplace(get(post,"ucQueryHandler_QueryTab_ClientState"),"i)&quot;","""")


		arr:=[]


		table:=$(dom,"UpdatePanel1").childNodes[2]


		loop % table.rows.length-1 {


			v:=table.rows[a_index]


			pt:=[]


			pt.ChartNo:=trim(v.cells[1].innerText)


			pt.Name:=trim(v.cells[2].innerText)


			pt.Gender:=trim(v.cells[3].innerText)


			pt.Age:=trim(v.cells[4].innerText)


			pt.Status:=trim(v.cells[5].innerText)


			pt.Date:=trim(v.cells[6].innerText)


			pt.PostBack:=RegExReplace(v.cells[2].firstChild.href,"is)^.+(lvQuery\$ctrl\d+\$lbtName).+$","$1")


			arr.push(pt.clone())


		}


		this.results:=arr


	}


	getLink(n="",chartNo="",date="",postback:=""){


		global sid,portalAspId,__VIEWSTATE,__EVENTVALIDATION


		if(n!=""){


			return this.getLink("","","",this.results[n].PostBack)


		}else{


			arr:=[]


			for k,v in this.results {


				if (instr(v.chartNo,chartNo) && instr(RegExReplace(v.date,"\D",""),substr(RegExReplace(date,"\D",""),1,8))){


					formattime,startDate,% a_now,yyyy/M/d


					header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx`nx-requested-with: XMLHttpRequest`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E)`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache`nCookie: ASP.NET_SessionId=" portalAspId "; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y; CK_Clinics_OrderSearch=IsShowOrderCode=N; "


					post:="ToolkitScriptManager1=" encodeurl("UpdatePanel1|" (postback=""?v.PostBack:postback)) "&ToolkitScriptManager1_HiddenField=" this.func1(RegExReplace(this.ToolkitScriptManager1_HiddenField,"\+","%20")) "&__EVENTTARGET=" encodeurl(postback=""?v.PostBack:postback) "&__EVENTARGUMENT=&__LASTFOCUS=&ucQueryHandler_QueryTab_ClientState=" encodeurl("{""ActiveTabIndex"":1,""TabEnabledState"":[true,true],""TabWasLoadedOnceState"":[true,true]}") "&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__SCROLLPOSITIONX=0&__SCROLLPOSITIONY=0&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&ucQueryHandler%24ddlSystem=17&ucQueryHandler%24QueryTab%24QueryFromScheduling%24ddlOrder=CHMRX&ucQueryHandler%24QueryTab%24QueryFromScheduling%24txbDateStart=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryFromScheduling%24ddlShiftType=&ucQueryHandler%24QueryTab%24QueryFromScheduling%24txbQueryPat=&ucQueryHandler%24QueryTab%24QueryFromScheduling%24TextBoxWatermarkExtender2_ClientState=&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbChartNoOrPersonId=" v.chartNo "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24TextBoxWatermarkExtender1_ClientState=&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbStartDate=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbEndDate=" encodeurl(startDate) "&isMenuVisible=true&__ASYNCPOST=true"


					;~ clipboard:=header "`n`n" post


					httprequest("http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx",post,header,"charset: utf-8")


					arr.push(RegExReplace(clipboard:=post,"is)^.+(http:\/\/hisaw.hospital-n.local\/WebApplication\/InspectionReport\/ReportSheet\.aspx\?SESSION=" sid "[^\\]+).+$","$1"))


					if (PostBack!="")


						break


				}


			}


			return arr


		}


	}


	StringUpper(str){


		StringUpper,str,str


		return str


	}


	func1(str){


		str:=RegExReplace(str,"(\%\d)b","$1B")


		str:=RegExReplace(str,"(\%\d)a","$1A")


		str:=RegExReplace(str,"(\%\d)d","$1D")


		str:=RegExReplace(str,"(\%\d)c","$1C")


		str:=RegExReplace(str,"(\%\d)e","$1E")


		str:=RegExReplace(str,"(\%\d)f","$1F")


		return str


	}


}











/*


POST http://hiswsvc.hospital-n.local/HL7Central_IIS/Central.asmx HTTP/1.1


User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; MS Web Services Client Protocol 2.0.50727.3053)


Content-Type: text/xml; charset=utf-8


SOAPAction: "http://localhost/HL7Central/HL7Port"


Host: hiswsvc.hospital-n.local


Content-Length: 763


Expect: 100-continue





<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><HL7Port xmlns="http://localhost/HL7Central/"><HL7Input>&lt;QBP_Z10&gt;&lt;MSH&gt;&lt;MSH.3&gt;&lt;HD.1&gt;WebPageID&lt;/HD.1&gt;&lt;/MSH.3&gt;&lt;MSH.7&gt;&lt;TS.1&gt;20151023084922.2880&lt;/TS.1&gt;&lt;/MSH.7&gt;&lt;MSH.9&gt;&lt;MSG.2&gt;Z01&lt;/MSG.2&gt;&lt;/MSH.9&gt;&lt;/MSH&gt;&lt;PV1&gt;&lt;PV1.2&gt;I&lt;/PV1.2&gt;&lt;PV1.3&gt;&lt;PL.11&gt;&lt;HD.1&gt;T0&lt;/HD.1&gt;&lt;/PL.11&gt;&lt;/PV1.3&gt;&lt;PV1.19&gt;&lt;CX.1&gt;15T01440976&lt;/CX.1&gt;&lt;/PV1.19&gt;&lt;/PV1&gt;&lt;/QBP_Z10&gt;</HL7Input></HL7Port></soap:Body></soap:Envelope>








<QBP_Z10><MSH><MSH.3><HD.1>WebPageID</HD.1></MSH.3><MSH.7><TS.1>20151023084922.2880</TS.1></MSH.7><MSH.9><MSG.2>Z01</MSG.2></MSH.9></MSH><PV1><PV1.2>I</PV1.2><PV1.3><PL.11><HD.1>T0</HD.1></PL.11></PV1.3><PV1.19><CX.1>15T01440976</CX.1></PV1.19></PV1></QBP_Z10>











response:


HTTP/1.1 200 OK


Date: Fri, 23 Oct 2015 00:49:20 GMT


Server: Microsoft-IIS/6.0


X-Powered-By: ASP.NET


X-AspNet-Version: 2.0.50727


Cache-Control: private, max-age=0


Content-Type: text/xml; charset=utf-8


Content-Length: 11269





<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><HL7PortResponse xmlns="http://localhost/HL7Central/"><HL7PortResult>&lt;BAR_Z01&gt;&lt;PID&gt;&lt;PID.3&gt;&lt;CX.1&gt;ACC12345678&lt;/CX.1&gt;&lt;/PID.3&gt;&lt;/PID&gt;&lt;BAR_Z01.VISIT&gt;&lt;PV1&gt;&lt;PV1.2&gt;I&lt;/PV1.2&gt;&lt;PV1.3&gt;&lt;PL.11&gt;&lt;HD.1&gt;T0&lt;/HD.1&gt;&lt;HD.2&gt;EMER&lt;/HD.2&gt;&lt;HD.3&gt;NA&lt;/HD.3&gt;&lt;/PL.11&gt;&lt;/PV1.3&gt;&lt;PV1.19&gt;&lt;CX.1&gt;15T01440976&lt;/CX.1&gt;&lt;/PV1.19&gt;&lt;/PV1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;M&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;486&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Pneumonia&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;694.9&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Bullous dermatosis&lt;/ZDG1.4&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;692.9&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Eczema, chronic&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02,16&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;698.9&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Pruritus&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;879.8&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Wound&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;04&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;707.0&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Pressure sore&lt;/ZDG1.4&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;332.0&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Parkinsonism (F02.3)&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;331.4&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Hydrocephalus&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;300.4&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Mixed depression and anxiety&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;333.0&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Multiple system atrophy (MSA)&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;437.0&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Cerebral atherosclerosis&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;01,02,22&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;564.0&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Constipation&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;401.9&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Hypertension&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;V70.0&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Health examination&lt;/ZDG1.4&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;600.0&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Hypertrophy (benign) of prostate&lt;/ZDG1.4&gt;&lt;ZDG1.5&gt;02,14&lt;/ZDG1.5&gt;&lt;ZDG1.6&gt;103667&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;103667&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;103667&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151020151140.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;/BAR_Z01.VISIT&gt;&lt;/BAR_Z01&gt;</HL7PortResult></HL7PortResponse></soap:Body></soap:Envelope>








<BAR_Z01><PID><PID.3><CX.1>ACC12345678</CX.1></PID.3></PID><BAR_Z01.VISIT><PV1><PV1.2>I</PV1.2><PV1.3><PL.11><HD.1>T0</HD.1><HD.2>EMER</HD.2><HD.3>NA</HD.3></PL.11></PV1.3><PV1.19><CX.1>15T01440976</CX.1></PV1.19></PV1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>M</ZDG1.2><ZDG1.3>486</ZDG1.3><ZDG1.4>Pneumonia</ZDG1.4><ZDG1.5>02</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>694.9</ZDG1.3><ZDG1.4>Bullous dermatosis</ZDG1.4><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>692.9</ZDG1.3><ZDG1.4>Eczema, chronic</ZDG1.4><ZDG1.5>02,16</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>698.9</ZDG1.3><ZDG1.4>Pruritus</ZDG1.4><ZDG1.5>02</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>879.8</ZDG1.3><ZDG1.4>Wound</ZDG1.4><ZDG1.5>04</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>707.0</ZDG1.3><ZDG1.4>Pressure sore</ZDG1.4><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>332.0</ZDG1.3><ZDG1.4>Parkinsonism (F02.3)</ZDG1.4><ZDG1.5>02</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>331.4</ZDG1.3><ZDG1.4>Hydrocephalus</ZDG1.4><ZDG1.5>02</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>300.4</ZDG1.3><ZDG1.4>Mixed depression and anxiety</ZDG1.4><ZDG1.5>02</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>333.0</ZDG1.3><ZDG1.4>Multiple system atrophy (MSA)</ZDG1.4><ZDG1.5>02</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>437.0</ZDG1.3><ZDG1.4>Cerebral atherosclerosis</ZDG1.4><ZDG1.5>01,02,22</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>564.0</ZDG1.3><ZDG1.4>Constipation</ZDG1.4><ZDG1.5>02</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>401.9</ZDG1.3><ZDG1.4>Hypertension</ZDG1.4><ZDG1.5>02</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>V70.0</ZDG1.3><ZDG1.4>Health examination</ZDG1.4><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1><ZDG1><ZDG1.1>I</ZDG1.1><ZDG1.2>O</ZDG1.2><ZDG1.3>600.0</ZDG1.3><ZDG1.4>Hypertrophy (benign) of prostate</ZDG1.4><ZDG1.5>02,14</ZDG1.5><ZDG1.6>103667</ZDG1.6><ZDG1.7><TS.1>20151020151140.0000</TS.1></ZDG1.7><ZDG1.8>10.0.0.100</ZDG1.8><ZDG1.9>103667</ZDG1.9><ZDG1.10><TS.1>20151020151140.0000</TS.1></ZDG1.10><ZDG1.11>Y</ZDG1.11><ZDG1.13>103667</ZDG1.13><ZDG1.14>10.0.0.100</ZDG1.14><ZDG1.15><TS.1>20151020151140.0000</TS.1></ZDG1.15><ZDG1.16>I</ZDG1.16><ZDG1.17>N</ZDG1.17></ZDG1></BAR_Z01.VISIT></BAR_Z01>


*/





; clipboard:=PacsImageViewerRequest()


; ExitApp


PacsImageViewerRequest(){


	global portalUrl


	url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/ExternalPage/PacesImageViewer.aspx?SESSION=MOCK_SESSION_ID"


	header=


	(Ltrim


	Referer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/ExternalPage/PACSImage.aspx?isfrombackupdb=False&sheetnolist=T__________&chartnolist=H______&personid=ACC12345678&reportpageguid=ACC12345678&hospitalcode


	Host: ihisaw.hospital-n.local


	Cookie: WardListColumnSelectloginId=DR; InPatientWardDefaultQuery=T0|15C|00||QByBed|4; CK_MedicalReportOpen_PatientQueryCookie=SelectPatListTypeCookieIPatList=&SelectPatListTypeCookieEPatList=&SelectPatListTypeCookieOPatList=&SelectPatListTypeCookieLabPatList=&SelectPatListTypeCookieSpeList=&SelectPatListTypeCookie=IPatList; NPage_MenuSettingCookie=`%u5831`%u544a`%u7d22`%u5f15`%u7cfb`%u7d71=Y; ASP.NET_SessionId=mock_asp_session_id


	)


	httprequest(url, post:="", header)


	return header "`n`n" post


}








;~ PacsWebInfo(output,"T__________",chartNo,loginId,loginPw)


;~ a:=1


;~ PacsWebInfo(output,"T__________","3______",loginId,loginPw)


;~ PacsWebInfo(output,"T__________","6______",loginId,loginPw)


;~ PacsWebInfo(output,"T__________","H______",loginId,loginPw)


;~ ExitApp











PacsWebInfoYLH(byref output,AccNo,chartNo="",loginId="",loginPw="",count="1500"){


	baseUrl:="http://hwpacs.hospital-y.local/DicomWeb/DicomWeb.dll/WADO?User=" loginId "&Password=" md5(loginPw)


	,httprequest(url:=baseUrl "&requestType=Query&patientID=" chartNo "&accessionNumber=" accNo "&flag=2"


	,post:=""


	,header:="Host: hwpacs.hospital-y.local"


	, "charset: utf-8")


	


	if !IsObject(output)


		output:=[]


	try {


		x:=new xml(post)


		,output.studyUID:=x.getText("/queryResult/dataset/study/studyUID")


		, series:=x.selectNodes("/queryResult/dataset/study/series")


		Loop % series.length {


			s:=[]


			,s.seriesUID:=series.item(A_Index-1).getElementsByTagName("seriesUID").item(0).Text


			,im:=series.item(A_Index-1).getElementsByTagName("image")


			Loop % im.length {


				i:=[]


				, i.objectUID:=im.item(A_Index-1).getElementsByTagName("objectUID").item(0).Text


				, i.filePath:=im.item(A_Index-1).getElementsByTagName("filePath").item(0).Text


				, i.url:= baseUrl "&requestType=WADO&psHash=&studyUID=" output.studyUID "&seriesUID=" s.seriesUID "&objectUID=" i.objectUID "&flag=2&contentType=image/jpeg&imageQuality=100&columns=1536&windowCenter=&windowWidth=&frameNumber="


				, s[A_Index]:=i


			}


			output[A_Index]:=s


		}


	}catch e 


		MsgBox % e.message


	


	return output


	


}





PacsWebInfo(byref output,AccNo,chartNo="",loginId="",loginPw="",count="1500"){


	;~ url:="http://pacsmobile.hospital-n.local/?user=" loginId "&password=" loginPw "&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr"


	;~ header=


	;~ ( ltrim


	;~ Referer: http://pacswide.hospital-n.local:8080/kQuery.php


	;~ Host: pacsmobile.hospital-n.local


	;~ )


	;~ httprequest(url,post,header)


	;~ clipboard:=header "`n`n" post


	;~ exitapp


	PacsWebServer(AccNo, baseUrl, host)


	


	if(host="hwpacs.hospital-y.local")


		return PacsWebInfoYLH(output, AccNo, chartNo, loginId, loginPw, Count="1500")


	


	if InStr(baseUrl, "pacsmobile"){


		url:=baseUrl "/wado/?v=2.0.SU3.3&requestType=STUDY&contentType=text/javascript&maxResults=250&PatientID=" chartNo "&AccessionNumber=" AccNo "&ae=local&IssuerOfPatientID=&groupByIssuer=*&language=zh_TW&user=" loginId "&password=" loginPw 


		header=


		( Ltrim


		Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr


		Host: %host%


		)


		httprequest(url,post:="",header)


		cookie:=""


		;~ clipboard:=post


	}else if (baseUrl~="xero-\d+"){


		httprequest(url:="http://pacswide.hospital-n.local:8080/"


			, post:=""


			, header:="Host: pacswide.hospital-n.local:8080", "+NO_AUTO_REDIRECT`ncharset: utf-8")


	


		RegExMatch(header, "Set-Cookie: PHPSESSID=([^;]+)", match)


		, PHPSESSID:=match1


	


		httprequest(url:="http://pacswide.hospital-n.local:8080/auth_nh.php"


			, post:="account=" loginId "&pwd=" loginPw "&signIn=%E7%99%BB%E5%85%A5"


			, header:="Referer: http://pacswide.hospital-n.local:8080/`nHost: pacswide.hospital-n.local:8080`nCookie: PHPSESSID=" PHPSESSID


			, "+NO_AUTO_REDIRECT`ncharset: utf-8")


		


		;~ httprequest(url:="http://pacswide.hospital-n.local:8080/kQuery.php"


			;~ , post:=""


			;~ , header:="Referer: http://pacswide.hospital-n.local:8080/auth_nh.php`nHost: pacswide.hospital-n.local:8080`nCookie: PHPSESSID=" PHPSESSID


			;~ , "+NO_AUTO_REDIRECT`ncharset: utf-8")


			


		;~ httprequest(url:="http://pacswide.hospital-n.local:8080/gXWL.php"


			;~ , post:="qMethod=pt_id&hosp_id=hosp_id_04&user_hosp=01&pt_id=" chartNo "&fetchDbFlag=Y&qDirect=+&emgFlag=F"


			;~ , header:="Referer: http://pacswide.hospital-n.local:8080/kQuery.php`nHost: pacswide.hospital-n.local:8080`nCookie: PHPSESSID=" PHPSESSID


			;~ , "+NO_AUTO_REDIRECT`ncharset: utf-8")


			


		httprequest(url:=baseUrl "/"


			, post:=""


			, header:="Host: " host "`nCookie: JSESSIONID=""""", "+NO_AUTO_REDIRECT`ncharset: utf-8")


		


		RegExMatch(header, "Set-Cookie: JSESSIONID=([^;]+)", match)


		, JSESSIONID:=match1


		


		;~ httprequest(url:="http://pacswide.hospital-n.local:8080/giFrameXero.php"


			;~ , post:="ptID=" chartNo "&ptTitle=&ptInfo=&accessionNO=" AccNo "&width=1184&height=1521&hospID=04&emgFlag=F&hospPtIDs=" chartNo


			;~ , header:="Referer: http://pacswide.hospital-n.local:8080/kQuery.php`nHost: pacswide.hospital-n.local:8080`nCookie: PHPSESSID=" PHPSESSID


			;~ , "+NO_AUTO_REDIRECT`ncharset: utf-8")


			


		;~ httprequest(url:="http://pacswide.hospital-n.local:8080/gXero.php"


			;~ , post:=""


			;~ , header:="Referer: http://pacswide.hospital-n.local:8080/kQuery.php`nHost: pacswide.hospital-n.local:8080`nCookie: PHPSESSID=" PHPSESSID


			;~ , "+NO_AUTO_REDIRECT`ncharset: utf-8")


			


		httprequest(url:=baseUrl "/?user=xero01&password=xero01&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr"


			, post:=""


			, header:="Referer: http://pacswide.hospital-n.local:8080/kQuery.php`nHost: " host "`nCookie: JSESSIONID=" JSESSIONID


			, "+NO_AUTO_REDIRECT`ncharset: utf-8")


		


		RegExMatch(header, "Set-Cookie: JSESSIONIDSSO=([^;]+)", match)


		, JSESSIONIDSSO:=match1


		


		cookie:=PacsWebCookie(JSESSIONID, JSESSIONIDSSO, "1184/1152")


		


		;~ httprequest(url:=baseUrl "/?&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr"


			;~ , post:=""


			;~ , header:="Referer: http://pacswide.hospital-n.local:8080/kQuery.php`nHost: " host "`nCookie: JSESSIONID=" JSESSIONID "; JSESSIONIDSSO=" JSESSIONIDSSO


			;~ , "+NO_AUTO_REDIRECT`ncharset: utf-8")


			


		;~ clipboard:=post


		


		url:=baseUrl "/wado/?v=2.0.SU3.3&requestType=STUDY&contentType=text/javascript&maxResults=250&PatientID=" chartNo "&AccessionNumber=" AccNo "&ae=local&IssuerOfPatientID=&groupByIssuer=*&language=zh_TW&user=" loginId "&password=" loginPw 


		header=


		( Ltrim


		Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr


		Host: %host%


		Cookie: %cookie%


		)


		httprequest(url,post:="",header, "+NO_AUTO_REDIRECT`ncharset: utf-8")


		global __PacsWebCookie:=cookie


	}


	


	regexmatch(post,"(?<=studyUID=)[^&]+",studyUID)


		





	


	;~ regexmatch(post,"(?<=Count=)[^&]+",count)


	;~ count:=2


	regexmatch(post,"(?<=""ver"":"")[^""]+",ver)


	regexmatch(post,"(?<=Count=)\d+",count)


	


	url:=baseUrl "/wado/?v=2.0.SU3.3&requestType=IMAGE&contentType=text/javascript&regroup=*&studyUID=" (studyUid) "&Position=0&Count=" count "&ver=" ver "&ae=local&language=zh_TW"


	if InStr(baseUrl, "pacsmobile")


		url.="&user=" loginId "&password=" loginPw





	header=


	( Ltrim


	Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr


	Host: %host%


	)


	if(cookie!="")


		header.="`nCookie: " cookie


	httprequest(url,post:="",header)


	


	


	json:=json_from(post)


	if(!isobject(output))


		output:=[]


	


	output.studyUID:=json.children.1.children.1.studyUID


	output.url:=PacsWebUrlTrans(json.children.1.children.1.url, baseUrl, host)


	


	header=


	( Ltrim


	Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr


	Host: %host%


	)


	if(cookie!="")


		header.="`nCookie: " cookie


	


	


	ind:=0


	for k,v in json.children.1.children.1.children {


		if (v.seriesUID="")


			continue


		++ind


		output[ind]:=[]


		output[ind,"seriesUID"]:=v.seriesUID


		output[ind,"url"]:=PacsWebUrlTrans(v.url, baseUrl, host)


		


		url:=baseUrl "/wado/?v=2.0.SU3.3&" regexreplace(substr(v.url,2),"i)&url=true&regroup=true","")  "&contentType=text/javascript&regroup=*&ver=" ver


		if InStr(baseUrl, "pacsmobile")


			url.="&user=" loginId "&password=" loginPw


		;~ url:=regexreplace(url,"i)&url=true&regroup=true","") 


		httprequest(url,post:="",header1:=header)


		


		json2:=json_from(post)


		


		ind2:=0


		


		for x,y in json2.children.1.children.1.children {


			if (y.seriesUID=v.seriesUID){


				ind3:=x


				break


			}


		}


		


		for x,y in json2.children.1.children.1.children[ind3].children {


			if(y.objectUID="")


				continue


			++ind2


			output[ind,ind2,"objectUID"]:=y.objectUID


			output[ind,ind2,"url"]:=PacsWebUrlTrans(y.url, baseUrl, host)


		}


	}


	return output


	


}





PacsWebInfoFlatten(byref result){


	output:=[]


	for k,v in result


		if isobject(v)


			for x,y in v


				if isobject(y) && y.hasKey("ObjectUID")


					output.push(y)


	return output


}


PacsWebUrlTrans(url, baseUrl, host){


	regexmatch(url,"is)(?<=studyUID=)[\d\.]+",studyUID)


	regexmatch(url,"is)(?<=seriesUID=)[\d\.]+",seriesUID)


	regexmatch(url,"is)(?<=objectUID=)[\d\.]+",objectUID)


	return baseUrl "/wado/?v=2.0.SU3.3&requestType=XERO" (studyUID?"&studyUID=" studyUID:"") (seriesUID?"&seriesUID=" seriesUID:"") (objectUID?"&objectUID=" objectUID:"") "&language=zh_TW&ae=local"


}





PacsWebUrl(AccNo,chartNo="",loginId="",loginPw=""){


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	PacsWebServer(AccNo, baseUrl, host)


		


	return baseUrl "/?user=" loginId "&password=" loginPw "&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr"


}


;~ PacsWebDownloadJpeg2("http://pacsmobile.hospital-n.local/wado/?v=2.0.SU3.3&requestType=XERO&studyUID=1.2.124.113532.80.22187.2757.20130629.230919.702675561&seriesUID=1.2.840.113619.2.80.667156916.17002.1372519080.40.4.1&language=zh_TW&objectUID=1.2.840.113619.2.80.667156916.17002.1372519083.55&ae=local&user=loginId&password=loginPw,"T__________",chartNo,"test.jpeg","","2500")





;~ PacsWebLogin(loginId,loginPw)





;~ httprequest("http://pacsmobile.hospital-n.local/?user=loginId&password=loginPw&tab=Display&PatientID=ACC12345678&AccessionNumber=ACC12345678&theme=epr",post,header)


;~ PacsWebDownloadJpeg2("http://pacsmobile.hospital-n.local/wado/?v=2.0.SU3.3&requestType=XERO&studyUID=1.2.124.113532.80.22187.2757.20151230.105255.173046468&seriesUID=1.2.392.200046.100.14.787097720830906753119811747483526556630&objectUID=1.2.392.200046.100.14.545665725318203531646724020424983745249&language=zh_TW&ae=local","T__________","4______","test.jpeg","","2500",loginId,loginPw)





;~ ?requestType=WADO&studyUID=1.2.124.113532.80.22187.2757.20151230.105255.173046468&seriesUID=1.2.392.200046.100.14.787097720830906753119811747483526556630&objectUID=1.2.392.200046.100.14.545665725318203531646724020424983745249&ae=local





;~ output:=PacsWebInfoFlatten(PacsWebInfo(output,"T__________","N033777",loginId,loginPw))





;~ v:=output[output.maxindex()]


				;~ PacsWebDownloadJpeg2(v.url,"T__________",chartNo,"T__________ " chartNo.jpeg", "T__________" "" "" chartNo,1000,loginId,loginPw)





PacsWebCookie(ByRef inout_JSESSIONID="", ByRef inout_JSESSIONIDSSO="", ByRef inout_ViewportSize=""){


	static candidates1:="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-_"


	, candidates2:="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


	if (inout_JSESSIONID=""){


		loop 24 {


			random,rand,1,% strlen(candidates1)


			inout_JSESSIONID.=substr(candidates1,rand,1)


		}


	}


	if(inout_JSESSIONIDSSO=""){


		loop 32 {


			random,rand,1,% strlen(candidates2)


			inout_JSESSIONIDSSO.=substr(candidates2,rand,1)


		}


	}


	if(inout_ViewportSize=""){


		inout_ViewportSize:="1024/643"


	}


	return "JSESSIONID=" inout_JSESSIONID "; JSESSIONIDSSO=" inout_JSESSIONIDSSO "; xero-viewport-size=" inout_ViewportSize


}





PacsWebTemp(accNo,chartNo,loginId,loginPw){


	global JSESSIONID,JSESSIONIDSSO


	


	cookie:=PacsWebCookie(JSESSIONID, JSESSIONIDSSO)


	


	PacsWebServer(AccNo, baseUrl, host)


	


	url:=baseUrl "/?user=" loginId "&password=" loginpw "&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr"


	header=


	(


	Referer: http://pacswide.hospital-n.local:8080/kQuery.php


	Host: %host%


	Cookie: %cookie%


	)


	httprequest(url,post:="",header)


	


}








;~ ,accNo:="Y__________", chartNo:="Y______"


;~ ,output:=PacsWebInfoFlatten(PacsWebInfoYLH(output, AccNo, chartNo, loginId, loginPw))


;~ ,PacsWebDownloadJpeg2(output.1.url, AccNo, chartNo, "test.jpeg", "D:", "5000", loginId, loginPw)


;~ p:=1





PacsWebDownloadJpeg2(url,AccNo,chartNo,fileName="",folder="",PicWidth="",loginId="",loginPw="",retry=3,fileSize=100,first=1, callback="", param=""){


	global __PacsWebCookie


	;~ global JSESSIONID,JSESSIONIDSSO


	


	;~ if(!JSESSIONID || !JSESSIONIDSSO)


		;~ PacsWebTemp(AccNo,chartNo,loginId,loginPw)





	PacsWebServer(AccNo, baseUrl, host)


	


	if(first=1){


		;~ url:=PacsWebUrl(AccNo,chartNo,loginId,loginPw)


		;~ header:="Host: pacsmobile.hospital-n.local`nReferer: http://pacswide.hospital-n.local:8080/kQuery.php"


		;~ httprequest(url,post:="",header)


		


		


		while strlen(chartNo)<7


			chartNo:="0" chartNo


		


		if InStr(baseUrl, "hwpacs.hospital-y.local"){


			if !instr(url,"User=", true)


					url.="&User=" loginId


			if !instr(url,"Password=", true)


				url.="&Password=" md5(loginPw)


			


			if (!instr(url,"columns="))


				url.="&columns=" (PicWidth?PicWidth:a_screenwidth*2)


			else if PicWidth


				url:=RegExReplace(url,"(?<=columns=)[^&]+",PicWidth)


		}else{


		


			if InStr(baseUrl, "pacsmobile"){


				if !instr(url,"user=")


					url.="&user=" loginId


				if !instr(url,"password=")


					url.="&password=" loginPw


			}


			


			if (!instr(url,"rows="))


				url.="&rows=" (PicWidth?PicWidth:a_screenwidth*2)


			else if PicWidth


				url:=RegExReplace(url,"(?<=rows=)[^&]+",PicWidth)


		}


	}


	


	


	


	;~ url:="http://pacsmobile.hospital-n.local/wado/?v=2.0.SU3.3&requestType=XERO&studyUID=1.2.124.113532.80.22187.2757.20130629.230919.702675561&seriesUID=1.2.840.113619.2.80.667156916.17002.1372519080.40.4.1&language=zh_TW&objectUID=1.2.840.113619.2.80.667156916.17002.1372519083.55&ae=local&user=loginId&password=loginPw


	if InStr(baseUrl, "hwpacs.hospital-y.local"){


		header:="Referer: " baseUrl "/html5/ShowImage.html?User=" loginId "&Password=" md5(loginPw) "&patientID=" chartNo "&accessionNumber=" AccNo "`nHost: " host


	}else{


		header=


		( LTRIM


		Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr


		Host: %host%


		)





		if (baseUrl~="xero-\d+")


			header.="`nCookie: " __PacsWebCookie


	


	}


	httprequest(url,post:="",header,"charset: utf-8`nbinary")


	;~ msgbox % post


	;~ clipboard:=header


	


	


	


	if (folder="")


		folder:=A_ScriptDir


	if (filename="")


		filename:=AccNo " " chartNo " 1.jpeg"


	


	regexmatch(header,"(?<=Content-Length: )\d+",len)


	filedelete,% folder "\" filename


	if !InStr(FileExist(folder), "D")


		FileCreateDir,% folder


	if (len>fileSize)


		bytes:=BinWrite(folder "\" filename,post,len)


	


	if(bytes>100){


		if IsFunc(callback)


			SetTimerFn(callback,-1, param)


		return 0


	}else if (--retry<1){


		return -1


	}else


		return PacsWebDownloadJpeg2(url,AccNo,chartNo,fileName,folder,PicWidth,loginid,loginpw,retry,fileSize,0, callback, param)


}


;~ PacsWebDownloadJpeg("T__________","4______","test.jpeg","","2500",loginId,loginPw)





PacsWebServer(AccNo, ByRef outBaseUrl, ByRef outHost){


	if (AccNo~="i)^Y"){


		outBaseUrl:="http://hwpacs.hospital-y.local"


		,outHost:="hwpacs.hospital-y.local"


		return


	}


	


	RegExMatch(AccNo, "i)^T(\d)", hospitalCode)


	if (hospitalCode1="4" || SubStr(AccNo,1,1)="H")


		outBaseUrl:="http://xero-01.hospital-h.local"


		,outHost:="xero-01.hospital-h.local"


	else


		outBaseUrl:="http://pacsmobile.hospital-n.local"


		,outHost:="pacsmobile.hospital-n.local"


}





PacsWebDownloadJpeg(AccNo,chartNo="",fileName="",folder="",PicWidth="",loginid="",loginpw="",retry=3,fileSize=100){


	static tried





	++tried


	


	if (chartNo!="")


		while strlen(chartNo)<7


			chartNo:="0" chartNo


		


	PacsWebServer(AccNo, baseUrl, host)


	


	url:=PacsWebUrl(AccNo,chartNo,loginId,loginPw)


	header:="Host: " host "`nReferer: http://pacswide.hospital-n.local:8080/kQuery.php"


	httprequest(url,post:="",header)





	regexmatch(post,"i)wado\/\?v=[^\ \""]+",match)


	StringReplace,match,match,&amp;,&,all


	


	url:=baseUrl "/" match


	url:=RegExReplace(url,"\d+$",picWidth?picWidth:a_screenwidth)


	header:="Referer: " baseUrl "/?&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr`nHost: " host


	httprequest(url,post:="",header1:=header,"charset: utf-8`nbinary")


	


	


	if (folder="") 


		folder:=A_ScriptDir


	if (filename="")


		filename:=AccNo " " chartNo " 1.jpeg"


	


	regexmatch(header1,"(?<=Content-Length: )\d+",len)


	


	filedelete,% folder "\" filename


	bytes:=BinWrite(folder "\" filename,post,len)


	


	if(bytes>100)


		return 0


	else if (tried>=retry)


		return tried


	else


		return PacsWebDownloadJpeg(AccNo,chartNo,fileName,folder,PicWidth,loginid,loginpw,retry,fileSize)


	


}


;~ PacsWebLogin(loginId,loginPw)


PacsWebLogin(loginid,loginpw){


	global pacsWebPhpid


	


	if (pacsWebPhpId=""){


		httprequest("http://pacswide.hospital-n.local:8080/",post:="",header:="","charset: utf-8")


		RegExMatch(header,"i)PHPSESSID=(\w+)",match)


		pacsWebPhpId:=match1


	}


	


	url:="http://pacswide.hospital-n.local:8080/auth_nh.php"


	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: http://pacswide.hospital-n.local:8080/`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: pacswide.hospital-n.local:8080`nConnection: Keep-Alive`nPragma: no-cache`nCookie: PHPSESSID=" pacsWebPhpId


	post:="account=" loginId "&pwd=" loginPw "&signIn=%E7%99%BB%E5%85%A5"


	


	httprequest(url,post,header,"charset: utf-8")


	


	if instr(post,"﻿﻿<script language='javascript'>location.replace('kQuery.php')</script>")


		return 1


	else


		return 0


}





;hospital="1,2,3,4,5,6" -> N總院、J分院、B分院、H分院、ZD分院、Y分院


; one page = 10 results


PacsWebQuery(chartNo,hospital="1",pageLimit=3){


	global pacsWebPhpId


	


	while strlen(chartNo)<7


		chartNo:="0" chartNo


	


	


	url:="http://pacsweb.hospital-n.local/gXWL.php"


	header:="x-requested-with: XMLHttpRequest`nAccept-Language: zh-tw`nReferer: http://pacswide.hospital-n.local:8080/kQuery.php`nAccept: text/html, */*; q=0.01`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322; .NET4.0C; .NET4.0E)`nHost: pacswide.hospital-n.local:8080`nConnection: Keep-Alive`nPragma: no-cache`nCookie: PHPSESSID=" pacsWebPhpId


	


	;~ post:="qMethod=pt_id&hosp_id=hosp_id_01&user_hosp=01&pt_id=" chartNo "&fetchDbFlag=Y&qDirect=+&emgFlag=T"


	hospitalCode:=""


	loop,parse,hospital,`,


		hospitalCode.="hosp_id_0" a_loopfield "%2C"


	hospitalCode:=substr(hospitalCode,1,-3)


	if (hospitalCode="")


		hospitalCode:="hosp_id_01"


	post:="qMethod=pt_id&hosp_id=" hospitalCode "&user_hosp=01&pt_id=" chartNo "&fetchDbFlag=Y&qDirect=+&emgFlag=F"


	


	httprequest(url,post,headerSent:=header,"charset: utf-8")


	


	regexmatch(post,"第(\d)頁 / 共(\d)頁",match)


	


	result:=[]


	PacsWebResult(post,result)


	loop % match2-1 {


		if (pageLimit && a_index>pageLimit)


			break


		


		httprequest(url,post:="qMethod=pt_id&hosp_id=" hospitalCode "&user_hosp=01&pt_id=" chartNo "&fetchDbFlag=N&qDirect=next&emgFlag=F",headerSent:=header,"charset: utf-8")


		PacsWebResult(post,result)


	}


	


	return result


}





;; 院區 姓名 性別 年齡 生日 病歷號 Modality 檢查時間 AccessNo 檢查項目


PacsWebResult(html,byref arr){


	dom:=ComObjCreate("HtmlFile")


	


	,dom.write(html)


	


	,table:=$(dom,"ptWL_table")


	loop % table.rows.length-1 {


		row:=table.rows[a_index]


		,tmp:=[]


		,tmp["Hospital"]:=trim(row.cells[2].innerText)


		,tmp["Name"]:=trim(row.cells[3].innerText)


		,tmp["Gender"]:=trim(row.cells[4].innerText)


		,tmp["Age"]:=trim(row.cells[5].innerText)


		,tmp["Birthday"]:=trim(row.cells[6].innerText)


		,tmp["ChartNo"]:=trim(row.cells[7].innerText)


		,tmp["Modality"]:=trim(row.cells[8].innerText)


		,tmp["ExamDate"]:=trim(row.cells[9].innerText) ;2015/11/11 19:21:54


		,tmp["AccessNo"]:=trim(row.cells[10].innerText)


		,tmp["ExamName"]:=trim(row.cells[11].innerText)


		,arr.push(tmp)


	}


	


	return arr


	


}





/*POST http://hiswsvc.hospital-n.local/HL7Central_IIS/Central.asmx HTTP/1.1


User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; MS Web Services Client Protocol 2.0.50727.3623)


Content-Type: text/xml; charset=utf-8


SOAPAction: "http://localhost/HL7Central/HL7Port"


Host: hiswsvc.hospital-n.local


Content-Length: 763


Expect: 100-continue





<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><HL7Port xmlns="http://localhost/HL7Central/"><HL7Input>&lt;QBP_Z10&gt;&lt;MSH&gt;&lt;MSH.3&gt;&lt;HD.1&gt;WebPageID&lt;/HD.1&gt;&lt;/MSH.3&gt;&lt;MSH.7&gt;&lt;TS.1&gt;20151115114124.7158&lt;/TS.1&gt;&lt;/MSH.7&gt;&lt;MSH.9&gt;&lt;MSG.2&gt;Z01&lt;/MSG.2&gt;&lt;/MSH.9&gt;&lt;/MSH&gt;&lt;PV1&gt;&lt;PV1.2&gt;I&lt;/PV1.2&gt;&lt;PV1.3&gt;&lt;PL.11&gt;&lt;HD.1&gt;T0&lt;/HD.1&gt;&lt;/PL.11&gt;&lt;/PV1.3&gt;&lt;PV1.19&gt;&lt;CX.1&gt;15T08814901&lt;/CX.1&gt;&lt;/PV1.19&gt;&lt;/PV1&gt;&lt;/QBP_Z10&gt;</HL7Input></HL7Port></soap:Body></soap:Envelope>


*/





/*


HTTP/1.1 200 OK


Date: Sun, 15 Nov 2015 03:41:23 GMT


Server: Microsoft-IIS/6.0


X-Powered-By: ASP.NET


X-AspNet-Version: 2.0.50727


Cache-Control: private, max-age=0


Content-Type: text/xml; charset=utf-8


Content-Length: 2112





<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><HL7PortResponse xmlns="http://localhost/HL7Central/"><HL7PortResult>&lt;BAR_Z01&gt;&lt;PID&gt;&lt;PID.3&gt;&lt;CX.1&gt;ACC12345678&lt;/CX.1&gt;&lt;/PID.3&gt;&lt;/PID&gt;&lt;BAR_Z01.VISIT&gt;&lt;PV1&gt;&lt;PV1.2&gt;I&lt;/PV1.2&gt;&lt;PV1.3&gt;&lt;PL.11&gt;&lt;HD.1&gt;T0&lt;/HD.1&gt;&lt;HD.2&gt;SURG&lt;/HD.2&gt;&lt;HD.3&gt;NA&lt;/HD.3&gt;&lt;/PL.11&gt;&lt;/PV1.3&gt;&lt;PV1.19&gt;&lt;CX.1&gt;15T08814901&lt;/CX.1&gt;&lt;/PV1.19&gt;&lt;/PV1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;U&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;M&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;512.8&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Pneumothorax&lt;/ZDG1.4&gt;&lt;ZDG1.6&gt;100898&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20150903155518.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;100898&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20150903155518.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;100898&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151024095801.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;ZDG1&gt;&lt;ZDG1.1&gt;I&lt;/ZDG1.1&gt;&lt;ZDG1.2&gt;O&lt;/ZDG1.2&gt;&lt;ZDG1.3&gt;599.0&lt;/ZDG1.3&gt;&lt;ZDG1.4&gt;Urinary tract infection&lt;/ZDG1.4&gt;&lt;ZDG1.6&gt;100898&lt;/ZDG1.6&gt;&lt;ZDG1.7&gt;&lt;TS.1&gt;20151024095801.0000&lt;/TS.1&gt;&lt;/ZDG1.7&gt;&lt;ZDG1.8&gt;10.0.0.100&lt;/ZDG1.8&gt;&lt;ZDG1.9&gt;100898&lt;/ZDG1.9&gt;&lt;ZDG1.10&gt;&lt;TS.1&gt;20151024095801.0000&lt;/TS.1&gt;&lt;/ZDG1.10&gt;&lt;ZDG1.11&gt;Y&lt;/ZDG1.11&gt;&lt;ZDG1.13&gt;100898&lt;/ZDG1.13&gt;&lt;ZDG1.14&gt;10.0.0.100&lt;/ZDG1.14&gt;&lt;ZDG1.15&gt;&lt;TS.1&gt;20151024095801.0000&lt;/TS.1&gt;&lt;/ZDG1.15&gt;&lt;ZDG1.16&gt;I&lt;/ZDG1.16&gt;&lt;ZDG1.17&gt;N&lt;/ZDG1.17&gt;&lt;/ZDG1&gt;&lt;/BAR_Z01.VISIT&gt;&lt;/BAR_Z01&gt;</HL7PortResult></HL7PortResponse></soap:Body></soap:Envelope>


*/


; need patient admission account no using getAccountIdFromAccNo(sid, AccNo)


;~ msgbox % a:=getAccountIdFromAccNo("DDD5E9C88C8648A3A3B000A608DA15C9", "T__________")


;~ clipboard:=getRisPatientHx(a:="16T02877448")


getRisPatientDx(PatientAccNo,hospital="T0",patientType="I"){


	;~ random,rand,1,1000


	;~ while strlen(rand)<4


		;~ rand.="0" rand


	


	url:="http://hiswsvc.hospital-n.local/HL7Central_IIS/Central.asmx"


	header:="User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; MS Web Services Client Protocol 2.0.50727.3623)`nContent-Type: text/xml; charset=utf-8`nSOAPAction: ""http://localhost/HL7Central/HL7Port""`nHost: hiswsvc.hospital-n.local`nExpect: 100-continue"


	post:="<?xml version=""1.0"" encoding=""utf-8""?><soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema""><soap:Body><HL7Port xmlns=""http://localhost/HL7Central/""><HL7Input>&lt;QBP_Z10&gt;&lt;MSH&gt;&lt;MSH.3&gt;&lt;HD.1&gt;WebPageID&lt;/HD.1&gt;&lt;/MSH.3&gt;&lt;MSH.7&gt;&lt;TS.1&gt;" a_now ".0001"  "&lt;/TS.1&gt;&lt;/MSH.7&gt;&lt;MSH.9&gt;&lt;MSG.2&gt;Z01&lt;/MSG.2&gt;&lt;/MSH.9&gt;&lt;/MSH&gt;&lt;PV1&gt;&lt;PV1.2&gt;" patientType "&lt;/PV1.2&gt;&lt;PV1.3&gt;&lt;PL.11&gt;&lt;HD.1&gt;" hospital "&lt;/HD.1&gt;&lt;/PL.11&gt;&lt;/PV1.3&gt;&lt;PV1.19&gt;&lt;CX.1&gt;" PatientAccNo "&lt;/CX.1&gt;&lt;/PV1.19&gt;&lt;/PV1&gt;&lt;/QBP_Z10&gt;</HL7Input></HL7Port></soap:Body></soap:Envelope>"


	


	httprequest(url,post,header,"charset: utf-8")


	


	regexmatch(post,"is)<HL7PortResult>(.*)<\/HL7PortResult>",match)


	StringReplace,match1,match1,&lt;,<,all


	StringReplace,match1,match1,&gt;,>,all


	return match1


	


}


;~ a:=a_tickcount


;~ b:=getPacsHx("46384ABC44F2944279B48905EA5A126A9F","")


;~ msgbox % a_tickcount-a "," b.maxindex()


;~ ExitApp


getPacsHx(sid,patientIdorChartNo, hospital=""){


	;~ global portalAspId


	if(patientIdorChartNo="")


		return


	while strlen(patientIdorChartNo)<7


		patientIdorChartNo:="0" patientIdorChartNo


	


	if hospital!=


		hospitalSpecified:=true


	


	if StrLen(patientIdorChartNo)!=10 {


		if SubStr(patientIdorChartNo,1,1)="H" 


			hospital=T4


		else if SubStr(patientIdorChartNo,1,1)="Y" 


			hospital=Y0


	}


	


	;~ if hospital!=


		hospital:="&Hosp=" hospital


	


	personId:=strlen(patientIdorChartNo)<10?patientBasicInfo(patientIdorChartNo,sid).personId:patientIdorChartNo


	


	,url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PACSImageShowList.aspx?SESSION=" sid "&PersonID=" personId hospital


	


	,httprequest(url, post:="", header:="", "charset: utf-8")


	


	,dom:=ComObjCreate("HtmlFile")


	,dom.write(post)


	,arr:=[]


	,rows:=$(dom,"BloodCallRecordDataGrid").rows


	


	


	;全選  病歷號 單號 檢查日 檢查名稱 儀器 狀態 


	loop % rows.length-1 {


		cells:=rows[a_index].cells


		arr[a_index]:=[]


		arr[a_index,"ChartNo"]:=trim(cells[1].innerText)


		arr[a_index,"AccessNo"]:=trim(cells[2].innerText)


		arr[a_index,"ExamDate"]:=trim(cells[3].innerText) ;20151019


		arr[a_index,"ExamName"]:=trim(cells[4].innerText)


		arr[a_index,"Modality"]:=trim(cells[5].innerText)


		arr[a_index,"Status"]:=trim(cells[6].innerText) ;已確認 


	}


	


	if (!hospitalSpecified && !arr.maxIndex() && hospital!="")


		return getPacsHx(sid, patientId, "T0")


	else


		return arr


}





;查詢醫令提成


;~ queryPerformancePercentage("33026BZM" ,"478C2718A117E746EBB70B85B735A08FCA", "T4")


queryPerformancePercentage(orderCode, sid, hospitalCode="T0"){


	global __VIEWSTATE, __VIEWSTATEGENERATOR, __EVENTVALIDATION, portalAspId


	


	url:="http://ahisaw.hospital-n.local/WebApplication/Administration/GCAPerformance/QueryPerformancePercentage.aspx?SESSION=" sid


	if (__VIEWSTATE="" || __EVENTVALIDATION="" || __VIEWSTATEGENERATOR="" || portalAspId=""){


		httprequest(url, post:="",header:="Host: ahisaw.hospital-n.local", "charset: utf-8")


		,RegExMatch(header,"i)(?<=ASP.NET_SessionId=)\w+",portalAspId)


		,renewPortalState(post)


	}


	


	header=


	(LTrim


	Referer: %url%


	Host: ahisaw.hospital-n.local


	Cookie: 15=1; remember=0; mypassword=; myaccount=; ASP.NET_SessionId=%portalAspId%; JSESSIONID=null


	)


	


	post:="scrollLeft=0&scrollTop=0&WebCtrlQueryPP%24ddlHospital=" hospitalCode "&WebCtrlQueryPP%24tbxOrderCode=" orderCode "&WebCtrlQueryPP%24btnQueryOrderPP=%E6%9F%A5%E8%A9%A2%E9%86%AB%E4%BB%A4%E6%8F%90%E6%88%90&WebCtrlQueryPP%24QueryOrderPercentageByOrderName1%24tbxOrderName="


	


	,httprequest(url, post:=addPortalState(post), header, "charset: utf-8")


	;~ clipboard:=post


	


	dom:=ComObjCreate("HtmlFile")


	,dom.write(post)


	,table:=dom.getElementById("WebCtrlQueryPP_dgrQOrderPP")


	


	,ret:=[], col:=[]


	Loop % table.rows.length {


		row:=table.rows[A_Index-1]


		if(A_Index=1){


			Loop % row.cells.length 


				col.push(Trim(row.cells[A_Index-1].innerText)) ; 醫令碼	院區碼	醫令名稱	提成比率	是否提成


		}else{


			ret[i:=A_Index-1]:=[]


			Loop % row.cells.length


				ret[i, col[A_Index]]:=Trim(row.cells[A_Index-1].innerText)


		}


	}


	return ret


}








;~ getPortalMessages("46C4B2F7B45D8A41F78CE0173BEFC3979A")


;~ ExitApp


getPortalMessages(sid){


	httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ShowInfo.aspx?SESSION=" sid "&ACT=ShowNCPHSMessage", post:="")


	,renewPortalState(post)


	,dom:=ComObjCreate("HtmlFile")


	,dom.write(post)


	,tables:=dom.getElementById("dtlPHSMessage").getElementsByTagName("TABLE")


	,arr:=[]


	


	Loop % (tables.length-1)


		Loop % (rows:=tables[A_Index].rows).length {


			cells:=rows[A_Index-1].cells


			,tmp:=[]


			; 選 	序號 	接收號碼 	發送者 	發送時間 	收到時間 	內容提示 	狀態


			for k,v in ["index", "receiveNo", "sender", "sendTime", "receiveTime", "text", "status"]


				tmp[v]:=Trim(cells[k].innerText)


			arr.push(tmp)


			break


		}	


	


	return arr


}





confirmMessage(msgIndex, sid){


	global __VIEWSTATE, __VIEWSTATEGENERATOR, __EVENTVALIDATION


	


	msg:=getPortalMessages(sid), 


	for k, v in msg


		if (v.index=msgIndex){


			cb:="dtlPHSMessage$ctl" fill0(k,2) "$ckbSelect"


			break


		}


	


	if(cb="")


		return 1


	


	post:="__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR) "&" encodeurl(cb) "=on&btnConfirm=%E7%A2%BA%E8%AA%8D%E7%B0%A1%E8%A8%8A" 


	,url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ShowInfo.aspx?SESSION=" sid "&ACT=ShowNCPHSMessage"


	,httprequest(url, post, header:="Host: ihisaw.hospital-n.local`nReferer: " url, "charset: utf-8")


	return !!InStr(post, "self.close()")


}





;~ getVSConfirmList("4664C0232E7DE8497B9271D9F02AF00506")


getVSConfirmList(sid){


	global portalAspId


	if (portalAspId="")


		getPortalAspId()


	


	url:="http://portal.hospital-n.local/General/NewRedirect.aspx?SESSION=" sid


	,httprequest("http://portal.hospital-n.local/General/GeneralHandler.ashx", post:="Mode=VSConfirmList", header:="


	(LTrim


	Content-Type: application/x-www-form-urlencoded; charset=UTF-8


	Referer: http://portal.hospital-n.local/General/NewRedirect.aspx?SESSION=" sid "


	Host: portal.hospital-n.local


	Cookie: _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=000860&SessionKey=" sid "&LoginPosCode=H&LoginPosCodeIndex=0; ASP.NET_SessionId=" portalAspId "


	)", "charset: utf-8")


	try 


		return j:=JXON_load(post)


	catch e


		return []


	


}








;--------------include: F:\scripts\Radiology\urgentReport\selectCT - threading.ahk------------


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.


SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.


SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance,Off


SetBatchLines, -1


coordMode,mouse,screen


CoordMode,caret,screen


DetectHiddenWindows,on


SetTitleMatchMode,2


SetControlDelay,-1


comobjerror(false)


onexit,onexit








;~ #include <JoinScript>


;~ #include <ExploreObj>








;~ #include <LVA>


gosub Main


return








main:


askForPortalIdPw()


,RisListQue:=CriticalObject()


,RisListNewResult:=CriticalObject()


,OnMessage(0x1001, "urgentReportClick")


;~ ,test:=20


;~ ,OnMessage("0x4E", "LVA_OnNotify")


gosub pointsDef


gosub loadHx


gui,+hwndGuihwnd


gui,Font,s12,微軟正黑體


gui,Add,ListView,% "r20 w980 backgroundBlack cwhite AltSubmit vlv gLVClick",% s:="Type|Chart No|Exam Date|Exam Name|Acc No|OPD Date|Clinician|Pay|Points|Mets|Op"


colNo:={}


Loop,Parse,s,|


	colNo[RegExReplace(A_LoopField, " ", "")]:=A_Index


for k,v in [30, 80, 80, 100, 130, 80, 80, 30, 80, 30, 30]


	LV_ModifyCol(k, v)


LV_ModifyCol(colNo.Points, "Float")


,LV_ModifyCol(colNo.Mets, "Integer")


,LV_ModifyCol(colNo.Op, "Integer")





;~ gui,add,button,gAddRisList,Add RIS List


gui,Show,,Select CT


GroupAdd,Self,ahk_id %guihwnd%


gosub routine


;~ SetTimer,routine,300000


;~ SetTimer,impaxContextServer,-1





return





urgentReportClick(){


	global urgentReportClick:=1


}








#IfWinActive,ahk_group Self


F5::


MsgBox, 260, ,Reload?


IfMsgBox,Yes


	gosub routine


;~ SetTimer,routine,300000


return


#IfWinActive





strAbbr(str, patternArr, abbrArr){


	for k,v in patternArr


		if RegExMatch(str, v) 


			return abbrArr[k]


	return str


}








addRisList:


ReportList:=[]


,reportListCount:=parseDataGrid(RisListRowsAcc:=acc_children(acc_objectfromwindow(RisListHwnd:=getRisList(RisOpened()[2]))),reportList, 1, 1)


,extractTitleCol(reportList[1], reportListTitleCol:=[])


,parseDataGrid(RisListRowsAcc,reportList, 1, test?test:"", "", "", "reportListProgress")


ToolTip 


return





reportListProgress(k, ByRef rowAcc, ByRef cellsAcc, ByRef rowValue){


	local haskey


	tooltip % "Get list from RIS: " k-1 " / " reportListCount-1 " ..."


	


	if(k=1)


		return


	


	if !((ChartNo:=rowValue[reportListTitleCol["病歷號"]])~="\w{6}\d") 


			|| !((ExamName:=Trim(rowValue[reportListTitleCol["檢查名稱"]]), "CT")~="is)CT.+with.*contrast|low dose (lung|chest)")


		return


	


	if RisListInfo.haskey(AccNo:=rowValue[reportListTitleCol["照會單號"]]){


		data:=RisListInfo[AccNo]


	}else{


		data:=[], toBeSearch.push(k)


	}


	LV_Add(""


		, strAbbr(rowValue[reportListTitleCol["診別"]], ["門診", "住院", "急診"], ["門", "住", "急"])


		, Trim(rowValue[reportListTitleCol["病歷號"]])


		, (Trim(rowValue[reportListTitleCol["檢查日"]]))


		, abr:=strAbbr(ExamName:=rowValue[reportListTitleCol["檢查名稱"]], ["i)with\/without contrast-chest", "i)with contrast-chest", "i)without contrast-chest", "i)low dose (lung|chest)"], ["-+C", "+C", "-C", "LDCT"])


		, Trim(AccNo)


		, StrLen(t:=SubStr(Trim(rowValue[reportListTitleCol["回診日期"]]), 6))>4?t:""


		, Trim(rowValue[reportListTitleCol["開單醫師"]])


		, strAbbr(Pay:=rowValue[reportListTitleCol["保險別"]], ["自費", "健保"], ["自", "健"])


		, pointsArr[ExamName]*(InStr(Pay, "自費")&&abr!="LDCT"?1.3:1)/data.parts/10*0.2


		, data.mets


		, data.Op)


		





}








routine:


ToolTip % "Loading RIS list ..."


;~ SetTimer,searching,Off





LV_Delete()


toBeSearch:=[]


SetFormat,FloatFast,0.1


gosub addRisList


;~ for k, v in reportList {


	


;~ }


;~ LV_ModifyCol(colNo.Urgency, "Sort")


toBeSearchInd:=1


;~ SetTimerF("searching", -1)


;~ search(searchInd)


if (toBeSearch.maxindex()>0) {


	renewSid(sid, loginId, loginPw)


	searching:=[]


	SetTimer,search,-1


	SetTimer,RisListRefresh,-1000


}


ToolTip


return





test:


	MsgBox


return





search:


	;~ global reportList, reportListTitleCol, sid, RisListInfo, pointsArr, hxFile, colNo, stop, errorInds, searchingTh, ThreadCount


	;~ for k,v in reportList {


	searchInd:=toBeSearch[toBeSearchInd]


	if searching[searchInd] {


		if(++toBeSearchInd<=toBeSearch.maxindex()){


					SetTimer,search,-500


				}


		return


	}


	searching[searchInd]:=true


	


	;~ row:=reportList[searchInd]


		;~ if ((ChartNo:=row[reportListTitleCol["病歷號"]])~="\w{6}\d") 


			;~ && ((ExamName:=Trim(row[reportListTitleCol["檢查名稱"]]), "CT")~="is)CT.+with.*contrast|low dose (lung|chest)"){


			


		


		;~ Pay:=row[reportListTitleCol["保險別"]]


		;~ , ExamDate:=SubStr(RegExReplace(row[reportListTitleCol["檢查日"]], "\D", ""), 1, 8)


		;~ if(RisListInfo.haskey(AccNo:=row[reportListTitleCol["照會單號"]])){


			;~ SetFormat, FloatFast, 0.1


			;~ data:=RisListInfo[AccNo]


			;~ LV_Edit(colNo.AccNo, AccNo, colNo.Points


					;~ , pointsArr[ExamName]*(InStr(Pay, "自費")?1.3:1)/data.parts/10*0.2)


			;~ ,LV_Edit(colNo.AccNo, AccNo, colNo.Mets, data.mets)


			;~ ,LV_Edit(colNo.AccNo, AccNo, colNo.Op, data.Op)


			


		;~ }else{


			;~ RisListQue[AccNo]:=k


			if(ThreadCount>20){


				settimer,search,-500


				return


			}else {


					newSearchThread(searchInd)


				


			}


		;~ }


	


	;~ }


	





				if(++toBeSearchInd<=toBeSearch.maxindex()){


					SetTimer,search,-500


						;~ SetTimerF("search", -500, [searchInd+1])


				}


	;~ }


return





;@Ahk2Exe-AddResource LIB portallib.ahk


newSearchThread(ind){


	global


	


	


		ahkmini("


		(


		#persistent


		


		SetFormat, FloatFast, 0.1


		RisListInfo:=CriticalObject(" (&RisListInfo) ")


		,RisListNewResult:=CriticalObject(" (&RisListNewResult) ")


		,Alias(searchInd, " getvar(searchInd) ")


		,Alias(reportList, " getvar(reportList) ")


		,Alias(reportListTitleCol, " getvar(reportListTitleCol) ")


		,Alias(sid, " getvar(sid) ")


		,Alias(pointsArr, " getvar(pointsArr) ")


		,Alias(hxFile, " getvar(hxFile) ")


		,Alias(colNo, " getvar(colNo) ")


		,Alias(ThreadCount, " getvar(ThreadCount) ")


		,searchInd:=" ind "


		SetFormat,FloatFast,0.1


		gosub <searching


		return


		


		)" CreateScript("


		(


		<searching:searching>


		patientBasicInfoWebTree{}


		patientBasicInfoWeb{}


		checkSid{}


		)") )


	


	ThreadCount++


	


}








<searching:





Loop 3 {


		row:=reportList[searchInd]


		,ChartNo:=row[reportListTitleCol["病歷號"]]


		, AccNo:=row[reportListTitleCol["照會單號"]]


		, Pay:=row[reportListTitleCol["保險別"]]


		, ExamName:=Trim(row[reportListTitleCol["檢查名稱"]])


		, ExamDate:=SubStr(RegExReplace(row[reportListTitleCol["檢查日"]], "\D", ""), 1, 8)





				ToolTip % "Loading PACS history: " ChartNo


				;~ 6______


				PacsCTHx:=patientBasicInfoWebTree(patientBasicInfoWeb(chartNo, sid)).getNodeByNames("置頂","報告","影核醫報告").arr


				, parts:=0


				for k,v in PacsCTHx {


					RegExMatch(v.innerText,"is)^([\d\/]{10})\_(.+)", match)


					,match1:=RegExReplace(match1, "\D", "")


					


					if (ExamDate=match1 && match2~="^CT") || ((ExamName~="i)low dose (lung|chest)") && (match2~="i)low dose (lung|chest)"))


						parts++


					else if (ExamDate>match1)


						break


				}


				;~ MsgBox % parts


				if(parts!=0){


					;~ clipboard:=ChartNo


					;~ MsgBox % "error"


					;~ if stop


						;~ ExitApp


					;~ else 


						;~ SetTimer,<searching,-100


					;~ Pacs2YrHx:=parseRisReport2Yr(RisReport2Yr(sid, chartNo))


					Pacs2YrHx:=(RisReport2Yr(sid, chartNo))


					if(Pacs2YrHx~="i)(bone|lung|pulmonary) +metastas")


						mets:=true


					if(Pacs2YrHx~="i)operative|post[- ]?op|lobectomy|(wedge +resection)|segmentectomy|pneumonectomy")


						op:=true


					 


					RisListNewResult[AccNo]:=[searchInd, parts, pointsArr[ExamName]*(InStr(Pay, "自費")&&!(ExamName~="i)low dose (lung|chest)")?1.3:1)/parts/10*0.2, !!mets, !!op]


					break


				}


				;~ MsgBox % ExploreObj(ahkSelf)


				;~ ahkSelf.Func("searching_onData", jxon_dump([parts, AccNo, pointsArr[ExamName]*(InStr(Pay, "自費")?1.3:1)/parts/10*0.2]))


				;~ ahkSelf.sub("test")


				;~ RisListInfo[AccNo]:=parts


				;~ ,LV_Edit(colNo.AccNo, AccNo, colNo.Points


					;~ , pointsArr[ExamName]*(InStr(Pay, "自費")?1.3:1)/parts/10*0.2)


				;~ FileAppend,% AccNo "," parts "`n",% hxFile,utf-8


				;~ ToolTip


				;~ Pacs2YrHx:=parseRisReport2Yr(RisReport2Yr(sid, chartNo))





		;~ if !(++searchInd > reportList.maxindex()) || (stop)


			;~ ExitApp


		;~ else


			;~ SetTimer,<searching,-100


			ToolTip


		}


ThreadCount--


ExitApp


searching>:


return





RisListRefresh(){


	global RisListNewResult, colNo, RisListInfo, hxFile


	SetFormat,FloatFast,0.1


	if(RisListNewResult.SetCapacity(0)=0){


		SetTimer,RisListRefresh,-1000


		return


	}


	


	toBeDel:=[]


	for AccNo, v in RisListNewResult {


		ToolTip % "Set value for AccNo: " AccNo


		LV_Edit(colNo.AccNo, AccNo, colNo.Points, v[3])


		,LV_Edit(colNo.AccNo, AccNo, colNo.Mets, v[4])


		,LV_Edit(colNo.AccNo, AccNo, colNo.Op, v[5])


		,toBeDel.push(AccNo)


		,RisListInfo[AccNo]:={parts: v[2], mets: v[4], op: v[5]}


		FileAppend,% AccNo "," v[2] "," v[4] "," v[5]  "`n",% hxFile,utf-8


	}


	ToolTip 


	for k,v in toBeDel


		RisListNewResult.delete(v)


	


	SetTimer,RisListRefresh,-500


}





LV_Edit(matchCol, matchValue, EditCol, EditValue){


	local v


	static lastInd:=0


	SetFormat,FloatFast,0.1	


	Loop % LV_GetCount()-lastInd+1 {


		LV_GetText(v, A_Index + lastInd -1, matchCol)


		if(v=matchValue){


			LV_Modify(lastInd:=A_Index + lastInd -1, "Col" EditCol, EditValue)


			return lastInd


		}


	}


	Loop % lastInd-1 {


		LV_GetText(v, A_Index, matchCol)


		if(v=matchValue){


			LV_Modify(lastInd:=A_Index, "Col" EditCol, EditValue)


			return lastInd


		}


	


	}


}





shortenTime(timeStr){ ; yyyy/mm/dd hh:mm


	str:=""


	if !RegExMatch(timeStr, "(\d+)/(\d+)/(\d+) (\d+):(\d+)", match)


		return


	


	datefrom := match1 match2 match3


	,distance := dateto := A_YYYY a_mm a_dd


	,distance -= datefrom, days


	


	if (distance =0 || (datefrom=A_YYYY a_mm a_dd))


		return match4 ":" match5


	else if (distance<4)


		return match2 "/" match3 " " match4 ":" match5


	else if (distance<30)


		return match2 "/" match3


	else


		return match1 "/" match2


		


}








LVClick:


;~ ToolTip % A_GuiEvent


;~ Sleep 500


if !A_EventInfo 


	return


LV_GetText(getAccNo, A_EventInfo, colNo.AccNo)


,LV_GetText(getChartNo, A_EventInfo, colNo.ChartNo)


,priorRow:=A_EventInfo


if (A_GuiEvent="DoubleClick" ){


	SetTimer,singleClick,Off


	urgentReportClick:=-1


	PostMessage,0x1001,,,,ahk_exe urgentReport.exe


	if (RisOpened()[1]=2){


		winactivate,% "ahk_id " RisOpened()[2]


		searchRisChartNo(RisOpened()[2],getAccNo=""?getChartNo:getAccNo, getChartNo)


		if(getAccNo!="")


			ClickFirstResult(getAccNo)


	}else{


		clipboard:=getChartNo


		ToolTip % "Chart No copied!"


		settimer,ToolTip,-2000


	}


	


}else if (A_GuiEvent="RightClick"){


	


}else if (A_GuiEvent="Normal"){


	SetTimer,singleClick,-500


}else if (A_GuiEvent="ColClick"){


	


}else{


	ToolTip


}


return





quitPwb(pwb){


	try 


		pwb.quit()


}











ClickFirstResult(AccNo){


	global reportListTitleCol


	WinWaitActive,% "ahk_id " RisOpened()[2],,3


	parseDataGrid(RisListRowsAcc:=acc_children(acc_objectfromwindow(RisListHwnd:=getRisList(RisOpened()[2])))


		,reportListTmp:=[], 1, 2)


	if (Trim(reportListTmp[2, reportListTitleCol["照會單號"]])=AccNo){


		loc:=acc_location(RisListRowsAcc[2])


		mouseclick,l,% loc.x+100,% loc.y+10,2,0


	}


}





singleClick:


LV_GetText(getExamName, priorRow, colNo.ExamName)


ToolTip % getExamName


SetTimer, ToolTip, -2000


return





WrapText(str, WrapLen=25){


	s:="", l:=StrLen(str)


	Loop % q:=Floor(l/WrapLen) 


		s.=SubStr(str, WrapLen*(A_Index-1)+1, WrapLen) "`n"


	


	if (l-q*WrapLen<4)


		s:=SubStr(s, 1, -1)


	s.= SubStr(str, WrapLen*q+1) 


	return s


}





~LButton:


ToolTip


return





ToolTip:


ToolTip


return





GuiClose:


OnExit:


;~ esc::


searchingTh.terminate()


for k,v in openedIE


	try


	v.quit()


ExitApp








extractTitleCol(ByRef reportListFirstRow, ByRef reportListTitleCol){


	for k,v in reportListFirstRow


		reportListTitleCol[v]:=k


}








pointsDef:


pointsArr:={"CT With/Without Contrast-Chest": 5035


	, "CT With Contrast-Chest": 4560


	, "CT Without Contrast-Chest": 3800 


	, "Low dose lung cancer screening CT": 6000 


	, "Low dose lung cancer screening CT for employee(N Hospital)": 6000 


	, "CT Without Contrast for low dose lung cancer screening": 6000 }





return





loadHx:


hxFile:=A_ScriptDir "\RisListInfo.txt"


fileread,RisListInfoTxt,% hxFile


RisListInfo:=[]


Loop,parse,RisListInfoTxt,`n,`r


	if RegExMatch(A_LoopField, "i)([TY]\w{9}\d),(\d+),(\d),(\d)", match)


		RisListInfo[match1]:={parts: match2, mets: match3, op: match4}


return














#IfWinActive,ahk_exe Menu.exe


~*F3::


F3:


if urgentReportClick=1


	return


settimer,activate,-500


return


#IfWinActive





#IfWinActive,simple RIS ahk_class AutoHotkeyGUI


~*F3::


gosub F3


return


#IfWinActive








activate:


winactivate,ahk_id %guihwnd%


WinGetPos,x,y,w,h,ahk_id %guihwnd%


MouseMove,% x+Floor(w/2),% y+30,0


return