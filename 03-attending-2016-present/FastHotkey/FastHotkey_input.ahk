#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Ignore
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
StringCaseSense,On

keypair:=CSobj(), options:=CSobj()
keypair["btw"]:="by the way"

Keys:=[]
gosub reset
for k in keypair.Keys()
    Keys.push(k)
Q:=CriticalObject(new Queue)
,EndKeys:="{""}{$}{%}{&}{'}{(}{)}{*}{,}{-}{.}{/}{0}{1}{2}{3}{4}{5}{6}{7}{8}{9}{:}{;}{<}{=}{>}{?}{@}{[}{\}{]}{_}{``}{a}{b}{c}{d}{e}{f}{g}{h}{i}{j}{k}{l}{m}{n}{o}{p}{q}{r}{s}{t}{u}{v}{w}{x}{y}{z}{{}{|}{}}{~}{Escape}{Enter}{Space}{PgDn}{PgUp}{Up}{Down}{Left}{Right}{Home}{Del}{bs}{PrintScreen}{Tab}"
EndChars:=" - ( ) [ ] { } `: `; ' "" / \ , . ? ! Enter Tab Space Escape PgDn PgUp Up Down Left Right Home Del "
ahkthread("
(%
#persistent
SetBatchLines, -1
Alias(EndKeys, " getvar(EndKeys) ")
,Q:=CriticalObject(" (&Q) ")
Loop {
    Input, LastKey, I E L1, %EndKeys%
    Q.enqueue(SubStr(ErrorLevel,8))
}
)")
SetTimer,hk,1
return

hk:
if !Q.length
    return
    ;~ goto Loop
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


reset:
buffer:="", len:=0
,matchList:=[]
;~ gosub Loop
return




end:
if (keypair.Exists(buffer)){
    sendStr(keypair[buffer])
    if !InStr(options[buffer], "O", false)
        sendch(ch)
}else{
    sendStr(buffer)
    sendch(ch)
}
noMatch:=false
goto reset
return

nonEnd:

    if (ch="Backspace"){
        if(len=0)
            sendch("bs")
        else{
            if (--len)=0 {
                goto reset
            }else{
                buffer:=SubStr(buffer,1,-1)
                ,matchList.pop()
            }
        }
            
    }else if(noMatch){
        sendch(ch)
    }else{
        buffer.=ch, len++
        
        if (o:=options.Exists(buffer)) && InStr(o, "*") {
            sendStr(keypair[buffer])
            goto reset
        }
        
        if !(ind:=matchList.maxindex())
            matchList.push(Keys.clone())
        
        newMatchList:=[]
        for k,v in matchList[ind?ind:1]
            if SubStr(v, len, 1)=ch
                newMatchList.push(v)
        
        if !newMatchList.maxindex(){
            sendStr(buffer)
            ,noMatch:=true
        } else
            matchList.push(newMatchList.clone())
    }

;~ ToolTip % buffer "`n" len "`n`n" exploreobj(matchList)
return

sendch(ByRef ch){
    send {%ch%}
}

sendStr(ByRef str){
    send % str
}

esc::
OnExit:
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