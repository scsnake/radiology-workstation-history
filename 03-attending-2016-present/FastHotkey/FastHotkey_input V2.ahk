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
StringCaseSense,On

thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))
,dwData:=197
,OnMessage(0x4a, "ON_WM_COPYDATA")
,OnMessage(0x10101, "exit")

args:=[]
Loop %0%
    args.push(%a_index%)

EndKeys:="{""}{$}{%}{&}{'}{(}{)}{*}{,}{-}{.}{/}{0}{1}{2}{3}{4}{5}{6}{7}{8}{9}{:}{;}{<}{=}{>}{?}{@}{[}{\}{]}{_}{``}{a}{b}{c}{d}{e}{f}{g}{h}{i}{j}{k}{l}{m}{n}{o}{p}{q}{r}{s}{t}{u}{v}{w}{x}{y}{z}{{}{|}{}}{~}{Escape}{Enter}{Space}{PgDn}{PgUp}{Up}{Down}{Left}{Right}{Home}{Del}{bs}{PrintScreen}{Tab}"
Loop 12
    EndKeys.="{F" A_Index "}"

if HasVal(args, "-bgloop")
    goto bgloop

keypair:=CSobj(), options:=CSobj()
, keypairA:=CSobj() ; match everywhere

keypair["btw"]:="by the way"
keypairA["intus"]:="intussusception"
, options["intus"]:="?"

Keys:=[]
gosub reset
for k in keypair.Keys()
    Keys.push(k)
matchListSeq:= new MatchListSeqClass(Keys)
Q:=(new Queue)
EndChars:=" - ( ) [ ] { } `: `; ' "" / \ , . ? ! Enter Tab Space Escape PgDn PgUp Up Down Left Right Home Del "
run, % """" RegExReplace(A_ScriptFullPath, "i).ahk$", ".exe") """ -bgloop -hwnd" thisHwnd,,,bgpid
;~ SetTimer,debug,100
return

bgloop:
for k,v in args
    if RegExMatch(v, "i)-hwnd(\w+)", mainHwnd)
        break
Loop {
    Input, LastKey, I E L1, %EndKeys%
    ToolTip % LastKey "," ErrorLevel
    if !Send_WM_COPYDATA(mainHwnd1,dwData, SubStr(ErrorLevel,8))
        ExitApp
}
return

On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
    global Q
; dwData = Command
; cbData = String lenght
; lpData = String
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,str := StrGet(lpData)
	
	;~ str:=lpData
	
	If  (dwData = 197) ; CMD_CURRENTPOSITION
	{
		Q.enqueue(str)
        SetTimer,hk,-1
	}
}

debug:
ToolTip % buffer "`n" sent "`n" noMatch  "`n`n" exploreobj(matchListSeq.matchLists)
return
;~ abcd     abcdefg  g ba ba  abcd btw b by the way 000 by the way ;intus F3
hk:
ch:=Q.dequeue()
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
;by the way ;btw by the way bababy the way intus intu intussusception intussusception
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
    if ch!=
        send {%ch%}
}

sendStr(ByRef str){
    global sent
    if str=
        return
    sent.=str
    send % str
}

sendbs(len){
    if len<1
        return
    send {bs %len%}
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