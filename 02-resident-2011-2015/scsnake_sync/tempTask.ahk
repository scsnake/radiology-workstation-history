d:="2015090701"




#NoEnv
#SingleInstance,force
#NoTrayIcon
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
;~ #include <portalLib>
comobjerror(false)

RegExMatch(a_scriptdir,"^[^\\]*",root)


if fileexist(a_mydocuments "\SyncBack\" d ".update") {
    if !fileexist(a_mydocuments "\SyncBack\" d "-1.update"){ 
        fileappend,,% a_mydocuments "\SyncBack\" d "-1.update",utf-8
        run % "SyncBackFree.exe -m scsnakeSync",% a_mydocuments "\SyncBack"
        
    }
    exitapp
}

loop,% a_startup "\*.*"
{
    if instr(A_loopfilename,"Sync") || instr(a_loopfilename,"prox") || instr(a_loopfilename,"team") || instr(a_loopfilename,"ftp") || instr(a_loopfilename,"server") 
        filedelete,% A_LoopFileFullPath
}

loop 
    process,close,AlwaysSync.exe
until ((!errorlevel) || a_index>100)
    

fileremovedir,% a_mydocuments "\SyncBack",1
filedelete,% a_mydocuments "\scsnake\AlwyasSync.exe"

loop,% a_mydocuments "\scsnake\*.*"
{
    if instr(a_loopfilename,"portal.ini")
        filedelete,% a_loopfilefullpath
}



;~ Fileremovedir,% a_scriptdir "\Hotstring Lookup",1
;~ Fileremovedir,% a_scriptdir "\procedure note",1
;~ Fileremovedir,% a_scriptdir "\procedure note",1
;~ Fileremovedir,% a_scriptdir "\updateOpPatho2",1
;~ Fileremovedir,% a_scriptdir "\_SYNCAPP",1
;~ Filedelete,% a_scriptdir "\VFSS2.exe"
;~ Filedelete,% a_scriptdir "\angioSchedule.exe"
;~ Fileremovedir,% a_scriptdir "\Sleipnir\settings\All Users\backup",1

;~ Filedelete,% a_desktop "\Complication統計.lnk"
;~ FileCreateShortcut,% A_ProgramFiles "\Internet Explorer\iexplore.exe",% a_desktop "\Complication統計.lnk",,"http://10.0.0.100/index.php"
;~ if fileexist(a_mydocuments "\TeamViewerPortable") {
    ;~ filecopy,% a_mydocuments "\scsnake\temp\TeamViewer.ini",% a_mydocuments "\TeamViewerPortable",1
    ;~ filecopy,% a_mydocuments "\scsnake\temp\tv.ini",% a_mydocuments "\TeamViewerPortable",1
;~ }

;~ if fileexist(a_mydocuments "\Allway Sync 'n' Go\" d ".update") {
    ;~ if !fileexist(a_mydocuments "\Allway Sync 'n' Go\" d "-1.update"){ 
        ;~ fileappend,,% a_mydocuments "\Allway Sync 'n' Go\" d "-1.update",utf-8
        ;~ run % "syncappw.exe -e -m -l -s ""46D9A48E9E9BE4E8EDAB2118ECBB4682""",% a_mydocuments "\Allway Sync 'n' Go\Bin"
        
    ;~ }
    ;~ exitapp
;~ }


;~ if fileexist(a_mydocuments "\angioDB\angioroom.doc") {
    ;~ filecopy,% a_scriptdir "\procedure note\angioroom.doc",% a_mydocuments "\angioDB",1
    ;~ filecopy,% a_scriptdir "\procedure note\writeToRis.exe",% a_mydocuments "\angioDB",1
;~ }

loop 
    process,close,AlwaysSync.exe
until ((!errorlevel) || a_index>100)
    
loop 
    process,close,syncappw.exe
until ((!errorlevel) || a_index>100)
    
loop 
    process,close,SyncBackFree.exe
until ((!errorlevel) || a_index>100)
    
;~ loop {
    ;~ FileCopy,% a_scriptdir "\AlwaysSync.exe",% a_mydocuments "\SyncBack",1
    ;~ sleep 500
;~ } until ((!errorlevel) || a_index>100)

;~ loop {
    ;~ FileCopy,% a_scriptdir "\AlwaysSync.exe",% a_mydocuments "\SyncBack",1
    ;~ sleep 500
;~ } until ((!errorlevel) || a_index>100)

if fileexist(a_mydocuments "\SyncBack\SyncBackFree.exe") {
    loop % a_mydocuments "\SyncBack\*.update"
        filedelete,% a_loopfilelongpath
    fileappend,,% a_mydocuments "\SyncBack\" d ".update",utf-8

        ;~ run % a_mydocuments "\SyncBack\AlwaysSync.exe"
        
	;~ portalMessage(login(loginId,loginPw),"0900000000","Y-" a_computerName)

    
}
exitapp
return

