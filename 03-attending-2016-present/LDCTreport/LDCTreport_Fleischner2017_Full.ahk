; <COMPILER: v1.1.30.01>
MD5_File(FileName)
{
return HashFile(FileName, 2)
Ptr := A_PtrSize ? "Ptr" : "UInt"
H := DllCall("CreateFile",Ptr,&FileName,"UInt",0x80000000,"UInt",3,"UInt",0,"UInt",3,"UInt",0,"UInt",0)
, DllCall("GetFileSizeEx","UInt",H,"Int64*",FileSize)
, FileSize := FileSize = -1 ? 0 : FileSize
, VarSetCapacity(Data,FileSize,0)
, DllCall("ReadFile",Ptr,H,Ptr,&Data,"UInt",FileSize,"UInt",0,"UInt",0)
, DllCall("CloseHandle",Ptr,H)
, VarSetCapacity(MD5_CTX,104,0)
, DllCall("advapi32\MD5Init",Ptr,&MD5_CTX)
, DllCall("advapi32\MD5Update",Ptr,&MD5_CTX,Ptr,&Data,"UInt",FileSize)
, DllCall("advapi32\MD5Final",Ptr,&MD5_CTX)
FileMD5 := ""
Loop % StrLen(Hex:="123456789ABCDEF0")
N := NumGet(MD5_CTX,87+A_Index,"Char"), FileMD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
VarSetCapacity(Data,FileSize,0)
, VarSetCapacity(Data,0)
Return FileMD5
}
HashFile(filePath,hashType=2)
{
PROV_RSA_AES := 24
CRYPT_VERIFYCONTEXT := 0xF0000000
BUFF_SIZE := 1024 * 1024
HP_HASHVAL := 0x0002
HP_HASHSIZE := 0x0004
HASH_ALG := hashType = 1 ? (CALG_MD2 := 32769) : HASH_ALG
HASH_ALG := hashType = 2 ? (CALG_MD5 := 32771) : HASH_ALG
HASH_ALG := hashType = 3 ? (CALG_SHA := 32772) : HASH_ALG
HASH_ALG := hashType = 4 ? (CALG_SHA_256 := 32780) : HASH_ALG
HASH_ALG := hashType = 5 ? (CALG_SHA_384 := 32781) : HASH_ALG
HASH_ALG := hashType = 6 ? (CALG_SHA_512 := 32782) : HASH_ALG
f := FileOpen(filePath,"r","CP0")
if !IsObject(f)
return 0
if !hModule := DllCall( "GetModuleHandleW", "str", "Advapi32.dll", "Ptr" )
hModule := DllCall( "LoadLibraryW", "str", "Advapi32.dll", "Ptr" )
if !dllCall("Advapi32\CryptAcquireContextW"
,"Ptr*",hCryptProv
,"Uint",0
,"Uint",0
,"Uint",PROV_RSA_AES
,"UInt",CRYPT_VERIFYCONTEXT )
Goto,FreeHandles
if !dllCall("Advapi32\CryptCreateHash"
,"Ptr",hCryptProv
,"Uint",HASH_ALG
,"Uint",0
,"Uint",0
,"Ptr*",hHash )
Goto,FreeHandles
VarSetCapacity(read_buf,BUFF_SIZE,0)
hCryptHashData := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "CryptHashData", "Ptr")
While (cbCount := f.RawRead(read_buf, BUFF_SIZE))
{
if (cbCount = 0)
break
if !dllCall(hCryptHashData
,"Ptr",hHash
,"Ptr",&read_buf
,"Uint",cbCount
,"Uint",0 )
Goto,FreeHandles
}
if !dllCall("Advapi32\CryptGetHashParam"
,"Ptr",hHash
,"Uint",HP_HASHSIZE
,"Uint*",HashLen
,"Uint*",HashLenSize := 4
,"UInt",0 )
Goto,FreeHandles
VarSetCapacity(pbHash,HashLen,0)
if !dllCall("Advapi32\CryptGetHashParam"
,"Ptr",hHash
,"Uint",HP_HASHVAL
,"Ptr",&pbHash
,"Uint*",HashLen
,"UInt",0 )
Goto,FreeHandles
SetFormat,integer,Hex
loop,%HashLen%
{
num := numget(pbHash,A_index-1,"UChar")
hashval .= substr((num >> 4),0) . substr((num & 0xf),0)
}
SetFormat,integer,D
FreeHandles:
f.Close()
DllCall("FreeLibrary", "Ptr", hModule)
dllCall("Advapi32\CryptDestroyHash","Ptr",hHash)
dllCall("Advapi32\CryptReleaseContext","Ptr",hCryptProv,"UInt",0)
return hashval
}
Bin2Hex(ByRef h, ByRef b, n=0)
{
format = %A_FormatInteger%
SetFormat Integer, Hex
m := VarSetCapacity(b)
If (n < 1 or n > m)
n := m
Address := &b
h =
Loop %n%
{
x := *Address
StringTrimLeft x, x, 2
x = 0%x%
StringRight x, x, 2
h = %h%%x%
Address++
}
SetFormat Integer, %format%
}
Hex2Bin(ByRef b, h, n=0)
{
m := Ceil(StrLen(h)/2)
If (n < 1 or n > m)
n := m
Granted := VarSetCapacity(b, n, 0)
IfLess Granted,%n%, {
ErrorLevel = Mem=%Granted%
Return
}
Address := &b
Loop %n%
{
StringLeft  x, h, 2
StringTrimLeft h, h, 2
x = 0x%x%
DllCall("RtlFillMemory", "UInt", Address, "UInt", 1, "UChar", x)
Address++
}
}
BinWrite(file, ByRef data, n=0, offset=0)
{
h := DllCall("CreateFile","str",file,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
IfEqual h,-1, SetEnv, ErrorLevel, -1
IfNotEqual ErrorLevel,0,Return,0
m = 0
IfLess offset,0, SetEnv,m,2
r := DllCall("SetFilePointerEx","Uint",h,"Int64",offset,"UInt *",p,"Int",m)
IfEqual r,0, SetEnv, ErrorLevel, -3
IfNotEqual ErrorLevel,0, {
t = %ErrorLevel%
DllCall("CloseHandle", "Uint", h)
ErrorLevel = %t%
Return 0
}
m := VarSetCapacity(data)
If (n < 1 or n > m)
n := m
result := DllCall("WriteFile","UInt",h,"Str",data,"UInt",n,"UInt *",Written,"UInt",0)
if (!result or Written < n)
ErrorLevel = -3
IfNotEqual ErrorLevel,0, SetEnv,t,%ErrorLevel%
h := DllCall("CloseHandle", "Uint", h)
IfEqual h,-1, SetEnv, ErrorLevel, -2
IfNotEqual t,,SetEnv, ErrorLevel, %t%-%ErrorLevel%
Return Written
}
BinRead(file, ByRef data, n=0, offset=0)
{
h := DllCall("CreateFile","Str",file,"Uint",0x80000000,"Uint",3,"UInt",0,"UInt",3,"Uint",0,"UInt",0)
IfEqual h,-1, SetEnv, ErrorLevel, -1
IfNotEqual ErrorLevel,0,Return,0
m = 0
IfLess offset,0, SetEnv,m,2
r := DllCall("SetFilePointerEx","Uint",h,"Int64",offset,"UInt *",p,"Int",m)
IfEqual r,0, SetEnv, ErrorLevel, -3
IfNotEqual ErrorLevel,0, {
t = %ErrorLevel%
DllCall("CloseHandle", "Uint", h)
ErrorLevel = %t%
Return 0
}
m := DllCall("GetFileSize","UInt",h,"Int64 *",r)
If (n < 1 or n > m)
n := m
Granted := VarSetCapacity(data, n, 0)
IfLess Granted,%n%, {
ErrorLevel = Mem=%Granted%
Return 0
}
result := DllCall("ReadFile","UInt",h,"Str",data,"UInt",n,"UInt *",Read,"UInt",0)
if (!result or Read < n)
t = -3
IfNotEqual ErrorLevel,0, SetEnv,t,%ErrorLevel%
h := DllCall("CloseHandle", "Uint", h)
IfEqual h,-1, SetEnv, ErrorLevel, -2
IfNotEqual t,,SetEnv, ErrorLevel, %t%-%ErrorLevel%
Return Read
}
ProcessList(){
d := "  |  "
s := 4096
Process, Exist
h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel, "Ptr")
,DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)
,VarSetCapacity(ti, 16, 0)
,NumPut(1, ti, 0, "UInt")
,DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
,NumPut(luid, ti, 4, "Int64")
,NumPut(2, ti, 12, "UInt")
,r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)
,DllCall("CloseHandle", "Ptr", t)
,DllCall("CloseHandle", "Ptr", h)
,hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")
,s := VarSetCapacity(a, s)
,c := 0
,DllCall("Psapi.dll\EnumProcesses", "Ptr", &a, "UInt", s, "UIntP", r)
,l:=[]
Loop, % r // 4
{
id := NumGet(a, A_Index * 4, "UInt")
,h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id, "Ptr")
if !h
continue
name_size = 255
VarSetCapacity( name, name_size )
,result := DllCall( "psapi.dll\GetModuleFileNameEx" ( A_IsUnicode ? "W" : "A" )
, "uint", h, "uint", 0, "str", name, "uint", name_size )
,VarSetCapacity(n, s, 0)
,e := DllCall("Psapi.dll\GetModuleBaseName", "Ptr", h, "Ptr", 0, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
if !e
if e := DllCall("Psapi.dll\GetProcessImageFileName", "Ptr", h, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
SplitPath n, n
DllCall("CloseHandle", "Ptr", h)
if (n && e)
l[n "_" id]:={name: n, path: name, pid: id} , c++
}
DllCall("FreeLibrary", "Ptr", hModule)
return l
}
HTTPRequest( URL, byref In_POST__Out_Data="", byref In_Out_HEADERS="", Options="" ) {
Static version := "2.42", Ptr, PtrSize, IsUnicode, MyACP, MyCharset, Default_Agent, WorA := ""
, Default_Accept_Types := "text/xml, text/json; q=0.4, text/html; q=0.3, text/*; q=0.2, */*; q=0.1"
, Text_Content_Subtypes := "/atom/html/json/rss/soap/xhtml/xml/x-www-form-urlencoded"
, internet_flags_list := "
( LTRIM JOIN|INTERNET_FLAG_
	....
	NEED_FILE
	MUST_CACHE_REQUEST|.
	FWD_BACK|.
	FORMS_SUBMIT|..
	PRAGMA_NOCACHE|.
	NO_UI|.
	HYPERLINK|.
	RESYNCHRONIZE|.
	IGNORE_CERT_CN_INVALID|.
	IGNORE_CERT_DATE_INVALID|.
	IGNORE_REDIRECT_TO_HTTPS|.
	IGNORE_REDIRECT_TO_HTTP|..
	RESTRICTED_ZONE|.
	NO_AUTH|.
	NO_COOKIES|.
	READ_PREFETCH|.
	NO_AUTO_REDIRECT|.
	KEEP_CONNECTION|.
	SECURE|.
	FROM_CACHE
	OFFLINE|.
	MAKE_PERSISTENT|.
	DONT_CACHE|...
	NO_CACHE_WRITE|.
	RAW_DATA|.
	RELOAD|
)"
, security_flags_list := "
( LTRIM JOIN|SECURITY_FLAG_
	SECURE|.
	SSL|.
	SSL3|.
	PCT|.
	PCT4|.
	IETFSSL4|..
	IGNORE_REVOCATION|.
	IGNORE_UNKNOWN_CA|.
	IGNORE_WRONG_USAGE|...
	IGNORE_CERT_CN_INVALID|.
	IGNORE_CERT_DATE_INVALID|.
	IGNORE_REDIRECT_TO_HTTPS|.
	IGNORE_REDIRECT_TO_HTTP|............
	FORTEZZA|.
	40BIT
	NORMALBITNESS
	STRENGTH_WEAK|.
	128BIT
	STRENGTH_STRONG|.
	56BIT
	STRENGTH_MEDIUM|.
	UNKNOWNBIT|
)"
, Codepage_Charsets := "|
( LTRIM JOIN|
	00037=IBM037|00437=IBM437|00500=IBM500|00708=ASMO-708|00720=DOS-720|00737=ibm737
	00775=ibm775|00850=ibm850|00852=ibm852|00855=IBM855|00857=ibm857|00858=IBM00858|00860=IBM860
	00861=ibm861|00862=DOS-862|00863=IBM863|00864=IBM864|00865=IBM865|00866=cp866|00869=ibm869
	00870=IBM870|00874=windows-874|00875=cp875|00932=shift_jis|00936=gb2312|00949=ks_c_5601-1987
	00950=big5|01026=IBM1026|01047=IBM01047|01140=IBM01140|01141=IBM01141|01142=IBM01142
	01143=IBM01143|01144=IBM01144|01145=IBM01145|01146=IBM01146|01147=IBM01147|01148=IBM01148
	01149=IBM01149|01200=utf-16|01201=unicodeFFFE|01250=windows-1250|01251=windows-1251
	01252=Windows-1252|01253=windows-1253|01254=windows-1254|01255=windows-1255
	01256=windows-1256|01257=windows-1257|01258=windows-1258|01361=Johab|10000=macintosh
	10001=x-mac-japanese|10002=x-mac-chinesetrad|10003=x-mac-korean|10004=x-mac-arabic
	10005=x-mac-hebrew|10006=x-mac-greek|10007=x-mac-cyrillic|10008=x-mac-chinesesimp
	10010=x-mac-romanian|10017=x-mac-ukrainian|10021=x-mac-thai|10029=x-mac-ce
	10079=x-mac-icelandic|10081=x-mac-turkish|10082=x-mac-croatian|12000=utf-32|12001=utf-32BE
	20000=x-Chinese-CNS|20001=x-cp20001|20002=x-Chinese-Eten|20003=x-cp20003|20004=x-cp20004
	20005=x-cp20005|20105=x-IA5|20106=x-IA5-German|20107=x-IA5-Swedish|20108=x-IA5-Norwegian
	20127=us-ascii|20261=x-cp20261|20269=x-cp20269|20273=IBM273|20277=IBM277|20278=IBM278
	20280=IBM280|20284=IBM284|20285=IBM285|20290=IBM290|20297=IBM297|20420=IBM420|20423=IBM423
	20424=IBM424|20833=x-EBCDIC-KoreanExtended|20838=IBM-Thai|20866=koi8-r|20871=IBM871
	20880=IBM880|20905=IBM905|20924=IBM00924|20932=EUC-JP|20936=x-cp20936|20949=x-cp20949
	21025=cp1025|21866=koi8-u|28591=iso-8859-1|28592=iso-8859-2|28593=iso-8859-3|28594=iso-8859-4
	28595=iso-8859-5|28596=iso-8859-6|28597=iso-8859-7|28598=iso-8859-8|28599=iso-8859-9
	28603=iso-8859-13|28605=iso-8859-15|29001=x-Europa|38598=iso-8859-8-i|50220=iso-2022-jp
	50221=csISO2022JP|50222=iso-2022-jp|50225=iso-2022-kr|50227=x-cp50227|51932=euc-jp
	51936=EUC-CN|51949=euc-kr|52936=hz-gb-2312|54936=GB18030|57002=x-iscii-de|57003=x-iscii-be
	57004=x-iscii-ta|57005=x-iscii-te|57006=x-iscii-as|57007=x-iscii-or|57008=x-iscii-ka
	57009=x-iscii-ma|57010=x-iscii-gu|57011=x-iscii-pa|65000=utf-7|65001=utf-8|
)"
If ( WorA = "" )
{
If ( A_PtrSize = "" )
PtrSize := 4, Ptr := "UInt"
Else PtrSize := A_PtrSize, Ptr := "Ptr"
If !( IsUnicode := 1 = A_IsUnicode )
WorA := "A", MyACP := SubStr( 100000.0 + DllCall("GetACP"), 2, 5 )
Else WorA := "W", MyACP := "01200"
MyCharset := ( 7 = pos := 7 + InStr( Codepage_Charsets, "|" MyACP "=" ) ) ? "UTF-8"
: SubStr( Codepage_Charsets, pos, InStr( Codepage_Charsets, "|", 0, pos ) - pos )
SplitPath, A_ScriptName,,,, Default_Agent
Default_Agent .= "/1.0 (Language=AutoHotkey/" A_AhkVersion "; Platform=" A_OSVersion ")"
}
Internet_Open_Type := 1
Security_Flags := Security_Flags_Add := Security_Flags_Nix := 0
Response_Code := "0"
Do_Callback := 0
Do_NonBinary_Up := 0
Do_Binary_Down := 0
Do_Up_MD5_Hash := 0
Do_Dn_MD5_Hash := 0
Do_File_Upload := 0
Do_Multipart := 0
Do_Download_To_File := 0
Do_Download_Resume := 0
Do_Legacy_Dual_Output := 0
Agent := Default_Agent
Accept_Types := Default_Accept_Types
Multipart_Boundary := ""
proxy_bypass := ""
Method_Verb := ""
MyErrors := ""
dbuffsz := 0
port := 0
dtsz := 0
Convert_POST_To_Codepage := MyACP
Internet_Flags := 0
| 0x400000
| 0x80000000
| 0x20000000
StringLen, Content_Length, In_POST__Out_Data
Content_Length <<= IsUnicode
hbuffer := "The provided url could not be parsed: """ URL """"
If ( pos := InStr( URL, "://" ) )
{
StringLeft, scheme, URL, pos - 1
StringLower, scheme, scheme
StringTrimLeft, URL, URL, pos + 2
If ( scheme = "https" )
Internet_Flags |= 0x1000
| 0x2000
| 0x800000
Else If ( scheme != "http" )
Return 0, ErrorLevel := 0, In_Out_HEADERS := "HTTPRequest does not support '" scheme "' type connections."
}
Else scheme := "http"
StringLeft, host, URL, pos := InStr( URL "/", "/" ) - 1
StringTrimLeft, URL, URL, pos
If ( pos := InStr( host, "@" ) )
{
StringLeft, user, host, pos - 1
StringTrimLeft, host, host, pos
If ( pos := InStr( user, ":" ) )
{
StringTrimLeft, pass, user, pos
StringLeft, user, user, pos - 1
}
Else pass := ""
}
Else user := pass := ""
If ( pos := InStr( host, ":", 0, InStr( host, "[" ) = 1 ? InStr( host, "]" ) + 1 : 1 ) )
&& ( 0 < port := 0 | SubStr( host, pos + 1 ) ) && ( port < 65536 )
{
StringTrimLeft, port, host, pos
StringLeft, host, host, pos - 1
}
Else port := scheme = "https" ? 443 : 80
If ( host = "" )
Return 0, ErrorLevel := 0, In_Out_HEADERS := hbuffer
StringLen, pos, In_Out_HEADERS
VarSetCapacity( hbuffer, 1 + pos << IsUnicode )
hbuffer := "`r`n"
Loop, Parse, In_Out_HEADERS, `n
{
StringReplace, rbuffer, A_LoopField, :, `n
Loop, Parse, rbuffer, `n, % "`t`r "
If ( A_Index = 1 )
rbuffer := A_LoopField
Else If ( A_LoopField = "" )
If ( rbuffer = "Content-MD5" )
Do_Up_MD5_Hash := 1
Else Continue
Else If ( rbuffer = "Accept" )
Accept_Types := A_LoopField
Else If ( rbuffer = "Content-Length" ) && ( 0 < 1 | A_LoopField )
Content_Length := A_LoopField
Else If ( rbuffer = "Content-Type" )
{
hbuffer .= "Content-Type: " A_LoopField "`r`n"
StringReplace, Multipart_Boundary, A_LoopField, % ",", % ";", A
If ( 7 != pos := 7 + InStr( Multipart_Boundary, "charset=" ) )
&& ( pos := InStr( Codepage_Charsets, SubStr( Multipart_Boundary, pos
, InStr( Multipart_Boundary ";" , ";", 0, pos ) - pos ) "|" ) )
StringMid, Convert_POST_To_Codepage, Codepage_Charsets, pos - 5, 5
Multipart_Boundary := ( InStr( A_LoopField, "Multipart/" ) != 1
|| 9 = pos := 9 + InStr( Multipart_Boundary, "boundary=" ) ) ? ""
: SubStr( Multipart_Boundary, pos, InStr( Multipart_Boundary ";", ";" ) - pos )
}
Else If ( rbuffer = "Referrer" )
hbuffer .= "Referer: " A_LoopField "`r`n"
Else If ( rbuffer = "User-Agent" )
Agent := A_LoopField
Else hbuffer .= rbuffer ": " A_LoopField "`r`n"
}
IfInString, hbuffer, % "`r`nCookie: "
options .= "`n+NO_COOKIES"
If ( Multipart_Boundary != "" ) && ( pos := InStr( options, "--" Multipart_Boundary ) )
&& ( ( 4 + StrLen( Multipart_Boundary ) ) != ( Multipart_Boundary := 4
+ StrLen( Multipart_Boundary ) + InStr( options, "--" Multipart_Boundary "--", 0, 0 ) ) )
{
StringMid, Multipart_Envelope, options, pos, Multipart_Boundary - pos
options := SubStr( options, 1, pos - 1 ) SubStr( options, Multipart_Boundary )
}
Loop, Parse, options, `n
{
If InStr( A_LoopField, ">" ) + 3 >> 2 = 1
{
Loop, Parse, A_LoopField, >, % "`t`n`r "
If ( A_Index = 1 )
options := ( InStr( A_LoopField, "R" ) ? "RESUME`n" : "SAVEAS`n" )
, Do_Legacy_Dual_Output := !!InStr( A_LoopField, "N" )
Else options .= A_LoopField
}
Else IfInString, A_LoopField, :
StringReplace, options, A_LoopField, :, `n
Else If InString, A_LoopField, =
StringReplace, options, A_LoopField, =, `n
Else options := A_LoopField "`n"
Loop, Parse, options, `n, % "`t`r "
If ( A_Index = 1 )
StringUpper, options, A_LoopField
Else If ( options = "AUTOPROXY" )
Internet_Open_Type := !!A_LoopField || A_LoopField = "" ? 0 : 1
Else If ( options = "BINARY" )
Do_Binary_Down := !!A_LoopField || A_LoopField = ""
Else If ( options = "CALLBACK" )
{
If ( pos := InStr( A_LoopField, "," ) ) || ( pos := InStr( A_LoopField, ";" ) )
|| ( pos := InStr( A_LoopField, "`t" ) ) || ( pos := InStr( A_LoopField, " " ) )
{
StringLeft, Do_Callback_Func, A_LoopField, pos - 1
StringTrimLeft, Do_Callback_3rdParam, A_LoopField, pos
Loop, Parse, Do_Callback_3rdParam, `n, % "`t`r "
Do_Callback_3rdParam := A_LoopField
}
Else Do_Callback_Func := A_LoopField
Do_Callback := IsFunc( Do_Callback_Func ) + 3 >> 2 = 1
}
Else If ( options = "CHARSET" )
Do_NonBinary_Up := !( pos := InStr( Codepage_Charsets, "=" A_LoopField "|" ) ) ? Convert_POST_To_Codepage
: SubStr( Codepage_Charsets, pos - 5, 5 )
Else If ( options = "CHECKMD5" ) || ( options = "CHECK MD5" )
Do_Dn_MD5_Hash := 1
Else If ( options = "CODEPAGE" )
Do_NonBinary_Up := ( A_LoopField | 0 < 1 || A_LoopField >> 16 ) ? Convert_POST_To_Codepage
: ( Convert_POST_To_Codepage := SubStr( A_LoopField + 100000.0, 2, 5 ) )
Else If InStr( options, "+" ) = 1 || InStr( options, "-" ) = 1
{
StringLeft, flag_plus_or_minus, options, 1
Loop, Parse, options, +-, % "`t`n`r _"
options := A_LoopField
If ( options = "FLAG" )
StringUpper, options, A_LoopField
If ( pos := InStr( internet_flags_list, "|" options "|" ) )
|| ( pos := InStr( internet_flags_list, "|INTERNET_FLAG_" options "|" ) )
{
StringLeft, options, internet_flags_list, pos
StringReplace, options, options, ., ., UseErrorLevel
If ( flag_plus_or_minus = "+" )
Internet_Flags |= 1 << ErrorLevel
Else Internet_Flags &= ~( 1 << ErrorLevel )
}
Else If ( pos := InStr( security_flags_list, "|" options "|" ) )
|| ( pos := InStr( security_flags_list, "|SECURITY_FLAG_" options "|" ) )
{
StringLeft, options, security_flags_list, pos
StringReplace, options, options, ., ., UseErrorLevel
If ( flag_plus_or_minus = "+" )
Security_Flags_Add |= 1 << ErrorLevel
Else Security_Flags_Nix |= 1 << ErrorLevel
}
Else If ( InStr( options, "S" ) = 1 ) && ( 0 < pos := Abs( SubStr( options, 2 ) ) )
&& ( pos = 1 << Round( Ln( pos ) / Ln(2) ) )
{
If ( flag_plus_or_minus = "+" )
Security_Flags_Add |= pos
Else Security_Flags_Nix |= pos
}
Else If ( 0 < pos := Abs( options ) ) && ( pos = 1 << Round( Ln( pos ) / Ln(2) ) )
If ( flag_plus_or_minus = "+" )
Internet_Flags |= pos
Else Internet_Flags &= ~pos
}
Else If ( options = "METHOD" ) && InStr( "|GET|HEAD|POST|PUT|DELETE|OPTIONS|TRACE|", "|" A_LoopField "|" )
StringUpper, Method_Verb, A_LoopField
Else If ( options = "PROXY" )
Internet_Open_Type := 3, proxy_url := A_LoopField
Else If ( options = "PROXY BYPASS" )
proxy_bypass .= A_LoopField "`r`n"
Else If ( options = "RESUME" ) || ( options = "SAVEAS" ) || ( options = "SAVE AS" )
{
file_ext := FileExist( output_file_path := A_LoopField )
If ( file_ext = "" )
{
If !( pos := InStr( output_file_path, "\", 0, 0 ) )
|| FileExist( SubStr( output_file_path, 1, pos - 1 ) )
Do_Download_To_File := 1
Else MyErrors .= "`nThe file path """ output_file_path """ is not valid. The folder can't be found."
}
Else If InStr( file_ext, "D" )
{
file_ext := "V://x/E/" url
SplitPath, file_ext, file_ext
StringLeft, file_ext, file_ext, InStr( file_ext "?", "?" ) - 1
output_file_path .= ( SubStr( output_file_path, 0 ) = "\" ? "" : "\" )
. ( file_ext = "" ? "HTTPRequest " A_Year "-" A_MM "-" A_DD "_" SubStr( A_Now A_MSec, 9 ) ".txt" : file_ext )
}
Else
If ( options = "RESUME" )
FileGetSize, Do_Download_Resume, % output_file_path
}
Else If ( options = "UPLOAD" )
{
If ( pos := InStr( A_LoopField, "*", 0, 0 ) )
{
Upload_File_Path := SubStr( A_LoopField, 1, pos - 1 ) "`n" SubStr( A_LoopField, pos + 1 )
Loop, Parse, Upload_File_Path, `n, % "`t`r "
If ( A_Index = 1 )
Upload_File_Path := A_LoopField
Else If ( 0 < 0 | A_LoopField )
Do_File_Upload := !FileExist( Upload_File_Path ) ? 0 : 0 | 1 + A_LoopField
}
Else Do_File_Upload := !FileExist( Upload_File_Path := A_LoopField ) ? 0 : 1
If ( Do_File_Upload )
{
FileGetsize, Content_Length, % Upload_File_Path
}
Else MyErrors .= "`nFile upload failed: the file """ Upload_File_Path """ could not be found."
}
}
StringTrimRight, proxy_bypass, proxy_bypass, 2
If ( 0 < Content_Length )
{
If ( Do_File_Upload )
{
VarSetCapacity( dbuffer, 4096, 0 )
dbuffsz := Content_Length := SubStr( Content_Length + 0.0, 1, 1 + FLOOR( LOG( Content_Length )))
hbuffer .= "Content-Length: " Content_Length "`r`n"
IfNotInString, hbuffer, % "`r`nContent-Type: "
{
SplitPath, Upload_File_Path,,, file_ext
hbuffer .= "Content-Type: " ( file_ext = "xml" ? "text/xml"
: file_ext = "txt" ? "application/x-www-form-urlencoded"
: "application/octet-stream" ) "`r`n"
}
If ( Do_Up_MD5_Hash )
hbuffer .= "Content-MD5: " HTTPRequest_MD5( hbuffer, Upload_File_Path ) "`r`n"
}
Else If !( Do_NonBinary_Up ) || ( Do_NonBinary_Up = MyACP ) || ( Do_Multipart )
{
VarSetCapacity( dbuffer, dbuffsz := Content_Length, 0 )
DllCall( "RtlMoveMemory", Ptr, &dbuffer, Ptr, &In_POST__Out_Data, "Int", Content_Length )
Content_Length := SubStr( Content_Length + 0.0, 1, 1 + FLOOR( LOG( Content_Length )))
hbuffer .= "Content-Length: " Content_Length "`r`n"
IfNotInString, hbuffer, % "`r`nContent-Type: "
hbuffer .= "Content-Type: " ( InStr( dbuffer, "<?xml" ) + 3 >> 2 = 1 ? "text/xml"
: "application/x-www-form-urlencoded" ) "; charset=" MyCharset
}
Else
{
IfNotInString, hbuffer, % "`r`nContent-Type: "
{
hbuffer .= "Content-Type: " ( InStr( dbuffer, "<?xml" ) + 3 >> 2 = 1 ? "text/xml"
: "application/x-www-form-urlencoded" )
If ( 7 != pos := 7 + InStr( Codepage_Charsets, "|" Do_NonBinary_Up "=" ) )
hbuffer .= "; charset=" SubStr( Codepage_Charsets, pos, InStr( Codepage_Charsets, "|", 0, pos ) - pos )
hbuffer .= "`r`n"
}
If ( IsUnicode )
pos := &In_POST__Out_Data, rbuffsz := Content_Length >> 1
Else
{
If ( 0 < rbuffsz := DllCall( "MultiByteToWideChar", "UInt", MyACP, "UInt", 0, Ptr, &In_POST__Out_Data, "Int", Content_Length, Ptr, 0, "Int", 0 ) )
{
VarSetCapacity( rbuffer, rbuffsz + 1 << 1, 0 )
DllCall( "MultiByteToWideChar", "UInt", MyACP, "UInt", 0, Ptr, &In_POST__Out_Data, "Int", Content_Length, Ptr, pos := &rbuffer, "Int", rbuffsz )
}
Else MyErrors .= "`nThere was a problem converting codepage " MyACP " to " Convert_POST_To_Codepage ". 'MultiByteToWideChar' failed: Return value = " rbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
}
If ( 0 < rbuffsz )
If ( 0 < dbuffsz := DllCall( "WideCharToMultiByte", "UInt", Do_NonBinary_Up, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0 ) )
{
VarSetCapacity( dbuffer, dbuffsz + 1, 0 )
DllCall( "WideCharToMultiByte", "UInt", Do_NonBinary_Up, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, &dbuffer, "Int", dbuffsz, Ptr, 0, Ptr, 0 )
Content_Length := SubStr( dbuffsz + 0.0, 1, 1 + FLOOR( LOG( dbuffsz )))
hbuffer .= "Content-Length: " Content_Length "`r`n"
}
Else MyErrors .= "`nThere was a problem converting codepage " MyACP " to " Convert_POST_To_Codepage ". 'WideCharToMultiByte' failed: Return value = " dbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
VarSetCapacity( rbuffer, 0 )
If ( Do_Up_MD5_Hash )
hbuffer .= "Content-MD5: " HTTPRequest_MD5( dbuffer, dbuffsz ) "`r`n"
}
VarSetCapacity( INTERNET_BUFFERS, 28 + PtrSize * 3, 0 )
NumPut( 28 + PtrSize * 3, INTERNET_BUFFERS, 0, "Int" )
NumPut( Content_Length, INTERNET_BUFFERS, 16 + PtrSize * 3, "Int" )
}
Loop, Parse, Accept_Types, "
If ( A_Index = 1 )
StringReplace, Accept_Types, A_LoopField, `,, `n, A
Else If ( A_Index & 1 )
{
StringReplace, Accept_PtrArray, A_LoopField, `,, `n, A
Accept_Types .= Accept_PtrArray
}
Else Accept_Types .= """" A_LoopField """"
Loop, Parse, Accept_Types, `n, % "`t`r "
If ( 1 = pos := A_Index )
Accept_Types := A_LoopField
Else Accept_Types .= "`n" A_LoopField
VarSetCapacity( Accept_PtrArray, pos * PtrSize + PtrSize, 0 )
pos := 0
Loop, Parse, Accept_Types, `n
{
NumPut( &Accept_Types + pos, Accept_PtrArray, A_Index * PtrSize - PtrSize, Ptr )
pos += 1 + StrLen( A_LoopField ) << IsUnicode
NumPut( 0, Accept_Types, pos - 1 - IsUnicode, IsUnicode ? "UShort" : "UChar" )
}
Method_Verb := Method_Verb != "" ? Method_Verb : 0 < Content_Length ? "POST" : "GET"
StringTrimLeft, hbuffer, hbuffer, 2
If InStr( MyErrors, "`n" )
Return 0, In_Out_HEADERS := SubStr( MyErrors, 2 ), ErrorLevel := oel
If !( hModule := DllCall( "LoadLibrary" WorA, "Str", "WinINet.dll", Ptr ) )
MyErrors .= "`nThere was a problem loading WinINet.dll. 'LoadLibrary" WorA "' failed: Return value = " hModule ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else	If !( hInternet := Internet_Open_Type != 3 ? DllCall( "WinINet\InternetOpen" WorA, Ptr, &Agent, "UInt", Internet_Open_Type, Ptr, 0, Ptr, 0, "UInt", 0, Ptr )
: DllCall( "WinINet\InternetOpen" WorA, Ptr, &Agent, "UInt", 3, ptr, &proxy_url, Ptr, proxy_bypass = "" ? 0 : &proxy_bypass, "UInt", 0, Ptr ) )
MyErrors .= "`nThere was a problem initializing WinINet. 'WinINet\InternetOpen" WorA "' failed: Return value = " hInternet ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If !( hConnection := DllCall( "WinINet\InternetConnect" WorA, Ptr, hInternet, Ptr, &Host, "UInt", Port, Ptr, &User, Ptr, &Pass, "UInt", 3, "UInt", Internet_Flags, "UInt", 0, Ptr ) )
MyErrors .= "`nThere was a problem opening a HTTP session. 'WinINet\InternetConnect" WorA "' failed: Return value = " hConnection ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If !( hRequest := DllCall( "WinINet\HttpOpenRequest" WorA, Ptr, hConnection, Ptr, &Method_Verb, Ptr, &URL, "Str", "HTTP/1.1", Ptr, 0, Ptr, &Accept_PtrArray, "UInt", Internet_Flags, Ptr ) )
MyErrors .= "`nThere was a problem creating a HTTP request. 'WinINet\HttpOpenRequest" WorA "' failed: Return value = " hRequest ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If ( hbuffer != "" ) && !DllCall( "WinINet\HttpAddRequestHeaders" WorA, Ptr, hRequest, Ptr, &hbuffer, "UInt", StrLen( hbuffer ), "UInt", 0xA0000000 )
MyErrors .= "`nThere was a problem adding one or more headers to the request. 'WinINet\HttpAddRequestHeaders" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`nHeaders: `n" hbuffer
Else If ( Security_Flags_Add || Security_Flags_Nix ) && !DllCall( "WinINet\InternetQueryOption" WorA, Ptr, hRequest, "UInt", 31, "UInt*", Security_Flags, "UInt*", 4 )
MyErrors .= "`nThere was a problem retrieving the security flags. 'WinINet\InternetQueryOption" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If ( Security_Flags_Add || Security_Flags_Nix ) && !DllCall( "WinINet\InternetSetOption" WorA, Ptr, hRequest, "UInt", 31, "UInt*", pos := ( ~Security_Flags_Nix & Security_Flags ) | Security_Flags_Add, "UInt*", 4 )
MyErrors .= "`nThere was a problem setting the security flags. 'WinINet\InternetSetOption" WorA "' failed: Flags value = " pos ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If !( 0 < Content_Length ) && !DllCall( "WinINet\HttpSendRequest" WorA, Ptr, hRequest, Ptr, 0, "UInt", 0, Ptr, 0, "UInt", 0 )
MyErrors .= "`nThere was a problem sending the " Method_Verb " request. 'WinINet\HttpSendRequest" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If ( 0 < Content_Length ) && !DllCall( "WinINet\HttpSendRequestEx" WorA, Ptr, hRequest, Ptr, &INTERNET_BUFFERS, "UInt", 0, Ptr, 0, "UInt", 0 )
MyErrors .= "`nThere was a problem sending the " Method_Verb " request. 'WinINet\HttpSendRequestEx" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If ( 0 < Content_Length )
{
If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( -1, Content_Length, Do_Callback_3rdParam ) )
MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. Zero bytes were uploaded."
Else	If ( Do_File_Upload ) && !( Do_File_Upload := DllCall( "CreateFile" WorA, Ptr, &Upload_File_Path, "UInt", 0x80000000, "UInt", 0, Ptr, 0, "UInt", 4, "UInt", 0, Ptr, 0, Ptr ) )
MyErrors .= "`nThere was a problem opening the file to upload """ Upload_File_Path """. 'CreateFile" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else
{
size := 0
Loop
If ( Content_Length <= size )
Break
Else IfInString, MyErrors, `n
Break
Else
{
If ( size < Do_Multipart )
{
pos := &rbuffer
dtsz := Do_Multipart - size < 4096 ? Do_Multipart - size : 4096
}
Else If ( Do_Multipart + dbuffsz <= size )
{
pos := &rbuffer + Do_Multipart
dtsz := Content_Length - size < 4096 ? Content_Length - size : 4096
}
Else If ( Do_File_Upload ) && !DllCall( "ReadFile", Ptr, Do_File_Upload, Ptr, pos := &dbuffer, "UInt", dbuffsz - size < 4096 ? dbuffsz - size : 4096, "Int*", dtsz, Ptr, 0 )
{
MyErrors .= "`nThere was a problem reading from the file """ Upload_File_Path """. 'ReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Break
}
Else
{
pos := &dbuffer + size
dtsz := dbuffsz - size < 4096 ? dbuffsz - size : 4096
}
If !DllCall( "WinINet\InternetWriteFile", Ptr, hRequest, Ptr, pos, "UInt", dtsz + 0, "Int*", dtsz )
MyErrors .= "`nThere was a problem uploading the POST data. 'WinINet\InternetWriteFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else
{
size += dtsz
If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( size / Content_Length - 1, Content_Length, Do_Callback_3rdParam ) )
MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. " size " bytes were uploaded."
}
}
If ( Do_File_Upload ) && !DllCall( "CloseHandle", Ptr, Do_File_Upload )
MyErrors .= "`nThere was a problem closing the file """ Upload_File_Path """. 'CloseHandle' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
}
DllCall( "WinINet\HttpEndRequest" WorA, Ptr, hRequest, Ptr, 0, "UInt", 0, Ptr, 0 )
}
Content_Length := size := rbuffsz := 0
If InStr( MyErrors, "`n" )
hbuffer := ""
Else
{
DllCall( "WinINet\InternetQueryDataAvailable", Ptr, hRequest, "Int*", Content_Length, "UInt", 0, Ptr, 0 )
If VarSetCapacity( hbuffer, hbuffsz := 4096, 0 )
&& !DllCall( "WinINet\HttpQueryInfo" WorA, Ptr, hRequest, "UInt", 22, Ptr, &hbuffer, "Int*", hbuffsz, Ptr, 0 )
&& VarSetCapacity( hbuffer, hbuffsz, 0 )
&& !DllCall( "WinINet\HttpQueryInfo" WorA, Ptr, hRequest, "UInt", 22, Ptr, &hbuffer, "Int*", hbuffsz, Ptr, 0 )
MyErrors .= "`nThere was a problem reading the response headers. 'WinINet\HttpQueryInfo" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else
{
VarSetCapacity( hbuffer, -1 )
StringReplace, hbuffer, hbuffer, `r`n, `n, A
StringMid, Response_Code, hbuffer, InStr( hbuffer, " " ) + 1, 3
If ( 17 != pos := 17 + InStr( hbuffer, "`nContent-Length: " ) )
StringMid, Content_Length, hbuffer, pos, InStr( hbuffer, "`n", 0, pos ) - pos
}
}
If ( Content_Length ) && !InStr( MyErrors, "`n" )
{
If ( Do_Download_To_File ) && !( Do_Download_To_File := DllCall( "CreateFile" WorA, Ptr, &output_file_path, "UInt", 0x40000000, "UInt", 0, Ptr, 0, "UInt", 4, "UInt", 0, Ptr, 0, Ptr ) )
MyErrors .= "`nThere was a problem opening/creating the output file for writing data: """ output_file_path """. 'CreateFile" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If ( Do_Download_Resume ) && !DllCall( "SetFilePointerEx", Ptr, Do_Download_To_File, "Int64", Do_Download_Resume, Ptr, 0, "UInt", 0 )
MyErrors .= "`nThere was a problem seeking to the end of the output file for resuming the download. 'SetFilePointerEx' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( Do_Download_Resume, Content_Length + Do_Download_Resume, Do_Callback_3rdParam ) )
MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. Zero bytes were downloaded."
Else
{
VarSetCapacity( dbuffer, dbuffsz := Do_Download_To_File ? 4096 : 4096 + Content_Length, 0 )
Loop
IfInString, MyErrors, `n
Break
Else
{
If ( Do_Download_To_File )
pos := &dbuffer
Else If ( size + 4096 < Content_Length )
pos := &dbuffer + size
Else
{
VarSetCapacity( rbuffer, rbuffsz := size + 4096 + 1, 0 )
pos := &rbuffer + size
}
If !DllCall( "WinINet\InternetReadFile", Ptr, hRequest, Ptr, pos, "UInt", 4096, "Int*", dtsz )
MyErrors .= "`nThere was a problem downoading data. 'WinINet\InternetReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If !dtsz
{
If ( Do_Callback )
%Do_Callback_Func%( 1, Content_Length + Do_Download_Resume, Do_Callback_3rdParam )
Break
}
Else If ( Do_Download_To_File ) && !DllCall( "WriteFile", Ptr, Do_Download_To_File, Ptr, pos, "UInt", dtsz, "Int*", 0, Ptr, 0 )
MyErrors .= "`nThere was a problem writing data to the disk. 'WriteFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
Else If !( Do_Download_To_File ) && ( size < rbuffsz )
{
DllCall( "RtlMoveMemory", Ptr, &rbuffer, Ptr, &dbuffer, "Int", size )
VarSetCapacity( dbuffer, Content_Length := 4096 + ( size += dtsz ), 0 )
DllCall( "RtlMoveMemory", Ptr, &dbuffer, Ptr, &rbuffer, "Int", size )
rbuffsz := 0
}
Else size += dtsz
If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( ( size + Do_Download_Resume ) / ( Content_Length + Do_Download_Resume ), Content_Length + Do_Download_Resume, Do_Callback_3rdParam ) )
MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. " size " bytes were uploaded."
}
If ( Do_Download_To_File )
{
If ( Do_Legacy_Dual_Output )
{
VarSetCapacity( dbuffer, size + 1, 0 )
If !DllCall( "ReadFile", Ptr, Do_Download_To_File, Ptr, &dbuffer, "UInt", size, Ptr, 0, Ptr, 0 )
MyErrors .= "`nThere was a problem reading the file """ output_file_path """. 'ReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
}
If !DllCall( "CloseHandle", Ptr, Do_Download_To_File )
MyErrors .= "`nThere was a problem closing the file """ output_file_path """. 'CloseHandle' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
}
}
}
DllCall( "WinINet\InternetCloseHandle", Ptr, hRequest )
DllCall( "WinINet\InternetCloseHandle", Ptr, hConnection )
DllCall( "WinINet\InternetCloseHandle", Ptr, hInternet )
DllCall( "FreeLibrary", Ptr, hModule )
If ( Do_Dn_MD5_Hash ) && InStr( hbuffer, "`nContent-MD5: " )
If ( Do_Download_To_File )
hbuffer .= "`nComputed-MD5: " HTTPRequest_MD5( rbuffer, output_file_path )
Else hbuffer .= "`nComputed-MD5: " HTTPRequest_MD5( dbuffer, size )
If ( size ) && ( !( Do_Download_To_File ) || ( Do_Legacy_Dual_Output ) )
{
If ( 15 != pos := 15 + InStr( hbuffer, "`nContent-Type: " ) )
StringMid, Content_Type, hbuffer, pos, InStr( hbuffer "`n", "`n", 0, pos ) - pos
Else Content_Type := "text/plain; charset=" MyCharset
If ( 7 != pos := 7 + InStr( Content_Type, "charset=" ) )
&& ( pos := InStr( Codepage_Charsets, SubStr( Content_Type, pos
, InStr( Content_Type ";" , ";", 0, pos ) - pos ) "|" ) )
StringMid, Convert_POST_To_Codepage, Codepage_Charsets, pos - 5, 5
Else Convert_POST_To_Codepage := IsUnicode ? "65001" : MyACP
StringLeft, Content_Type, Content_Type, InStr( Content_Type ";", ";" ) - 1
If !( pos := InStr( Content_Type, "text/" ) = 1 )
Loop, Parse, Text_Content_Subtypes, /
If ( pos |= 0 < InStr( Content_Type, "/" A_LoopField ) )
Break
If ( Do_Binary_Down ) || !( pos ) || ( Convert_POST_To_Codepage = MyACP )
{
VarSetCapacity( In_POST__Out_Data, size + 2, 0 )
DllCall( "RtlMoveMemory", Ptr, &In_POST__Out_Data, Ptr, &dbuffer, "Int", size )
If ( pos )
VarSetCapacity( In_POST__Out_Data, -1 )
}
Else
{
If ( Convert_POST_To_Codepage = "01200" )
{
pos := &dbuffer
rbuffsz := size >> 1
}
Else If ( 0 < rbuffsz := DllCall( "MultiByteToWideChar", "UInt", Convert_POST_To_Codepage, "UInt", 0, Ptr, &dbuffer, "Int", size, Ptr, 0, "Int", 0 ) )
{
VarSetCapacity( rbuffer, rbuffsz + 1 << 1 )
DllCall( "MultiByteToWideChar", "UInt", Convert_POST_To_Codepage, "UInt", 0, Ptr, &dbuffer, "Int", size, Ptr, pos := &rbuffer, "Int", rbuffsz )
}
Else MyErrors .= "`nThere was a problem converting codepage " Convert_POST_To_Codepage " to " MyACP ". 'MultiByteToWideChar' failed: Return value = " rbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
If ( IsUnicode )
{
VarSetCapacity( In_POST__Out_Data, rbuffsz + 1 << 1, 0 )
DllCall( "RtlMoveMemory", Ptr, &In_POST__Out_Data, Ptr, &rbuffer, "Int", rbuffsz << 1 )
VarSetCapacity( In_POST__Out_Data, -1 )
}
Else If ( 0 < rbuffsz ) && ( 0 < dbuffsz := DllCall( "WideCharToMultiByte", "UInt", MyACP, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0 ) )
{
VarSetCapacity( In_POST__Out_Data, dbuffsz + 1, 0 )
DllCall( "WideCharToMultiByte", "UInt", MyACP, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, &In_POST__Out_Data, "Int", dbuffsz, Ptr, 0, Ptr, 0 )
size := dbuffsz
VarSetCapacity( In_POST__Out_Data, -1 )
}
Else MyErrors .= "`nThere was a problem converting codepage " Convert_POST_To_Codepage " to " MyACP ". 'WideCharToMultiByte' failed: Return value = " dbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
}
}
Else
In_POST__Out_Data := ""
In_Out_HEADERS := SubStr( hbuffer, 1, -1 ) . SubStr( MyErrors, 1 + ( hbuffer = "" ) )
Return size, dbuffer := "", hbuffer := "", rbuffer := "", ErrorLevel := Response_Code
}
HTTPRequest_MD5( byref data, length=-1 ) {
Static s, k, pty, u, p:=0, r := "GLQVGLQVGLQVGLQVEINTEINTEINTEINTDKPWDKPWDKPWDKPWFJOUFJOUFJOUFJOU"
If !( p )
{
VarSetCapacity( k, 256 )
VarSetCapacity( S, 64, 0 )
u := !!A_IsUnicode
pty := A_PtrSize = "" ? "UInt" : "Ptr"
Loop, 64
NumPut( i := Floor(Abs(Sin(A_Index)) * 0x100000000 ), k, A_Index - 1 << 2, "UInt" )
}
If length IS NOT NUMBER
IfExist, % length
{
hFile := DllCall( "CreateFile" ( u ? "W" : "A" ), "Str", length
, "UInt", 0x80000000
, "UInt", 0, pty, 0
, "UInt", 4
, "UInt", 0, pty, 0, Ptr )
VarSetCapacity( l, 8 )
DllCall( "GetFileSizeEx", pty, hFile, pty, &l )
length := NumGet( l, 0, "Int64" )
}
If Round( length ) < 1
length := StrLen( dat ) << u
ha := 0x67452301, hb := 0xEFCDAB89, hc := 0x98BADCFE, hd := 0x10325476
Loop % length + 72 >> 6
{
If ( f := length - 64 > ( e := A_Index - 1 << 6 ) ? 64 : length > e ? length - e : 0 )
If ( hFile )
DllCall( "ReadFile", pty, hFile, pty, &s, "UInt", f, pty, &l, pty, 0 )
Else DllCall( "RtlMoveMemory", pty, &s, pty, &data + e, "UInt", f )
If ( f != 64 && e <= length )
NumPut( 128, s, f, "UChar" )
If ( f < 56 )
Loop 8
NumPut( ( ( length << 3 ) >> ( A_Index - 1 << 3 ) ) & 255, s, 55 + A_Index, "UChar" )
a := ha, b := hb, c := hc, d := hd
Loop 64
{
e := NumGet( r, ( i := A_Index - 1 ) << u, "UChar" ) & 31
f := 0 = ( j := i >> 4 ) ? (b&c)|(~b&d) : j=1 ? (d&b)|(~d&c) : j=2 ? b^c^d : c^(~d|b)
g := &s + (( i * ( 3817 >> j * 3 & 7 ) + ( 328 >> j * 3 & 7 ) & 15 ) << 2 )
w := (*(g+3) << 24 | *(g+2) << 16 | *(g+1) << 8 | *g) + a + f + NumGet(k,i<<2,"UInt")
a := d, d := c, c := b, b += w << e | (( w & 0xFFFFFFFF ) >> ( 32 - e ))
}
ha := ha+a&0xFFFFFFFF, hb := hb+b&0xFFFFFFFF, hc := hc+c&0xFFFFFFFF, hd := hd+d&0xFFFFFFFF
VarSetCapacity( S, 64, 0 )
}
If ( hFile )
DllCall( "CloseHandle", pty, hFile )
Loop 32
g:=1&(i:=A_Index-1), e:=Chr(97+(i>>3))
, f:=15&(h%e%>>((!g-g+i&7)<<2)), s.=Chr(48+f+39*(9<f))
s .= "0000"
Loop 6
Loop, % 4+0*(g := Abs("0x" SubStr( s,A_Index*6-5,6)))
i:=(g>>6*(4-A_Index))&63, s.=i=63 ? "/" : i=62 ? "+" : Chr(i<26 ? i+65 : i<52 ? i+71 : i-4)
Return SubStr( s, 37, 22 ) "=="
}
URLDownloadToVar(url, SetTimeouts="", WaitForResponse="", proxy=""){
hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
if(proxy!="")
hObject.SetProxy(HTTPREQUEST_PROXYSETTING_PROXY:=2 , proxy)
if IsObject(SetTimeouts)
hObject.SetTimeouts(SetTimeouts[1], SetTimeouts[2], SetTimeouts[3], SetTimeouts[4])
hObject.Open("GET",url)
,hObject.Send()
if (WaitForResponse!="")
hObject.WaitForResponse(WaitForResponse)
return hObject.ResponseText
}
URL2Var(url, proxy="", binary=false, toFile="", encoding="cp0"){
httprequest(url ,post:="",header:="", "binary" (proxy!=""?"`nproxy: " proxy:""))
,regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
if (code1<200 || code1>=300)
return
if !binary
post:=StrGet(&post, encoding)
if (toFile!="")
if binary
BinWrite(toFile, post, len)
else
FileAppend,% post,% toFile, utf-8
return post
}
NoTrayOrphans() {
TrayInfo:= TrayIcons(sExeName,"ahk_class Shell_TrayWnd","ToolbarWindow32" . GetTrayBar()) "`n"
. TrayIcons(sExeName,"ahk_class NotifyIconOverflowWindow","ToolbarWindow321")
Loop, Parse, TrayInfo, `n
{
ProcessName:= StrX(A_Loopfield, "| Process: ", " |")
ProcesshWnd:= StrX(A_Loopfield, "| hWnd: ", " |")
ProcessuID := StrX(A_Loopfield, "| uID: ", " |")
If !ProcessName && ProcesshWnd
RemoveTrayIcon(ProcesshWnd, ProcessuID)
}
}
RemoveTrayIcon(hWnd, uID, nMsg = 0, hIcon = 0, nRemove = 2) {
NumPut(VarSetCapacity(ni,444,0), ni)
,NumPut(hWnd , ni, 4)
,NumPut(uID  , ni, 8)
,NumPut(1|2|4, ni,12)
,NumPut(nMsg , ni,16)
,NumPut(hIcon, ni,20)
Return    DllCall("shell32\Shell_NotifyIconA", "Uint", nRemove, "Uint", &ni)
}
TrayIcons(sExeName,traywindow,control) {
DetectHiddenWindows, On
WinGet,   pidTaskbar, PID, %traywindow%
hProc:=   DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar, "Ptr")
,pProc:=   DllCall("VirtualAllocEx", "Ptr", hProc, "Ptr", 0, "Ptr", 32, "Uint", 0x1000, "Uint", 0x4, "Ptr")
SendMessage, 0x418, 0, 0, %control%, %traywindow%
Loop,   %ErrorLevel%
{
SendMessage, 0x417, A_Index-1, pProc, %control%, %traywindow%
VarSetCapacity(btn,32,0), VarSetCapacity(nfo,32,0)
,DllCall("ReadProcessMemory", "Ptr", hProc, "Ptr", pProc, "Ptr", &btn, "Uint", 32, "Uint", 0)
,iBitmap   := NumGet(btn, 0)
,idn   := NumGet(btn, 4)
,Statyle := NumGet(btn, 8)
If   dwData   := NumGet(btn,12)
iString   := NumGet(btn,16)
Else   dwData   := NumGet(btn,16,"int64"), iString:=NumGet(btn,24,"int64")
DllCall("ReadProcessMemory", "Ptr", hProc, "Ptr", dwData, "Ptr", &nfo, "Uint", 32, "Uint", 0)
If   NumGet(btn,12)
hWnd   := NumGet(nfo, 0)
,   uID   := NumGet(nfo, 4)
,   nMsg   := NumGet(nfo, 8)
,   hIcon   := NumGet(nfo,20)
Else   hWnd   := NumGet(nfo, 0,"int64"), uID:=NumGet(nfo, 8), nMsg:=NumGet(nfo,12), hIcon := NumGet(nfo,24)
WinGet, pid, PID,			  ahk_id %hWnd%
WinGet, sProcess, ProcessName, ahk_id %hWnd%
WinGetClass, sClass,		   ahk_id %hWnd%
If !sExeName || (sExeName = sProcess) || (sExeName = pid)
VarSetCapacity(sTooltip,128), VarSetCapacity(wTooltip,128*2)
,   DllCall("ReadProcessMemory", "Ptr", hProc, "Ptr", iString, "Ptr", &wTooltip, "Uint", 128*2, "Uint", 0)
,   DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "str", wTooltip, "int", -1, "str", sTooltip, "int", 128, "Uint", 0, "Uint", 0)
,   sTrayIcons .= "idx: " . A_Index-1 . " | idn: " . idn . " | Pid: " . pid . " | uID: " . uID . " | MessageID: " . nMsg . " | hWnd: " . hWnd . " | Class: " . sClass . " | Process: " . sProcess . " | Icon: " . hIcon . " | Tooltip: " . wTooltip . "`n"
}
DllCall("VirtualFreeEx", "Ptr", hProc, "Ptr", pProc, "Uint", 0, "Uint", 0x8000)
,DllCall("CloseHandle", "Ptr", hProc)
return   sTrayIcons
}
GetTrayBar() {
ControlGet, hParent, hWnd,, TrayNotifyWnd1  , ahk_class Shell_TrayWnd
ControlGet, hChild , hWnd,, ToolbarWindow321, ahk_id %hParent%
Loop {
ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
If  Not    hWnd
Break
Else If    hWnd = %hChild%
{
idxTB := A_Index
Break
}
}
Return    idxTB
}
StrX( H,BS="",ES="",Tr=1,ByRef OS=1) {
return,(SP := InStr(H,BS,0,OS)) && (L := InStr(H,ES,0,SP+StrLen(BS))) && (OS := L + StrLen(ES)) ? SubStr(H,SP := Tr ? SP + StrLen(BS) : SP ,(Tr ? L : L + StrLen(ES))-SP) : ""
}
Zip(FilesToZip,sZip)
{
If Not FileExist(sZip)
CreateZipFile(sZip)
psh := ComObjCreate( "Shell.Application" )
,pzip := psh.Namespace( sZip )
if InStr(FileExist(FilesToZip), "D")
FilesToZip .= SubStr(FilesToZip,0)="\" ? "*.*" : "\*.*"
loop,%FilesToZip%,1
{
zipped++
ToolTip Zipping %A_LoopFileName% ..
pzip.CopyHere( A_LoopFileLongPath, 4|16 )
Loop
{
done := pzip.items().count
if done = %zipped%
break
}
done := -1
}
ToolTip
}
ZipFiles(ArrFiles, sZip){
If Not FileExist(sZip)
CreateZipFile(sZip)
psh := ComObjCreate( "Shell.Application" )
,pzip := psh.Namespace( sZip )
for k,v in ArrFiles
{
zipped++
ToolTip Zipping %v% ..
pzip.CopyHere( v, 4|16 )
Loop
{
done := pzip.items().count
if done = %zipped%
break
}
done := -1
}
ToolTip
}
CreateZipFile(sZip)
{
Header1 := "PK" . Chr(5) . Chr(6)
,VarSetCapacity(Header2, 18, 0)
,file := FileOpen(sZip,"w")
,file.Write(Header1)
,file.RawWrite(Header2,18)
,file.close()
}
Unz(sZip, sUnz)
{
fso := ComObjCreate("Scripting.FileSystemObject")
If Not fso.FolderExists(sUnz)
fso.CreateFolder(sUnz)
ToolTip % "Unzipping in progress.. " sZip
psh  := ComObjCreate("Shell.Application")
,zippedItems := psh.Namespace( sZip ).items().count
,psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
ToolTip
}
_scs_sync(){
if FileExist(path:=A_ScriptDir "\scsnakeUpdate.exe")
|| FileExist(path:=A_ScriptDir "\..\scsnakeUpdate.exe")
|| FileExist(path:=A_MyDocuments "\scsnakeUpdate.exe")
|| FileExist(path:=A_MyDocuments "\scsnake\scsnakeUpdate.exe"){
path:=GetFullPath(path)
run % """" path """ """ A_ScriptFullPath """"
}
}
scs_update(name, base_url, localFolderFile, is_folder){
if(is_folder){
if !InStr(FileExist(localFolderFile), "D")
FileCreateDir,% localFolderFile
if !FileExist(p:=PathCombine(localFolderFile, name ".version"))
FileAppend,,% p, utf-8
scs_sync([base_url (base_url~="\/$"?"":"/") name "/"], localFolderFile, 0, 3, 0, 0, 1, 1)
}else{
SplitPath,localFolderFile,,dir
if !InStr(FileExist(dir), "D")
FileCreateDir,% dir
if !FileExist(p:=localFolderFile)
FileAppend,,% p, utf-8
scs_sync([base_url (base_url~="\/$"?"":"/") name], p, 0, 3, 0, 0, 1, 0)
}
}
update_self(url){
SplitPath,A_ScriptDir,,fileDir
FileCreateDir,% localFolder:=A_ScriptDir "\" a_now "_update"
httprequest(url,post:="",header:="","binary`nProxy: proxy.hospital-n.local:3128")
regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
if (code1<200 || code1>=300){
MsgBox % "Download error !"
return
}else
BinWrite(downloadFile:=localFolder "\" A_ScriptName, post, len)
lastUpdate:=fileDir "\lastUpdate_" A_ScriptName
cmd1=
	(LTrim
	TITLE Updating...
	@echo off
)
cmd2:="taskkill /IM """ a_scriptname """ /F`n"
cmd3=
	(Ltrim
	xcopy "%localFolder%" "%fileDir%" /c /q /i /s /e /k /h /y
	echo %now% > "%lastUpdate%"
	attrib +h "%lastUpdate%" 
)
cmd4:="start """" """ A_ScriptFullPath """`n"
cmd5=
	(LTrim
	rd "%localFolder%" /s /q
	(goto) 2>nul & del "`%~f0"
)
fileappend,% fullCmd:=cmd1 cmd2 cmd3 cmd4 cmd5,% updateCmd:=fileDir "\" now "update.bat",cp0
Run,%updateCmd%,,Hide
}
scs_sync(url="", localFolderFile="", showMessageBox=1, Retry=3, isRecur=0, noUpdateWithin=720, noStart=false, is_folder=""){
tried:=0, errLog:="",targetType:=0, tmpFile:=""
if !(noUpdateWithin+0>0)
noUpdateWithin:=720
localFolderFile:=RegExReplace(localFolderFile, "\/", "\")
if (localFolderFile~="\\$")
localFolderFile:=SubStr(localFolderFile,1,-1)
,is_folder:=true
inputPath:=GetFullPath(localFolderFile)
f:=FileExist(localFolderFile)
SplitPath,inputPath,fileNameWithExt,dir,fileExt,fileNameNoExt
SplitPath,dir,dirName,pDir
if (is_folder!=""){
if(is_folder){
if InStr(f, "D") || (fileExt=""){
FileCreateDir,% inputPath
localFolderFile:=fileDir:=PathCombine(dir, fileNameWithExt)
,isFolder:=true
,i:=0
Loop,files,% localFolderFile "\*.version"
localVersionFile:=A_LoopFileLongPath
,i++
if (i>1)
if !FileExist(p:=PathCombine(localFolderFile, fileNameWithExt ".version"))
return err.="Cannot determine target!"
else
localVersionFile:=p
if (!localVersionFile){
localVersionFile:=PathCombine(localFolderFile, fileNameWithExt ".version")
FileAppend,,% localVersionFile,utf-8
FileSetAttrib,+H,% localVersionFile
}
SplitPath,localVersionFile,,,,identifier
}else{
localFolderFile:=fileDir:=dir
,isFolder:=true,
Loop,files,% PathCombine(localFolderFile, "*.version")
{
localVersionFile:=A_LoopFileLongPath
break
}
if (!localVersionFile){
localVersionFile:=fileExt="version"?inputPath:PathCombine(localFolderFile, dirName ".version")
FileAppend,,% localVersionFile,utf-8
FileSetAttrib,+H,% localVersionFile
}
SplitPath,localVersionFile,,,,identifier
SplitPath,identifier,withExt,,Ext
if(fileNameWithExt=identifier)
isFolder:=false
,localFolderFile:=PathCombine(dir, identifier)
else if (Ext){
isFolder:=false
,identifier:=fileNameWithExt
,localVersionFile:=PathCombine(dir, identifier ".version")
,localFolderFile:=PathCombine(dir, identifier)
FileAppend,,% localVersionFile,utf-8
FileSetAttrib,+H,% localVersionFile
}
}
}else{
if InStr(f, "D"){
return err.="Cannot determine target!"
}else{
localFolderFile:=fileDir:=dir
,isFolder:=false
,vf:=FileExist(localVersionFile:=fileExt="version"?inputPath:PathCombine(localFolderFile, fileNameWithExt ".version"))
if (!vf || InStr(vf,"D")){
FileAppend,,% localVersionFile,utf-8
FileSetAttrib,+H,% localVersionFile
}
SplitPath,localVersionFile,,,,identifier
}
}
}else{
if InStr(f,"D"){
FileCreateDir,% inputPath
localFolderFile:=fileDir:=PathCombine(dir, fileNameWithExt)
,isFolder:=true
,i:=0
Loop,files,% PathCombine(localFolderFile, "*.version")
localVersionFile:=A_LoopFileLongPath
,i++
if (i>1)
if !FileExist(p:=PathCombine(localFolderFile, fileNameWithExt ".version"))
return err.="Cannot determine target!"
else
localVersionFile:=p
if (!localVersionFile){
localVersionFile:=PathCombine(localFolderFile, fileNameWithExt ".version")
FileAppend,,% localVersionFile,utf-8
FileSetAttrib,+H,% localVersionFile
}
SplitPath,localVersionFile,,,,identifier
}else if (fileExt="version"){
localVersionFile:=inputPath
SplitPath,localVersionFile,,,,identifier
SplitPath,identifier,withExt,,Ext
if(Ext){
isFolder:=false
,fileDir:=dir
if !FileExist(localFolderFile:=PathCombine(dir, identifier)){
FileAppend,,% localFolderFile,utf-8
}
}else{
isFolder:=true
,localFolderFile:=fileDir:=dir
}
}else{
if FileExist(PathCombine(dir, fileNameNoExt ".version")) || (dirName=fileNameNoExt) {
localVersionFile:=PathCombine(dir, fileNameNoExt ".version")
,isFolder:=true
,fileDir:=dir
,localFolderFile:=dir
,identifier:=fileNameNoExt
}else{
localVersionFile:=PathCombine(dir, fileNameWithExt ".version")
,isFolder:=false
,fileDir:=dir
,localFolderFile:=inputPath
,identifier:=fileNameWithExt
}
if !FileExist(localVersionFile){
FileAppend,,% localVersionFile,utf-8
FileSetAttrib,+H,% localVersionFile
}
}
}
SplitPath,A_ScriptFullPath,,,,thisScriptName
if !FileExist(localVersionFile)
currentVersion:="0.0"
else{
FileReadLine,localVersion,% localVersionFile,1
RegExMatch(localVersion,"\[([^\]]+)\] *(\d{8})?", match)
if(match1!="")
currentVersion:=match1
else
currentVersion:="0.0"
}
if(!IsObject(url) && !isRecur){
if(url="")
url:=["http://intranet.hospital.example/scsnake/" identifier (isFolder?"/":"")]
else
url:=[RegExReplace(url, "\/$", "") "/" identifier (isFolder?"/":"")]
}
lastUpdate:=RegExReplace(fileDir "\lastUpdate_" identifier,"\.","_")
if !isRecur && FileExist(lastUpdate) {
FileRead,lastUpdateTime,% lastUpdate
lastUpdateTime-=a_now,Minutes
if(lastUpdateTime<noUpdateWithin){
NoTrayOrphans()
return "justUpdated"
}
}
if IsObject(url){
notLink:=0
for k, Link in url {
Link:=RegExReplace(Link, "\\", "/")
try
var:=URLDownloadToVar(isFolder?Link identifier ".version":Link ".version", [1000,1000,1000,1000], 1000)
if(var=""){
++notLink
continue
}
errLog.=(errLog=""?"":"`n`n") (ret:=scs_sync(Link, inputPath, showMessageBox, Retry, 1, noUpdateWithin, noStart, is_folder))
if (ret~="i)no newer|user cancel|not quit|cannot determine")
return errLog
}
if(notLink=url.maxindex()){
errLog.="All url are invalid`n"
if(showMessageBox){
MsgBox % "Can't link to update server."
}
}
return errLog
}
RegExMatch(url, "is)^(.+?(?:\\|\/))([^\/\\]+)(?:\\|\/)?$",match)
fileFolderName:=match2
httprequest((remoteFolder:=match1) match2 ".version",post:="",header:="","binary")
regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
if (code1<200 || code1>=300){
httprequest((remoteFolder:=match1 match2 "/") match2 ".version",post:="",header:="","binary")
regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
if(code1<200 || code1>=300){
errLog.="Can't find version file.`n"
return errLog
}else{
tmpFile:=StrGet(&post, "utf-8")
targetType:=1
}
}else{
tmpFile:=StrGet(&post, "utf-8")
}
version:=[], unzip:=[], dependency:=[]
loop,Parse,tmpFile,`n,`r
{
if ((line:=Trim(A_LoopField))=""){
continue
}else if RegExMatch(line,"unzip=([^\n]*)",match) {
Loop,Parse,match1,|
unzip[Trim(A_LoopField)]:=true
}else if RegExMatch(line,"dependency=([^\n]*)",match) {
Loop,Parse,match1,|
dependency.push(Trim(A_LoopField))
}else if RegExMatch(line,"\?--([^\n]*)",match) {
version[ver, "?delete " match1]:=""
}else if RegExMatch(line,"\[([^\]]+)\] *(\d{8})?",match) {
version[ver:=match1]:=[],version[ver,"?date"]:=match2
if(targetType=0)
version[ver, file:=fileFolderName]:=""
}else if !RegExMatch(line,"i)^\?(\w+)",match) {
version[ver, file:=line]:=""
}else if (file && match1) {
version[ver, file]:=match1
}
}
ordered_version := sort_version(version)
update:=0,toUpdate:=[]
for k,ver in ordered_version{
v:=version[ver]
if !isobject(v)
continue
if checkUpdate_compareVersion(checkUpdate_splitVersion(currentVersion), checkUpdate_splitVersion(ver))>-1
continue
anyFile:=0
for file,md5 in v {
anyFile:=1
break
}
if(anyFile)
toUpdate[ver]:=v.clone()
,update:=1
}
if(!update){
errLog.="No newer version available.`n"
FileDelete,% localVersionFile
FileAppend,% tmpFile,% localVersionFile,utf-8
FileSetAttrib,+H,% localVersionFile
goto scs_sync_EOF
}
updateInfo:=""
for k,ver in ordered_version {
if !toUpdate.haskey(ver)
continue
v:=toUpdate[ver]
updateInfo.="Version " ver " (" toUpdate[ver,"?date"] ")`n"
for file,md5 in v {
if (file~="\?delete")
updateInfo.=SubStr(file, 2) "`n"
else if (file!="?date")
updateInfo.=file "`n"
}
}
if(showMessageBox){
gui,versionInfo:Default
Gui, +LastFound
GuiHWND := WinExist()
Gui, Add, Text, ,% "Current version: " currentVersion
Gui, Add , Edit  ,% "readonly w500 h300",% updateInfo
Gui, Add , Button, Default gscs_sync_Update, Update
Gui, Add , Button, x+20 gscs_sync_Cancel, Cancel
Gui, Show
WinWaitClose, ahk_id %GuiHWND%
if(ReturnCode=0){
errLog.="User cancels update.`n"
goto scs_sync_EOF
}
}
FileDelete,% localVersionFile
FileAppend,% tmpFile,% localVersionFile,utf-8
FileSetAttrib,+H,% localVersionFile
updateList:=[], delete:=[]
for k,ver in ordered_version {
if !toUpdate.haskey(ver)
continue
v:=toUpdate[ver]
for file,md5 in v
if RegExMatch(file, "\?delete ([^\n]+)", match)
try
updateList.delete(match1)
,delete[match1]:=true
else if(file!="?date"){
updateList[file]:=md5
if delete.haskey(match1)
delete.delete(match1)
}
}
localFolder:=RegExReplace(fileDir "\" a_now "_update_" identifier "\","\.","_")
for file,md5 in updateList {
try:=0
loop % retry {
SplitPath,% localFolder file,,dir
if !InStr(FileExist(dir),"D")
FileCreateDir,% dir
filedelete,% localFolder file
httprequest(remoteFolder file,post:="",header:="","binary")
regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
if !(code1<200 || code1>=300) {
BinWrite(localFolder file, post, len)
if (!md5 || md5=md5_file(localFolder file)){
break
}else{
++try
}
}else{
++try
}
}
if (try=retry){
errLog.="Can't download """ file """.`n"
goto scs_sync_EOF
}
}
if (unzip.SetCapacity(0)!=0){
for file, md5 in updateList {
if !unzip.haskey(file)
continue
SplitPath,% localFolder file,,dir
try
Unz(localFolder file, dir)
catch e {
}
if !e
FileDelete,% localFolder file
}
}
SplitPath,localVersionFile,fileNameWithExt,dir,,fileNameNoExt
SplitPath,dir,dirName,pDir
for k,v in delete {
FileDelete,% PathCombine(dir, k)
}
for k,v in dependency {
if (v~="\.([^\n]+)$")
target_is_file:=true
if (isFolder){
if (target_is_file){
scs_sync([url "../" v] , GetFullPath(dir "\..\" v),0,3,0,1,1,0)
}else{
scs_sync([url "../" v "/"], GetFullPath(dir "\..\" v),0,3,0,1,1,1)
}
}else{
if (target_is_file){
scs_sync([RegExReplace(url, "\/[^\/]+$", "/") v], GetFullPath(dir "\" v),0,3,0,1,1,0)
}else{
scs_sync([RegExReplace(url, "\/[^\/]+$", "/") v "/"], GetFullPath(dir "\" v),0,3,0,1,1,1)
}
}
}
if(showMessageBox && !updateOther){
MsgBox, 4161, Quit and Update, The script will quit and update.
IfMsgBox,Cancel
{
errLog.="Script not quit for updating.`n"
goto scs_sync_EOF
}
}
processList:=ProcessList()
,opened:=[],openedStr:="", updateOther:=true, selfOpenedPid:=0
if (isFolder){
for file,md5 in updateList {
for k, ProcessInfo in ProcessList {
if(ProcessInfo.path=(localFolderFile "\" file)){
if(ProcessInfo.path=A_ScriptFullPath)
updateOther:=false
,selfOpenedPid:=ProcessInfo.pid
else {
SplitPath,file,fileName
opened.push(ProcessInfo.pid)
,openedStr.=fileName ", "
}
break
}
}
}
}else{
for ProcessName, ProcessInfo in ProcessList
if(ProcessInfo.path=localFolderFile){
if(ProcessInfo.path=A_ScriptFullPath)
updateOther:=false
,selfOpenedPid:=ProcessInfo.pid
else {
SplitPath,localFolderFile,fileName
opened.push(ProcessInfo.pid)
,openedStr.=fileName ", "
}
break
}
}
tasksKill:="taskkill"
for k,v in opened
tasksKill.=" /PID " v
if selfOpenedPid
tasksKill.=" /PID " selfOpenedPid
localFolder:=SubStr(localFolder,1,-1)
now:=a_now
cmd1=
	(LTrim
	TITLE Updating...
	@echo off
	
)
cmd1.="`n" tasksKill	"`n"
if(updateOther){
if !(InStr(FileExist(inputPath), "D")){
cmd4:=noStart?"":"start """" """ inputPath """`n"
}else
cmd2:=cmd4:=""
}else{
if (a_iscompiled){
cmd4:=noStart?"":"start """" """ A_ScriptFullPath """`n"
}else{
cmd2=
cmd4:=noStart?"":"start """" """ A_AhkPath """ """ A_ScriptFullPath """`n"
}
}
cmd3=
	(Ltrim
	xcopy "%localFolder%" "%fileDir%" /c /q /i /s /e /k /h /y
	echo %now% > "%lastUpdate%"
	attrib +h "%lastUpdate%" 
	
)
cmd5=
	(LTrim
	rd "%localFolder%" /s /q
	(goto) 2>nul & del "`%~f0"
)
fileappend,% fullCmd:=cmd1 cmd2 cmd3 cmd4 cmd5,% updateCmd:=fileDir "\" now "update_" RegExReplace(identifier, "\.", "_") ".bat",cp0
Run,%updateCmd%,,Hide
return errLog
scs_sync_EOF:
FileDelete,% tmpFile
if(localFolder!=""){
if (replaceCurrentScript)
FileRemoveDir,% localFolder,1
else if (showMessageBox)
run % localFolder
}
return errLog
scs_sync_Update:
ReturnCode:=1
Gui,versionInfo:Destroy
return
scs_sync_Cancel:
versionInfoGuiEscape:
versionInfoGuiClose:
ReturnCode = 0
Gui, versionInfo:Destroy
return
}
checkUpdate(url,currentVersion,replaceCurrentScript=1,showMessageBox=1,retry=3){
tried:=0, errLog:="",targetType:=0
,tmpFile:=A_ScriptDir "\" a_now "_temp.tmp"
if FileExist(lastUpdate:=RegExReplace(a_scriptdir "\lastUpdate_" A_ScriptName,"\.","_")) {
FileRead,lastUpdateTime,% lastUpdate
lastUpdateTime-=a_now,Seconds
if(lastUpdateTime<3600)
return "justUpdated"
}
FileDelete,% tmpFile
RegExMatch(url, "is)^(.+?(?:\\|\/))([^\/\\]+)(?:\\|\/)?$",match)
fileFolderName:=match2
httprequest((remoteFolder:=match1) match2 ".version",post:="",header:="","binary")
regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
if (code1<200 || code1>=300){
httprequest((remoteFolder:=match1 match2 "\") match2 ".version",post:="",header:="","binary")
regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
if(code1<200 || code1>=300){
errLog.="Can't find version file.`n"
if(showMessageBox)
MsgBox,% errLog
goto checkUpdate_EOF
}else{
BinWrite(tmpFile,post,len)
targetType:=1
}
}else{
BinWrite(tmpFile,post,len)
}
version:=[]
loop,read,% tmpFile
{
if (line:=Trim(A_LoopReadLine))="" {
continue
}else if RegExMatch(line,"\[([^\]]+)\] *(\d{8})?",match) {
version[ver:=match1]:=[],version[ver,"?date"]:=match2
if(targetType=0)
version[ver, file:=fileFolderName]:=""
}else if !RegExMatch(line,"i)^\?(\w+)",match) {
version[ver, file:=line]:=""
}else if (file && match1) {
version[ver, file]:=match1
}
}
update:=0,toUpdate:=[]
for ver,v in version {
if !isobject(v)
continue
if checkUpdate_compareVersion(checkUpdate_splitVersion(currentVersion), checkUpdate_splitVersion(ver))>-1
continue
anyFile:=0
for file,md5 in v {
anyFile:=1
break
}
if(anyFile)
toUpdate[ver]:=v.clone()
,update:=1
}
if(!update){
errLog.="No newer version available.`n"
if(showMessageBox){
msgbox,% "No newer version available."
}
FileDelete,% lastUpdate
FileAppend,% a_now, % lastUpdate,utf-8
FileSetAttrib,+H,% lastUpdate
goto checkUpdate_EOF
}
updateInfo:=""
for ver,v in toUpdate {
updateInfo.="Version " ver " (" toUpdate[ver,"?date"] ")`n"
for file,md5 in v {
if (file!="?date")
updateInfo.=file "`n"
}
}
if(showMessageBox){
gui,checkUpdate:Default
Gui, +LastFound
GuiHWND := WinExist()
Gui, Add, Text, ,% "Current version: " currentVersion
Gui, Add , Edit  ,% "readonly w500 h300",% updateInfo
Gui, Add , Button, Default gcheckUpdate_Update, Update
Gui, Add , Button, x+20 gcheckUpdate_Cancel, Cancel
Gui, Show
WinWaitClose, ahk_id %GuiHWND%
if(ReturnCode=0){
errLog.="User cancels update.`n"
goto checkUpdate_EOF
}
}
updateList:=[]
for ver,v in toUpdate {
for file,md5 in v
if(file!="?date")
updateList[file]:=md5
}
localFolder:=RegExReplace(a_scriptdir "\" a_now "_update_" fileFolderName "\","\.","_")
for file,md5 in updateList {
try:=0
loop % retry {
SplitPath,% localFolder file,,dir
if !InStr(FileExist(dir),"D")
FileCreateDir,% dir
filedelete,% localFolder file
httprequest(remoteFolder file,post:="",header:="","binary")
regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
if !(code1<200 || code1>=300) {
BinWrite(localFolder file, post, len)
if (!md5 || md5=md5_file(localFolder file)){
break
}else{
++try
}
}else{
++try
}
}
if (try=retry){
errLog.="Can't download """ file """.`n"
}
}
if(!replaceCurrentScript){
goto checkUpdate_EOF
}
if(showMessageBox){
MsgBox, 4161, Quit and Update, The script will quit and update.
IfMsgBox,Cancel
{
errLog.="Script not quit for updating.`n"
replaceCurrentScript:=0
goto checkUpdate_EOF
}
}
localFolder:=SubStr(localFolder,1,-1)
now:=a_now
cmd1=
	(LTrim
	TITLE Updating...
	@echo off
	ping 1.1.1.1 -n 1 -w 3000
	
)
if (a_iscompiled){
cmd2:="taskkill /IM """ a_scriptname """ /F`n"
cmd4:="start """" """ A_ScriptFullPath """`n"
}else{
cmd2=
cmd4:="start """" """ A_AhkPath """ """ A_ScriptFullPath """`n"
}
cmd3=
	(Ltrim
	xcopy "%localFolder%" "%a_scriptdir%" /c /q /i /s /e /k /h /y
	type %a_now% > "%lastUpdate%"
	attrib +h "%lastUpdate%" 
	
)
cmd5=
	(LTrim
	rd "%localFolder%" /s /q
	(goto) 2>nul & del "`%~f0"
)
fileappend,% fullCmd:=cmd1 cmd2 cmd3 cmd4 cmd5,% updateCmd:=a_scriptdir "\" now "update.bat",cp0
FileDelete,% tmpFile
Run,%updateCmd%,,Hide
ExitApp
return errLog
checkUpdate_EOF:
FileDelete,% tmpFile
if(localFolder!=""){
if (replaceCurrentScript)
FileRemoveDir,% localFolder,1
else if (showMessageBox)
run % localFolder
}
return errLog
checkUpdate_Update:
ReturnCode:=1
Gui, checkUpdate:Destroy
return
checkUpdate_Cancel:
checkUpdateGuiEscape:
checkUpdateGuiClose:
ReturnCode = 0
Gui, checkUpdate:Destroy
return
}
checkUpdate_splitVersion(version){
ret:=[]
Loop,Parse,version,.
ret.push(A_LoopField)
return ret
}
sort_version(ver){
ret:=[], s:=""
for k,v in ver
s.=k "`n"
sort,s,F checkUpdate_compareVersion
Loop,Parse,s,`n
if Trim(A_LoopField)!=""
ret.push(Trim(A_LoopField))
return ret
}
checkUpdate_compareVersion(v1, v2){
if !IsObject(v1)
v1:=checkUpdate_splitVersion(v1)
if !IsObject(v2)
v2:=checkUpdate_splitVersion(v2)
for k,v in v1
if (v2[k]="" || v>v2[k])
return 1
else if (v<v2[k])
return -1
if (v2[k+1]!="")
return -1
else
return 0
}
SetTitleMatchMode,2
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
ComObjError(false)
FileEncoding,utf-8
OnExit,OnExit
class xml
{
__New(src:="") {
static MSXML := "MSXML2.DOMDocument" (A_OSVersion ~= "WIN_(7|8)" ? ".6.0" : "")
ObjInsert(this, "_", [])
this.doc := ComObjCreate(MSXML)
, this.setProperty("SelectionLanguage", "XPath")
if src {
if (src ~= "s)^<.*>$")
this.loadXML(src)
else if (src ~= "[^<>:""/\\|?*]+\.[^<>:""/\\|?*\s]+$") {
if FileExist(src)
this.load(src)
this.file := ""
} else throw Exception("The parameter '" src "' is neither an XML file "
. " nor a string containing XML string.`n", -1, src)
if (pe := this.parseError).errorCode {
m := pe.url ? ["file", "load"] : ["string", "loadXML"]
throw Exception("Invalid XML " m.1 ".`nError Code: " pe.errorCode
. "`nFilePos: " pe.filePos "`nLine: " pe.line "`nLinePos: " pe.linePos
. "`nReason: " pe.reason "`nSource Text: " pe.srcText
. "`nURL: " pe.url "`n", -1, m.2)
}
if (this.file <> false)
this.file := src
}
}
__Delete() {
ObjRelease(Object(this.doc))
}
__Set(property, value) {
if (property ~= "i)^(doc|file)$") {
if (property = "file") {
if (value ~= "(^$|[^<>:""/\\|?*]+\.[^<>:""/\\|?*\s]+$)")
return this._[property] := value
else return false
}
} else {
try return (this.doc)[property] := value
catch
return false
}
}
__Get(property) {
if !ObjHasKey(this, property) {
if (property = "file")
return this._.HasKey(property)
? this._[property]
: false
else {
try return (this.doc)[property]
catch
try return this.selectSingleNode(property)
}
}
}
__Call(method, params*) {
static BF := "i)^(Insert|Remove|(Min|Max)Index|(Set|Get)Capacity"
. "|GetAddress|_NewEnum|HasKey|Clone)$"
if !ObjHasKey(xml, method) {
if RegExMatch(method, "iJ)^(add|insert)((?P<_>E)lement|(?P<_>C)hild)$", m)
return this["addInsert" m_](method, params*)
else {
try return (this.doc)[method](params*)
catch e
if !(method ~= BF)
throw e
}
}
}
rename(node, newName) {
new := this.createElement(newName)
, old := IsObject(node) ? node : this.selectSingleNode(node)
while old.hasChildNodes()
new.appendChild(old.firstChild)
while (old.attributes.length > 0)
new.setAttributeNode(old.removeAttributeNode(old.attributes[0]))
old.parentNode.replaceChild(new, old)
return new
}
setAtt(element, att*) {
e := IsObject(element) ? element : this.selectSingleNode(element)
for a, b in att {
if !IsObject(b)
continue
for x, y in b
e.setAttribute(x, y)
}
}
getAtt(element, name) {
e := IsObject(element) ? element : this.selectSingleNode(element)
return e.getAttribute(name)
}
setText(element, text:="", idx:=1) {
e := IsObject(element) ? element : this.selectSingleNode(element)
if (t := this.getChild(e, "t", idx)) {
text <> "" ? t.nodeValue := text : e.removeChild(t)
return true
} else {
t := this.createTextNode(text)
, c := this.getChild(e, "", idx)
return c ? e.insertBefore(t, c) : e.appendChild(t)
}
}
getText(element, idx:=1) {
e := IsObject(element) ? element : this.selectSingleNode(element)
t := this.getChild(e, "t", idx)
return t.text
}
getChild(node, type:="element", idx:=1) {
if !idx
return
n := IsObject(node) ? node : this.selectSingleNode(node)
if !type
return n.childNodes.item(idx-1)
cn := this.getChildren(n, type)
return ObjHasKey(cn, idx) ? cn[idx] : (idx<0 ? cn[cn.MaxIndex()+idx+1] : false)
}
getChildren(node, type:="element") {
static nts := {e:"element", t:"text", cds:"cdatasection"
, er:"entityreference", en:"entity", pi:"processinginstruction"
, c:"comment", dt:"documenttype", df:"documentfragment"
, n:"notation"}
static _NT := "nodeType" , _NTS := "nodeTypeString"
n := IsObject(node) ? node : this.selectSingleNode(node)
if !n.hasChildNodes()
return false
cn := n.childNodes
if (type ~= "^(1($|0|1|2)|[3-8])$")
nType := _NT
else if (type ~= "^[[:alpha:]]+$") {
if (t := (StrLen(type)<=3))
nType := ObjHasKey(nts, type) ? _NTS : false
else {
for a, b in nts
continue
until (nType := (type = b) ? _NTS : false)
}
} else return false
if !nType
return false
c := []
Loop, % cn.length {
if (cn.item(A_Index-1)[nType] == (t ? nts[type] : type))
c[(i := i ? i : 1)] := cn.item(A_Index-1), i+=1
}
return c
}
saveXML() {
if this.file
return this.save(this.file)
}
transformXML() {
this.transformNodeToObject(this.style(), this.doc)
}
toEntity(ByRef str) {
static e := [["&", "&amp;"], ["<", "&lt;"], [">", "&gt;"], ["'", "&apos;"], ["""", "&quot;"]]
for a, b in e
str := RegExReplace(str, b.1, b.2)
return !(str ~= "s)([<>'""]|&(?!(amp|lt|gt|apos|quot);))")
}
toChar(ByRef str) {
static e := [["<", "&lt;"], [">", "&gt;"], ["'", "&apos;"], ["""", "&quot;"], ["&", "&amp;"]]
for a, b in e
str := RegExReplace(str, b.2, b.1)
return true
}
viewXML(ie:=true) {
static dir := (FileExist(A_ScriptDir) ? A_ScriptDir : A_Temp)
static _v := []
dhw := A_DetectHiddenWindows
DetectHiddenWindows, On
if !this.documentElement
return
if WinExist("ahk_id " _v[this].hwnd)
return
if ie {
this.save((f := dir "\tempXML_" A_TickCount ".xml"))
if !FileExist(f)
return
} else (f := this.xml)
if (hwnd := this._view(f)) {
_v[this] := {hwnd: hwnd, res:f}
WinWaitClose, % "ahk_id " hwnd
ObjRemove(_v, this)
}
if (ie ? FileExist(f) : false)
FileDelete, % f
DetectHiddenWindows, % dhw
}
style(){
static xsl
if !IsObject(xsl) {
RegExMatch(ComObjType(this.doc, "Name"), "IXMLDOMDocument\K(?:\d|$)", m)
MSXML := "MSXML2.DOMDocument" (m < 3 ? "" : ".6.0")
xsl := ComObjCreate(MSXML)
style =
			(LTrim
			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
			<xsl:template match="@*|node()">
			<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:for-each select="@*">
			<xsl:text></xsl:text>
			</xsl:for-each>
			</xsl:copy>
			</xsl:template>
			</xsl:stylesheet>
)
xsl.loadXML(style), style := NULL
}
return xsl
}
addInsertE(m, en, pr:="", prm*) {
n := pr
? (IsObject(pr) ? pr : this.selectSingleNode(pr))
: (m = "addElement" ? this.doc : false)
e := IsObject(en) ? en : this.createElement(en)
if prm.1 {
if !IsObject(prm[prm.maxIndex()]) {
t := prm.Delete(prm.maxIndex())
if prm.1
this.setAtt(e, prm*)
if (t <> "")
e.text := t
} else this.setAtt(e, prm*)
}
if (m = "addElement")
return n.appendChild(e)
if (m = "insertElement")
return n ? n.parentNode.insertBefore(e, n) : n
}
addInsertC(m, pr, type:="element", prm*) {
static ntm := {1:"createElement", 3:"createTextNode", 4:"createCDATASection"
, 5: "createEntityReference", 6:"createNode", 7:"createProcessingInstruction"
, 8:"createComment", 10:"createNode", 11:"createDocumentFragment"
, 12:"createNode"}
static nt := {element:1, text:3, cdatasection:4, entityreference:5, entity:6
, processinginstruction:7, comment:8, documenttype:10, documentfragment:11
, notation:12, e:1, t:3, cds:4, er:5, en:6, pi:7, c:8, dt:10, df:11, n:12}
n := IsObject(pr) ? pr : this.selectSingleNode(pr)
if (type ~= "^(1($|0|1|2)|[3-8])$")
_m := ntm[t := type]
else if (type ~= "^[[:alpha:]]+$")
_m := ntm[t := nt[type]]
else return false
if !_m
return false
if (_m == "createNode")
_n := this[_m](t, prm*)
else (_n := this[_m](prm*))
if (m = "addChild")
return _n ? n.appendChild(_n) : false
if (m = "insertChild")
return _n ? n.parentNode.insertBefore(_n, n) : false
}
_view(p*) {
static _v := []
if !ObjHasKey(_v, p.1) {
if (p.1 ~= "^(\Q" A_ScriptDir "\E|\Q" A_Temp "\E)\\tempXML_\d+\.xml$")
f := true
else if (p.1 ~= "s)^<.*>$")
f := false
else return
Gui, New
Gui, +LastFound +LabelviewXML +Resize
hwnd := WinExist()
_v[hwnd] := {button:"", res: (f ? p.1 : false), xv:""}
Gui, Margin, 0, 12
Gui, Font, s10, Consolas
Gui, Color, % f ? "" : 0xFFFFFF
Gui, Add, % f ? "ActiveX" : "Edit"
, % "y0 w600 h400 HwndhXV" (f ? "" : " HScroll -Wrap ReadOnly T8")
, % f ? "Shell.Explorer" : p.1
if f {
GuiControlGet, IE,, % hXV
IE.Navigate((_v[hwnd].res))
}
Gui, Add, Button, y+12 x+-100 w88 h26 Default HwndhBtn gviewXMLClose, OK
Gui, Show,, % A_ScriptName " - viewXML"
if !f
SendMessage, 0x00B1, 0, 0,, % "ahk_id " hXV
_v[hwnd].xv := hXV , _v[hwnd].button := hBtn
return hwnd
} else {
if (p.2 == "viewXMLClose") {
if (_v[p.1].res ? FileExist(_v[p.1].res) : false)
FileDelete, % _v[p.1].res
Gui, % p.1 ":Destroy"
_v.Delete(p.1, "")
}
if (p.2 == "viewXMLSize") {
if (A_EventInfo == 1)
return
DllCall("SetWindowPos", "Ptr", _v[p.1].button, "Ptr", 0
, "UInt", (A_GuiWidth-100), "UInt", (A_GuiHeight -38)
, "Uint",  88, "UInt", 26
, "UInt", 0x0010|0x0001|0x0004)
DllCall("SetWindowPos", "Ptr", _v[p.1].xv, "Ptr", 0
, "UInt", 0, "UInt", 0
, "Uint",  A_GuiWidth, "UInt", (A_GuiHeight-50)
, "UInt", 0x0010|0x0002|0x0004)
}
}
return
viewXMLSize:
viewXMLClose:
xml._view(A_Gui, A_ThisLabel)
return
}
}
class scintilla {
hwnd            := 0
,notify          := ""
,idFrom          := 0
,scnCode         := 0
,position        := 0
,ch              := 0
,modifiers       := 0
,modType         := 0
,text            := 0
,length          := 0
,linesAdded      := 0
,macMessage      := 0
,macwParam       := 0
,maclParam       := 0
,line            := 0
,foldLevelNow    := 0
,foldLevelPrev   := 0
,margin          := 0
,listType        := 0
,x               := 0
,y               := 0
,token           := 0
,annotLinesAdded := 0
,updated         := false
__new(params*){
if (params.MaxIndex())
__SCI(this.hwnd := __Add(params*), this)
else
return this
}
__call(msg, ByRef wParam=0, ByRef lParam=0, params*){
if (msg = "Add")
__SCI(this.hwnd := __Add(wParam, lParam, params*), this)
else
{
(wParam && !(wParam+0) && !isObject(wParam)) ? (VarSetCapacity(wParamA, StrPut(wParam, "UTF-8"))
,StrPut(wParam, &wParamA, "UTF-8")
,wParam:=&wParamA) : nullValue
(lParam && !(lParam+0) && !isObject(lParam)) ? (VarSetCapacity(lParamA, StrPut(lParam, "UTF-8"))
,StrPut(lParam, &lParamA, "UTF-8")
,lParam:=&lParamA) : nullValue
(msg = "GetText") ? (VarSetCapacity(lParam, wParam * (a_isunicode ? 2 : 1)+8), lParam := &lParam, buf:=true) : nullValue
(msg = "GetLine") ? (VarSetCapacity(lParam, this.linelength(wParam)+1 * (a_isunicode ? 2 : 1)),lParam := &lParam, buf:=true) : nullValue
(msg = "GetCurLine") ? (VarSetCapacity(lParam, this.linelength(wParam)+1 * (a_isunicode ? 2 : 1)), lParam := &lParam, buf:=true) : nullValue
(msg = "GetTextRange") ? (range:=abs(wParam.1 - wParam.2)+1, dSize :=  __sendEditor(this.hwnd, "GetLength")
,VarSetCapacity(lParam, range > dSize ? (dSize, wParam.2 := dSize) : range)
,VarSetCapacity(textRange, 12, 0)
,NumPut(wParam.1,textRange,0,"UInt")
,NumPut(wParam.2,textRange,4,"UInt")
,NumPut(&lParam,textRange,8,"UInt")
,blParam := &lParam, wParam := false,lParam := &textRange, buf:=true) : nullValue
__isHexColor(lParam, msg) ? lParam := (lParam & 0xFF) <<16 | (lParam & 0xFF00) | (lParam >>16) : nullValue
__isHexColor(wParam, msg) ? wParam := (wParam & 0xFF) <<16 | (wParam & 0xFF00) | (wParam >>16) : nullValue
res := __sendEditor(this.hwnd, msg, wParam, lParam)
buf ? (lParam := StrGet((msg = "GetTextRange") ? blParam : &lParam, "UTF-8"), buf:=false) : nullValue
return res
}
}
}
class sciCharRange {
__new(_cMin=0, _cMax=0){
this.cMin := _cMin
this.cMax := _cMax
}
}
class sciTextRange {
__new(_chrg=0, _pStr=0){
if (!isObject(_chrg)){
Msgbox % 0x0
, % "sciTextRange Object Error"
, % "The first parameter must match a sciCharRange object"
Exit
}
this.chrg := _chrg ? _chrg : new sciCharRange
this.pStr := _pStr
}
}
class sciTextToFind {
__new(_chrg=0, _text="", _found=0){
if (!isObject(_chrg) || !isObject(_found)) {
Msgbox % 0x0
, % "sciTextToFind Object Error"
, % "The first and last parameters must match a sciCharRange object"
Exit
}
this.chrg   := _chrg ? _chrg : new sciCharRange
this.text   := _text
this.found  := _found ? _found : new sciCharRange
}
}
class sciRectangle {
__new(_left=0, _top=0, _right=0, _bottom=0){
this.left    := _left
this.top     := _top
this.right   := _right
this.bottom  := _bottom
}
}
class sciRangeToFormat {
__new(_hdc=0, _hdcTarget=0, _rc=0, _rcPage=0, _chrg=0){
this.hdc         := _hdc
this.hdcTarget   := _hdcTarget
this.rc          := _rc ? _rc : new sciRectangle
this.rcPage      := _rcPage ? _rcPage : new sciRectangle
this.chrg        := _chrg ? _chrg : new sciCharRange
}
}
__Add(hParent=0, x=5, y=5, w=590, h=390, DllPath="", Styles=""){
static WS_OVERLAPPED:=0x00000000,WS_POPUP:=0x80000000,WS_CHILD:=0x40000000,WS_MINIMIZE:=0x20000000
,WS_VISIBLE:=0x10000000,WS_DISABLED:=0x08000000,WS_CLIPSIBLINGS:=0x04000000,WS_CLIPCHILDREN:=0x02000000
,WS_MAXIMIZE:=0x01000000,WS_CAPTION:=0x00C00000,WS_BORDER:=0x00800000,WS_DLGFRAME:=0x00400000
,WS_VSCROLL:=0x00200000,WS_HSCROLL:=0x00100000,WS_SYSMENU:=0x00080000,WS_THICKFRAME:=0x00040000
,WS_GROUP:=0x00020000,WS_TABSTOP:=0x00010000,WS_MINIMIZEBOX:=0x00020000,WS_MAXIMIZEBOX:=0x00010000
,WS_TILED:=0x00000000,WS_ICONIC:=0x20000000,WS_SIZEBOX:=0x00040000,WS_EX_CLIENTEDGE:=0x00000200
,GuiID:=311210,init:=false, nullValue:=0
DllPath := !DllPath ? "SciLexer.dll" : inStr(DllPath, ".dll") ? DllPath : DllPath "\SciLexer.dll"
if !init
old:=OnMessage(0x4E,"__sciNotify"),init:=true
if !SCIModule:=DllCall("LoadLibrary", "Str", DllPath, "Ptr")
return debug ? A_ThisFunc "> Could not load library: " DllPath : 1
hStyle := WS_CHILD | (VISIBILITY := InStr(Styles, "Hidden") ? 0 : WS_VISIBLE) | WS_TABSTOP
if Styles
Loop, Parse, Styles, %a_tab%%a_space%, %a_tab%%a_space%
hStyle |= %a_loopfield%+0 ? %a_loopfield% : WS_%a_loopfield% ? WS_%a_loopfield% : 0
hSci:=DllCall("CreateWindowEx"
,Uint ,WS_EX_CLIENTEDGE
,Str  ,"Scintilla"
,Str  ,""
,UInt ,hStyle
,Int  ,x ? x : 5
,Int  ,y ? y : 5
,Int  ,w ? w : 590
,Int  ,h ? h : 390
,Ptr ,hParent ? hParent : WinExist()
,Ptr ,GuiID
,Ptr ,nullValue
,Ptr ,nullValue, "Ptr")
,__sendEditor(hSci)
return hSci
}
__sendEditor(hwnd, msg=0, wParam=0, lParam=0){
static
hwnd := !hwnd ? oldhwnd : hwnd, oldhwnd := hwnd, msg := !(msg+0) ? "SCI_" msg : msg
if !%hwnd%_df
{
SendMessage, SCI_GETDIRECTFUNCTION,0,0,,ahk_id %hwnd%
%hwnd%_df := ErrorLevel
SendMessage, SCI_GETDIRECTPOINTER,0,0,,ahk_id %hwnd%
%hwnd%_dp := ErrorLevel
}
if !msg && !wParam && !lParam
return
return DllCall(%hwnd%_df
,"Ptr" ,%hwnd%_dp
,"Ptr" ,!(msg+0) ? %msg% : msg
,"Int"  ,inStr(wParam, "-") ? wParam : (%wParam%+0 ? %wParam% : wParam)
,"Int"  ,%lParam%+0 ? %lParam% : lParam, "Ptr")
}
__sciNotify(wParam, lParam, msg, hwnd){
__sciObj                 := __SCI(NumGet(lParam + 0))
,__sciObj.idFrom          := NumGet(lParam + a_Ptrsize * 1)
,__sciObj.scnCode         := NumGet(lParam + a_Ptrsize * 2)
,__sciObj.position        := NumGet(lParam + a_Ptrsize * 3)
,__sciObj.ch              := NumGet(lParam + a_Ptrsize * 4)
,__sciObj.modifiers       := NumGet(lParam + a_Ptrsize * 5)
,__sciObj.modType         := NumGet(lParam + a_Ptrsize * 6)
,__sciObj.text            := NumGet(lParam + a_Ptrsize * 7)
,__sciObj.length          := NumGet(lParam + a_Ptrsize * 8)
,__sciObj.linesAdded      := NumGet(lParam + a_Ptrsize * 9)
,__sciObj.macMessage      := NumGet(lParam + a_Ptrsize * 10)
,__sciObj.macwParam       := NumGet(lParam + a_Ptrsize * 11)
,__sciObj.maclParam       := NumGet(lParam + a_Ptrsize * 12)
,__sciObj.line            := NumGet(lParam + a_Ptrsize * 13)
,__sciObj.foldLevelNow    := NumGet(lParam + a_Ptrsize * 14)
,__sciObj.foldLevelPrev   := NumGet(lParam + a_Ptrsize * 15)
,__sciObj.margin          := NumGet(lParam + a_Ptrsize * 16)
,__sciObj.listType        := NumGet(lParam + a_Ptrsize * 17)
,__sciObj.x               := NumGet(lParam + a_Ptrsize * 18)
,__sciObj.y               := NumGet(lParam + a_Ptrsize * 19)
,__sciObj.token           := NumGet(lParam + a_Ptrsize * 20)
,__sciObj.annotLinesAdded := NumGet(lParam + a_Ptrsize * 21)
,__sciObj.updated         := NumGet(lParam + a_Ptrsize * 22)
,__sciObj.notify(wParam, lParam, msg, hwnd, __sciObj)
return __sciObj := ""
}
__isHexColor(hex, msg){
if (RegexMatch(hex, "^0x[0-9a-fA-F]{6}$"))
return true
else
return false
}
__SCI(var, val=""){
static
if (RegExMatch(var,"i)[ `n-\.%,(\\\/=&^]"))
return
lvar := %var%, val ? %var% := val : nullValue
return lvar
}
{
global INVALID_POSITION:=-1, unused := 0
{
global SCI_DELETERANGE:=2645
global SCI_ADDTEXT:=2001,SCI_ADDSTYLEDTEXT:=2002,SCI_INSERTTEXT:=2003,SCI_CLEARALL:=2004,SCI_CLEARDOCUMENTSTYLE:=2005,SCI_GETLENGTH:=2006
,SCI_GETCHARAT:=2007,SCI_GETCURRENTPOS:=2008,SCI_GETANCHOR:=2009,SCI_GETSTYLEAT:=2010,SCI_REDO:=2011,SCI_SETUNDOCOLLECTION:=2012
,SCI_SELECTALL:=2013,SCI_SETSAVEPOINT:=2014,SCI_GETSTYLEDTEXT:=2015,SCI_CANREDO:=2016,SCI_MARKERLINEFROMHANDLE:=2017
,SCI_MARKERDELETEHANDLE:=2018,SCI_GETUNDOCOLLECTION:=2019,SCI_GETVIEWWS:=2020,SCI_SETVIEWWS:=2021,SCI_POSITIONFROMPOINT:=2022
,SCI_POSITIONFROMPOINTCLOSE:=2023,SCI_GOTOLINE:=2024,SCI_GOTOPOS:=2025,SCI_SETANCHOR:=2026,SCI_GETCURLINE:=2027,SCI_GETENDSTYLED:=2028
,SCI_CONVERTEOLS:=2029,SCI_GETEOLMODE:=2030,SCI_SETEOLMODE:=2031,SCI_STARTSTYLING:=2032,SCI_SETSTYLING:=2033,SCI_GETBUFFEREDDRAW:=2034
,SCI_SETBUFFEREDDRAW:=2035,SCI_SETTABWIDTH:=2036,SCI_GETTABWIDTH:=2121,SCI_SETCODEPAGE:=2037,SCI_SETUSEPALETTE:=2039,SCI_MARKERDEFINE:=2040
,SCI_MARKERSETFORE:=2041,SCI_MARKERSETBACK:=2042,SCI_MARKERADD:=2043,SCI_MARKERDELETE:=2044,SCI_MARKERDELETEALL:=2045,SCI_MARKERGET:=2046
,SCI_MARKERNEXT:=2047,SCI_MARKERPREVIOUS:=2048,SCI_MARKERDEFINEPIXMAP:=2049,SCI_MARKERADDSET:=2466,SCI_MARKERSETALPHA:=2476
,SCI_SETMARGINTYPEN:=2240,SCI_GETMARGINTYPEN:=2241,SCI_SETMARGINWIDTHN:=2242,SCI_GETMARGINWIDTHN:=2243,SCI_SETMARGINMASKN:=2244
,SCI_GETMARGINMASKN:=2245,SCI_SETMARGINSENSITIVEN:=2246,SCI_GETMARGINSENSITIVEN:=2247,SCI_STYLECLEARALL:=2050,SCI_STYLESETFORE:=2051
,SCI_STYLESETBACK:=2052,SCI_STYLESETBOLD:=2053,SCI_STYLESETITALIC:=2054,SCI_STYLESETSIZE:=2055,SCI_STYLESETFONT:=2056
,SCI_STYLESETEOLFILLED:=2057,SCI_STYLEGETFORE:=2481,SCI_STYLEGETBACK:=2482,SCI_STYLEGETBOLD:=2483,SCI_STYLEGETITALIC:=2484
,SCI_STYLEGETSIZE:=2485,SCI_STYLEGETFONT:=2486,SCI_STYLEGETEOLFILLED:=2487,SCI_STYLEGETUNDERLINE:=2488,SCI_STYLEGETCASE:=2489
,SCI_STYLEGETCHARACTERSET:=2490,SCI_STYLEGETVISIBLE:=2491,SCI_STYLEGETCHANGEABLE:=2492,SCI_STYLEGETHOTSPOT:=2493,SCI_STYLERESETDEFAULT:=2058
,SCI_SETCARETSTYLE:=2512
,SCI_STYLESETUNDERLINE:=2059,SCI_STYLESETCASE:=2060,SCI_STYLESETCHARACTERSET:=2066,SCI_STYLESETHOTSPOT:=2409,SCI_SETSELFORE:=2067
,SCI_SETSELBACK:=2068,SCI_GETSELALPHA:=2477,SCI_SETSELALPHA:=2478,SCI_SETCARETFORE:=2069,SCI_ASSIGNCMDKEY:=2070,SCI_CLEARCMDKEY:=2071
,SCI_CLEARALLCMDKEYS:=2072,SCI_SETSTYLINGEX:=2073,SCI_STYLESETVISIBLE:=2074,SCI_GETCARETPERIOD:=2075,SCI_SETCARETPERIOD:=2076
,SCI_SETWORDCHARS:=2077,SCI_BEGINUNDOACTION:=2078,SCI_ENDUNDOACTION:=2079,SCI_INDICSETSTYLE:=2080,SCI_INDICGETSTYLE:=2081
,SCI_INDICSETFORE:=2082,SCI_INDICGETFORE:=2083,SCI_SETWHITESPACEFORE:=2084,SCI_SETWHITESPACEBACK:=2085,SCI_SETSTYLEBITS:=2090
,SCI_GETSTYLEBITS:=2091,SCI_SETLINESTATE:=2092,SCI_GETLINESTATE:=2093,SCI_GETMAXLINESTATE:=2094,SCI_GETCARETLINEVISIBLE:=2095
,SCI_SETCARETLINEVISIBLE:=2096,SCI_GETCARETLINEBACK:=2097,SCI_SETCARETLINEBACK:=2098,SCI_STYLESETCHANGEABLE:=2099,SCI_AUTOCSHOW:=2100
,SCI_AUTOCCANCEL:=2101,SCI_AUTOCACTIVE:=2102,SCI_AUTOCPOSSTART:=2103,SCI_AUTOCCOMPLETE:=2104,SCI_AUTOCSTOPS:=2105
,SCI_AUTOCSETSEPARATOR:=2106,SCI_AUTOCGETSEPARATOR:=2107,SCI_AUTOCSELECT:=2108,SCI_AUTOCSETCANCELATSTART:=2110
,SCI_AUTOCGETCANCELATSTART:=2111,SCI_AUTOCSETFILLUPS:=2112,SCI_AUTOCSETCHOOSESINGLE:=2113,SCI_AUTOCGETCHOOSESINGLE:=2114
,SCI_AUTOCSETIGNORECASE:=2115,SCI_AUTOCGETIGNORECASE:=2116,SCI_USERLISTSHOW:=2117,SCI_AUTOCSETAUTOHIDE:=2118,SCI_AUTOCGETAUTOHIDE:=2119
,SCI_AUTOCSETDROPRESTOFWORD:=2270,SCI_AUTOCGETDROPRESTOFWORD:=2271,SCI_REGISTERIMAGE:=2405,SCI_CLEARREGISTEREDIMAGES:=2408
,SCI_AUTOCGETTYPESEPARATOR:=2285,SCI_AUTOCSETTYPESEPARATOR:=2286,SCI_AUTOCSETMAXWIDTH:=2208,SCI_AUTOCGETMAXWIDTH:=2209
,SCI_AUTOCSETMAXHEIGHT:=2210,SCI_AUTOCGETMAXHEIGHT:=2211,SCI_SETINDENT:=2122,SCI_GETINDENT:=2123,SCI_SETUSETABS:=2124,SCI_GETUSETABS:=2125
,SCI_SETLINEINDENTATION:=2126,SCI_GETLINEINDENTATION:=2127,SCI_GETLINEINDENTPOSITION:=2128,SCI_GETCOLUMN:=2129,SCI_SETHSCROLLBAR:=2130
,SCI_GETHSCROLLBAR:=2131,SCI_SETINDENTATIONGUIDES:=2132,SCI_GETINDENTATIONGUIDES:=2133,SCI_SETHIGHLIGHTGUIDE:=2134
,SCI_GETHIGHLIGHTGUIDE:=2135,SCI_GETLINEENDPOSITION:=2136,SCI_GETCODEPAGE:=2137,SCI_GETCARETFORE:=2138,SCI_GETUSEPALETTE:=2139
,SCI_GETREADONLY:=2140,SCI_SETCURRENTPOS:=2141,SCI_SETSELECTIONSTART:=2142,SCI_GETSELECTIONSTART:=2143,SCI_SETSELECTIONEND:=2144
,SCI_GETSELECTIONEND:=2145,SCI_SETPRINTMAGNIFICATION:=2146,SCI_GETPRINTMAGNIFICATION:=2147,SCI_SETPRINTCOLORMODE:=2148
,SCI_GETPRINTCOLORMODE:=2149,SCI_FINDTEXT:=2150,SCI_FORMATRANGE:=2151,SCI_GETFIRSTVISIBLELINE:=2152,SCI_GETLINE:=2153
,SCI_GETLINECOUNT:=2154,SCI_SETMARGINLEFT:=2155,SCI_GETMARGINLEFT:=2156,SCI_SETMARGINRIGHT:=2157,SCI_GETMARGINRIGHT:=2158
,SCI_GETMODIFY:=2159,SCI_SETSEL:=2160,SCI_GETSELTEXT:=2161,SCI_GETTEXTRANGE:=2162,SCI_HIDESELECTION:=2163,SCI_POINTXFROMPOSITION:=2164
,SCI_POINTYFROMPOSITION:=2165,SCI_LINEFROMPOSITION:=2166,SCI_POSITIONFROMLINE:=2167,SCI_LINESCROLL:=2168,SCI_SCROLLCARET:=2169
,SCI_SCROLLRANGE:=2569
,SCI_REPLACESEL:=2170,SCI_SETREADONLY:=2171,SCI_NULL:=2172,SCI_CANPASTE:=2173,SCI_CANUNDO:=2174,SCI_EMPTYUNDOBUFFER:=2175,SCI_UNDO:=2176
,SCI_CUT:=2177,SCI_COPY:=2178,SCI_PASTE:=2179,SCI_CLEAR:=2180,SCI_SETTEXT:=2181,SCI_GETTEXT:=2182,SCI_GETTEXTLENGTH:=2183
,SCI_GETDIRECTFUNCTION:=2184,SCI_GETDIRECTPOINTER:=2185,SCI_SETOVERTYPE:=2186,SCI_GETOVERTYPE:=2187,SCI_SETCARETWIDTH:=2188
,SCI_GETCARETWIDTH:=2189,SCI_SETTARGETSTART:=2190,SCI_GETTARGETSTART:=2191,SCI_SETTARGETEND:=2192,SCI_GETTARGETEND:=2193
,SCI_REPLACETARGET:=2194,SCI_REPLACETARGETRE:=2195,SCI_SEARCHINTARGET:=2197,SCI_SETSEARCHFLAGS:=2198,SCI_GETSEARCHFLAGS:=2199
,SCI_CALLTIPSHOW:=2200,SCI_CALLTIPCANCEL:=2201,SCI_CALLTIPACTIVE:=2202,SCI_CALLTIPPOSSTART:=2203,SCI_CALLTIPSETHLT:=2204
,SCI_CALLTIPSETBACK:=2205,SCI_CALLTIPSETFORE:=2206,SCI_CALLTIPSETFOREHLT:=2207,SCI_CALLTIPUSESTYLE:=2212,SCI_VISIBLEFROMDOCLINE:=2220
,SCI_DOCLINEFROMVISIBLE:=2221,SCI_WRAPCOUNT:=2235,SCI_SETFOLDLEVEL:=2222,SCI_GETFOLDLEVEL:=2223,SCI_GETLASTCHILD:=2224
,SCI_GETFOLDPARENT:=2225,SCI_SHOWLINES:=2226,SCI_HIDELINES:=2227,SCI_GETLINEVISIBLE:=2228,SCI_SETFOLDEXPANDED:=2229
,SCI_GETFOLDEXPANDED:=2230,SCI_TOGGLEFOLD:=2231,SCI_ENSUREVISIBLE:=2232,SCI_SETFOLDFLAGS:=2233,SCI_ENSUREVISIBLEENFORCEPOLICY:=2234
,SCI_SETTABINDENTS:=2260,SCI_GETTABINDENTS:=2261,SCI_SETBACKSPACEUNINDENTS:=2262,SCI_GETBACKSPACEUNINDENTS:=2263,SCI_SETMOUSEDWELLTIME:=2264
,SCI_GETMOUSEDWELLTIME:=2265,SCI_WORDSTARTPOSITION:=2266,SCI_WORDENDPOSITION:=2267,SCI_SETWRAPMODE:=2268,SCI_GETWRAPMODE:=2269
,SCI_SETWRAPVISUALFLAGS:=2460,SCI_GETWRAPVISUALFLAGS:=2461,SCI_SETWRAPVISUALFLAGSLOCATION:=2462,SCI_GETWRAPVISUALFLAGSLOCATION:=2463
,SCI_SETWRAPSTARTINDENT:=2464,SCI_GETWRAPSTARTINDENT:=2465,SCI_SETLAYOUTCACHE:=2272,SCI_GETLAYOUTCACHE:=2273,SCI_SETSCROLLWIDTH:=2274
,SCI_GETSCROLLWIDTH:=2275,SCI_TEXTWIDTH:=2276,SCI_SETENDATLASTLINE:=2277,SCI_GETENDATLASTLINE:=2278,SCI_TEXTHEIGHT:=2279
,SCI_SETVSCROLLBAR:=2280,SCI_GETVSCROLLBAR:=2281,SCI_APPENDTEXT:=2282,SCI_GETTWOPHASEDRAW:=2283,SCI_SETTWOPHASEDRAW:=2284
,SCI_TARGETFROMSELECTION:=2287,SCI_LINESJOIN:=2288,SCI_LINESSPLIT:=2289,SCI_SETFOLDMARGINCOLOR:=2290,SCI_SETFOLDMARGINHICOLOR:=2291
,SCI_ZOOMIN:=2333,SCI_ZOOMOUT:=2334,SCI_MOVECARETINSIDEVIEW:=2401,SCI_LINELENGTH:=2350,SCI_BRACEHIGHLIGHT:=2351,SCI_BRACEBADLIGHT:=2352
,SCI_BRACEMATCH:=2353,SCI_GETVIEWEOL:=2355,SCI_SETVIEWEOL:=2356,SCI_GETDOCPOINTER:=2357,SCI_SETDOCPOINTER:=2358,SCI_SETMODEVENTMASK:=2359
,SCI_GETEDGECOLUMN:=2360,SCI_SETEDGECOLUMN:=2361,SCI_GETEDGEMODE:=2362,SCI_SETEDGEMODE:=2363,SCI_GETEDGECOLOR:=2364,SCI_SETEDGECOLOR:=2365
,SCI_SEARCHANCHOR:=2366,SCI_SEARCHNEXT:=2367,SCI_SEARCHPREV:=2368,SCI_LINESONSCREEN:=2370,SCI_USEPOPUP:=2371,SCI_SELECTIONISRECTANGLE:=2372
,SCI_SETZOOM:=2373,SCI_GETZOOM:=2374,SCI_CREATEDOCUMENT:=2375,SCI_ADDREFDOCUMENT:=2376,SCI_RELEASEDOCUMENT:=2377,SCI_GETMODEVENTMASK:=2378
,SCI_SETFOCUS:=2380,SCI_GETFOCUS:=2381,SCI_SETSTATUS:=2382,SCI_GETSTATUS:=2383,SCI_SETMOUSEDOWNCAPTURES:=2384,SCI_GETMOUSEDOWNCAPTURES:=2385
,SCI_SETCURSOR:=2386,SCI_GETCURSOR:=2387,SCI_SETCONTROLCHARSYMBOL:=2388,SCI_GETCONTROLCHARSYMBOL:=2389,SCI_SETVISIBLEPOLICY:=2394
,SCI_SETXOFFSET:=2397,SCI_GETXOFFSET:=2398,SCI_CHOOSECARETX:=2399,SCI_GRABFOCUS:=2400,SCI_SETXCARETPOLICY:=2402,SCI_SETYCARETPOLICY:=2403
,SCI_SETPRINTWRAPMODE:=2406,SCI_GETPRINTWRAPMODE:=2407,SCI_SETHOTSPOTACTIVEFORE:=2410,SCI_SETHOTSPOTACTIVEBACK:=2411
,SCI_SETHOTSPOTACTIVEUNDERLINE:=2412,SCI_SETHOTSPOTSINGLELINE:=2421,SCI_POSITIONBEFORE:=2417,SCI_POSITIONAFTER:=2418
,SCI_COPYRANGE:=2419,SCI_COPYTEXT:=2420,SCI_SETSELECTIONMODE:=2422,SCI_GETSELECTIONMODE:=2423,SCI_GETLINESELSTARTPOSITION:=2424
,SCI_GETLINESELENDPOSITION:=2425,SCI_SETWHITESPACECHARS:=2443,SCI_SETCHARSDEFAULT:=2444,SCI_AUTOCGETCURRENT:=2445,SCI_ALLOCATE:=2446
,SCI_TARGETASUTF8:=2447,SCI_SETLENGTHFORENCODE:=2448,SCI_ENCODEDFROMUTF8:=2449,SCI_FINDCOLUMN:=2456,SCI_GETCARETSTICKY:=2457
,SCI_SETCARETSTICKY:=2458,SCI_TOGGLECARETSTICKY:=2459,SCI_SETPASTECONVERTENDINGS:=2467,SCI_GETPASTECONVERTENDINGS:=2468
,SCI_SETCARETLINEBACKALPHA:=2470,SCI_GETCARETLINEBACKALPHA:=2471,SCI_STARTRECORD:=3001,SCI_STOPRECORD:=3002,SCI_SETLEXER:=4001
,SCI_GETLEXER:=4002,SCI_COLORISE:=4003,SCI_SETPROPERTY:=4004,SCI_SETKEYWORDS:=4005,SCI_SETLEXERLANGUAGE:=4006,SCI_LOADLEXERLIBRARY:=4007
,SCI_GETPROPERTY:=4008,SCI_GETPROPERTYEXPANDED:=4009,SCI_GETPROPERTYINT:=4010,SCI_GETSTYLEBITSNEEDED:=4011,SCI_AUTOCSETCASEINSENSITIVEBEHAVIOUR:=2634,SCI_AUTOCGETCASEINSENSITIVEBEHAVIOUR:=2635
}
{
global MARKER_MAX:=31,STYLE_DEFAULT:=32,STYLE_LINENUMBER:=33,STYLE_BRACELIGHT:=34,STYLE_BRACEBAD:=35,STYLE_CONTROLCHAR:=36
,STYLE_INDENTGUIDE:=37,STYLE_CALLTIP:=38,STYLE_LASTPREDEFINED:=39,STYLE_MAX:=127,INDIC_MAX:=7,INDIC_PLAIN:=0,INDIC_SQUIGGLE:=1,INDIC_TT:=2
,INDIC_DIAGONAL:=3,INDIC_STRIKE:=4,INDIC_HIDDEN:=5,INDIC_BOX:=6,INDIC_ROUNDBOX:=7,INDIC0_MASK:=0x20,INDIC1_MASK:=0x40,INDIC2_MASK:=0x80
,INDICS_MASK:=0xE0,SCI_START:=2000,SCI_OPTIONAL_START:=3000,SCI_LEXER_START:=4000,SCWS_INVISIBLE:=0,SCWS_VISIBLEALWAYS:=1
,SCWS_VISIBLEAFTERINDENT:=2,SC_EOL_CRLF:=0,SC_EOL_CR:=1,SC_EOL_LF:=2,SC_CP_UTF8:=65001,SC_CP_DBCS:=1,SC_MARK_CIRCLE:=0,SC_MARK_ROUNDRECT:=1
,SC_MARK_ARROW:=2,SC_MARK_SMALLRECT:=3,SC_MARK_SHORTARROW:=4,SC_MARK_EMPTY:=5,SC_MARK_ARROWDOWN:=6,SC_MARK_MINUS:=7,SC_MARK_PLUS:=8
,SC_MARK_VLINE:=9,SC_MARK_LCORNER:=10,SC_MARK_TCORNER:=11,SC_MARK_BOXPLUS:=12,SC_MARK_BOXPLUSCONNECTED:=13,SC_MARK_BOXMINUS:=14
,SC_MARK_BOXMINUSCONNECTED:=15,SC_MARK_LCORNERCURVE:=16,SC_MARK_TCORNERCURVE:=17,SC_MARK_CIRCLEPLUS:=18,SC_MARK_CIRCLEPLUSCONNECTED:=19
,SC_MARK_CIRCLEMINUS:=20,SC_MARK_CIRCLEMINUSCONNECTED:=21,SC_MARK_BACKGROUND:=22,SC_MARK_DOTDOTDOT:=23,SC_MARK_ARROWS:=24
,SC_MARK_PIXMAP:=25,SC_MARK_FULLRECT:=26,SC_MARK_CHARACTER:=10000,SC_MARKNUM_FOLDEREND:=25,SC_MARKNUM_FOLDEROPENMID:=26
,SC_MARKNUM_FOLDERMIDTAIL:=27,SC_MARKNUM_FOLDERTAIL:=28,SC_MARKNUM_FOLDERSUB:=29,SC_MARKNUM_FOLDER:=30,SC_MARKNUM_FOLDEROPEN:=31
,SC_MASK_FOLDERS:=0xFE000000,SC_MARGIN_SYMBOL:=0,SC_MARGIN_NUMBER:=1
}
{
global SC_CHARSET_ANSI:=0,SC_CHARSET_DEFAULT:=1,SC_CHARSET_BALTIC:=186
,SC_CHARSET_CHINESEBIG5:=136,SC_CHARSET_EASTEUROPE:=238,SC_CHARSET_GB2312:=134,SC_CHARSET_GREEK:=161,SC_CHARSET_HANGUL:=129
,SC_CHARSET_MAC:=77,SC_CHARSET_OEM:=255,SC_CHARSET_RUSSIAN:=204,SC_CHARSET_CYRILLIC:=1251,SC_CHARSET_SHIFTJIS:=128
,SC_CHARSET_SYMBOL:=2,SC_CHARSET_TURKISH:=162,SC_CHARSET_JOHAB:=130,SC_CHARSET_HEBREW:=177,SC_CHARSET_ARABIC:=178,SC_CHARSET_VIETNAMESE:=163
,SC_CHARSET_THAI:=222,SC_CHARSET_8859_15:=1000, SC_CASE_MIXED:=0,SC_CASE_UPPER:=1,SC_CASE_LOWER:=2,SC_PRINT_NORMAL:=0,SC_PRINT_INVERTLIGHT:=1
,SC_PRINT_BLACKONWHITE:=2,SC_PRINT_COLORONWHITE:=3,SC_PRINT_COLORONWHITEDEFAULTBG:=4
}
{
global SCFIND_WHOLEWORD:=2,SCFIND_MATCHCASE:=4
,SCFIND_WORDSTART:=0x00100000,SCFIND_REGEXP:=0x00200000,SCFIND_POSIX:=0x00400000
}
{
global SC_FOLDLEVELBASE:=0x400,SC_FOLDLEVELWHITEFLAG:=0x1000
,SC_FOLDLEVELHEADERFLAG:=0x2000,SC_FOLDLEVELBOXHEADERFLAG:=0x4000,SC_FOLDLEVELBOXFOOTERFLAG:=0x8000,SC_FOLDLEVELCONTRACTED:=0______
,SC_FOLDLEVELUNINDENT:=0______,SC_FOLDLEVELNUMBERMASK:=0x0FFF,SC_FOLDFLAG_LINEBEFORE_EXPANDED:=0x0002,SC_FOLDFLAG_LINEBEFORE_CONTRACTED:=0x0004
,SC_FOLDFLAG_LINEAFTER_EXPANDED:=0x0008,SC_FOLDFLAG_LINEAFTER_CONTRACTED:=0x0010,SC_FOLDFLAG_LEVELNUMBERS:=0x0040,SC_FOLDFLAG_BOX:=0x0001
}
{
global SCMOD_NORM:=0, SCMOD_SHIFT:=1,SCMOD_CTRL:=2,SCMOD_ALT:=4, SCK_DOWN:=300,SCK_UP:=301,SCK_LEFT:=302,SCK_RIGHT:=303,SCK_HOME:=304,SCK_END:=305
,SCK_PRIOR:=306,SCK_NEXT:=307,SCK_DELETE:=308,SCK_INSERT:=309,SCK_ESCAPE:=7,SCK_BACK:=8,SCK_TAB:=9,SCK_RETURN:=13,SCK_ADD:=310,SCK_SUBTRACT:=311
,SCK_DIVIDE:=312
}
{
global SCLEX_CONTAINER:=0,SCLEX_NULL:=1,SCLEX_PYTHON:=2,SCLEX_CPP:=3,SCLEX_HTML:=4,SCLEX_XML:=5,SCLEX_PERL:=6,SCLEX_SQL:=7,SCLEX_VB:=8
,SCLEX_PROPERTIES:=9,SCLEX_ERRORLIST:=10,SCLEX_MAKEFILE:=11,SCLEX_BATCH:=12,SCLEX_XCODE:=13,SCLEX_LATEX:=14,SCLEX_LUA:=15,SCLEX_DIFF:=16
,SCLEX_CONF:=17,SCLEX_PASCAL:=18,SCLEX_AVE:=19,SCLEX_ADA:=20,SCLEX_LISP:=21,SCLEX_RUBY:=22,SCLEX_EIFFEL:=23,SCLEX_EIFFELKW:=24
,SCLEX_TCL:=25,SCLEX_NNCRONTAB:=26,SCLEX_BULLANT:=27,SCLEX_VBSCRIPT:=28,SCLEX_BAAN:=31,SCLEX_MATLAB:=32,SCLEX_SCRIPTOL:=33
,SCLEX_ASM:=34,SCLEX_CPPNOCASE:=35,SCLEX_FORTRAN:=36,SCLEX_F77:=37,SCLEX_CSS:=38,SCLEX_POV:=39,SCLEX_LOUT:=40,SCLEX_ESCRIPT:=41
,SCLEX_PS:=42,SCLEX_NSIS:=43,SCLEX_MMIXAL:=44,SCLEX_CLW:=45,SCLEX_CLWNOCASE:=46,SCLEX_LOT:=47,SCLEX_YAML:=48,SCLEX_TEX:=49
,SCLEX_METAPOST:=50,SCLEX_POWERBASIC:=51,SCLEX_FORTH:=52,SCLEX_ERLANG:=53,SCLEX_OCTAVE:=54,SCLEX_MSSQL:=55,SCLEX_VERILOG:=56,SCLEX_KIX:=57
,SCLEX_GUI4CLI:=58,SCLEX_SPECMAN:=59,SCLEX_AU3:=60,SCLEX_APDL:=61,SCLEX_BASH:=62,SCLEX_ASN1:=63,SCLEX_VHDL:=64,SCLEX_CAML:=65
,SCLEX_BLITZBASIC:=66,SCLEX_PUREBASIC:=67,SCLEX_HASKELL:=68,SCLEX_PHPSCRIPT:=69,SCLEX_TADS3:=70,SCLEX_REBOL:=71,SCLEX_SMALLTALK:=72
,SCLEX_FLAGSHIP:=73,SCLEX_CSOUND:=74,SCLEX_FREEBASIC:=75,SCLEX_INNOSETUP:=76,SCLEX_OPAL:=77,SCLEX_SPICE:=78,SCLEX_D:=79,SCLEX_CMAKE:=80
,SCLEX_GAP:=81,SCLEX_PLM:=82,SCLEX_PROGRESS:=83,SCLEX_ABAQUS:=84,SCLEX_ASYMPTOTE:=85,SCLEX_R:=86,SCLEX_MAGIK:=87,SCLEX_POWERSHELL:=88
,SCLEX_MYSQL:=89,SCLEX_PO:=90,SCLEX_TAL:=91,SCLEX_COBOL:=92,SCLEX_TACL:=93,SCLEX_SORCUS:=94,SCLEX_POWERPRO:=95,SCLEX_NIMROD:=96,SCLEX_SML:=97
,SCLEX_MARKDOWN:=98,SCLEX_TXT2TAGS:=99,SCLEX_A68K:=100,SCLEX_MODULA:=101,SCLEX_COFFEESCRIPT:=102,SCLEX_TCMD:=103,SCLEX_AVS:=104,SCLEX_ECL:=105
,SCLEX_OSCRIPT:=106,SCLEX_VISUALPROLOG:=107,SCLEX_LITERATEHASKELL:=108,SCLEX_AHKL:=109
,SCE_AHKL_NEUTRAL:=0,SCE_AHKL_IDENTIFIER:=1,SCE_AHKL_COMMENTDOC:=2,SCE_AHKL_COMMENTLINE:=3,SCE_AHKL_COMMENTBLOCK:=4,SCE_AHKL_COMMENTKEYWORD:=5
,SCE_AHKL_STRING:=6,SCE_AHKL_STRINGOPTS:=7,SCE_AHKL_STRINGBLOCK:=8,SCE_AHKL_STRINGCOMMENT:=9,SCE_AHKL_LABEL:=10,SCE_AHKL_HOTKEY:=11
,SCE_AHKL_HOTSTRING:=12,SCE_AHKL_HOTSTRINGOPT:=13,SCE_AHKL_HEXNUMBER:=14,SCE_AHKL_DECNUMBER:=15,SCE_AHKL_VAR:=16,SCE_AHKL_VARREF:=17
,SCE_AHKL_OBJECT:=18,SCE_AHKL_USERFUNCTION:=19,SCE_AHKL_DIRECTIVE:=20,SCE_AHKL_COMMAND:=21,SCE_AHKL_PARAM:=22,SCE_AHKL_CONTROLFLOW:=23
,SCE_AHKL_BUILTINFUNCTION:=24,SCE_AHKL_BUILTINVAR:=25,SCE_AHKL_KEY:=26,SCE_AHKL_USERDEFINED1:=27,SCE_AHKL_USERDEFINED2:=28,SCE_AHKL_ESCAPESEQ:=30
,SCE_AHKL_ERROR:=31,AHKL_LIST_DIRECTIVES:=0,AHKL_LIST_COMMANDS:=1,AHKL_LIST_PARAMETERS:=2,AHKL_LIST_CONTROLFLOW:=3,AHKL_LIST_FUNCTIONS:=4
,AHKL_LIST_VARIABLES:=5,AHKL_LIST_KEYS:=6,AHKL_LIST_USERDEFINED1:=7,AHKL_LIST_USERDEFINED2:=8,SCLEX_AUTOMATIC=1000
}
{
global SCEN_CHANGE:=768,SCEN_SETFOCUS:=512,SCEN_KILLFOCUS:=256, SCN_STYLENEEDED:=2000,SCN_CHARADDED:=2001
,SCN_SAVEPOINTREACHED:=2002,SCN_SAVEPOINTLEFT:=2003,SCN_MODIFYATTEMPTRO:=2004,SCN_KEY:=2005,SCN_DOUBLECLICK:=2006,SCN_UPDATEUI:=2007
,SCN_MODIFIED:=2008,SCN_MACRORECORD:=2009,SCN_MARGINCLICK:=2010,SCN_NEEDSHOWN:=2011,SCN_PAINTED:=2013,SCN_USERLISTSELECTION:=2014
,SCN_URIDROPPED:=2015,SCN_DWELLSTART:=2016,SCN_DWELLEND:=2017,SCN_ZOOM:=2018,SCN_HOTSPOTCLICK:=2019,SCN_HOTSPOTDOUBLECLICK:=2020
,SCN_CALLTIPCLICK:=2021,SCN_AUTOCSELECTION:=2022
}
{
global SCI_LINEDOWN:=2300,SCI_LINEDOWNEXTEND:=2301,SCI_LINEDOWNRECTEXTEND:=2426
,SCI_LINESCROLLDOWN:=2342,SCI_LINEUP:=2302,SCI_LINEUPEXTEND:=2303,SCI_LINEUPRECTEXTEND:=2427,SCI_LINESCROLLUP:=2343,SCI_PARADOWN:=2413
,SCI_PARADOWNEXTEND:=2414,SCI_PARAUP:=2415,SCI_PARAUPEXTEND:=2416,SCI_CHARLEFT:=2304,SCI_CHARLEFTEXTEND:=2305,SCI_CHARLEFTRECTEXTEND:=2428
,SCI_CHARRIGHT:=2306,SCI_CHARRIGHTEXTEND:=2307,SCI_CHARRIGHTRECTEXTEND:=2429,SCI_WORDLEFT:=2308,SCI_WORDLEFTEXTEND:=2309,SCI_WORDRIGHT:=2310
,SCI_WORDRIGHTEXTEND:=2311,SCI_WORDLEFTEND:=2439,SCI_WORDLEFTENDEXTEND:=2440,SCI_WORDRIGHTEND:=2441,SCI_WORDRIGHTENDEXTEND:=2442
,SCI_WORDPARTLEFT:=2390,SCI_WORDPARTLEFTEXTEND:=2391,SCI_WORDPARTRIGHT:=2392,SCI_WORDPARTRIGHTEXTEND:=2393,SCI_HOME:=2312
,SCI_HOMEEXTEND:=2313,SCI_HOMERECTEXTEND:=2430,SCI_HOMEDISPLAY:=2345,SCI_HOMEDISPLAYEXTEND:=2346,SCI_HOMEWRAP:=2349
,SCI_HOMEWRAPEXTEND:=2450,SCI_VCHOME:=2331,SCI_VCHOMEEXTEND:=2332,SCI_VCHOMERECTEXTEND:=2431,SCI_VCHOMEWRAP:=2453,SCI_VCHOMEWRAPEXTEND:=2454
,SCI_LINEEND:=2314,SCI_LINEENDEXTEND:=2315,SCI_LINEENDRECTEXTEND:=2432,SCI_LINEENDDISPLAY:=2347,SCI_LINEENDDISPLAYEXTEND:=2348
,SCI_LINEENDWRAP:=2451,SCI_LINEENDWRAPEXTEND:=2452,SCI_DOCUMENTSTART:=2316,SCI_DOCUMENTSTARTEXTEND:=2317,SCI_DOCUMENTEND:=2318
,SCI_DOCUMENTENDEXTEND:=2319,SCI_PAGEUP:=2320,SCI_PAGEUPEXTEND:=2321,SCI_PAGEUPRECTEXTEND:=2433,SCI_PAGEDOWN:=2322,SCI_PAGEDOWNEXTEND:=2323
,SCI_PAGEDOWNRECTEXTEND:=2434,SCI_STUTTEREDPAGEUP:=2435,SCI_STUTTEREDPAGEUPEXTEND:=2436,SCI_STUTTEREDPAGEDOWN:=2437
,SCI_STUTTEREDPAGEDOWNEXTEND:=2438,SCI_DELETEBACK:=2326,SCI_DELETEBACKNOTLINE:=2344,SCI_DELWORDLEFT:=2335,SCI_DELWORDRIGHT:=2336
,SCI_DELLINELEFT:=2395,SCI_DELLINERIGHT:=2396,SCI_LINEDELETE:=2338,SCI_LINECUT:=2337,SCI_LINECOPY:=2455,SCI_LINETRANSPOSE:=2339
,SCI_LINEDUPLICATE:=2404,SCI_LOWERCASE:=2340,SCI_UPPERCASE:=2341,SCI_CANCEL:=2325,SCI_EDITTOGGLEOVERTYPE:=2324,SCI_NEWLINE:=2329
,SCI_FORMFEED:=2330,SCI_TAB:=2327,SCI_BACKTAB:=2328,SCI_SELECTIONDUPLICATE:=2469,SCI_SCROLLTOSTART:=2628,SCI_SCROLLTOEND:=2629
,SCI_DELWORDRIGHTEND:=2518,SCI_VERTICALCENTRECARET:=2619,SCI_MOVESELECTEDLINESUP:=2620,SCI_MOVESELECTEDLINESDOWN:=2621
,SC_TIME_FOREVER:=10000000,SC_WRAP_NONE:=0,SC_WRAP_WORD:=1,SC_WRAP_CHAR:=2,SC_WRAPVISUALFLAG_NONE:=0x0000,SC_WRAPVISUALFLAG_END:=0x0001
,SC_WRAPVISUALFLAG_START:=0x0002,SC_WRAPVISUALFLAG_MARGIN:=0x0004, SC_WRAPVISUALFLAGLOC_DEFAULT:=0x0000,SC_WRAPVISUALFLAGLOC_END_BY_TEXT:=0x0001
,SC_WRAPVISUALFLAGLOC_START_BY_TEXT:=0x0002,SC_CACHE_NONE:=0,SC_CACHE_CARET:=1,SC_CACHE_PAGE:=2,SC_CACHE_DOCUMENT:=3,EDGE_NONE:=0,EDGE_LINE:=1
,EDGE_BACKGROUND:=2,SC_CURSORNORMAL:=-1,SC_CURSORWAIT:=4,VISIBLE_SLOP:=0x01,VISIBLE_STRICT:=0x04,CARET_SLOP:=0x01,CARET_STRICT:=0x04
,CARET_JUMPS:=0x10,CARET_EVEN:=0x08,SC_SEL_STREAM:=0,SC_SEL_RECTANGLE:=1,SC_SEL_LINES:=2,SC_ALPHA_TRANSPARENT:=0,SC_ALPHA_OPAQUE:=255
,SC_ALPHA_NOALPHA:=256,KEYWORDSET_MAX:=8,SC_MOD_INSERTTEXT:=0x1,SC_MOD_DELETETEXT:=0x2,SC_MOD_CHANGESTYLE:=0x4,SC_MOD_CHANGEFOLD:=0x8
,SC_PERFORMED_USER:=0x10,SC_PERFORMED_UNDO:=0x20,SC_PERFORMED_REDO:=0x40,SC_MULTISTEPUNDOREDO:=0x80,SC_LASTSTEPINUNDOREDO:=0x100
,SC_MOD_CHANGEMARKER:=0x200,SC_MOD_BEFOREINSERT:=0x400,SC_MOD_BEFOREDELETE:=0x800,SC_MULTILINEUNDOREDO:=0x1000,SC_MODEVENTMASKALL:=0x1FFF
,SC_WEIGHT_NORMAL:=400, SC_WEIGHT_SEMIBOLD:=600, SC_WEIGHT_BOLD:=700
}
}
SCI_GETTEXT(ByRef sci){
if(len:=sci.GetLength())=0
return ""
sci.GetText(len+4, t:="")
return t
}
SCI_SETTEXT(ByRef sci, txt){
if (txt="")
sci.clearall()
else
sci.settext(unused, t:=txt)
}
Class _RemoteBuf {
pid:=0,RemoteBuf:=0,size:=0,hProc:=0,LocalBuf:=0,Encoding:="UTF-8"
__New(hwnd,size=0){
this.Open(size,hwnd)
}
__Delete(){
static MEM_RELEASE:=0x8000
If !this.hProc
Return
If this.RemoteBuf
If !DllCall("VirtualFreeEx","PTR",this.hProc,"PTR",this.RemoteBuf,"PTR",0,"uint",MEM_RELEASE)
return DllCall("MessageBox","PTR",0,"Str","Unable to free memory (" A_LastError ")","Str","OpenProcess Failed","UInt",0)
DllCall( "CloseHandle", "PTR", this.hProc)
}
Open(size="",hwnd=0){
static MEM_COMMIT:=0x1000,PAGE_READWRITE:=4,MEM_RELEASE:=0x8000
If (!this.hProc||hwnd) {
If this.RemoteBuf
DllCall("VirtualFreeEx","PTR",this.hProc,"PTR",this.RemoteBuf,"PTR",0,"uint",MEM_RELEASE)
If this.hProc
DllCall( "CloseHandle", "PTR", this.hProc)
DetectHiddenWindows % DetectHidden:=A_DetectHiddenWindows?"On":"On"
WinGet, pid, PID,% "ahk_id " hwnd
DetectHiddenWindows % DetectHidden
If !this.hProc:=DllCall("OpenProcess","uint",0x38,"int",0,"uint",pid,"Ptr")
return DllCall("MessageBox","PTR",0,"Str","Unable to open process (" A_LastError ")","Str","OpenProcess Failed","UInt",0)
this.size:=0
} else if !this.hProc
Return DllCall("MessageBox","PTR",0,"Str","No open process and no hWnd was given.","Str","OpenProcess Failed","UInt",0)
If (size<>""&&size>this.size){
this.size:=size
If this.RemoteBuf
DllCall("VirtualFreeEx","PTR",this.hProc,"PTR",this.RemoteBuf,"PTR",0,"uint",MEM_RELEASE)
If !this.RemoteBuf := DllCall("VirtualAllocEx","PTR",this.hProc,"PTR",0,"PTR",size,"uint",MEM_COMMIT,"uint",PAGE_READWRITE)
return DllCall("MessageBox","PTR",0,"Str","Unable to allocate memory (" A_LastError ")","Str","OpenProcess Failed","UInt",0),this.hProc:=0
}
Return this.size
}
Read(size=0,offset=0){
If !this.hProc
return DllCall("MessageBox","PTR",0,"Str","Invalid remote buffer handle","Str","Handle is NULL","UInt",0)
If (offset>this.size)
DllCall("MessageBox","PTR",0,"Str","Offset (" offset ") is bigger then size (" this.size ")","Str","Offset bigger than size","UInt",0)
this.SetCapacity("buffer",size?size:this.size)
return DllCall("ReadProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",this.LocalBuf:=this.GetAddress("buffer"),"uint",(size?size:this.size)+1,"uint",0)
}
Write(value,offset=0,CP=""){
If !this.hProc
return DllCall("MessageBox","PTR",0,"Str","Invalid remote buffer handle","Str","Handle is NULL","UInt",0)
If (offset>this.size)
return DllCall("MessageBox","PTR",0,"Str","Offset (" offset ") is larger then size (" this.size ")","Str","Offset bigger than size","UInt",0)
If (value=""){
return DllCall("WriteProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",&value,"uint",4,"uint",0)
} else {
If (this.size<Strlen(value)*(CP="CP0"?1:2))
this.Open(StrLen(value)*(CP="CP0"?1:2))
}
return DllCall("WriteProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",&value,"uint",(StrLen(value)+1)*((CP="CP0"||this.Encoding="CP0")||CP=""?2:4),"uint",0)
}
NumPut(value=0,offset=0,Type="UInt"){
If !this.hProc
return DllCall("MessageBox","PTR",0,"Str","Invalid remote buffer handle","Str","Handle is NULL","UInt",0)
If (offset>this.size)
return DllCall("MessageBox","PTR",0,"Str","Offset (" offset ") is larger then size (" this.size ")","Str","Offset bigger than size","UInt",0)
this.SetCapacity("buffer",this.size),NumPut(value,this.LocalBuf:=this.GetAddress("buffer"),Type)
return DllCall("WriteProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",this.LocalBuf,"uint",A_PtrSize,"uint",0)
}
BinWrite(ByRef data,datasize,offset=0){
If !this.hProc
return DllCall("MessageBox","PTR",0,"Str","Invalid remote buffer handle","Str","Handle is NULL","UInt",0)
If (offset>this.size)
return DllCall("MessageBox","PTR",0,"Str","Offset (" offset ") is larger then size (" this.size ")","Str","Offset bigger than size","UInt",0)
this.SetCapacity("buffer",this.size),DllCall("RtlMoveMemory","PTR",this.LocalBuf:=this.GetAddress("buffer"),"PTR",&data,"PTR",datasize)
return DllCall("WriteProcessMemory","PTR",this.hProc,"PTR",this.RemoteBuf+offset,"PTR",this.LocalBuf,"uint",datasize,"uint",0)
}
}
StrPutVar(string,ByRef var,encoding){
VarSetCapacity(var,StrPut(string,encoding)
*((encoding="utf-16"||encoding="cp1200")?2:1),00)
return StrPut(string,&var,encoding),VarSetCapacity(var,-1)
}
MCode_Bin2Hex(addr, len) {
Static fun
If (fun = "") {
If Not A_IsUnicode
h=
        ( LTrim Join
            8B54240C85D2568B7424087E3A53578B7C24148A07478AC8C0E90480F9090F97C3F6
            DB80E30702D980C330240F881E463C090F97C1F6D980E10702C880C130880E464A75
            CE5F5BC606005EC3
)
Else
h=
        ( LTrim Join
            8B44240C8B4C240485C07E53568B74240C578BF88A168AC2C0E804463C090FB6C076
            066683C037EB046683C03066890180E20F83C10280FA09760C0FB6D26683C2376689
            11EB0A0FB6C26683C03066890183C1024F75BD33D25F6689115EC333C0668901C3
)
VarSetCapacity(fun, n := StrLen(h)//2)
Loop % n
NumPut("0x" . SubStr(h, 2 * A_Index - 1, 2), fun, A_Index - 1, "Char")
}
VarSetCapacity(hex, A_IsUnicode ? 4 * len + 2 : 2 * len + 1)
DllCall(&fun, "Ptr", &hex, "Ptr", addr, "Ptr", len, "cdecl")
VarSetCapacity(hex, -1)
Return hex
}
MultiByteChars(ByRef str){
a:=0
Loop,Parse,str
a+= StrPutVar(A_LoopField, UTF8:="", "UTF-8")-1
return a
}
CharToWordPos(ByRef str, ByRef start, ByRef end="", swap=0){
if(End="")
End:=start
if(start=0 && End=0){
start:=0, End:=0
return
}
if(start>End)
start0:=End, End0:=start, swap:=1
else
start0:=start, End0:=End
_start:=_end:=""
,CharPos:=0
Loop,Parse,str
{
if (CharPos>start0 && CharPos>End0)
break
CharPos+= StrPutVar(A_LoopField, UTF8, "UTF-8")-1
if (CharPos>=start0 && _start="")
_start:=A_Index
if (CharPos>=End0 && _end="")
_End:=A_Index
ind:=A_Index
}
if(!swap)
start:=_start?_start:ind, End:=_end?_end:ind
else
start:=_end?_end:ind, End:=_start?_start:ind
}
WordToCharPos(ByRef str, ByRef start, ByRef end="", swap=0){
if(End="")
End:=start
if(start=0 && End=0){
start:=0, End:=0
return
}
if(start>End)
start0:=End, End0:=start, swap:=1
else
start0:=start, End0:=End
_start:=_end:=""
,_start:=MultiByteChars(SubStr(str, 1, start0)), _End:=_start+MultiByteChars(SubStr(str, start0+1, End0-start0))
if(!swap)
return [start:=_start, End:=_End]
else
return [start:=_End, End:=_start]
}
class RemoteScintilla {
__New(hwnd){
this.hwnd:=hwnd
this.Buf:=new _RemoteBuf(this.hwnd)
}
GetText() {
if(len:=this.GetTextLength())>0{
Buf:=new _RemoteBuf(this.hwnd,len+1)
,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETTEXT,"UPTR",Buf.size,"PTR",Buf.RemoteBuf, "Ptr")
,Buf.Read()
Return StrGet(Buf.LocalBuf,"UTF-8")
}else{
return ""
}
}
SetText(Text){
if(Text="")
return this.ClearAll()
else{
ret:=StrPutVar(Text,str:="", "UTF-8")
,Buf:= new _RemoteBuf(this.hwnd, ret)
,Buf.Write(str,0,"UTF-8")
,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SETTEXT,"PTR",0,"PTR",Buf.RemoteBuf, "Ptr")
return ret
}
}
InsertText(Text, pos=-1){
if(Text="")
return -1
ret:=StrPutVar(Text,str:="", "UTF-8")
,Buf:= new _RemoteBuf(this.hwnd, ret)
,Buf.Write(str,0,"UTF-8")
,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_INSERTTEXT,"PTR",pos,"PTR",Buf.RemoteBuf, "Ptr")
}
_InsertText(Text, pos=-1){
if(Text="")
return -1
WordToCharPos(oldText:=this.GetText(), pos=-1?(pos:=StrLen(oldText)):pos)
,ret:=StrPutVar(Text,str:="", "UTF-8")
,Buf:= new _RemoteBuf(this.hwnd, ret)
,Buf.Write(str,0,"UTF-8")
,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_INSERTTEXT,"PTR",pos,"PTR",Buf.RemoteBuf, "Ptr")
}
AddText(Text){
if(Text="")
return -1
ret:=StrPutVar(Text,str:="", "UTF-8")
,Buf:= new _RemoteBuf(this.hwnd, ret)
,Buf.Write(str,0,"UTF-8")
,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ADDTEXT,"PTR",StrLen(Text),"PTR",Buf.RemoteBuf, "Ptr")
}
DeleteRange(pos, len){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_DELETERANGE,"PTR", pos,"PTR", len, "PTR")
}
_DeleteRange(pos, len){
WordToCharPos(Text:=this.GetText(), s:=pos, e:=pos+len)
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_DELETERANGE,"PTR", s,"PTR", e-s, "PTR")
}
GetSelectionStart(){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETSELECTIONSTART,"PTR",0,"PTR")
}
GetSelectionEnd(){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETSELECTIONEND,"PTR",0,"PTR")
}
GetCurrentPos(){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetCurrentPos,"PTR",0,"PTR")
}
GetAnchor(){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetAnchor,"PTR",0,"PTR")
}
GetSel(ByRef s="", ByRef e=""){
s:=this.GetAnchor()
,e:=this.GetCurrentPos()
return {start:s, End:e}
}
_GetSelectionStart(){
s:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETSELECTIONSTART,"PTR",0,"PTR")
,CharToWordPos(Text:=this.GetText(), s)
return s
}
_GetSelectionEnd(){
e:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GETSELECTIONEND,"PTR",0,"PTR")
,CharToWordPos(Text:=this.GetText(), e)
return e
}
_GetCurrentPos(){
s:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetCurrentPos,"PTR",0,"PTR")
,CharToWordPos(Text:=this.GetText(), s)
return s
}
_GetAnchor(){
e:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetAnchor,"PTR",0,"PTR")
,CharToWordPos(Text:=this.GetText(), e)
return e
}
_GetSel(ByRef s="", ByRef e=""){
s:=this.GetAnchor()
,e:=this.GetCurrentPos()
,CharToWordPos(Text:=this.GetText(), s, e)
return {start:s, End:e}
}
GetSelWords(){
if(len:=this.GetTextLength())>0 {
s0:=s:=this.GetSelectionStart()
,e0:=e:=this.GetSelectionEnd()
,s:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_WORDSTARTPOSITION,"PTR",s, "INT",1 ,"PTR")
,e:=DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_WORDENDPOSITION,"PTR",e,"INT",1,"PTR")
if(s!=s0)
this.SetSelectionStart(s)
if(e!=e0)
this.SetSelectionEnd(e)
return this.GetSelText()
}else{
return ""
}
}
GetSelText(){
if(len:=this.GetTextLength())>0 {
Buf:=new _RemoteBuf(this.hwnd,this.GetTextLength()+4)
,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetSelText,"UPTR",Buf.size,"PTR",Buf.RemoteBuf, "Ptr")
,Buf.Read()
Return StrGet(Buf.LocalBuf,"UTF-8")
}else{
return ""
}
}
StyleGetFont(styleNumber){
Buf:=new _RemoteBuf(this.hwnd,32)
,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_StyleGetFont,"UPTR",styleNumber,"PTR",Buf.RemoteBuf, "Ptr")
,Buf.Read()
Return StrGet(Buf.LocalBuf,"UTF-8")
}
GetLine(line=""){
if(line="" || line=-1)
line:=this.LINEFROMPOSITION()
Buf:=new _RemoteBuf(this.hwnd,this.LineLength(line)+1)
,DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetLine,"PTR",line,"PTR",Buf.RemoteBuf, "Ptr")
,Buf.Read()
Return StrGet(Buf.LocalBuf,"UTF-8")
}
LineLength(line=""){
if(line="" || line=-1)
line:=this.LineFromPosition()
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_LineLength,"PTR",line,"PTR")
}
LineFromPosition(pos=""){
if(pos="")
pos:=this.GetCurrentPos()
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_LINEFROMPOSITION,"PTR",pos,"PTR")
}
SetSelectionStart(s){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSELECTIONSTART,"PTR",s,"PTR")
}
SetSelectionEnd(e){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSELECTIONEND,"PTR",e,"PTR")
}
SetCurrentPos(s){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetCurrentPos,"PTR",s,"PTR")
}
SetAnchor(e){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetAnchor,"PTR",e,"PTR")
}
SetSel(s="", e=""){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSel,"PTR",s,"PTR",e, "PTR")
}
_SetSelectionStart(s){
if Strlen(Text:=this.GetText())=this.GetLength(){
return this.SetSelectionStart(s)
}
WordToCharPos(Text, s)
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSELECTIONSTART,"PTR",s,"PTR")
}
_SetSelectionEnd(e){
if Strlen(Text:=this.GetText())=this.GetLength(){
return this.SetSelectionEnd(e)
}
WordToCharPos(Text, e)
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSELECTIONEND,"PTR",e,"PTR")
}
_SetCurrentPos(s){
if Strlen(Text:=this.GetText())=this.GetLength(){
return this.SetCurrentPos(s)
}
WordToCharPos(Text, s)
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetCurrentPos,"PTR",s,"PTR")
}
_SetAnchor(e){
if Strlen(Text:=this.GetText())=this.GetLength(){
return this.SetAnchor(e)
}
WordToCharPos(Text, e)
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetAnchor,"PTR",e,"PTR")
}
_SetSel(s="", e=""){
if Strlen(Text:=this.GetText())=this.GetLength(){
return this.SetSel(s,e)
}
WordToCharPos(Text, s, e)
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetSel,"PTR",s,"PTR",e, "PTR")
}
SelAll(){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SELECTALL,"PTR")
}
GetLength(){
return this.GetTextLength()
}
GetTextLength(){
Return DllCall("SendMessage","PTR",this.hwnd,"UInt",SCI_GETTEXTLENGTH,"PTR",0,"PTR",0,"PTR")
}
ScrollCaret(){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ScrollCaret,"PTR")
}
ScrollRange(secondary="", primary=""){
this.GetSel(s, e)
if(primary="")
primary:=e
if(secondary="")
secondary:=s
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ScrollRange,"PTR",secondary, "PTR", primary,"PTR")
}
ClearAll(){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_ClearAll,"PTR")
}
SetCodePage(code){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_SetCodePage,"PTR",code,"PTR")
}
GetCodePage(code){
return DllCall("SendMessage","PTR",this.hwnd,"UINT", SCI_GetCodePage,"PTR",0,"PTR")
}
Do(command){
if command is not integer
{
command:=%command%
}
try
ret:= DllCall("SendMessage","PTR",this.hwnd,"UINT", command,"PTR", 0, "PTR")
return ret
}
}
min(params*){
ret:=params[1]
for k,v in params
if (v<ret)
ret:=v
return ret
}
max(params*){
ret:=params[1]
for k,v in params
if (v>ret)
ret:=v
return ret
}
Edit_CanUndo(hEdit)
{
Static EM_CANUNDO:=0xC6
SendMessage EM_CANUNDO,0,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_CharFromPos(hEdit,X,Y,ByRef r_CharPos="",ByRef r_LineIdx="")
{
Static EM_CHARFROMPOS:=0xD7
SendMessage EM_CHARFROMPOS,0,(Y<<16)|X,,ahk_id %hEdit%
if (ErrorLevel=0xFFFFFFFF)
{
r_CharPos:=-1
r_LineIdx:=-1
Return r_CharPos
}
r_CharPos:=ErrorLevel & 0xFFFF
r_LineIdx:=ErrorLevel>>16
FirstLine:=Edit_GetFirstVisibleLine(hEdit)-1
if (FirstLine>r_LineIdx)
r_LineIdx:=r_LineIdx+(65536*Floor((FirstLine+(65535-r_LineIdx))/65536))
FirstCharPos:=Edit_LineIndex(hEdit,FirstLine<0 ? 0:FirstLine)
if (FirstCharPos>r_CharPos)
r_CharPos:=r_CharPos+(65536*Floor((FirstCharPos+(65535-r_CharPos))/65536))
Return r_CharPos
}
Edit_Clear(hEdit)
{
Static WM_CLEAR:=0x303
SendMessage WM_CLEAR,0,0,,ahk_id %hEdit%
}
Edit_Convert2DOS(p_Text)
{
StringReplace p_Text,p_Text,`r`n,`n,All
StringReplace p_Text,p_Text,`r,`n,All
StringReplace p_Text,p_Text,`n,`r`n,All
Return p_Text
}
Edit_Convert2Mac(p_Text)
{
StringReplace p_Text,p_Text,`r`n,`r,All
StringReplace p_Text,p_Text,`n,`r,All
if StrLen(p_Text)
if p_Text not Contains `r
p_Text .= "`r"
Return p_Text
}
Edit_Convert2Unix(p_Text)
{
StringReplace p_Text,p_Text,`r`n,`n,All
StringReplace p_Text,p_Text,`r,`n,All
if StrLen(p_Text)
if p_Text not Contains `n
p_Text .= "`n"
Return p_Text
}
Edit_ConvertCase(hEdit,p_Case)
{
Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)
if (l_StartSelPos=l_EndSelPos)
Return
l_SelectedText:=Edit_GetSelText(hEdit)
if l_SelectedText is Space
Return
if p_Case in U,Upper,Uppercase
StringUpper l_SelectedText,l_SelectedText
else
if p_Case in L,Lower,Lowercase
StringLower l_SelectedText,l_SelectedText
else
if p_Case in C,Capitalize,Title,TitleCase
StringLower l_SelectedText,l_SelectedText,T
else
if p_Case in T,Toggle,ToggleCase,I,Invert,InvertCase
{
t_SelectedText=
Loop Parse,l_SelectedText
{
t_Char:=A_LoopField
l_Asc:=Asc(t_Char)
if l_Asc between 65 and 90
t_Char:=Chr(l_Asc+32)
else
if l_Asc between 97 and 122
t_Char:=Chr(l_Asc-32)
t_SelectedText .= t_Char
}
l_SelectedText:=t_SelectedText
}
Edit_ReplaceSel(hEdit,l_SelectedText)
Edit_SetSel(hEdit,l_StartSelPos,l_EndSelPos)
}
Edit_Copy(hEdit)
{
Static WM_COPY:=0x301
SendMessage WM_COPY,0,0,,ahk_id %hEdit%
}
Edit_Cut(hEdit)
{
Static WM_CUT:=0x300
SendMessage WM_CUT,0,0,,ahk_id %hEdit%
}
Edit_EmptyUndoBuffer(hEdit)
{
Static EM_EMPTYUNDOBUFFER:=0xCD
SendMessage EM_EMPTYUNDOBUFFER,0,0,,ahk_id %hEdit%
}
Edit_FindText(hEdit,p_SearchText,p_Min=0,p_Max=-1,p_Flags="",ByRef r_RegExOut="")
{
Static s_Text
r_RegExOut:=""
if InStr(p_Flags,"Reset")
s_Text:=""
if StrLen(p_SearchText)=0
Return -1
l_MaxLen:=Edit_GetTextLength(hEdit)
if (l_MaxLen=0)
Return -1
if (p_Min<0 or p_Max>l_MaxLen)
p_Min:=l_MaxLen
if (p_Max<0 or p_Max>l_MaxLen)
p_Max:=l_MaxLen
if (p_Min=p_Max)
Return -1
if InStr(p_Flags,"Static")
{
if StrLen(s_Text)=0
s_Text:=Edit_GetText(hEdit)
l_Text:=SubStr(s_Text,(p_Max>p_Min) ? p_Min+1:p_Max+1,(p_Max>p_Min) ? p_Max:p_Min)
}
else
{
s_Text:=""
l_Text:=Edit_GetTextRange(hEdit,(p_Max>p_Min) ? p_Min:p_Max,(p_Max>p_Min) ? p_Max:p_Min)
}
if InStr(p_Flags,"RegEx")=0
l_FoundPos:=InStr(l_Text,p_SearchText,InStr(p_Flags,"MatchCase"),(p_Max>p_Min) ? 1:0)-1
else
{
p_SearchText:=RegExReplace(p_SearchText,"^P\)?","",1)
if (p_Max>p_Min)
{
l_FoundPos:=RegExMatch(l_Text,p_SearchText,r_RegExOut,1)-1
if ErrorLevel
{
outputdebug,
                   (ltrim join`s
                    Function: %A_ThisFunc% - RegExMatch error.
                    ErrorLevel=%ErrorLevel%
)
l_FoundPos:=-1
}
}
else
{
RE_MinPos     :=1
RE_MaxPos     :=StrLen(l_Text)
RE_StartPos   :=RE_MinPos
Saved_FoundPos:=-1
Saved_RegExOut:=""
loop
{
l_FoundPos:=RegExMatch(l_Text,p_SearchText,r_RegExOut,RE_StartPos)-1
if ErrorLevel
{
outputdebug,
                       (ltrim join`s
                        Function: %A_ThisFunc% - RegExMatch error.
                        ErrorLevel=%ErrorLevel%
)
l_FoundPos:=-1
Break
}
if (l_FoundPos>-1)
{
Saved_FoundPos:=l_FoundPos
Saved_RegExOut:=r_RegExOut
RE_MinPos     :=l_FoundPos+2
}
else
RE_MaxPos:=RE_StartPos-1
if (RE_MinPos>RE_MaxPos or RE_MinPos>StrLen(l_Text))
{
l_FoundPos:=Saved_FoundPos
r_RegExOut:=Saved_RegExOut
Break
}
RE_StartPos:=RE_MinPos+Floor((RE_MaxPos-RE_MinPos)/2)
}
}
}
if (l_FoundPos>-1)
l_FoundPos += (p_Max>p_Min) ? p_Min:p_Max
Return l_FoundPos
}
Edit_FindTextReset()
{
Edit_FindText("","",0,0,"Reset")
}
Edit_FmtLines(hEdit,p_Flag)
{
Static EM_FMTLINES:=0xC8
SendMessage EM_FMTLINES,p_Flag,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_GetFirstVisibleLine(hEdit)
{
Static EM_GETFIRSTVISIBLELINE:=0xCE
SendMessage EM_GETFIRSTVISIBLELINE,0,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_GetLastVisibleLine(hEdit)
{
Edit_GetRect(hEdit,Left,Top,Right,Bottom)
Return Edit_LineFromPos(hEdit,0,Bottom-1)
}
Edit_GetLimitText(hEdit)
{
Static EM_GETLIMITTEXT:=0xD5
SendMessage EM_GETLIMITTEXT,0,0,,ahk_id %hEdit%
Return ErrorLevel<<32>>32
}
Edit_GetLine(hEdit, p_LineIdx=-1,p_Length=-1){
if(p_LineIdx=-1)
p_LineIdx:=Edit_GetCurrentLineCount(hEdit)
if(p_LineIdx<0)
return
WinGetClass, class, ahk_id %hEdit%
if(class="Scintilla"){
hEdit:=Edit_GetLastScintilla(hEdit)
Text:=hEdit.GetLine(p_LineIdx)
return p_Length=-1?(Text):SubStr(Text,1, p_Length)
}
controlget,Text,line,% p_LineIdx+1,,% "ahk_id " hEdit
if(p_Length!=-1)
Text:=SubStr(Text,1,p_Length)
return Text
}
Edit_GetCurrentLineCount(hEdit){
WinGetClass, class, ahk_id %hEdit%
if(class="Scintilla"){
hEdit:=Edit_GetLastScintilla(hEdit)
return hEdit.LineFromPosition()
}
ControlGet, line, CurrentLine,,,% "ahk_id " hEdit
return line-1
}
Edit_GetLineCount(hEdit)
{
Static EM_GETLINECOUNT:=0xBA
SendMessage EM_GETLINECOUNT,0,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_GetMargins(hEdit,ByRef r_LeftMargin="",ByRef r_RightMargin="")
{
Static EM_GETMARGINS:=0xD4
SendMessage EM_GETMARGINS,0,0,,ahk_id %hEdit%
r_LeftMargin :=ErrorLevel & 0xFFFF
r_RightMargin:=ErrorLevel>>16
Return r_LeftMargin
}
Edit_GetModify(hEdit)
{
Static EM_GETMODIFY:=0xB8
SendMessage EM_GETMODIFY,0,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_GetRect(hEdit,ByRef r_Left="",ByRef r_Top="",ByRef r_Right="",ByRef r_Bottom="")
{
Static EM_GETRECT:=0xB2
VarSetCapacity(RECT_Structure,16,0)
SendMessage EM_GETRECT,0,&RECT_Structure,,ahk_id %hEdit%
r_Left  :=NumGet(RECT_Structure,0,"Int")
r_Top   :=NumGet(RECT_Structure,4,"Int")
r_Right :=NumGet(RECT_Structure,8,"Int")
r_Bottom:=NumGet(RECT_Structure,12,"Int")
Return r_Left . A_Space . r_Top . A_Space . r_Right . A_Space . r_Bottom
}
Edit_GetSel(hEdit,ByRef r_StartSelPos="",ByRef r_EndSelPos="", startBeforeEnd=true)
{
WinGetClass,class,ahk_id %hEdit%
if (class="Scintilla") {
hEdit:=Edit_GetLastScintilla(hEdit)
r_EndSelPos:=hEdit._getCurrentPos()
r_StartSelPos:=hEdit._getAnchor()
}else{
Static EM_GETSEL:=0xB0
VarSetCapacity(l_StartSelPos,4,0)
VarSetCapacity(l_EndSelPos,4,0)
SendMessage EM_GETSEL,&l_StartSelPos,&l_EndSelPos,,ahk_id %hEdit%
r_StartSelPos:=NumGet(l_StartSelPos)
r_EndSelPos  :=NumGet(l_EndSelPos)
}
if(startBeforeEnd && r_EndSelPos<r_StartSelPos){
swap:=r_StartSelPos
r_StartSelPos:=r_EndSelPos
r_EndSelPos:=swap
}
return r_StartSelPos
}
Edit_GetSelText(hEdit,l_startSelPos="",l_endSelPos="")
{
WinGetClass,class,ahk_id %hEdit%
if (class="Scintilla") {
hEdit:=Edit_GetLastScintilla(hEdit)
return hEdit.getSelText()
}
if l_startselpos= || l_endselpos=
Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)
if (l_StartSelPos=l_EndSelPos)
Return
l_FirstSelectedLine:=Edit_LineFromChar(hEdit,l_StartSelPos)
l_LastSelectedLine :=Edit_LineFromChar(hEdit,l_EndSelPos)
l_FirstPos:=Edit_LineIndex(hEdit,l_FirstSelectedLine)
if (l_FirstSelectedLine=l_LastSelectedLine)
and (l_EndSelPos<=l_FirstPos+Edit_LineLength(hEdit,l_FirstSelectedLine))
Return SubStr(Edit_GetLine(hEdit,l_FirstSelectedLine,l_EndSelPos-l_FirstPos),l_StartSelPos-l_FirstPos+1)
else
Return SubStr(Edit_GetText(hEdit,l_EndSelPos),l_StartSelPos+1)
}
Edit_GetText(hEdit,p_Length=-1)
{
WinGetClass,class,ahk_id %hEdit%
if (class="Scintilla") {
hEdit:=Edit_GetLastScintilla(hEdit)
return hEdit.GetText()
}
ControlGetText,t,,ahk_id %hEdit%
return t
}
Edit_GetTextLength(hEdit)
{
Static WM_GETTEXTLENGTH:=0xE
SendMessage WM_GETTEXTLENGTH,0,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_GetTextRange(hEdit,p_Min=0,p_Max=-1)
{
Return SubStr(Edit_GetText(hEdit,p_Max),p_Min+1)
}
Edit_IsMultiline(hEdit)
{
Static ES_MULTILINE:=0x4
Return Edit_IsStyle(hEdit,ES_MULTILINE)
}
Edit_IsReadOnly(hEdit)
{
Static ES_READONLY:=0x800
Return Edit_IsStyle(hEdit,ES_READONLY)
}
Edit_IsStyle(hEdit,p_Style)
{
Static GWL_STYLE:=-16
ControlGet l_Style,Style,,,ahk_id %hEdit%
Return l_Style & p_Style ? True:False
}
Edit_SetStyle(hEdit,p_Style,p_Option="+")
{
Control Style,%p_Option%%p_Style%,,ahk_id %hEdit%
Return ErrorLevel ? False:True
}
Edit_LineFromChar(hEdit,p_CharPos=-1)
{
Static EM_LINEFROMCHAR:=0xC9
SendMessage EM_LINEFROMCHAR,p_CharPos,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_LineFromPos(hEdit,X,Y,ByRef r_CharPos="",ByRef r_LineIdx="")
{
Edit_CharFromPos(hEdit,X,Y,r_CharPos,r_LineIdx)
Return r_LineIdx
}
Edit_LineIndex(hedit,p_LineIdx=-1)
{
Static EM_LINEINDEX:=0xBB
SendMessage EM_LINEINDEX,p_LineIdx,0,,ahk_id %hEdit%
Return ErrorLevel<<32>>32
}
Edit_LineLength(hEdit,p_LineIdx=-1)
{
Static EM_LINELENGTH:=0xC1
l_CharPos:=Edit_LineIndex(hEdit,p_LineIdx)
if (l_CharPos<0)
l_CharPos:=Edit_LineIndex(hEdit,Edit_GetTextLength(hEdit)-1)
SendMessage EM_LINELENGTH,l_CharPos,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_LineScroll(hEdit,xScroll=0,yScroll=0)
{
Static EM_LINESCROLL:=0xB6
SendMessage EM_LINESCROLL,xScroll,yScroll,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_LoadFile(hEdit,p_FileName,p_Convert2DOS=False,ByRef r_FileFormat="")
{
IfNotExist %p_FileName%
{
outputdebug Function: %A_ThiSFunc% - File "%p_FileName%" not found
Return False
}
FileRead l_Text,%p_FileName%
if ErrorLevel
{
outputdebug Function: %A_ThiSFunc% - Unable to read from "%p_FileName%"
Return False
}
if l_Text Contains `r`n
{
r_FileFormat:="DOS"
outputdebug DOS file format detected
}
else
if l_Text Contains `n
{
r_FileFormat:="UNIX"
outputdebug Unix file format detected
}
else
if l_Text Contains `r
{
r_FileFormat:="MAC"
outputdebug Mac file format detected
}
else
{
r_FileFormat:="DOS"
outputdebug NO EOL character detected. DOS file format assumed.
}
if p_Convert2DOS
l_Text:=Edit_Convert2DOS(l_Text)
Return Edit_SetText(hEdit,l_Text)
}
Edit_Paste(hEdit)
{
Static WM_PASTE:=0x302
SendMessage WM_PASTE,0,0,,ahk_id %hEdit%
}
Edit_PosFromChar(hEdit,p_CharPos,ByRef X,ByRef Y)
{
Static EM_POSFROMCHAR:=0xD6
SendMessage EM_POSFROMCHAR,p_CharPos,0,,ahk_id %hEdit%
X:=(ErrorLevel & 0xFFFF)<<48>>48
Y:=(ErrorLevel>>16)<<48>>48
}
Edit_ReplaceSel(hEdit,p_Text="",p_CanUndo=True)
{
Static EM_REPLACESEL:=0xC2
SendMessage EM_REPLACESEL,p_CanUndo,&p_Text,,ahk_id %hEdit%
}
Edit_SaveFile(hEdit,p_FileName,p_Convert="")
{
IfExist %p_FileName%
{
FileDelete %p_FileName%
if ErrorLevel
{
outputdebug Function: %A_ThisFunc% - Unable to delete "%p_FileName%"
Return False
}
}
l_Text:=Edit_GetText(hEdit)
if p_Convert in M,Mac
l_Text:=Edit_Convert2Mac(l_Text)
if p_Convert in U,Unix
l_Text:=Edit_Convert2Unix(l_Text)
FileAppend %l_Text%,*%p_FileName%
if ErrorLevel
{
outputdebug Function: %A_ThisFunc% - Unable to save to "%p_FileName%"
Return False
}
Return True
}
Edit_Scroll(hEdit,p_Pages=0,p_Lines=0)
{
Static EM_SCROLL  :=0xB5
,SB_LINEUP  :=0x0
,SB_LINEDOWN:=0x1
,SB_PAGEUP  :=0x2
,SB_PAGEDOWN:=0x3
l_ScrollLines:=0
Loop % Abs(p_Pages)
{
SendMessage EM_SCROLL,(p_Pages>0) ? SB_PAGEDOWN:SB_PAGEUP,0,,ahk_id %hEdit%
if not ErrorLevel
Break
l_ScrollLines:=l_ScrollLines+((ErrorLevel & 0xFFFF)<<48>>48)
}
Loop % Abs(p_Lines)
{
SendMessage EM_SCROLL,(p_Lines>0) ? SB_LINEDOWN:SB_LINEUP,0,,ahk_id %hEdit%
if not ErrorLevel
Break
l_ScrollLines:=l_ScrollLines+((ErrorLevel & 0xFFFF)<<48>>48)
}
Return l_ScrollLines
}
Edit_ScrollCaret(hEdit)
{
WinGetClass,class,ahk_id %hEdit%
if (class="Scintilla") {
hEdit:=Edit_GetLastScintilla(hEdit)
hEdit.ScrollCaret()
return
}
Static EM_SCROLLCARET:=0xB7
SendMessage EM_SCROLLCARET,0,0,,ahk_id %hEdit%
}
Edit_SetLimitText(hEdit,p_Limit)
{
Static EM_LIMITTEXT:=0xC5
SendMessage EM_LIMITTEXT,p_Limit,0,,ahk_id %hEdit%
}
Edit_SetMargins(hEdit,p_LeftMargin="",p_RightMargin="")
{
Static EM_SETMARGINS :=0xD3
,EC_LEFTMARGIN :=0x1
,EC_RIGHTMARGIN:=0x2
,EC_USEFONTINFO:=0xFFFF
l_Margins:=0
l_Flags  :=0
if p_LeftMargin is Integer
{
l_Flags |= EC_LEFTMARGIN
l_Margins |= p_LeftMargin
}
if p_RightMargin is Integer
{
l_Flags |= EC_RIGHTMARGIN
l_Margins |= p_RightMargin<<16
}
if l_Flags
SendMessage EM_SETMARGINS,l_Flags,l_Margins,,ahk_id %hEdit%
}
Edit_SetModify(hEdit,p_Flag)
{
Static EM_SETMODIFY:=0xB9
SendMessage EM_SETMODIFY,p_Flag,0,,ahk_id %hEdit%
}
Edit_SetPasswordChar(hEdit,p_Char="*")
{
Static EM_SETPASSWORDCHAR:=0xCC
SendMessage EM_SETPASSWORDCHAR,Asc(p_Char),0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_SetReadOnly(hEdit,p_Flag)
{
Static EM_SETREADONLY:=0xCF
SendMessage EM_SETREADONLY,p_Flag,0,,ahk_id %hEdit%
Return ErrorLevel ? True:False
}
Edit_SetRect(hEdit,p_Left,p_Top,p_Right,p_Bottom)
{
Static EM_SETRECT:=0xB3
VarSetCapacity(RECT_Structure,16,0)
NumPut(p_Left,  RECT_Structure,0,"Int")
NumPut(p_Top,   RECT_Structure,4,"Int")
NumPut(p_Right, RECT_Structure,8,"Int")
NumPut(p_Bottom,RECT_Structure,12,"Int")
SendMessage EM_SETRECT,0,&RECT_Structure,,ahk_id %hEdit%
}
Edit_SetTabStops(hEdit,p_NbrOfTabStops=0,p_DTU=32)
{
Static EM_SETTABSTOPS:=0xCB
VarSetCapacity(l_TabStops,p_NbrOfTabStops*4,0)
if p_DTU contains ,,
{
Loop Parse,p_DTU,`,,%A_Space%
if (A_Index<=p_NbrOfTabStops)
Numput(A_LoopField+0,l_TabStops,(A_Index-1)*4,"UInt")
}
else
Loop %p_NbrOfTabStops%
NumPut(p_DTU*A_Index,l_TabStops,(A_Index-1)*4,"UInt")
SendMessage EM_SETTABSTOPS,p_NbrOfTabStops,&l_TabStops,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_SetText(hEdit,p_Text)
{
WinGetClass,class,ahk_id %hEdit%
if (class="Scintilla") {
hEdit:=Edit_GetLastScintilla(hEdit)
return hEdit.SetText(p_Text)
}
Static WM_SETTEXT:=0xC
SendMessage WM_SETTEXT,0,&p_Text,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_SetSel(hEdit,p_StartSelPos=0,p_EndSelPos=-1)
{
WinGetClass,class,ahk_id %hEdit%
if (class="Scintilla") {
hEdit:=Edit_GetLastScintilla(hEdit)
return hEdit._SetSel(p_StartSelPos, p_EndSelPos)
}
Static EM_SETSEL:=0x0B1
SendMessage EM_SETSEL,p_StartSelPos,p_EndSelPos,,ahk_id %hEdit%
}
Edit_TextIsSelected(hEdit)
{
Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)
Return (l_StartSelPos<>l_EndSelPos)
}
Edit_Undo(hEdit)
{
Static EM_UNDO:=0xC7
SendMessage EM_UNDO,0,0,,ahk_id %hEdit%
Return ErrorLevel
}
Edit_GetActiveHandles(ByRef hEdit="",ByRef hWindow="",p_MsgBox=False)
{
WinGet hWindow,ID,A
ControlGetFocus l_Control,A
if SubStr(l_Control,1,4)="Edit"
{
ControlGet hEdit,hWnd,,%l_Control%,A
Return hEdit
}
if p_MsgBox
MsgBox
,262160
,Error
,This request cannot be performed on this control.  %A_Space%
Return False
}
Edit_SelectLine(hEdit, line=0, include_newline=false)
{
control:="",wintitle:="ahk_id " hEdit
ControlGet, hwnd, Hwnd,, %Control%, %WinTitle%
if (!WinExist("ahk_id " hwnd))
return false
if (line<1)
ControlGet, line, CurrentLine
SendMessage, 0xBB, line-1, 0
offset := ErrorLevel
SendMessage, 0xC1, offset, 0
lineLen := ErrorLevel
if (include_newline) {
WinGetClass, class
lineLen += (class="Edit") ? 2 : 1
}
SendMessage, 0xB1, offset, offset+lineLen
Edit_SCROLLCARET(hEdit)
return (ErrorLevel != "FAIL")
}
Edit_InsertText(hEdit, ByRef Text, pos=""){
WinGetClass, class, ahk_id %hEdit%
if(class="Scintilla"){
hEdit:=Edit_GetLastScintilla(hEdit)
if pos=
hEdit.AddText(Text)
else
hEdit._InsertText(Text, pos)
return
}
Edit_GetSel(hEdit, s, e)
,oldText:=Edit_GetText(hEdit)
if (pos=""){
Edit_SetText(hEdit, SubStr(oldText,1,s) Text (SubStr(oldText,e+1)))
,Edit_SetSel(hEdit, s:=s+StrLen(Text), s)
}else{
if(pos=-1)
pos:=StrLen(oldText), last:=true
len:=StrLen(Text), AllLen:=StrLen(oldText)+len
Edit_SetText(hEdit, SubStr(oldText,1,pos) Text (last?"":SubStr(oldText,pos+1)))
,Edit_SetSel(hEdit, min(s<=pos?s:s+len, AllLen), min(e<pos?e:e+len, AllLen))
}
}
Edit_DeleteText(hEdit, pos="", len=""){
WinGetClass, class, ahk_id %hEdit%
if(class="Scintilla"){
hEdit:=Edit_GetLastScintilla(hEdit)
if(pos="" && len=""){
s:=hEdit.getSelectionStart()
,e:=hEdit.getSelectionEnd()
hEdit.DeleteRange(s-1,e-s?e-s:1)
return
}
if(pos=""){
Loop % len
Edit_DeleteText(hEdit.hwnd)
return
}
if(len=""){
if hEdit.getSelectionStart()=hEdit.getSelectionEnd()
len:=1
else
len:=hEdit._getSelectionEnd()-Pos
}
hEdit._DeleteRange(pos, len)
return
}
Edit_GetSel(hEdit, s, e)
if(pos="")
pos:=s
if(len="")
len:=e-s?e-s:1
if len>pos
len:=pos
oldText:=Edit_GetText(hEdit)
,Edit_SetText(hEdit, SubStr(oldText,1,pos-len) (SubStr(oldText,pos+1)))
,AllLen:=StrLen(Edit_GetText(hEdit))
,pos-=len
,Edit_SetSel(hEdit, a:=(s<=pos)?s:(s>=pos+len)?max(min(s-len,AllLen),0):pos, b:=(e<=pos)?e:(e>=pos+len)?max(min(e-len,AllLen),0):pos)
}
Edit_GetLastScintilla(hwnd){
static lastHwnd, lastClass
if (hwnd=lastHwnd){
return lastClass
}else{
return lastClass:=new RemoteScintilla(lastHwnd:=hwnd)
}
}
Control_GetClassNN(hWndWindow,hWndControl){
DetectHiddenWindows, On
WinGet, ClassNNList, ControlList, ahk_id %hWndWindow%
Loop, PARSE, ClassNNList, `n
{
ControlGet, hwnd, hwnd,,%A_LoopField%,ahk_id %hWndWindow%
if (hWnd = hWndControl)
return A_LoopField
}
}
findAccByRoleText(acc, RoleText, depth=0){
thisRoleText:=RoleText[depth+1]
,which=thisRoleText[2]
,findAt=thisRoleText[3]
i:=0, found:=false
if(which!=""){
for ch in Acc_EnumChildren(acc)
if (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]) && (++i=which){
found:=ch
break
}
if(found)
if IsObject(RoleText[depth+2])
return findAccByRoleText(ch, RoleText, depth+1)
else
return ch
else
return false
}else if (findAt!=""){
for ch in Acc_EnumChildren(acc)
if(A_Index=findAt && (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]))
if IsObject(RoleText[depth+2])
return findAccByRoleText(ch, RoleText, depth+1)
else
return ch
else
return false
}else{
for ch in Acc_EnumChildren(acc)
if (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]){
if IsObject(RoleText[depth+2])
found:=findAccByRoleText(ch, RoleText, depth+1)
else
found:=ch
if(found)
return found
}
return false
}
}
findAccByValue(byref acc,val,this_path=""){
static arr:=[]
static path:=""
static record:=""
for k,v in acc_children(acc) {
if (IsObject(v) && instr(v.accValue,val)) || (!IsObject(v) && InStr(acc_get("value", "", k, acc), val))
arr.push([v.clone(),this_path "," k])
findAccByValue(v,val,this_path "," k)
}
record.=this_path "`n"
return [arr,record]
}
findAccByName(byref acc,val,this_path=""){
static arr:=[]
static path:=""
static record:=""
for k,v in acc_children(acc) {
if instr(v.accName,val)
arr.push([v.clone(),this_path "," k])
findAccByName(v,val,this_path "," k)
}
record.=this_path "`n"
return [arr,record]
}
findAccBy(byref acc,val,by="value",this_path=""){
static arr:=[]
static path:=""
static record:=""
for k,v in acc_children(acc) {
if instr(acc_get(by,"",0,v),val)
arr.push([v.clone(),this_path "," k])
findAccBy(v,val,by,this_path "," k)
}
record.=this_path "`n"
return [arr,record]
}
accControl(Control,WinTitle=""){
if (Control="A" && WinTitle="") {
ControlGetFocus, Control, A
WinTitle = A
} else if (Control+0!="" && WinTitle="") {
WinTitle := "ahk_id " . Control
Control =
}
controlget,hwnd,hwnd,,%control%,%WinTitle%
return acc_objectfromwindow(hwnd)
}
Acc_Init()
{
Static	h
If Not	h
h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild)
{
Acc_Init()
If	DllCall("oleacc\AccessibleObjectFromEvent", "Ptr", hWnd, "UInt", idObject, "UInt", idChild, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}
Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "")
{
Acc_Init()
If	DllCall("oleacc\AccessibleObjectFromPoint", "Int64", x==""||y==""?0*DllCall("GetCursorPos","Int64*",pt)+pt:x&0xFFFFFFFF|y<<32, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}
Acc_ObjectFromWindow(hWnd, idObject = -4)
{
Acc_Init()
If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
Return	ComObjEnwrap(9,pacc,1)
}
Acc_ObjectFromWindow2(hWnd, idObject = -4)
{
If DllCall(AccessibleObjectFromWindowProc, "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
Return	ComObjEnwrap(9,pacc,1)
}
Acc_WindowFromObject(pacc)
{
If	DllCall("oleacc\WindowFromAccessibleObject", "Ptr", IsObject(pacc)?ComObjValue(pacc):pacc, "Ptr*", hWnd)=0
Return	hWnd
}
Acc_GetRoleText(nRole)
{
nSize := DllCall("oleacc\GetRoleText", "Uint", nRole, "Ptr", 0, "Uint", 0)
,VarSetCapacity(sRole, (A_IsUnicode?2:1)*nSize)
,DllCall("oleacc\GetRoleText", "Uint", nRole, "str", sRole, "Uint", nSize+1)
Return	sRole
}
Acc_GetStateText(nState)
{
nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)
,VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)
,DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)
Return	sState
}
Acc_SetWinEventHook(eventMin, eventMax, pCallback)
{
Return	DllCall("SetWinEventHook", "Uint", eventMin, "Uint", eventMax, "Uint", 0, "Ptr", pCallback, "Uint", 0, "Uint", 0, "Uint", 0)
}
Acc_UnhookWinEvent(hHook)
{
Return	DllCall("UnhookWinEvent", "Ptr", hHook)
}
Acc_Role(Acc, ChildId=0) {
try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetRoleText(Acc.accRole(ChildId)):"invalid object"
}
Acc_State(Acc, ChildId=0) {
try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateText(Acc.accState(ChildId)):"invalid object"
}
Acc_Location(Acc, ChildId=0, byref Position="") {
try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
catch
return
Position := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
return	{x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")}
}
Acc_Parent(Acc) {
try parent:=Acc.accParent
return parent?Acc_Query(parent):
}
Acc_Child(Acc, ChildId=0) {
try child:=Acc.accChild(ChildId)
return child?Acc_Query(child):
}
Acc_Query(Acc) {
try return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Error(p="") {
static setting:=0
return p=""?setting:setting:=p
}
Acc_Children(Acc) {
if ComObjType(Acc,"Name") != "IAccessible"
ErrorLevel := "Invalid IAccessible Object"
else {
Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
Loop %cChildren%
i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.push(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
return Children.MaxIndex()?Children:
} else
ErrorLevel := "AccessibleChildren DllCall Failed"
}
if Acc_Error()
throw Exception(ErrorLevel,-1)
}
Acc_ChildrenByRole(Acc, Role) {
if ComObjType(Acc,"Name")!="IAccessible"
ErrorLevel := "Invalid IAccessible Object"
else {
Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
Loop %cChildren% {
i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i)
if NumGet(varChildren,i-8)=9
AccChild:=Acc_Query(child), ObjRelease(child), Acc_Role(AccChild)=Role?Children.push(AccChild):
else
Acc_Role(Acc, child)=Role?Children.push(child):
}
return Children.MaxIndex()?Children:, ErrorLevel:=0
} else
ErrorLevel := "AccessibleChildren DllCall Failed"
}
if Acc_Error()
throw Exception(ErrorLevel,-1)
}
Acc_Get(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
AccObj :=   IsObject(WinTitle)? WinTitle
:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
if ComObjType(AccObj, "Name") != "IAccessible"
ErrorLevel := "Could not access an IAccessible Object"
else {
StringReplace, ChildPath, ChildPath, _, %A_Space%, All
AccError:=Acc_Error(), Acc_Error(true)
Loop Parse, ChildPath, ., %A_Space%
try {
if A_LoopField is digit
Children:=Acc_Children(AccObj), m2:=A_LoopField
else
RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
if Not Children.HasKey(m2)
throw
AccObj := Children[m2]
} catch {
ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
if Acc_Error()
throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
return
}
Acc_Error(AccError)
StringReplace, Cmd, Cmd, %A_Space%, , All
properties.HasKey(Cmd)? Cmd:=properties[Cmd]:
try {
if (Cmd = "Location")
AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
, ret_val := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
else if (Cmd = "Object")
ret_val := AccObj
else if Cmd in Role,State
ret_val := Acc_%Cmd%(AccObj, ChildID+0)
else if Cmd in ChildCount,Selection,Focus
ret_val := AccObj["acc" Cmd]
else
ret_val := AccObj["acc" Cmd](ChildID+0)
} catch {
ErrorLevel := """" Cmd """ Cmd Not Implemented"
if Acc_Error()
throw Exception("Cmd Not Implemented", -1, Cmd)
return
}
return ret_val, ErrorLevel:=0
}
if Acc_Error()
throw Exception(ErrorLevel,-1)
}
Class AccObj {
__New(hwnd){
if !hwnd
return
setformat,integer,h
if isobject(hwnd) {
this.hwnd:=acc_windowfromobject(hwnd)
this.acc:=hwnd
}else{
this.hwnd:=hwnd
this.acc:=acc_objectfromwindow(hwnd)
}
setformat,integer,d
}
loc(childId=0, byref pos=""){
return Acc_Location(this.Acc, childId, pos)
}
get(Cmd, ChildPath="", ChildID=0,WinTitle="", WinText="", ExcludeTitle="", ExcludeText=""){
if (WinTitle WinText ExcludeTitle ExcludeText="")
wintitle:=this.acc
get:=Acc_Get(Cmd, ChildPath, ChildID, WinTitle, WinText, ExcludeTitle, ExcludeText)
return isobject(get)?(new AccObj(get)):get
}
parent(){
return new AccObj(acc_parent(this.acc))
}
children(ind=""){
ret:=[]
ch:=acc_children(this.acc)
if (ind=""){
if ch.maxindex() {
for k,v in acc_children(this.acc)
ret.push(new AccObj(v))
}
}else{
ret:=new AccObj(acc_children(this.acc)[ind])
}
return ret
}
__Get(childrenCount){
ret:=acc_children(this.acc)
return (ret.maxIndex()?ret.maxIndex():0)
}
childrenTree(obj=""){
arr:=[]
if (obj="")
obj:=this
arr[0]:=obj
ch:=obj.children()
if ch.maxIndex() {
for k,v in ch
arr.push(obj.childrenTree(v))
}
return arr
}
childrenTreeStr(byref node="",win=""){
if win=
win:=this.belongWin()
if node=
node:=this.childrenTree()
controlgettext,text,,% "ahk_id " node[0].hwnd
str:=node[0].hwnd "|" Control_GetClassNN(win,node[0].hwnd) "|" text "`n"
for k,v in node {
if k
str.="`t" this.childrenTreeStr(v,win)
}
return str
}
GetControls(hwnd="")
{
if hwnd=
hwnd:=this.hwnd
controls:=[]
winget,classnn,ControlList,ahk_id %hwnd%
winget,controlId,controllisthwnd,ahk_id %hwnd%
loop,parse,classnn,`n
{
controls[a_index]:=[]
controls[a_index]["ClassNN"]:=a_loopfield
}
loop,parse,controlId,`n
{
controls[a_index]["Hwnd"]:=a_loopfield
controlgetText,txt,,ahk_id %a_loopfield%
controls[a_index]["text"]:=txt
}
return controls
}
belongWin(){
WinGet, all, list
DetectHiddenWindows,on
Loop, %all%
{
setformat,integer,d
v := all%A_Index%
winget,controls,controllisthwnd,ahk_id %v%
setformat,integer,h
hwnd:=this.hwnd
if regexmatch(controls,"\b" hwnd "\b") {
found:=v
break
}
}
return found?found:0
}
}
Acc_Children2(pacc, cChildren, ByRef varChildren)
{
Acc_Init()
If	DllCall("oleacc\AccessibleChildren", "Ptr", IsObject(pacc)?ComObjValue(pacc):pacc, "Int", 0, "Int", cChildren, "Ptr", VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*", cChildren)=0
Return	cChildren
}
Acc_EnumChildren(Acc) {
Children := []
Loop, % Acc_Children2(Acc, Acc.accChildCount, varChildren)
i := (A_Index-1)*(A_PtrSize*2+8)+8
, child := NumGet(varChildren,i)
, Children.push(NumGet(varChildren,i-8)=3?child:ComObj(9,child,1))
return, {	Items:		Children
,	_NewEnum:	Func("Acc_Enum_NewEnum")
,	Next:		Func("Acc_Enum_Next")
,	base:		{__Get:Func("Acc_Enum_Get")}	}
}
Acc_Enum_NewEnum(obj) {
return, obj
}
Acc_Enum_Next(obj, byref child, byref type="") {
If Not obj.HasKey("child")
obj.child:=child, obj.type:=type
If Not obj.Items.MaxIndex() {
child:=obj.child, type:=obj.type
return, false
} else {
child:=obj.Items.Delete(1), type:=IsObject(child)?9:3
return, true
}
}
Acc_Enum_Get(obj, key) {
return, obj.Items[key]
}
hModuleKernel := DllCall("LoadLibrary", "Str", "Kernel32.dll", "Ptr")
listAccChildProperty(hwnd){
}
getControlNameByHwnd(winHwnd,controlHwnd, tried=0){
bufSize:=1024
winget,processID,pid,ahk_id %winHwnd%
VarSetCapacity(var1,bufSize)
getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )
if(ErrorLevel || !getName)
goto getControlNameByHwnd_FAIL
hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID, "Ptr")
if(ErrorLevel || !hProcess)
goto getControlNameByHwnd_FAIL
otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")
if(ErrorLevel || !otherMem)
goto getControlNameByHwnd_FAIL
SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %controlHwnd%
if(ErrorLevel="FAIL")
goto getControlNameByHwnd_FAIL
DllCall("ReadProcessMemory","Ptr",hProcess,"Ptr",otherMem,"Str",var1,"UInt",bufSize,"Ptr",0)
,DllCall("VirtualFreeEx","Ptr", hProcess,"Ptr",otherMem,"UInt", 0, "UInt", 0x8000)
,DllCall("CloseHandle","Ptr",hProcess)
return var1
getControlNameByHwnd_FAIL:
if(tried>2)
return A_LastError
else
return getControlNameByHwnd(winHwnd, controlHwnd, ++tried)
}
getControlNameByHwnd64(winHwnd, controlHwnd){
return
SetBatchLines,-1
DetectHiddenWindows,on
process,Exist,getControlNameByHwnd64.exe
if(!ErrorLevel){
ToolTip % "Please run ""getControlNameByHwnd64.exe""!"
return
}
processID:=ErrorLevel
bufSize=65536
VarSetCapacity(var1,bufSize)
getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )
if(ErrorLevel || !getName)
return A_LastError
hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID, "Ptr")
if(ErrorLevel || !hProcess)
return A_LastError
otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")
if(ErrorLevel || !otherMem)
return A_LastError
SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %controlHwnd%
if(ErrorLevel="FAIL")
return
DllCall("ReadProcessMemory","Ptr",hProcess,"Ptr",otherMem,"Str",var1,"UInt",bufSize,"Ptr",0)
,DllCall("VirtualFreeEx","Ptr", hProcess,"Ptr",otherMem,"UInt", 0, "UInt", 0x8000)
,DllCall("CloseHandle","Ptr",hProcess)
return var1
}
getControlNameByHwnd2(_, controlHwnd){
UIAutomation := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
,DllCall(NumGet(NumGet(UIAutomation+0)+6*A_PtrSize), "Ptr", UIAutomation, "Ptr", controlHwnd, "Ptr*", IUIAutomationElement)
,DllCall(NumGet(NumGet(IUIAutomationElement+0)+29*A_PtrSize), "Ptr", IUIAutomationElement, "Ptr*", automationId)
,ret := StrGet(automationId,, "UTF-16")
,DllCall("oleaut32\SysFreeString", "Ptr", automationId)
,ObjRelease(IUIAutomationElement)
,ObjRelease(UIAutomation)
return ret
}
getByControlName(winHwnd,name){
winget,controlList,controlListhwnd,ahk_id %winHwnd%
arr:=[]
,bufSize=1024
winget,processID,pid,ahk_id %winHwnd%
VarSetCapacity(var1,bufSize)
if !(getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )) || ErrorLevel
return []
dwResult:=DllCall("GetWindowThreadProcessId", "Ptr", winHwnd)
if !(hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID), "Ptr") || ErrorLevel
return []
if !(otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")) || ErrorLevel
return []
loop,parse,controlList,`n
{
SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %a_loopfield%
if errorlevel=FAIL
return []
if !DllCall("ReadProcessMemory","Ptr",hProcess,"Ptr",otherMem,"Str",var1,"UInt",bufSize,"Ptr",0)
return []
if (var1=name)
arr.push(a_loopfield)
,var1:=""
}
DllCall("VirtualFreeEx","Ptr", hProcess,"Ptr",otherMem,"UInt", 0, "UInt", 0x8000)
,DllCall("CloseHandle","Ptr",hProcess)
return arr
}
getByControlName2(winHwnd,name){
winget,controlList,controlListhwnd,ahk_id %winHwnd%
arr:=[], UIAutomation := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
Loop,Parse,controllist,`n
{
controlHwnd:=A_LoopField
,DllCall(NumGet(NumGet(UIAutomation+0)+6*A_PtrSize), "Ptr", UIAutomation, "Ptr", controlHwnd, "Ptr*", IUIAutomationElement)
,DllCall(NumGet(NumGet(IUIAutomationElement+0)+29*A_PtrSize), "Ptr", IUIAutomationElement, "Ptr*", automationId)
,controlName := StrGet(automationId,, "UTF-16")
if(controlName = name){
arr.push(controlHwnd)
}
}
if (automationId)
DllCall("oleaut32\SysFreeString", "Ptr", automationId)
if (IUIAutomationElement)
ObjRelease(IUIAutomationElement)
ObjRelease(UIAutomation)
return arr
}
controlGetText(hwnd){
if IsObject(hwnd) {
if (hwnd.__Class="Scintilla") {
Text:=""
if (len:=hwnd.GetTextLength())>0
hwnd.GetText(hwnd.GetTextLength()+4, Text)
}else if (hwnd.__Class="RemoteScintilla"){
Text:=hwnd.GetText()
}
return Text
}
WinGetClass,class,ahk_id %hwnd%
if (class="scintilla") {
hwnd:=new RemoteScintilla(hwnd)
return hwnd.GetText()
}else {
controlgettext,t,,ahk_id %hwnd%
}
return t
}
winGetClass(hwnd){
WinGetClass,cl,ahk_id %hwnd%
return cl
}
getNetAcc(winHwnd,controlName,classNN,shift=0,acc=true,name="",text="", getNonEmpty=false){
ret:=getNetControl2(winHwnd,text,controlName,name,classNN,"","","",shift)
if(getNonEmpty || InStr(classNN,"Edit"))
ret:=getNonEmptyControl(ret)
if (acc){
return acc_objectfromwindow(ret[1])
}else
return ret[1]
}
getNetControls(ByRef param){
ret:=[]
,winHwndControls:=[]
for k,v in param {
if !IsObject(v) {
oneParam:=true
v:=param
}
if (winHwnd:=v.winHwnd) && WinExist("ahk_id " winHwnd) {
if(winHwndControls.hasKey(winHwnd))
list:=winHwndControls[winHwnd]
else{
winget,list,controllisthwnd,ahk_id %winHwnd%
winHwndControls[winHwnd]:=list
}
}else{
continue
}
for x,y in ["text", "ClassNN", "controlName", "accName", "accHelp", "accRole", "style", "shift", "getNonEmpty"]
%y%:=v[y]
if(shift="")
shift:=0
arr:=[],controlArr:=[]
loop,parse,list,`n
{
controlArr.push(a_loopfield)
if (text="" || instr(controlgettext(a_loopfield),text)) && (classNN="" || instr(winGetClass(a_loopfield),classNN)) && (controlName="" || getControlNameByHwnd(winHwnd,a_loopfield)=controlName) && (accName="" || instr((acc:=acc_objectfromwindow(a_loopfield)).accName,accName)) && (accHelp="" || instr(acc.accHelp,accHelp)) && (accRole="" || instr(acc.accRole,accRole)) && (!style || DllCall("GetWindowLong",Ptr,a_loopfield,Int,-16)=style)
arr[a_index]:=a_loopfield
}
result:=[]
for k,v in arr
if (r:=controlArr[k+shift])
result.push(r)
if(oneParam)
return getNonEmpty?getNonEmptyControl(result):result
else{
ret.push(getNonEmpty?getNonEmptyControl(result):result)
}
}
return ret
}
getNetControl2(winHwnd,text="",controlName="",accName="",classNN="",accHelp="",accRole="",style="",shift=0, result="", getNonEmpty=false){
if !isobject(result)
result:=[]
if isobject(winHwnd){
for k,v in winHwnd
getNetControl2(v,text,controlName,accName,classNN,accHelp,accRole,style,shift,result)
return getNonEmpty?getNonEmptyControl(result):result
}
winget,list,controllisthwnd,ahk_id %winHwnd%
arr:=[],controlArr:=[]
loop,parse,list,`n
{
controlArr.push(a_loopfield)
if (text="" || instr(controlgettext(a_loopfield),text)) && (classNN="" || instr(winGetClass(a_loopfield),classNN)) && (controlName="" || getControlNameByHwnd(winHwnd,a_loopfield)=controlName) && (accName="" || instr((acc:=acc_objectfromwindow(a_loopfield)).accName,accName)) && (accHelp="" || instr(acc.accHelp,accHelp)) && (accRole="" || instr(acc.accRole,accRole)) && (!style || DllCall("GetWindowLong",Ptr,a_loopfield,Int,-16)=style)
arr[a_index]:=a_loopfield
}
for k,v in arr
if (r:=controlArr[k+shift])
result.push(r)
return getNonEmpty?getNonEmptyControl(result):result
}
getNonEmptyControl(ByRef arr, acc=false){
ret:=[]
if(!acc){
for k,v in arr
if ControlGetText(v)!=""
ret.push(v)
}else{
for k,v in arr
if (v.accValue!="")
ret.push(v)
}
return ret.maxindex()>0?ret:[arr[1]]
}
getNetControlGlobal(text="",controlName="",accName="",classNN="",accHelp="",accRole="",style="",shift=0){
ret:=[],win=[]
DetectHiddenWindows,on
winget,lst,list
loop % lst {
winhwnd:=lst%a_index%
a:=getNetControl2(winHwnd,text,controlName,accName,classNN,accHelp,accRole,style,shift)
if (a.maxindex()){
for k,v in a
ret.push(v)
b:=[]
b["" winHwnd]:=a
win.push(b)
}
}
return [ret,win]
}
getNetControl(winHwnd,controlName="",accName="",classNN="",accHelp=""){
winget,list,controllisthwnd,ahk_id %winHwnd%
bufSize=1024
winget,processID,pid,ahk_id %winHwnd%
VarSetCapacity(var1,bufSize)
getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )
if(ErrorLevel || !getName)
return A_LastError
hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID, "Ptr")
if(ErrorLevel || !hProcess)
return A_LastError
otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")
if(ErrorLevel || !otherMem)
return A_LastError
count=0
loop,parse,list,`n
{
SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %a_loopfield%
if !DllCall("ReadProcessMemory","Ptr",hProcess,"Ptr",otherMem,"Str",var1,"UInt",bufSize,"UInt *",0) || ErrorLevel
continue
if ((var1&&var1=controlName)&&(accName=""||(acc:=Acc_ObjectFromWindow(a_loopfield)).accName=accName)){
WinGetClass,cl,ahk_id %a_loopfield%
if(instr(cl,classNN)=1&&(accHelp=""||acc.accHelp=accHelp)) {
ret:=a_loopfield
break
}
}
var1:=""
}
DllCall("VirtualFreeEx","Ptr", hProcess,"Ptr",otherMem,"UInt", 0, "UInt", 0x8000)
,DllCall("CloseHandle","Ptr",hProcess)
,DllCall("FreeLibrary", "Ptr", hModule)
return ret
}
getControlDescription(winHwnd,controlHwnd){
return "getNetControl2(RisState[2],""" controlgettext(controlHwnd) """,""" getControlNameByHwnd(winHwnd,controlHwnd) """,""" (acc:=acc_objectfromwindow(controlHwnd)).accName """,""" winGetClass(controlHwnd) """,""" acc.accHelp """,""" acc.accRole """,""" DllCall("GetWindowLong",Ptr,controlHwnd,Int,-16) """,0)"
}
Send_WM_COPYDATA(Hwnd, dwData, lpData="") {
static WM_COPYDATA := 0x4A
VarSetCapacity(COPYDATASTRUCT, 3*A_PtrSize, 0)
,cbData := (StrLen(lpData) + 1) * (A_IsUnicode ? 2 : 1)
,NumPut(dwData,  COPYDATASTRUCT, 0*A_PtrSize)
,NumPut(cbData,  COPYDATASTRUCT, 1*A_PtrSize)
,NumPut(&lpData, COPYDATASTRUCT, 2*A_PtrSize)
SendMessage, WM_COPYDATA, 0, &COPYDATASTRUCT,, ahk_id %Hwnd%
return ErrorLevel == "FAIL" ? false : true
}
DetectHiddenWindows,on
ImpaxContextServer_Init(hwnd=""){
static prvHwnd
if WinExist("ahk_id " hwnd) || WinExist("ahk_id " hwnd:=prvHwnd){
winget,ProcessName,ProcessName,ahk_id %hwnd%
if(ProcessName="ImpaxContextServer.exe")
return hwnd
}
process,Exist,ImpaxContextServer.exe
if (!ErrorLevel){
root:=SubStr(A_ScriptDir, 1, 2)
if  FileExist(path:=root "\scripts\Radiology\MammoSR\ImpaxContextServer\ImpaxContextServer.exe")
|| fileexist(path:=A_ScriptDir "\ImpaxContextServer.exe")
|| fileexist(path:=A_ScriptDir "\ImpaxContextServer\ImpaxContextServer.exe")
||  fileexist(path:=a_mydocuments "\ImpaxContextServer\ImpaxContextServer.exe")
contextServerPath:=path
run % contextServerPath
winwait,ahk_exe ImpaxContextServer.exe,,5
winminimize,ahk_exe ImpaxContextServer.exe
}
return (h:=WinExist("ahk_exe ImpaxContextServer.exe"))?(prvHwnd:=h):0
}
ImpaxContextServer_SendCommand(str, hwnd=""){
Send_WM_COPYDATA(ImpaxContextServer_Init(hwnd), 0, str)
}
ImpaxContextServer_Show(AccNo, hwnd=""){
ImpaxContextServer_SendCommand("SYNC_DISPLAY || " Trim(AccNo) " || ", hwnd)
}
ImpaxContextServer_Add(AccNo, withPrior=false, hwnd=""){
ImpaxContextServer_SendCommand("ADD_TO_DISPLAY_LIST" (withPrior?"_WITH_PRIORS":"") " || " Trim(AccNo) " || ", hwnd)
}
SetTimerF( Function, Period=0, ParmObject=0, Priority=0 ) {
Static current,tmrs:=[]
static PTR:=A_PtrSize ? "Ptr" : "UInt"
static UInt:="UInt"
If IsFunc( Function ) {
if IsObject(tmr:=tmrs[Function])
ret := DllCall( "KillTimer", PTR,0, PTR, tmr.tmr)
, DllCall("GlobalFree", PTR, tmr.CBA)
, tmrs.Delete(Function)
if (Period = 0 || Period = "off")
return ret
tmr:=tmrs[Function]:={func:Function,Period:Period="on" ? 250 : Period,Priority:Priority
,OneTime:Period<0,params:IsObject(ParmObject)?ParmObject:Object()
,Tick:A_TickCount}
tmr.CBA := RegisterCallback(A_ThisFunc,"F",4,&tmr)
return !!(tmr.tmr  := DllCall("SetTimer", PTR,0, PTR,0, UInt
, (Period && Period!="On") ? Abs(Period) : (Period := 250)
, PTR,tmr.CBA,"PTR"))
, tmr.Tick:=A_TickCount
}
tmr := Object(A_EventInfo)
if IsObject(tmr) {
DllCall("KillTimer", PTR,0, PTR,tmr.tmr)
If (current && tmr.Priority<current.priority)
Return (tmr.tmr:=DllCall("SetTimer", PTR,0, PTR,0, UInt, 100, PTR,tmr.CBA,"PTR"))
current:=tmr
,tmr.tick:=ErrorLevel :=Priority
,tmr.func(tmr.params*)
if (tmr.OneTime)
return DllCall("GlobalFree", PTR,tmr.CBA)
,tmrs.Delete(tmr.func)
tmr.tmr:= DllCall("SetTimer", PTR,0, PTR,0, UInt
,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), PTR,tmr.CBA,"PTR")
current=
}
}
class SetTimerF_class {
SetTimer( Function, Period=0, ParmObject=0, Priority=0 ) {
Static tmrs:=[]
If IsFunc( Function ) {
if IsObject(tmr:=tmrs[this])
ret := DllCall( "KillTimer", "UInt",0, "UInt", tmr.tmr)
, DllCall("GlobalFree", "UInt", tmr.CBA)
, ObjRemove(tmrs,this)
if (Period = 0 || Period = "off")
return ret
tmr:=tmrs[this]:={func:Function,ref:this,Period:Period="on" ? 250 : Period,Priority:Priority
,OneTime:Period<0,params:IsObject(ParmObject)?ParmObject:[],Tick:A_TickCount}
,tmr.CBA := RegisterCallback(this.base.SetTimer,"F",4,&tmr)
return !!(tmr.tmr  := DllCall("SetTimer", "UInt",0, "UInt",0, "UInt"
, (Period && Period!="On") ? Abs(Period) : (Period := 250)
, "UInt",tmr.CBA))
, tmr.Tick:=A_TickCount
}
if IsObject(tmr := Object(A_EventInfo)) {
DllCall("KillTimer", "UInt",0, "UInt",tmr.tmr)
,tmr.tick:= ErrorLevel := A_TickCount
,func:=tmr.func,%func%(tmr.ref,tmr.params*)
if (tmr.OneTime)
return DllCall("GlobalFree", "UInt",tmr.CBA)
,ObjRemove(tmrs,tmr.ref?tmr.ref:tmr.func)
tmr.tmr := DllCall("SetTimer", "UInt",0, "UInt",0, "UInt"
,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), "UInt",tmr.CBA)
}
}
}
Jxon_Load(ByRef src, args*)
{
static q := Chr(34)
key := "", is_key := false
stack := [ tree := [] ]
is_arr := { (tree): 1 }
next := q . "{[01234567890-tfn"
pos := 0
while ( (ch := SubStr(src, ++pos, 1)) != "" )
{
if InStr(" `t`n`r", ch)
continue
if !InStr(next, ch, true)
{
ln := ObjLength(StrSplit(SubStr(src, 1, pos), "`n"))
col := pos - InStr(src, "`n",, -(StrLen(src)-pos+1))
msg := Format("{}: line {} col {} (char {})"
,   (next == "")      ? ["Extra data", ch := SubStr(src, pos)][1]
: (next == "'")     ? "Unterminated string starting at"
: (next == "\")     ? "Invalid \escape"
: (next == ":")     ? "Expecting ':' delimiter"
: (next == q)       ? "Expecting object key enclosed in double quotes"
: (next == q . "}") ? "Expecting object key enclosed in double quotes or object closing '}'"
: (next == ",}")    ? "Expecting ',' delimiter or object closing '}'"
: (next == ",]")    ? "Expecting ',' delimiter or array closing ']'"
: [ "Expecting JSON value(string, number, [true, false, null], object or array)"
, ch := SubStr(src, pos, (SubStr(src, pos)~="[\]\},\s]|$")-1) ][1]
, ln, col, pos)
throw Exception(msg, -1, ch)
}
is_array := is_arr[obj := stack[1]]
if i := InStr("{[", ch)
{
val := (proto := args[i]) ? new proto : {}
is_array? ObjPush(obj, val) : obj[key] := val
ObjInsertAt(stack, 1, val)
is_arr[val] := !(is_key := ch == "{")
next := q . (is_key ? "}" : "{[]0123456789-tfn")
}
else if InStr("}]", ch)
{
ObjRemoveAt(stack, 1)
next := stack[1]==tree ? "" : is_arr[stack[1]] ? ",]" : ",}"
}
else if InStr(",:", ch)
{
is_key := (!is_array && ch == ",")
next := is_key ? q : q . "{[0123456789-tfn"
}
else
{
if (ch == q)
{
i := pos
while i := InStr(src, q,, i+1)
{
val := StrReplace(SubStr(src, pos+1, i-pos-1), "\\", "\u005C")
static end := A_AhkVersion<"2" ? 0 : -1
if (SubStr(val, end) != "\")
break
}
if !i ? (pos--, next := "'") : 0
continue
pos := i
val := StrReplace(val,    "\/",  "/")
, val := StrReplace(val, "\" . q,    q)
, val := StrReplace(val,    "\b", "`b")
, val := StrReplace(val,    "\f", "`f")
, val := StrReplace(val,    "\n", "`n")
, val := StrReplace(val,    "\r", "`r")
, val := StrReplace(val,    "\t", "`t")
i := 0
while i := InStr(val, "\",, i+1)
{
if (SubStr(val, i+1, 1) != "u") ? (pos -= StrLen(SubStr(val, i)), next := "\") : 0
continue 2
xxxx := Abs("0x" . SubStr(val, i+2, 4))
if (A_IsUnicode || xxxx < 0x100)
val := SubStr(val, 1, i-1) . Chr(xxxx) . SubStr(val, i+6)
}
if is_key
{
key := val, next := ":"
continue
}
}
else
{
val := SubStr(src, pos, i := RegExMatch(src, "[\]\},\s]|$",, pos)-pos)
static nullVar := ""
if InStr(",true,false,null,", "," . val . ",", true)
val := %val%
else if (Abs(val) == "") ? (pos--, next := "#") : 0
continue
val := val + 0, pos += i-1
}
is_array? ObjPush(obj, val) : obj[key] := val
next := obj==tree ? "" : is_array ? ",]" : ",}"
}
}
return tree[1]
}
Jxon_Dump(obj, indent:="", lvl:=1, UnicodeTransform:=false)
{
static q := Chr(34)
if lvl=
lvl:=1
if IsObject(obj)
{
static Type := Func("Type")
if Type ? (Type.Call(obj) != "Object") : (ObjGetCapacity(obj) == "")
throw Exception("Object type not supported.", -1, Format("<Object at 0x{:p}>", &obj))
is_array := 0
for k in obj
is_array := k == A_Index
until !is_array
static integer := "integer"
if indent is %integer%
{
if (indent < 0)
throw Exception("Indent parameter must be a postive integer.", -1, indent)
spaces := indent, indent := ""
Loop % spaces
indent .= " "
}
indt := ""
Loop, % indent ? lvl : 0
indt .= indent
lvl += 1, out := ""
for k, v in obj
{
if IsObject(k) || (k == "")
throw Exception("Invalid object key.", -1, k ? Format("<Object at 0x{:p}>", &obj) : "<blank>")
if !is_array
out .= ( ObjGetCapacity([k], 1) ? Jxon_Dump(k,"","",UnicodeTransform) : q . k . q )
.  ( indent ? ": " : ":" )
out .= Jxon_Dump(v, indent, lvl,UnicodeTransform)
.  ( indent ? ",`n" . indt : "," )
}
if (out != "")
{
out := Trim(out, ",`n" . indent)
if (indent != "")
out := "`n" . indt . out . "`n" . SubStr(indt, StrLen(indent)+1)
}
return is_array ? "[" . out . "]" : "{" . out . "}"
}
else if (ObjGetCapacity([obj], 1) == "")
return obj
if (obj != "")
{
obj := StrReplace(obj,  "\",    "\\")
, obj := StrReplace(obj,  "/",    "\/")
, obj := StrReplace(obj,    q, "\" . q)
, obj := StrReplace(obj, "`b",    "\b")
, obj := StrReplace(obj, "`f",    "\f")
, obj := StrReplace(obj, "`n",    "\n")
, obj := StrReplace(obj, "`r",    "\r")
, obj := StrReplace(obj, "`t",    "\t")
static needle := (A_AhkVersion<"2" ? "O)" : "") . "[^\x20-\x7e]"
if UnicodeTransform
while RegExMatch(obj, needle, m)
obj := StrReplace(obj, m[0], Format("\u{:04X}", Ord(m[0])))
}
return q . obj . q
}
monitorInfo(){
sysget,monitorCount,monitorCount
arr:=[],sorted:=[]
loop % monitorCount {
sysget,mon,monitor,% a_index
arr.push({l:monLeft,r:monRight,b:monBottom,t:monTop,w:monRight-monLeft+1,h:monBottom-monTop+1,ind: A_Index})
k:=a_index
while strlen(k)<3
k:="0" k
sorted[monLeft k]:=a_index
}
arr2:=[]
for k,v in sorted
arr2.push(arr[v])
return arr2
}
whichMonitor(x="",y="",byref monitorInfo=""){
CoordMode,mouse,screen
if (x="" || y="")
mousegetpos,x,y
if !IsObject(monitorInfo)
monitorInfo:=monitorInfo()
for k,v in monitorInfo
if (x>=v.l&&x<=v.r&&y>=v.t&&y<=v.b)
return [k,monitorInfo.maxIndex()]
}
WinVisible(hwnd)
{
WinGet, Style, Style ,ahk_id %hwnd%
Transform, Result, BitAnd, %Style%, 0x10000000
if Result <> 0
Return 1
Else
Return 0
}
controlvisible(hwnd){
controlget,v,visible,,,ahk_id %hwnd%
return v
}
GetNextWindow(hwnd,next=1,visibleWin=1){
result:=hwnd
Loop {
result:=DllCall("GetWindow", UInt, result, UINT, next?2:3, UINT)
if(!result)
return
else if(visibleWin && !WinVisible(result))
continue
else
return result
}
}
GetWindowOrder(hwnd="",visibleWin=1){
if !hwnd
hwnd:=winexist("ahk_pid " DllCall("GetCurrentProcessId"))
arr1:=[]
arr2:=[]
hwndP:=hwnd
loop {
hwndP:=GetNextWindow(hwndP,1,visibleWin)
if(hwndP=hwnd || !hwndP)
break
else
arr1.push(hwndP)
}
hwndN:=hwnd
loop {
hwndN:=GetNextWindow(hwndN,1,visibleWin)
if(hwndN=hwnd || !hwndP)
break
else
arr2.push(hwndN)
}
arr:=[],max:=arr1.maxIndex()
loop % max
arr.push(arr1[max+1-a_index])
for k,v in arr2
arr.push(v)
return {array: arr, index: max+1}
}
WinInsertAfter(hwnd, after){
return DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", after, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
}
WinStack(ByRef arr){
for k,v in arr {
if(k=1)
winactivate,% v
else if (v)
WinInsertAfter(v, last)
last:=v?v:last
}
}
AltTab_window_list()
{
WS_EX_CONTROLPARENT =0______
WS_EX_APPWINDOW =0______
WS_EX_TOOLWINDOW =0x80
WS_DISABLED =0x8000000
WS_POPUP =0x80000000
AltTab_ID_List :=[]
AltTab_ID_List_i :=0
WinGet, Window_List, List
id_list =
Loop, %Window_List%
{
wid := Window_List%A_Index%
WinGetTitle, wid_Title, ahk_id %wid%
WinGet, Style, Style, ahk_id %wid%
If ((Style & WS_DISABLED) or ! (wid_Title))
Continue
WinGet, es, ExStyle, ahk_id %wid%
Parent := Decimal_to_Hex( DllCall( "GetParent", "uint", wid ) )
WinGetClass, Win_Class, ahk_id %wid%
WinGet, Style_parent, Style, ahk_id %Parent%
If ((es & WS_EX_TOOLWINDOW)
or ((es & ws_ex_controlparent) and ! (Style & WS_POPUP) and !(Win_Class ="#32770") and ! (es & WS_EX_APPWINDOW))
or ((Style & WS_POPUP) and (Parent) and ((Style_parent & WS_DISABLED) =0)))
continue
AltTab_ID_List_i ++
wingetclass,cl,ahk_id %wid%
wingettitle,ti,ahk_id %wid%
AltTab_ID_List.push({hwnd:wid, title: ti, class: cl})
}
return AltTab_ID_List
}
Decimal_to_Hex(var)
{
SetFormat, integer, hex
var += 0
SetFormat, integer, d
return var
}
HasVal(haystack, needle) {
for index, value in haystack
if (value = needle)
return index
if !IsObject(haystack)
throw Exception("Bad haystack!", -1, haystack)
return 0
}
getFocusedHwnd(){
static GuiThreadInfoSize = 48
VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize)
,NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)
,DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)
return FocusedHWND := NumGet(GuiThreadInfo, 12)
}
RegExSplit(txt, regex){
i:=0, j:=1
,a:=[], b:=[]
while i:=RegExMatch(txt, regex, match, j) {
a.push(SubStr(txt,j,i-j))
,b.push(match)
,j:=i+StrLen(match)
}
a.push(SubStr(txt,j))
return {split: a, match: b}
}
RegExReplaceFn(txt, regex, Fn, ByRef List="", ByRef Dict="", params=""){
if !IsFunc(Fn) || !IsFunc(Fn:=Func(Fn))
return
if RegExMatch(regex, "^[\w``r``n``a]+\)", match) && !InStr(match, "O")
regex:="O" regex
else
regex:= "O)" regex
i:=0, j:=1
,str:=""
out:= IsObject(list) || IsObject(dict)
while i:=RegExMatch(txt, regex, match, j) {
str.=SubStr(txt,j, i-j)
,str.=(params=""?Fn.call(match):Fn.call(match, params))
if(out){
tmp1:=[], tmp2:=[]
Loop % match.Count()+1 {
tmp1[A_Index-1]:=(val:=match.value(A_Index-1))
if((name:=match.Name(A_Index-1))!="")
tmp2["" name]:=val
}
list.push(tmp1)
,dict.push(tmp2)
}
j:=i+match.len(0)
}
return str SubStr(txt, j)
}
RegExMatchAll(txt, regex){
if RegExMatch(regex, "^[\w``r``n``a]+\)", match) && !InStr(match, "O")
regex:="O" regex
else
regex:= "O)" regex
i:=0, j:=1
,list:=[], dict:=[]
while i:=RegExMatch(txt, regex, match, j) {
tmp1:=[], tmp2:=[]
Loop % match.Count()+1 {
tmp1[A_Index-1]:=(val:=match.value(A_Index-1))
if((name:=match.Name(A_Index-1))!="")
tmp2["" name]:=val
}
list.push(tmp1)
,dict.push(tmp2)
,j:=i+match.len(0)
}
return {list: list, dict: dict}
}
Bin_Hex(ByRef Bin,Len,Chunks=32, Div="|") {
bytes:=Chunks/8
strint:=A_FormatInteger
SetFormat, IntegerFast, H
line:=""
Loop, %Len% {
chunk:=NumGet(Bin,A_Index-1, "UChar")
chunk:=SubStr("00" . SubStr(chunk,3), -1)
if (!Mod(A_Index-1,bytes) && Chunks!=0)
line.=Div
line.=chunk
}
SetFormat, IntegerFast, %strint%
Return line
}
Hex_Bin(ByRef bin, hex) {
Static fun
If (fun = "") {
h:="568b74240c8a164684d2743b578b7c240c538ac2c0e806b109f6e98ac802cac0e104880f8"
. "a164684d2741a8ac2c0e806b309f6eb80e20f02c20ac188078a16474684d275cd5b5f5ec3"
VarSetCapacity(fun,StrLen(h)//2)
Loop % StrLen(h)//2
NumPut("0x" . SubStr(h,2*A_Index-1,2), fun, A_Index-1, "Char")
}
VarSetCapacity(bin,StrLen(hex)//2)
dllcall( &fun, "uint",&bin, (A_IsUnicode ? "AStr" : "Str"),hex, "cdecl" )
}
Crypt_AES(pData, nSize, sPassword, SID = 256, bEncrypt = True)
{
CALG_AES_256 := 1 + CALG_AES_192 := 1 + CALG_AES_128 := 0x660E
CALG_SHA1 := 1 + CALG_MD5 := 0x8003
DllCall("advapi32\CryptAcquireContextA", "UintP", hProv, "Uint", 0, "Uint", 0, "Uint", 24, "Uint", 0xF0000000)
DllCall("advapi32\CryptCreateHash", "Uint", hProv, "Uint", CALG_SHA1, "Uint", 0, "Uint", 0, "UintP", hHash)
DllCall("advapi32\CryptHashData", "Uint", hHash, "Uint", &sPassword, "Uint", StrLen(sPassword), "Uint", 0)
DllCall("advapi32\CryptDeriveKey", "Uint", hProv, "Uint", CALG_AES_%SID%, "Uint", hHash, "Uint", SID<<16, "UintP", hKey)
DllCall("advapi32\CryptDestroyHash", "Uint", hHash)
If	bEncrypt
DllCall("advapi32\CryptEncrypt", "Uint", hKey, "Uint", 0, "Uint", True, "Uint", 0, "Uint", pData, "UintP", nSize, "Uint", nSize+16)
Else	DllCall("advapi32\CryptDecrypt", "Uint", hKey, "Uint", 0, "Uint", True, "Uint", 0, "Uint", pData, "UintP", nSize)
DllCall("advapi32\CryptDestroyKey", "Uint", hKey)
DllCall("advapi32\CryptReleaseContext", "Uint", hProv, "Uint", 0)
Return	nSize
}
releasePressed(candidates="LButton,RButton,MButton", autoRepress=false){
pressed:=""
loop,parse,candidates,`,
{
if A_LoopField && GetKeyState(A_LoopField){
pressed.=A_LoopField ","
try
send % "{" A_LoopField 	" UP}"
}
}
if (autoRepress){
if autoRepress=1
autoRepress=1000
SetTimerF("rePress", (-1)*abs(autoRepress), [pressed])
}
return pressed
}
rePress(pressList){
Loop,Parse,pressList,`,
{
if A_LoopField {
try
send % "{" A_LoopField 	" DOWN}"
}
}
}
DetectHiddenWindows,on
RisImpaxLoadPw(ByRef RisImpaxDecodePw="", iniPath:=""){
static fileName:="RisImpaxPw.ini"
ret:={Ris:[], Impax:[]}
if FileExist(path:=iniPath) || FileExist(path:=A_ScriptDir "\" fileName)
|| FileExist(path:=A_ScriptDir "\..\" fileName)
|| FileExist(path:=SubStr(A_ScriptDir,1,1) ":\scripts\Radiology\" fileName)
|| FileExist(path:=SubStr(A_ScriptDir,1,1) ":\scripts\Autorun\" fileName) {
fileread,RisImpaxPwData,% path
if InStr(RisImpaxPwData, "ENCRYPT"){
if(RisImpaxDecodePw!="")
AES_pw := RisImpaxDecodePw
else
InputBox,AES_pw,,Decrypt pw,Hide
Hex_Bin(enc_dec,RisImpaxPwData:=RegExReplace(RisImpaxPwData, "^\s*ENCRYPT", ""))
,size:=Crypt_AES(&enc_dec, floor(strlen(RisImpaxPwData)/2), AES_pw, 256, 0)
,RisImpaxPwData:=substr(substr(enc_dec,1,size),1,size-160)
if InStr(RisImpaxPwData,"user1="){
ret.RisImpaxDecodePw:=RisImpaxDecodePw:=AES_pw
,ret.path := path
,fe:=A_FileEncoding
FileDelete,% tmppath:=A_ScriptDir "\RisImpaxPwTmp.ini"
FileAppend,% RisImpaxPwData,% tmppath,utf-8-Raw
tmp:=true
}else{
MsgBox, 53, , Password error
IfMsgBox,Retry
return RisImpaxLoadPw()
else
return ret
}
}
loop {
IniRead,user,% tmppath,RIS,% "user" A_Index,% "$%^&*"
IniRead,pw,% tmppath,RIS,% "pw" A_Index
if(user!="$%^&*") && (user!="ERROR")
ret.Ris.push({user: user, pw: iniSpecialChar(pw)})
else
break
}
loop {
IniRead,user,% tmppath,IMPAX,% "user" A_Index,% "$%^&*"
IniRead,pw,% tmppath,IMPAX,% "pw" A_Index
if(user!="$%^&*") && (user!="ERROR")
ret.Impax.push({user: user, pw: iniSpecialChar(pw)})
else
break
}
if(tmp)
FileDelete,% tmppath
return ret
}
}
__RisImpaxPwEncrypt(str="", pw=""){
if str=
str:=clipboard
if pw =
pw := "scsnakeAutoHotkey"
enc_dec:=str
loop % 10
enc_dec.="0123456789abcdef"
size:=Crypt_AES(&enc_dec, strlen(enc_dec), pw, 256, 1)
,aes:=Bin_Hex(enc_dec,size,32,"")
return aes
}
refreshRisImpaxEncrypt(){
old:=RisImpaxLoadPw()
,str:="[RIS]`n"
InputBox,new_pw,,new portal pw,
for k,v in old.RIS
str.= "user" k "=" v.user "`n"
,str.= "pw" k "=" new_pw "`n"
str.="[IMPAX]`n"
for k,v in old.Impax
str.= "user" k "=" v.user "`n"
,str.= "pw" k "=" new_pw "`n"
if(old.path){
FileDelete,% old.path
FileAppend,% "ENCRYPT" __RisImpaxPwEncrypt(str, old.RisImpaxDecodePw),% old.path,utf-8-Raw
}
}
iniSpecialChar(pw){
return RegExReplaceFn(pw, "i)\\x([a-f\d]+)\\", "_Chr2")
}
_Chr2(c){
return Chr("0x" c.1)
}
RisImpaxPollingInit(){
static exeNAme:="RisImpaxPolling.exe"
if (hwnd:=WinExist("RisImpaxPolling_Main ahk_class AutoHotkeyGUI")) || (hwnd:=WinExist("ahk_exe " exeName)){
SetTimer,RisImpaxPollingNotExist,off
return hwnd
}
if FileExist(path:=A_ScriptDir "\" exeName) || FileExist(path:=A_ScriptDir "\..\" exeName) || FileExist(path:=A_ScriptDir "\RisImpaxPolling\" exeName) || FileExist(path:=A_ScriptDir "\..\RisImpaxPolling\" exeName) || FileExist(path:=SubStr(A_ScriptDir,1,1) ":\scripts\Radiology\RisServer\" exeName)  || FileExist(path:=A_ScriptDir "\..\simpleRIS\" exeName) {
Run % path
winwait,% "ahk_exe " exeName,,3
if (!ErrorLevel){
return RisImpaxPollingInit()
}
}
SetTimer,RisImpaxPollingNotExist,500
return 0
}
RisImpaxPollingNotExist(){
global
RisState:=risOpened(), impaxState:=impaxOpened()
}
RisImpax__tooltip(){
ToolTip
}
RisImpaxRegister(infoJson){
if !(hwnd:=RisImpaxPollingInit()){
return 1
}
thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))
for k,v in infoJson {
if (v.msg.msg && v.func && v.func!=OnMessage(v.msg.msg))
OnMessage(v.msg.msg, v.func)
if (v.func && v.initStart)
SetTimerF(v.func, (-1)*v.initStart)
if !WinExist("ahk_id " v.hwnd)
infoJson[k, "hwnd"]:=thisHwnd
}
Send_WM_COPYDATA(hwnd, 0, JXON_Dump(infoJson))
,SetTimerF("RisImpaxRegisterMonitor", 30000, [hwnd, infoJson])
}
RisImpaxRegisterMonitor(hwnd, infoJson){
if !WinExist("ahk_id " hwnd)
if (hwnd:=RisImpaxPollingInit())
Send_WM_COPYDATA(hwnd, 0, JXON_Dump(infoJson))
,SetTimerF("RisImpaxRegisterMonitor", 0)
,SetTimerF("RisImpaxRegisterMonitor", 30000, [hwnd, infoJson])
}
RisImpaxMsgProtocol(){
global
local k,v
registerRisChangeMsg:=[0x1000, 0x1003]
,registerRisChangeItem:=["ris", "risAcc", "risReport", "risOldReport"]
,registerImpaxChangeMsg:=[0x2000,0x2001]
,registerImpaxChangeItem:=["impax", "impaxAcc"]
,RisImpaxChangeMsg2Item:=[]
,RisImpaxChangeItem2Msg:=[]
loop % registerRisChangeMsg.2-registerRisChangeMsg.1+1 {
RisImpaxChangeMsg2Item[registerRisChangeMsg.1+A_Index-1]:=registerRisChangeItem[A_Index]
,RisImpaxChangeItem2Msg[registerRisChangeItem[A_Index]]:=registerRisChangeMsg.1+A_Index-1
}
loop % registerImpaxChangeMsg.2-registerImpaxChangeMsg.1+1 {
RisImpaxChangeMsg2Item[registerImpaxChangeMsg.1+A_Index-1]:=registerImpaxChangeItem[A_Index]
,RisImpaxChangeItem2Msg[registerImpaxChangeItem[A_Index]]:=registerImpaxChangeMsg.1+A_Index-1
}
}
checkRIS(byref RisState,refresh=1){
SetTitleMatchMode,2
winget,winList,list,放射線資訊管理系統(Radiology Information System)
match:=0
loop % winList
{
wingetclass, winClass,% "ahk_id " id:=winList%a_index%
if instr(winClass,"WindowsForms10.Window.8.app.") && id=RisState[2] {
match:=1
break
}
}
if (!match && refresh){
if !IsObject(RisState)
RisState:=[]
for k,v in RisOpened()
RisState[k]:=v
}
return match
}
RisOpened(allRis=0)
{
alttabList:=AltTab_window_list()
if(allRis=0){
for k,v in alttabList
if InStr(v.title, "放射線資訊管理系統(Radiology Information System)") && winvisible(v.hwnd){
winget,pname,ProcessName,% "ahk_id " v.hwnd
if (pname="Menu.exe"){
return Array(2, v.hwnd)
}
}
winget,winList,list,放射線資訊管理系統(Radiology Information System)
winget,activeWin,id,A
loop % winList
{
if !winvisible(winList%a_index%)
continue
wingetclass, winClass,% "ahk_id " winList%a_index%
if instr(winClass,"WindowsForms10.Window.8.app."){
return array(2,winList%a_index%)
}
}
winget,winList,list,RIS系統登入<<陽明資訊>>
loop % winList
{
if !winvisible(winList%a_index%)
continue
wingetclass, winClass,% "ahk_id " winList%a_index%
if instr(winClass,"WindowsForms10.Window.8.app."){
return array(1,winList%a_index%)
}
}
return array(0,0)
}else{
ret:=[[],[]]
for k,v in alttabList
if InStr(v.title, "放射線資訊管理系統(Radiology Information System)") {
winget,pname,ProcessName,% "ahk_id " v.hwnd
if(pname="Menu.exe")
ret[2].push(v.hwnd)
}
winget,winList,list,放射線資訊管理系統(Radiology Information System) ahk_exe Menu.exe
loop % winList
if !HasVal(ret[2], hwnd:=winList%a_index%)
ret[2].push(hwnd)
for k,v in alttabList
if InStr(v.title, "RIS系統登入<<陽明資訊>>") {
winget,pname,ProcessName,% "ahk_id " v.hwnd
if(pname="Menu.exe") && winvisible(v.hwnd)
ret[1].push(v.hwnd)
}
winget,winList,list,RIS系統登入<<陽明資訊>> ahk_exe Menu.exe
loop % winList
if !HasVal(ret[1], hwnd:=winList%a_index%) && winvisible(hwnd)
ret[1].push(hwnd)
}
return ret
}
GetControls(hwnd, controls="")
{
if !isobject(controls)
controls:=[]
if isobject(hwnd){
for k,v in hwnd
controls:=GetControls(v, controls)
return controls
}
winget,classnn,ControlList,ahk_id %hwnd%
winget,controlId,controllisthwnd,ahk_id %hwnd%
loop,parse,classnn,`n
{
controls[a_index]:=[]
controls[a_index]["ClassNN"]:=a_loopfield
}
loop,parse,controlId,`n
{
controls[a_index]["Hwnd"]:=a_loopfield
controlgetText,txt,,ahk_id %a_loopfield%
controls[a_index]["text"]:=txt
}
return controls
}
GetOtherControl(refHwnd,shift,controls,type="hwnd"){
for k,v in controls
if v[type]=refHwnd
return controls[k+shift].hwnd
}
ImpaxOpened()
{
winget,ImpaxIdList,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098
winget,activeWin,id,A
arr:=[],ind1:=ind2:=ind3:=0,a1:=a2:=a3:=0
arr[1]:=0
loop 5
arr[2,a_index]:=0
loop % ImpaxIdList
{
id:=ImpaxIdList%a_index%
wingettext,text,ahk_id %id%
if ind:=instr(text,"STUDY_NAV_TOOLBAR0"){
ind1:=ind,a1:=a_index,arr[2,1]:=id
}
if((instr(text,"工作清單")&&instr(text,"相關性")&&instr(text,"更新"))||(instr(text,"Worklists")&&instr(text,"Relevance")&&instr(text,"Refresh"))){
if((instr(text,"臨床資訊")&&instr(text,"RIS 狀態")&&instr(text,"病患 HIS 代碼"))||(instr(text,"Clinical Information")&&instr(text,"RIS Status")&&instr(text,"Patient HIS Code"))){
ind2:=instr(text,"臨床資訊")|instr(text,"Clinical Information")
a2:=a_index,arr[2,2]:=id
}else{
ind3:=instr(text,"工作清單")|instr(text,"Worklists")
a3:=a_index,arr[2,3]:=id
}
}
wingetpos,,,,h,ahk_id %id%
if (maxH<h)
maxH:=h
}
h:=maxH
h-=41
if (arr[2,1]||arr[2,2]||arr[2,3]){
arr[1]:=2
if(arr[2,1]=(arr[2,2]|arr[2,3])){
arr[2,5]:=1
if ((bar:=impaxBar(arr[2,2]|arr[2,3])).h>h){
arr[2,4]:=2
}else if(ind1<(ind2|ind3)){
arr[2,4]:=1
}else {
arr[2,4]:=3
}
}else{
arr[2,5]:=2
if(a1<(a2|a3)){
arr[2,4]:=1
}else if(impaxBar(arr[2,2]|arr[2,3]).h>h){
arr[2,4]:=2
}else{
arr[2,4]:=3
}
}
return arr
}
loop % ImpaxIdList
{
id:=ImpaxIdList%a_index%
wingettext,text,ahk_id %id%
if (instr(text,"登入") && instr(text,"密碼") && instr(text,"選項")) || (instr(text,"Login") && instr(text,"Options") && instr(text,"User ID"))
return array(1,array(id))
}
return array(0,0)
}
GetControlIdByText(byref arr,RefControlText,offset=0,UseRegEx=0)
{
if !isobject(arr)||!arr.maxIndex()
return
k=0
if UseRegEx
{
for k,v in arr
if RegExMatch(v.text,RefControltext)
break
}
else
{
for k,v in arr
if v.text=RefControltext
break
if !k
for k,v in arr
if instr(v.text,RefControltext)
break
}
if !offset
i:=k
else
{
i:=k+offset
l:=arr.MaxIndex()
while i>l
i-=l
while i<1
i+=l
}
return (k=0 ? 0 : arr[i]["Hwnd"])
}
GetRisPath(direct=0){
if(direct=0){
if fileexist(path:=a_desktop "\放射線資訊管理系統(Radiology Information System).appref-ms")
return path
if fileexist(path:=a_desktop "\RIS.appref-ms")
return path
if fileexist(path:=A_StartMenu "\Programs\放射線資訊管理系統(Radiology Information System).appref-ms")
return path
if fileexist(path:=A_StartMenu "\程式集\放射線資訊管理系統(Radiology Information System).appref-ms")
return path
if fileexist(path:=A_StartMenu "\Programs\陽明資訊\RIS.appref-ms")
return path
if fileexist(path:=A_StartMenu "\程式集\陽明資訊\RIS.appref-ms")
return path
}
loop,HKCU,Software\Microsoft\Windows\ShellNoRoam\MUICache
if instr(a_loopregname,"Menu.exe") && fileexist(a_loopregname)
return a_loopregname
loop,HKCU,Software\Microsoft\Internet Explorer\TypedURLs
{
regread,v
if instr(a,"Menu.exe") && fileexist(v)
return v
}
if (a:=searchFile("Menu.exe",substr(a_windir,1,3) "Documents and Settings\" a_username "\Local Settings\Apps\2.0")).maxindex()
return a[a.maxindex()]
return 0
}
ListControls(hwnd, obj=0, arr="")
{
if !isobject(arr)
arr:=[]
if isobject(hwnd){
for k,v in hwnd
arr:=ListControls(v, 1, arr)
goto ListControlsReturn
}
str=
arr:=GetControls(hwnd)
ListControlsReturn:
if obj
return arr
for k,v in arr
str.="""" v["Hwnd"] """,""" v["ClassNN"] """,""" v["text"] """,""" getControlNameByHwnd(hwnd,v["Hwnd"]) """`n"
return str
}
ImpaxBar(impaxStateOrHwnd){
if isobject(impaxStateOrHwnd)
hwnd:=impaxStateOrHwnd[2,2] | impaxStateOrHwnd[2,3]
else
hwnd:=impaxStateOrHwnd
for k,v in (impaxControls:=getcontrols(hwnd)) {
if ((v.text="登出"||v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(impaxControls[k-2].classNN,"WindowsForms10.Window.8.app")) {
controlgetpos,x,y,w,h,,% "ahk_id " barId:=impaxControls[k-2].hwnd
break
}
}
return {hwnd:barId, x:x, y:y, w:w, h:h}
}
ImpaxSwitchPage(ImpaxStateArr,which=0,bar=""){
if !bar
bar:=ImpaxBar(ImpaxStateArr[2])
wingetpos,winx,winy,,,% "ahk_id " ImpaxStateArr[2]
if (which=0){
winactivate,% "ahk_id " ImpaxStateArr[2]
controlclick,,% "ahk_id " bar.hwnd
} else if (which=1) {
if(ImpaxState[1]) {
winactivate,% "ahk_id " ImpaxStateArr[1]
}else if !(bar.h>100) {
mouseclick,,% winx+bar.x+bar.w/3,% winy+bar.y+10,,0
}
}
}
getRisReports(risHwnd=""){
if !WinExist("ahk_id " RisHwnd)
RisHwnd:=risOpened()[2]
arr:=[]
for k,v in risControls:=getcontrols(risHwnd) {
if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {
temp:=k
break
}
}
for k,v in risControls {
if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app")) {
if(abs(k-temp)<18){
arr[1]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"],risControls[k+7]["hwnd"])
}else if (risControls[k-13,"text"]="歷史報告") || (risControls[k-12,"text"]="歷史報告") {
arr[2]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"],risControls[k+7]["hwnd"])
}else if (risControls[k-12,"text"]="報告版本查詢") || (risControls[k-11,"text"]="報告版本查詢") {
arr[3]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"])
}
}
}
return arr
}
getRisReportsHwnd(risHwnd){
for k,v in risControls:=getcontrols(risHwnd) {
if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {
temp:=k
break
}
}
for k,v in risControls {
if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && abs(k-temp)<13) {
return array(risControls[k+1]["hwnd"])
break
}
}
return []
}
getTextByHwnd(id){
controlgettext,t,,ahk_id %id%
return t
}
getImpaxInfo(ByRef impaxState, ByRef items){
params:=[]
if !IsObject(impaxState)
for k,v in impaxOpened()
if isobject(v)
for x,y in v
impaxState[k,x]:=y
else
impaxState[k]:=v
for k,v in items
if IsFunc(FuncName:="getImpax" v){
func:=func(FuncName), param:=[impaxState]
Loop % func.MaxParams-2
param.push("")
param.push(true)
,params.push(func.call(param*))
}
result:=getNetControls(params)
info:=[]
for k,v in items
info[v]:=ControlGetText(result[k].1)
return info
}
getImpaxExamDate(impaxHwnd){
arr:=[], sort:=[]
for k,v in ret:=getNetControl2(impaxHwnd,"","studyDateTimeLabel","","WindowsForms10.STATIC.app","","","",0)
arr.push(ControlGetText(v))
,loc:=Acc_Location(acc_ObjectFromWindow(v))
,sort[loc.x]:=k
arr2:=[]
for k,v in sort
arr2.push(arr[v])
return arr2
}
getImpaxChartNo(impaxStateOrHwnd="", returnFilter=false){
if isobject(impaxStateOrHwnd)
hwnd:=impaxStateOrHwnd[2,1]
else if (impaxStateOrHwnd)
hwnd:=impaxStateOrHwnd
else
hwnd:=impaxopened()[2,1]
if (returnFilter)
return {winHwnd: hwnd, controlName: "patientIdLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}
controlgettext,chartNo,,% "ahk_id " getNetControl2(hwnd,"","patientIdLabel","","WindowsForms10.STATIC.app","","","",0)[1]
if(chartNo="")
return
while strlen(chartNo)<7
chartNo:="0" chartNo
return chartNo
}
getImpaxUserId(impaxStateOrHwnd="", returnFilter=false){
if isobject(impaxStateOrHwnd)
hwnd:=impaxStateOrHwnd[2,2] | impaxStateOrHwnd[2,3]
else if (impaxStateOrHwnd)
hwnd:=impaxStateOrHwnd
else
hwnd:=impaxopened()[2,1]
if (returnFilter)
return {winHwnd: hwnd, controlName: "userIDLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}
controlgettext,UserId,,% "ahk_id " getNetControl2(hwnd,"","userIDLabel","","WindowsForms10.STATIC.app","","","",0)[1]
return UserId
}
getImpaxAccNo(impaxStateOrHwnd="",leftUpper=1, returnFilter=false){
if isobject(impaxStateOrHwnd)
hwnd:=impaxStateOrHwnd[2,1]
else if (impaxStateOrHwnd)
hwnd:=impaxStateOrHwnd
else
hwnd:=impaxopened()[2,1]
if (returnFilter)
return {winHwnd: hwnd, controlName: "accessionNumberLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}
if(leftUpper="")
leftUpper:=1
con:=getNetControl2(hwnd,"","accessionNumberLabel","","WindowsForms10.STATIC.app","","","",0)
controlgettext,AccNo,,% "ahk_id " selectControlByPos(con)
return AccNo
}
selectControlByPos(byref controlArr,mostLeft=1,mostUpper=0,first=1){
selected:=[],ind:=1
selected[ind]:=controlArr[1]
controlgetpos,cx,cy,,,,% "ahk_id " controlArr[1]
if(mostLeft=0&&mostUpper=0)
mostLeft:=1
for k,v in controlArr {
if k=1
continue
controlgetpos,x,y,,,,ahk_id %v%
if (x=cx && y=cy)
selected[++ind]:=v
else if  (((mostLeft=1 && x<cx) || (mostLeft=-1 && x>cx)) && mostUpper=0)
|| (((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)) && mostLeft=0)
|| (((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)) && ((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)))
|| ((x=cx) && mostUpper=0 && y<cy)
|| ((y=cy) && mostLeft=0 && x<cx)
selected:=[],ind:=1,selected[1]:=v
cx:=x,cy:=y
}
if(first)
return selected[1]
else
return selected
}
getChartNo(id){
return getRisChartNo(id)
}
getRisChartNo(hwnd){
static prvHwnd
for k,v in controls:=getcontrols(hwnd)
if RegExMatch(v.text,"^\w{6}\d$") && controls[k-1].text="病歷號"
chartNo:=v.text, prvHwnd:=v.hwnd
if(chartNo="")
chartNo:=ControlGetText(prvHwnd)
if chartNo!=
while strlen(chartNo)<7
chartNo:="0" chartNo
return chartNo
for k,v in getcontrols(hwnd)
if instr(v.classNN,"WindowsForms10.EDIT") && acc_objectfromwindow(v.hwnd).accName="病歷號"
{
controlgettext,str,,% "ahk_id " v.hwnd
return str
}
}
getRisChartNoHwnd(hwnd){
static prvHwnd
for k,v in controls:=getcontrols(hwnd)
if RegExMatch(v.text,"^\w{6}\d$") && controls[k-1].text="病歷號"
chartNo:=v.text,prvHwnd:=id:=v.hwnd
return prvHwnd
for k,v in getcontrols(hwnd)
if instr(v.classNN,"WindowsForms10.EDIT") && acc_objectfromwindow(v.hwnd).accName="病歷號"
{
return v.hwnd
}
}
getRisAccNo(hwnd){
return getRisSheetNo(hwnd)
}
getRisSheetNo(hwnd){
static prvHwnd
for k,v in controls:=getcontrols(hwnd)
if controls[k-1].text="照會單號" && regexmatch(v.text,"^\w{11}$") && instr(v.classNN,"WindowsForms10.EDIT")
{
prvHwnd:=v.hwnd
return v.text
}
return ControlGetText(prvHwnd)
}
getRisAccNoHwnd(risHwnd){
static prvHwnd
for k,v in controls:=getcontrols(risHwnd)
if controls[k-1].text="照會單號" && regexmatch(v.text,"^\w{11}$") && instr(v.classNN,"WindowsForms10.EDIT")
{
return prvHwnd:=v.hwnd
}
return prvHwnd
}
getRisHistoryId(hwnd){
static prvHwnd
for k,v in controls:=getControls(hwnd)
if (instr(v.classNN,"WindowsForms10.Window.8.app") && v.text="歷史報告" && instr(controls[k+3,"classNN"],"WindowsForms10.Window.8.app")){
if (controlId:=controls[k+3,"hwnd"])
return prvHwnd:=controlId
}
return prvHwnd
}
getRisHistoryIndex(dgHisReportAcc,rowAcc){
loop % acc_children(dgHisReportAcc).maxIndex()-1 {
check:=true
i:=a_index+1
loop % acc_children(acc_get("Object",1,0,dgHisReportAcc)).maxindex()-1 {
j:=A_Index
check:=check & (acc_get("Value",i "." j,0,dgHisReportAcc)=acc_get("Value",j,0,rowAcc))
}
if (check)
return i
}
return 0
}
searchFile(f,dir){
arr:=[]
originalWorkingDir:=A_WorkingDir
SetWorkingDir,% dir
loop,% f,0,1
arr.push(a_loopfilelongpath)
SetWorkingDir,% originalWorkingDir
return arr
}
searchRisChartNo(hwnd,AccNoOrChartNo, chartNo=""){
static prvHwnd
for k,v in controls:=getControls(hwnd)
if (instr(v.text,"查詢單號") && instr(v.classNN,"WindowsForms10.STATIC")){
thisHwnd:=prvHwnd:=controls[k+1].hwnd
break
}
if(!thisHwnd)
for k,v in controls
if (instr(v.text,"病歷號") && instr(v.classNN,"WindowsForms10.STATIC") && !instr(controls[k-3].text,"照會單號")){
thisHwnd:=prvHwnd:=controls[k+1].hwnd
, useChartNo:=true
break
}
if(!thisHwnd || (thisHwnd:=prvHwnd)){
controlfocus,,% "ahk_id " thisHwnd
controlsettext,,% useChartNo&&chartNo!=""?chartNo:AccNoOrChartNo,% "ahk_id " thisHwnd
controlsend,,{Enter},% "ahk_id " thisHwnd
return true
}
return false
}
parseDataGrid2(listHwnd="", RisHwnd="",ByRef childrenAcc="", wait=false, useCurrentClipboard=false, unselectAll=true){
if (!useCurrentClipboard){
if !listHwnd
listHwnd:=getRisList(RisHwnd)
if(childrenAcc && childrenAcc.maxIndex()<2)
return []
#ClipboardTimeout 2000
clipboardOld:=ClipboardAll
,clipboard:=""
loop 3 {
if(childrenAcc && winvisible(risHwnd))
selectAllRisList(childrenAcc)
else{
BlockInput,on
ControlFocus,,ahk_id %listHwnd%
controlsend,,^a,ahk_id %listHwnd%
BlockInput,off
}
Sleep % 500*(A_Index)
BlockInput,on
ControlFocus,,ahk_id %listHwnd%
controlsend,,^c,ahk_id %listHwnd%
BlockInput,off
if Wait
ClipWait,% wait+0
else
ClipWait,% 2+(A_Index*3)
if !ErrorLevel
break
WinClose,,Can't open clipboard for reading
}
if(clipboard=""){
ToolTip % "Copy failed!"
return -1
}
data:=Clipboard
,clipboard:=clipboardOld
}else{
data:=clipboard
}
output:=[]
Loop,parse,data,`n
{
row:=[]
,txt:=A_LoopField
loop,parse,txt,`t
row.push(Trim(A_LoopField))
output.push(row)
}
ret:=new DataGridTable(output)
if(unselectAll)
if childrenAcc
unselectAllRisList(childrenAcc)
else if listHwnd
controlsend,,^{Home},% "ahk_id " listHwnd
return ret
}
class DataGridTable {
__New(ByRef data){
this.titles:=data[1]
,this.colNos:=[]
,this.data:=data.clone()
for k,v in this.titles
if (v!="")
this.colNos[v]:=k
this.colNos["AccNo"]:=this.colNos["照會單號"]
,this.colNos["ChartNo"]:=this.colNos["病歷號"]
,this.colNos["ExamName"]:=this.colNos["檢查名稱"]
,this.colNos["Status"]:=this.colNos["狀態"]
,this.colNos["ExamDate"]:=this.colNos["檢查日"]
,data.base:=this
return data
}
_NewEnum(){
this.enum_ind:=0
,this.data_ind_max:=this.data.maxIndex()
return this
}
Next(ByRef k, ByRef v){
k:=++this.enum_ind
,v:=new this.base.base.DataGridRow(this.base.data[k], this.base.colNos, k)
return k<=this.data_ind_max
}
class DataGridRow {
__New(ByRef data, colNos, rowNo){
this.colNos:=colNos
,this.data:=data.clone()
,this.rowNo:=rowNo
,data.base:=this
return data
}
getColNo(colName){
return this.colNos[colName]
}
getCell(colName){
return this[this.getColNo(colName)]
}
}
getColNo(colName){
return this.colNos[colName]
}
getCell(row, colName){
return this[row][this.getColNo(colName)]
}
getRow(rowOrColName, value=""){
if (value!="")
return this.getRowByVal(rowOrColName, value)
else
return (r:=this[rowOrColName])?new this.DataGridRow(r, this.colNos, rowOrColName):""
}
getRowByVal(colName, value){
col:=this.getColNo(colName)
for k,v in this {
if (v[col]=value) && (k!=1){
return new this.DataGridRow(v, this.colNos, k)
}
}
}
getRowsByVal(colName, value){
col:=this.getColNo(colName)
,ret:=[]
for k,v in this {
if (v[col]=value) && (k!=1){
ret[k]:=new this.DataGridRow(v, this.colNos)
}
}
return ret
}
}
parseDataGrid(hwnd,byref output="",is_acc=0,limit=0,sleep=0,start="",callback=""){
if(is_acc=0)
acc:=acc_ObjectFromWindow(hwnd)
,rows:=acc_children(acc)
else if(is_acc=1)
rows:=hwnd
rowsCount:=rows.maxIndex()
if (output="")
output:=[]
if (isobject(start) && !isobject(limit)){
for k,v in rows {
cells:=acc_children(v)
if(cells[0+start.1].accValue=start.2)
found:=k
else if(limit && found && k-found>limit-1)
break
tmp:=[]
for x,y in cells
tmp[x]:=y.accValue
output[x,y]:=tmp
%callback%(k, v, cells, tmp)
if (sleep)
sleep % sleep
}
}else if (!isobject(limit)){
if (start="" || start=0)
start:=1
loop {
if (limit && a_index>limit)
break
if (k:=start+a_index-1)>rowsCount
break
tmp:=[]
for x,y in cells:=acc_children(row:=rows[k])
tmp[x]:=y.accValue
output[k]:=tmp
%callback%(k, row, cells, tmp)
if (sleep)
sleep % sleep
}
}else{
k1:=limit.1&&limit.1>=1&&limit.1<=rows.maxIndex()?limit.1:1
if(limit.maxIndex()=1)
k2:=k1
else
k2:=limit.2&&limit.2<=rows.maxindex()&&limit.2>=1?limit.2:rows.maxIndex()
loop % abs(k2-k1)+1 {
ind:=k2>=k1?a_index-1+k1:k1-a_index+1
if (ind> rowsCount)
break
tmp:=[]
for x,y in cells:=acc_children(row:=rows[ind])
tmp[x]:=y.accValue
output[ind]:=tmp
%callback%(ind, row, cells, tmp)
if(sleep)
sleep % sleep
}
}
return rowsCount
}
getRisMenu(){
global menuHwnd=0
EnumAddress := RegisterCallback("EnumProc")
DllCall("EnumWindows", "Ptr", EnumAddress, "Ptr", 0)
return menuHwnd
}
EnumProc(hwnd, lParam)
{
global menuHwnd
if (DllCall("GetWindowLong",Ptr,hwnd,Int,-20)=0______){
if ((acc:=acc_children(acc_objectfromwindow(hwnd))).maxindex()=6 && acc[1].accName="瀏覽影像"){
menuHwnd:=hwnd
return false
}
}
return true
}
getRisExamItems(hwnd){
static prvHwnd
for k,v in getcontrols(hwnd) {
if (instr(name:=getControlNameByHwnd(hwnd,v.hwnd),"EXAMITEM")) {
return prvHwnd:=v.hwnd
}
}
return prvHwnd
}
parseRisExamItems(hwnd){
arr:=[[],[]]
acc:=acc_objectFromWindow(hwnd)
if !acc
return arr
loop % acc_children(acc).maxindex()-1 {
i:=a_index+1
str:=acc_get("Value",i ".2",0,acc)
if(str="")
continue
if instr(str,"※")
arr[1].push(RegExReplace(str,"※"))
arr[2].push(RegExReplace(str,"※"))
}
return arr
}
parseRisHistory(hwnd){
arr:=[]
if !acc:=acc_objectfromwindow(hwnd)
return arr
for i,j in rows:=acc_children(acc) {
if i=1
continue
for x,y in acc_children(v)
arr[i-1,x]:=y.accValue
}
return arr
}
getRisHistory(hwnd){
static prvHwnd
for k,v in getcontrols(hwnd) {
if (getControlNameByHwnd(hwnd,v.hwnd)="dgHisReport") {
return prvHwnd:=v.hwnd
}
}
return prvHwnd
}
LineBreakConvert(str){
return regexreplace(regexreplace(str,"\r",""),"\n","`r`n")
}
getSEIM(ImpaxState="", recur=0){
if !impaxstate
impaxstate:=impaxOpened()
if IsObject(impaxState)
impaxImageHwnd:=impaxState[2,1]
else
impaxImageHwnd:=impaxState
SEIM:=getNetControl2(impaxImageHwnd,"","DicomImageNumbers","","WindowsForms10.STATIC.app","","","",0)
for k,v in SEIM
if RegExMatch(text:=controlgettext(v),"i)S:\s+(\d+)\s+I:\s+(\d+)",match)
break
if (match1=""){
SEIM:=getNetControl2(impaxImageHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)
for k,v in SEIM
if RegExMatch(text:=controlgettext(v),"i)S:\s+(\d+)\/\d+\s+I:\s+(\d+)",match)
break
}
if (match1="" && recur<3){
mousemove,-1,-1,1,R
mousemove,1,1,1,R
return getSEIM(ImpaxState, recur+1)
}
return [match1,match2]
}
RisExamEditInfo(RisHwnd="",RisExamHwnd=""){
if !rishwnd && !risexamhwnd
risHwnd:=risOpened()[2]
if !risexamhwnd
risexamhwnd:=getRisReports(risHwnd)[1,1]
Edit_GetSel(risexamhwnd,start,end)
return {id: risexamhwnd, start: start,end: end}
}
getReportHint(risHwnd){
static prvHwnd
return ControlGetText((h:=acc_windowfromobject(getNetAcc(risHwnd,"REPORT_HINT","WindowsForms10.STATIC")))?(prvHwnd:=h):prvHwnd)
}
getIndication(RisHwnd="",filter=1){
static prvHwnd
if !WinExist(risHwnd)
risHwnd:=risOpened()[2]
thisHnwd:=(indication:=getNetControl2(RisHwnd,"","REPORT_HINT","","WindowsForms10.STATIC.app","","","",0))[1]?indication[1]:prvHwnd
if regexmatch(controlgettext(thisHwnd),"Indication:([^\n\r]*)",match) || regexmatch(controlgettext(indication[1]),"Indication:([^\n\r]*)",match) {
str:=match1
}else{
for k,v in getControls(RisHwnd)
if regexmatch(v.text,"Indication:([^\n\r]*)",match) {
str:=match1
break
}
}
str:=RegExReplace(trim(str),"[^\w\+\)]+$","")
if(filter=1){
str:=RegExReplace(str,"is)(.+?)(有.+)?","$1")
}
return trim(str)
}
getRisClinicalInfoHwnd(RisHwnd){
static prvHwnd
return (h:=getNetControl2(risHwnd,"","txtALL","","WindowsForms10.EDIT.app","","","",0)[1])?(prvHwnd:=h):prvHwnd
}
getIndicationText(RisHwnd){
clinicalHx:=getClinicalInfo(RisHwnd)
indication:=getIndication(RisHwnd)
if(indication="" && RegExMatch(clinicalHx,"is)\[The Others\]:([^\r\n\※]+)",match)){
indication:=Trim(match1)
}
if(indication="")
indication:="N/A"
return indication
}
getSeriesList(){
winget,impaxList,list,ahk_exe impax-client-main.exe ahk_class #32770,Slider1
SeriesList:=[]
loop % impaxList {
SeriesList.push(id:=impaxList%a_index%)
}
if impaxList && !seriesList.maxIndex()
return -1
monitorInfo:=monitorInfo()
List:=[]
for k,v in SeriesList {
for x,y in getControls(v)
if (y.ClassNN="SysListView321" && y.text="List1") {
WinGetPos,x,y,,,% "ahk_id " hwnd:=y.hwnd
Loop % (monitorInfo.maxIndex())
if(x<=monitorInfo[a_index].r && x>=monitorInfo[a_index].l && y>=monitorInfo[a_index].t && y<=monitorInfo[a_index].b){
List[A_Index]:=[v, hwnd]
break, 2
}
}
}
return List
}
getSeriesName(list="",screen=2){
if list=
list:=getSeriesList()
if isobject(list)
listAcc:=acc_objectfromwindow(listHwnd:=list[screen,2])
else
listAcc:=acc_objectfromwindow(list)
seriesName:=[],ch:=acc_children(listAcc),count:=ch.maxindex()
for k,v in ch {
if (k=count)
break
RegExMatch(acc_get("Name","",k,listAcc),"is)(\d+)\s*:\s*(\d+)\s*:\s*(.*)",match)
seriesName.push([match3,match2])
}
return seriesName
}
getViewFrame(ImpaxHwnd="", whichScreen=""){
if impaxHwnd=
impaxHwnd:=impaxOpened()[2,1]
if !impaxHwnd
return
if(whichScreen="")
whichScreen:=[1,2]
arr:=[]
for k,v in getControls(impaxHwnd)
if RegExMatch(v.ClassNN,"AfxWnd90u\d+") && RegExMatch(v.text,"Screen_(\d+)_format_\d+_Position_(\d)_(\d)",match) {
screen:=match1+1,x:=match2+1,y:=match3+1
if (!IsObject(whichScreen) && screen!=whichScreen)
|| (IsObject(whichScreen) && !eleInArr(screen, whichScreen))
continue
if !isobject(arr[screen])
arr[screen]:=[]
arr[screen,x,y]:=v.hwnd
}
return arr
}
eleInArr(e, a){
for k,v in a
if(v=e)
return true
return false
}
dragSeries(frameX,frameY=0,seriesInd=0,screen=2,ByRef seriesList="",frame=""){
CoordMode,mouse,screen
if (frame="")
frame:=getViewFrame()
if (seriesList="")
seriesList:=getSeriesList()
frameFlat:=[]
for k,v in frame[screen]
for m,n in v
frameFlat.push(n)
if !(frameHwnd:=frame[screen,frameX,frameY]) && !(frameHwnd:=frameFlat[frameX+frameY])
return
listAcc:=acc_objectfromwindow(listHwnd:=seriesList[screen,2])
,listWin:=seriesList[screen,1]
mousegetpos,mX,mY
if(seriesInd=0){
seriesLoc:={x:mX,y:mY,w:0,h:0}
}else if IsObject(seriesInd){
seriesLoc:={x: seriesInd.x, y: seriesInd.y}
}else{
seriesLoc:=acc_location(listAcc,seriesInd)
if (!seriesLoc.x || !seriesLoc.y)
return
}
if (seriesInd!=0 && !IsObject(seriesInd)){
wingetpos,x,y,w,h,ahk_id %listWin%
xMax:=0,columns:=0
loop % (seriesNum:=acc_children(listAcc).maxindex()-1) {
loc:=acc_location(listAcc,a_index)
if(loc.x>xMax){
xMax:=loc.x
}else{
columns:=a_index-1
break
}
}
controlsend,,{home},ahk_id %listHwnd%
Loop % floor(seriesInd/columns)
controlsend,,{down},ahk_id %listHwnd%
sleep 500
seriesLoc:=acc_location(listAcc,seriesInd)
}
wingetpos,fX,fY,fW,fH,% "ahk_id " frameHwnd
winactivate,ahk_id %listWin%
mousemove,% seriesLoc.x+seriesLoc.w/2,% seriesLoc.y+seriesLoc.h/2,0
send {lbutton down}
sleep 100
mousemove,% fX+fW/2,% fY+20,2
send {lbutton up}
mousemove,% mX,% mY,0
}
mouseDragSeries(originalXY, originalWin, targetFrame){
WinActivate,ahk_id %originalWin%
mousemove,% originalXY.x,% originalXY.y,0
send {LButton Down}
Sleep 100
WinGetPos,x,y,w,h,ahk_id %targetFrame%
MouseMove, % x+w/2, % y+20,2
send {LButton up}
}
toggleSeriesList(impaxState="", action="toggle", for="all", ByRef monitorInfo="", activate=false){
static seriesListStored:=[]
, impaxControlList:=[]
if !IsObject(impaxState)
impaxState:=impaxOpened()
if !WinExist("ahk_exe impax-client-main.exe") || (impaxState[1]!=2 && impaxState[2,4]!=1)
return
if IsObject(for){
for k,v in for
ret:=toggleSeriesList(impaxState, action, v, monitorInfo, activate)
return ret
}
screenNo:=(for+0)*2-1
if screenNo is number
{
if WinExist("ahk_id " seriesListStored[screenNo]) && winvisible(seriesListStored[screenNo]) && WinExist("ahk_id " seriesListStored[screenNo+1]) {
if (((winvisible(seriesListStored[screenNo+1]))=(action="off")) || (action="toggle")){
pressed:=releasePressed()
ControlClick,,% "ahk_id " seriesListStored[screenNo]
rePress(pressed)
}
return seriesListStored
}else{
if !IsObject(monitorInfo)
monitorInfo:=monitorInfo()
seriesListButton:=[]
loop 2 {
for k,hwnd in impaxControlList {
impaxId:=hwnd
for k,v in (impaxControls:=getcontrols(impaxId)){
if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {
WinGetPos,x,y,,,% "ahk_id " v.hwnd
Loop % (monitorInfo.maxIndex())
if(x<=monitorInfo[a_index].r && x>=monitorInfo[a_index].l && y>=monitorInfo[a_index].t && y<=monitorInfo[a_index].b){
seriesListButton[A_Index]:=v.hwnd
break
}
}
}
}
if (!seriesListButton.maxIndex()){
winget,impaxListCount,list,ahk_exe impax-client-main.exe
impaxControlList:=[]
loop % impaxListCount
impaxControlList.push(impaxListCount%a_index%)
}else
break
}
for k,v in seriesListButton
seriesListStored[k*2-1]:=v
for k,v in seriesList:=getSeriesList()
seriesListStored[2*k]:=v.1
if (winvisible(sHwnd:= seriesListStored[screenNo+1])=(action="off")) || (action="toggle") {
pressed:=releasePressed()
ControlClick,,% "ahk_id " seriesListStored[screenNo]
if(action="off")
WinHide, % "ahk_id " sHwnd
else if(action="on")
WinShow, % "ahk_id " sHwnd
rePress(pressed)
}
return seriesListStored
}
}else{
if !IsObject(monitorInfo)
monitorInfo:=monitorInfo()
whichMonitor:=whichMonitor("","",monitorInfo)
,which:=whichMonitor.1
if (for="mouse"){
return toggleSeriesList(impaxState, action, which+0, monitorInfo, activate)
}else if(for="all"){
if (!impaxControlList.maxIndex()){
winget,impaxListCount,list,ahk_exe impax-client-main.exe
impaxControlList:=[]
loop % impaxListCount
impaxControlList.push(impaxListCount%a_index%)
}
ret:=toggleSeriesList(impaxState, action, which+0, monitorInfo, activate)
,others:=[]
Loop % monitorInfo.maxIndex()-1
if(A_Index+1!=which){
others.push(A_Index+1)
toggleSeriesList(impaxState, action, A_Index+1, monitorInfo, activate)
}
return ret
}
return
}
if(activate)
winactivate,% "ahk_id " ImpaxState[2,1]
}
getRisList(hwnd=""){
if !hwnd
hwnd:=risOpened()[2]
static prvHwnd
return (h:=getNetAcc(hwnd,"DataGridView1","WindowsForms",0,0,"",""))?(prvHwnd:=h):prvHwnd
}
RisAddToDisplayList(risHwnd="",list=""){
if !risHwnd
risHwnd:=risOpened()[2]
if !list || !isobject(list)
list:=parseDataGrid(getRisList(risHwnd))
str:=""
i:=list.maxIndex()
for k,v in list.1
if (v="照會單號") {
ind:=k
break
}
if !ind
return
arr:=[]
for k,v in list
if (k!=1 && k!=i)
str.="ADD_TO_DISPLAY_LIST """" " v[ind] " """" "
,arr.push(v[ind])
str.="SYNC_DISPLAY """" " list[2,ind] " """""
return arr
}
impaxCyclicListDo(next=1,hwnd=""){
if !hwnd
hwnd:=impaxOpened()[2,1]
controlclick,,% "ahk_id " getNetAcc(hwnd,next=1?"nextButton":"previousButton","WindowsForms10.BUTTON",0,0,"","")
}
controlexist(hwnd, acc=false){
if !hwnd
return
if acc
hwnd:=acc_windowfromobject(hwnd)
controlget,id,hwnd,,,ahk_id %hwnd%
return id
}
RisSearchResultCount(risHwnd){
static RisSearchResultTextHwnd
if !controlexist(RisSearchResultTextHwnd)
RisSearchResultTextHwnd:=getNetAcc(risHwnd,"lblSearchResult","WindowsForms10.STATIC",0,0,"","")
text:=controlgettext(RisSearchResultTextHwnd)
regexmatch(text,"共搜尋到\s*(\d+)\s*筆資料",match)
return match1
}
getRisExamDate(risHwnd){
if IsObject(risHwnd)
risHwnd:=risHwnd[2]
static prvHwnd
return ControlGetText((h:=getNetControl2(risHwnd,"","EXAM_DATE_TIME","","WindowsForms10.EDIT")[1])?(prvHwnd:=h):prvHwnd)
}
getImpaxListAcc(impaxState){
impaxHwnd:=impaxState[2,2] | impaxState[2,3]
return getNetAcc(impaxHwnd, "grid", "windowsForms")
}
getRisLoginName(risHwnd){
WinGetTitle,title,% "ahk_id " risHwnd
RegExMatch(title,"^([^\-])+", match)
return match
}
resetRisReports(RisHwnd="", RisReports=""){
if(RisReports=""){
if !WinExist("ahk_id " RisHwnd)
RisHwnd:=risOpened()[2]
RisReports:=getRisReports(RisHwnd)
}
ControlSetText,,,% "ahk_id " RisReports[1,1]
ControlSetText,,,% "ahk_id " RisReports[1,2]
}
setReportText(findings, impression, RisReports="", replaceFindings=0, replaceImpression=true, caretToEnd=true, updateSimpleRis=true){
if (RisReports="" || !IsObject(RisReports)) || !WinExist("ahk_id " RisReports[1,1])
RisReports:=getRisReports(risOpened()[2])
oldReport:=EditHwnd?edit_getText(EditHwnd):ControlGetText(RisReports[1,1])
if (replaceFindings=0)
findings:=oldReport (oldReport=""?"":"`n`n") findings
else if (replaceFindings=-1)
findings:=(oldReport) findings
if !(replaceImpression)
impression:=Trim(ControlGetText(RisReports[1,2])) "`n" impression
findings:=RegExReplace(findings, "(?<!\r)\n", "`r`n")
if (updateSimpleRis){
if(simpleRis:=WinExist("ahk_exe simpleRIS.exe")){
controlget,EditHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
}
if (EditHwnd){
Edit_SetText(EditHwnd, findings)
if(caretToEnd){
Edit_SetSel(EditHwnd, len:=StrLen(findings), len)
}
}
}
ControlSetText,,% findings,% "ahk_id " RisReports[1,1]
ControlSetText,,% impression:=Trim(RegExReplace(impression, "(?<!\r)\n", "`r`n")),% "ahk_id " RisReports[1,2]
if(caretToEnd){
Edit_SetSel(RisReports[1,1], len:=StrLen(findings), len)
,Edit_SetSel(RisReports[1,2], len:=StrLen(impression), len)
}
}
getRisTechName(risHwnd){
static prvHwnd
return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"放射師","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}
getRisPtName(risHwnd){
static prvHwnd
return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"姓名","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}
getRisPtGender(risHwnd){
static prvHwnd
return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"性別","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}
getRisPtAge(risHwnd){
static prvHwnd
return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"年齡","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}
getRisStudyStatus(risHwnd){
return getRisStudyState(risHwnd)
}
getRisStudyState(risHwnd){
static prvHwnd
return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"狀態","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}
getClinicalInfo(RisHwnd){
static prvHwnd
return (h:=getNetControl2(risHwnd,"","txtALL","","WindowsForms10.EDIT.app","","","",0)[1])?controlgettext(prvHwnd:=h):ControlGetText(prvHwnd)
}
getImpaxContextServerPath(){
if FileExist(path:=A_ScriptDir "\ImpaxContextServer.exe")
return path
else if FileExist(path:=A_ScriptDir "\ImpaxContextServer\ImpaxContextServer.exe")
return path
else if FileExist(path:=RegExReplace(A_ScriptDir, "is)[\/\\][^\/\\]+$", "") "\ImpaxContextServer\ImpaxContextServer.exe")
return path
}
risSendReport(risHwnd, type=3){
static prvHwnd1, prvHwnd2, prvHwnd3
if !WinExist("ahk_id " risHwnd)
risHwnd:=risOpened()[2]
while !(button:=getNetAcc(risHwnd,type=1?"cmdRunSave":type=2?"cmdRunVerify":"cmdRunVerifySend","WindowsForms10.BUTTON",0,true))
&& !(button:=acc_objectfromwindow(getNetControl2(risHwnd,type=1?"暫存":type=2?"存檔":"存檔發送" ,"","","WindowsForms10.BUTTON")[1])) && !controlexist(prvHwnd%type%) && A_Index<4
Sleep 50
if(!button){
if controlexist(prvHwnd%type%)
button:=acc_ObjectFromWindow(prvHwnd%type%)
else {
MsgBox,,,% "Can't get RIS button, suggest re-open RIS!",3
return 1
}
}
prvHwnd%type%:=acc_windowfromobject(button)
return button.accDoDefaultAction()
}
risNextStudy(RisHwnd, next=true){
static nextHwnd0, nextHwnd1
next:=!!next
while !(button:=getNetAcc(risHwnd, next?"cmdRunNext":"cmdRunFoword","WindowsForms10.BUTTON",0,true))
&& !controlexist(nextHwnd%next%) && A_Index<4
Sleep 50
if(!button){
if controlexist(nextHwnd%next%)
button:=acc_ObjectFromWindow(nextHwnd%next%)
else {
MsgBox,,,% "Can't get RIS button, suggest re-open RIS!",3
return 1
}
}
nextHwnd%next%:=acc_windowfromobject(button)
return button.accDoDefaultAction()
}
risOpenStudyImpax(risHwnd="", blackFilter=false){
static prvHwnd
if !WinExist("ahk_id " risHwnd)
risHwnd:=risOpened()[2]
while !(openImpax:=getNetAcc(risHwnd,"cmdDs3000","WindowsForms10.BUTTON")) && !(openImpax:=acc_objectfromwindow(getNetControl2(risHwnd,"IMPAX6","","","WindowsForms10.BUTTON")[1])) && !controlexist(prvHwnd) && A_Index<4
Sleep 50
if(!openImpax){
if controlexist(prvHwnd)
openImpax:=acc_ObjectFromWindow(prvHwnd)
else{
MsgBox,,,% "Can't get RIS button, suggest re-open RIS!",3
return 1
}
}
prvHwnd:=acc_windowfromobject(openImpax)
if(blackFilter){
maskImpaxLoading()
}
return openImpax.accDoDefaultAction()
}
RisHistoryQueryByAccNo(AccNo, RisHwnd="", RisHistoryAcc=""){
static prvRisHistoryAcc, prvRisHwnd
if (!RisHistoryAcc) && !controlexist(acc_windowfromobject(RisHistoryAcc:=prvRisHistoryAcc)) {
if !WinExist(RisHwnd) && !WinExist(RisHwnd:=prvHwnd)
prvHwnd:=RisHwnd:=risOpened()[2]
prvRisHistoryAcc:=RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(prvHwnd:=RisHwnd))
}
prvRisHistoryAcc:=RisHistoryAcc
for k,v in rows:=acc_children(RisHistoryAcc){
cells:=acc_children(v)
if(k=1){
for x,y in cells {
if (y.accValue="照會單號"){
AccNoCol:=x
}else if (y.accValue="檢查日"){
examDateCol:=x
}else if (y.accValue="檢查名稱"){
examNameCol:=x
}
}
}else if (cells[AccNoCol].accValue=AccNo){
return {examDate: cells[examDateCol].accValue, examName: cells[examNameCol].accValue}
}
}
}
risOpenOldSingleStudy(AccNo, ExamDate="", ExamName="", RisHwnd="", RisHistoryAcc=""){
static prvRisHistoryAcc, prvRisHwnd
if (!RisHistoryAcc) && !controlexist(acc_windowfromobject(RisHistoryAcc:=prvRisHistoryAcc)) {
if !WinExist(RisHwnd) && !WinExist(RisHwnd:=prvHwnd)
prvHwnd:=RisHwnd:=risOpened()[2]
prvRisHistoryAcc:=RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(prvHwnd:=RisHwnd))
}
prvRisHistoryAcc:=RisHistoryAcc
if(examDate="" || examName="")
res:=RisHistoryQueryByAccNo(AccNo, RisHwnd, RisHistoryAcc)
, examDate:=res.examDate, examName:=res.examName
examType:=InStr(examName,"CT")?"CT":InStr(examName,"MRI")?"MRI":examName
for k,v in rows:=acc_children(RisHistoryAcc){
cells:=acc_children(v)
if(k=1){
for x,y in cells {
if (y.accValue="照會單號"){
AccNoCol:=x
}else if (y.accValue="檢查日"){
examDateCol:=x
}else if (y.accValue="檢查名稱"){
examNameCol:=x
}
}
}else if InStr(cells[examNameCol].accValue, examType) && (Trim(cells[examDateCol].accValue)=examDate){
ImpaxContextServer_Add(Trim(cells[AccNoCol].accValue))
}
}
}
coordToPacs(framePos, coord, dicomInfo){
origin:=dicomInfo.origin
, spacing:=dicomInfo.spacing
, dimension:=dicomInfo.dimension
if IsObject(coord.pacsPos)
pacsPos:=coord.pacsPos
else{
pacsPos:=coordToPacsPos(origin, coord, spacing)
}
target:=[]
if(framePos.w/framePos.h > dimension.x*spacing.x/dimension.y/spacing.y){
target.y:=Floor(framePos.h * pacsPos.y / dimension.y ) + framePos.y -1
, imageW:=framePos.h * dimension.x / dimension.y
, target.x:=Floor(imageW * pacsPos.x / dimension.x ) + framePos.x -1
}else{
target.x:=Floor(framePos.w * pacsPos.x / dimension.x ) + framePos.x -1
, imageH:=framePos.w * dimension.y / dimension.y
, target.y:=Floor(imageH * pacsPos.y / dimension.y ) + framePos.y -1
}
return {x: target.x, y: target.y}
}
coordToPacsPos(origin, coord, spacing){
pacsPos:=[]
for k,v in coord
pacsPos[k]:=Floor((v-origin[k])/spacing[k])+1
return pacsPos
}
PacsToCoord(impaxHwnd="", aspectRatio=1){
if !WinExist("ahk_id " impaxHwnd)
if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])
return
static clientImNoReg:="i)S: \d+\/(\d+) +I: \d+\/(\d+)"
MouseGetPos,mX,mY,win,frameHwnd,2
SEIM:=getSEIM(impaxHwnd)
WinGetPos,fX,fY,fW,fH,ahk_id %frameHwnd%
if(fW/fH > aspectRatio){
coordY:=(mY-fY)/fH
,coordX:=(mX - (fW-fH*aspectRatio)/2) / (fH*aspectRatio)
}else{
coordX:=(mX-fX)/fW
,coordY:=(mY-(fH-fW/aspectRatio)/2) / (fW/aspectRatio)
}
SEIM.push(Floor(coordX*1024)), SEIM.push(Floor(coordY*1024))
return SEIM
}
getImpaxAllImNo(impaxHwnd){
static clientImNoReg:="i)S: \d+\/(\d+) +I: \d+\/(\d+)"
if !WinExist("ahk_id " impaxHwnd)
if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])
return
for k,v in getNetControl2(impaxHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)
if ((t:=ControlGetText(v))!="" && RegExMatch(t, clientImNoReg, match)){
return match2
}
}
impaxSelectImageCurrent(xratio, yratio, slice_number){
return impaxSelectImage(slice_number, "", {x: xratio, y:yratio}, "", "", "", "", true)
}
impaxSelectImage(im, SeriesNoOrFrameCoord="", MouseMoveCoord="", whichScreen="", impaxHwnd="", nextKey="{Right}", prvKey="{Left}", current=false){
CoordMode,mouse,screen
static SEIMReg:="i)DICOM S: (\d+) +I: (\d+)", clientImNoReg:="i)S: (\d+)\/\d+ +I: (\d+)\/(\d+)"
static lastFoundFrameHwnd
if !WinExist("ahk_id " impaxHwnd)
if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])
return
winactivate, % "ahk_id " impaxHwnd
WinGetPos,wx,wy,,,% "ahk_id " impaxHwnd
SEIM:=getNetControl2(impaxHwnd,"","DicomImageNumbers","","WindowsForms10.STATIC.app","","","",0)
,clientImNo:=getNetControl2(impaxHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)
if (current){
frameHwnd:=getFocusedHwnd(), matched:=false
for screen, v1 in frames:=getViewFrame(impaxHwnd)
for x, v2 in v1
for y, hwnd in v2
if(hwnd=frameHwnd){
matched:=true
break, 3
}
if !matched
return
ControlGetPos,cx,cy,cw,ch,,% "ahk_id " frameHwnd
ControlFocus,,% "ahk_id " frameHwnd
MouseMove,% mX:=wx+cx+Floor(cw*3/4),% wy+cy+Floor(ch/2),0
Sleep 50
}else if IsObject(seriesNoOrFrameCoord){
frameHwnd:=getViewFrame(impaxHwnd)[seriesNoOrFrameCoord[1], seriesNoOrFrameCoord[2], seriesNoOrFrameCoord[3]]
if !frameHwnd
return
ControlGetPos,cx,cy,cw,ch,,% "ahk_id " frameHwnd
ControlFocus,,% "ahk_id " frameHwnd
MouseMove,% mX:=wx+cx+Floor(cw*3/4),% wy+cy+Floor(ch/2),0
Sleep 50
}else{
se:=seriesNoOrFrameCoord, matched:=false, recordFrameSe:=""
Loop 15 {
if controlexist(lastFoundFrameHwnd){
v3:=lastFoundFrameHwnd
ControlGetPos,cx,cy,cw,ch,,% "ahk_id " v3
ControlFocus,,% "ahk_id " v3
MouseMove,% mX:=wx+cx+Floor(cw*3/4),% mY:=wy+cy+Floor(ch/2),0
Sleep 100
for k,v in SEIM
if ((t:=ControlGetText(v))!=""){
if RegExMatch(t, SEIMReg, match){
if(match1=se){
frameHwnd:=v3, matched:=true
break, 2
}
}
break
}
}
LoopInd:=A_Index
for k1,v1 in frames:=getViewFrame(impaxHwnd, whichScreen)
for k2,v2 in v1
for k3,v3 in v2 {
ControlGetPos,cx,cy,cw,ch,,% "ahk_id " v3
ControlFocus,,% "ahk_id " v3
MouseMove,% mX:=wx+cx+Floor(cw*3/4),% mY:=wy+cy+Floor(ch/2),0
Sleep 100
for k,v in SEIM
if ((t:=ControlGetText(v))!=""){
if RegExMatch(t, SEIMReg, match){
if(match1=se){
lastFoundFrameHwnd:=frameHwnd:=v3, matched:=true
break, 5
}
}
break
}
for k,v in clientImNo
if ((t:=ControlGetText(v))!=""){
if RegExMatch(t, clientImNoReg, match){
if(recordFrameSe=match1)
return
if (LoopInd=2 && recordFrameSe="")
recordFrameSe:=match1
}
break
}
}
if(!matched){
winactivate,% "ahk_id " impaxHwnd
ControlFocus,,ahk_id %v3%
send % nextKey
Sleep 200
}
}
}
if(!matched)
return
for k,v in clientImNo
if ((t:=ControlGetText(v))!=""){
clientImNoHwnd:=v
,clientImNoText:=t
break
}
priorSendLevel:=a_sendlevel
SendLevel,0
if RegExMatch(clientImNoText, clientImNoReg, match){
allImNo:=match3
send {LButton Down}
MouseMove,% mX, % mY:=impaxImNoToMousePos(im, wy+cy, ch, allImNo),3
send {LButton up}
}
if im>allImNo
im:=allImNo
winactivate,% "ahk_id " impaxHwnd
ControlFocus,,ahk_id %frameHwnd%
wheelWay:=1, dist:=confirmPos:=0, tried:=0
loop {
if !RegExMatch(ControlGetText(clientImNoHwnd), clientImNoReg, match) {
if ++tried>10
break
Sleep 100
continue
}
if(match2=im && ++confirmPos>1)
break
if(dist && Abs(match2-im)>dist)
wheelWay:=!wheelWay
if (match2-im)*(wheelWay-0.5)>0
send % "{WheelUp " Abs(match2-im) "}"
else
send % "{WheelDown " Abs(match2-im) "}"
dist:=Abs(match2-im)
Sleep 100
}
SendLevel,% priorSendLevel
if tried>10
return
if(MouseMoveCoord="" || !MouseMoveCoord.x || !MouseMoveCoord.y)
MouseMoveCoord:={x:0.8, y:0.5}
WinGetPos,fX,fY,fW,fH,ahk_id %frameHwnd%
if(fW>=fH)
MoveCoordX:=Floor(fX+(fW-fH)/2+fH*MouseMoveCoord.x)
,MoveCoordY:=Floor(fY+fH*MouseMoveCoord.y)
else
MoveCoordY:=Floor(fY+(fH-fW)/2+fW*MouseMoveCoord.y)
,MoveCoordX:=Floor(fX+fW*MouseMoveCoord.x)
mousemove,% MoveCoordX,% MoveCoordY,1
return [MoveCoordX, MoveCoordY]
}
impaxMousePosToImNo(mouseY, frameY, frameH, allImNo){
return Floor((mouseY-frameY)*allImNo/frameH + 0.5)+1
}
impaxImNoToMousePos(k, frameY, frameH, allImNo, interval=false){
range:=[k=1?frameY:impaxImNoToMousePos(k-1, frameY, frameH, allImNo)+1,k=allImNo?frameY+frameH-1:Ceil(frameH*(2*k-1)/2/allImNo)+frameY-1]
if !interval
return Floor((range.1 + range.2)/2)
else
return range
}
risOpenOldStudy(risHwnd, open=true){
regEx:=""
for k,v in (ExamItems:=parseRisExamItems(getRisExamItems(RisHwnd)))[1]
if RegExMatch(v, "i)(CT|MRI)[^-]+-+([\w ]+)", match)
regEx.="((CT|MRI)[^-]+-+" match2 ")|"
else if (v~="i)((CT|MRI)[^-]+-+Brain)|(Perfusion CT)")
regEx.="((CT|MRI)[^-]+-+Brain)|(Perfusion CT)|"
regEx:="i)" SubStr(regEx,1,-1)
if(regEx="")
return
examDate:=getRisExamDate(risHwnd)
afterStudy:="", priorStudy:=""
for k,v in rows:=acc_children(RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(RisHwnd))){
if(k=1){
for x,y in cells:=acc_children(v) {
if (y.accValue="照會單號"){
AccNoCol:=x
}else if (y.accValue="檢查日"){
examDateCol:=x
}else if (y.accValue="檢查名稱"){
examNameCol:=x
}
}
}else if regexmatch(ExamName:=acc_children(v)[examNameCol].accValue, regEx) {
priorDate:=acc_children(v)[examDateCol].accValue
if RegExReplace(priorDate,"\W","")>SubStr(RegExReplace(examDate,"\W",""),1,8){
afterStudy:=v
continue
}
else if RegExReplace(priorDate,"\W","")=SubStr(RegExReplace(examDate,"\W",""),1,8){
isSameStudy:=false
for x,y in ExamItems[1]
if(y=ExamName){
isSameStudy:=true
break
}
if(isSameStudy)
continue
}
priorStudy:=v
break
}
}
if((v:=priorStudy) || (v:=afterStudy)){
v.accSelect(ComObj(3,3),0)
if (open){
if(impaxContextServerHwnd:=winexist("ahk_exe ImpaxContextServer.exe")){
ImpaxContextServer_Add(Trim(acc_children(v)[AccNoCol].accValue))
Loop {
if !(RegExReplace(priorDate,"\W","")=RegExReplace(test:=(nearRow:=acc_children(rows[k-A_Index]))[examDateCol].accValue,"\W","") && InStr(test2:=nearRow[examNameCol].accValue,"CT"))
break
ImpaxContextServer_Add(Trim(nearRow[AccNoCol].accValue))
}
Loop {
if !(RegExReplace(priorDate,"\W","")=RegExReplace((nearRow:=acc_children(rows[k+A_Index]))[examDateCol].accValue,"\W","") && InStr(nearRow[examNameCol].accValue,"CT"))
break
ImpaxContextServer_Add(Trim(nearRow[AccNoCol].accValue))
}
}else{
sleep 200
loc:=Acc_Location(v)
mouseclick,r,% loc.x+50,% loc.y+5,1,0
sleep 200
mouseclick,l,10,10,1,0,,R
}
}
}
}
parseOldSEIM(RisHwnd=""){
if !WinExist("ahk_id " RisHwnd)
RisHwnd:=risOpened()[2]
RisReports:=getRisReports(RisHwnd)
, oldReportText:=ControlGetText(RisReports[2,1])
, ret:=[]
if Trim(oldReportText)=""
return ret
i:=0, j:=1
while i:=RegExMatch(oldReportText, "i)\(([^\)\n]+)\)", match, j) {
thisSE:=""
if (k:=RegExMatch(match1, "i)SE *(\d+) *[\/\\]?", SE)) || (k:=RegExMatch(match1, "i)^(\d+) *[\/\\]", SE))
IMtext:=SubStr(match1, k+StrLen(SE)), thisSE:=SE1
else
IMtext:=match1
if (k:=InStr(IMtext, "IM")) && (RegExReplace(IMtext:=SubStr(IMtext,k), "i)IM|[\,\; ]", "") ~= "^\d+$"){
IMs:=RegExReplace(IMtext, "i)IM|[\,\; ]", ","), IMarr:=[]
loop,parse,IMs,`,
if RegExMatch(A_LoopField, "\d+", imMatch)
IMarr.push(imMatch)
if (IMarr.maxIndex()>0){
if !(thisSE ~= "^\d+$")
thisSE:=lastSE
if thisSE!=
for x,im in IMarr
ret.push([thisSE, im])
lastSE:=thisSE
}
}
j:=i+StrLen(match)
}
return ret
}
getEBMChartNo(all=false){
if (!all){
WinGetTitle,title,% "病歷號: ahk_class TViewerForm"
RegExMatch(title, "病歷號: ([^ ]+) 姓名: ([^ ]+) (\d+)(M|F) 日期: (\d{4})\/(\d\d)\/(\d\d) 存取編號: ([^ ]+)", match)
return match1
}
winget,list,list,% "病歷號: ahk_class TViewerForm"
ret:=[]
loop % list {
WinGetTitle,title,% "ahk_id " list%a_index%
if RegExMatch(title, "病歷號: ([^ ]+) 姓名: ([^ ]+) (\d+)(M|F) 日期: (\d{4})\/(\d\d)\/(\d\d) 存取編號: ([^ ]+)", match)
ret.push(match1)
}
return ret
}
getEBMInfo(Hwnd=""){
if Hwnd
WinGetTitle,title,% "ahk_id " Hwnd
else
WinGetTitle,title,% "病歷號: ahk_class TViewerForm"
ret:=[]
if RegExMatch(title, "病歷號: ([^ ]+) 姓名: ([^ ]+) (\d+)(M|F) 日期: (\d{4})\/(\d\d)\/(\d\d) 存取編號: ([^ ]+)", match){
ret.ChartNo:=match1
,ret.name:=match2
,ret.age:=match3
,ret.gender:=match4
,ret.examYear:=match5
,ret.examMonth:=match6
,ret.examDay:=match7
,ret.AccNo:=match8
}
return ret
}
selectAllRisList(RIsListAccChildren=""){
global RisState
if(RisListAccChildren=""){
if !WinExist("ahk_id " RisState[2]){
RisState:=risOpened()
}
RisListAccChildren := acc_children(acc_ObjectFromWindow(getRisList(RisState[2])))
}
ControlClick,x1 y1,% "ahk_id " acc_windowfromobject(RisListAccChildren[1])
}
unselectAllRisList(RisListAccChildren=""){
global RisState
if(RisListAccChildren=""){
if !WinExist("ahk_id " RisState[2]){
RisState:=risOpened()
}
RisListAccChildren := acc_children(acc_ObjectFromWindow(getRisList(RisState[2])))
}
ControlClick,,% "ahk_id " acc_windowfromobject(RisListAccChildren[2])
RisListAccChildren[lastInd:=RisListAccChildren.length()].accSelect(ComObj(3,3),0)
,RisListAccChildren[2].accSelect(ComObj(3,3),0)
,RisListAccChildren[2].accSelect(ComObj(3,16),0)
}
activateRisListTab(tabHwnd="", risHwnd=""){
global RisState
if !WinExist("ahk_id " risHwnd)
risHwnd:=(RisState:=risOpened())[2]
if !WinExist("ahk_id " tabHwnd){
tabHwnd:=getNetControl2(risHwnd,"報告工作清單","B_ACTIVE","報告工作清單","WindowsForms10.BUTTON.app","","","",0)[1]
}
controlclick,,% "ahk_id " tabHwnd
}
doubleClickRisList(index, RisListAcc="", RisListAccChildren="", risHwnd="", activateRis=true){
global RisState
if !WinExist("ahk_id " risHwnd)
risHwnd:=(RisState:=risOpened())[2]
if(RisListAcc=""){
RisListAcc:=acc_ObjectFromWindow(RisListHwnd:=getRisList(risHwnd))
}else{
RisListHwnd:=acc_windowfromobject(RisListAcc)
}
if(RisListAccChildren=""){
RisListAccChildren := acc_children(RisListAcc)
}
activateRisListTab()
,(ch:=RisListAccChildren[index+1]).accSelect(ComObj(3,3),0)
,pos:=Acc_Location(ch)
MouseGetPos,x0,y0
if (activateRis){
activeWin:=risHwnd
winactivate,% "ahk_id " RisHwnd
WinWaitActive,% "ahk_id " RisHwnd,,3
}
if (activeWin:=WinActive("A")) == risHwnd{
mousemove,% pos.x+1,% pos.y+1,0
Loop {
MouseGetPos,,,,con,2
if(con==RisListHwnd)
break
Sleep 1
}until A_Index>1000
state:="active"
}else if winvisible(RisHwnd){
winset,Transparent,0,% "ahk_id " RisHwnd
state:="non_active"
}else{
winset,Transparent,0,% "ahk_id " RisHwnd
WinShow,% "ahk_id " RisHwnd
state:="hidden"
}
winactivate,% "ahk_id " RisHwnd
WinWaitActive,% "ahk_id " RisHwnd,,3
ControlFocus,,% "ahk_id " RisListHwnd
mouseclick,l,% pos.x+1,% pos.y+1,2,0
mousemove,% x0,% y0,0
if(state="non_active"){
winset,Transparent,255,% "ahk_id " RisHwnd
}else if(state="hidden"){
winset,Transparent,255,% "ahk_id " RisHwnd
WinHide,% "ahk_id " RisHwnd
}
winactivate,% "ahk_id " activeWin
}
selectRisListItem(index="", AccNo="", chartNo="", ByRef ReportList="", ByRef RisListHwndAcc="", ByRef RisState="",MultiSelect=false){
if (RisState="")
RisState:=risOpened()
if (RisListHwndAcc="")
RisListHwnd:=getRisList(RisState[2])
,RisListAcc:=acc_ObjectFromWindow(RisListHwnd)
else if IsObject(RisListHwndAcc)
RisListAcc:=RisListHwndAcc, RisListHwnd:=acc_windowfromobject(RisListAcc)
else
RisListHwnd:=RisListHwndAcc, RisListAcc:=acc_ObjectFromWindow(RisListHwnd)
if (!index && AccNo="" && chartNo ="")
index:=1
if (AccNo chartNo = ""){
if IsObject(index){
acc_children(RisListAcc)[2].accSelect(ComObj(3,16),0)
for k,v in index
selectRisListItem(v, "", "", doubleClick, ReportList, RisListAcc, true)
}else{
item:=acc_children(RisListAcc)[index+1]
if !IsObject(item)
return -1
item.accSelect(MultiSelect?ComObj(3,8):ComObj(3,3),0)
}
}else{
if (ReportList="")
ReportList:=parseDataGrid2(RisListHwnd)
for k,v in reportList[1] {
if (v="照會單號") {
AccNoCol:=k
}
if (v="病歷號") {
chartNoCol:=k
}
}
if (AccNo){
if IsObject(AccNo){
acc_children(RisListAcc)[2].accSelect(ComObj(3,16),0)
for k,v in AccNo
selectRisListItem("", v, "", doubleClick, ReportList, RisListAcc, true)
}else{
for k,v in ReportList
if (v[AccNoCol]=AccNo){
item:=acc_children(RisListAcc)[k]
if !IsObject(item)
return -1
item.accSelect(MultiSelect?ComObj(3,8):ComObj(3,3),0)
break
}
}
}else{
if IsObject(ChartNo){
acc_children(RisListAcc)[2].accSelect(ComObj(3,16),0)
for k,v in ChartNo
selectRisListItem("", v, "", doubleClick, ReportList, RisListAcc, true)
}else{
for k,v in ReportList
if (v[ChartNoCol]=ChartNo){
item:=acc_children(RisListAcc)[k]
if !IsObject(item)
return -1
item.accSelect(MultiSelect?ComObj(3,8):ComObj(3,3),0)
break
}
}
}
}
return item
}
CaptureTextPath(){
if FileExist(path:=a_mydocuments "\Capture2Text\Capture2Text.exe")
|| FileExist(path:=A_ScriptDir "\Capture2Text\Capture2Text.exe")
|| FileExist(path:=A_ScriptDir "\..\Capture2Text\Capture2Text.exe")
|| FileExist(path:=A_ScriptDir "\..\..\Capture2Text\Capture2Text.exe")
|| FileExist(path:=SubStr(A_ScriptDir,1,2) "\software\Capture2Text\Capture2Text.exe")
return path
}
CaptureText(x0="",y0="",x1="",y1="", ByRef path=""){
WinClose,ahk_exe Capture2Text.exe
if !FileExist(path)
path:=CaptureTextPath()
if !FileExist(path)
return
if (x0="" || y0="" || x1="" || y0="") {
monitorInfo:=monitorInfo()
,w:=whichMonitor("","",monitorInfo)[1]
,w:=monitorInfo[w]
, x0:=w.l
, y0:=w.t
, x1:=w.r
, y1:=w.b
}
oldClip:=ClipboardAll
,tick:=a_now A_TickCount
,clipboard:=""
,output:=A_ScriptDir "\output" tick ".txt"
run % """" path """ " x0 " " y0 " " x1 " " y1 " """ output """ -b"
ClipWait,20
if ErrorLevel
fileread,t,% output
else
t:=Clipboard
clipboard:=oldClip
FileDelete,% output
WinClose,ahk_exe Capture2Text.exe
return t
}
getImpaxFrameInfo(hwnd="", corners=""){
if hwnd=
{
frames:=getViewFrame()
for k,v in frames {
hwnd:=v[1,1]
break
}
}
if !hwnd
return {}
WinGetPos,x,y,w,h,% "ahk_id " hwnd
info:={}
,cornerSize1:=250
,cornerSize2:=400
if corners=
corners=LU/RU/LL/RL
if (corners~="i)\bLU\b"){
t:=CaptureText(x,y,x+cornerSize2-1, y+cornerSize1-1)
,RegExMatch(t, "i)(\d+)Y *(M|F)", age_sex)
,RegExMatch(t, "i)@(\w+)", accno)
,RegExMatch(t, "is) *(\d+)\/(\d+)\/(\d+)\s*(\d+):(\d+):(\d+)\s*(.*)$", date)
,info.age:=age_sex1
,info.gender:=age_sex2
,info.AccNo:=accno1
,info.Date:=date1 "/" date2 "/" date3
,info.Time:=date4 ":" date5 ":" date6
,info.Year:=date1
,info.Month:=date2
,info.Day:=date3
,info.Hour:=date4
,info.Minute:=date5
,info.Second:=date6
,info.SeriesDescription:=Trim(date7)
}
if (corners~="i)\bRU\b"){
t:=CaptureText(x+w-cornerSize2,y,x+w-1, y+cornerSize1-1)
,o:=[]
loop,parse,t,`n,`r
if Trim(A_LoopField)!=""
o.push(Trim(A_LoopField))
info.hospital := o[1]
,info.ModalityName := o[2]
,info.studyId:=o[3]
,info.SE:=RegExReplace(o[4], "\D", "")
,info.IM:=RegExReplace(o[5], "\D", "")
}
if (corners~="i)\bLL\b"){
t:=CaptureText(x,y+h-cornerSize1,x+cornerSize2-1, y+h-1)
,o:=[]
loop,parse,t,`n,`r
if Trim(A_LoopField)!="" && !(Trim(A_LoopField)~="i)(^\d+$)|(^thk)|(^DF)|(^W )") {
info.StudyDescription:=Trim(A_LoopField)
break
}
RegExMatch(t, "-?[\d\.]+", m)
,info.z := m
,RegExMatch(t, "is)thk:([\d\.]+)mm", m)
,info.thickness:=m1
,RegExMatch(t, "is)\r?\nDF[^\r\n\.\d]+?([\.\d]+)", m)
,info.FOV:=m1
,RegExMatch(t, "i)W *([\-\d]+)[^\r\n]*L *([\-\d]+)", w)
,info.WW:=w1
,info.WL:=w2
}
if (corners~="i)\bRL\b"){
t:=CaptureText(x+w-cornerSize1,y+h-cornerSize1,x+w-1, y+h-1)
,o:=[]
loop,parse,t,`n,`r
if Trim(A_LoopField)!=""
o.push(Trim(A_LoopField))
info.kV:=RegExReplace(o[1], "is)kV\W*(\d+).+", "$1")
,info.mA:=RegExReplace(o[1], "is).+mA\W*(\d+)", "$1")
,info.FocalSpot:=RegExReplace(o[2], "[^\d\.]", "")
,info.ExposureTime:=RegExReplace(o[3], "\D", "")
,info.ConvolutionKernel:=RegExReplace(o[4], "i)^ALG *: *", "")
}
return info
}
getRisSmallMenu(getActive=true){
winget,list,list,ahk_exe Menu.exe ahk_class WindowsForms10.Window.808.app.0.33c0d9d
ret :=[]
loop % list
ret.push(list%a_index%)
if(!getActive){
return ret
}else{
for k,v in ret
if winvisible(v)
return v
}
}
RisNoIdle(RisHwnd=""){
if !RisHwnd
RisHwnd:=risOpened()[2]
for k,v in risControls:=GetControls(RisHwnd)
if instr(v.ClassNN,"WindowsForms10.SysTreeView32") {
controlsend,,{space},% "ahk_id " v.Hwnd
break
}
}
getRisTabs(risHwnd=""){
if !risHwnd
risHwnd:=risOpened()[2]
return tabs:=getNetControl2(risHwnd,"","B_ACTIVE","","WindowsForms10.BUTTON")
}
getSimpleImpaxUrl(chartNO, accNo){
global loginId, loginPw
while StrLen(chartNo)<7
chartNo:="0" chartNO
return "agfahc://impax-client-epr/?user=" loginId "&password=" loginPw "&domain=Agfa Healthcare&patientid=" ChartNo "&accession=" AccNo "&representation=Original"
}
maskImpaxLoading(impaxState="", timeOut=10){
__maskImpaxClose()
if impaxState =
impaxState:=impaxOpened()
if impaxState[1]!=2
return
w1:=impaxState[2,1]
,w2:=impaxState[2,2] | impaxState[2,3]
WinGetPos,x1,y1,w1,h1,ahk_id %w1%
WinGetPos,x2,y2,w2,h2,ahk_id %w2%
mask:=[]
,mask.l:=(x1*x2<0)?(x1<0?x2:x1):(x1>=0&&x1<=x2)?x1:(x2>=0&&x2>=x1)?x2:0
,mask.t:=(y1*y2<0)?(y1<0?y2:y1):(y1>=0&&y1<=y2)?y1:(y2>=0&&y2>=y1)?y2:0
,mask.r:=(x1+w1>=x2+w2)?x1+w1:x2+w2
,mask.b:=(y1+h1>=y2+h2)?y1+h1:y2+h2
,mask.w:=mask.r-mask.l
,mask.h:=mask.b-mask.t
if h:=WinExist("__maskImpaxLoading ahk_class AutoHotkeyGUI"){
__maskHwnd:=h
WinShow,ahk_id %h%
winactivate,ahk_id %h%
WinMove,ahk_id %h%,,% mask.l,% mask.t,% mask.w,% mask.h
}else{
gui,__mask:+toolwindow -caption +alwaysontop +hwnd__maskHwnd
gui,__mask:color,black
winset,trans,200,% "ahk_id " __maskHwnd
gui,__mask:Show,% "x" mask.l " y" mask.t " w" mask.w " h" mask.h " noactivate",__maskImpaxLoading
}
__setMaskImpaxHotkey()
}
__setMaskImpaxHotkey(on=true){
global
Hotkey,IfWinExist,__maskImpaxLoading ahk_class AutoHotkeyGUI
Hotkey,~WheelDown,__maskImpaxClose,% on?"on":"off"
Hotkey,~WheelUp,__maskImpaxClose,% on?"on":"off"
Hotkey,IfWinExist
Hotkey,IfWinActive,__maskImpaxLoading ahk_class AutoHotkeyGUI
Hotkey,~LButton,__maskImpaxClose,% on?"on":"off"
Hotkey,IfWinActive
}
__maskImpaxClose(){
WinClose,__maskImpaxLoading ahk_class AutoHotkeyGUI
__setMaskImpaxHotkey(false)
MouseGetPos,,win,con,2
winget,pName,ProcessName,ahk_id %win%
if (pName~="i)impax-client-main.exe|WebViewerComSrvEC.exe|WEBVIE~1.EXE"){
winactivate,ahk_id %win%
ControlFocus,,ahk_id %con%
}
}
__maskImpaxWait(impaxState, __maskHwnd, timeOut, tickcount){
global __SetTimerFn__maskImpaxWait
elapsed:=(A_TickCount-tickcount)/1000
if (elapsed<1.5)
return
if !WinExist("ahk_id " __maskHwnd) || impaxState[1]!=2{
__maskImpaxClose()
return
}
h:=impaxState[2,2] | impaxState[2,3]
WinGetPos,x,y,,,ahk_id %h%
if (timeOut && elapsed>timeOut) || (x<0 && y<0){
SetTimerFn(__SetTimerFn__maskImpaxWait,0)
Sleep 500
__maskImpaxClose()
return
}
}
compareList(ByRef ReportList, ByRef RisListAcc, ByRef RisListHwnd, colName="AccNo"){
if !WinExist("ahk_id " RisListHwnd)
RisListHwnd:=getRisList(risHwnd:=risOpened()[2])
,RisListAcc:=acc_ObjectFromWindow(RisListHwnd)
rows:=acc_children(RisListAcc)
,lastInd:=rows.maxIndex()
,colNo:=ReportList.getColNo(colName)
if (colNo="") || (ReportList[1][ColNo] != acc_children(rows[1])[ColNo].accValue)
|| lastInd<2
|| (ReportList[2][ColNo] != acc_children(rows[2])[ColNo].accValue) {
ReportList:=ParseDataGrid2(RisListHwnd, risHwnd)
return ReportList
}
Loop {
v:=acc_children(rows[lastInd-A_Index+1])[ColNo].accValue
if (v="")
continue
if (v!=ReportList[lastInd-A_Index+1][ColNo])
return ReportList:=ParseDataGrid2(RisListHwnd, risHwnd)
else
break
}
}
#SingleInstance,force
LungLobes:=["RUL","LUL","RML","lingular LUL","RLL","LLL","right lung","left lung","bilateral lungs","bilateral upper lungs","bilateral lower lungs"]
,side:={r:"right", l:"left", b:"bilateral"}
,site:={u:"upper", m:"middle", l:"lower", n:"lung"}
gosub gui
monitorInfo:=monitorInfo()
,SEIM:=[]
settimer,activeControl,-50
try
Menu,tray,icon,% a_scriptdir "\LDCTreport.ico",1,0
return
activeControl:
GuiControlGet, activeCon, %guihwnd2%: FocusV
if(pactiveCon && pactiveCon!=activeCon)
activeControlChanged(pActiveCon, activeCon)
pactiveCon:=activeCon
settimer,,-50
return
activeControlChanged(pActiveCon, ActiveCon){
global guihwnd2, noduleSizeHwnd
if(pActiveCon="size"){
ToolTip
GuiControlGet,noduleSize,%guihwnd2%:,size
if RegExMatch(Trim(noduleSize), "([\d\.]+)\W *([\d\.]+)(cm)?", m){
if(m3="cm")
m1*=10, m2*=10
s1:=Floor(m1+0.5)
,s2:=Floor(m2+0.5)
,mean:=Floor((m1+m2)/2+0.5)
if(m3="cm"){
s1:=Format("{:0.1f}", s1/10)
,s2:=Format("{:0.1f}", s2/10)
,mean:=Format("{:0.1f}", mean/10)
,s:= mean "cm (" s1 "*" s2 "cm)"
}else{
s:= mean "mm (" s1 "*" s2 "mm)"
}
guicontrol,Text,% noduleSizeHwnd,% s
}
}else if(activeCon="size"){
ShowToolTip("For example, ""5,7"" => ""6mm (5*7mm)""",5000)
}
}
gui:
ToolTip
gui,1:Default
gui,+hwndguiHwnd
GroupAdd,MyGUI,ahk_id %guiHwnd%
gui,Font,s12,Verdana
gui,Add,Text,,Lung findings:
gui,Add,button,gaddFindings,Nodule/GGO
gui,Add,button,x+5 gaddFindings,PFN
gui,Add,button,x+5 gaddFindings,Ifxn
gui,Add,button,x+5 gaddFindings,Emphysema
gui,add,Edit,% "xs w600 r5 vlungFindings hwndeditHwnd",
gui,add,Text,,Other findings:
gui,add,button,gaddFindings,Cal
gui,add,button,x+5 gaddFindings,Cyst
gui,add,button,x+5 gaddFindings,Thyroid
gui,add,Edit,% "xs w600 r5 vextraFindings hwndedithwnd2",% DefaultExtraFindings:="- No definite mediastinal mass or lymphadenopathy. `r`n- Degenerative change of thoracic spine. `r`n- "
gui,Font,s12 w700,Verdana
gui,add,Text,,Impression:
gui,Font,s12 w400,Verdana
gui,add,Text,xm,Risk factor
gui,add,DropDownList,xp+100 vriskfactor gprovideSuggestion hwndimprfhwnd,% "Unknown||High Risk|Low Risk"
gui,add,Text,x+20,Multiplicity
gui,add,DropDownList,xp+100 vmultiplicity gprovideSuggestion hwndimpmulhwnd,% "||Single|Multiple"
gui,add,Text,xm,Nodule
gui,add,DropDownList,xp+100 vnoduleType gprovideSuggestion hwndimpnthwnd,% "||Solid|PSN|GGN"
gui,add,Text,x+20,Size
gui,add,DropDownList,xp+100 vnoduleSz gprovideSuggestion hwndimpnshwnd,% "||<6|?6,<8|?8"
gui,add,edit,xm r5 w600 vimpression hwndimpressionHwnd,
gui,add,button,gsubmit,Submit
gui,add,button,greset yp x+50,Reset
gui,add,button,gcopyimpression yp x+300,Copy
gui,Show,AutoSize,LDCT Report (Fleischner Guidelines 2017)
gosub provideSuggestion
return
copyimpression:
clipboard:=ControlGetText(ImpressionHwnd)
ShowToolTip("Impression copied!")
return
provideSuggestion:
sug:=""
Gui,1:Submit,NoHide
if(noduleType="solid"){
if(noduleSz="<6"){
choices:={"low risk": "No routine follow-up.", "high risk": "Optional follow-up CT at 12 months."}
,sug:=considerRiskFactor(Riskfactor, choices)
}else if(noduleSz="?6,<8"){
if(Multiplicity="single"){
choices:={"low risk": "Follow-up CT at 6-12 months, then consider another CT at 18-24 months."
, "high risk": "Follow-up CT at 6-12 months, then another CT at 18-24 months."}
,sug:=considerRiskFactor(Riskfactor, choices)
}else if (Multiplicity="multiple"){
choices:={"low risk": "Follow-up CT at 3-6 months, then consider another CT at 18-24 months."
, "high risk": "Follow-up CT at 3-6 months, then another CT at 18-24 months."}
,sug:=considerRiskFactor(Riskfactor, choices)
}
}else if (noduleSz="?8"){
if(Multiplicity="single"){
sug:="Consider follow-up CT at 3 months, or PET/CT, or tissue sampling."
}else if (Multiplicity="multiple"){
choices:={"low risk": "Follow-up CT at 3-6 months, then consider another CT at 18-24 months."
, "high risk": "Follow-up CT at 3-6 months, then another CT at 18-24 months."}
,sug:=considerRiskFactor(Riskfactor, choices)
}
}
}else if(noduleType="GGN"){
if (Multiplicity="single"){
if(noduleSz="<6"){
sug:="No routine follow-up."
}else if (noduleSz!=""){
sug:="Follow-up CT at 6-12 months. If persistent, then CT at 3 and 5 years."
}
}else if (Multiplicity="multiple"){
choices:=["Follow-up CT at 3-6 months. ","If stable, consider CT at 2 and 4 years."]
,sug:=InStr(Riskfactor,"low")?choices[1]:(choices[1] choices[2])
}
}else if(noduleType="PSN"){
if (Multiplicity="single"){
if(noduleSz="<6"){
sug:="No routine follow-up."
}else{
sug:="Follow-up CT at 3-6 months. If persistent and stable with solid component <6mm, annual CT for 5 years."
}
}else if (Multiplicity="multiple"){
choices:=["Follow-up CT at 3-6 months. ","If stable, consider CT at 2 and 4 years."]
,sug:=InStr(Riskfactor,"low")?choices[1]:(choices[1] choices[2])
}
}
if (sug=""){
if (PFN_benign!="" && PFN_benign)
sug:="For perifissural or other juxtapleural location with a morphology consistent with an intrapulmonary lymph node, follow-up CT is not recommended, even if the average dimension exceeds 6 mm."
}else{
sug.="`n(This suggestion is based on ""Guidelines for Management of Incidental Pulmonary Nodules Detected on CT Images: From the Fleischner Society 2017"", please refer to original article for details.)"
}
guicontrol,Text,% ImpressionHwnd,% sug
return
considerRiskFactor(Riskfactor, choices){
sug:=""
if (Riskfactor="unknown"){
for k,v in choices
sug.= v " (" k ") / "
sug:=SubStr(sug,1,-3)
}else{
sug:=choices[Riskfactor]
}
return sug
}
ToolTip:
ToolTip
return
Reset:
Reload
return
Submit:
gui,Submit,NoHide
finalReport:="TECHNIQUE: Low dose CT (LDCT) of the chest without intravenous contrast administration.`r`n`r`nLung findings: `r`n" (lungFindings=""?"- No significant lung abnormality. ":lungFindings) "`r`n`r`nOther findings: (Limited detection of extrapulmonary lesion on LDCT.)`r`n" extraFindings
,finalReport:=RegExReplace(finalReport, "(- \r?\n)|(- $)", "")
,finalReport:=addAbbr(finalReport)
,setReportText(finalReport, impression)
if(simpleRis:=WinExist("simple RIS ahk_class AutoHotkeyGUI")){
controlget,ScintillaHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
Edit_SetText(ScintillaHwnd, finalReport)
}
winactivate,% "ahk_id " RisOpened()[2]
return
addAbbr(Report){
static LungLobesArr:={RUL: "right upper lobe", RML: "right middle lobe", RLL: "right lower lobe", LUL: "left upper lobe", LLL:"left lower lobe"}
str:=""
for k,v in LungLobesArr
if RegExMatch(Report, "\b" k "\b")
str.=k ": " v "; "
if(str="")
return Report
else
return RegExReplace(Report, "(\r?\n?)*$", "") "`r`n`r`n(" SubStr(str,1,-2) ")"
}
AddFindings:
gui,2:Destroy
gui,2:+Owner1 +OwnDialogs +hwndguiHwnd2
gui,2:Default
gui,Font,s12,Verdana
gosub % RegExReplace(a_guicontrol, "\W", "_")
return
Nodule_GGO:
gui,add,ComboBox,% "w200 vquantity",% "A||Multiple"
gui,add,ComboBox,% "w200 vsize hwndnoduleSizehwnd",% "tiny (<6mm)||small (<=10mm)"
gui,add,ComboBox,% "w200 vcharacter",% "part-solid|cavitary|ill-defined|calcified"
gui,add,ComboBox,% "w200 vlesion",% "nodule|GGN|GGO|mass"
gui,add,Text,,in
gui,add,ListBox,% "x+200 ys w200 r11 vlobe 8 t4 hwndlbhwnd1",% "RUL|LUL|RML|lingular LUL|RLL|LLL|right lung|left lung|bilateral lungs|bilateral upper lungs|bilateral lower lungs"
gui,add,ComboBox,% "xs w200 vchange",% "stable|larger|smaller"
ShowSub:
gui,add,button,% "xs Default gadd_" RegExReplace(a_guicontrol, "\W", "_"),% "Add"
gui,Show,AutoSize,% A_GuiControl
return
Add_Nodule_GGO:
gui,2:Default
gui,Submit
str:=(quantity:=Trim(quantity)) " " size
if size is number
str.="mm"
str.=" " character " "
if(quantity~="i)a|one|single|solitary")
str.=lesion
else
str.=pluralAppend(lesion)
str.=" in " itemsText(lobe)
if(Trim(change)!="")
str.=", " Trim(change) "."
else
str.="."
if !RegExMatch(character, "i)calcified|fat") {
if (lesion~="i)GGN|GGO|ground glass") || (character~="i)(part(ly)?|sub)-?solid"){
if (character~="i)(part(ly)?|sub)-?solid"){
guicontrol,ChooseString,% impnthwnd,PSN
}else if (noduleType!="PSN"){
guicontrol,ChooseString,% impnthwnd,GGN
}
}
else if (lesion~="i)nodule|mass|tumor") && (noduleType!="PSN") && (noduleType!="GGN") {
guicontrol,ChooseString,% impnthwnd,solid
}
if InStr(size, "<6") || InStr(size, "tiny")
size:=5
else if size is not number
size:=RegExReplace(size, "is)^([\d\.]+).+", "$1")
if (size>=8)
guicontrol,ChooseString,% impnshwnd,% "?8"
else if(size>=6) && (noduleSz!="?8")
guicontrol,ChooseString,% impnshwnd,% "?6,<8"
else if(size<6) && (noduleSz!="?8") && (noduleSz!="?6,<8")
guicontrol,ChooseString,% impnshwnd,% "<6"
totalNodCount:=(quantity~="i)a|one|single|solitary")?Floor(totalNodCount)+1 :Floor(totalNodCount)+2
if (totalNodCount>1){
guicontrol,ChooseString,% impmulhwnd,% "Multiple"
}else if (Multiplicity!="multiple"){
guicontrol,ChooseString,% impmulhwnd,% "Single"
}
settimer,provideSuggestion,-1
}
addLine:
str:=RegExReplace(str, "\s+", " ")
str:=StringUpperFirst(str)
AddReportLine(str, EditHwnd)
changeCategory:
return
PFN:
gui,add,ComboBox,% "w200 vquantity",% "A||Multiple"
gui,add,ComboBox,% "w200 vsize hwndnoduleSizehwnd",% "tiny (<6mm)||small (<=10mm)"
gui,add,ComboBox,% "w200 vlesion",% "perifissural nodule||juxtapleural nodule"
gui,add,ComboBox,% "w200 vlocation",% "right minor fissure|right major fissure|left major fissure|bilateral fissures"
gui,add,ComboBox,% "w200 vchange",% "stable|larger|smaller"
gui,add,ComboBox,% "w500 vmorphology",% "the morphology consistent with intrapulmonary lymph node||"
gosub ShowSub
return
Add_PFN:
gui,2:Default
gui,Submit
str:=(quantity:=Trim(quantity)) " " size
if size is number
str.="mm"
str.=" "
if(quantity~="i)a|one|single|solitary")
str.=lesion
else
str.=pluralAppend(lesion)
str.=" at " location
if(Trim(change)!="")
str.=", " Trim(change)
if(Trim(morphology)!="")
str.=", " Trim(morphology) "."
else
str.="."
if (morphology!="the morphology consistent with intrapulmonary lymph node") && !InStr(morphology,"benign")
PFN_benign:=false
else
PFN_benign:=true
settimer,provideSuggestion,-1
gosub addLine
return
Ifxn:
gui,add,ComboBox,% "w200 vlesion",% "tree-in-bud nodules||peribronchial nodules|fibrocalcified lesions"
gui,add,Text,,in
gui,add,ListBox,% "w200 vlobe x+200 ys r11 8 hwndlbhwnd2",% "RUL|LUL|RML|lingular LUL|RLL|LLL|right lung|left lung|bilateral lungs|bilateral upper lungs|bilateral lower lungs"
gosub ShowSub
return
Add_Ifxn:
gui,2:Default
gui,Submit
str:=lesion " in " itemsText(lobe) "."
if(category=1)
category:=4
gosub addLine
return
Emphysema:
gui,add,ComboBox,% "w400 vlesion",% "Emphysematous change in bilateral lungs||Emphysematous change in bilateral upper lungs"
gui,add,Text,,with
gui,add,ComboBox,% "w200 vadditional",% "apical bullae"
gosub ShowSub
return
Add_Emphysema:
gui,2:Default
gui,Submit
str:=lesion
if Trim(additional)!=""
str.= " with " Trim(additional)
str.="."
if(category=1)
category:=4
gosub addLine
return
Cal:
gui,add,Text,,% "Calcification of the"
gui,add,Checkbox,vca1 checked,% "aorta"
gui,add,Checkbox,vca2,% "coronary artery"
gui,add,Checkbox,vca3,% "cardiac valve"
gosub ShowSub
return
Add_Cal:
gui,2:Default
gui,Submit
str:=""
Loop 3 {
var:="ca" A_Index
if !(t:=%var%)
continue
GuiControlGet,Text,,% var,Text
str.=Text ", "
}
if (str="")
return
str:="Calcification of the " SubStr(RegExReplace(str,"i), ([^,]+), $"," and $1, "),1,-2) "."
addLine2:
str:=RegExReplace(str, "\s+", " ")
str:=StringUpperFirst(str)
AddReportLine(str, EditHwnd2)
gosub changeCategory
return
Thyroid:
gui,add,Checkbox,vth1,% "right"
gui,add,Checkbox,vth2,% "left"
gui,add,Text,,% "thyroid nodule(s)"
gosub ShowSub
return
Add_Thyroid:
gui,2:Default
gui,Submit
str:=""
if(th1)
str.=th2?"bilateral ":"right "
else if (th2)
str.="left "
str.="thyroid nodule" (str="bilateral "?"s":"(s)") "."
gosub addLine2
return
Cyst:
gui,add,ComboBox,vhc w600,% "hypodense lesion(s) in the liver, probably cyst(s).|hypodense lesion(s) in the liver, suggest ultrasound correlation."
gui,add,ComboBox,vrc w600,% "hypodense lesion(s) in the kidney, probably cyst(s).|hypodense lesion(s) in the kidney, suggest ultrasound correlation."
gosub ShowSub
return
Add_Cyst:
gui,2:Default
gui,Submit
str:="",rc:=Trim(rc),hc:=Trim(hc)
if(hc!=""){
if (replaced:=RegExReplace(hc,"i)liver","!@#$"))=RegExReplace(rc, "i)(left |right |bilateral )?kidney\(?s?\)?","!@#$") {
RegExMatch(rc, "i)(left |right |bilateral )?kidney(\(?s\)?)?", match)
,str:=RegExReplace(hc,"i)liver","liver and " match)
goto addLine2
}
str.=StringUpperFirst(hc) " "
}
if(rc!="")
str.=StringUpperFirst(rc) " "
gosub addLine2
return
AddReportLine(str, EditHwnd){
static bullet:="- "
Text:=ControlGetText(EditHwnd)
if(Trim(Text)="" || RegExMatch(Text, "i)\r?\n$"))
Edit_SetText(EditHwnd, Text bullet str "`r`n" bullet)
else if RegExMatch(Text, "i)\r?\n" bullet "$")
Edit_SetText(EditHwnd, Text str "`r`n" bullet)
else
Edit_SetText(EditHwnd, Text "`r`n" bullet str "`r`n" bullet)
Edit_SetSel(EditHwnd,-1,-1)
}
OnExit:
ExitApp
guiclose:
ExitApp
~esc::
if WinActive("ahk_id" guihwnd2)
WinClose,ahk_id %guihwnd2%
return
StringUpper(str){
StringUpper,str,str
return str
}
StringUpperFirst(str){
return StringUpper(SubStr(str,1,1)) SubStr(str,2)
}
pluralAppend(str){
if RegExMatch(str, "i)(s|x|z|ch|sh)$")
return str "es"
else if RegExMatch(str, "i)([^aeiou])y$")
return SubStr(str,1,-1) "ies"
else
return str "s"
}
getFocused(){
static GuiThreadInfoSize = 48
VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize)
NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)
DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)
return FocusedHWND := NumGet(GuiThreadInfo, 12)
}
#IfWinActive,ahk_group MyGUI
~*tab::
Sleep 100
focused:=getFocused()
WinGetClass,focusedClass,ahk_id %focused%
if InStr(focusedClass,"Edit")
Edit_SetSel(focused,-1,-1)
return
#IfWinActive
~r::
~b::
~l::
Critical
if (flagRunning)
return
if WinActive("ahk_id " guihwnd2) {
focused:=getFocused()
if matchHwnd(focused,"lbHwnd"){
flagRunning:=true
input,input,I L1 V T1,,u,m,l,n
candidate:=""
if (ErrorLevel="match"){
thisHotkey:=SubStr(A_ThisHotkey,2,1)
if(thisHotkey="l" && input="m")
candidate:="lingular LUL"
else{
for k,v in LungLobes
if InStr(v,thisHotkey input)=1 || InStr(v,side[thisHotkey] " " site[input])=1 {
candidate:=v
break
}
}
}
if(candidate!=""){
GuiControlGet,chosenLobes,,% focused
if !InStr("|" chosenLobes "|", "|" candidate "|")
guicontrol,ChooseString,% focused,% candidate
else {
guicontrol,choose,% focused,0
Loop,Parse,chosenLobes,|
if (A_LoopField!=candidate)
guicontrol,ChooseString,% focused,% A_LoopField
}
}
}
}
flagRunning:=false
return
matchHwnd(focused, varName="", hwndArr=""){
Loop {
var:=varName A_Index
if !(hwnd:=%var%)
break
if (hwnd=focused)
return true
}
if IsObject(hwndArr){
for k,v in hwndArr
if(hwnd=v)
return true
}
return false
}
itemsText(str,del="|",newDel=", ",lastAnd=true){
if (str="")
return ""
ret:="",Count:=0
Loop,Parse,str,% Del
{
ret.=(lastItem:=A_LoopField) newDel
Count++
}
if (lastAnd)
return (Count>1?SubStr(ret,1,(-1)*StrLen(newDel lastItem newDel)) " and ":"") lastItem
else
return SubStr(ret,1,(-1)*StrLen(newDel))
}
getSEIM:
whichMonitor:=whichMonitor("","",monitorInfo)
SEIM[whichMonitor.1]:=getSEIM()
return
GetFullPath(path) {
VarSetCapacity(fullpath, 260 * (!!A_IsUnicode + 1))
if DllCall("GetFullPathName", "Str", path, "UInt", 260, "Ptr", &fullpath, "Ptr", 0, "UInt")
return fullpath,VarSetCapacity(fullpath,-1)
}
PathCombine(abs, rel) {
VarSetCapacity(dest, (A_IsUnicode ? 2 : 1) * 260, 1)
,DllCall("Shlwapi.dll\PathCombine", "Ptr", &dest, "Ptr", &abs, "Ptr", &rel)
Return, dest
}
SetTimerFn(FuncName, Period, param="", Priority=0, autoFree=true){
static toBeFree:=[]
if IsFunc(FuncName){
fn:=Func(FuncName).Bind(param*)
}else if IsBoundFunc(FuncName)
fn:=FuncName
else if (FuncName+0=FuncName && Period="Delete"){
if (fn:=toBeFree[FuncName]){
try{
SetTimer,% fn, Delete
SetTimer,, Delete
}
toBeFree.delete(FuncName)
return
}
}
try
SetTimer,% fn,% Period,% Priority
if(autoFree && Period!="Delete"){
if(Period=0 || Period="off")
try
SetTimer,% fn,Delete
else if (Period<0){
self:=Func("SetTimerFn").Bind(t:=A_TickCount, "Delete")
,toBeFree[t]:=fn
try
SetTimer,% self,% Period-1000,% Priority
}
}
return fn
}
IsBoundFunc(obj) {
static dummy := Func("Abs").Bind(1)
return NumGet(&obj) == NumGet(&dummy)
}
ShowToolTip(Text="", Out=1500, X="",Y="", In=1, bControl=0, Nr=19){
static
If (Text=""){
MouseGetPos,,,_win,_ctrl
ControlGet,hCtrl,HWND,,%_ctrl%,ahk_id %_win%
If ((T_Text%Nr% && !T_%Nr% && T_In%Nr%<A_TickCount && (!T_Ctrl%Nr% or (T_Ctrl%Nr% && hCtrl=T_Ctrl%Nr%))) || (T_%Nr% && T_Out%Nr%<A_TickCount && !((T_Text%Nr%:="") . (T_X%Nr%:="") . (T_Y%Nr%:="") . (T_In%Nr%:="") . (T_Out%Nr%:="") . (T_%Nr%:="") . (T_Ctrl%Nr%:=""))))
ToolTip % T_Text%Nr%,% T_X%Nr%,% T_Y%Nr%,% Nr+(T_Text%Nr% ? ((T_%Nr%:=1)-1) : 0)
Return (!T_%Nr% ? T_In%Nr% : (T_Out%Nr%>A_TickCount ? T_Out%Nr% : ""))
} else if (bControl=1){
MouseGetPos,,,_win,_ctrl
ControlGet,T_Ctrl%Nr%,HWND,,%_ctrl%,ahk_id %_win%
} else T_Ctrl%Nr%:=0
T_Text%Nr%:=text,T_X%Nr%:= X,T_Y%Nr%:= Y,T_In%Nr%:=Round(A_TickCount+In),T_Out%Nr%:=(Out ? Round(A_TickCount+In+Out) : 9223372036854775807)
ShowToolTip:
NextTimer=
Loop 20
If (ErrorLevel:=ShowToolTip("","","","","","",A_Index))
If (!NextTimer || NextTimer+A_TickCount>ErrorLevel)
NextTimer:=(ErrorLevel-A_TickCount<0) ? "" : (ErrorLevel-A_TickCount+10)
SetTimer, ShowToolTip,% NextTimer ? (-1*(NextTimer+10)) : "Off"
Return
}