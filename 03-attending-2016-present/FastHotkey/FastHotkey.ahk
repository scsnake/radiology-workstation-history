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
args:=[]
Loop %0%
    args.push(%a_index%)

hotkeyPrefix := "$", typed:="", keyTypes := {"symbols": "!""#$%&()*+,-.:;<=>?@[/]^_``{|}~", "num": "0123456789", "alpha":"abcdefghijklmnopqrstuvwxyz", "other": "backspace,Return,Tab,Space", "breakKeys":"Left,Right,Up,Down,Home,End,RButton,LButton,WheelDown,WheelUp,f1,f2,f3,f4,f5,f6,f7,f8,f9,f6,f7,f9,f10,f11,f12", "numpad":"Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"}, effect := {"Return" : "`n", "Tab":A_Tab, "Space": A_Space, "Enter":"`n", "Dot": ".", "Div":"/", "Mult":"*", "Add":"+", "Sub":"-"}
;Binds the keys to watch for triggers.
for k,v in ["symbols", "num", "alpha"]
{
    ;alphanumeric/symbols
    v := keytypes[v]
    Loop,Parse, v
        Hotkey,%hotkeyPrefix%%A_LoopField%,__hotstring
}

v := keytypes.alpha
Loop,Parse, v
    Hotkey, %hotkeyPrefix%+%A_Loopfield%,__hotstring
for k,v in ["other", "breakkeys", "numpad"]
{
    ;comma separated values
    v := keytypes[v]
    Loop,Parse, v,`,
        Hotkey,%hotkeyPrefix%%A_LoopField%,__hotstring
}

; -()[]{}:;'"/\,.?!`n `t
EndChars:=" - ( ) [ ] { `} `: `; `' "" / \ , . ? ! Enter Space Tab "

nonEndCharsRegex:=""
Loop,parse,EndChars,%a_space%
    if StrLen(A_LoopField)==1
        nonEndCharsRegex.="\" A_LoopField
nonEndCharsRegex:="[^" nonEndCharsReg "\s]"

keypair:=CSobj(), options:=CSobj()
, keypairA:=CSobj() ; match everywhere

keypair["btw"]:="by the way"
,keypair["btw1"]:="by the way,"
,options["btw1"]:="*"
,keypairA["intus"]:="intussusception"
, options["intus"]:="?"

Keys:=[]
;~ listHotstrings("G:\scripts\radiology\ych_xr.ahk", fullscript, AllHotstringInfo, collideHotstring)
;~ ParseHotstring(AllHotstringInfo)
gosub reset
for k in keypair.Keys()
    Keys.push(k)
matchListSeq:= new MatchListSeqClass(Keys)
Q:=(new Queue)
;~ EndChars:=" - ( ) [ ] { } `: `; ' "" / \ , . ? ! Enter Tab Space Escape PgDn PgUp Up Down Left Right Home Del "
;~ run, % """" RegExReplace(A_ScriptFullPath, "i).ahk$", ".exe") """ -bgloop -hwnd" thisHwnd,,,bgpid
SetTimer,debug,100
return

__hotstring:
Hotkey := SubStr(A_ThisHotkey,2)
if (StrLen(Hotkey) == 2 && Substr(Hotkey,1,1) == "+" && Instr(keyTypes.alpha, Substr(Hotkey, 2,1), false)){
    Hotkey := Substr(Hotkey,2)
    if (!GetKeyState("Capslock", "T")){
        StringUpper, Hotkey,Hotkey
    }
}

shiftState := GetKeyState("Shift", "P")
,uppercase :=  GetKeyState("Capslock", "T") ? !shiftState : shiftState 
;If capslock is down, shift's function is reversed.(ie pressing shift and a key while capslock is on will provide the lowercase key)
if (uppercase && Instr(keyTypes.alpha, Hotkey)){
    StringUpper, Hotkey,Hotkey
}

ch:= hotkey
gosub hk
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




debug:
ToolTip % "buffer:" buffer ".`nsent:" sent ".`nvalid:" validStr ".`nMatch:" !noMatch  "`n`n" exploreobj(matchListSeq.matchLists)
return
;~ abcd     abcdefg  g ba ba  abcd btw b by the way 000 by the way ;intus F3 by the way, btw1
hk:
;~ ch:=Q.dequeue()
;~ if (ch="Backspace")
    ;~ aaa:=1
if(ch="Escape")
    ExitApp
if InStr(EndChars, " " ch " ", false)
    gosub end
else if StrLen(ch)>1 && !(ch~="i)backspace|bs"){
    sendStr(buffer)
    ,sendkey(ch)
    ,validStr:=""
    goto reset
}else
    gosub nonEnd
;~ Loop:
;~ SetTimer,,-1
return

;
reset:
buffer:=""
,matchListSeq.reset(), sent:=""
;~ gosub Loop
return

;b1 ;b;ba;by the way ;by the wa; ;by the way btdsasdf;by the way b babtw by the way  bt by the way	
;intussusception btw intussuscep intuintussusception by the way by the way    btw th intussusception
end:
if (validStr!="" && RegExMatch(validStrAll:=validStr buffer, nonEndCharsRegex "+$", match) && keypair.Exists(k:=match) ){
    if (l:=StrLen(k)-StrLen(buffer))>0
        sendbs(l)
    else
        sendStr(SubStr(buffer, 1, Abs(l)))
    trigger("", "", "", keypair[k], ch, options[k])
    
}else if(noMatch){
    sendch(ch)
}else if (keypair.Exists(k:=sent buffer)) {
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
;intussusception btw  intussuintussusceptintussusceptions intuintussusception intussusceptiby the way 
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
            }else if  (validStr!="" && RegExMatch(validStrAll:=validStr buffer ch, nonEndCharsRegex "+$", match) && InStr(match, k) ){
                 if (l:=StrLen(k)-StrLen(buffer ch))>0
                    sendbs(l)
                else
                    sendStr(SubStr(buffer ch, 1, Abs(l)))
                trigger("", "", "", keypairA[k], "", options[k])
                
                goto reset
            }
    }
    ;intu;i by the way by the way   btw1    btw1   by the way  by the way, a b c d e f g h i jk l m n op qr s btw
    
     if  (validStr!="" && RegExMatch(validStrAll:=validStr buffer ch, nonEndCharsRegex "+$", match) && InStr(o:=options[k:=match], "*") ){
        if (l:=StrLen(k)-StrLen(buffer ch))>0
            sendbs(l)
        else
            sendStr(SubStr(buffer ch, 1, Abs(l)))
        trigger("", "", "", keypair[k], "", o)
        goto reset
    }else if(noMatch){
        sendStr(ch)
    }else{
        buffer.=ch
        ,noMatch:=!matchListSeq.AddChar(ch)
        
        if !noMatch && InStr(o:=options[k:=sent buffer], "*") {
            ;~ sendStr(keypair[buffer])
            trigger(sent, buffer, k, keypair[k], "", o)
            
            goto reset
        }else if  (validStr!="" && RegExMatch(validStrAll:=validStr buffer, nonEndCharsRegex "+$", match) && InStr(o:=options[k:=match], "*") ){
            if (l:=StrLen(k)-StrLen(buffer))>0
                sendbs(l)
            else
                sendStr(SubStr(buffer, 1, Abs(l)))
            trigger("", "", "", keypair[k], "", o)
            goto reset
        }
        
        if (noMatch){
            sendStr(buffer)
            ,buffer:=""
        }
            
    }

;~ ToolTip % buffer "`n" len "`n`n" exploreobj(matchList)
return

sendkey(ByRef ch){
    try
        SendInput % "{" ch "}"
}

sendch(ByRef ch){
    static pair:={Enter: "`r`n", Space: " ", Tab: "`t"}
    global sent, validStr
    if ch=
        return
        ;~ send {%ch%}
    ;~ Edit_InsertText(GetFocusedHwnd(), c:=pair.haskey(ch)?pair[ch]:ch), sent.=c, validStr.=c
    c:=pair.haskey(ch)?pair[ch]:ch
    ,sent.=c,validStr.=c
    if c=" "
        Edit_InsertText(GetFocusedHwnd(), " ")
    else 
        sendkey(ch)
} 
sendStr(ByRef str){
    global sent, validStr
    if str=
        return
    sent.=str, validStr.=str
    ;~ send % str
    ,Edit_InsertText(GetFocusedHwnd(), str)
}

sendbs(len){
    global validStr
    if len<1
        return
    ;~ send {bs %len%}
    hwnd:=GetFocusedHwnd()
    Loop % len
        Edit_DeleteText(hwnd)
    StringTrimRight,validStr,validStr,% len
}

trigger(sent, buffer, key, str, ch, options){
    global validStr
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
    validStr:=""
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