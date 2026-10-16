#include <_RemoteBuf>
#include <SCI>
#include <CharWordPos>

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
            this.Buf.Open(len+1, this.hwnd)
            ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETTEXT,"PTR",this.Buf.size,"PTR",this.Buf.RemoteBuf)
            ,this.Buf.Read()
            Return StrGet(this.Buf.LocalBuf,"UTF-8")
        }else{
            return ""
        }
    }
    SetText(Text){
        ret:=StrPutVar(Text,str:="", "UTF-8")
        ,this.Buf.Open(ret, this.hwnd)
        ,this.Buf.Write(str,0,"UTF-8")
        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SETTEXT,"PTR",0,"PTR",this.Buf.RemoteBuf)
        
        return ret
    }
    InsertText(Text, pos=-1){
        if(Text="")
            return -1
        ret:=StrPutVar(Text,str:="", "UTF-8")
        ,this.Buf.Open(ret, this.hwnd)
        ,this.Buf.Write(str,0,"UTF-8")
        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_INSERTTEXT,"PTR",pos,"PTR",this.Buf.RemoteBuf)
        
    }
    _InsertText(Text, pos=-1){
        if(Text="")
            return -1
        CharToWordPos(oldText:=this.GetText(), pos=-1?(pos:=StrLen(oldText)):pos)
        ,ret:=StrPutVar(Text,str:="", "UTF-8")
        ,this.Buf.Open(ret, this.hwnd)
        ,this.Buf.Write(str,0,"UTF-8")
        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_INSERTTEXT,"PTR",pos,"PTR",this.Buf.RemoteBuf)
        
    }
    AddText(Text){ ;current position, move caret
        if(Text="")
            return -1
        ret:=StrPutVar(Text,str:="", "UTF-8")
        ,this.Buf.Open(ret, this.hwnd)
        ,this.Buf.Write(str,0,"UTF-8")
        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ADDTEXT,"PTR",StrLen(Text),"PTR",this.Buf.RemoteBuf)
        
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
            this.Buf.Open(len+1, this.hwnd)
            ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetSelText,"PTR",Buf.size,"PTR",this.Buf.RemoteBuf)
            ,this.Buf.Read()
            Return StrGet(this.Buf.LocalBuf,"UTF-8")
        }else{
            return ""
        }
    }
    
    GetLine(line=""){
        if(line="" || line=-1)
            line:=this.LINEFROMPOSITION()
        this.Buf.Open(this.LineLength(line)+1, this.hwnd)
        ,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetLine,"PTR",line,"PTR",this.Buf.RemoteBuf)
        ,this.Buf.Read()
        Return StrGet(this.Buf.LocalBuf,"UTF-8")
    }
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
    Do(command){
        if command is not integer
            command:=%command%
        try
            return DllCall("SendMessage","PTR",this.hwnd,"UINT", command,"PTR")
    }
}
