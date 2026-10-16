#include <HotstringEnhancer>
#include <hasVal>


;~ test=
;~ (%
;~ :*:BRA0::
;~ send % "Mild brain atrophy with dilated sulci, fissures and ventricles. ``r``n" bullet
;~ return
;~ ::gwj::gray-white matter junction
;~ ::gwj::gray-white matter junction2
;~ )

root:=SubStr(A_ScriptDir, 1,1)

MakeFastHotkey(root ":\scripts\radiology\ych_XR.ahk", A_ScriptDir "\test.ahk")

EscapeQuote(ByRef s, escapeLineBreak=false){
    StringReplace,ss,s,`",`"`", A
    if escapeLineBreak
        ss:=RegExReplace(ss,"[\r\n]", "``n")
    return ss
}
MakeFastHotkey(inFile, outFile=""){
    ;~ global test
    if outFile=
        outFile:=SubStr(inFile, 1,-4) "_Fast.ahk"
    
    tmp:=inFile ".tmp"
    fileread,script,% inFile
    ;~ script:=test
    script:="#include " A_ScriptDir "\fasthotkey_class.ahk`n" script
    FileDelete,% tmp
    FileAppend,% script,% tmp,utf-8
    a:=listHotstrings(tmp, fullscript:=[], AllHotstringInfo:=[], collideHotstring:=[])
    FileDelete,% tmp
    clipboard:=fullscript
    AllLines:=[]
    Loop,Parse,fullscript,`n,`r
        AllLines.push(A_LoopField)

    newscript:=AllLines.clone()
    Labels:=[]
    fhctext:="__FH:=new FastHotkey_Class`n"

    for k, hs in AllHotstringInfo {
        line1:=hs.Line[1]
        ,line2:=hs.Line[2]
        
        str:=hs.value
        ,str:=RegExReplace(str, "i)\{space\}", " ")
        ,str:=RegExReplace(str, "i)\{enter\}", "`r`n")
        ,str:=RegExReplace(str, "i)\{tab\}", "`t")
        ,str:=RegExReplace(str, "i)\{(\W)\}", "``$1")
        ,hs.value:=str
        hasSpecial:=(str~="\{[\w \+]+\}")

        if(hs.Type="directive"){
            if InStr(hs.value, "EndChars"){
                Endchars:=RegExReplace(hs.value, "i)^EndChars +", "")
                ec:=""
                Loop,Parse,Endchars
                    if A_LoopField in `;
                        ec.="``" A_LoopField
                    else 
                        ec.=A_LoopField
                fhctext.="__FH.SetEndChars(""" EscapeQuote(ec) """)`n"
            }else if !InStr(hs.value, "NoMouse"){
                fhctext.="__FH.globalOptions:=""" EscapeQuote(hs.value) """`n"
            }
            
        }else if (hs.Type="hotstring") && !hasSpecial {
            settings:=hs.settings=""?"":",""" EscapeQuote(hs.settings) """"
        
                newscript[line1]:="`;`;`;`; one line hs `;`;`;`;"
                ,fhctext.="__FH.AddHotstring(""" EscapeQuote(hs.trigger) """,""" EscapeQuote(hs.value, 1) """" settings ")`n"
        }else if hasSpecial || (hs.Type="hotstring_section"){
            trigger:=hs.trigger
            settings:=hs.settings hs.settings2
            Loop,Parse,settings
                trigger.="_" Asc(A_LoopField)
            
            while hasVal(Labels, trigger)
                trigger.="_"
            settings:=hs.settings=""?"":",""" EscapeQuote(hs.settings) """"
            newscript[hs.line]:=trigger ":"
            ,fhctext.="__FH.AddHotstring(""" EscapeQuote(hs.trigger) """,""__sub__" EscapeQuote(trigger) """" settings ")`n"
        
        }
        
    }
   
    for k,v in newscript
        if !InStr(v, "`;`;`;`; one line hs `;`;`;`;")
            fhctext.=v "`n"
    
    if FileExist(outFile)
        FileDelete % outFile
    FileAppend,% fhctext, % outFile, utf-8
}


ExitApp
esc::ExitApp