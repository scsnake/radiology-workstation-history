class NamedPipeClass {
	
	__New(pipeName){
		this.ptr := A_PtrSize ? "Ptr" : "UInt"
		,this.char_size := A_IsUnicode ? 2 : 1
		,this.pipe:=-1
		,pipeName:="\\.\pipe\" pipeName
		
		,pipe    := this.CreateNamedPipe(pipeName)
		if (pipe=-1)
			return -1
		
		if !DllCall("ConnectNamedPipe", this.ptr, pipe, this.ptr, 0)
			this.pipe:=pipe
		
	}
	
	send(msg){
		if (this.pipe=-1)
			return
		
		; Standard AHK needs a UTF-8 BOM to work via pipe.  If we're running on
		; Unicode AHK_L, 'Script' contains a UTF-16 string so add that BOM instead:
		msg := (A_IsUnicode ? chr(0xfeff) : chr(239) chr(187) chr(191)) . msg
		
		if !DllCall("WriteFile", ptr, this.pipe, "str", msg, "uint", (StrLen(msg)+1)*this.char_size, "uint*", 0, this.ptr, 0)
			return ErrorLevel
	}
	
	CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255)
    {
    ptr:=this.ptr
    return DllCall("CreateNamedPipe", "str", Name, "uint", OpenMode, "uint", PipeMode, "uint", MaxInstances, "uint", 0, "uint", 0, "uint", 0, ptr, 0, ptr)
    }
	
	__Delete(){
		DllCall("CloseHandle", this.ptr, this.pipe)
	}
}


#Persistent
#NoEnv
np :=new NamedPipeClass("testNP")
