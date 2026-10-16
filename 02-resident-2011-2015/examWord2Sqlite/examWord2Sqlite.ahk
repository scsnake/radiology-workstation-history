#Persistent
#Include <DBA>
onexit,onexit
comobjerror(false)

;~ if %0%
	;~ wordPath:=%1%
;~ else
	;~ wordPath:="J:\醫學\考試複習檔案和學習資料\專科考試整理-JYC\2013專科交換考題\2013 林口長庚\林口長庚筆試.rtf"

;~ RegExMatch(wordPath,"\d{4}",match)
;~ year:=match?match:"2013"

;~ hospital:="林口長庚"



dbPath:="D:\softwares\sqlite\RadExamDb.sqlite"
logFile:=a_scriptdir "\word.log"


colName1:=["類科","科目","Anatomy","Code","答案","題目來源","題目","選項","本題難易程度","擬題者","審查者"]
colName2:=["speciality","subspeciality","anatomy","Code","answer","source","question","choices","difficulty","creator","examiner"]
colName3:=["類科","科目","Anatomy","Code","編號","題目","答案","正確答案","本題難易程度","題目來源","頁次","擬題者","審查者"]
colName4:=["speciality","subspeciality","anatomy","Code","number","question","choices","answer","difficulty","source","source2","creator","examiner"]
hospitals:=["中山","北榮","成大","和信","林口長庚","馬偕","N醫院","三總","中榮","亞東","奇美","高長","高榮","高醫","國泰","新光","萬芳","彰基","台北仁愛"]

regex1:="is)(?:類科(?:\:|：)\s*?)(?P<speciality>.*?)(\s*?)(?:科目(?:\:|：)\s*?)(?P<subspeciality>.*?)(\s*?)(?:Anatomy(?:\:|：)\s*?)(?P<anatomy>.*?)(\s*?)(?:Code(?:\:|：)\s*?)(?P<Code>.*?)(\s*?)(?:編號(?:\:|：)\s*?)(?P<number>.*?)(\s*?)(?:題目(?:\:|：)\s*?)?(?P<question>.*?)(\s*?)(?:答案(?:\:|：)\s*?)(?P<choices>.*?)(\s*?)(?:正確答案(?:\:|：)\s*?)(?P<answer>.*?)(\s*?)(?:本題難易程度(?:\:|：)\s*?)(?P<difficulty>.*?)(\s*?)(?:題目來源(?:\:|：)\s*?)(?P<source>.*?)(\s*?)(?:頁次(?:\:|：)\s*?)(?P<source2>.*?)(\s*?)(?:(?:擬題者(?:\:|：)\s*?)(?P<creator>.*?)(\s*?)(?:審查者(?:\:|：)\s*?)(?P<examiner>.*?)(\s*?))?(?:出題須知(?:\:|：)(?:.+?))?(?:類科(?:\:|：))"
regex1:="is)(?:類科(?:\:|：)\s*?)(?P<speciality>.*?)(\s*?)(?:科目(?:\:|：)\s*?)(?P<subspeciality>.*?)(\s*?)(?:Anatomy(?:\:|：)\s*?)(?P<anatomy>.*?)(\s*?)(?:Code(?:\:|：)\s*?)(?P<Code>.*?)(\s*?)(?:編號(?:\:|：)\s*?)(?P<number>.*?)(\s*?)(?:題目(?:\:|：)\s*?)?(?P<question>.*?)(\s*?)(?:答案(?:\:|：)\s*?)(?P<choices>.*?)(\s*?)(?:正確答案(?:\:|：)\s*?)(?P<answer>.*?)(\s*?)(?:本題難易程度(?:\:|：)\s*?)(?P<difficulty>.*?)(\s*?)(?:題目來源(?:\:|：)\s*?)(?P<source>.*?)(\s*?)(?:頁次(?:\:|：)\s*?)(?P<source2>.*?)(\s*?)(?:(?:擬題者(?:\:|：)\s*?)(?P<creator>.*?)(\s*?)(?:審查者(?:\:|：)\s*?)(?P<examiner>.*?)(\s*?))?(?:出題須知(?:\:|：)(?:.+?))?$"

gosub connectDb 
gosub openWord
;~ oword.documents.open("J:\醫學\考試複習檔案和學習資料\專科考試整理-JYC\2007專科交換考題\高榮2007\2007交換筆試VGHKS.rtf")
;~ wordAlltext:=oWord.activeDocument.range.text
;~ gosub parseTexts
gosub findWord
;~ gosub parseTables1

return

findWord:
root:="J:\醫學\考試複習檔案和學習資料\專科考試整理-JYC"
loop,% root "\*",1,0
{
	if !instr(a_loopfilename,"專科交換考題")
		continue
	regexmatch(a_loopfilename,"\d{4}",year)
	loop,% a_loopfilefullpath "\*",1,1
	{
		if A_LoopFileExt not in doc,docx,rtf
			continue
		if regexmatch(a_loopfilename,"^(\~\$|\.\_)")
			continue
		oWord.Documents.open(wordPath:=a_loopfilefullpath)
		if !ifExamQuestions(wordAllText:=oWord.activeDocument.range.text){
			oWord.activeDocument.Close(ComObj(0,2)) ;wdDoNotSaveChanges
			continue
		}
		for k,v in hospitals 
			if instr(a_loopfilefullpath,v) {
				hospital:=v
				break
			}
		if (oWord.activeDocument.Tables.Count>0)
			gosub parseTables
		;~ else
			;~ gosub parseTexts
		
		oWord.activeDocument.Close(ComObj(0,2)) ;wdDoNotSaveChanges
	}
	
	
	
}
FileAppend,% a_now "`t" a_loopfilefullpath,% logFile,utf-8
return

parseTexts:
i:=1,colons:="(?:\:|：)",record:={}
record.year:="2007",record.hospital:="高榮"
eof:=false
loop {
	if !RegExMatch(wordAllText,regex1,match,i)
		if !regexmatch(wordAllText,regex2,match,i){
			fileappend,% a_loopfilefullpath,% logFile,utf-8
			return
		}else{
			eof:=true
		}
	
	for k,v in colName4
		if v=source2
			record["source"].=" " match%v%
		else
			record[v]:=match%v%
	
	try {
		db.push(record,"multiChoices")
	}catch e {
		MsgBox,16, Error, % "Test of Recordset Insert failed!`n`nException Detail:`n" e.What "`n"  e.Message
	}	
	record:={},record.year:="2007",record.hospital:="高榮"
	
	;~ i+=strlen(match)-10
	i+=50
	
	if (eof)
		break
	;~ for k,v in colName3 {
		;~ if !RegExMatch(wordAllText,regex:="is)(" v colons "\s*?)(.*)(\s*?)(?:" colName3[mod(k,colName3.maxindex())+1] ")",match,i) {
			;~ if RegExMatch(wordAllText,"is)(?:" v colons "\s*?)(.*)(?:\s*?)$",match,i) {
				;~ if !(k=colName3.maxindex()) 
					;~ fileappend,% a_loopfilefullpath,% logFile,utf-8
				;~ return
			;~ }else{
				;~ fileappend,% a_loopfilefullpath,% logFile,utf-8
			;~ }
		;~ }else{
			;~ record[colName4[k]]:=trim(match2)
			;~ i+=strlen(match1)+strlen(match2)
		;~ }
		
		;~ if(k=colName3.maxindex()){
			;~ db.push(record,"multiChoices")
			;~ record:={},record.year:="2007",record.hospital:="高榮"
		;~ }
	;~ }
} until a_index>9999
return

ifExamQuestions(str){
	global colName1
	a:=true
	for k,v in colName1
		if !instr(str,v)
			a&=false
	return a
}

parseTables:
;~ oWord.Documents.open(wordPath)
loop % oWord.activeDocument.Tables.Count {
	table:=oWord.activeDocument.Tables[a_index]
	record:={}
	record.year:=year,record.hospital:=hospital
	if table.Rows.Count<>11
		FileAppend,% a_now "`t" a_loopfilefullpath,% logFile,utf-8
	loop % table.Rows.Count {
		k:=table.Cell[a_index,1].Range.Text,v:=table.Cell[a_index,2].Range.Text
		if !col:=colPair(k)
			continue
		record[col]:=v
	}
	try {
		db.push(record,"multiChoices")
	}catch e {
		MsgBox,16, Error, % "Test of Recordset Insert failed!`n`nException Detail:`n" e.What "`n"  e.Message
		FileAppend,% a_now "`t" a_loopfilefullpath,% logFile,utf-8
		return
	}
}
return

colPair(str){
	global colName1,colName2
	for k,v in colName1
		if instr(str,v)
			return colName2[k]
	
	return false
}
	

connectDb:
db := DBA.DataBaseFactory.OpenDataBase("SQLite", dbPath)
return

openWord:
oWord:=ComObjCreate("Word.Application")
;~ oWord.Visible:=ComObj(0xB,-1) ;true
;~ oWord.Documents.open(wordPath)
;~ table:=oWord.activeDocument.Tables[1]
;~ msgbox % table.Cell[1,1].Range.Text
;~ oWord.activeDocument.Close(ComObj(0,2)) ;wdDoNotSaveChanges
return

onexit:
;~ ~esc::
db.close()
oWord.quit(ComObj(0,2)) 
ExitApp
return

