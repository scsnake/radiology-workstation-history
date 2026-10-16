#include <SCI>
#include <prettyReport>
#include <Edit>
#singleinstance force

/*
    ---------------------
    This is an example of how to highlight without selecting a pre-existing lexer.
    In this example we will manually tell scintilla which positions to color.

    In this case we use SCLEX_CONTAINER to tell scintilla that we will manually do the coloring.
    I set some random text in the control, set some styles and use the Search Label together with a simple search function
    To tell scintilla what to color.
*/

Text=
(
CT of the brain and neck without/with contrast enhancement shows:
- Brain atrophy with dilated sulci, fissures and ventricles. 
- No abnormal attenuation in the brain parenchyma. 
- Normal appearance of the cranial vault and skull base. 
- Small lymph nodes (<1cm) in bilateral neck. 
- Clear paranasal sinuses. 
- Clear bilateral mastoid air cells. 
- Clear nasopharynx and parapharyngeal space. 
)

Gui +LastFound
sci := new scintilla(WinExist())

; Set some options
sci.SetWrapMode(true), sci.SetLexer(SCLEX_CONTAINER), sci.StyleClearAll()
,sci.SetCodePage(65001)
,sci.AUTOCSETCASEINSENSITIVEBEHAVIOUR(1)
,sci.AUTOCSETSEPARATOR(0xA)
;~ MsgBox % sci.AUTOCGETSEPARATOR()
SciAutoCompleteList=
(
no definite
normal
)


; Change a style

;~ sci.StyleSetBack(32, 0x000000)
sci.StyleSetFore(SCLEX_CONTAINER, 0xDDDDDD), sci.StyleSetBack(SCLEX_CONTAINER, 0x000000), sci.StyleSetBold(SCLEX_CONTAINER, false)
,sci.StyleSetFore(STYLE_DEFAULT, 0xDDDDDD), sci.StyleSetBack(STYLE_DEFAULT, 0x000000), sci.StyleSetBold(STYLE_DEFAULT, false)
,sci.StyleSetFore(SCE_AHKL_USERDEFINED1, 0xFFFFFF), sci.StyleSetBack(SCE_AHKL_USERDEFINED1, 0x000000), sci.StyleSetBold(SCE_AHKL_USERDEFINED1, true)
,sci.SetCaretFore(0xFFFFFF)
,sci.SetText(unused, text),  sci.GrabFocus(), sci.Notify := "Notify", sci.SetMarginWidthN(1,0)

Gui, show, w600 h460
SetTimer, Search,-1
;~ settimer,repeat,1000
return

Notify(wParam, lParam, msg, hwnd, obj){
    global sci
    if (obj.scnCode = SCN_MODIFIED){
        SetTimer,Search,-1000 ; obj is in this case the scintilla object above. The obj.sc variable contains the latest character added to the control
    }
    if (obj.scnCode = SCN_CHARADDED){
        currentPos:=sci.GetCurrentPos()
        wordStartPos := sci.WordStartPosition(currentPos,true)
        if((len:=currentPos - wordStartPos)>0)
            SetTimerF("AutoComplete",-300,[len])
        else
            SetTimerF("AutoComplete",0)
    }
    return
}
AutoComplete(len){
    global
    sci.AutoCShow(len, lst:=SciAutoCompleteList)
}
return

;~ f::
;~ controlget,focused,hwnd,,scintilla1,A
;~ Edit_GetSel(focused, s, e)
;~ MsgBox % s "," e
;~ return

repeat:
sci.GetText(sci.GetLength()+1,text:="")
ToolTip % Text
return 

Search:
    /*
        Manually highlighting goes like this:
        You first have to tell scintilla where you are going to start highlighting and which bits you will highlight.
        That is done with StartStyling. Then you use SetStyling with the length of characters you whish to highlight and which style you want to use.
        
        All other code is just for the sake of demonstration and not really needed.
        The most important lines are 50-55.
    */
    ;~ Gui, Submit, Nohide
    
    sci.GetText(sci.GetLength()+1,text:="")
    
    if !sr
        sr:=new StyleRange(text)
    else
        sr.text:=text
    
    sr.ResetStyles()
    ;~ sr.AddStyleRegex("i)\bNo(rmal)?\b[^\.]*\.?", "UD1")
    sr.AddStyleRegex("i)\b(right|left|bilateral)\b","UD1")
	sr.AddStyleRegex("i)\bpost[- \w]+?changes?\b","UD1")
	sr.AddStyleRegex("i)\b(cysts?|(micro)?calcifications?|mild|minimal|small)\b", "UD1") ;light green
	
	sr.AddStyleRegex("i)\b(fractures?|moderate)\b", "UD1")
	sr.AddStyleRegex("i)\b(mass(es)?|nodules?|tumors?|lesions?|cancer|malignanc(y|ies)|metastas[ei]s|mets|severe|large|marked|total)\b", "UD1")
	sr.AddStyleRegex("i)\b(larger|enlarged|engorged|disten([st]ion|ded)|dilat(ed|ation)|more prominent|thicken(ing|ed)|ruptured?)\b", "UD1")

	;sentence
	sr.AddStyleRegex("i)\b(clear|normal|no (definite|obvious|significant)|non( |-)specific|spondylosis|degenerative|atherosclero(sis|tic)|fibrotic changes?)\b[^\.;]+[\.;]", "UD1")
    sr.ApplyToSCI(sci)
    /*
    ; Clear old matches
    sci.StartStyling(0, 0x1f)
    sci.SetStyling(sci.GetLength()+1, STYLE_DEFAULT)
    
    ; Find and style new match
    sci.StartStyling(pos:=Search(sci, newpos ? newpos : 0, sci.GetLength()+1, GuiMessage), 0x1f) ; 0x1f sets text bits styles, no indicators.
    sci.SetStyling(strlen(GuiMessage), SCE_AHKL_USERDEFINED1),  ; Change color of length of typed text to style #1, move caret to position.
    
    ;~ sci.ScrollCaret() ; scroll in to view.
    */
return



F3::
SearchAgain:
    ; sets position forward to allow searching for next match
    newpos := pos + strlen(GuiMessage)
    GoSub, Search
return

esc::
GuiClose:
    ExitApp

/*
    This function is not really necesary but I made it for convenience...
    It returns the position of first found string match.
*/

Search(sci, tStart, tEnd, str, flags = ""){

    sci.SetSearchFlags(flags), sci.SetTargetStart(tStart), sci.SetTargetEnd(tEnd)
    return pos:=sci.SearchInTarget(strlen(str), str)
}