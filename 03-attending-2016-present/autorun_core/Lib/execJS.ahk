execJS(byref pwb, byref js){
	e:=pwb.document.createElement("script")
	,e.text:=js
	
	try
		p:=pwb.document.head
	catch
	try
		p:=pwb.document.documentElement
	catch
	try
		p:=pwb.document.body
	
	if p
		p.appendChild(e)
}