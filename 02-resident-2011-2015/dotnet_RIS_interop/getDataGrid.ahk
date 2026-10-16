#include CLR.ahk


fileread,c#,getDataGrid.cs

CLR_Start()

; Compile and execute C# code
asm := CLR_CompileC#(c#, "System.dll | System.Windows.Forms.dll | C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.0\UIAutomationClient.dll | C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.0\UIAutomationTypes.dll")
obj := CLR_CreateObject(asm, "RIS")
obj.getDataGrid()
exitapp
return


~esc::
ExitApp
return