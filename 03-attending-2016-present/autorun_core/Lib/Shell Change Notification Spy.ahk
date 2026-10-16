; Shell Change Notification Spy - By SKAN                            Created : 24-Aug-2012
; http://dl.dropbox.com/u/6428211/AutoHotkey/ShellChangeNotification/ShChangeNotifySpy.ahk

#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
OnExit, QuitScript

Gui +AlwaysOnTop +LastFound
hGui := WinExist()
Gui, Font, S8
Gui, Add, ListView, +Grid w600 r50, EVENT|Values
LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int,20, Int,0x18, Int,1, Int,1 ), 1 )
LV_ModifyCol( 1, 150 )
Gui, Show, y150, Shell Change Notification Spy

MsgNo := DllCall( "RegisterWindowMessage", Str,"SHCHANGENOTIFY" )
OnMessage( MsgNo, "ShChangeNotify" )

DriveGet, DriveList, List, Fixed
Entries := StrLen( DriveList )
VarSetCapacity( $SHChangeNotifyEntry, 8 * Entries, 0 )
Loop, Parse, DriveList
   Off  := ( A_Index - 1 ) * 8
 , PIDL := PathGetPIDL( A_LoopField ":" )
 , NumPut( PIDL, $SHChangeNotifyEntry, Off+0 )
 , NumPut( True, $SHChangeNotifyEntry, Off+4 )

SHCNR_ID := DllCall( "Shell32\SHChangeNotifyRegister", UInt,hGui
                   , UInt, 0x8000|0x1000|0x2|0x1
                   , Int,  0xC0581E0|0x7FFFFFFF|0x80000000
                   , UInt, MsgNo
                   , Int,  Entries
                   , UInt, &$SHChangeNotifyEntry )
Return


GuiClose:
GuiEscape:
QuitScript:
 OnExit
 DllCall( "Shell32\SHChangeNotifyDeregister", UInt,SHCNR_ID )
 ExitApp


ShChangeNotify( wParam, lParam, msg, hwnd ) {
 hLock := DllCall( "Shell32\SHChangeNotification_Lock"
                 , UInt,wParam, UInt,lParam, UIntP,pppidl, UIntP,plEvent )

 Event := "SHCNE_UNDEFINED"
 IfEqual,plEvent,0x7FFFFFFF ,SetEnv,Event, SHCNE_ALLEVENTS
 IfEqual,plEvent,0x08000000 ,SetEnv,Event, SHCNE_ASSOCCHANGED
 IfEqual,plEvent,0x00000800 ,SetEnv,Event, SHCNE_ATTRIBUTES
 IfEqual,plEvent,0x00000002 ,SetEnv,Event, SHCNE_CREATE
 IfEqual,plEvent,0x00000004 ,SetEnv,Event, SHCNE_DELETE
 IfEqual,plEvent,0x0002381F ,SetEnv,Event, SHCNE_DISKEVENTS
 IfEqual,plEvent,0x00000100 ,SetEnv,Event, SHCNE_DRIVEADD
 IfEqual,plEvent,0x00010000 ,SetEnv,Event, SHCNE_DRIVEADDGUI
 IfEqual,plEvent,0x00000080 ,SetEnv,Event, SHCNE_DRIVEREMOVED
 IfEqual,plEvent,0x04000000 ,SetEnv,Event, SHCNE_EXTENDED_EVENT
 IfEqual,plEvent,0x00040000 ,SetEnv,Event, SHCNE_FREESPACE
 IfEqual,plEvent,0x0C0581E0 ,SetEnv,Event, SHCNE_GLOBALEVENTS
 IfEqual,plEvent,0x80000000 ,SetEnv,Event, SHCNE_INTERRUPT
 IfEqual,plEvent,0x00000020 ,SetEnv,Event, SHCNE_MEDIAINSERTED
 IfEqual,plEvent,0x00000040 ,SetEnv,Event, SHCNE_MEDIAREMOVED
 IfEqual,plEvent,0x00000008 ,SetEnv,Event, SHCNE_MKDIR
 IfEqual,plEvent,0x00000200 ,SetEnv,Event, SHCNE_NETSHARE
 IfEqual,plEvent,0x00000400 ,SetEnv,Event, SHCNE_NETUNSHARE
 IfEqual,plEvent,0x00020000 ,SetEnv,Event, SHCNE_RENAMEFOLDER
 IfEqual,plEvent,0x00000001 ,SetEnv,Event, SHCNE_RENAMEITEM
 IfEqual,plEvent,0x00000010 ,SetEnv,Event, SHCNE_RMDIR
 IfEqual,plEvent,0x00004000 ,SetEnv,Event, SHCNE_SERVERDISCONNECT
 IfEqual,plEvent,0x00001000 ,SetEnv,Event, SHCNE_UPDATEDIR
 IfEqual,plEvent,0x00008000 ,SetEnv,Event, SHCNE_UPDATEIMAGE
 IfEqual,plEvent,0x00002000 ,SetEnv,Event, SHCNE_UPDATEITEM

 If Val2 := PIDLGetPath( NumGet( pppidl+4 ) )
 LV_Insert( 1, "", "", Val2 )

 Val1 := PIDLGetPath( NumGet( pppidl+0 ) )
 LV_Insert( 1, "", Event, Val1 )

 DllCall( "Shell32\SHChangeNotification_Unlock", UInt,hLock )
}

PathGetPIDL( sPath ) {
 Return DllCall( "Shell32\ILCreateFromPath" ( A_IsUnicode ? "W":"A" ), Str,sPath, UInt )
}

PIDLGetPath( PIDL ) {
 VarSetCapacity( sPath, 520, 0 )
 DllCall( "Shell32\SHGetPathFromIDList" ( A_IsUnicode ? "W":"A" ), UInt,PIDL, Str,sPath )
Return sPath
}
