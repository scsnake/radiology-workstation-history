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
;~ onexit,onexit
;~ #NoTrayIcon
;~ #include <DoublyLinkedList>
;~ #include <WM_COPYDATA>
;~ #include <SetWindowsHookEx>
#include <Edit>
;~ #include <HotstringEnhancer>
;~ StringCaseSense,On
;zzzzby the way 
;~ gosub main
;~ return


;~ main:
;~ test:=[["btw", "by the way", ""]
    ;~ ,["btw", "by the way,", ""]
    ;~ ,["bTw", "by The way", "C"]
    ;~ ,["intus", "intussusception", "?"]
    ;~ ,["zZ", "zzzz", "?C"]]

;~ FastHotkey:=new FastHotkey_Class
;~ for k,v in test
    ;~ FastHotkey.AddHotstring(v[1], v[2], v[3])
;~ SetTimer,debug,100
;~ return

class FastHotkey_Class {
    ;~ static hotkeyPrefix := "$", typed:="", keyTypes := {"symbols": "!""#$%&()*+,-.:;<=>?@[/]^_``{|}~", "num": "0123456789", "alpha":"abcdefghijklmnopqrstuvwxyz", "other": "backspace,Return,Tab,Space", "breakKeys":"Left,Right,Up,Down,Home,End,RButton,LButton,WheelDown,WheelUp,f1,f2,f3,f4,f5,f6,f7,f8,f9,f6,f7,f9,f10,f11,f12", "numpad":"Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"}, effect := {"Return" : "`n", "Tab":A_Tab, "Space": A_Space, "Enter":"`n", "Dot": ".", "Div":"/", "Mult":"*", "Add":"+", "Sub":"-"}
    static hotkeyPrefix := "$", typed:="", keyTypes := {"symbols": "!""#$%&()*+,-.:;<=>?@[/]^_``{|}~", "num": "0123456789", "alpha":"abcdefghijklmnopqrstuvwxyz", "other": "backspace,Return,Tab,Space", "breakKeys":"Left,Right,Up,Down,Home,End,RButton,f1,f2,f3,f4,f5,f6,f7,f8,f9,f6,f7,f9,f10,f11,f12", "numpad":"Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"}, effect := {"Return" : "`n", "Tab":A_Tab, "Space": A_Space, "Enter":"`n", "Dot": ".", "Div":"/", "Mult":"*", "Add":"+", "Sub":"-"}
    static hs_options:=[["*0", "*"], ["?0", "?"], ["B0", "B"], ["C1", "C0", "C"], ["O0", "O"],  ["R0", "R"], ["SI", "SP", "SE"], ["Z0", "Z"]]
    static instance:=""
    
    __New() {
        ;Binds the keys to watch for triggers.
        if FastHotkey_Class.instance
            return FastHotkey_Class.instance
        hotkeyPrefix:=FastHotkey_Class.hotkeyPrefix
        
        for k,v in ["symbols", "num", "alpha"]
        {
            ;alphanumeric/symbols
            v := FastHotkey_Class.keytypes[v]
            Loop,Parse, v
                Hotkey,%hotkeyPrefix%%A_LoopField%,__FastHotkey_Class_hs
        }
        v := FastHotkey_Class.keytypes.alpha
        Loop,Parse, v
            Hotkey, %hotkeyPrefix%+%A_Loopfield%,__FastHotkey_Class_hs
        for k,v in ["other", "breakkeys", "numpad"]
        {
            ;comma separated values
            v := FastHotkey_Class.keytypes[v]
            Loop,Parse, v,`,
                Hotkey,%hotkeyPrefix%%A_LoopField%,__FastHotkey_Class_hs
        }
        ; -()[]{}:;'"/\,.?!`n `t
        this.EndChars:=" - ( ) [ ] { `} `: `; `' "" / \ , . ? ! Enter Space Tab "
        ,this.globalOptions:=""
        
        nonEndCharsRegex:=""
        Loop,parse,% this.EndChars,%a_space%
            if StrLen(A_LoopField)==1
                nonEndCharsRegex.="\" A_LoopField
        this.nonEndCharsRegex:="[^" nonEndCharsReg "\s]"        
        
        
        this.hs:={}
        ,this.hs_instant:={}
        ,this.hs_c :=CSobj() ; case-sensitive
        ,this.hs_instant_c:=CSobj()
        ;~ , this.options:=CSobj()
        this.has_instant_hs:=false
        
        this.buffer:=""
        ,this.matchListSeq:=new MatchListSeqClass
        ,this.sent:=""
        ,this.noMatch:=false
        ,FastHotkey_Class.instance:=this
       
    }
    
    __Delete() {
        FastHotkey_Class.instance:=""
    }
    
    SetEndChars(s){
        if s=
            return
        ret:=" "
        Loop,Parse,s
            if (A_LoopField="`n")
                ret.="Enter "
            else if(A_LoopField=" ")
                ret.="Space "
            else if (A_LoopField="`t")
                ret.="Tab "
            else
                ret.=A_LoopField " "
        this.EndChars :=ret    
    }
    ;
    type(thisHotkey){
        Hotkey := SubStr(thisHotkey,2)
        if InStr("," FastHotkey_Class.keyTypes.breakKeys ",", "," hotkey ","){
            return this.breakKey()
        }
        
        if (StrLen(Hotkey) == 2 && Substr(Hotkey,1,1) == "+" && Instr(FastHotkey_Class.keyTypes.alpha, Substr(Hotkey, 2,1), false)){
            Hotkey := Substr(Hotkey,2)
            if (!GetKeyState("Capslock", "T")){
                StringUpper, Hotkey,Hotkey
            }
        }

        shiftState := GetKeyState("Shift", "P")
        ,uppercase :=  GetKeyState("Capslock", "T") ? !shiftState : shiftState 
        ;If capslock is down, shift's function is reversed.(ie pressing shift and a key while capslock is on will provide the lowercase key)
        if (uppercase && Instr(FastHotkey_Class.keyTypes.alpha, Hotkey)){
            StringUpper, Hotkey,Hotkey
        }
        ;
        ch:=this.ch:=hotkey
        
        ;~ if(ch=="Escape")
            ;~ ExitApp
        if InStr(this.EndChars, " " ch " ")
            this.hs_end()
        else if StrLen(ch)>1 && !(ch~="i)backspace|bs"){
            this.sendStr(this.buffer)
            ,this.sendkey(ch)
            ,this.validStr:=""
            this.reset()
        }else
            this.hs_nonend()
        
        SetTimer,FastHotkey_debug,-1000
    }
    breakKeys(){
        this.sendStr(this.buffer)
        return this.reset()
    }
    hs_match(ByRef input){
        if this.hs_c.Exists(input)
            return this.hs_c["" input]
        else if this.hs.haskey(input) {
            return this.hs["" input]
        }
    }
    
    hs_instant_match(ByRef input){
        if this.hs_instant_c.Exists(input)
            return this.hs_instant_c["" input]
        else if this.hs_instant.haskey(input) {
            return this.hs_instant["" input]
        }
    }
    ;btw by the way by the way,intussusceptionintusb by the way by the way 
    hs_end(){
        ch:=this.ch, buffer:=this.buffer, sent:=this.sent
        if (this.validStr!="" && RegExMatch(validStrAll:=this.validStr buffer, this.nonEndCharsRegex "+$", match) && (hs_match:=this.hs_match(k:=match))){
            
            if (l:=StrLen(k)-StrLen(buffer))>0
                this.sendbs(l)
            else
                this.sendStr(SubStr(buffer, 1, Abs(l)))
            this.trigger("", "", "", hs_match.v, ch, hs_match.o)
            
        }else if(this.noMatch){
            this.sendch(ch)
        }else if (hs_match:=this.hs_match(k:=sent buffer)) {
           this.trigger(sent, buffer, k, hs_match.v, ch, hs_match.o)
            ;
            ;~ if InStr(o:=options[buffer], "B0", false)
                ;~ sendStr(SubStr(buffer, StrLen(sent)+1))
            ;~ else
                ;~ sendbs(StrLen(sent))
            ;~ sendStr(keypair[buffer])
            ;~ if !InStr(o, "O", false)
                ;~ sendch(ch)
        }else{   
            this.sendStr(buffer)
            ,this.sendch(ch)
        }
        this.noMatch:=false
        ,this.reset()
    }
    
    hs_nonend(){
        ch:=this.ch, buffer:=this.buffer, noMatch:=this.noMatch, sent:=this.sent, validStr:=this.validStr
        if (ch="Backspace"){
            if StrLen(buffer)>0 {
            
                this.buffer:=SubStr(buffer,1,-1)
                ,this.noMatch:=!this.matchListSeq.DelChar()
            }else if StrLen(sent){
                this.sent:=SubStr(sent,1,-1)
                ,this.noMatch:=!matchListSeq.DelChar()
                ,this.sendbs(1)
            }else{
                this.sendbs(1)
            }
            
            return        
        }
        ;intussusceptionby the way 
        if(this.has_instant_hs){ 
            ;~ ToolTip % sent buffer ch
            if hs_match:=this.hs_instant_match(k:=sent buffer ch) 
                return this.trigger(sent, buffer ch, k, hs_match.v, "", hs_match.o)
                ,this.reset()
            else if  (validStr!="" && RegExMatch(validStrAll:=validStr buffer ch, this.nonEndCharsRegex "+$", match) 
                && (hs_match:=this.hs_instant_match(k:=match)) ){
                     if (l:=StrLen(k)-StrLen(buffer ch))>0
                        this.sendbs(l)
                    else
                        this.sendStr(SubStr(buffer ch, 1, Abs(l)))
                    this.trigger("", "", "", hs_match.v, "", hs_match.o)
                    
                    return this.reset()
                }
        }
        ;
         if  (validStr!="" && RegExMatch(validStrAll:=validStr buffer ch, this.nonEndCharsRegex "+$", match) 
            && (hs_match:=this.hs_match(k:=match)) && InStr(o:=hs_match.o, "*") ){
            if (l:=StrLen(k)-StrLen(buffer ch))>0
                this.sendbs(l)
            else
                this.sendStr(SubStr(buffer ch, 1, Abs(l)))
            this.trigger("", "", "", hs_match.v, "", o)
            return this.reset()
        }else if(this.noMatch){
            this.sendStr(ch)
        }else{
            buffer:=this.buffer.=ch
            ,noMatch:=this.noMatch:=!this.matchListSeq.AddChar(ch)
            ;
            ;
            if !noMatch && (hs_match:=this.hs_match(k:=sent buffer)) && InStr(o:=hs_match.o, "*") {
                ;~ sendStr(keypair[buffer])
                this.trigger(sent, buffer, k, hs_match.v, "", o)
                
                return this.reset()
            }else if  (validStr!="" && RegExMatch(validStrAll:=validStr buffer, this.nonEndCharsRegex "+$", match) 
                && (hs_match:=this.hs_match(k:=match)) && InStr(o:=hs_match.o, "*") ){
                if (l:=StrLen(k)-StrLen(buffer))>0
                    this.sendbs(l)
                else
                    this.sendStr(SubStr(buffer, 1, Abs(l)))
                this.trigger("", "", "", hs_match.v, "", o)
                return this.reset()
            }
            
            if (noMatch){
                this.sendStr(buffer)
                ,this.buffer:=""
            }
                
        }
        
    }
    
    sendkey(ByRef ch){
        try
            SendInput % "{" ch "}"
    }

    sendch(ByRef ch){
        static pair:={Enter: "`r`n", Space: " ", Tab: "`t"}
       
        if ch=
            return
            ;~ send {%ch%}
        ;~ Edit_InsertText(GetFocusedHwnd(), c:=pair.haskey(ch)?pair[ch]:ch), this.sent.=c, this.validStr.=c
        c:=pair.haskey(ch)?pair[ch]:ch
        ,this.sent.=c,this.validStr.=c
        if c=" "
            Edit_InsertText(GetFocusedHwnd(), " ")
        else 
            this.sendkey(ch)
    } 
    sendStr(ByRef str){
       
        if str=
            return
        
        ;~ str:=RegExReplace(str, "i)\{space\}", " ")
        ;~ str:=RegExReplace(str, "i)\{enter\}", "`r`n")
        ;~ str:=RegExReplace(str, "i)\{tab\}", "`t")
        this.sent.=str, this.validStr.=str
        ;~ send % str
        ,Edit_InsertText(GetFocusedHwnd(), str)
    }

    sendbs(len){
        validStr:=this.validStr
        if len<1
            return
        ;~ send {bs %len%}
        hwnd:=GetFocusedHwnd()
        Loop % len
            Edit_DeleteText(hwnd)
        StringTrimRight,validStr,validStr,% len
        this.validStr:=validStr
    }
    
    trigger(sent, buffer, key, str, ch, options){
        tooltip
        if InStr(options, "B0", false)
            this.sendStr(buffer)
        else{
            if (len:=StrLen(key)-StrLen(buffer))>0
                this.sendbs(len)
            else
                this.sendStr(SubStr(buffer,1,Abs(len)))
        }
        
        if (str~="^__sub__")
            try
                gosub % SubStr(str,8)
        else
            this.sendStr(str)
        
        if !InStr(options, "*")
            this.sendch(ch)
        this.validStr:=""
    }
    
    AddHotstring(trigger, string, options=""){

        options:=this.__CombineOptions(options)
        
        if this.has_trigger(trigger, options)
            return
        if InStr(options, "?")
            store:=(options ~= "i)C[^01]?")?this.hs_instant_c:this.hs_instant
            , this.has_instant_hs:=true
        else
            store:=(options ~= "i)C[^01]?")?this.hs_c:this.hs
        store["" trigger]:={v: "" string, o: options}
        
        ,this.matchListSeq.AddKey("" trigger)
    }
    
    has_trigger(ByRef trigger, options){
        if (options ~= "i)C[^01]?")
            return this.hs_c.Exists(trigger) || this.hs_instant_c.Exists(trigger)
        else
            return this.hs.haskey(trigger) || this.hs_instant.haskey(trigger) || this.hs_c.Exists(trigger) || this.hs_instant_c.Exists(trigger)
    }
    
    __CombineOptions(options){
        ret:=""
        for k, hs_options in FastHotkey_Class.hs_options {
            g:=l:=""
            for kk, o in hs_options {
                if !g && InStr(this.globalOptions, o)
                    g:=o
                if !l && InStr(options, o)
                    l:=o
            }
            if l!=
                ret.=l
            else if g!=
                ret.=g
        }
        for k, hs_options in ["i)K\d+", "i)P\d+"] {
            if RegExMatch(this.globalOptions, hs_options, match)
                ret.=match
            else if RegExMatch(options, hs_options, match)
                ret.=match
        }
        return ret
    }

    reset(){
        this.buffer:=""
        ,this.matchListSeq.reset()
        ,this.sent:=""
    }

    
    StringUpper(ByRef str){
        StringUpper,s,str
        return s
    }
    StringUpperFirst(ByRef str){
        if str=
            return
        s:=SubStr(str,1,1)
        StringUpper,s,s
        return s SubStr(str,2)
    }
    StringReplace(ByRef input, ByRef search, ByRef replace="", all=true){
        StringReplace,s,input,% search,% replace,% all?"ALL":""
        return s
    }
}



__FastHotkey_Class_hs:
FastHotkey_Class.instance.type(A_ThisHotkey)
return


FastHotkey_debug:
;~ s:="buffer sent validstr noMatch matchListSeq"
;~ Loop,parse,s,%a_space%
    ;~ %A_LoopField%:=FastHotkey_Class.instance[A_LoopField]
if (__b:=FastHotkey_Class.instance.buffer)!="" {
    __ml:=FastHotkey_Class.instance.matchListSeq.matchLists
    ToolTip % __b "`n`n" exploreobj(__ml[__ml.maxindex()])
}else{
    ToolTip 
}
;~ SetTimer,__tooltip,-2000
return

__tooltip:
ToolTip
return
class MatchListSeqClass {
    __New(ByRef AllKeys=""){
        
        this.Keys:=IsObject(AllKeys)?AllKeys.clone():[]
        this.reset()
    }
    
    AddKey(key){
        this.Keys.push(key)
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


;~ exit(){
    ;~ ExitApp
;~ }

;~ esc::
;~ exit:
;~ OnExit:
;~ PostMessage,0x10101,,,,ahk_pid %bgpid%
;~ process,Close,%bgpid%
;~ UnhookWindowsHookEx(hHookKeybd)
;~ ExitApp

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