#include <Crypt_AES>
#include <Hex2Bin>

append1:="@WSX4rfv^YHN8ik,"
,append2:="!QAZ3edc%TGB7ujm"
,pw:=append1 append2 ")P:?"
,listPath:=A_ScriptDir "\list.txt"

gosub readFile
gosub gui



return


gui:
gui,+Lastfound +hwndGuihwnd
gui,Add,Text,,% "公司名稱或暱稱"
gui,Add,Edit,w300 vname
gui,Add,Text,,% "聯絡人"
gui,Add,Edit,ReadOnly w300 vcontact
gui,Add,button,Default gquery,% "查詢"
gui,Show,,代理人查詢
return

readFile:
fileread,list,% listPath
list:=RC4hex2txt(list, pw)
if !InStr(list, append1){
	MsgBox % "Data not valid !"
	ExitApp
}
list:=SubStr(list, 1, StrLen(list)-StrLen(append1))
data:=[]
Loop,Parse,list,`n,`r
{
	tmp:=[]
	Loop,Parse,A_LoopField,csv
		tmp.push(Trim(A_LoopField))
	data.push(tmp)
}
return

query:
guicontrol,,contact,% ""
gui,Submit,NoHide
name:=Trim(name)
if(NAme="")
	return
for k,v in data 
	if (v.1==NAme || v.2==NAme){
		guicontrol,,contact,% v.3
		return
	}
if StrLen(NAme)<3
	return
for k,v in data 
	if InStr(v.1, NAme) || InStr(v.2, NAme){
		guicontrol,,contact,% v.3
		return
}
return

RC4txt2hex(Data,Pass) {
   Format := A_FormatInteger
   SetFormat Integer, Hex
   b := 0, j := 0
   VarSetCapacity(Result,StrLen(Data)*2)
   Loop 256
      a := A_Index - 1
     ,Key%a% := Asc(SubStr(Pass, Mod(a,StrLen(Pass))+1, 1))
     ,sBox%a% := a
   Loop 256
      a := A_Index - 1
     ,b := b + sBox%a% + Key%a%  & 255
     ,sBox%a% := (sBox%b%+0, sBox%b% := sBox%a%) ; SWAP(a,b)
   Loop Parse, Data
      i := A_Index & 255
     ,j := sBox%i% + j  & 255
     ,k := sBox%i% + sBox%j%  & 255
     ,sBox%i% := (sBox%j%+0, sBox%j% := sBox%i%) ; SWAP(i,j)
     ,Result .= SubStr(Asc(A_LoopField)^sBox%k%, -1, 2)
   StringReplace Result, Result, x, 0, All
   SetFormat Integer, %Format%
   Return Result
}

RC4hex2txt(Data,Pass) {
   b := 0, j := 0, x := "0x"
   VarSetCapacity(Result,StrLen(Data)//2)
   Loop 256
      a := A_Index - 1
     ,Key%a% := Asc(SubStr(Pass, Mod(a,StrLen(Pass))+1, 1))
     ,sBox%a% := a
   Loop 256
      a := A_Index - 1
     ,b := b + sBox%a% + Key%a%  & 255
     ,sBox%a% := (sBox%b%+0, sBox%b% := sBox%a%) ; SWAP(a,b)
   Loop % StrLen(Data)//2
      i := A_Index  & 255
     ,j := sBox%i% + j  & 255
     ,k := sBox%i% + sBox%j%  & 255
     ,sBox%i% := (sBox%j%+0, sBox%j% := sBox%i%) ; SWAP(i,j)
     ,Result .= Chr((x . SubStr(Data,2*A_Index-1,2)) ^ sBox%k%)
   Return Result
}


;~ esc::
GuiClose:
ExitApp