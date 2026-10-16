
;~ dcm4che:=new dcm4che("RAID")
;~ SeriesInfo:=dcm4che.getSeriesInfo("T__________")
;~ MsgBox % seriesInfo.maxindex()
;~ clipboard:=dcm4che.LastOutput
;~ dcm4che.Move([SeriesInfo.3.SeriesUID], "SYNGOVIA")
;~ esc::
;~ ExitApp

;~ d:=new dcm4che({aet: "PACSWFM2", ip: "10.0.0.100", port: "104"})
;~ clipboard:=s:=d.getSeriesInfo("T__________")
;~ ExitApp


;~ d:=new dcm4che("RAID")
;~ d.PACStoRAID({chartNo: "6______", date: "20170525"})
;~ ,d.getStudyByDate("20170519")
;~ info:=d.ParseTextResult(clipboard, {"Query/Retrieve Level":"STUDY"
			;~ , "Patient ID":""
			;~ , "Study Instance UID":""})
;~ ExitApp

class dcm4che {
	__New(remote="", dcmpath=""){
		this.root:=SubStr(A_ScriptDir,1,2)
		if(dcmpath=""){
			if FileExist(dcmpath:=this.root "\scripts\AutoHotkey\Lib\dcm4che-2.0.26\bin\dcmqr.bat")
				|| FileExist(dcmpath:=A_MyDocuments "\dcm4che-2.0.26\bin\dcmqr.bat") 
				|| FileExist(dcmpath:=A_ScriptDir "\Lib\dcm4che-2.0.26\bin\dcmqr.bat") {
			
			}
			
		}
		this.dcmqrPath:=dcmpath
		,this.aet:="RAID"
		if(remote=""){
			this.remote:={aet: "RAID", ip: "10.0.0.100", port: "4006"}
			,this.aet:="DCMQR"
		}else{
			if IsObject(remote)
				this.remote:=remote
			else if(remote="RAID")
				this.remote:={aet: "RAID", ip: "10.0.0.100", port: "4006"}
				,this.aet:="DCMQR"
			else if(remote="SYNGOVIA")
				this.remote:={aet: "SYNGOVIA", ip: "10.0.0.100", port: "104"}
			else if(remote="PACSWFM2")
				this.remote:={aet: "PACSWFM2", ip: "10.0.0.100", port: "104"}	
		}
	}
	
	getSeriesInfo(AccNo){
		if(AccNo="")
			return []
		StringUpper,AccNo,AccNo
		parameter:="-L " this.aet " " this.remote.aet "@" this.remote.ip ":" this.remote.port " -q00080050=" AccNo " -S -r SeriesDescription -r NumberOfSeriesRelatedInstances -r PatientID -r AccessionNumber"
		,outputFileName:="__dcm4cheOutput" a_now
		RunWait,% """" this.dcmqrPath """ " parameter " > """ a_scriptdir "\" outputFileName """",% a_scriptdir
		;~ RunWait,% """" this.dcmqrPath """ " parameter 
		fileread,__dcm4cheOutput,% A_ScriptDir "\" outputFileName
		FileDelete,% A_ScriptDir "\" outputFileName
		this.LastOutput:=__dcm4cheOutput
		;~ clipboard:=__dcm4cheOutput
		if !RegExMatch(__dcm4cheOutput, "i)\[([^\]]+)\] Study Instance UID", StudyUID)
			return []
		
		this.LastStudyUID:=StudyUID1
		
		;~ MsgBox % clipboard:=__dcm4cheOutput
		;~ ,arr1:=[],arr2:=[]
		;~ ,rxms(__dcm4cheOutput,"(\r?\n){2,}","sarr1[] marr2[]")
		
		;~ StringReplace,t,__dcm4cheOutput,`r,% ""
		;~ StringReplace,t,t,`n`n,㏄
		
		return info:=this.ParseTextResult(__dcm4cheOutput, {"Series Instance UID":""
			, "Series Number":""
			, "Patient ID":""
			, "Acession Number":""
			, "Number of Series Related Instances":""
			;~ , "Slice Thickness":""
			;~ , "SpacingBetweenSlices":""
			, "Series Description":""})
		
		t:=RegExReplace(__dcm4cheOutput, "(\r?\n){2,}", "㏄")
		
		info:=[]
		;~ clipboard:=t
		Loop,Parse,t,㏄
		{
			v:=A_LoopField
			if RegExMatch(v, "i)\[([^\]]+)\] Series Instance UID", SeriesUID)
				&& RegExMatch(v, "i)\[([^\]]+)\] Series Number", SeriesNumber)
				&& RegExMatch(v, "i)\[([^\]]+)\] Number of Series Related Instances", InstanceCount)
				&& RegExMatch(v, "i)\[([^\]]+)\] Series Description", SeriesDescription) {
				info.push({SeriesNumber: SeriesNumber1, SeriesUID: SeriesUID1, InstanceCount: InstanceCount1, SeriesDescription: SeriesDescription1})
			}
		}
		return this.LastSeriesInfo:=info
	}
	
	getStudyByDate(date){ ;2017/1/1
		if !(date~="^\d{8}$"){ ;date format to 20170101
			dateArr:=[]
			Loop,Parse,date,%a_space%`,`./\%a_tab%
			{
				if A_Index>3
					break
				if (A_LoopField>0){
					v:=A_LoopField
					while StrLen(v)<(A_Index=1?4:2)
						v:="0" v
				}
			}
			date:=""
			Loop 3
				date.=dateArr[A_Index]
		}
		parameter:="-L " this.aet " " this.remote.aet "@" this.remote.ip ":" this.remote.port " -qStudyDate=" date " -S -r PatientID -r AccessionNumber -r StudyDescription"
		,outputFileName:="__dcm4cheOutput" a_now
		RunWait,% clipboard:= """" this.dcmqrPath """ " parameter " > """ a_scriptdir "\" outputFileName """",% a_scriptdir
		fileread,__dcm4cheOutput,% A_ScriptDir "\" outputFileName
		FileDelete,% A_ScriptDir "\" outputFileName
		this.LastOutput:=__dcm4cheOutput
		
		;~ info:=this.ParseTextResult(__dcm4cheOutput, {"Query/Retrieve Level":"STUDY"
			;~ , "Patient ID":""
			;~ , "Study Instance UID":""})
		
		info2:=this.ParseTextResult(__dcm4cheOutput, {"Query/Retrieve Level":"SERIES"
			;~ , "Series Description":""
			, "Patient ID":""
			, "Study Instance UID":""
			, "Series Instance UID":""
			, "Accession Number":""
			, "Study Description":""
			, "Number of Series Related Instances":""})
			
			
		return info2
		
		
	}
	
	ParseTextResult(outputtext, items){ ;items = key-value pairs, empty value means retrieval, non-empty means filtering
		t:=RegExReplace(outputtext, "(\r?\n){2,}", "㏄")
		,info:=[]
		
		Loop,Parse,t,㏄
		{
			v:=A_LoopField
			,tmp:=[],hasMatch:=false
			for item, value in items
			{
				var:=RegExReplace(item, "\W", "")
				if (value=""){
					if((id:=this.DicomTagNameToId(var))!="" && (match:=RegExMatch(v, "i)" id "[^\[]+\[([^\]]+)\]", %var%))) || (match:=RegExMatch(v, "i)\[([^\]]+)\] " item, %var%))
						varName:=var "1"
						,tmp[var]:=%varName%
						,hasMatch:=true
				}else{
					match:=InStr(v, "[" value "] " item)
				}
				
				if(!match)
					break
			}
			
			if (!hasMatch)
				continue
			
			info.push(tmp)
		}
		
		return info
	}
	
	move(SeriesUIDArr, targetAet){
		;~ clipboard:=""
		;~ MsgBox % SeriesUIDArr.maxindex() "," SeriesUIDArr[1]
		for k,v in SeriesUIDArr {
			parameter:="-L " this.aet " " this.remote.aet "@" this.remote.ip ":" this.remote.port " -qSeriesInstanceUID=" v " -S -cmove " targetAet
			,outputFileName:="__dcm4cheOutput" a_now
			;~ MsgBox % parameter
			;~ RunWait,% """" this.dcmqrPath """ " parameter " > """ a_scriptdir "\" outputFileName """",% a_scriptdir
			Run,% """" this.dcmqrPath """ " parameter " > """ a_scriptdir "\" outputFileName """",% a_scriptdir
			;~ fileread,__dcm4cheOutput,% A_ScriptDir "\" outputFileName
			;~ FileDelete,% A_ScriptDir "\" outputFileName
			;~ this.LastOutput:=__dcm4cheOutput
			;~ fileread,__dcm4cheOutput,% A_ScriptDir "\" outputFileName
			;~ clipboard.=__dcm4cheOutput
			;~ FileDelete,% A_ScriptDir "\" outputFileName
		}
	}
	
	DicomTagNameToId(n){
		static nameToId:={StudyDate:"80020",AccessionNumber:"80050",QueryRetrieveLevel:"80052",Modality:"80060",PatiendID:"100020",StudyInstanceUID:"20000D",SeriesInstanceUID:"20000E",SeriesNumber:"200011",NumberofSeriesRelatedInstances:"201209",SliceThickness:"180050",SpacingBetweenSlices:"180088",StudyDescription:"81030"}
		if (v:=nameToId[RegExReplace(n, "\W", "")])=""
			return
		while StrLen(v)<8
			v:="0" v
		return  SubStr(v,1,4) "," SubStr(v,5,4)
	}
	
	PACStoRAID(AccNoOrChartNoDate){
		if !IsObject(AccNo:=AccNoOrChartNoDate)
			parameter:="-L EPHICT01AW02:104 PACSWFM2@10.0.0.100:104 -q00080050=" AccNo " -cmove RAID"
		else {
			chartNo:=AccNoOrChartNoDate.ChartNo
			, date:=AccNoOrChartNoDate.date
			if(chartNo!="" && date!="")
				parameter:="-L EPHICT01AW02:104 PACSWFM2@10.0.0.100:104 -qPatientID=" chartNo " -qInstanceCreationDate=" date " -cmove RAID"
			else 
				return
		}
		outputFileName:="__dcm4cheOutput" a_now
			;~ MsgBox % parameter
			;~ RunWait,% """" this.dcmqrPath """ " parameter " > """ a_scriptdir "\" outputFileName """",% a_scriptdir
			Run,% """" this.dcmqrPath """ " parameter " > """ a_scriptdir "\" outputFileName """",% a_scriptdir
			;~ fileread,__dcm4cheOutput,% A_ScriptDir "\" outputFileName
			;~ FileDelete,% A_ScriptDir "\" outputFileName
			;~ this.LastOutput:=__dcm4cheOutput
	}
}