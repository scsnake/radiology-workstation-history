/* 
	Credit to Wanker
	
	author 	: Chef
	link 	: http://ahkscript.org/boards/memberlist.php?mode=viewprofile&u=55319
	date 	: 14 January 2014
	description
		Process-related functions
*/	

process_property(pid, property)
{
	/*
		available properties:
			Caption
			CommandLine
			CreationClassName
			CreationDate
			CSCreationClassName
			CSName
			Description
			ExecutablePath
			ExecutionState
			Handle
			HandleCount
			InstallDate
			KernelModeTime
			MaximumWorkingSetSize
			MinimumWorkingSetSize
			Name
			OSCreationClassName
			OSName
			OtherOperationCount
			OtherTransferCount
			PageFaults
			PageFileUsage
			ParentProcessId
			PeakPageFileUsage
			PeakVirtualSize
			PeakWorkingSetSize
			Priority
			PrivatePageCount
			ProcessId
			QuotaNonPagedPoolUsage
			QuotaPagedPoolUsage
			QuotaPeakNonPagedPoolUsage
			QuotaPeakPagedPoolUsage
			ReadOperationCount
			ReadTransferCount
			SessionId
			Status
			TerminationDate
			ThreadCount
			UserModeTime
			VirtualSize
			WindowsVersion
			WorkingSetSize
			WriteOperationCount
			WriteTransferCount
		
		msdn
			
			http://msdn.microsoft.com/en-us/library/aa394372%28v=vs.85%29.aspx
	*/
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where ProcessId=" pid)
		return, process[property]
}

process_isFirstInstance()
{
	if !a_isCompiled
	{
		msgBox, 0x40010,% a_thisFunc "()",This function can only be used with compiled scripts!`n`n"%a_scriptName%"
		return
	}
	scriptPID := DllCall( "GetCurrentProcessId" )
	process, exist, %A_Scriptname%
	ifequal,scriptPID,%errorLevel%,return 1
}

process_instanceCount(name)
{
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where Name='" name "'")
		count := a_index
	return count
}