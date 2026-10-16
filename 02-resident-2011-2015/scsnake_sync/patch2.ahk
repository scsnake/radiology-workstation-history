#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2

;~ RegExMatch(a_scriptdir,"^[^\\]*",root)

process,close,AlwaysSync.exe
loop {
    FileCopy,% a_scriptdir "\AlwaysSync.exe",% a_mydocuments "\Allway Sync 'n' Go",1
    sleep 500
} until (!errorlevel)
run % a_mydocuments "\Allway Sync 'n' Go\AlwaysSync.exe"
exitapp