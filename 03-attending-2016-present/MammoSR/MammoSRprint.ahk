OnExit,OnExit
FileEncoding,utf-8
#include <XML>
#SingleInstance,force
#NoTrayIcon
ComObjError(false)
param:=[]

ReportDir:=A_ScriptDir "\MammoReportSaved\"
if %0%
	Loop %0%
	{
		arg:=%a_index%
		param.push(arg)
	}
else 
	ExitApp



;~ param[1]:=ReportDir "1______ T__________.xml"
err:=""
for k,XMLfile in param {
	if !FileExist(XMLfile)
		continue
	
	fileread,XMLcontents,% XMLfile
	try
		SRxml:=new XML(XMLcontents)
	catch {
		err.="XML file error: " XMLfile "`n"
		continue
	}
	fileread,html,% A_ScriptDir "\output.html"
	dom:=ComObjCreate("HtmlFile")
	,dom.write(html)
	
	,studydate:=SubStr(SRxml.getText("/MammoSR/StudyDateTime"),1,10)
	,replaceWith(dom, "examDate", [SubStr(studydate,1,4), SubStr(studydate,6,2), SubStr(studydate,9,2)])
	
	,reportdate:=SubStr(SRxml.getText("/MammoSR/Report/ReportDate"),1,10)
	,replaceWith(dom, "reportDate", [SubStr(reportdate,1,4), SubStr(reportdate,6,2), SubStr(reportdate,9,2)])
	
	,d:=SRxml.getText("/MammoSR/Report/Density")
	,CheckboxWhich(dom, "bdcb", InStr(d,"fatty")?1:InStr(d,"fibroglandular")?2:InStr(d,"heterogeneous")?3:4)
	
	,m:=SRxml.getText("/MammoSR/Report/Modality")
	,CheckboxWhich(dom, "xraycb", InStr(m,"CR")?1:InStr(m,"DR")?2:InStr(m,"Tomo")?3:2)
	
	,c:=SRxml.getText("/MammoSR/Report/Comparison")
	,CheckboxWhich(dom, "comparecb", InStr(c,"yes")?1:2)
	,CheckboxWhich(dom, "reasoncb", InStr(c,"yes")?0:InStr(c,"第一次")?1:InStr(c,"無法取得")?2:3)
	
	,assessment:=SRxml.getText("/MammoSR/Report/Assessment")
	
	,lesionInd:=1
	if !RegExMatch(assessment, "i)BI-RADS (1|2)")
		ReportFinding(SRxml)
	
	
	RegExMatch(assessment, "i)BI-RADS ([\dabc]+)", m)
	,CheckboxWhich(dom, "resultcb", SubStr(m1,1,1)+1)
	,CheckboxWhich(dom, "resultsubcb", SubStr(m1,2,1)="a"?1:SubStr(m1,2,1)="b"?2:SubStr(m1,2,1)="c"?3:0)
	
	,replaceWith(dom, "radiologist", SRxml.getText("/MammoSR/ReportVS"))
	,replaceWith(dom, "technician", SRxml.getText("/MammoSR/Technician"))
	,replaceWith(dom, "chartno", chartNo:=SRxml.getText("/MammoSR/ChartNo"))
	replaceWith(dom, "ptname", ptname:=SRxml.getText("/MammoSR/Patient/Name"))
	
	,p:=SRxml.getText("/MammoSR/Patient/PersonId"), arr:=[]
	Loop,Parse,p
		arr.push(A_LoopField)
	replaceWith(dom, "id", arr)
	
	,d:=SubStr(SRxml.getText("/MammoSR/Patient/Birthday"),1,10)
	,replaceWith(dom, "brth", [SubStr(d,1,4), SubStr(d,6,2), SubStr(d,9,2)])
	

	
	;~ html:=RegExReplace(html, "\$\w+cb\d*\b", "□")
	;~ html:=RegExReplace(html, "\$\w+\b", "")
	,dom.getElementById("positiveFindingPage").style.display:="none"
	,html:=dom.documentElement.innerHTML
	
	FileDelete,% ReportDir RegExReplace(studydate, "\W", "") " " chartNo ".html"
	FileAppend,% html,% ReportDir RegExReplace(studydate, "\W", "") " " chartNo ".html",utf-8
}

;~ MsgBox,,,Finished!,10
ExitApp
return

setLesionLocation(ByRef dom, tag, locStr, ByRef arr=""){
	global lesionInd
	if(locStr="")
		return
	suffix:=("_" lesionInd)
	
	if (arr="")
		arr:={r:0,l:0,b:0}
	Loop,Parse,locStr,`n
	{
		if !RegExMatch(A_LoopField, "([\w ]?)\,?([\w ]+)?\,?([\w ]+)?",match)
			continue
		++arr[match1]
		if(match2="subareolar")
			CheckboxWhich(dom, tag "loccb", 5 suffix)
		else if(match2="AT")
			CheckboxWhich(dom,  tag "loccb", 6 suffix)
		else if (match2="U"){
			if(match3="O")
				CheckboxWhich(dom,  tag "loccb", 1 suffix)
			else if(match3="I")
				CheckboxWhich(dom,  tag "loccb", 2 suffix)
			else if(Trim(match3)="")
				CheckboxWhich(dom,  tag "hscb", 1 suffix)
		}else if (match2="L"){
			if(match3="O")
				CheckboxWhich(dom,  tag "loccb", 3 suffix)
			else if(match3="I")
				CheckboxWhich(dom,  tag "loccb", 4 suffix)
			else if(Trim(match3)="")
				CheckboxWhich(dom,  tag "hscb", 2 suffix)
		}else if (Trim(match2)=""){
			if(match3="O")
				CheckboxWhich(dom,  tag "hscb", 3 suffix)
			else if(match3="I")
				CheckboxWhich(dom,  tag "hscb", 4 suffix)
		}
		
		
		if(match1="b")
			CheckboxWhich(dom,  tag "poscb", 4 suffix)
		;~ else if (arr.r + arr.l >1)
			;~ CheckboxWhich(dom,  tag "poscb", 3 suffix)
		else if (match1="l")
			CheckboxWhich(dom,  tag "poscb", 2 suffix)
		else if (match1="r")
			CheckboxWhich(dom,  tag "poscb", 1 suffix)
		
		ele:=dom.getElementsByName("finding" tag "cb" suffix)
		Loop % ele.length
			ele[A_Index-1].checked:="checked"
		
	}
	
	
	
	
}

setLesionsLocation(ByRef dom, tag, ByRef AllLocations, ByRef lesionInds){
	for k,v in lesionInds {
		suffix:=v=1?"":("_" v)
		if(AllLocations.b || (AllLocations.r && AllLocations.l))
			CheckboxWhich(dom,  tag "poscb", 4 suffix)
		else if (AllLocations.r + AllLocations.l >1)
			CheckboxWhich(dom,  tag "poscb", 3 suffix)
		else if (AllLocations.l>0)
			CheckboxWhich(dom,  tag "poscb", 2 suffix)
		else if (AllLocations.r>0)
			CheckboxWhich(dom,  tag "poscb", 1 suffix)
	}
}

createNewPage(lesionInd){

	global dom
	suffix:="_" lesionInd
	,newLesion:=dom.createElement("DIV")
	,newLesion.id:="positiveFindingPage" suffix
	
	,innerHTML:=dom.getElementById("positiveFindingPage").innerHTML
	,newHTML:="", i:=0, ind:=1
	while i:=RegExMatch(innerHTML,"i)\bname=(""?)([^ "">]+)(""?)", match, ind) {
		if RegExMatch(match2, "i)^(chartno|ptname|f?id|brth|examDate|resultcb|resultsubcb|hospital|radiologist)")
			newHTML.=SubStr(innerHTML, ind, i-ind) match
		else
			newHTML.=SubStr(innerHTML, ind, i-ind) "name=" match1 match2 suffix match3
		ind:=i+StrLen(match)
	}
	newHTML.=SubStr(innerHTML,ind)
	,newLesion.innerHTML:=newHTML
	
	;~ ,newLesion:=dom.getElementById("positiveFindingPage").cloneNode(true)
	;~ ,newLesion.id:= "positiveFindingPage" suffix
	;~ Loop % (descend:=newLesion.getElementsByTagName("*")).length {
		;~ name:=descend[A_Index-1].getAttribute("name")
		;~ if(descend[A_Index-1].tagName="SPAN"){
			;~ if(name="other")
				;~ descend[A_Index-1].setAttribute("name", name suffix)
		;~ }else if (name!="")
			;~ descend[A_Index-1].name:=name suffix
		
	;~ }
	
	,dom.getElementById("positiveFindingPage").parentNode.insertBefore(newLesion, dom.getElementById("saveHint"))
	;~ dom.getElementById("allFindings").value:=lesionInd
	
	
}

ReportFinding(ByRef SRxml){
	global dom, lesionInd
	;~ category:=SRxml.getText("/MammoSR/Report/Assessment")
	;~ positive:=InStr(category, "suggest tissue proof")||InStr(category, "proven")
	
	
	Type:="Mass",loc:="", AllLocations:={r:0,l:0,b:0}, lesionInds:=[], AllLocations:={r:0,l:0,b:0}
	Loop % (nodes:=SRxml.selectNodes("/MammoSR/Report/Findings/" Type)).length {
		if !isPositiveFinding(node:=nodes.item(A_Index-1))
			continue
		;~ str.=getLocationText(node) " " nodeElement(node, "Shape") " " nodeElement(node, "Density") " " nodeElement(node, "Margin") "<br/>"
		createNewPage(lesionInd)

		
		,loc:=nodeElement(node, "Location") "`n"
		,setLesionLocation(dom, "mass", loc, AllLocations)
		
		,s:=nodeElement(node, "Size")
		,CheckboxWhich(dom, "masssizecb", (s>4?5:s>=3?4:s>=2?3:s>=1?2:1) ("_" lesionInd))
		
		,s:=nodeElement(node, "Shape")
		for k,v in ["round", "oval", "lobular", "irregular"]
			if InStr(s, v)
				CheckboxWhich(dom, "massmorcb" , k ("_" lesionInd))
		
		s:=nodeElement(node, "Margin")
		for k,v in ["circumscribed", "microlobulated", "obscured", "indistinct", "spiculated"]
			if InStr(s, v)
				CheckboxWhich(dom, "massmargincb" , k ("_" lesionInd))
		
		s:=nodeElement(node, "Density")
		for k,v in ["high", "iso", "low", "fat", "mixed"]
			if InStr(s, v)
				CheckboxWhich(dom, "massdencb" , k ("_" lesionInd))
			
		lesionInds.push(lesionInd), ++lesionInd
		
		
		
	}
	;~ setLesionsLocation(dom, "mass", AllLocations, lesionInds)
	
	
	
	Type:="Calcification",loc:="", AllLocations:={r:0,l:0,b:0}, lesionInds:=[]
	Loop % (nodes:=SRxml.selectNodes("/MammoSR/Report/Findings/" Type)).length {
		if !isPositiveFinding(node:=nodes.item(A_Index-1))
			continue
		createNewPage(lesionInd)
		
		,loc:=nodeElement(node, "Location") "`n"
		,setLesionLocation(dom, "cal", loc, AllLocations)
		
		,s:=nodeElement(node, "Distribution")
		for k,v in ["grouped", "linear", "segmental", "regional", "diffuse"]
			if InStr(s, v)
				CheckboxWhich(dom, "caldistcb", k ("_" lesionInd))
		
		s:=nodeElement(node, "Morphology")
		for k,v in ["amorphous", "coarse heterogeneous", "pleomorphic", "fine linear branching"]
			if InStr(s, v)
				CheckboxWhich(dom, "calmorcb", k ("_" lesionInd))
				
		lesionInds.push(lesionInd), ++lesionInd
		
	}
	;~ setLesionsLocation(dom, "cal", AllLocations, lesionInds)
	
	
	Type:="Asymmetry",loc:="", AllLocations:={r:0,l:0,b:0}, lesionInds:=[]
	Loop % (nodes:=SRxml.selectNodes("/MammoSR/Report/Findings/" Type)).length {
		if !isPositiveFinding(node:=nodes.item(A_Index-1))
			continue
		createNewPage(lesionInd)
		
		,loc:=nodeElement(node, "Location") "`n"
		,setLesionLocation(dom, "asy", loc, AllLocations)
		;~ setLesionsLocation(dom, "asy", loc, lesionInds)
		,Type:=node.getElementsByTagName("Type").item(0).Text
		,CheckboxWhich(dom, "asytypecb", (InStr(Type, "developing")?3:InStr(Type, "focal")?2:1) ("_" lesionInd))
			
		,lesionInds.push(lesionInd), ++lesionInd
		
		
	}
	;~ setLesionsLocation(dom, "asy", AllLocations, lesionInds)
	
	
	Type:="ArchitecturalDistortion",loc:="", AllLocations:={r:0,l:0,b:0}, lesionInds:=[]
	Loop % (nodes:=SRxml.selectNodes("/MammoSR/Report/Findings/" Type)).length {
		if !isPositiveFinding(node:=nodes.item(A_Index-1))
			continue
		createNewPage(lesionInd)
		
		,loc:=nodeElement(node, "Location") "`n"
		,setLesionLocation(dom, "ardi", loc, AllLocations)
			
		,lesionInds.push(lesionInd), ++lesionInd
		
	}
	;~ setLesionsLocation(dom, "ardi", AllLocations, lesionInds)
	
	
	Type:="Other",str:="", loc:="" AllLocations:={r:0,l:0,b:0}, lesionInds:=[], strText:=0
	Loop % (nodes:=SRxml.selectNodes("/MammoSR/Report/Findings/" Type)).length {
		;~ if !isPositiveFinding(node:=nodes.item(A_Index-1))
			;~ continue
		;~ str.=getLocationText(nodes.item(A_Index-1)) " " nodeElement(node, "Description") "; "
		if(lesionInd=1)
			createNewPage(lesionInd)
		
		node:=nodes.item(A_Index-1)
		,d:=nodeElement(node, "Description"), loc:=nodeElement(node, "Location") "`n"
		if(d="Enlarged axillary lymph node(s)") || (d="Dense axillary lymph node(s)")
			setLesionLocation(dom, "ln", loc)
		else if (d="Nipple retraction") || (d="Skin thickening") || (d="Skin retraction")
			setLesionLocation(dom, "nip", loc)
		else if (d="Dilated lactiferous ducts")
			setLesionLocation(dom, "duct", loc)
		else
			str.=getLocationText(node) " " d "; ", strText++
		
		lesionInds.push(lesionInd), ++lesionInd
	}
	if(strText)
		replaceWith(dom, "other", SubStr(str,1,-2))
}

getLocationText(ByRef xmlNode){
	static loc:={"U": "upper", "O": "outer", "L": "lower", "I": "inner", "C": "center"}, side:={"R": "Right", "L": "Left", "B": "Bilateral"}
	RegExMatch(nodeElement(xmlNode, "Location"), "(\w?)\,(\w?)\,(\w?)",match)
	return (side[match1]?side[match1]:match1) "," (loc[match2]?loc[match2]:match2) "," (loc[match3]?loc[match3]:match3)
	
}

nodeElement(ByRef xmlNode, ele){
	return xmlNode.getElementsByTagName(ele).item(0).Text
}

isPositiveFinding(ByRef xmlNode){
	return !!RegExMatch(nodeElement(xmlNode, "Suggestion"), "i)tissue proof|ultrasound|spot|\bmag(nif|\b)|short\W+term|(6|six)\W+month|malignan|tomosyn")
}

replaceWith(ByRef dom, tag, contents){
	if IsObject(contents){
		for k,v in contents
			;~ StringReplace,html,html,% tag k,% v
			replaceWith(dom, tag k, v)
	}else{
		;~ StringReplace,html,html,% tag,% contents,All
		e:=dom.getElementsByName(tag)
		Loop % e.length
			e[A_Index-1].innerText:=contents
		
		s:=dom.getElementsByTagName("span")
		;~ MsgBox % s[0].name
		Loop % s.length {
			if(s[A_Index-1].getAttribute("name")=tag)
				s[A_Index-1].innerText:=contents
		}
	}
	return dom
}

CheckboxWhich(ByRef dom, tag, checkInd){
	if IsObject(checkInd){
		for k,v in checkInd
			;~ StringReplace,html,html,% tag k,% v
			CheckboxWhich(dom, tag, v)
	}else{
		e:=dom.getElementsByName(tag checkInd)
		Loop % e.length
			e[A_Index-1].checked:="checked"
		;~ html:=RegExReplace(html, "\" tag checkInd "\b", "■")
	}
	;~ html:=RegExReplace(html, "\" tag "\d+\b" ,"□")
	return dom
}

OnExit:
;~ esc::
ExitApp