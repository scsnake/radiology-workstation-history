#include CLR.ahk
#persistent
#SingleInstance,force
SetBatchLines,-1
SetWorkingDir,% a_scriptdir
OnMessage(0x10303,"BuildString")
tempStr:=""
params:=[]

FileInstall,Interop.mitra_context_server.dll,%a_scriptdir%\Interop.mitra_context_server.dll,1
filedelete,% a_scriptdir "\ImpaxContextServer.exe"

vb =
(
Option Strict Off
Option Explicit On
Imports System
Imports System.Windows.Forms
    


    Public Class ImpaxContextServer

        Public Connector As mitra_context_server.connector_class = New mitra_context_server.connector_class
        Public WithEvents Server As mitra_context_server.context_server = Connector.ContextServer
        
        Public Shared Sub Main()
        End Sub
        
        Public Sub ImpaxContextServerInvoke(ByVal param1 As String, ByVal param2 As String, ByVal param3 As String, ByVal param4 As String)
            
            Call Server.DoAction(param1, param2, param3, param4)

        End Sub
    End Class
)


; Compile and execute VB code
CLR_Start()
CLR_StartDomain(pApp, a_scriptdir) 
CLR_CompileVB(vb, "System.dll | System.Windows.Forms.dll | " a_scriptdir "\Interop.mitra_context_server.dll", pApp, a_scriptdir "\ImpaxContextServer.exe")
while !fileexist(a_scriptdir "\ImpaxContextServer.exe")
    sleep 100
asm:=CLR_LoadLibrary("ImpaxContextServer.exe", pApp)
obj := CLR_CreateObject(asm, "ImpaxContextServer")

return 


BuildString(wParam, lParam, msg, hwnd){
    Critical
    global tempStr,params,obj
    if (lParam!=0x0)
        tempStr.=Chr(lParam)
    else {
        params.push(tempStr)
        Tooltip % tempStr "," params.maxindex() "," isobject(obj)
        tempStr:=""
        if (params.maxIndex()=4)
            COM_Invoke(obj,"ImpaxContextServerInvoke", params[1], params[2], params[3], params[4])
            ,params:=[]
    }
}

    
esc::exitapp
    
;~ msgbox % DllCall("C:\Program Files\Agfa\IMPAX Client\6.5.2.114\impax-client-study-image-viewer.dll\get_day")

;~ #include <risimpax>

;~ msgbox % impaxopened()[2,1]