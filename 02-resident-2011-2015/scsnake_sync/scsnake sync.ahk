#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2

process,close,AlwaysSync.exe
process,close,SyncBackFree.exe
process,close,autoSync.exe
process,close,cleanDropboxCache.exe

RegExMatch(a_scriptdir,"^[^\\]*",root)

FileRemoveDir,%  A_MyDocuments "\SyncBack",1
filedelete,% a_mydocuments "\scsnake\AlwaysSync.exe"
filedelete,% a_mydocuments "\scsnake\TempTask.exe"
filedelete,% A_Startup "\dropbox.lnk"
FileRemoveDir,% a_mydocuments "\Allway Sync 'n' Go",1
FileRemoveDir,% a_mydocuments "\FreeFileSync",1
FileRemoveDir,% a_mydocuments "\scsnake\SyncBack",1

ifnotexist,%  A_MyDocuments "\SyncBack" 
{
    FileCreateDir, % A_MyDocuments "\SyncBack"
    CopyFilesAndFolders(root "\software\SyncBack",A_MyDocuments ,true)
}
ifnotexist,% a_mydocuments "\scsnake"
    FileCreateDir, % a_mydocuments "\scsnake"


CopyFilesAndFolders(root "\software\SyncBack",A_MyDocuments "\scsnake" ,true)

FileCreateShortcut,% a_mydocuments "\scsnake\執行住院醫師.exe",% a_desktop "\執行住院醫師.lnk"
FileCreateShortcut,% a_mydocuments "\scsnake\searchLab.exe",% a_desktop "\searchLab.lnk"
FileCreateShortcut,% a_mydocuments "\scsnake\Sleipnir\SleipnirLogin.exe",% a_desktop "\SleipnirLogin.lnk"

IfNotExist,% a_mydocuments "\FirefoxPortable"
{
    CopyFilesAndFolders(root "\software\FirefoxPortable",a_mydocuments,true)
    FileCreateShortcut,% a_mydocuments "\FirefoxPortable\FirefoxPortable.exe",% a_desktop "\Firefox.lnk"
}

;~ Run %comspec% /c "net use \\xray-e1f-19\scsnake /user:admin qazWSXedc"
run % A_MyDocuments "\SyncBack"
;~ run % "control.exe schedtasks"



FileCopy,% root "\scripts\scsnake sync\AlwaysSync.exe",% a_mydocuments "\SyncBack",1
FileCopy,% root "\scripts\scsnake sync\tempTask.exe",% a_mydocuments "\scsnake",1
FileCreateShortcut,% a_mydocuments "\SyncBack\AlwaysSync.exe",% A_Startup "\AlwaysSync.lnk",% a_mydocuments "\SyncBack"

sleep 1000
run % a_mydocuments "\SyncBack\AlwaysSync.exe"

;~ run % root "\software\FileZillaPortable\FileZillaPortable.exe"
run % a_startup

;~ clipboard:=a_mydocuments "\SyncBack\SyncBackFree.exe"

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