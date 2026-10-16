Imports System.Runtime.InteropServices

Public Class ImpaxContextServer
    <DllImport("kernel32.dll")> _
        Public Shared Function LocalAlloc(ByVal flag As Integer, ByVal size As Integer) As IntPtr
    End Function
    <DllImport("kernel32.dll")> _
    Public Shared Function LocalFree(ByVal p As IntPtr) As IntPtr
    End Function
    <DllImport("user32.dll")> _
    Public Shared Function SendMessage(ByVal hWnd As IntPtr, ByVal Msg As Integer, ByVal wParam As IntPtr, ByVal lParam As IntPtr) As Integer
    End Function
    Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

    'Private WithEvents BS As New BuildString
    Public Connector As mitra_context_server.connector_class
    Public WithEvents Server As mitra_context_server.context_server

    'Dim login = 0
    'Dim loginInfo As String
    'Dim buffer As String
    'Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
    'Private Declare Function GetSystemMenu Lib "user32" (ByVal hwnd As Long, ByVal bRevert As Long) As Long
    'Private Const GWL_EXSTYLE = (-20)
    'Private Const WS_EX_TOOLWINDOW = &H80

    Private Sub Form1_Closed(ByVal sender As Object, _
    ByVal e As System.EventArgs) Handles MyBase.Closed

    End Sub

    Private Sub Form1_Load(ByVal sender As Object, _
        ByVal e As System.EventArgs) Handles MyBase.Load
        newContextServer()
    End Sub

    Protected Overrides Sub WndProc(ByRef m As System.Windows.Forms.Message)
        If (m.Msg = WM_COPYDATA) Then
            ' Get the COPYDATASTRUCT struct from lParam.
            Dim cds As COPYDATASTRUCT = m.GetLParam(GetType(COPYDATASTRUCT))

            Dim str As String = Marshal.PtrToStringUni(cds.lpData)
            'MsgBox(str)
            'Try
            '    Dim oThread As New Threading.Thread(New Threading.ParameterizedThreadStart(AddressOf ImpaxContextServerInvoke))
            '    With oThread
            '        .IsBackground = True
            '        .Priority = Threading.ThreadPriority.BelowNormal
            '        .Name = "ImpaxContextServerInvoke"

            '        .Start(New Object() {str})
            '    End With
            'Catch ex As Exception
            '    MsgBox(ex.ToString)
            'End Try
            
            ImpaxContextServerInvoke(str)
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



    Public Sub ImpaxContextServer_Load(ByVal sender As Object, _
    ByVal e As System.EventArgs) Handles MyBase.Load
        'Connector = New mitra_context_server.connector_class
        'Server = Connector.ContextServer
        'Me.ShowInTaskbar = False
        'SetWindowLong(Me.Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW)
        'Me.Refresh()
        'GetSystemMenu(Me.Handle, True)
    End Sub

    Public Sub newContextServer()
        Connector = New mitra_context_server.connector_class
        Server = Connector.ContextServer
    End Sub


    Public Sub ImpaxContextServerInvoke(ByVal param As String)
        Dim params = Split(param, "|")


        Dim i As Integer = 0
        Dim j As Integer
        Dim len = params.length
        Dim arg(3) As String
        Do Until i > len - 1
            For j = 1 To 4
                If (i + j) > len Then
                    arg(j - 1) = ""
                Else
                    arg(j - 1) = Trim(params(i + j - 1))
                End If
            Next
            'MsgBox(arg(0) & "," & arg(1) & "," & arg(2) & "," & arg(3))
            
            Try
                Dim oThread As New Threading.Thread(New Threading.ParameterizedThreadStart(AddressOf ServerDoAction))
                With oThread
                    .IsBackground = True
                    .Priority = Threading.ThreadPriority.BelowNormal
                    .Name = "ServerDoAction"

                    .Start(New String() {arg(0), arg(1), arg(2), arg(3)})
                End With
                'Call Server.DoAction(arg(0), arg(1), arg(2), arg(3))
            Catch ex As Exception
                MsgBox(ex.ToString)
                Exit Sub
            End Try

            i = i + 4
        Loop


    End Sub

    Public Sub ServerDoAction(ByVal arg As String())
        If Not TypeOf Server Is mitra_context_server.context_server Then
            newContextServer()
        End If
        Server.DoAction(arg(0), arg(1), arg(2), arg(3))
    End Sub


    Public Sub ImpaxContextServerLogin(ByVal param As String)
        'Dim params = Split(param)
        'Dim ret_length As Integer
        'Dim encrypted_password_temp As String
        'Dim password As String
        'Dim lengthPassword As Integer

        'password = params(1)
        'lengthPassword = Len(password)

        'encrypted_password_temp = New String(" ", Len(password) + 16)


        'ret_length = MitraCryptoEncrypt(password, encrypted_password_temp, lengthPassword)
        'Server.UserName = params(0)
        'Server.password = Microsoft.VisualBasic.Left(encrypted_password_temp, ret_length)

        'Server.PerformUserValidation()

        'login = 1

    End Sub



End Class