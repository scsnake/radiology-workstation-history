/*
arr[lineCount, itemTitle, subItemCount] -> subItem

subItemCount=0 -> same line as itemTitle
subItemCount>0 -> sub item line below itemTitle
*/
#include <SCI>
parseReport(byref input, returnArr=0){
	if !isobject(input){
		text:=input
		arr:=[],i:=0
		loop,parse,text,`n,`r
		{
			line:=RegExReplace(a_loopfield," *$","")
			;~ line:=a_loopfield
			if RegExMatch(line, "is)^(\w[^:]*: *)(.*)",match){
				++i,arr[i]:=[]
				arr[i, k:="" trim(match1) " "]:=[]
				if(trim(match2)!="")
					arr[i, k, 0]:=parseSentence(match2)
			}else if regexmatch(line, "is)^([^\w\(\[\{ ]|\d+[^\w\(\[\{]) +(.*)",match){
				if regexmatch(match2, "is)^([^:]+): *(.*)",m){
					++i,arr[i]:=[]
					arr[i, k:=match1 " " m1 ": "]:=[]
					if (trim(m2)!="")
						arr[i, k, 0]:=parseSentence(m2)
				}else if (trim(match2)!=""){
					++i
					arr[i]:=match1 " " parseSentence(match2, 0)
				}
			}else if regexmatch(line, "is)^( +)([^\w\(\[\{ ]{2,}|\d+[^\w\(\[\{]) +(.*)",match) && (trim(match3)!=""){
				arr[i, k].push(match1 match2 " " parseSentence(match3, 0))
			}else if (trim(line)!="" && !regexmatch(line, "^([ \W]+| *\d+[^\w\(\[\{] *)$")){
				++i
				arr[i]:=parseSentence(line, 0)
			}

		}
		if(returnArr)
			return arr
	}
	
		if isobject(input)
			arr:=input
		
		str:=""
		for k,v in arr {
			if !isobject(v) {
				str.=v "`n"
				continue
			}
			for x, y in v {
				if(y.maxindex()="" && !RegExMatch(x,"show|FINDINGS"))
					continue
				
				str.=x
				for a,b in y {
					str.=(a>0?"`n":"") b
				}
				str.="`n"
				if regexmatch(x,"i)^(indication|history|hx)")
					str.="`n"
			}
		}
		
		return RegExReplace(str,"\n","`r`n")
	
}

/*
capitalize after period (do not use abbr with period)
remove extra spaces
only one space after ".,;"

.. -> .
., -> , 
etc.
*/

parseSentence(text,capitalizeFirst=1){
	return text
}

_parseSentence(text, capitalizeFirst=1){
	arr:=[]
	
	text:=RegExReplace(text,"\ {2,}"," ")
	text:=RegExReplace(text,"(?<![\,\;\.])[\,\;\.]([\,\;\.])(?![\,\;\.])","$1")
	text:=RegExReplace(text,"(?<!\d)[\.\,\;](?![\d ])","$0 ")
	
	
	if !regexmatch(text,"[\(\)\[\]\{\}]") {
		arr.push(trim(text))
	}else{
		text:=trim(text),tmp:="",enclosed:=0
		loop,parse,text
		{
			if !regexmatch(a_loopfield,"[\(\)\[\]\{\}]",match)
				tmp.=a_loopfield
			else if (match && !enclosed){
				if(tmp!="")
					arr.push(tmp)
				tmp:=enclosed:=a_loopfield
			}else if (enclosed && a_loopfield=(enclosed="("?")":enclosed="["?"]":"}")){
				arr.push(tmp.=a_loopfield)
				,tmp:=enclosed:=""
			}
		}
		if(tmp!="")
			arr.push(tmp)
	}
	
	
	str:="",ind:=1+(capitalizeFirst?0:1)
	for k,v in arr {
		RegExMatch(v, "is)^( *[\(\[\{)])?(.*?)([\(\[\{)] *)?$",match)
		
		
		previousEnclosedSentence:=enclosedSentence
		
		if (match1!="" && regexmatch(match2,"\. *$"))
			enclosedSentence:=1
		else
			enclosedSentence:=0
			,str:=RegExReplace(str,"\. *$","")
		
		str.=(enclosedSentence=1||previousEnclosedSentence?" ":"") match1
		
		tmp:=""
		loop,parse,match2,`.
		{
			if(a_index=1 && trim(a_loopfield)=""){
				str.=". "
				continue
			}
	
			if regexmatch(substr(tmp,0,1),"\d") && regexmatch(substr(a_loopfield,1,1),"\d"){
				tmp.="." a_loopfield
			}else {
				if (tmp!="")
					str.=(ind=1||previousEnclosedSentence=0?(tmp):capitalize(tmp)) ". "
					,++ind
				tmp:=a_loopfield
			}
		}
		if (tmp!="")
			str.=(ind=1||previousEnclosedSentence=0?(tmp):capitalize(tmp)) (enclosedSentence?". ":"")
		str:=trim(str)
		str:=RegExReplace(str,"\ {2,}"," ")
		
		str.= match3
		
	}
	
	str:=RegExReplace(str,"(?<![\,\;\.])[\,\;\.]([\,\;\.])(?![\,\;\.])","$1")

	str:=RegExReplace(trim(str),"[\,\;] *$",".")
	str:=RegExReplace(str," ([\,\;\.])","$1")
	str:=RegExReplace(str,"(?<![\,\;\.])[\,\;\.]([\,\;\.])(?![\,\;\.])","$1")

	
	
	return str
}

capitalize(s){
	matched:=RegExMatch(s,"\w",match)
	StringUpper,match,match
	if matched=1
		return match substr(s,2)
	else
		return substr(s,1,matched-1) match substr(s,matched+1)
}

;~ text=
;~ (
;~ - Other: probably cyst(s). soft tissue density around sternum, suggest clinical correlation and contrast enhanced study if indicated.
;~ (Low sensitivity and specificity of non-contrast CT.)

;~ (RLL: right lower lobe.)
;~ )

;~ msgbox % parseReport(text)

;~ text=
;~ (
;~ INDICATION: Neoplasm.

;~ TECHNIQUE: CT of the chest without/with intravenous contrast.
;~ - Lung/airway: 
  ;~ -- Tiny or probably non-specific nodules and minor or non-specific lung parenchymal change.
;~ - Pleura: no pleural effusion.
;~ - Mediastinum: small mediastinal lymph nodes.
;~ - Bone: spondylosis with marginal spur formation.
;~ - Other: fatty liver. B//.


;~ )

;~ msgbox % parseChestCTCommand(text)
parseChestCTCommand(text){
	matchWhere:=regexmatch(text,"([\w]+)//",match)
	text:=substr(text,1,matchWhere-1) substr(text,matchWhere+strlen(match))
	
	regexmatch(match1, "i)(\d+)c",ca)
	static caArr:=["aorta","coronary artery","cardiac valve"]
	if(ca1!=""){
		caText:=""
		count:=0
		loop,parse,ca1
			caText.=caArr[a_loopfield+0] ", ",count:=a_index
		
		caText:=substr(caText,1,-2)
		
		if (count>1)
			caText:=RegExReplace(caText,", ([^,]+)$"," and $1")
		
		text:=RegExReplace(text,"i)Heart/great vessel: *","$0 calcification of the " caText ". ")
	}
	
	
	if instr(match1,"t")
		text:=RegExReplace(text,"i)Other: *","$0 thyroid nodule(s). ")
	
	if instr(match1,"g")
		text:=RegExReplace(text,"i)Heart/great vessel: *","$0 cardiomegaly. ")
	
	if instr(match1,"b")
		text:=RegExReplace(text,"i)spondylosis with marginal spur formation.","")
	
	if instr(match1,"p")
		text:=RegExReplace(text,"i)Other: *","$0 placement of a portacath. ")
	
	if instr(match1,"s")
		text:=RegExReplace(text,"i)Other: *","$0 gallstone(s). ")
	
	
	if instr(match1,"hr")
		text:=RegExReplace(text,"i)Other: *","$0 hypodense lesions in liver and kidneys, cysts are favored. ")
	else if instr(match1,"h")
		text:=RegExReplace(text,"i)Other: *","$0 hypodense lesion(s) in liver, probably cyst(s). ")
	else if instr(match1,"r")
		text:=RegExReplace(text,"i)Other: *","$0 hypodense lesion(s) in kidney(s), probably cyst(s). ")
	
	return text
}

colorKeywords(RegEx, byref Font, byref RE){
	text:=RE.getText(), sel:=RE.getSel()
	i:=0, match:="0", count:=0
	while i:=regexmatch(text, RegEx, match, i+strlen(match)) {
		RE.setSel(i-1, i+strlen(match)-1)
		RE.setFont(Font)
		++count
	}
	RE.setSel(-1, -1)
}

colorRadReport(RE, color=1, reset=1){
	
	if(reset){
		if(color=1){
			RE.SetBkgndColor("white")
			RE.SetDefaultFont({Color: "Black"})
		}else {
			RE.SetBkgndColor("black")
			RE.SetDefaultFont({Color: "Silver"})
		}
	}
	colorKeywords("i)\b(right|left|bilateral)\b",{Color: color?"navy":"white", style: "b"},RE)
	colorKeywords("i)\bpost[- \w]+?changes?\b",{Color: color?"purple":"white", style: "b"},RE)
	colorKeywords("i)\bno(rmal)?\b", {Color: color?0x00cc00:"white", style: "b"}, RE)
	colorKeywords("i)\b(cysts?|(micro)?calcifications?|mild|minimal|small)\b", {Color: color?0x00cc00:"white", style: "b"}, RE) ;light green
	
	colorKeywords("i)\b(fractures?|moderate)\b", {Color: color?"0xcccc":"white", style: "b"}, RE)
	colorKeywords("i)\b(mass(es)?|nodules?|tumors?|lesions?|cancer|malignanc(y|ies)|metastas[ei]s|mets|severe|large|marked|total)\b", {Color: color?"red":"white", style: "b"}, RE)
	colorKeywords("i)\b(larger|enlarged|engorged|disten([st]ion|ded)|dilat(ed|ation)|more prominent|thicken(ing|ed)|ruptured?)\b", {Color: color?"red":"white", style: "b"}, RE)

	;sentence
	colorKeywords("i)\b(normal|no (definite|obvious|significant)|non( |-)specific|spondylosis|degenerative|atherosclero(sis|tic)|fibrotic changes?)\b[^\.;]+[\.;]", {Color: color?0x00cc00:"white", style: "b"}, RE)
	

	RE.Deselect()
}

SCI_ColorRadReport(ByRef sci, ByRef StyleRange, color=1){
	sci.GetText(sci.GetLength()+1,text:="")
	StyleRange.text:=text
	
	if(text="")
		return 
	
	StyleRange.ResetStyles()
    ;~ StyleRange.AddStyleRegex("i)\bNo(rmal)?\b[^\.]*\.?", "UD1")
	if(!color){
		StyleRange.AddStyleRegex("i)\b(right|left|bilateral)\b","UD1")
		,StyleRange.AddStyleRegex("i)\bpost[- \w]+?changes?\b","UD1")
		,StyleRange.AddStyleRegex("i)\b(cysts?|(micro)?calcifications?|mild|minimal|small)\b", "UD1") ;light green
		
		,StyleRange.AddStyleRegex("i)\b(fractures?|moderate)\b", "UD1")
		,StyleRange.AddStyleRegex("i)\b(mass(es)?|nodules?|tumors?|lesions?|cancer|malignanc(y|ies)|metastas[ei]s|filling defects?|mets|severe|large|marked|total)\b", "UD1")
		,StyleRange.AddStyleRegex("i)\b(larger|enlarged|engorged|disten([st]ion|ded)|dilat(ed|ation)|more prominent|thicken(ing|ed)|ruptured?)\b", "UD1")

		;sentence
		,StyleRange.AddStyleRegex("i)\b(clear|normal|no (abnormal|definite|obvious|significant)?|non( |-)specific|spondylosis|degenerative|atherosclero(sis|tic)|fibrotic changes?)\b[^\.;]*[\.;]?", "UD1")
	}
	
    StyleRange.ApplyToSCI(sci)
	

}

class StyleRange 
{
    __New(Text){
        this.TextLen:=StrLen(Text)
        this.ResetStyles()
        this.__Text:=Text
    }
    
    Text {
        get {
            return this.__Text
        }
        set {
			if(value="")
				return this.reset()
            if((newLen:=StrLen(value)) > this.TextLen )
                this.AddStyle(this.TextLen, newLen)
            else if (newLen< this.TextLen)
                for k,v in this.styles
                    this.exclude(this.styles, v, newLen, this.TextLen)
            this.TextLen:=newLen
            return this.__Text:=value
        }
        
    
    }
	
	
	reset(){
		this.__Text:=""
		this.TextLen:=0
		this.ResetStyles()
	}
    
    ApplyToSCI(ByRef sci){
        for style,Ranges in this.styles {
            SciStyle:= style="Default"?STYLE_DEFAULT:style="UD1"?SCE_AHKL_USERDEFINED1:style="UD2"?SCE_AHKL_USERDEFINED2:STYLE_DEFAULT
            for k,v in Ranges 
                if(v.1!=v.2)
                    sci.StartStyling(v.1, 0x1f)
                    , sci.SetStyling(v.2-v.1, SciStyle)
        }
    }
    
    ResetStyles(){
        this.Styles:={Default:[[0, this.TextLen:=StrLen(this.__Text)]]}
    }
    
    AddStyleRegex(RegEx, style="Default"){
        if IsObject(RegEx){
            for k,v in RegEx
                this.AddStyleRegex(v, style)
            return 
        }
        i:=0,match:="0",matchLen:=1
        while i:=RegExMatch(this.__Text, RegEx, match, i+matchLen) 
            this.AddStyle(i-1,(matchLen:=StrLen(match))+i-1, style)
    }

    AddStyle(start,End,style="Default"){
        if !this.styles.haskey(style)
            this.Styles[style]:=[[0,0]]
        for k,v in this.Styles {
            if(k=style)
                this.include(this.Styles, k,start,End)
            else
                this.exclude(this.Styles, k,start,End)
        }
    }
    
    include(ByRef styles, style, start, End){
        arr:=[],added:=0,Count:=styles[style].maxIndex()

        for k,v in styles[style] {
            if (continue){
                --continue
                continue
            }
        
            if(added || start>v.2){
                arr.push(v)
                continue
            }
            if(End<v.1){
                if(!added){
                    added:=1
                    ,arr.push([start, End])
                }
                arr.push(v)
                continue
            }
            
            
            
            added:=1
            if(End<=v.2){
                arr.push([start>v.1?v.1:start, End<v.2?v.2:End])
                continue
            }
            farEnd:="",continue:=0
            Loop % Count-k {
                if(End>=(after:=styles[style,A_Index+k]).1)
                    farEnd:=after.2,++continue
                else 
                    break
            }
            arr.push([start>v.1?v.1:start, farEnd=""?End:farEnd])
        }
        
        if !added
            arr.push([start,End])
        
		if arr.maxIndex()
			styles[style]:=arr
        
    }
    
    exclude(ByRef styles, style, start, End){
        arr:=[],added:=0,Count:=styles[style].maxIndex()

        for k,v in styles[style] {
            if (continue){
                --continue
                continue
            }
        
            if(added || start>=v.2){
                arr.push(v)
                continue
            }
            if(End<=v.1){
                if(!added){
                    added:=1
                    ;~ ,arr.push([start, End])
                }
                arr.push(v)
                continue
            }
            
            
            
            added:=1
      
            if(start>v.1)
                arr.push([v.1, start])
            if(End<v.2){
                arr.push([End, v.2])
                continue
            }
            continue:=0
            Loop % Count-k {
                if(End>(after:=styles[style,A_Index+k]).1){
                    ++continue
                    if(End<after.2){
                        arr.push([End, after.2])
                        break
                    }
                }else 
                    break
            }
            
        }
        
        ;~ if !added
            ;~ arr.push([start,End])
        

		styles[style]:=arr.maxIndex()?arr:[[0,0]]        
    }
}