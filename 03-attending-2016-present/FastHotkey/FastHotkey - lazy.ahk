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
;~ #NoTrayIcon
#include <DoublyLinkedList>
#include <WM_COPYDATA>
#include <SetWindowsHookEx>
#include <Edit>
#include <HotstringEnhancer>
StringCaseSense,On


thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))
,dwData:=197
,OnMessage(0x4a, "ON_WM_COPYDATA")
,OnMessage(0x10101, "exit")
,hHookKeybd := SetWindowsHookEx(WH_KEYBOARD_LL	:= 13, RegisterCallback("__Keyboard", "Fast"))
,hHookMouse := SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("__MouseMove", "Fast"))
args:=[]
Loop %0%
    args.push(%a_index%)

shiftPairLow:="``1234567890-=[]\;',./"
,shiftPairHigh:="~!@#$%^&*()_+{}|:""<>?"
, specialChars:="``!@#$%^&*()_+-={}|[]\:"";'<>?,./"
, shiftPair:={}
Loop,Parse,shiftPairLow
    shiftPair["" A_LoopField]:=SubStr(shiftPairHigh, A_Index,1)

; -()[]{}:;'"/\,.?!`n `t
EndChars:=" - ( ) [ ] { `} `: `; `' "" / \ , . ? ! Enter Space Tab "
,EndCharsRegex:="[\-\(\)\[\]\{\}\:\;\'\""\/\\\,\.\?\!\s]"
,NonEndCharsRegex:="[^\-\(\)\[\]\{\}\:\;\'\""\/\\\,\.\?\!\s]"

keypair:=CSobj(), options:=CSobj()
, keypairA:=CSobj() ; match everywhere

keypair["btw"]:="by the way"
keypairA["intus"]:="intussusception"
, options["intus"]:="?"
cache:=""
Keys:=[]
listHotstrings("G:\scripts\radiology\ych_xr.ahk", fullscript, AllHotstringInfo, collideHotstring)
ParseHotstring(AllHotstringInfo)
gosub reset
;~ for k in keypair.Keys()
    ;~ Keys.push(k)
matchListSeq:= new MatchListSeqClass(Keys)
Q:=(new Queue)
;~ EndChars:=" - ( ) [ ] { } `: `; ' "" / \ , . ? ! Enter Tab Space Escape PgDn PgUp Up Down Left Right Home Del "
;~ run, % """" RegExReplace(A_ScriptFullPath, "i).ahk$", ".exe") """ -bgloop -hwnd" thisHwnd,,,bgpid
;~ SetTimer,debug,100
return

On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
    
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,str := StrGet(lpData)
	
	;~ str:=lpData
	
	If  (dwData = 0x19) ; CMD_CURRENTPOSITION
	{
		try
            ParseHotstring(jxon_load(str))
		 
        
	}
}

ParseHotstring(AllHotstring){
    global keypar,options,keypairA,Keys
    for k,v in AllHotstring {
            if (v.Type!="hotstring")
                continue
            if keypair.Exists(v.trigger) || keypairA.Exists(v.trigger)
                continue
            s:=v.settings v.settings2
            var:=InStr(s,"?")?"keypairA":"keypair"
            %var%["" v.trigger]:=v.value
            if !InStr(s, "c1", false)
                %var%["" StringUpperFirst(v.trigger)]:=StringUpperFirst(v.value)
                ,%var%["" StringUpper(v.trigger)]:=StringUpper(v.value)
            
            
            options["" v.trigger]:=s
        }
        for k in keypair.Keys()
            Keys.push(k)
}


;~ StringUpper(ByRef str){
    ;~ stringupper,s,str
    ;~ return s
;~ }

;~ StringUpperFirst(ByRef str){
    ;~ stringupper,s,% SubStr(str,1,1)
    ;~ return s SubStr(str,2)
;~ }
__MouseMove(nCode, wParam, lParam){
	If nCode<0
		return CallNextHookEx(nCode, wParam, lParam)
	;~ x:=NumGet(lParam+0, 0, "int")
	;~ ,y:=NumGet(lParam+0, 4, "int")
	
	;~ if(wParam=0x200){  ;WM_MOUSEMOVE 
	;~ }else if(wParam=0x201){ ; WM_LBUTTONDOWN
	;~ }else if(wParam=0x202){ ; WM_LBUTTONUP
	;~ }else if(wParam=0x204){ ; WM_RBUTTONDOWN 
	;~ }else if(wParam=0x205){ ; WM_RBUTTONUP  
	;~ }else if(wParam=0x20A){ ; WM_MOUSEWHEEL 
	;~ }else if(wParam=0x20E){ ; WM_MOUSEHWHEEL  
	;~ }
    if (wParam=0x201 || wParam=0x204){
        gosub reset
    }
	
	Return CallNextHookEx(nCode, wParam, lParam)
}

__Keyboard(nCode, wParam, lParam)
{
	Critical
    global specialChars, Q, shiftPair, shiftPairLow, EndChars, noMatch, cache, KeyName, ending
    static numpadPair:={dot:".", mult:"*", div: "/", add:"+", sub:"-"}
	SetFormat, Integer, H
	If ((wParam = 0x100)  ; WM_KEYDOWN
	|| (wParam = 0x101))  ; WM_KEYUP
	{
        if GetKeyState("LCtrl") || GetKeyState("RCtrl") || GetKeyState("Alt") || GetKeyState("Shift") || GetKeyState("LWin") || GetKeyState("RWin") || GetKeyState("CapsLock")
            Return CallNextHookEx(nCode, wParam, lParam)
        
		KeyName := GetKeyName("vk" NumGet(lParam+0, 0))
		
        StringReplace,KeyName,KeyName,Numpad
        if numpadPair.haskey(KeyName)
            KeyName:=numpadPair[KeyName]
        
        matched:=false
        if StrLen(KeyName)=1 {
            if (KeyName~="[a-z]"){
                if GetKeyState("Shift") || GetKeyState("Capslock", "T")
                    StringUpper,KeyName,KeyName
                matched:=true
            }else if (KeyName~="[A-Z]"){
                if GetKeyState("Shift") && !GetKeyState("Capslock", "T")
                    StringLower,KeyName,KeyName
                matched:=true
            }else if InStr(shiftPairLow, KeyName, false){
                 if GetKeyState("Shift")
                    KeyName:=shiftPair[KeyName]
                matched:=true
            }else if InStr(shiftPairHigh, KeyName, false){
                matched:=true
            }
        }
        ;~ Tooltip, % KeyName " Down" 
        
        ;~ if InStr(EndChars, " " KeyName " "){
            
        ;~ }else if(matched){
        if InStr(EndChars, " " KeyName " ", false) || matched || (KeyName="Backspace") {
            if(wParam==0x100){
                if (KeyName="Backspace"){
                    if (cache="")
                        sendbs(1)
                    else
                        cache:=SubStr(cache,1,-1)
                }else if InStr(EndChars, " " KeyName " ", false){
                    ending:=true
                    gosub hk
                }else{
                    cache.=KeyName
                    gosub hk
                }
                
                ;~ Q.enqueue(KeyName)
                ;~ SetTimer,hk,-1
            }
            
            return 1
        }

        ;~ }
        
	}
    
    
	
    gosub reset
    ;~ noMatch:=false
    return CallNextHookEx(nCode, wParam, lParam)
}
;intussusception this is a test by the way a. 
hk:
Critical
RegExMatch(cache, "s)(" NonEndCharsRegex "+)$", match)
, key:=match1
, buffer:=SubStr(cache, 1, (-1)*StrLen(key))
if (ending){
    sendStr(buffer)
    if (keypair.Exists(key)){
        trigger2(key, keypair[key], KeyName, options[key])
    }else{
        sendStr(key), sendch(KeyName)
    }
    cache:=""
}else if (keypairA.Exists(key)){
    sendStr(buffer), trigger2(key, keypairA[key], "", options[key])
    ,cache:=""
}
ending:=false
return


debug:
ToolTip % buffer "`n" sent "`n" noMatch  "`n`n" exploreobj(matchListSeq.matchLists)
return
;~ abcd     abcdefg  g ba ba  abcd btw b by the way 000 by the way ;intus F3 
hk_old:
ch:=Q.dequeue()
;~ if (ch="Backspace")
    ;~ aaa:=1
if(ch="Escape")
    ExitApp
if InStr(EndChars, " " ch " ", false)
    gosub end
else
    gosub nonEnd
;~ Loop:
;~ SetTimer,,-1
return

;
reset:
sendStr(cache)
,cache:=""
return

reset_old:
buffer:=""
,matchListSeq.reset(), sent:=""
;~ gosub Loop
return

;b1 ;b;ba;by the way ;by the wa; ;by the way btdsasdf;by the way b ba


end:
if(noMatch){
    sendch(ch)
}else if (keypair.Exists(k:=sent buffer)){
    
    trigger(sent, buffer, k, keypair[k], ch, options[k])
    ;~ if InStr(o:=options[buffer], "B0", false)
        ;~ sendStr(SubStr(buffer, StrLen(sent)+1))
    ;~ else
        ;~ sendbs(StrLen(sent))
    ;~ sendStr(keypair[buffer])
    ;~ if !InStr(o, "O", false)
        ;~ sendch(ch)
}else{   
    sendStr(buffer)
    ,sendch(ch)
}
noMatch:=false
goto reset
return

;bbttww 

class MatchListSeqClass {
    __New(ByRef AllKeys){
        this.Keys:=AllKeys.clone()
        ,this.reset()
    }
    reset(){
        this.matchLists:=[this.Keys]
        ,this.ind:=1
        ,this.key:=""
    }
    AddChar(ch){
        locAt:=StrLen(this.key)+1
        ,newMatch:=[]
        for k,v in this.matchLists[this.ind]
            if SubStr(v, locAt, 1)=ch
                newMatch.push(v)
        this.matchLists.push(newMatch)
        ,this.ind++
        ,this.key.=ch
        return !!newMatch.maxindex()
        
    }
    AddChars(str){
        Loop,Parse,str
            this.AddChar(A_LoopField)
    }
    DelChars(n=1){
        Loop % n
            this.DelChar()
    }

    DelChar(){
        if (--this.ind<=1){
            this.reset()
            return false
        }
            
        this.matchLists.pop()
        ,this.key:=SubStr(this.key,1,-1)
        return !!this.matchLists[this.ind].maxindex()
    }
    
}

nonEnd:

    if (ch="Backspace"){
        if StrLen(buffer)>0 {
        
            buffer:=SubStr(buffer,1,-1)
            ,noMatch:=!matchListSeq.DelChar()
        }else if StrLen(sent){
            sent:=SubStr(sent,1,-1)
            ,noMatch:=!matchListSeq.DelChar()
            ,sendbs(1)
        }else{
            sendbs(1)
        }
        
        return        
    }
    
    if(keypairA.setCapacity(0)>0){ 
        for k in keypairA.Keys()
            if InStr(sent buffer ch, k){
                trigger(sent, buffer ch, k, keypairA[k], "", options[k])
                goto reset
            }
    }
    ;intu;i
    
    if(noMatch){
        sendStr(ch)
    }else{
        buffer.=ch
        ,noMatch:=!matchListSeq.AddChar(ch)
        
        if !noMatch && InStr(o:=options[k:=sent buffer], "*") {
            ;~ sendStr(keypair[buffer])
            trigger(sent, buffer, k, keypair[k], "", o)
            goto reset
        }
        
        if (noMatch){
            sendStr(buffer)
            ,buffer:=""
        }
            
    }

;~ ToolTip % buffer "`n" len "`n`n" exploreobj(matchList)
return

sendch(ByRef ch){
    ;~ static pair:={Enter: "`r`n", Space: " ", Tab: "`t"}
    static pair:={Space: " ", Tab: "`t"}
    if (ch="")
        return
        ;~ send {%ch%}
    if pair.haskey(ch)
        Edit_InsertText(GetFocusedHwnd(), pair[ch])
    else
        send {%ch%}
}

sendStr(ByRef str){
    ;~ global sent
    if str=
        return
    ;~ sent.=str
    ;~ send % str
    Edit_InsertText(GetFocusedHwnd(), str)
}

sendbs(len){
    if len<1
        return
    ;~ send {bs %len%}
    hwnd:=GetFocusedHwnd()
    Loop % len
        Edit_DeleteText(hwnd)
}
trigger2(key, str, ch, options){
    
    if InStr(options, "B0", false)
        sendStr(key str)
    else 
        sendStr(str)
    
    if !InStr(options, "*")
        sendch(ch)
}
trigger(sent, buffer, key, str, ch, options){
    
    if InStr(options, "B0", false)
        sendStr(buffer)
    else{
        if (len:=StrLen(key)-StrLen(buffer))>0
            sendbs(len)
        else
            sendStr(SubStr(buffer,1,Abs(len)))
    }
    
    sendStr(str)
    
    if !InStr(options, "*")
        sendch(ch)
}

exit(){
    ExitApp
}

esc::
exit:
OnExit:
PostMessage,0x10101,,,,ahk_pid %bgpid%
process,Close,%bgpid%
UnhookWindowsHookEx(hHookKeybd)
ExitApp

CSobj() {
   static base := object("_NewEnum","__NewEnum", "Next","__Next", "__Set","__Setter", "__Get","__Getter", "Exists", "__Exists", "Keys", "__Keys")
   return, object("__sd_obj__", ComObjCreate("Scripting.Dictionary"), "base", base)
}
    __Exists(self, key){
        return (self.__sd_obj__.Exists(key)=-1)
    }
    __Keys(self){
        return (self.__sd_obj__.Keys)
    }
   __Getter(self, key) {
      return, self.__sd_obj__.item(key)
   }
   __Setter(self, key, value) {
      self.__sd_obj__.item(key) := value
      return, false
   }
   __NewEnum(self) {
      return, self
   }
   __Next(self, ByRef key = "", ByRef val = "") {
      static Enum
      if not Enum
         Enum := self.__sd_obj__._NewEnum
      if Not Enum[key], val:=self[key]
         return, Enum:=false
      return, true
   }