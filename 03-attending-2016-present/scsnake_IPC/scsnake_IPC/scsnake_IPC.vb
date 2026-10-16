Imports System.Runtime.InteropServices

Public Class scsnake_IPC
    <DllImport("kernel32.dll")> _
        Public Shared Function LocalAlloc(ByVal flag As Integer, ByVal size As Integer) As IntPtr
    End Function
    <DllImport("kernel32.dll")> _
    Public Shared Function LocalFree(ByVal p As IntPtr) As IntPtr
    End Function
    <DllImport("user32.dll")> _
    Public Shared Function SendMessage(ByVal hWnd As IntPtr, ByVal Msg As Integer, ByVal wParam As IntPtr, ByVal lParam As IntPtr) As Integer
    End Function

    Protected Overrides Sub WndProc(ByRef m As System.Windows.Forms.Message)
        If (m.Msg = WM_COPYDATA) Then
            ' Get the COPYDATASTRUCT struct from lParam.
            Dim cds As COPYDATASTRUCT = m.GetLParam(GetType(COPYDATASTRUCT))

            Dim str As String = Marshal.PtrToStringUni(cds.lpData)
            GetMsgString(str)
        End If

        MyBase.WndProc(m)
    End Sub

    'Create wrappers for the memory API's similar to
    'Marshal.AllocHGlobal and Marshal.FreeHGlobal

    Public Shared Function AllocHGlobal(ByVal cb As Integer) As IntPtr
        Dim hMemory As New IntPtr()
        hMemory = LocalAlloc(LPTR, cb)
        Return hMemory
    End Function

    Public Shared Sub FreeHGlobal(ByVal hMemory As IntPtr)
        If hMemory <> IntPtr.Zero Then
            LocalFree(hMemory)
        End If
    End Sub

    Public Shared Sub SendMsgString(ByVal hWndDest As IntPtr, ByVal sScript As String)
        Dim oCDS As New COPYDATASTRUCT()
        Dim status As String

        oCDS.cbData = (sScript.Length + 1) * 2
        oCDS.lpData = LocalAlloc(64, oCDS.cbData)
        Marshal.Copy(sScript.ToCharArray(), 0, oCDS.lpData, sScript.Length)
        oCDS.dwData = 1
        Dim lParam As IntPtr = AllocHGlobal(oCDS.cbData)
        Marshal.StructureToPtr(oCDS, lParam, False)
        status = SendMessage(hWndDest, WM_COPYDATA, IntPtr.Zero, lParam)
        MsgBox(Hex(hWndDest))
        LocalFree(oCDS.lpData)
        FreeHGlobal(lParam)
    End Sub

    Public Sub GetMsgString(ByVal str As String)

    End Sub

#Region "Native API Signatures and Types"

    ''' <summary>
    ''' An application sends the WM_COPYDATA message to pass data to another 
    ''' application.
    ''' </summary>
    Friend Const WM_COPYDATA As Integer = &H4A
    Const LMEM_FIXED As Integer = 0
    Const LMEM_ZEROINIT As Integer = 64
    Const LPTR As Integer = (LMEM_FIXED Or LMEM_ZEROINIT)


    ''' <summary>
    ''' The COPYDATASTRUCT structure contains data to be passed to another 
    ''' application by the WM_COPYDATA message. 
    ''' </summary>
    <StructLayout(LayoutKind.Sequential)> _
    Friend Structure COPYDATASTRUCT
        Public dwData As IntPtr
        Public cbData As Integer
        Public lpData As IntPtr
    End Structure

#End Region
End Class
