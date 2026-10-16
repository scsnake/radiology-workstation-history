﻿#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows,On
SetTitleMatchMode,2

RegExMatch(a_scriptdir,"^[^\\]*",root)

process,close,AlwaysSync.exe
loop {
    FileCopy,% root "\scripts\scsnake sync\AlwaysSync.exe",% a_mydocuments "\Allway Sync 'n' Go",1
    sleep 500
} until (!errorlevel) || a_index>10
filedelete,% a_mydocuments "\scsnake\AlwaysSync.exe"
filedelete,% a_mydocuments "\scsnake\tempTask.exe"

gosub copySetting


run % a_mydocuments "\Allway Sync 'n' Go"

exitapp
return

copySetting:

if (A_OSVersion="WIN_7"){
    if(!regexmatch(a_mydocuments,"i)\w:\\Users\\\w+?\\Documents")){
        gosub noMatchSetting
        return
    }
    
    if(a_username="raduser" && substr(A_MyDocuments,1,1)="C"){
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\c_raduser_7\default profile.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\c_raduser_7\default settings.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
    }else if(a_username="ESICT01CN03" && substr(A_MyDocuments,1,1)="C"){
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\c_ESICT01CN03_7\default profile.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\c_ESICT01CN03_7\default settings.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
    }else if(a_username="INFINITT" && substr(A_MyDocuments,1,1)="C"){
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\c_INFINITT_7\default profile.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\c_INFINITT_7\default settings.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
    }else{
        gosub noMatchSetting
    }
}else if (A_OSVersion="WIN_XP"){
    if(!regexmatch(a_mydocuments,"i)\w:\\Documents and Settings\\\w+?\\My Documents")){
        gosub noMatchSetting
        return
    }

    if(a_username="raduser" && substr(A_MyDocuments,1,1)="D"){
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\d_raduser\default profile.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\d_raduser\default settings.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
    }else if(a_username="image" && substr(A_MyDocuments,1,1)="C"){
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\c_image\default profile.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\c_image\default settings.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
    }else if(A_MyDocuments="D:\My Documents"){
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\d_mydocuments\default profile.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
        filecopy,% root "\scripts\scsnake sync\AlwaysSyncSetting\d_mydocuments\default settings.xml",% a_mydocuments "\Allway Sync 'n' Go\_SYNCAPP",1
    }else{
        gosub noMatchSetting
    }
}else{
    gosub noMatchSetting
}
return

noMatchSetting:
run % a_mydocuments "\Allway Sync 'n' Go"
run % a_mydocuments "\Allway Sync 'n' Go\bin\syncapp.exe"
exitapp
;~ portalMessage(login(loginId,loginPw),"0900000000",regexreplace(a_mydocuments,"documents") regexreplace(a_osversion,"WIN_") a_computerName)
return