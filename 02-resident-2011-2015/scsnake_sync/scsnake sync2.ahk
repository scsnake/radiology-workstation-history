#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2

process,close,AlwaysSync.exe


RegExMatch(a_scriptdir,"^[^\\]*",root)

ifnotexist,%  A_MyDocuments "\Allway Sync 'n' Go" 
{
    FileCreateDir, % A_MyDocuments "\Allway Sync 'n' Go"
    CopyFilesAndFolders(root "\software\Allway Sync 'n' Go",A_MyDocuments ,true)
}
ifnotexist,% a_mydocuments "\scsnake"
    FileCreateDir, % a_mydocuments "\scsnake"

FileCreateShortcut,% a_mydocuments "\scsnake\執行住院醫師.exe",% a_desktop "\執行住院醫師.lnk"
FileCreateShortcut,% a_mydocuments "\scsnake\searchLab.exe",% a_desktop "\searchLab.lnk"
FileCreateShortcut,% a_mydocuments "\scsnake\Sleipnir\SleipnirLogin.exe",% a_desktop "\SleipnirLogin.lnk"

;~ Run %comspec% /c "net use \\xray-e1f-19\scsnake /user:admin qazWSXedc"
run % A_MyDocuments "\Allway Sync 'n' Go"
run % "control.exe schedtasks"

process,close,AlwaysSync.exe
process,close,autoSync.exe
process,close,cleanDropboxCache.exe
FileCopy,% root "\software\Allway Sync 'n' Go\AlwaysSync.exe",% a_mydocuments "\Allway Sync 'n' Go",1
FileCreateShortcut,% a_mydocuments "\Allway Sync 'n' Go\AlwaysSync.exe",% A_Startup "\AlwaysSync.lnk"
run % a_mydocuments "\Allway Sync 'n' Go\AlwaysSync.exe"

run % a_startup

;~ clipboard:=a_mydocuments "\Allway Sync 'n' Go\Bin\syncappw.exe"

exitapp
return 
CopyFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = false)
; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
; returns the number of files/folders that could not be copied.
{
    ErrorCount := ErrorLevel
    ; Now copy all the folders:
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        FileCopyDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
        if ErrorLevel  ; Report each problem folder by name.
            MsgBox Could not copy %A_LoopFileFullPath% into %DestinationFolder%.
    }
    return ErrorCount
}