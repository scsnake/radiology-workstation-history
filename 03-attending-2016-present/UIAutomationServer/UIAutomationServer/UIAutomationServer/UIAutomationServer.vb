Imports System.Windows.Automation
Imports System.Runtime.InteropServices
Imports System.Text.RegularExpressions
Imports System.Threading

Public Class UIAutomationServer
    Private watchEvents As New Dictionary(Of String, ArrayList)
    Private lockObj As Boolean
    Private msgFrom As UInteger
    Private eventHandlers As New ArrayList
    'Private ElementSubscribeButton As AutomationElement
    'Private UIAeventHandler As AutomationEventHandler
    'Private ElementSubscribeEdit As AutomationElement
    'Private textChangeHandler As AutomationEventHandler
    'Private propChangeHandler As AutomationPropertyChangedEventHandler
    'Private focusHandler As AutomationFocusChangedEventHandler
    'Private rgx As New Regex("([^_]*)")
    'Private timer As New Timer(AddressOf scheduledSub, New Object() {}, 0, 60000)

    Private Sub Form1_Load(ByVal sender As Object, _
    ByVal e As System.EventArgs) Handles MyBase.Load
        'Dim startWin = AutomationElement.FromHandle(&H11E4E)
        'Call SubscribeToEvent(New Object() {startWin, 1})
        'Dim walker As TreeWalker = TreeWalker.ControlViewWalker
        'Dim child As AutomationElement = walker.GetFirstChild(startWin)
        'Dim index = 100
        'For x As Integer = 1 To (index - 1)
        '    child = walker.GetNextSibling(child)
        '    If child = Nothing Then

        '        Throw New ArgumentOutOfRangeException()
        '    End If
        'Next x


        'Dim elementCollection As AutomationElementCollection = startWin.FindAll(TreeScope.Children, Condition.TrueCondition)

        'MsgBox(SendMessage(&H49077C, &H10303, 123, 321))
        'Application.Exit()

        'SetForegroundWindow(Process.GetCurrentProcess().MainWindowHandle)


        xTimer = New System.Windows.Forms.Timer
        xTimer.Interval = 60000
    End Sub

    <DllImport("kernel32.dll")> _
        Public Shared Function LocalAlloc(ByVal flag As Integer, ByVal size As Integer) As IntPtr
    End Function
    <DllImport("kernel32.dll")> _
    Public Shared Function LocalFree(ByVal p As IntPtr) As IntPtr
    End Function
    <DllImport("user32.dll")> _
    Public Shared Function SendMessage(ByVal hWnd As IntPtr, ByVal Msg As Integer, ByVal wParam As IntPtr, ByVal lParam As IntPtr) As Integer
    End Function
    <DllImport("user32.dll")> _
    Private Shared Function SetForegroundWindow(ByVal hwnd As Long) As IntPtr
    End Function
    <DllImport("user32.dll", CharSet:=CharSet.Auto, ExactSpelling:=True)> _
Public Shared Function IsWindow(ByVal hWnd As IntPtr) As Boolean
    End Function

    Protected Overrides Sub WndProc(ByRef m As System.Windows.Forms.Message)
        If (m.Msg = WM_COPYDATA) Then
            ' Get the COPYDATASTRUCT struct from lParam.
            Dim cds As COPYDATASTRUCT = m.GetLParam(GetType(COPYDATASTRUCT))

            Dim str As String = Marshal.PtrToStringUni(cds.lpData)
            Dim v As Integer
            If Integer.TryParse(m.HWnd, v) Then
                parseArgs(str, v)
            End If
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
        'MsgBox(Hex(hWndDest))
        LocalFree(oCDS.lpData)
        FreeHGlobal(lParam)
    End Sub

    Public Sub GetMsgString(ByVal str As String)

    End Sub

#Region "Timer function"
    Private WithEvents xTimer As New System.Windows.Forms.Timer

  

    Public Sub StartTimer()
        xTimer.Start()
    End Sub

    Public Sub StopTimer()
        xTimer.Stop()
    End Sub

    Private Sub Timer_Tick() Handles xTimer.Tick
        SampleProcedure()
    End Sub

    Private Sub SampleProcedure()
        Dim rx As New Regex("^[^\_]+")
        Dim match As String

        While lockObj
        End While
        lockObj = True

        Dim v As Integer

        For Each key In watchEvents.Keys
            match = rx.Match(key).ToString()
            If Integer.TryParse(match, v) And (Not IsWindow(New IntPtr(CInt(v)))) Then
                watchEvents.Remove(key)
            End If
        Next

        lockObj = False

    End Sub

#End Region

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

    ''' <summary>
    ''' param: "|" as delimiter
    ''' eventHwnd|eventType|responseMsg|responseLParam|responseToHwnd
    ''' 
    ''' eventType: 0=invokeEvent, 1=propertyChangedEvent(NameProperty)
    '''  
    ''' </summary>
    ''' <param name="param"></param>
    ''' <remarks></remarks>
    Public Sub parseArgs(ByVal param As String, ByVal sourceHwnd As UInteger)
        Dim params = Split(param, "|")
        Dim ele As AutomationElement
        Dim residual = (params.Length Mod 5)
        Dim len = params.Length
        If residual <> 0 Then

            Array.Resize(params, len + 5 - residual)
            For i As Integer = 1 To 5 - residual
                params(len - 1 + i) = ""
            Next
            len = len + 5 - residual
        End If

        Dim j As Integer = 0, args(4) As String
        Do Until j > len - 1
            For k As Integer = 0 To 4
                args(k) = Trim(params(j + k))
            Next

            If CInt(args(4)) = 0 Then
                args(4) = CStr(sourceHwnd)
            End If

            While (lockObj)
            End While
            lockObj = True
            Dim key As String = args(0) & "_" & args(1)
            'MsgBox(key)
            If args(1) = "2" Then
                key = "_2"
            End If

            Dim v, v2 As Integer


            If watchEvents.ContainsKey(key) Then
                watchEvents.Item(key).Add(args)
                lockObj = False
            Else

                watchEvents.Add(key, New ArrayList)
                lockObj = False


                If Integer.TryParse(args(0), v) And Integer.TryParse(args(1), v2) Then
                    Try
                        ele = AutomationElement.FromHandle(New IntPtr(v))
                        Dim oThread As New Threading.Thread(New Threading.ParameterizedThreadStart(AddressOf SubscribeToEvent))
                        With oThread
                            .IsBackground = True
                            .Priority = Threading.ThreadPriority.Normal
                            .Name = "SubscribeToEvent"

                            .Start(New Object() {ele, v2})
                        End With
                    Catch ex As Exception
                        MsgBox(ex.ToString)
                        Exit Sub
                    End Try

                    'SubscribeToEvent(ele, CInt(args(1)))
                End If
            End If



            j = j + 5
        Loop


    End Sub

    ' Member variables.


    ''' <summary>
    ''' Register an event handler for InvokedEvent on the specified element.
    ''' </summary>
    ''' <param name="args">The automation element.</param>
    Public Sub SubscribeToEvent(ByVal args As Object())
        Dim elementTarget As AutomationElement = args(0)
        Dim eventType As Integer = args(1)
        'MsgBox(elementTarget.Current.NativeWindowHandle & "," & eventType)
        If (elementTarget IsNot Nothing) Then
            Dim ElementSubscribe = elementTarget
            If eventType = 0 Then
                Dim UIAeventHandler = New AutomationEventHandler(AddressOf OnUIAutomationEvent)
                Automation.AddAutomationEventHandler(InvokePattern.InvokedEvent, elementTarget, _
                TreeScope.Element, UIAeventHandler)
                eventHandlers.Add(New Object() {0, UIAeventHandler, ElementSubscribe})
                'ElseIf eventType = 1 Then
                '    textChangeHandler = New AutomationEventHandler(AddressOf OnUIAutomationEvent)
                '    Automation.AddAutomationEventHandler(TextPattern.TextChangedEvent, elementTarget, _
                '    TreeScope.Element, textChangeHandler)
                '    ElementSubscribeEdit = elementTarget
            ElseIf eventType = 1 Then
                Dim propChangeHandler = New AutomationPropertyChangedEventHandler(AddressOf OnPropertyChange)
                Automation.AddAutomationPropertyChangedEventHandler(elementTarget, TreeScope.Element, _
                    propChangeHandler, ValuePattern.ValueProperty)
                eventHandlers.Add(New Object() {1, propChangeHandler, ElementSubscribe})
            ElseIf eventType = 2 Then
                Dim focusHandler = New AutomationFocusChangedEventHandler(AddressOf OnFocusChange)
                Automation.AddAutomationFocusChangedEventHandler(focusHandler)
                eventHandlers.Add(New Object() {2, focusHandler})
            ElseIf eventType = 3 Then
                Dim structureHandler = New StructureChangedEventHandler(AddressOf OnStructureChange)
                Automation.AddStructureChangedEventHandler(ElementSubscribe, TreeScope.Subtree, structureHandler)
                eventHandlers.Add(New Object() {3, structureHandler})
            End If


        End If

    End Sub 'SubscribeToEvent


    ''' <summary>
    ''' AutomationEventHandler delegate.
    ''' </summary>
    ''' <param name="src">Object that raised the event.</param>
    ''' <param name="e">Event arguments.</param>
    Private Sub OnUIAutomationEvent(ByVal src As Object, ByVal e As AutomationEventArgs)
        ' Make sure the element still exists. Elements such as tooltips can disappear
        ' before the event is processed.
        Dim sourceElement As AutomationElement
        Dim response As String()

        Try
            sourceElement = DirectCast(src, AutomationElement)
        Catch ex As ElementNotAvailableException
            MsgBox(ex.ToString)
            Exit Sub
        End Try
        'MsgBox("invoked")
        'MsgBox(e.EventId Is InvokePattern.InvokedEvent)
        'If e.EventId Is InvokePattern.InvokedEvent Then
        Try
            While lockObj
            End While
            lockObj = True
            For Each response In watchEvents.Item(CStr(GetAncestorHwnd(sourceElement)) & "_0")
                SendMessage(New IntPtr(CInt(response(4))), CInt(response(2)), New IntPtr(0), New IntPtr(CInt(response(3))))
            Next

            'MsgBox(GetLastError())
        Catch ex As Exception
            MsgBox(ex.ToString)
            Exit Sub
        Finally
            lockObj = False
        End Try
        'ElseIf e.EventId Is TextPattern.TextChangedEvent Then
        '    Try
        '        While lockObj
        '        End While
        '        lockObj = True
        '        response = watchEvents.Item(CStr(sourceElement.Current.NativeWindowHandle) & "_1")
        '        lockObj = False
        '        Call SendMessage(clng(response(4)), clng(response(2)), 0, clng(response(3)))
        '    Catch ex As Exception
        '        MsgBox(ex.ToString)
        '        Exit Sub
        '    End Try

        'Else
        'End If
        ' TODO Handle any other events that have been subscribed to.
        ' Console.WriteLine("Event: " & e.EventId.ProgrammaticName)
    End Sub 'OnUIAutomationEvent

    Private Sub ShutdownUIA()
        For Each eventHandler As Object() In eventHandlers
            Select Case eventHandler(0)
                Case 0
                    Automation.RemoveAutomationEventHandler(InvokePattern.InvokedEvent, eventHandler(2), eventHandler(1))
                Case 1
                    Automation.RemoveAutomationPropertyChangedEventHandler(eventHandler(2), eventHandler(1))
                Case 2
                    Automation.RemoveAutomationFocusChangedEventHandler(eventHandler(1))
                Case Else

            End Select
        Next

    End Sub 'ShutdownUIA




    ''' <summary>
    ''' Handler for property changes.
    ''' </summary>
    ''' <param name="src">The source whose properties changed.</param>
    ''' <param name="e">Event arguments.</param>
    Private Sub OnPropertyChange(ByVal src As Object, ByVal e As AutomationPropertyChangedEventArgs)
        Dim sourceElement As AutomationElement = DirectCast(src, AutomationElement)
        Dim response As String()
        'MsgBox("propertyChanged")
        'If e.Property Is ValuePattern.ValueProperty Then
        Try
            While lockObj
            End While
            lockObj = True
            'MsgBox("")
            For Each response In watchEvents.Item(CStr(GetAncestorHwnd(sourceElement)) & "_1")
                SendMessage(New IntPtr(CInt(response(4))), CInt(response(2)), New IntPtr(0), New IntPtr(CInt(response(3))))
                'MsgBox(response(4) & response(2) & response(3))
            Next
            'MsgBox(GetLastError())
        Catch ex As Exception
            MsgBox(ex.ToString)
            Exit Sub
        Finally
            lockObj = False
        End Try
        ' Else
        'End If
        'MsgBox(e.Property.ToString)
    End Sub 'OnPropertyChange




    ''' <summary>
    ''' Handle the event.
    ''' </summary>
    ''' <param name="src">Object that raised the event.</param>
    ''' <param name="e">Event arguments.</param>
    Private Sub OnFocusChange(ByVal src As Object, ByVal e As AutomationFocusChangedEventArgs)
        Dim sourceElement As AutomationElement = DirectCast(src, AutomationElement)
        Dim response As String()
        Try
            While lockObj
            End While
            lockObj = True

            For Each response In watchEvents.Item("_2")
                SendMessage(New IntPtr(CInt(response(4))), CInt(response(2)), New IntPtr(0), New IntPtr(GetAncestorHwnd(sourceElement)))
            Next
            'MsgBox()
            'MsgBox(GetLastError())
        Catch ex As Exception
            MsgBox(ex.ToString)
            Exit Sub
        Finally
            lockObj = False
        End Try
    End Sub 'OnFocusChange

    Private Sub OnStructureChange(ByVal sender As Object, ByVal e As StructureChangedEventArgs)
        Dim changeType As Integer = 0
        Dim sourceElement As AutomationElement = DirectCast(sender, AutomationElement)
        If e.StructureChangeType = StructureChangeType.ChildrenBulkAdded Or _
            e.StructureChangeType = StructureChangeType.ChildAdded Then
            changeType = 1
        ElseIf e.StructureChangeType = StructureChangeType.ChildrenBulkRemoved Or _
            e.StructureChangeType = StructureChangeType.ChildRemoved Then
            changeType = 2
        End If
        'MsgBox(changeType)

        If changeType <> 0 Then
            Dim response As String()
            Try
                While lockObj
                End While
                lockObj = True

                For Each response In watchEvents.Item("_3")
                    SendMessage(New IntPtr(CInt(response(4))), CInt(response(2)), New IntPtr(changeType), New IntPtr(GetAncestorHwnd(sourceElement)))
                Next
                'MsgBox()
                'MsgBox(GetLastError())
            Catch ex As Exception
                MsgBox(ex.ToString)
                Exit Sub
            Finally
                lockObj = False
            End Try
        End If

    End Sub 'OnStructureChanged


    ''' <summary>
    ''' Gets the toggle state of an element in the target application.
    ''' </summary>
    ''' <param name="element">The target element.</param>
    Private Function IsElementToggledOn(ByVal element As AutomationElement) As Boolean
        If element Is Nothing Then
            ' TODO: Invalid parameter error handling.
            Return False
        End If

        Dim objPattern As Object = Nothing
        Dim togPattern As TogglePattern
        If True = element.TryGetCurrentPattern(TogglePattern.Pattern, objPattern) Then
            togPattern = TryCast(objPattern, TogglePattern)
            Return togPattern.Current.ToggleState.GetHashCode
        End If
        ' TODO: Object doesn't support TogglePattern error handling.
        Return False
    End Function

    Private Function GetAncestorHwnd(ByVal element As AutomationElement) As Long
        Dim propertyIdWindowHandle = 30020
        Dim propValueWindow As Int32 = 0

        Dim conditionNativeWindowHandleZero = New PropertyCondition(AutomationElement.NativeWindowHandleProperty, propValueWindow)
        Dim conditionNativeWindowHandleNOTZero = New NotCondition(conditionNativeWindowHandleZero)

        Dim walker = New TreeWalker(conditionNativeWindowHandleNOTZero)

        Dim cacheRequest = New CacheRequest
        'cacheRequest.Add(AutomationElement.NameProperty)
        'cacheRequest.Add(AutomationElement.BoundingRectangleProperty)
        cacheRequest.Add(AutomationElement.NativeWindowHandleProperty)
        cacheRequest.AutomationElementMode = AutomationElementMode.None

        Dim elementAncestorWithWindow = walker.Normalize(element, cacheRequest)

        Return elementAncestorWithWindow.Cached.NativeWindowHandle
    End Function

    'Private Sub scheduledSub()
    '    While lockObj
    '    End While
    '    lockObj = True

    '    For Each key As String In watchEvents.Keys
    '        Dim matches As MatchCollection = rgx.Matches(key)

    '    Next
    '    lockObj = False
    'End Sub


End Class
