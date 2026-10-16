﻿﻿﻿; <COMPILER: v1.1.30.03>



SHA(string, encoding = "utf-8")



{



return CalcStringHash(string, 0x8004, encoding)



}



Hash_MD5(string, encoding = "UTF-8")



{



return CalcStringHash(string, 0x8003, encoding)



}



CalcAddrHash(addr, length, algid, byref hash = 0, byref hashlength = 0)



{



static h := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "A", "B", "C", "D", "E", "F"]



static b := h.minIndex()



o := ""



if (DllCall("advapi32\CryptAcquireContext", "Ptr*", hProv, "Ptr", 0, "Ptr", 0, "UInt", 24, "UInt", 0xF0000000))



{



if (DllCall("advapi32\CryptCreateHash", "Ptr", hProv, "UInt", algid, "UInt", 0, "UInt", 0, "Ptr*", hHash))



{



if (DllCall("advapi32\CryptHashData", "Ptr", hHash, "Ptr", addr, "UInt", length, "UInt", 0))



{



if (DllCall("advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", 0, "UInt*", hashlength, "UInt", 0))



{



VarSetCapacity(hash, hashlength, 0)



if (DllCall("advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", &hash, "UInt*", hashlength, "UInt", 0))



{



loop, % hashlength



{



v := NumGet(hash, A_Index - 1, "UChar")



o .= h[(v >> 4) + b] h[(v & 0xf) + b]



}



}



}



}



DllCall("advapi32\CryptDestroyHash", "Ptr", hHash)



}



DllCall("advapi32\CryPtreleaseContext", "Ptr", hProv, "UInt", 0)



}



return o



}



CalcStringHash(string, algid, encoding = "utf-8", byref hash = 0, byref hashlength = 0)



{



chrlength := (encoding = "cp1200" || encoding = "utf-16") ? 2 : 1



length := (StrPut(string, encoding) - 1) * chrlength



VarSetCapacity(data, length, 0)



StrPut(string, &data, floor(length / chrlength), encoding)



return CalcAddrHash(&data, length, algid, hash, hashlength)



}



OnScreenDisplay(str, DestroyAfter=1000, FontSize="50", FontColor="red", FontFamily="Verdana", xy_coord=""){



global



local __OnScreenDisplayGuiHwnd, __OnScreenDisplayGui,which,monitorInfo,w,h,mon



CoordMode,mouse,Screen



which:=OnScreenDisplay_whichMonitor("","", monitorInfo)



,mon:=monitorInfo[which.1]



gui,__OnScreenDisplay:Default



gui,destroy



gui,Font,s%fontsize% c%fontColor%,%fontFamily%



gui,Color,EEAA99



gui,+ToolWindow -Border -Caption +hwnd__OnScreenDisplayGuiHwnd +lastfound



WinSet, TransColor, EEAA99



gui,Add,Text,,% str



gui,Show,NA,__OnScreenDisplayGui



WinGetPos,,,w,h,% "ahk_id " __OnScreenDisplayGuiHwnd



WinMove,% "ahk_id " __OnScreenDisplayGuiHwnd,,% xy_coord?xy_coord[1]:Floor(mon.l+mon.w/2-w/2)



,% xy_coord?xy_coord[2]: Floor(mon.t+mon.h/2-h/2)



DllCall("SetWindowPos", "Ptr", __OnScreenDisplayGuiHwnd, "Ptr", 0, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)



,DllCall("SetWindowPos", "Ptr", __OnScreenDisplayGuiHwnd, "Ptr", -1, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)



SetTimer,__CloseOnScreenDisplayGUI,% (-1) * DestroyAfter



return



__CloseOnScreenDisplayGUI:



gui,__OnScreenDisplay:destroy



SetTimer,__CloseOnScreenDisplayGUI,Off



return



}



OnScreenDisplay_monitorInfo(){



sysget,monitorCount,monitorCount



arr:=[],sorted:=[]



loop % monitorCount {



sysget,mon,monitor,% a_index



arr.push({l:monLeft,r:monRight,b:monBottom,t:monTop,w:monRight-monLeft+1,h:monBottom-monTop+1})



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



OnScreenDisplay_whichMonitor(x="",y="",byref monitorInfo=""){



CoordMode,mouse,screen



if (x="" || y="")



mousegetpos,x,y



if !IsObject(monitorInfo)



monitorInfo:=OnScreenDisplay_monitorInfo()



for k,v in monitorInfo



if (x>=v.l&&x<=v.r&&y>=v.t&&y<=v.b)



return [k,monitorInfo.maxIndex()]



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



class CryptConst



{



static ALG_CLASS_ANY := (0)



static ALG_CLASS_SIGNATURE := (1 << 13)



static ALG_CLASS_MSG_ENCRYPT := (2 << 13)



static ALG_CLASS_DATA_ENCRYPT := (3 << 13)



static ALG_CLASS_HASH := (4 << 13)



static ALG_CLASS_KEY_EXCHANGE := (5 << 13)



static ALG_CLASS_ALL := (7 << 13)



static ALG_TYPE_ANY := (0)



static ALG_TYPE_DSS := (1 << 9)



static ALG_TYPE_RSA := (2 << 9)



static ALG_TYPE_BLOCK := (3 << 9)



static ALG_TYPE_STREAM := (4 << 9)



static ALG_TYPE_DH := (5 << 9)



static ALG_TYPE_SECURECHANNEL := (6 << 9)



static ALG_SID_ANY := (0)



static ALG_SID_RSA_ANY := 0



static ALG_SID_RSA_PKCS := 1



static ALG_SID_RSA_MSATWORK := 2



static ALG_SID_RSA_ENTRUST := 3



static ALG_SID_RSA_PGP := 4



static ALG_SID_DSS_ANY := 0



static ALG_SID_DSS_PKCS := 1



static ALG_SID_DSS_DMS := 2



static ALG_SID_ECDSA := 3



static ALG_SID_DES := 1



static ALG_SID_3DES := 3



static ALG_SID_DESX := 4



static ALG_SID_IDEA := 5



static ALG_SID_CAST := 6



static ALG_SID_SAFERSK64 := 7



static ALG_SID_SAFERSK128 := 8



static ALG_SID_3DES_112 := 9



static ALG_SID_CYLINK_MEK := 12



static ALG_SID_RC5 := 13



static ALG_SID_AES_128 := 14



static ALG_SID_AES_192 := 15



static ALG_SID_AES_256 := 16



static ALG_SID_AES := 17



static ALG_SID_SKIPJACK := 10



static ALG_SID_TEK := 11



static CRYPT_MODE_CBCI := 6



static CRYPT_MODE_CFBP := 7



static CRYPT_MODE_OFBP := 8



static CRYPT_MODE_CBCOFM := 9



static CRYPT_MODE_CBCOFMI := 10



static ALG_SID_RC2 := 2



static ALG_SID_RC4 := 1



static ALG_SID_SEAL := 2



static ALG_SID_DH_SANDF := 1



static ALG_SID_DH_EPHEM := 2



static ALG_SID_AGREED_KEY_ANY := 3



static ALG_SID_KEA := 4



static ALG_SID_ECDH := 5



static ALG_SID_MD2 := 1



static ALG_SID_MD4 := 2



static ALG_SID_MD5 := 3



static ALG_SID_SHA := 4



static ALG_SID_SHA1 := 4



static ALG_SID_MAC := 5



static ALG_SID_RIPEMD := 6



static ALG_SID_RIPEMD160 := 7



static ALG_SID_SSL3SHAMD5 := 8



static ALG_SID_HMAC := 9



static ALG_SID_TLS1PRF := 10



static ALG_SID_HASH_REPLACE_OWF := 11



static ALG_SID_SHA_256 := 12



static ALG_SID_SHA_384 := 13



static ALG_SID_SHA_512 := 14



static ALG_SID_SSL3_MASTER := 1



static ALG_SID_SCHANNEL_MASTER_HASH := 2



static ALG_SID_SCHANNEL_MAC_KEY := 3



static ALG_SID_PCT1_MASTER := 4



static ALG_SID_SSL2_MASTER := 5



static ALG_SID_TLS1_MASTER := 6



static ALG_SID_SCHANNEL_ENC_KEY := 7



static ALG_SID_ECMQV := 1



static ALG_SID_EXAMPLE := 80



static CALG_MD2 := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_MD2)



static CALG_MD4 := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_MD4)



static CALG_MD5 := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_MD5)



static CALG_SHA := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_SHA)



static CALG_SHA1 := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_SHA1)



static CALG_MAC := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_MAC)



static CALG_RSA_SIGN := (CryptConst.ALG_CLASS_SIGNATURE | CryptConst.ALG_TYPE_RSA | CryptConst.ALG_SID_RSA_ANY)



static CALG_DSS_SIGN := (CryptConst.ALG_CLASS_SIGNATURE | CryptConst.ALG_TYPE_DSS | CryptConst.ALG_SID_DSS_ANY)



static CALG_NO_SIGN := (CryptConst.ALG_CLASS_SIGNATURE | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_ANY)



static CALG_RSA_KEYX := (CryptConst.ALG_CLASS_KEY_EXCHANGE|CryptConst.ALG_TYPE_RSA|CryptConst.ALG_SID_RSA_ANY)



static CALG_DES := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_DES)



static CALG_3DES_112 := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_3DES_112)



static CALG_3DES := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_3DES)



static CALG_DESX := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_DESX)



static CALG_RC2 := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_RC2)



static CALG_RC4 := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_STREAM|CryptConst.ALG_SID_RC4)



static CALG_SEAL := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_STREAM|CryptConst.ALG_SID_SEA)



static CALG_DH_SF := (CryptConst.ALG_CLASS_KEY_EXCHANGE|CryptConst.ALG_TYPE_DH|CryptConst.ALG_SID_DH_SANDF)



static CALG_DH_EPHEM := (CryptConst.ALG_CLASS_KEY_EXCHANGE|CryptConst.ALG_TYPE_DH|CryptConst.ALG_SID_DH_EPHEM)



static CALG_AGREEDKEY_ANY := (CryptConst.ALG_CLASS_KEY_EXCHANGE|CryptConst.ALG_TYPE_DH|CryptConst.ALG_SID_AGREED_KEY_ANY)



static CALG_KEA_KEYX := (CryptConst.ALG_CLASS_KEY_EXCHANGE|CryptConst.ALG_TYPE_DH|CryptConst.ALG_SID_KEA)



static CALG_HUGHES_MD5 := (CryptConst.ALG_CLASS_KEY_EXCHANGE|CryptConst.ALG_TYPE_ANY|CryptConst.ALG_SID_MD5)



static CALG_SKIPJACK := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_SKIPJACK)



static CALG_TEK := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_TEK)



static CALG_CYLINK_MEK := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_CYLINK_MEK)



static CALG_SSL3_SHAMD5 := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_SSL3SHAMD5)



static CALG_SSL3_MASTER := (CryptConst.ALG_CLASS_MSG_ENCRYPT|CryptConst.ALG_TYPE_SECURECHANNEL|CryptConst.ALG_SID_SSL3_MASTER)



static CALG_SCHANNEL_MASTER_HASH := (CryptConst.ALG_CLASS_MSG_ENCRYPT|CryptConst.ALG_TYPE_SECURECHANNEL|CryptConst.ALG_SID_SCHANNEL_MASTER_HASH)



static CALG_SCHANNEL_MAC_KEY := (CryptConst.ALG_CLASS_MSG_ENCRYPT|CryptConst.ALG_TYPE_SECURECHANNEL|CryptConst.ALG_SID_SCHANNEL_MAC_KEY)



static CALG_SCHANNEL_ENC_KEY := (CryptConst.ALG_CLASS_MSG_ENCRYPT|CryptConst.ALG_TYPE_SECURECHANNEL|CryptConst.ALG_SID_SCHANNEL_ENC_KEY)



static CALG_PCT1_MASTER := (CryptConst.ALG_CLASS_MSG_ENCRYPT|CryptConst.ALG_TYPE_SECURECHANNEL|CryptConst.ALG_SID_PCT1_MASTER)



static CALG_SSL2_MASTER := (CryptConst.ALG_CLASS_MSG_ENCRYPT|CryptConst.ALG_TYPE_SECURECHANNEL|CryptConst.ALG_SID_SSL2_MASTER)



static CALG_TLS1_MASTER := (CryptConst.ALG_CLASS_MSG_ENCRYPT|CryptConst.ALG_TYPE_SECURECHANNEL|CryptConst.ALG_SID_TLS1_MASTER)



static CALG_RC5 := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_RC5)



static CALG_HMAC := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_HMAC)



static CALG_TLS1PRF := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_TLS1PRF)



static CALG_HASH_REPLACE_OWF := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_HASH_REPLACE_OWF)



static CALG_AES_128 := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_AES_128)



static CALG_AES_192 := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_AES_192)



static CALG_AES_256 := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_AES_256)



static CALG_AES := (CryptConst.ALG_CLASS_DATA_ENCRYPT|CryptConst.ALG_TYPE_BLOCK|CryptConst.ALG_SID_AES)



static CALG_SHA_256 := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_SHA_256)



static CALG_SHA_384 := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_SHA_384)



static CALG_SHA_512 := (CryptConst.ALG_CLASS_HASH | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_SHA_512)



static CALG_ECDH := (CryptConst.ALG_CLASS_KEY_EXCHANGE | CryptConst.ALG_TYPE_DH | CryptConst.ALG_SID_ECDH)



static CALG_ECMQV := (CryptConst.ALG_CLASS_KEY_EXCHANGE | CryptConst.ALG_TYPE_ANY | CryptConst.ALG_SID_ECMQV)



static CALG_ECDSA := (CryptConst.ALG_CLASS_SIGNATURE | CryptConst.ALG_TYPE_DSS | CryptConst.ALG_SID_ECDSA)



static CRYPT_VERIFYCONTEXT := 0xF0000000



static CRYPT_NEWKEYSET := 0x00000008



static CRYPT_DELETEKEYSET := 0x00000010



static CRYPT_MACHINE_KEYSET := 0x00000020



static CRYPT_SILENT := 0x00000040



static CRYPT_DEFAULT_CONTAINER_OPTIONAL := 0x00000080



static CRYPT_EXPORTABLE := 0x00000001



static CRYPT_USER_PROTECTED := 0x00000002



static CRYPT_CREATE_SALT := 0x00000004



static CRYPT_UPDATE_KEY := 0x00000008



static CRYPT_NO_SALT := 0x00000010



static CRYPT_PREGEN := 0x00000040



static CRYPT_RECIPIENT := 0x00000010



static CRYPT_INITIATOR := 0x00000040



static CRYPT_ONLINE := 0x00000080



static CRYPT_SF := 0x00000100



static CRYPT_CREATE_IV := 0x00000200



static CRYPT_KEK := 0x00000400



static CRYPT_DATA_KEY := 0x00000800



static CRYPT_VOLATILE := 0x00001000



static CRYPT_SGCKEY := 0x00002000



static CRYPT_ARCHIVABLE := 0x00004000



static CRYPT_FORCE_KEY_PROTECTION_HIGH := 0x00008000



static RSA1024BIT_KEY := 0x04000000



static CRYPT_SERVER := 0x00000400



static KEY_LENGTH_MASK := 0xFFFF0000



static CRYPT_Y_ONLY := 0x00000001



static CRYPT_SSL2_FALLBACK := 0x00000002



static CRYPT_DESTROYKEY := 0x00000004



static CRYPT_OAEP := 0x00000040



static CRYPT_BLOB_VER3 := 0x00000080



static CRYPT_IPSEC_HMAC_KEY := 0x00000100



static CRYPT_DECRYPT_RSA_NO_PADDING_CHECK := 0x00000020



static CRYPT_SECRETDIGEST := 0x00000001



static CRYPT_OWF_REPL_LM_HASH := 0x00000001



static CRYPT_LITTLE_ENDIAN := 0x00000001



static CRYPT_NOHASHOID := 0x00000001



static CRYPT_TYPE2_FORMAT := 0x00000002



static CRYPT_X931_FORMAT := 0x00000004



static CRYPT_MACHINE_DEFAULT := 0x00000001



static CRYPT_USER_DEFAULT := 0x00000002



static CRYPT_DELETE_DEFAULT := 0x00000004



static SIMPLEBLOB := 0x1



static PUBLICKEYBLOB := 0x6



static PRIVATEKEYBLOB := 0x7



static PLAINTEXTKEYBLOB := 0x8



static OPAQUEKEYBLOB := 0x9



static PUBLICKEYBLOBEX := 0xA



static SYMMETRICWRAPKEYBLOB := 0xB



static KEYSTATEBLOB := 0xC



static AT_KEYEXCHANGE := 1



static AT_SIGNATURE := 2



static CRYPT_USERDATA := 1



static KP_IV := 1



static KP_SALT := 2



static KP_PADDING := 3



static KP_MODE := 4



static KP_MODE_BITS := 5



static KP_PERMISSIONS := 6



static KP_ALGID := 7



static KP_BLOCKLEN := 8



static KP_KEYLEN := 9



static KP_SALT_EX := 10



static KP_P := 11



static KP_G := 12



static KP_Q := 13



static KP_X := 14



static KP_Y := 15



static KP_RA := 16



static KP_RB := 17



static KP_INFO := 18



static KP_EFFECTIVE_KEYLEN := 19



static KP_SCHANNEL_ALG := 20



static KP_CLIENT_RANDOM := 21



static KP_SERVER_RANDOM := 22



static KP_RP := 23



static KP_PRECOMP_MD5 := 24



static KP_PRECOMP_SHA := 25



static KP_CERTIFICATE := 26



static KP_CLEAR_KEY := 27



static KP_PUB_EX_LEN := 28



static KP_PUB_EX_VAL := 29



static KP_KEYVAL := 30



static KP_ADMIN_PIN := 31



static KP_KEYEXCHANGE_PIN := 32



static KP_SIGNATURE_PIN := 33



static KP_PREHASH := 34



static KP_ROUNDS := 35



static KP_OAEP_PARAMS := 36



static KP_CMS_KEY_INFO := 37



static KP_CMS_DH_KEY_INFO := 38



static KP_PUB_PARAMS := 39



static KP_VERIFY_PARAMS := 40



static KP_HIGHEST_VERSION := 41



static KP_GET_USE_COUNT := 42



static KP_PIN_ID := 43



static KP_PIN_INFO := 44



static HP_ALGID := 0x0001



static HP_HASHVAL := 0x0002



static HP_HASHSIZE := 0x0004



static HP_HMAC_INFO := 0x0005



static HP_TLS1PRF_LABEL := 0x0006



static HP_TLS1PRF_SEED := 0x0007



static PROV_RSA_FULL := 1



static PROV_RSA_SIG := 2



static PROV_DSS := 3



static PROV_FORTEZZA := 4



static PROV_MS_EXCHANGE := 5



static PROV_SSL := 6



static PROV_RSA_SCHANNEL := 12



static PROV_DSS_DH := 13



static PROV_EC_ECDSA_SIG := 14



static PROV_EC_ECNRA_SIG := 15



static PROV_EC_ECDSA_FULL := 16



static PROV_EC_ECNRA_FULL := 17



static PROV_DH_SCHANNEL := 18



static PROV_SPYRUS_LYNKS := 20



static PROV_RNG := 21



static PROV_INTEL_SEC := 22



static PROV_REPLACE_OWF := 23



static PROV_RSA_AES := 24



static PROV_STT_MER := 7



static PROV_STT_ACQ := 8



static PROV_STT_BRND := 9



static PROV_STT_ROOT := 10



static PROV_STT_ISS := 11



}



b64Encode( ByRef buf, bufLen )



{



DllCall( "crypt32\CryptBinaryToStringA", "ptr", &buf, "UInt", bufLen, "Uint", 1 | 0x40000000, "Ptr", 0, "UInt*", outLen )



VarSetCapacity( outBuf, outLen, 0 )



DllCall( "crypt32\CryptBinaryToStringA", "ptr", &buf, "UInt", bufLen, "Uint", 1 | 0x40000000, "Ptr", &outBuf, "UInt*", outLen )



return strget( &outBuf, outLen, "CP0" )



}



b64Decode( b64str, ByRef outBuf )



{



static CryptStringToBinary := "crypt32\CryptStringToBinary" (A_IsUnicode ? "W" : "A")



DllCall( CryptStringToBinary, "ptr", &b64str, "UInt", 0, "Uint", 1, "Ptr", 0, "UInt*", outLen, "ptr", 0, "ptr", 0 )



VarSetCapacity( outBuf, outLen, 0 )



DllCall( CryptStringToBinary, "ptr", &b64str, "UInt", 0, "Uint", 1, "Ptr", &outBuf, "UInt*", outLen, "ptr", 0, "ptr", 0 )



return outLen



}



b2a_hex( ByRef pbData, dwLen )



{



if (dwLen < 1)



return 0



if pbData is integer



ptr := pbData



else



ptr := &pbData



SetFormat,integer,Hex



loop,%dwLen%



{



num := numget(ptr+0,A_index-1,"UChar")



hash .= substr((num >> 4),0) . substr((num & 0xf),0)



}



SetFormat,integer,D



StringLower,hash,hash



return hash



}



a2b_hex( sHash,ByRef ByteBuf )



{



if (sHash == "" || RegExMatch(sHash,"[^\dABCDEFabcdef]") || mod(StrLen(sHash),2))



return 0



BufLen := StrLen(sHash)/2



VarSetCapacity(ByteBuf,BufLen,0)



loop,%BufLen%



{



num1 := (p := "0x" . SubStr(sHash,(A_Index-1)*2+1,1)) << 4



num2 := "0x" . SubStr(sHash,(A_Index-1)*2+2,1)



num := num1 | num2



NumPut(num,ByteBuf,A_Index-1,"UChar")



}



return BufLen



}



Free(byRef var)



{



VarSetCapacity(var,0)



return



}



class Crypt



{



class Encrypt



{



static StrEncoding := "UTF-16"



static PassEncoding := "UTF-16"



StrDecryptToFile(EncryptedHash,pFileOut,password,CryptAlg = 1, HashAlg = 1)



{



if !EncryptedHash



return ""



if !len := b64Decode( EncryptedHash, encr_Buf )



return ""



temp_file := "crypt.temp"



f := FileOpen(temp_file,"w","CP0")



if !IsObject(f)



return ""



if !f.RawWrite(encr_Buf,len)



return ""



f.close()



bytes := this._Encrypt( p, pp, password, 0, temp_file, pFileOut, CryptAlg, HashAlg )



FileDelete,% temp_file



return bytes



}



FileEncryptToStr(pFileIn,password,CryptAlg = 1, HashAlg = 1)



{



temp_file := "crypt.temp"



if !this._Encrypt( p, pp, password, 1, pFileIn, temp_file, CryptAlg, HashAlg )



return ""



f := FileOpen(temp_file,"r","CP0")



if !IsObject(f)



{



FileDelete,% temp_file



return ""



}



f.Pos := 0



fLen := f.Length



VarSetCapacity(tembBuf,fLen,0)



if !f.RawRead(tembBuf,fLen)



{



Free(tembBuf)



return ""



}



f.Close()



FileDelete,% temp_file



return b64Encode( tembBuf, fLen )



}



FileEncrypt(pFileIn,pFileOut,password,CryptAlg = 1, HashAlg = 1)



{



return this._Encrypt( p, pp, password, 1, pFileIn, pFileOut, CryptAlg, HashAlg )



}



FileDecrypt(pFileIn,pFileOut,password,CryptAlg = 1, HashAlg = 1)



{



return this._Encrypt( p, pp, password, 0, pFileIn, pFileOut, CryptAlg, HashAlg )



}



StrEncrypt(string,password,CryptAlg = 1, HashAlg = 1)



{



len := Crypt_StrPutVar(string, str_buf,100,this.StrEncoding)



if this._Encrypt(str_buf,len, password, 1,0,0,CryptAlg,HashAlg)



return b64Encode( str_buf, len )



else



return ""



}



StrDecrypt(EncryptedHash,password,CryptAlg = 1, HashAlg = 1)



{



if !EncryptedHash



return ""



if !len := b64Decode( EncryptedHash, encr_Buf )



return 0



if sLen := this._Encrypt(encr_Buf,len, password, 0,0,0,CryptAlg,HashAlg)



{



if ( this.StrEncoding = "utf-16" || this.StrEncoding = "cp1200" )



sLen /= 2



return strget(&encr_Buf,sLen,this.StrEncoding)



}



else



return ""



}



_Encrypt(ByRef encr_Buf,ByRef Buf_Len, password, mode, pFileIn=0, pFileOut=0, CryptAlg = 1,HashAlg = 1)



{



c := CryptConst



,CUR_PWD_HASH_ALG := HashAlg == 1 || HashAlg = "MD5" ?c.CALG_MD5



:HashAlg==2 || HashAlg = "MD2" 	?c.CALG_MD2



:HashAlg==3 || HashAlg = "SHA"	?c.CALG_SHA



:HashAlg==4 || HashAlg = "SHA256" ?c.CALG_SHA_256



:HashAlg==5 || HashAlg = "SHA384" ?c.CALG_SHA_384



:HashAlg==6 || HashAlg = "SHA512" ?c.CALG_SHA_512



:0



,CUR_ENC_ALG 	:= CryptAlg==1 || CryptAlg = "RC4" 			? ( c.CALG_RC4, KEY_LENGHT:=0x80 )



:CryptAlg==2 || CryptAlg = "RC2" 		? ( c.CALG_RC2, KEY_LENGHT:=0x80 )



:CryptAlg==3 || CryptAlg = "3DES" 		? ( c.CALG_3DES, KEY_LENGHT:=0xC0 )



:CryptAlg==4 || CryptAlg = "3DES112" ? ( c.CALG_3DES_112, KEY_LENGHT:=0x80 )



:CryptAlg==5 || CryptAlg = "AES128" 	? ( c.CALG_AES_128, KEY_LENGHT:=0x80 )



:CryptAlg==6 || CryptAlg = "AES192" 	? ( c.CALG_AES_192, KEY_LENGHT:=0xC0 )



:CryptAlg==7 || CryptAlg = "AES256" 	? ( c.CALG_AES_256, KEY_LENGHT:=0x100 )



:0



,KEY_LENGHT <<= 16



if (CUR_PWD_HASH_ALG = 0 || CUR_ENC_ALG = 0)



return 0



if !dllCall("Advapi32\CryptAcquireContextW","Ptr*",hCryptProv,"Uint",0,"Uint",0,"Uint",c.PROV_RSA_AES,"UInt",c.CRYPT_VERIFYCONTEXT)



{foo := "CryptAcquireContextW", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



if !dllCall("Advapi32\CryptCreateHash","Ptr",hCryptProv,"Uint",CUR_PWD_HASH_ALG,"Uint",0,"Uint",0,"Ptr*",hHash )



{foo := "CryptCreateHash", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



passLen := Crypt_StrPutVar(password, passBuf,0,this.PassEncoding)



if !dllCall("Advapi32\CryptHashData","Ptr",hHash,"Ptr",&passBuf,"Uint",passLen,"Uint",0 )



{foo := "CryptHashData", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



if !dllCall("Advapi32\CryptDeriveKey","Ptr",hCryptProv,"Uint",CUR_ENC_ALG,"Ptr",hHash,"Uint",KEY_LENGHT,"Ptr*",hKey )



{foo := "CryptDeriveKey", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



if !dllCall("Advapi32\CryptGetKeyParam","Ptr",hKey,"Uint",c.KP_BLOCKLEN,"Uint*",BlockLen,"Uint*",dwCount := 4,"Uint",0)



{foo := "CryptGetKeyParam", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



BlockLen /= 8



if (mode == 1)



{



if (pFileIn && pFileOut)



{



ReadBufSize := 10240 - mod(10240,BlockLen==0?1:BlockLen )



pfin := FileOpen(pFileIn,"r","CP0")



pfout := FileOpen(pFileOut,"w","CP0")



if !IsObject(pfin)



{foo := "File Opening " . pFileIn



GoTO FINITA_LA_COMEDIA



}



if !IsObject(pfout)



{foo := "File Opening " . pFileOut



GoTO FINITA_LA_COMEDIA



}



pfin.Pos := 0



VarSetCapacity(ReadBuf,ReadBufSize+BlockLen,0)



isFinal := 0



hModule := DllCall("LoadLibrary", "Str", "Advapi32.dll","UPtr")



CryptEnc := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "CryptEncrypt","UPtr")



while !pfin.AtEOF



{



BytesRead := pfin.RawRead(ReadBuf, ReadBufSize)



if pfin.AtEOF



isFinal := 1



if !dllCall(CryptEnc



,"Ptr",hKey



,"Ptr",0



,"Uint",isFinal



,"Uint",0



,"Ptr",&ReadBuf



,"Uint*",BytesRead



,"Uint",ReadBufSize+BlockLen )



{foo := "CryptEncrypt", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



pfout.RawWrite(ReadBuf,BytesRead)



Buf_Len += BytesRead



}



DllCall("FreeLibrary", "Ptr", hModule)



pfin.Close()



pfout.Close()



}



else



{



if !dllCall("Advapi32\CryptEncrypt"



,"Ptr",hKey



,"Ptr",0



,"Uint",1



,"Uint",0



,"Ptr",&encr_Buf



,"Uint*",Buf_Len



,"Uint",Buf_Len + BlockLen )



{foo := "CryptEncrypt", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



}



}



else if (mode == 0)



{



if (pFileIn && pFileOut)



{



ReadBufSize := 10240 - mod(10240,BlockLen==0?1:BlockLen )



pfin := FileOpen(pFileIn,"r","CP0")



pfout := FileOpen(pFileOut,"w","CP0")



if !IsObject(pfin)



{foo := "File Opening " . pFileIn



GoTO FINITA_LA_COMEDIA



}



if !IsObject(pfout)



{foo := "File Opening " . pFileOut



GoTO FINITA_LA_COMEDIA



}



pfin.Pos := 0



VarSetCapacity(ReadBuf,ReadBufSize+BlockLen,0)



isFinal := 0



hModule := DllCall("LoadLibrary", "Str", "Advapi32.dll","UPtr")



CryptDec := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "CryptDecrypt","UPtr")



while !pfin.AtEOF



{



BytesRead := pfin.RawRead(ReadBuf, ReadBufSize)



if pfin.AtEOF



isFinal := 1



if !dllCall(CryptDec



,"Ptr",hKey



,"Ptr",0



,"Uint",isFinal



,"Uint",0



,"Ptr",&ReadBuf



,"Uint*",BytesRead )



{foo := "CryptDecrypt", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



pfout.RawWrite(ReadBuf,BytesRead)



Buf_Len += BytesRead



}



DllCall("FreeLibrary", "Ptr", hModule)



pfin.Close()



pfout.Close()



}



else if !dllCall("Advapi32\CryptDecrypt"



,"Ptr",hKey



,"Ptr",0



,"Uint",1



,"Uint",0



,"Ptr",&encr_Buf



,"Uint*",Buf_Len )



{foo := "CryptDecrypt", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_LA_COMEDIA



}



}



FINITA_LA_COMEDIA:



dllCall("Advapi32\CryptDestroyKey","Ptr",hKey )



dllCall("Advapi32\CryptDestroyHash","Ptr",hHash)



dllCall("Advapi32\CryptReleaseContext","Ptr",hCryptProv,"UInt",0)



if (A_ThisLabel = "FINITA_LA_COMEDIA")



{



if (A_IsCompiled = 1)



return ""



else



ToolTip % foo " call failed with:`nErrorLevel: " err2 "`nLastError: " err "`n" ErrorFormat(err)



return ""



}



return Buf_Len



}



}



class Hash



{



static StrEncoding := "CP0"



static PassEncoding := "UTF-16"



FileHash(pFile,HashAlg = 1,pwd = "",hmac_alg = 1)



{



return this._CalcHash(p,pp,pFile,HashAlg,pwd,hmac_alg)



}



StrHash(string,HashAlg = 1,pwd = "",hmac_alg = 1)



{



buf_len := Crypt_StrPutVar(string, buf,0,this.StrEncoding)



return this._CalcHash(buf,buf_len,0,HashAlg,pwd,hmac_alg)



}



_CalcHash(ByRef bBuffer,BufferLen,pFile,HashAlg = 1,pwd = "",hmac_alg = 1)



{



c := CryptConst



HASH_ALG := HashAlg==1?c.CALG_MD5



:HashAlg==2?c.CALG_MD2



:HashAlg==3?c.CALG_SHA



:HashAlg==4?c.CALG_SHA_256



:HashAlg==5?c.CALG_SHA_384



:HashAlg==6?c.CALG_SHA_512



:0



HMAC_KEY_ALG 	:= hmac_alg==1?c.CALG_RC4



:hmac_alg==2?c.CALG_RC2



:hmac_alg==3?c.CALG_3DES



:hmac_alg==4?c.CALG_3DES_112



:hmac_alg==5?c.CALG_AES_128



:hmac_alg==6?c.CALG_AES_192



:hmac_alg==7?c.CALG_AES_256



:0



KEY_LENGHT 		:= hmac_alg==1?0x80



:hmac_alg==2?0x80



:hmac_alg==3?0xC0



:hmac_alg==4?0x80



:hmac_alg==5?0x80



:hmac_alg==6?0xC0



:hmac_alg==7?0x100



:0



KEY_LENGHT <<= 16



if (!HASH_ALG || !HMAC_KEY_ALG)



return 0



if !dllCall("Advapi32\CryptAcquireContextW","Ptr*",hCryptProv,"Uint",0,"Uint",0,"Uint",c.PROV_RSA_AES,"UInt",c.CRYPT_VERIFYCONTEXT )



{foo := "CryptAcquireContextW", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



if !dllCall("Advapi32\CryptCreateHash","Ptr",hCryptProv,"Uint",HASH_ALG,"Uint",0,"Uint",0,"Ptr*",hHash )



{foo := "CryptCreateHash1", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



if (pwd != "")



{



passLen := Crypt_StrPutVar(pwd, passBuf,0,this.PassEncoding)



if !dllCall("Advapi32\CryptHashData","Ptr",hHash,"Ptr",&passBuf,"Uint",passLen,"Uint",0 )



{foo := "CryptHashData Pwd", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



if !dllCall("Advapi32\CryptDeriveKey","Ptr",hCryptProv,"Uint",HMAC_KEY_ALG,"Ptr",hHash,"Uint",KEY_LENGHT,"Ptr*",hKey )



{foo := "CryptDeriveKey Pwd", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



dllCall("Advapi32\CryptDestroyHash","Ptr",hHash)



if !dllCall("Advapi32\CryptCreateHash","Ptr",hCryptProv,"Uint",c.CALG_HMAC,"Ptr",hKey,"Uint",0,"Ptr*",hHash )



{foo := "CryptCreateHash2", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



VarSetCapacity(HmacInfoStruct,4*A_PtrSize + 4,0)



NumPut(HASH_ALG,HmacInfoStruct,0,"UInt")



if !dllCall("Advapi32\CryptSetHashParam","Ptr",hHash,"Uint",c.HP_HMAC_INFO,"Ptr",&HmacInfoStruct,"Uint",0)



{foo := "CryptSetHashParam", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



}



if pFile



{



f := FileOpen(pFile,"r","CP0")



BUFF_SIZE := 1024 * 1024



if !IsObject(f)



{foo := "File Opening"



GoTO FINITA_DA_COMEDIA



}



if !hModule := DllCall( "GetModuleHandleW", "str", "Advapi32.dll", "UPtr" )



hModule := DllCall( "LoadLibraryW", "str", "Advapi32.dll", "UPtr" )



hCryptHashData := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "CryptHashData", "UPtr")



VarSetCapacity(read_buf,BUFF_SIZE,0)



f.Pos := 0



While (cbCount := f.RawRead(read_buf, BUFF_SIZE))



{



if (cbCount = 0)



break



if !dllCall(hCryptHashData



,"Ptr",hHash



,"Ptr",&read_buf



,"Uint",cbCount



,"Uint",0 )



{foo := "CryptHashData", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



}



f.Close()



}



else



{



if !dllCall("Advapi32\CryptHashData"



,"Ptr",hHash



,"Ptr",&bBuffer



,"Uint",BufferLen



,"Uint",0 )



{foo := "CryptHashData", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



}



if !dllCall("Advapi32\CryptGetHashParam","Ptr",hHash,"Uint",c.HP_HASHSIZE,"Uint*",HashLen,"Uint*",HashLenSize := 4,"UInt",0 )



{foo := "CryptGetHashParam HP_HASHSIZE", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



VarSetCapacity(pbHash,HashLen,0)



if !dllCall("Advapi32\CryptGetHashParam","Ptr",hHash,"Uint",c.HP_HASHVAL,"Ptr",&pbHash,"Uint*",HashLen,"UInt",0 )



{foo := "CryptGetHashParam HP_HASHVAL", err := GetLastError(), err2 := ErrorLevel



GoTO FINITA_DA_COMEDIA



}



hashval := b2a_hex( pbHash, HashLen )



FINITA_DA_COMEDIA:



DllCall("FreeLibrary", "Ptr", hModule)



dllCall("Advapi32\CryptDestroyHash","Ptr",hHash)



dllCall("Advapi32\CryptDestroyKey","Ptr",hKey )



dllCall("Advapi32\CryptReleaseContext","Ptr",hCryptProv,"UInt",0)



if (A_ThisLabel = "FINITA_LA_COMEDIA")



{



if (A_IsCompiled = 1)



return ""



else



ToolTip % foo " call failed with:`nErrorLevel: " err2 "`nLastError: " err "`n" ErrorFormat(err)



return 0



}



return hashval



}



}



}



GetLastError()



{



return ToHex(A_LastError < 0 ? A_LastError & 0xFFFFFFFF : A_LastError)



}



ToHex(num)



{



if num is not integer



return num



oldFmt := A_FormatInteger



SetFormat, integer, hex



num := num + 0



SetFormat, integer,% oldFmt



return num



}



ErrorFormat(error_id)



{



VarSetCapacity(msg,1000,0)



if !len := DllCall("FormatMessageW"



,"UInt",FORMAT_MESSAGE_FROM_SYSTEM := 0x00001000 | FORMAT_MESSAGE_IGNORE_INSERTS := 0x00000200



,"Ptr",0



,"UInt",error_id



,"UInt",0



,"Ptr",&msg



,"UInt",500)



return



return 	strget(&msg,len)



}



Crypt_StrPutVar(string, ByRef var, addBufLen = 0,encoding="UTF-16")



{



tlen := ((encoding="utf-16"||encoding="cp1200") ? 2 : 1)



,str_len := StrPut(string, encoding) * tlen



,VarSetCapacity( var, str_len + addBufLen,0 )



,StrPut( string, &var, encoding )



return str_len - tlen



}



SetKeySalt(hKey,hProv)



{



KP_SALT_EX := 10



SALT := "89ABF9C1005EDD40"



VarSetCapacity(st,2*A_PtrSize,0)



NumPut(len,st,0,"UInt")



NumPut(&pb,st,A_PtrSize,"UPtr")



if !dllCall("Advapi32\CryptSetKeyParam"



,"Ptr",hKey



,"Uint",KP_SALT_EX



,"Ptr",&st



,"Uint",0)



tooltip % ErrorFormat(GetLastError())



}



GetKeySalt(hKey)



{



KP_IV := 1



KP_SALT := 2



if !dllCall("Advapi32\CryptGetKeyParam"



,"Ptr",hKey



,"Uint",KP_SALT



,"Uint",0



,"Uint*",dwCount



,"Uint",0)



tooltip % "Fail to get SALT length."



tooltip % "SALT length.`n" dwCount



VarSetCapacity(pb,dwCount,0)



if !dllCall("Advapi32\CryptGetKeyParam"



,"Ptr",hKey



,"Uint",KP_SALT



,"Ptr",&pb



,"Uint*",dwCount



,"Uint",0)



tooltip % "Fail to get SALT"



}



class BatchCrypt {



__New(ByRef Password){



c:=CryptConst



, this.CUR_PWD_HASH_ALG:=32782



, this.CUR_ENC_ALG:=26128



, this.KEY_LENGHT:=(0x100<<16)



, dllCall("Advapi32\CryptAcquireContextW","Ptr*",hCryptProv,"Uint",0,"Uint",0,"Uint",c.PROV_RSA_AES,"UInt",c.CRYPT_VERIFYCONTEXT)



,dllCall("Advapi32\CryptCreateHash","Ptr",hCryptProv,"Uint",this.CUR_PWD_HASH_ALG,"Uint",0,"Uint",0,"Ptr*",hHash )



,passLen := Crypt_StrPutVar(password, passBuf,0,"UTF-16")



,dllCall("Advapi32\CryptHashData","Ptr",hHash,"Ptr",&passBuf,"Uint",passLen,"Uint",0 )



,dllCall("Advapi32\CryptDeriveKey","Ptr",hCryptProv,"Uint",this.CUR_ENC_ALG,"Ptr",hHash,"Uint",this.KEY_LENGHT,"Ptr*",hKey )



,dllCall("Advapi32\CryptGetKeyParam","Ptr",hKey,"Uint",c.KP_BLOCKLEN,"Uint*",BlockLen,"Uint*",dwCount := 4,"Uint",0)



, this.hKey := hKey



, this.hHash:=hHash



, this.hCryptProv:=hCryptProv



, this.BlockLen := BlockLen/8



}



Encrypt(ByRef string){



return this.__Crypt(ByRef string, 1)



}



Decrypt(ByRef string){



return this.__Crypt(ByRef string, 0)



}



__Crypt(string, mode){



Buf_Len := Crypt_StrPutVar(string, encr_Buf, 100,"UTF-16")



if(mode==1){



dllCall("Advapi32\CryptEncrypt"



,"Ptr",this.hKey



,"Ptr",0



,"Uint",1



,"Uint",0



,"Ptr",&encr_Buf



,"Uint*",Buf_Len



,"Uint",Buf_Len + this.BlockLen )



}else{



dllCall("Advapi32\CryptDecrypt"



,"Ptr",this.hKey



,"Ptr",0



,"Uint",1



,"Uint",0



,"Ptr",&encr_Buf



,"Uint*",Buf_Len )



}



return b64Encode( encr_Buf, Buf_Len )



}



__Delete(){



dllCall("Advapi32\CryptDestroyKey","Ptr",this.hKey )



,dllCall("Advapi32\CryptDestroyHash","Ptr",this.hHash)



,dllCall("Advapi32\CryptReleaseContext","Ptr",this.hCryptProv,"UInt",0)



}



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



__CryptStringUpper(ByRef m){



t:=m[1]



StringUpper(t)



return t



}



__CryptStr(str,pw,enc=1){



if (enc){



ret:=Crypt.Encrypt.StrEncrypt(str,pw,7,6)



,ret:=RegExReplace(ret, "[A-Z]", "_$0")



,ret:=RegExReplace(ret, "\/", "-")



}else



str:=RegExReplace(str, "\-", "/")



,str:=RegExReplaceFn(str, "i)_([A-Z])", "__CryptStringUpper")



,ret:=Crypt.Encrypt.StrDecrypt(str,pw,7,6)



return ret



}



__CryptFile(in_file, out_file,pw,enc=1){



return enc?Crypt.Encrypt.FileEncrypt(in_file, out_file,pw,7,6):Crypt.Encrypt.FileDecrypt(in_file, out_file,pw,7,6)



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



#Escapechar \



#CommentFlag //



__json_init()



{



global



static _ := __json_init()



$$ := Object()



JSON_init()



}



jQ(path, val = "") {



global $$



tempobj := $$



last := (instr(path, ".")



? substr(path, 1+instr(path, ".", false, -1))



: path)



Loop, Parse, path, \.



{



if (val != "") {



if (last = A_loopfield){



tempObj[A_loopfield] := val



continue



} else if (!tempObj[A_Loopfield])



tempObj[A_loopfield] := Object()



} else if (!tempObj)



break



tempObj := tempObj[A_loopfield]



}



if (! tempObj)



JSON_error("Cannot find or set entry " . path )



else



return (val = "" ?  tempObj : 0 )



}



JSON_save(obj, filename, spacing=35, block="    ", level=1) {



file         := FileOpen(filename, "w")



jsonString   := JSON_to(obj, spacing, block, level) "\n"



bytesWritten := file.write(jsonString)



file.close()



if (bytesWritten <= 0)



JSON_error("Cannot write file " . filename)



else



return bytesWritten



}



JSON_load(filename) {



file := FileOpen(filename, "r")



jsonString := file.read()



file.close()



if (jsonString == "")



JSON_error("No file found, or blank file.")



return JSON_from(jsonString)



}



JSON_error(s){



Msgbox, % "[" . A_now . "] " . s



Exit



}



JSON_escape(s){



StringReplace, s, s, \\, \\\\, All



StringReplace, s, s, ', \\',   All



StringReplace, s, s, ", \\",   All



return s



}



JSON_unescape(s){



StringReplace, s, s, \\\\, \\, All



StringReplace, s, s, \\', ',   All



StringReplace, s, s, \\", ",   All



return s



}



JSON_to(obj, spacing = 50, block = "    ", level = "1" ) {



s := ""



for k, v in obj



{



if (s != "")



s .= ","



s .= "\n"



Loop, %level%



s .= block



k := JSON_escape(k)



v := JSON_escape(v)



s .= """" k """: "



if (isobject(v)) {



s .= JSON_to(v, spacing, block, level + 1 )



} else {



totalKeyLength := level * strlen(block) + strlen(k) + 2



if (spacing >= totalKeyLength ) {



valueIndent := spacing - totalKeyLength



loop, %valueIndent%



s .= " "



}



if v is not number



v := """" v """"



s .= v



}



}



if ( (s == "") && !isobject(obj) ) {



s := Object()



} else if ( (s == "") && isobject(obj) ) {



s := "{}"



} else {



s := "{" s "\n"



level -= 1



Loop, %level%



s .= block



s .= "}"



}



return s



}



JSON_init(){



#EscapeChar `



global JSON_regexps, JSON_rules



JSON_regexps := Object( ""



. " " , "(\s+)"



, "{" , "({)"



, "[" , "(\[)"



, "]" , "(\])"



, "}" , "(})"



, "Q" , "'([^'\\]*(\\.[^'\\]*)*)'"



, "S" , """([^""\\]*(\\.[^""\\]*)*)"""



, "N" , "([+\-]?\d+([.,]\d+)?)"



, "D" , "(true|false|null)"



, ":" , "(:)"



, "," , "(,)"



. "" )



JSON_rules    := Object()



JSON_rules[0] := Object( "key", "(\s+)",                             "sub", "" , "func", "JSON_reduce_spaces"   )



JSON_rules[1] := Object( "key", "([QS]:[QSNOAD])",                   "sub", "_", "func", "JSON_reduce_keyvalue" )



JSON_rules[2] := Object( "key", "(\[(([QSNOAD](,[QSNOAD])*\])|\]))", "sub", "A", "func", "JSON_reduce_array"    )



JSON_rules[3] := Object( "key", "({}|{_(,_)*})",                     "sub", "O", "func", "JSON_reduce_object"   )



#Escapechar \



}



JSON_reduce_spaces(c)  {



return ""



}



JSON_reduce_keyvalue(c){



return Object(c[3], c[1])



}



JSON_reduce_array(c){



ret := Object()



new_idx := (c.maxindex() - 1) \/\/ 2



for old_idx, token in c {



if (mod(old_idx,2) == 0) {



ret[new_idx] := token



new_idx -= 1



}



}



return ret



}



JSON_reduce_object(c){



ret := Object()



for old_idx, key_val in c {



if (mod(old_idx,2) == 0) {



for key, val in key_val {



ret[key] := val



}



}



}



return ret



}



JSON_from(s){



ret     := Object()



pos     := 1



symbols := ""



len     := strLen(s)



while (pos <= len) {



t := JSON_shift(s,pos,symbols,ret)



symbols := JSON_reduce(t["symbols"],ret), pos := t["pos"]



}



if (symbols == "O" || symbols == "A")



return ret[""]



else



JSON_error("Invalid JSON string, cannot convert to object.")



}



JSON_shift(s, pos, symbols, ret){



global JSON_regexps



for symbol,regexp in JSON_regexps {



RegexMatch(s, "PSi)(" . regexp . ")", match_, pos)



if (match_pos1 == pos){



symbols .= symbol



pos  += match_len1



ret.push( JSON_unescape(substr(s, match_pos2, match_len2)) )



return Object("symbols", symbols, "pos", pos)



}



}



JSON_error("Error at pos:" pos "\n" substr(s,pos-4))



exit



}



JSON_reduce(symbols, ret){



global JSON_regexps, JSON_rules



rule_idx := 0



while (rule_idx <= JSON_rules.maxIndex()) {



children    := Object()



rule        := JSON_rules[rule_idx]



old_symbols := rule["key"]



new_symbol  := rule["sub"]



reduce_func := rule["func"]



Regexmatch(symbols, "PSi)" . old_symbols . "$", match_)



if ( match_pos1 < 1 ) {



rule_idx += 1



continue



}



Loop, %match_len1% {



if (ryle_idx != 0 )



children.push( ret[ret.maxindex()] )



ret.pop()



stringtrimright, symbols, symbols, 1



}



symbols .= new_symbol



rule_idx := 0



if ((new_token := %reduce_func%(children)) != "")



ret[ret.maxindex()+1] := new_token



}



return symbols



}



#Escapechar `



#CommentFlag ;



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



SetTimerFn(Function, Period=0, ParmObject=0, Priority=0, overriding=True){



return new SelfDeletingTimer(Priority, Period, Function, overriding, ParmObject*)



}



class SelfDeletingTimer {



static allTimers:=[]



__New(Priority, period, fn, overriding, prms*) {



is_off:=period=0||period="off"||period="delete"



if (fn.__Class="SelfDeletingTimer"){



this:=fn



if(overriding || is_off){



this.DeleteOldTimer(this)



}



}else{



this.fn := IsObject(fn) ? fn : Func(fn)



if(overriding || is_off){



this.DeleteOld(this.fn)



}



}



this.prms := prms



,this.period:=period



,this.tick:=A_TickCount



if (!is_off){



this.AddTimer()



}



SetTimer,% this, % period=0?"off":period,% Priority



}



DeleteOld(fn) {



if(SelfDeletingTimer.allTimers.haskey(fn)){



for timer, tick in SelfDeletingTimer.allTimers[fn]



settimer % timer,Delete



SelfDeletingTimer.allTimers[fn]:={}



}



}



DeleteOldTimer(timer){



for fn,arr in SelfDeletingTimer.allTimers



SelfDeletingTimer.allTimers[fn].delete(this)



settimer % timer,delete



}



AddTimer() {



fn:=this.fn



if(!SelfDeletingTimer.allTimers.haskey(fn)){



SelfDeletingTimer.allTimers[fn]:={}



}



SelfDeletingTimer.allTimers[fn, this]:=this.tick



}



Call() {



this.fn.Call(this.prms*)



if (this.period<0){



this.DeleteOldTimer(this)



}



}



}



StrPutVar(string,ByRef var,encoding){



VarSetCapacity(var,StrPut(string,encoding)



*((encoding="utf-16"||encoding="cp1200")?2:1),00)



return StrPut(string,&var,encoding),VarSetCapacity(var,-1)



}



MD5( V ) {



VarSetCapacity( MD5_CTX,104,0 ), DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )



DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, A_IsUnicode ? "AStr" : "Str",V



, UInt,StrLen(V) ), DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )



Loop % StrLen( Hex:="123456789ABCDEF0" )



N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)



stringlower,MD5,md5



return md5



}



portalUrl:="http://portal.hospital-n.local"



__ua_header:="User-Agent: Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0;  rv:11.0) like Gecko"



#(byref pwb,id){



return pwb.document.getElementById(id)



}



$(byref dom,id){



return dom.getElementById(id)



}



get(byref html,identifier,from="id",get="value"){



dom:=ComObjCreate("HtmlFile")



dom.write(regexreplace(html,"is)(<\/html>).*$","$1"))



if(from="id"){



return dom.getElementById(identifier)[get]



}else if (from="name"){



return dom.all[identifier][get]



}



}



getText(byref html){



html:=RegExReplace(html,"[\n\r\t]+","")



html:=regexreplace(html,"\s{2,}<"," <")



html:=regexreplace(html,">\s{2,}","> ")



html:=regexreplace(html,">\s+<","><")



html:=RegExReplace(html,"is)<script[^>]*>.*?<\s*\/\s*script\s*>","")



html:=regexreplace(html,"<[^<>]+>","")



html:=regexreplace(html,"i)&nbsp;"," ")



return html



}



getHtmlById(byref html,id,outer=false){



RegExMatch(html,"is)<([^>\s]+)[^>]*\sid=(?:(?:""" id """)|(?:'" id "')|(?:" id "))[^>]*>(.*?)<\s*\/\s*\1\s*>",match)



return outer ? match : match2



}



getTextById(byref html,id,trim=true){



return trim ? trim(s:=getText(getHtmlById(html,id))) : s



}



getElement(ByRef dom, filter="", returnFirst=true){



if !IsObject(filter)



return dom.getElementById(filter)



else if (filter.hasKey("id"))



return dom.getElementById(filter.id)



else{



f:=filter.tagName



if f=



f:="*"



e:=dom.getElementsByTagName(f)



if (returnFirst){



Loop % e.length {



v:=e[A_Index-1]



for x,y in filter



if !(v.getAttribute(x)=y)



continue,2



MsgBox % v.Name "," v.classname



return v



}



}else{



ret:=[]



for k,v in e {



r:=true



for x,y in filter



r &= (v.getAttribute(x)=y)



if r



ret.push(v)



}



}



}



}



convertHTMLchar(ByRef str){



s:=""



j:=1



while i:=RegExMatch(ss:=SubStr(str,j), "i)&(x[a-f\d]{1,4};|#\d{1,5};|[a-z]{2,5};)", match) {



s.=SubStr(ss,1,i-1)



dom:=ComObjCreate("HtmlFile")



,dom.write(match)



s.=dom.documentElement.innerText



j+=i+StrLen(match)



}



return s ss



}



getHtmlByTagName(byref html,tagName,outer=false){



arr:=[]



i:=0



while i:=regexmatch(html,"is)<" tagName "(?:\s[^>]*)?>(.*?)<\s*\/\s*" tagName "\s*>",match,i+1)



outer ? arr.push(match) : arr.push(match1)



return arr



}



getTextByTagName(byref html,tagName,trim=true){



arr:=getHtmlByTagName(html,tagName)



arr2:=[]



for k,v in arr



trim ? arr2.push(trim(s:=getText(v))) : arr2.push(s)



return arr2



}



getUserName(userId,sid){



if !checkSid(sid)



return



global portalUrl



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx?SESSION=" sid,html:="",header:="")



RegExMatch(header,"ASP.NET_SessionId=(\w+)",match)



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " match



post:="scrollLeft=&scrollTop=&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&NWeb1%24QueryInPatientPersonAccountControl1%24DropListHosp=T0&NWeb1%24QueryInPatientPersonAccountControl1%24DropListWard=&NWeb1%24QueryInPatientPersonAccountControl1%24SearchDayRangeTextBox=4&NWeb1%24QueryInPatientPersonAccountControl1%24PersonIDInput=&NWeb1%24QueryInPatientPersonAccountControl1%24AccountIDSEInput=&NWeb1%24QueryInPatientPersonAccountControl1%24tbxChartNoInput=&NWeb1%24QueryInPatientPersonAccountControl1%24PatientBasicInfoQueryByName1%24ctl00=&NWeb1%24QueryInPatientPersonAccountControl1%24OperationRoomInput=&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24IDInputTextBox=" getUserId(sid) "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24CheckBoxShowDrMainColumn=on&NWeb1%24QueryInPatientPersonAccountControl1%24ShowIntraReportCheck=on&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24ChartNoTextBox=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24LNameInput=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24FNameInput=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24BirthDayInput=&NWeb1%24QueryInPatientPersonAccountControl1%24HiddenFieldIntraReport=&NWeb1%24Group=BySelectPrint&NWeb1%24ConditionLevelDropList=%23&NWeb1%24DateExecuteSwitchDate%24YearInput=" a_yyyy "&NWeb1%24DateExecuteSwitchDate%24MonthInput" 0+a_mm "&NWeb1%24DateExecuteSwitchDate%24DayInput" 0+a_dd "&NWeb1%24OriginalUserID=&NWeb1%24TransferUserID=&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=" userId "&NWeb1%24QueryDrIDInfoByDrName1%24QueryByID=ID%E6%9F%A5%E5%A7%93%E5%90%8D&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24YearInput=" a_yyyy "&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24MonthInput" 0+a_mm "&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24DayInput" 0+a_dd "&NWeb1%24PrintStartDate%24YearInput=1500&NWeb1%24PrintStartDate%24MonthInput=1&NWeb1%24PrintStartDate%24DayInput=1&NWeb1%24PrintEndDate%24YearInput=" a_yyyy "&NWeb1%24PrintEndDate%24MonthInput" 0+a_mm "&NWeb1%24PrintEndDate%24DayInput" 0+a_dd



httprequest(url,post,header,"charset: utf-8")



regexmatch(getTextById(post,"NWeb1_QueryDrIDInfoByDrName1_EmpNoLabel"),"姓名：([^\s　]+)",match)



return match1



}



getUserId(sid){



if !checkSid(sid)



return



global portalUrl



httprequest(portalUrl "/General/Redirect.aspx?SESSION=" sid,page)



RegExMatch(page,"Portal_UserID=([^\']+)\'",match)



return match1



}



checkSid(sid){



global portalUrl



if !RegExMatch(sid,"i)^[A-Z\d]+$")



return 0



httprequest(portalUrl "/General/Redirect.aspx?SESSION=" sid,page)



return instr(page,sid) ? 1 : 0



}



renewSid(sid,loginId,loginPw){



if checkSid(sid)



return sid



else



return login(loginId,loginPw)



}



login(loginId, loginPw, hospitalCode=0){



global portalUrl, portalAspId



StringUpper,loginId,loginId



hospitalCode:=hospitalCode="H"?"T4":hospitalCode="Y"?"Y0":SubStr(hospitalCode,1,1)="T"?hospitalCode:"T" hospitalCode



header=



	(Ltrim



	SOAPAction: "http://10.0.0.100/General/SessionService.asmx/NewSession"



	Host: sess.hospital-n.local



	Content-Type: text/xml; charset=utf-8



)



httprequest(url:="http://sess.hospital-n.local/SessionService/SessionService.asmx"



, post:="<?xml version=""1.0"" encoding=""utf-8""?><soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema""><soap:Body><NewSession xmlns=""http://10.0.0.100/General/SessionService.asmx""><UserID>"  loginId "</UserID><password>" md5(loginPw)"</password><RemoteIP>10.0.0.100</RemoteIP><strHospital>" hospitalCode "</strHospital></NewSession></soap:Body></soap:Envelope>"



, header, "charset: utf-8")



,RegExMatch(post, "> *(\w{32,}) *<", match)



,httprequest(url:="http://portal.hospital-n.local/General/NewRedirect.aspx?SESSION=" match1, post:="", header:="")



,RegExMatch(header,"(?<=ASP.NET_SessionId=)[^;]+", portalAspIdNew)



if portalAspIdNew!=



portalAspId:=portalAspIdNew



return match1



}



login_without_captcha(loginId,loginPw,HospitalCode=0){



global portalUrl, portalAspId



httprequest(url:=portalUrl "/General/Login.aspx",html:="", header:="")



,inputs:=[]



,inputs[s:="__VIEWSTATE"]:="" get(html,s)



,inputs[s:="__EVENTVALIDATION"]:="" get(html,s)



,inputs["txtUserID"]:="" loginId



,inputs["txtPass"]:="" md5(loginpw)



,inputs["ddlHospital"]:=hospitalCode="H"?"T4":hospitalCode="Y"?"Y0":SubStr(hospitalCode,1,1)="T"?hospitalCode:"T" hospitalCode



,inputs["rdblQuickMenu"]:="H"



,RegExMatch(header,"(?<=ASP.NET_SessionId=)[^;]+", portalAspIdNew)



if portalAspIdNew!=



portalAspId:=portalAspIdNew



str=



for k,v in inputs



str.= encodeurl(k) "=" encodeurl(v) "&"



post:=str "imgBtnSubmitNew.x=0&imgBtnSubmitNew.y=0"



,header:=""



,httprequest(url,post,header,"charset: utf-8")



,RegExMatch(post,"i)SESSION=([A-Z\d]+)",match)



return match1 ? match1 : ""



}



logout(sid,portalAspId){



global portalUrl



httprequest(url:="http://portal.hospital-n.local/General/Redirect.aspx?SESSION=" sid,html:="")



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: http://portal.hospital-n.local/General/Redirect.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: portal.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=" getUserId(sid) "&SessionKey=" sid "&LoginPosCode=H&LoginPosCodeIndex=0; ASP.NET_SessionId=" portalAspId



post:="__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&ibtnLogOut.x=63&ibtnLogOut.y=22"



httprequest(url,post,header,"charset: utf-8")



}



patientBasicInfo(chartNo,sid,byref html=""){



if !checkSid(sid)



return []



while strlen(chartNo)<7



chartNo:="0" chartNo



if !regexmatch(chartNo,"(\w)\w{5}\d")



return



if(html=""){



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx?QueryBySelf=N&SESSION=" sid,html:="")



,inputs:=[]



,inputs[s:="__VIEWSTATE"]:="" get(html,s)



,inputs[s:="__EVENTVALIDATION"]:="" get(html,s)



,inputs["NWeb1$PatientBasicInfoQueryByIDAndName1$ctl01"]:="" chartNo



,inputs["NWeb1$PatientBasicInfoQueryByIDAndName1$ctl09"]:="查詢"



post=



for k,v in inputs



post.= encodeurl(k) "=" encodeurl(v) "&"



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " url "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



}else {



post:=html



}



ptInfo:=[]



,RegExMatch(post,"<[^>]+\sid=""NWeb1_PatAccountListRecord1_PatBasicDescription""[^>]*>([^\(]+)\(([^\,])\,(\d+)\/(\d+)\/(\d+)\,([^\)]+)\)",match)



,ptInfo.name:=match1



,ptInfo.gender:=match2



,ptInfo.birthYear:=match3



,ptInfo.birthMonth:=match4



,ptInfo.birthDay:=match5



,ptInfo.age:=match6



,ptInfo.personId:=get(post,"NWeb1_PatAccountListRecord1_personidHidden")



if (instr(post,"住院中")||instr(post,"已住院登記")||(trim(txt:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelStatusName"))&&(!instr(txt,"已出院"))))



ptInfo.ward:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelWardName") " " getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelRoomName") "-" getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelBedName")



else if s:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewEmergencyContent_ctl02_LabelEmerTempBedID")



ptInfo.ward:="ER " s



else if (trim(txt:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewEmergencyContent_ctl02_LabelEmerStatusName"))&&txt!="已離部")



ptInfo.ward:="ER"



else



ptInfo.ward:="OPD"



return ptInfo



}



patientLabDataRecent(personId,sid){



if !checkSid(sid)



return



url:= "http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/ReportResultQuery.aspx?SESSION=" sid "&PatClass=I&PersonID=" personId "&Hosp=T0&DefaultQuery=EMRContent"



httprequest(url,data,header,"charset: utf-8`n+NO_COOKIES")



arr:=new portalLib_patientLabDataRecent(getHtmlById(data,"TablePatientLabResult"))



return arr



}



class portalLib_patientLabDataRecent {



__New(html){



i:=0,arr:=[]



while i:=RegExMatch(html,"is)<td>([^<]*)<\/td>",match,i+1) {



if a_index<10



continue



if mod(a_index,3)=1



item:=match1



else if mod(a_index,3)=2



value:=match1



else {



date:=match1



arr[item,"" date]:=value



}



}



this.lab:=arr



}



getValue(labName){



value:=[]



for k,v in this.lab {



if (isobject(labName)) {



for m,n in labName



if(k=n)



for x,y in v



value.push(array(x,y))



}else if(k=labName)



for x,y in v



value.push(array(x,y))



}



return value



}



}



waitLoaded(byref pwb,judge="",waitSeconds=30,firstDelay=200){



sleep % firstDelay



if !isobject(judge) {



while pwb.busy {



if (a_index>waitSeconds*10)



return 0



sleep 100



}



return 1



}else{



while !judge.(pwb) {



if (a_index>waitSeconds*10)



return 0



sleep 100



}



return 1



}



}



IEGet2(Name="",matchMode="1")



{



Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs" : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )



if(matchMode="1"){



For Pwb in ComObjCreate( "Shell.Application" ).Windows



If ( RegExMatch(Pwb.LocationName,"^" Name) && InStr( Pwb.FullName, "iexplore.exe" ))



Return Pwb



}else if(matchMode="2"){



For Pwb in ComObjCreate( "Shell.Application" ).Windows



If ( instr(Pwb.LocationName,Name) && InStr( Pwb.FullName, "iexplore.exe" ))



Return Pwb



}else if(matchMode="3"){



For Pwb in ComObjCreate( "Shell.Application" ).Windows



If ( Pwb.LocationName=Name) && InStr( Pwb.FullName, "iexplore.exe" )



Return Pwb



}else if(matchMode="RegEx"){



For Pwb in ComObjCreate( "Shell.Application" ).Windows



If ( RegExMatch(Pwb.LocationName,Name) && InStr( Pwb.FullName, "iexplore.exe" ))



Return Pwb



}



return ""



}



labOrderList(byref pwb,divId="NWeb1_OrderSearch1_pnlSearchOrders"){



arr:=[]



if instr(pwb.document.getElementById(divId).innerText,"查無醫令")



return arr



tr:=pwb.document.getElementById(divId).getElementsByTagName("a")



loop % tr.length



if RegExMatch(tr[a_index-1].id,"NWeb1_OrderSearch1_dlsOrders_ctl\d+_lbnName")



arr[tr[a_index-1].innerText]:=tr[a_index-1].id



return arr



}



medOrderList(pwb,divId="NWeb1_MedicationDrugSearchBox_pnlControl"){



arr:=[]



tr:=pwb.document.getElementById(divId).rows



loop % tr.length-1 {



name:=tr[a_index].cells[1].innerText



arr[name,"id"]:=tr[a_index].getElementsByTagName("input")[0].id



arr[name,"bName"]:=tr[a_index].cells[2].innerText



}



return arr



}



class portalLib_parseLabDataRegex



{



__New(html){



if !html



return ""



labTable:=getHtmlByTagName(html,"table")[2]



labTableRows:=getHtmlByTagName(labTable,"tr")



lab:=[]



loop % labTableRows.maxIndex()



{



i:=a_index



labTableRowText:=getText(labTableRows[i])



if(i=1){



RegExMatch(labTableRowText,"病歷號:(\w{6}\d)\s+姓名:([^\n]+)(?:先生|小姐)\s+生日:\s民國\s([^\s]+)",match)



if !match1



break



lab.chartNo:="" match1



lab.name:="" match2



lab.birthDate:="" match3



continue



}



if (!labTableRowText)



continue



if(regexmatch(labTableRowText,"登記\s([^\s]+)\s+([^\s]+)\s+([^\n]+\s+)([^\s]+)\s+No:([^\s]+)\s+(?:詳細資料\s+)?報告\s([^\s]+)\s+([^\s]+)",match)){



labNo:=match5



lab[labNo]:=[]



lab[labNo].registerDate:="" match1



lab[labNo].registerTime:="" match2



lab[labNo].sample:="" trim(match3)



lab[labNo].examRoom:="" match4



lab[labNo].reportDate:="" match6



lab[labNo].reportTime:="" match7



continue



}



if(instr(labTableRowText,"檢查項目")){



labNameCol:=labValueCol:=labUnitCol:=labRangeCol:=labInfoCol:=""



loop % getHtmlByTagName(labTableRows[i],"td").maxIndex()



{



labTableCellText:=getText(getHtmlByTagName(labTableRows[i],"td")[a_index])



if instr(labTableCellText,"檢查項目")



labNameCol:=a_index



else if instr(labTableCellText,"數值")



labValueCol:=a_index



else if instr(labTableCellText,"單位")



labUnitCol:=a_index



else if instr(labTableCellText,"標準值")



labRangeCol:=a_index



else if instr(labTableCellText,"說明")



labInfoCol:=a_index



}



continue



}



if !labNameCol || !labNo



continue



else



{



labTableCells:=getHtmlByTagName(labTableRows[i],"td")



labName:=trim(getText(labTableCells[labNameCol]))



lab[labNo][labName]:=[]



if labValueCol



lab[labNo][labName].value:="" trim(getText(labTableCells[labValueCol]))



if labUnitCol



lab[labNo][labName].unit:="" trim(getText(labTableCells[labUnitCol]))



if labRangeCol



lab[labNo][labName].range:="" trim(getText(labTableCells[labRangeCol]))



if labInfoCol



lab[labNo][labName].info:="" trim(getText(labTableCells[labInfoCol]))



}



}



labHxTable:=getHtmlByTagName(html,"table")[3]



labHxTableRows:=getHtmlByTagName(labHxTable,"tr")



labHx:=[]



loop % labHxTableRows.maxIndex()-1



{



labHxTableRow:=labHxTableRows[a_index+1]



labHx[a_index]:=[]



labHx[a_index].account:="" getText(getHtmlByTagName(labHxTableRow,"td")[2])



labHx[a_index].ptFrom:="" getText(getHtmlByTagName(labHxTableRow,"td")[3])



labHx[a_index].earliest:="" getText(getHtmlByTagName(labHxTableRow,"td")[4])



labHx[a_index].last:="" getText(getHtmlByTagName(labHxTableRow,"td")[5])



labHx[a_index].newest:="" getText(getHtmlByTagName(labHxTableRow,"td")[6])



RegExMatch(getHtmlByTagName(labHxTableRow,"td")[2],"href=""([^""]+)""",match)



labHx[a_index].link:="" match1



}



lab["labHx"]:=labHx



this.lab:=lab



}



getValue(labName,sample="BLOOD"){



StringUpper,sample,sample



result:=[]



for k,v in this.lab



{



if k is not number



continue



if !(v.sample=sample)



continue



for i,j in v



{



if !isobject(j)



continue



if(i=labName)



result.push(array("" v.registerDate " " v.registerTime,"" j.value))



}



}



return result



}



}



class portalLib_parseLabData



{



__New(html){



if !html



return ""



doc := ComObjCreate("{25336920-03F9-11CF-8FD0-00AA00686F13}")



doc.write(html)



labTable:=doc.getElementsByTagName("table")[1]



labTableRows:=labTable.rows



lab:=[]



loop % labTableRows.length



{



i:=a_index-1



labTableRowText:=labTableRows[i].innerText



if(!i){



RegExMatch(labTableRowText,"病歷號:(\w{6}\d)\s+姓名:([^\n]+)(?:先生|小姐)\s+生日:\s民國\s([^\s]+)",match)



if !match1



break



lab.chartNo:="" match1



lab.name:="" match2



lab.birthDate:="" match3



continue



}



if (!labTableRowText)



continue



if(regexmatch(labTableRowText,"登記\s([^\s]+)\s+([^\s]+)\s+([^\n]+\s+)([^\s]+)\s+No:([^\s]+)\s+(?:詳細資料\s+)?報告\s([^\s]+)\s+([^\s]+)",match)){



labNo:=match5



lab[labNo]:=[]



lab[labNo].registerDate:="" match1



lab[labNo].registerTime:="" match2



lab[labNo].sample:="" trim(match3)



lab[labNo].examRoom:="" match4



lab[labNo].reportDate:="" match6



lab[labNo].reportTime:="" match7



continue



}



if(instr(labTableRowText,"檢查項目")){



labNameCol:=labValueCol:=labUnitCol:=labRangeCol:=labInfoCol:=""



loop % labTableRows[i].cells.length



{



labTableCellText:=labTableRows[i].cells[a_index-1].innerText



if instr(labTableCellText,"檢查項目")



labNameCol:=a_index-1



else if instr(labTableCellText,"數值")



labValueCol:=a_index-1



else if instr(labTableCellText,"單位")



labUnitCol:=a_index-1



else if instr(labTableCellText,"標準值")



labRangeCol:=a_index-1



else if instr(labTableCellText,"說明")



labInfoCol:=a_index-1



}



continue



}



if !labNameCol || !labNo



continue



else



{



labTableCells:=labTableRows[i].cells



labName:=trim(labTableCells[labNameCol].innerText)



lab[labNo][labName]:=[]



if labValueCol



lab[labNo][labName].value:="" trim(labTableCells[labValueCol].innerText)



if labUnitCol



lab[labNo][labName].unit:="" trim(labTableCells[labUnitCol].innerText)



if labRangeCol



lab[labNo][labName].range:="" trim(labTableCells[labRangeCol].innerText)



if labInfoCol



lab[labNo][labName].info:="" trim(labTableCells[labInfoCol].innerText)



}



}



labHxTable:=doc.getElementsByTagName("table")[2]



labHxTableRows:=labHxTable.rows



labHx:=[]



loop % labHxTableRows.length-1



{



labHxTableRow:=labHxTableRows[a_index]



labHx[a_index]:=[]



labHx[a_index].account:="" labHxTableRow.cells[1].innerText



labHx[a_index].ptFrom:="" labHxTableRow.cells[2].innerText



labHx[a_index].earliest:="" labHxTableRow.cells[3].innerText



labHx[a_index].last:="" labHxTableRow.cells[4].innerText



labHx[a_index].newest:="" labHxTableRow.cells[5].innerText



labHx[a_index].link:="" labHxTableRow.cells[1].getElementsByTagName("a")[0].href



}



lab["labHx"]:=labHx



this.lab:=lab



}



getValue(labName,sample="BLOOD"){



StringUpper,sample,sample



result:=[]



for k,v in this.lab



{



if k is not number



continue



if !(v.sample=sample)



continue



for i,j in v



{



if !isobject(j)



continue



if(i=labName)



result.push(array("" v.registerDate " " v.registerTime,"" j.value))



}



}



return result



}



}



EncodeURL( p_data, p_reserved=true, p_encode=true )



{



old_FormatInteger := A_FormatInteger



SetFormat, Integer, hex



unsafe =



      ( Join LTrim



         25000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F20



         22233C3E5B5C5D5E607B7C7D7F808182838485868788898A8B8C8D8E8F9091929394



         95969798999A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A9AAABACADAEAFB0B1B2B3B4B5B6



         B7B8B9BABBBCBDBEBFC0C1C2C3C4C5C6C7C8C9CACBCCCDCECFD0D1D2D3D4D5D6D7D8



         D9DADBDCDDDEDF7EE0E1E2E3E4E5E6E7E8E9EAEBECEDEEEFF0F1F2F3F4F5F6F7F8F9



         FAFBFCFDFEFF



)



if ( p_reserved )



unsafe = %unsafe%24262B2C2F3A3B3D3F40



if ( p_encode )



loop, % StrLen( unsafe )//2



{



StringMid, token, unsafe, A_Index*2-1, 2



StringReplace, p_data, p_data, % Chr( "0x" token ), `%%token%, all



}



else



loop, % StrLen( unsafe )//2



{



StringMid, token, unsafe, A_Index*2-1, 2



StringReplace, p_data, p_data, `%%token%, % Chr( "0x" token ), all



}



SetFormat, Integer, %old_FormatInteger%



return, p_data



}



DecodeURL( p_data )



{



return, EncodeURL( p_data, true, false )



}



getLab4New(chartNo,sid,days=10){



global lab4portalAspId



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?PatClass=I&WardCode=03C1&ChartNo=" chartNo "&HospitalCode=T0&Seed=" a_now "&IntervalDay=-" days-1 "&SESSION=" sid



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; GTB7.5; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nCookie: CK_MedicalReportOpen_PatientQueryCookie=SelectPatListTypeCookieIPatList=&SelectPatListTypeCookieEPatList=&SelectPatListTypeCookieOPatList=&SelectPatListTypeCookieLabPatList=&SelectPatListTypeCookieSpeList=&SelectPatListTypeCookie=IPatList;"



httprequest(url,post:="",header,"charset: utf-8")



RegExMatch(header,"is).+ASP.NET_SessionId=(\w{24}).+",match)



lab4portalAspId:=match1



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?PatClass=I&WardCode=03C1&ChartNo=" chartNo "&HospitalCode=T0&Seed=" a_now "&IntervalDay=-" days-1 "&SESSION=" sid



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; GTB7.5; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nCookie: CK_MedicalReportOpen_PatientQueryCookie=SelectPatListTypeCookieIPatList=&SelectPatListTypeCookieEPatList=&SelectPatListTypeCookieOPatList=&SelectPatListTypeCookieLabPatList=&SelectPatListTypeCookieSpeList=; ASP.NET_SessionId=" lab4portalAspId



httprequest(url,post:="",header,"charset: utf-8")



dom:=ComObjCreate("HtmlFile")



dom.write(post)



return parseLab4New(dom)



}



parseLab4New(byref dom){



arr:=[]



loop % (spans:=$(dom,"lReportTab_lsvReportBody_ctrl0_ctl00_LabDetailedSheetControl1_SpanSort").parentNode.childNodes).length-1 {



specimen:=[]



span:=spans[a_index]



RegExMatch(text:=span.firstChild.innerText,"isO)([^:\d]+?):(.+?)\s([^:\d]+?):(\d+?)\s(.+)\s([^:\d]+?):(.+?)\s([^:\d]+?):(.+?)\s([^:\d]+?):(.+?)$",match)



specimen["Info","" trim(match.1)]:=trim(match.2)



specimen["Info","" trim(match.3)]:=trim(match.4)



specimen["Info","SpecimenName"]:=trim(match.5)



specimen["Info","" trim(match.6)]:=trim(match.7)



specimen["Info","" trim(match.8)]:=trim(match.9)



specimen["Info","" trim(match.10)]:=trim(match.11)



table:=span.getElementsByTagName("TABLE")[0]



titles:=[]



loop % (tds:=table.rows[0].childNodes).length



titles.push(trim(tds[a_index-1].innerText))



loop % (trs:=table.childNodes[1].childNodes).length {



item:=[],i:=a_index



for k,v in titles



item["" v]:="" trim(regexreplace(trs[i-1].childNodes[k-1].innerText,"歷$"))



specimen.push(item.clone())



}



arr.push(specimen.clone())



}



return arr



}



findLab4New(byref lab,itemName,specimenName="BLOOD"){



arr:=[],itemNameText:="檢驗項目",sort:=[],foundCount:=0



for i,specimen in lab



for k,item in specimen {



if (k="Info" || !(item[itemNameText]=itemName))



continue



if (time:=regexreplace(specimen["info","採檢"],"\D")) {



}else if (time:=regexreplace(specimen["info","登入"],"\D")) {



}else



time:=regexreplace(specimen["info","最後報告"],"\D")



sort[time]:=(++foundCount)



found:=item.clone()



for m,n in specimen.Info



found["" m]:="" n



arr.push(found.clone())



}



sortedArr:=[]



for k,v in sort



sortedArr[foundCount+1-a_index]:=arr[v].clone()



return sortedArr



}



searchLab4(chartNo,sid){



if !checksid(sid)



return



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?SESSION=" sid,html:="")



inputs:=[]



inputs["__LASTFOCUS"]:=""



inputs["__EVENTTARGET"]:=""



inputs["__EVENTARGUMENT"]:=""



inputs[s:="__VIEWSTATE"]:="" get(html,s)



inputs["__VIEWSTATEENCRYPTED"]:=""



inputs[s:="__PREVIOUSPAGE"]:="" get(html,s)



inputs[s:="__EVENTVALIDATION"]:="" get(html,s)



inputs["hdfDelayedAction"]:=""



inputs["hdfAction"]:=""



inputs["hdfSplitted"]:="false"



inputs["hdfSelectPatientList"]:=""



inputs["hdfPatientInfoStaus"]:=""



inputs["CleanCookie"]:="false"



inputs["HeaderTemplate1$hdfSelectedFilter"]:=""



inputs["HeaderTemplate1$hdfIsFilterSetModified"]:="False"



inputs["sltexample4"]:="LabReport"



inputs["sltexample4"]:="XrayTextReport"



inputs["sltexample4"]:="UltraSonicReport"



inputs["sltexample4"]:="ECGReport"



inputs["sltexample4"]:="CECGReport"



inputs["sltexample4"]:="TreadmillReport"



inputs["sltexample4"]:="ABPMReport"



inputs["sltexample4"]:="LungFunctionReport"



inputs["sltexample4"]:="ExerciseLungReport"



inputs["sltexample4"]:="GEEndoScopeReport"



inputs["sltexample4"]:="EchocardiogramExternalReport"



inputs["sltexample4"]:="EchocardiogramReport"



inputs["sltexample4"]:="HolterReport"



inputs["sltexample4"]:="HealthyCenterReport"



inputs["sltexample4"]:="PathologyReport"



inputs["sltexample4"]:="PapTestReport"



inputs["sltexample4"]:="SLP"



inputs["sltexample4"]:="UBTReport"



inputs["sltexample4"]:="UltraSoundReport"



inputs["sltexample4"]:="EEGReport"



inputs["sltexample4"]:="ConductionReport"



inputs["sltexample4"]:="EvokeReport"



inputs["sltexample4"]:="RTNoteReport"



inputs["sltexample4"]:="GeneticReport"



inputs["sltexample4"]:="ChromosomesReport"



inputs["sltexample4"]:="PEDEEGReport"



inputs["sltexample4"]:="PEDHEARTSONOReport"



inputs["sltexample4"]:="01400-4-601266"



inputs["sltexample4"]:="01400-4-601197"



inputs["sltexample4"]:="01400-4-601267"



inputs["sltexample4"]:="01400-4-601431"



inputs["multiselect_sltReportFilter"]:="LabReport"



inputs["multiselect_sltReportFilter"]:="XrayTextReport"



inputs["multiselect_sltReportFilter"]:="UltraSonicReport"



inputs["multiselect_sltReportFilter"]:="ECGReport"



inputs["multiselect_sltReportFilter"]:="CECGReport"



inputs["multiselect_sltReportFilter"]:="TreadmillReport"



inputs["multiselect_sltReportFilter"]:="ABPMReport"



inputs["multiselect_sltReportFilter"]:="LungFunctionReport"



inputs["multiselect_sltReportFilter"]:="ExerciseLungReport"



inputs["multiselect_sltReportFilter"]:="GEEndoScopeReport"



inputs["multiselect_sltReportFilter"]:="EchocardiogramExternalReport"



inputs["multiselect_sltReportFilter"]:="EchocardiogramReport"



inputs["multiselect_sltReportFilter"]:="HolterReport"



inputs["multiselect_sltReportFilter"]:="HealthyCenterReport"



inputs["multiselect_sltReportFilter"]:="PathologyReport"



inputs["multiselect_sltReportFilter"]:="PapTestReport"



inputs["multiselect_sltReportFilter"]:="SLP"



inputs["multiselect_sltReportFilter"]:="UBTReport"



inputs["multiselect_sltReportFilter"]:="UltraSoundReport"



inputs["multiselect_sltReportFilter"]:="EEGReport"



inputs["multiselect_sltReportFilter"]:="ConductionReport"



inputs["multiselect_sltReportFilter"]:="EvokeReport"



inputs["multiselect_sltReportFilter"]:="RTNoteReport"



inputs["multiselect_sltReportFilter"]:="GeneticReport"



inputs["multiselect_sltReportFilter"]:="ChromosomesReport"



inputs["multiselect_sltReportFilter"]:="PEDEEGReport"



inputs["multiselect_sltReportFilter"]:="PEDHEARTSONOReport"



inputs["multiselect_sltReportFilter"]:="01400-4-601266"



inputs["multiselect_sltReportFilter"]:="01400-4-601197"



inputs["multiselect_sltReportFilter"]:="01400-4-601267"



inputs["multiselect_sltReportFilter"]:="01400-4-601431"



inputs["q"]:=""



inputs["HeaderTemplate1$txbIDInput"]:="" chartNo



inputs["HeaderTemplate1$TextBoxWatermarkExtender1_ClientState"]:=""



inputs["HeaderTemplate1$btnQueryAction"]:="查詢"



inputs["PatientListTemplate1$rblPatList"]:="IPatList"



inputs["PatientListTemplate1$ddlBedHosp"]:="T0"



inputs["PatientListTemplate1$ddlWard"]:=""



post=



for k,v in inputs



post.= encodeurl(k) "=" encodeurl(v) "&"



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: InPatientWardDefaultQuery=T0|0000|00|; WardListColumnSelect=DR; ASP.NET_SessionId=MOCK_SESSION_ID



httprequest(url,post,header,"charset: utf-8")



return header "`n`n" post



}



LabIn10Days(chartNo,sid,personId=""){



if !checksid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



seed:=a_now



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" seed "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: portal.hospital-n.local`nConnection: Close`nCookie: _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=" getUserId(sid) "&SessionKey=" sid "&LoginPosCode=H&LoginPosCodeIndex=0"



httprequest("http://portal.hospital-n.local/new_digreport/Lab/NewQuery.asp?result_latest=Y&chartno=" chartNo,post:="",header,"charset: utf-8")



lab:=new portalLib_patientLabIn10Days(post)



return lab



}



class portalLib_patientLabIn10Days {



__New(html){



i:=0,arr:=[],labNo:=""



dom:=ComObjCreate("HtmlFile")



dom.write(html)



loop % (tables:=dom.getElementsByTagName("TABLE")).length {



v:=tables[a_index-1]



if RegExMatch(v.innerText,"[^\s]+\s+([^\n]+)\s+No:(\d+)\s+\(\s+(\d+).(\d+).(\d+)\s+(\d+:\d+)[^\(]+\((\d+).(\d+).(\d+)\s+(\d+:\d+)",match){



labNo:=match2



arr["" labNo,"sample"]:="" trim(match1)



arr["" labNo,"regDate"]:=(match3+1911) match4 match5



arr["" labNo,"regTime"]:="" match6



arr["" labNo,"reportDate"]:=(match7+1911) match8 match9



arr["" labNo,"reportTime"]:="" match10



continue



}



if !labNo



continue



if(v.getElementsByTagName("TABLE").length)



continue



loop % (tr:=v.rows).length {



if(a_index=1)



continue



if (td:=tr[a_index-1].cells).length<6



continue



labName:="" trim(td[1].innerText)



arr["" labNo,"" labName,"value"]:="" trim(td[2].innerText)



arr["" labNo,"" labName,"unit"]:="" trim(td[3].innerText)



arr["" labNo,"" labName,"range"]:="" trim(td[4].innerText)



arr["" labNo,"" labName,"condition"]:="" trim(td[5].innerText)



}



labNo:=""



}



this.lab:=arr



}



getValue(byref labName,sample="BLOOD"){



result:=[]



StringUpper,sample,sample



for k,v in this.lab {



if (!isobject(v) || v.sample!=sample)



continue



if (isobject(labName))



for m,n in labName



if(isobject(v[n]))



result[v.reportDate]:=v[n]



else if (isobject(v[labName]))



result[v.reportDate]:=v[labName]



}



return result



}



}



patientBasicInfoTree(chartNo,sid,function="",personId=""){



global portalAspId



if !function



return



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now



,header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"



,httprequest(url,page:="",header,"charset: utf-8")



,RegExMatch(page,"i)http:[^']+?SimpleInfoShowUsingPlaceHolder[^']+?Func=" function "&[^']+?Seed=\d+",match)



if InStr(match, "\\"){



split:=RegExSplit(match, "\\\\")



for k,v in split.split



if InStr(v, function){



match:=v



break



}



}



return (match?RegExReplace(match,"&amp;","&"):"")



}



getReportByPortal(sid, chartNo, ByRef AccNo, ByRef PacsHx="", ByRef personId="", ExamNameRegex=""){



static prvChartNo, prvPacsHx, prvPersonId



while strlen(chartNo)<7



chartNo:="0" chartNo



if !(PacsHx.maxIndex()>0)



if (chartNo=prvChartNo && prvPacsHx.maxIndex()>0)



PacsHx:=prvPacsHx



else



PacsHx:=patientBasicInfoWebTree(patientBasicInfoWeb(chartNo, sid, personId)).getNodeByNames("置頂","報告","影核醫報告").arr



if !personId



if (chartNo=prvChartNo && prvPersonId!="")



personId:=prvPersonId



else



personId:=patientBasicInfo(chartNo,sid).personId



prvChartNo:=chartNo



, prvPacsHx:=PacsHx



, prvPersonId:=personId



if (accno="" && ExamNameRegex!=""){



ret:=[]



for k,v in PacsHx



if (RegExMatch(v.innerText, ExamNameRegex))  {



RegExMatch(v.href, "_([TY]\w{9}\d)&", accno)



, accno:=accno1



,RegExMatch(v.href, "http[^']+", url)



,httprequest(url, post:=""



, header:="Referer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now " `nHost: ihisaw.hospital-n.local", "charset: utf-8")



,dom:=ComObjCreate("HtmlFile")



,dom.write(post)



,arr:=[]



,fields:=[["", "AccessNo", "","IOE","","ReferDept"],["","Status","","FormalVersion","","ExamDate"]



,["","OrderDescription","","ReportDate"],[],["ReportBody"],[],["Impression"],["","ReportDr"]]



,table:=dom.getElementById("rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay")



for k,v in fields



for m,n in v



if (n!="")



try



arr[n]:=Trim((n~="i)reportbody|impression")?(table.rows[k-1].cells[m-1].getElementsByTagName("textarea")[0].innerText):(table.rows[k-1].cells[m-1].innerText))



ret[accno1]:=arr



}



return ret



}else if(accno!="") {



for k,v in PacsHx



if (InStr(v.href, "_" AccNo "&"))  {



RegExMatch(v.href, "http[^']+", url)



,httprequest(url, post:=""



, header:="Referer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now " `nHost: ihisaw.hospital-n.local", "charset: utf-8")



,dom:=ComObjCreate("HtmlFile")



,dom.write(post)



,arr:=[]



,fields:=[["", "AccessNo", "","IOE","","ReferDept"],["","Status","","FormalVersion","","ExamDate"]



,["","OrderDescription","","ReportDate"],[],["ReportBody"],[],["Impression"],["","ReportDr"]]



,table:=dom.getElementById("rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay")



for k,v in fields



for m,n in v



if (n!="")



try



arr[n]:=Trim((n~="i)reportbody|impression")?(table.rows[k-1].cells[m-1].getElementsByTagName("textarea")[0].innerText):(table.rows[k-1].cells[m-1].innerText))



return arr



}



}



}



getPacsHxByPortalParser(ByRef arr){



for k,v in arr {



if RegExMatch(v.innerText, "s)^(\d+)\/(\d+)\/(\d+)_(.+?)(?:\(V(\d+)\))?$", m)



arr[k, "ExamDate"]:=m1 m2 m3



, arr[k, "ExamName"]:=m4



, arr[k, "FormalVersion"]:=m5



else if RegExMatch(v.innerText, "s)^(\d+)(\d+)(\d+) (.+?)(?:\(V(\d+)\))?$", m)



arr[k, "ExamDate"]:=m1 m2 m3



,arr[k, "ExamName"]:=m4



, arr[k, "FormalVersion"]:=m5



if RegExMatch(v.href, "i)PersonID=([a-z\d]+)", m)



arr[k, "PersonId"]:=m1



if RegExMatch(v.href, "i)ChartNo(?:List)?=([^&]+)", m)



arr[k, "ChartNo"]:=m1



if RegExMatch(v.href, "i)ReportKey=([^_]+)_([^_]+)?_([^&]+)", m)



arr[k, "HospitalCode"]:=m1



,arr[k, "ReportDate"]:=SubStr(m2, 1, 8)



,arr[k, "ReportKey"]:=m2



,arr[k, "AccNo"]:=m3



else if RegExMatch(v.href, "i)RequestSheetNoList=([^&]+)", m)



arr[k, "AccNo"]:=m1



}



}



getPacsHxByPortal(sid, chartNo, ByRef PacsHx="", ByRef personId=""){



arr:=(infoTree:=patientBasicInfoWebTree(patientBasicInfoWeb(chartNo, sid, personId))).getNodeByNames("置頂","報告","影核醫報告").arr



for k,v in infoTree.getNodeByNames("置頂", "PACS","CTOT").arr



arr.push(v)



for k,v in infoTree.getNodeByNames("置頂", "PACS","MROT").arr



arr.push(v)



for k,v in infoTree.getNodeByNames("置頂", "PACS","MGOT").arr



arr.push(v)



getPacsHxByPortalParser(arr)



return PacsHx:=arr



}



getPacsHxTimeline(sid, ByRef PacsHx, ByRef AllReports=""){



ret:=[]



,first:=getReportByPortal(sid, PacsHx[1].chartNo, PacsHx[1].AccNo, PacsHx, PacsHx[1].personId)



, status:=first.IOE



, PacsHx[1, "report"]:=first



,ret[1]:=[PacsHx[1]]



for k,v in PacsHx {



if k=1



continue



report := getReportByPortal(sid, v.chartNo, v.AccNo, PacsHx, v.personId)



,AllReports.push(report)



,v["report"]:=report



if (report.IOE=status){



ret[ret.maxIndex()].push(v)



}else{



status:=report.IOE



,ret.push([v])



}



}



return ret



}



patientBasicInfoWeb(chartNo,sid,ByRef personId="",medicalPrivacy="C5"){



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now



,header2:=header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"



,httprequest(url,page:="",header,"charset: utf-8`n+NO_COOKIES")



if(instr(page,"確認非醫療業務執行期間開檔申請")){



RegExMatch(page,"<form[^>]+action=""[^>]+ReturnPath=(\w+)[^>]+>",match)



url2:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/MedicalManagementAuthor.aspx?SESSION=" sid "&PersonID=" personId "&ReturnPath=" match1



header2:="Accept: */*`nAccept-Language: zh-tw`nReferer: " url2 "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



post2:="ScriptManager1=UpdatePanelContent%7CConfirmButton&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(page,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(page,"__EVENTVALIDATION")) "&SelectCodeValue=" medicalPrivacy "&RBList=" medicalPrivacy "&OtherReason=&__ASYNCPOST=true&ConfirmButton=%E7%A2%BA%E8%AA%8D%E7%94%B3%E8%AB%8B%E9%96%8B%E6%AA%94"



httprequest(url2,post2,header2,"charset: utf-8`n+NO_COOKIES")



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now



header2:=header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"



httprequest(url,page:="",header,"charset: utf-8`n+NO_COOKIES")



}



return page



}



patientBasicInfoWebTree(html,recursing="",returnClass=1){



if(!recursing){



static dom:=ComObjCreate("HtmlFile")



dom.write(html)



,page:=dom.getElementById("TreeViewItemn0Nodes")



}else{



page:=dom.getElementById(recursing)



}



arr:=[]



Loop % (children:=page.childNodes).length {



v:=children[A_Index-1]



if(v.tagName="table"){



node:=[],a:=v.getElementsByTagName("a"),a:=a[a.length-1]



,node.innerText:=Trim(a.innerText)



,node.id:=a.id



,node.href:="" a.href



if(v.nextSibling.tagName!="div"){



arr.push(node)



}



}else if(v.tagName="div"){



node.childNodes:=patientBasicInfoWebTree(html, v.id)



,arr.push(node)



}



}



if (returnClass && !recursing){



return new portalLib_patientBasicInfoWebTree(arr)



}else



return arr



}



class portalLib_patientBasicInfoWebTree {



__New(ByRef arr){



this.arr:=arr



}



getNodeByNames(params*){



thisNode:=this.arr



for k,v in params {



found:=0



for m,n in thisNode {



if (n.innerText=v){



thisNode:=n.childNodes, found:=1



break



}



}



if(!found)



return []



}



return new portalLib_patientBasicInfoWebTree(thisNode)



}



}



checkMedicalManagement(url, header, ByRef post, check="C5"){



global __VIEWSTATE, __VIEWSTATEGENERATOR, __EVENTVALIDATION, portalAspId



if InStr(post, "確認非醫療業務執行期間開檔申請"){



dom:=ComObjCreate("HtmlFile")



,dom.write(post)



,url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/" dom.getElementById("form1").action



,pwb:=ComObjCreate("InternetExplorer.Application")



,pwb.navigate(url)



Loop



Sleep 100



until !pwb.busy || A_Index>300



b:=pwb.document.getElementsByTagName("input")



Loop % b.length



{



e:=b[A_Index-1]



if(e.getAttribute("name")="RBList" && e.getAttribute("type")="radio" && e.getAttribute("value")=check){



e.Click()



break



}



}



pwb.document.getElementById("ConfirmButton").Click()



Loop



Sleep 100



until !pwb.busy || A_Index>30



post:=pwb.document.documentElement.innerHTML



,pwb.quit()



}



return post



}



patientBriefMedicalRecord(chartNo,sid,personId=""){



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:=patientBasicInfoTree(chartNo,sid,"PatientBriefMedicalRecord",personId)



,httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")



,arr:=[]



,dom:=ComObjCreate("HtmlFile")



,dom.write(page)



,RegExMatch(page,"體重:([.\d]+)",match)



,arr["BW"]:="" (match1?"" match1:"")



,RegExMatch(page,"身高:([.\d]+)",match)



,arr["BH"]:="" (match1?"" match1:"")



,e:=dom.getElementById("PanelDetailBasicInfo")



,RegExMatch(e.innerText, "is)(\(?電話\)?)?([^手]*)(\(?手機\)?)?([^住]*)(住址)?:?(.*)", match)



,arr["Phone"]:= (Trim(match2)="" || InStr(match2, "(00)0"))?"":Trim(RegExReplace(match2, "\($", ""))



,arr["CellPhone"]:=Trim(match4)



,arr["Address"]:=Trim(match6)



return arr



}



patientFutureSchedule(chartNo,sid,personId=""){



global portalAspId



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:=patientBasicInfoTree(chartNo,sid,"FutureSchedule",personId)



,httprequest(url,page:="",header:="","charset: utf-8")



,arr:=[]



,dom:=ComObjCreate("HtmlFile")



,dom.write(page)



,e:=dom.getElementById("TableFutureSchedule")



if(e.id)



arr.OPD:=[]



Loop % (rows:=e.rows).length-2 {



cells:=row:=rows[A_Index+1].cells



,c:=[]



for k,v in ["Date","Shift","Department","OPDnumber","OrderNumber","Doctor"]



c[v]:=Trim(cells[k-1].innerText)



arr.OPD.push(c)



}



e:=dom.getElementById("TableImageSchedule")



if(e.id)



arr.Image:=[]



Loop % (rows:=e.rows).length-2 {



cells:=row:=rows[A_Index+1].cells



,c:=[]



for k,v in ["Date","Shift","ExamRoom","OrderNumber","ExamName"]



c[v]:=Trim(cells[k-1].innerText)



arr.Image.push(c)



}



return arr



}



patientBWBH(chartNo,sid,personId=""){



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientBasicExaminationInfo.aspx?SESSION=" sid "&PersonID=" personId "&Hosp=T0&PatClass=E"



,httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")



,arr:=[]



,arr["BH"]:="" regexreplace(getTextById(page,"TextBoxInputArea_ctl00_Label1"),"i)上次記錄 : ([\d.]+|nil|NA)","$1")



,arr["BW"]:="" regexreplace(getTextById(page,"TextBoxInputArea_ctl01_Label1"),"i)上次記錄 : ([\d.]+|nil|NA)","$1")



,arr["UpdateDate"]:="" RegExReplace(getTextById(page,"ErrorMessage"),"is).+?([\d\/]+).*?","$1")



return arr



}



patientLabHistory(chartNo,sid,personId=""){



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&PersonID=" personId "&Func=LabResultHistory&Seed=" a_now



httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")



return o:=new portalLib_patientLabHistory(page)



}



fill0(str,n=2,fill="0"){



while strlen(str)<n



str:=fill str



return str



}



parseRisPatientMainPage(html){



arr:=[]



html:=RegExReplace(html,"is)<input type=""hidden"" name=""__VIEWSTATE"" id=""__VIEWSTATE"" value="".+?"" \/>")



dom:=comobjcreate("HtmlFile")



dom.write(html)



arr["OrderName"]:=$(html,"NWeb1_OrderScheduleInfo1_OrderNameLabel").innerText



arr["CreatePersonName"]:=$(html,"NWeb1_OrderScheduleInfo1_lblCreateName").innerText



arr["AccountNo"]:=$(html,"NWeb1_OrderScheduleInfo1_lblAccountNo").innerText



arr["SheetNo"]:=$(html,"NWeb1_OrderScheduleInfo1_RequestSheetLabel").innerText



arr["OrderStatus"]:=$(html,"NWeb1_OrderScheduleInfo1_OrderStatusLabel").innerText



arr["ConfirmPersonName"]:=$(html,"NWeb1_OrderScheduleInfo1_LabelConfirmEmp").innerText



arr["OrderTime"]:=$(html,"NWeb1_OrderScheduleInfo1_lblCreateDateTime").title



arr["RegisterTime"]:=$(html,"NWeb1_OrderScheduleInfo1_RegisterTimeLabel").title



arr["LoginTime"]:=$(html,"NWeb1_OrderScheduleInfo1_LoginDateTimeLabel").title



arr["NotPerformReason"]:=$(html,"NWeb1_OrderScheduleInfo1_NotPerformReasonList").value



arr["SpecialInstruction"]:=$(html,"NWeb1_OrderScheduleInfo1_SpecialInstructionLabel").innerText



arr["ExecuteDr"]:=$(html,"NWeb1_OrderScheduleInfo1_ExecuteDrListLabel").innerText



arr["CCC"]:=$(html,"NWeb1_OrderScheduleInfo1_lblExecuteCCC").innerText



arr["ReportDr"]:=$(html,"NWeb1_OrderScheduleInfo1_ReportDrListLabel").innerText



arr["Technician"]:=$(html,"NWeb1_OrderScheduleInfo1_TechnicianList").innerText



arr["Machine"]:=$(html,"NWeb1_OrderScheduleInfo1_ExecuteMachineList").innerText



arr["ExecuteRecord"]:=$(html,"NWeb1_OrderScheduleInfo1_ExcuteRecordInfo").innerText



arr["ReportTime"]:=$(html,"NWeb1_OrderScheduleInfo1_txbReportDateTime").value



arr["ShouldPayAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblShouldPayAmount").innerText



arr["PaidAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblPaidAmount").innerText



arr["NeedToPayAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblNeedToPayAmount").innerText



arr["LastPaidDate"]:=$(html,"NWeb1_OrderScheduleInfo1_lblLastPaidDate").innerText



arr["LastPaidDate"]:=$(html,"NWeb1_OrderScheduleInfo1_lblLastPaidDate").innerText



loop % (tr:=$(html,"NWeb1_AppendCreateOrders1_grvTreOrders").rows).length {



arr["CreateOrders",a_index,"class"]:=(td:=tr[a_index+1].cells)[2].innerText



arr["CreateOrders",a_index,"code"]:=td[3].innerText



arr["CreateOrders",a_index,"name"]:=td[4].innerText



arr["CreateOrders",a_index,"amount"]:=td[5].innerText



arr["CreateOrders",a_index,"ifEmergent"]:=td[6].innerText



arr["CreateOrders",a_index,"accountType"]:=td[7].innerText



arr["CreateOrders",a_index,"executeTime"]:=td[8].innerText



}



return arr



}



getAccountIdFromAccNo(sid, AccNo){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId



url:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid



if (__VIEWSTATE="" || __EVENTVALIDATION="" || portalAspId=""){



httprequest(url, post:="",header:="", "charset: utf-8")



RegExMatch(header,"i)(?<=ASP.NET_SessionId=)\w+",portalAspId)



renewPortalState(post)



}



StartDate:=substr(a_now,1,4) "/" substr(a_now,5,2) "/" substr(a_now,7,2)



header=



	(LTrim



	Accept: */*



	Accept-Language: zh-tw



	Referer: %url%



	Host: hisaw.hospital-n.local



	Cookie: 3=1; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y&IsShowBarCode=N; ASP.NET_SessionId=%portalAspId%; JSESSIONID=null



	Connection: Keep-Alive



	x-microsoftajax: Delta=true



	Content-Type: application/x-www-form-urlencoded; charset=utf-8



	Cache-Control: no-cache



	Accept-Encoding: gzip, deflate



	User-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322; .NET4.0C; .NET4.0E)



	Pragma: no-cache



)



post:="NWeb1%24ScriptManager1=NWeb1%24uPnlQuery%7CNWeb1%24btnQueryByPatient&scrollLeft=&scrollTop=&__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__VIEWSTATEGENERATOR=377EE134&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=BDE1&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=&NWeb1%24ddlPatClass=&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=1&NWeb1%24txbRequestSheetNo=" AccNo "&NWeb1%24txbPersonID=&NWeb1%24txbAccountNo=&NWeb1%24txbChartNo=&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&__ASYNCPOST=true&NWeb1%24btnQueryByPatient=%E7%97%85%E4%BA%BA%E6%9F%A5%E8%A9%A2"



httprequest(url, post, header1:=header, "charset: utf-8")



if !instr(post,AccNo)



return -1



renewPortalState(post)



post:="NWeb1%24ScriptManager1=NWeb1%24uPnlOrders%7CNWeb1%24grvPatientOrderList%24ctl02%24lbnSelect&scrollLeft=&scrollTop=&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=BDE1&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=&NWeb1%24ddlPatClass=&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=1&NWeb1%24txbRequestSheetNo=" AccNo "&NWeb1%24txbPersonID=&NWeb1%24txbAccountNo=&NWeb1%24txbChartNo=&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&NWeb1%24txbExecuteDate=" encodeurl(StartDate) " " substr(a_now,9,2) "%3A" substr(a_now,11,2) "&NWeb1%24ddlNotPerformReasonList=&NWeb1%24ddlFunctionType=&NWeb1%24ddlFunctionType2=&__LASTFOCUS=&__EVENTTARGET=NWeb1%24grvPatientOrderList%24ctl02%24lbnSelect&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION="  encodeurl(__EVENTVALIDATION) "&__AjaxControlToolkitCalendarCssLoaded=&__ASYNCPOST=true&"



httprequest(url,post,header1:=header,"charset: utf-8")



if !instr(post,"pageRedirect")



return -1



url:="http://hisaw.hospital-n.local/WebApplication/Radiology/PatientMainPage.aspx?SESSION=" sid



httprequest(url,post:="",header,"charset: utf-8")



if !instr(post,AccNo)



return -1



dom:=comobjcreate("HtmlFile")



dom.write(post)



return dom.getElementById("NWeb1_OrderScheduleInfo1_lblAccountNo").innerText



}



renewPortalState(post){



global __VIEWSTATE,__EVENTVALIDATION,__VIEWSTATEGENERATOR



if !VIEWSTATE:=get(post,"__VIEWSTATE")



regexmatch(post,"i)(?<=__VIEWSTATE\|)[^\|]+",VIEWSTATE)



if (VIEWSTATE!="")



__VIEWSTATE:=VIEWSTATE



if !EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



regexmatch(post,"i)(?<=__EVENTVALIDATION\|)[^\|]+",EVENTVALIDATION)



if (EVENTVALIDATION!="")



__EVENTVALIDATION:=EVENTVALIDATION



if !VIEWSTATEGENERATOR:=get(post,"__VIEWSTATEGENERATOR")



regexmatch(post,"i)(?<=__VIEWSTATEGENERATOR\|)[^\|]+",VIEWSTATEGENERATOR)



if (VIEWSTATEGENERATOR!="")



__VIEWSTATEGENERATOR:=VIEWSTATEGENERATOR



}



addPortalState(post){



global __VIEWSTATE,__EVENTVALIDATION,__VIEWSTATEGENERATOR



if !InStr(post, "__VIEWSTATE")



post.=(post=""?"":"&") "__VIEWSTATE=" encodeurl(__VIEWSTATE)



if !InStr(post, "__EVENTVALIDATION")



post.=(post=""?"":"&") "__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION)



if !InStr(post, "__VIEWSTATEGENERATOR")



post.=(post=""?"":"&") "__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR)



return post



}



getRisPatientMainPage(sid,which="",ChartNo="",UnitList="X",StartDate="",ShiftType="",PatClass="",QueryDays=1,SheetNo="",PersonID="",AccountNo=""){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId



if portalAspId=



portalAspId=3aq1hx55dvooyqyzlp0nod22



if which=



which:="02"



else



which:=fill0(which+1)



if (StartDate="")



StartDate:=substr(a_now,1,4) "/" substr(a_now,5,2) "/" substr(a_now,7,2)



url:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid



if (__VIEWSTATE="" || __EVENTVALIDATION=""){



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/Default.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"



httprequest(url,post:="",header,"charset: utf-8")



__VIEWSTATE:=get(post,"__VIEWSTATE")



__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



}



header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"



post:="NWeb1%24ScriptManager1=NWeb1%24uPnlOrders%7CNWeb1%24grvPatientOrderList%24ctl" which "%24lbnSelect&scrollLeft=0&scrollTop=99&__LASTFOCUS=&__EVENTTARGET=NWeb1%24grvPatientOrderList%24ctl" which "%24lbnSelect&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=CHCT&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=&NWeb1%24ddlPatClass=&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=1&NWeb1%24txbRequestSheetNo=&NWeb1%24txbPersonID=&NWeb1%24txbAccountNo=&NWeb1%24txbChartNo=&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&NWeb1%24txbExecuteDate=" encodeurl(StartDate) " " substr(a_now,9,2) "%3A" substr(a_now,11,2) "&NWeb1%24ddlNotPerformReasonList=&NWeb1%24ddlFunctionType=&NWeb1%24grvPatientOrderList%24ctl" which "%24cbxSelect=on&NWeb1%24ddlFunctionType2=&__ASYNCPOST=true&"



httprequest(url,post,header,"charset: utf-8")



url:="http://hisaw.hospital-n.local/WebApplication/Radiology/PatientMainPage.aspx?SESSION=" sid



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"



httprequest(url,post:="",header,"charset: utf-8")



return post



}



is_selfPaid(sid, accno){



a:=getRisSchedule(sid,"",accno)



,b:=new portalLib_parseRisSchedule(a)



,sch:=b.schedule



if !(sch.maxIndex()>=1)



return -1



return !!InStr(sch[1].BillType, "自費")



}



class portalLib_parseRisSchedule{



__New(html){



arr:=[]



dom:=comobjcreate("HtmlFile")



dom.write(html)



table:=$(dom,"NWeb1_grvPatientOrderList")



loop % table.rows.length-1 {



row:=table.rows[a_index]



exam:=[]



exam.Date:=trim(row.cells[2].firstChild.title)



exam.Shift:=trim(row.cells[3].innerText)



exam.ExamOrder:=trim(row.cells[4].innerText)



exam.ChartNo:=trim(row.cells[5].innerText)



exam.Name:=trim(row.cells[6].innerText)



exam.IdBirth:=trim(row.cells[6].firstChild.title)



exam.Gender:=trim(row.cells[7].innerText)



exam.Dept:=trim(row.cells[8].innerText)



exam.Dept1:=trim(row.cells[8].firstChild.title)



exam.BillType:=trim(row.cells[9].innerText)



exam.OrderName:=trim(row.cells[10].innerText)



exam.SheetNo:=trim(row.cells[10].firstChild.title)



exam.Status:=trim(row.cells[11].innerText)



exam.AccountStatus:=trim(row.cells[12].innerText)



exam.ArriveTime:=trim(row.cells[13].innerText)



exam.Emergent:=trim(row.cells[14].innerText)



exam.Portable:=trim(row.cells[15].innerText)



arr.push(exam.clone())



}



this.schedule:=arr



}



filter(byref exam,filterName,filterValue,fitType=0){



if instr(exam.Status,"刪除")



return 0



if(fitType=1)



return exam[filterName]=trim(filterValue)?1:0



else if(fitType=0 || fitType="")



return instr(exam[filterName],trim(filterValue))?1:0



else if(fitType=2)



return regexmatch(exam[filterName],trim(filterValue))?1:0



}



query(param){



arr:=[]



for k,v in this.schedule {



match:=true



for x,y in param



if !(match:=match && this.filter(v,y.1,y.2,y.3))



break



if match



arr.push(v.clone())



}



return arr



}



}



getRisSchedule(sid,ChartNo="",SheetNo="",UnitList="BDE1",StartDate="",ShiftType="",PatClass="",QueryDays=1,PersonID="",AccountNo=""){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId



if (chartNo!="")



loop % 7-strlen(chartNo)



chartNo:="0" chartNo



url:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid



if (__VIEWSTATE="" || __EVENTVALIDATION="" || !portalAspId){



httprequest(url,post:="",header,"charset: utf-8")



portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")



__VIEWSTATE:=get(post,"__VIEWSTATE")



__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



}



header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"



if (StartDate="")



formattime,StartDate,% a_now,yyyy/MM/dd



queryType:="NWeb1$uPnlQuery"



if (chartNo!="" || SheetNo !="" || PatientID!="" || AccountNo!="")



queryType.="|NWeb1$btnQueryByPatient"



else if UnitList!=X



queryType.="|NWeb1$ddlUnitList"



formattime,now,% a_now,yyyy/MM/dd hh:mm



post:="NWeb1%24ScriptManager1=" encodeurl(queryType) "&scrollLeft=&scrollTop=&__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=" encodeurl(UnitList) "&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=" encodeurl(ShiftType) "&NWeb1%24ddlPatClass=" encodeurl(PatClass) "&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=" encodeurl(QueryDays) "&NWeb1%24txbRequestSheetNo=" encodeurl(SheetNo) "&NWeb1%24txbPersonID=" encodeurl(PersonID) "&NWeb1%24txbAccountNo=" encodeurl(AccountNo) "&NWeb1%24txbChartNo=" encodeurl(ChartNo) "&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&__ASYNCPOST=true"



if (chartNo!="" || SheetNo !="" || PatientID!="" || AccountNo!="")



post.="&NWeb1%24btnQueryByPatient=%E6%8E%92%E7%A8%8B%E6%9F%A5%E8%A9%A2"



httprequest(url,post,header,"charset: utf-8")



return post



}



class portalLib_patientLabHistory {



__New(html){



arr:=[]



,ComObjError(false)



,dom:=ComObjCreate("HtmlFile")



,dom.write(html)



loop % (tr:=dom.getElementById("TableLabHistoryNote").rows).length {



if (td:=tr[a_index-1].cells).length <=1



continue



labName:=td[1].innerText



ind=0



loop % (i:=td[2].cells).length {



if(ind:=!ind){



RegExMatch(i[a_index-1].innerText,"is)(.+)\s([^\s]+?)$",match)



,labValue:=match1



,labUnit:=match2



}else{



labDate:=i[a_index-1].innerText



if !isobject(arr["" labName,"" labDate])



arr["" labName,"" labDate]:=[]



arr["" labName,"" labDate].push(array("" labValue,"" labUnit))



}



}



}



this.lab:=arr



}



getValue(labName){



result:=[]



if(!isobject(this.lab[labName]))



return result



for k,v in this.lab[labName]



result[k]:=v



return result



}



}



getPathoAspId(sid){



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/MedicalReportQuery/PathExam.aspx?SESSION=" sid



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Keep-Alive`nHost: ihisaw.hospital-n.local`nCookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y&%u5831%u544a%u67e5%u8a62=Y"



httprequest(url,post:="",header)



RegExMatch(header,"ASP.NET_SessionId=(\w{24})",match)



return match1



}



getPatho(sid,chartNo){



global pathoportalAspId



if !pathoportalAspId



pathoportalAspId:=getPathoAspId(sid)



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/MedicalReportQuery/PathExam.aspx"



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: " url "?`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y&%u5831%u544a%u67e5%u8a62=Y; ASP.NET_SessionId=" pathoportalAspId ";"



httprequest(url "?SESSION=" sid,html:="",h:=header)



post:="__EVENTTARGET=&__EVENTARGUMENT=&ctl07_ExpandState=eununnunnnnununnunnunnnnnununnunnn&ctl07_SelectedNode=&ctl07_PopulateLog=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&QueryByChartNo1%24txbPatChar=" chartNo "&QueryByChartNo1%24btnPerIDPatChar=%E6%9F%A5%E8%A9%A2"



httprequest(url,post,header,"charset: utf-8")



dom:=ComObjCreate("HtmlFile")



dom.write(post)



arr:=[]



loop % (rows:=dom.getElementById("PathExam_Control1_GridViewPathExamno").rows).length



{



if a_index=1



continue



cells:=rows[i:=a_index-1].cells



arr[i,"Name"]:=trim(cells[0].innerText)



arr[i,"PathoNo"]:=trim(cells[1].innerText)



arr[i,"Department"]:=trim(cells[2].innerText)



arr[i,"Ward"]:=trim(cells[3].innerText)



arr[i,"Specimen"]:=trim(cells[4].innerText)



arr[i,"getDate"]:="" trim(convertTaiwanDateToWestern(cells[5].innerText))



arr[i,"reportDate"]:="" trim(convertTaiwanDateToWestern(cells[6].innerText))



arr[i,"linkId"]:=trim(cells[7].firstChild.id)



}



return arr



}



getPatho2(chartNo){



url:="http://converws.hospital-n.local/WebApplication/PathologyReportWS/PathologyReportWS.asmx"



header:="SOAPAction: ""http://PathologyReportWS.hospital-n.local/GetPathReportListByChartNo""`nHost: converws.hospital-n.local`nContent-Type: text/xml; charset=utf-8"



post=



	(



	<?xml version="1.0" encoding="utf-8"?>



	<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">



	  <soap:Body>



		<GetPathReportListByChartNo xmlns="http://PathologyReportWS.hospital-n.local/">



		  <chartNo>%chartNo%</chartNo>



		</GetPathReportListByChartNo>



	  </soap:Body>



	</soap:Envelope>



)



httprequest(url,post,header,"charset: utf-8")



i:=0,arr:=[]



while (i:=regexmatch(post,"is)<Table.+?<PATHCODE>(.+?)</PATHCODE><CHARTNO>" chartNo "</CHARTNO><SPECIMENGETDATE>(.+?)</SPECIMENGETDATE><REPORTDATETIME>(.+?)</REPORTDATETIME><ORGSOURCE>(.+?)</ORGSOURCE>(?:<CHECKREPORT>(.+?)</CHECKREPORT>)?</Table>",match,i+1)) {



arr[a_index,"" "pathCode"]:="" match1



arr[a_index,"" "getDate"]:="" dateTimeParse1(match2).str



arr[a_index,"" "reportDate"]:="" dateTimeParse1(match3).str



arr[a_index,"" "resource"]:="" match4



arr[a_index,"" "report"]:="" match5



}



return arr



}



getLabValue(byref Lab2Arr,ItemName,SpecimenName="BLOOD"){



arr:=[],sort:=[],newArr:=[],foundCount:=0



if(isobject(ItemName)){



for k,v in Lab2Arr



for m,n in ItemName



if (v.ItemName=n && v.SpecimenName=SpecimenName) {



arr.push(v.clone())



if ((time:=regexreplace(v.LogDateTime,"\D"))&&floor(substr(time,1,1))>1){



}else



time:=regexreplace(v.ReleaseDateTime,"\D")



sort["" time (++foundCount)]:=(foundCount)



}



}else {



for k,v in Lab2Arr



if (v.ItemName=ItemName && v.SpecimenName=SpecimenName) {



arr.push(v.clone())



if ((time:=regexreplace(v.LogDateTime,"\D"))&&floor(substr(time,1,1))>1){



}else



time:=regexreplace(v.ReleaseDateTime,"\D")



sort["" time (++foundCount)]:=(foundCount)



}



}



for k,v in sort



newArr[foundCount+1-a_index]:=arr[v].clone()



return newArr



}



getLab2(chartNo,sid="",startDays=14,endDays=0,startTime="",endTime=""){



global ptInfo,birthday,userId



url:="http://converws.hospital-n.local/WebApplication/MedicalReportWS/MedicalReportSelectedLabItemReportWS.asmx"



header:="SOAPAction: ""http://tempuri.org/QueryLabReportWithNormalRange""`nHost: converws.hospital-n.local`nContent-Type: text/xml; charset=utf-8"



while(strlen(chartNo)<7)



chartNo:="0" chartNo



if (startTime=""){



date:=a_now



date+=-%startDays%,d



FormatTime,startTime,% date,yyyy-MM-ddTHH:mm:ss



}



if (endTime=""){



date:=a_now



date+=-%endDays%,d



FormatTime,endTime,% date,yyyy-MM-ddTHH:mm:ss



}



post=



	(



	<?xml version="1.0" encoding="utf-8"?>



	<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">



	  <soap:Body>



		<QueryLabReportWithNormalRange xmlns="http://tempuri.org/">



		  <chartNo>%chartNo%</chartNo>



		  <birthday>1900-01-01T00:00:00</birthday>



		  <loginEmpNo>000000</loginEmpNo>



		  <startTime>%startTime%</startTime>



		  <endTime>%endTime%</endTime>



		</QueryLabReportWithNormalRange>



	  </soap:Body>



	</soap:Envelope>



)



httprequest(url,post,header,"charset: utf-8")



itemName:=["SybaseAcc","PortalAcc","DeptCode","Value","itemCode","LoginNo","ItemName","UnitName","ItemNameShort","OrderCode","ACMGroupName","OrderSeqNo","SpecimenName","SpecimenCode","LogDate","LogDateTime","ReleaseDateTime","Description","ViewCondition","OperatorDefineRange","RangeResult","MaxValue","MinValue","PatientClassCode"]



i:=0,arr:=[]



while i:=RegExMatch(post,"is)<LabItem>(.+?)</LabItem>",m,i+1) {



j:=a_index



for k,v in itemName {



RegExMatch(m1,"<" v ">(.+?)</" v ">",match)



StringReplace,match1,match1,&gt;,>



StringReplace,match1,match1,&lt;,<



StringReplace,match1,match1,&nbsp;,%a_space%



StringReplace,match1,match1,&quot;,"



StringReplace,match1,match1,&amp;,&



arr[j,v]:=match1



}



}



return arr



}



dateTimeParse1(str,delim="-"){



arr:=[]



RegExMatch(str,"(\d{4})" delim "(\d{2})" delim "(\d{2})T(\d{2}):(\d{2}):(\d{2})((?:\+|-)(?:\d{2}):(?:\d{2}))",match)



arr.year:=match1



arr.month:=match2



arr.day:=match3



arr.hour:=match4



arr.minute:=match5



arr.second:=match6



arr.zone:=match7



arr.dateStr:=match1 fill0(match2) fill0(match3)



arr.timeStr:=fill0(match4) fill0(match5) fill0(match6)



arr.str:=arr.dateStr arr.timeStr



return arr



}



convertTaiwanDateToWestern(tw,delim="/"){



RegExMatch(tw,"(\d+)\" delim "(\d+)\" delim "(\d+)",match)



return (match1<200?(1911+match1):match1) fill0(match2) fill0(match3)



}



portalMessage(sid,phoneNos,msg,msgType=3){



global portalAspId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/CriticalVentilator/MessageSend.aspx?SESSION=" sid



if (msgType=2)



category:="rdbUnNormal"



else if (msgType=1)



category:="rdbCritical"



else



category:="rdbNormal"



httprequest(url,html:="")



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " url "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E; Sleipnir/2.9.14)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"



str:="`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null;"



post:="scrollLeft=&scrollTop=&__EVENTTARGET=NWeb1%24btnSendSMSAndEmail&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&NWeb1%24PersonIDInput=&NWeb1%24txbwardno=&NWeb1%24QueryInputByDr=&NWeb1%24PHSSendSeqNo=&NWeb1%24PHSTelNo=" phoneNos "&NWeb1%24txbEmail=&NWeb1%24MessageContent=" encodeurl(msg) "&NWeb1%24Category=" category "&NWeb1%24txbSearchID=loginId&NWeb1%24txbStartDate=2013%2F4%2F29&NWeb1%24txbEndDate=2013%2F5%2F2"



httprequest(url,post,header str,"charset: utf-8")



return RegExMatch(post,"is)<script>alert.+?簡訊發送完成\\n")?true:false



}



getOpHistory(sid,chartNo,personId=""){



if(personId=""){



personId:=patientBasicInfo(chartNo,sid).personId



}



httprequest("http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&PersonID=" personId "&Func=OPNoteList&Seed=" a_now,html:="")



dom:=ComObjCreate("HtmlFile")



dom.write(html)



arr:=[]



loop {



if((t:=getTextById(html,"TreeViewItemt" a_index-1))="")



break



RegExMatch(t,"is)(.+)_(\d+)\/(\d+)\/(\d+)",match)



arr["" match2 match3 match4]:=match1



}



return arr



}



getLab4(sid,chartNo){



global portalAspId



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx?SESSION=" sid,html:="",header:="Cookie: ASP.NET_SessionId=" portalAspId)



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx"



header:="Cookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y; ASP.NET_SessionId=" portalAspId



}



htmlEscapeBack(str){



static escapeCode:="&euro;,&nbsp;,&quot;,&amp;,&lt;,&gt;,&iexcl;,&cent;,&pound;,&curren;,&yen;,&brvbar;,&sect;,&uml;,&copy;,&ordf;,&not;,&reg;,&macr;,&deg;,&plusmn;,&sup2;,&sup3;,&acute;,&micro;,&para;,&middot;,&cedil;,&sup1;,&ordm;,&raquo;,&frac14;,&frac12;,&frac34;,&iquest;,&Agrave;,&Aacute;,&Acirc;,&Atilde;,&Auml;,&Aring;,&AElig;,&Ccedil;,&Egrave;,&Eacute;,&Ecirc;,&Euml;,&Igrave;,&Iacute;,&Icirc;,&Iuml;,&ETH;,&Ntilde;,&Ograve;,&Oacute;,&Ocirc;,&Otilde;,&Ouml;,&times;,&Oslash;,&Ugrave;,&Uacute;,&Ucirc;,&Uuml;,&Yacute;,&THORN;,&szlig;,&agrave;,&aacute;,&acirc;,&atilde;,&auml;,&aring;,&aelig;,&ccedil;,&egrave;,&eacute;,&ecirc;,&euml;,&igrave;,&iacute;,&icirc;,&iuml;,&eth;,&ntilde;,&ograve;,&oacute;,&ocirc;,&otilde;,&ouml;,&divide;,&oslash;,&ugrave;,&uacute;,&ucirc;,&uuml;,&yacute;,&thorn;"



static characters:="€ ""&<>¡¢£¤¥¦§¨©ª¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþ"



i:=0



s:=str



while RegExMatch(s,"&([\w\d#]+?);",m,i+1) {



if RegExMatch(m,"#(\d+)",n) {



s:=RegExReplace(s,m,chr(n1))



}else {



loop,parse,escapeCode,`,



if(a_loopfield=m) {



s:=RegExReplace(s,m,substr(characters,a_index,1))



break



}



}



}



return s



}



OpdHxArrToCSV(byref arr,chartNo){



csv:=""



csv.="""病歷號"",""性別"",""生日年"",""生日月"",""生日日"",""姓名"",""門診日期"",""診斷"",""處方"",""醫令"",""年齡"",""帳號"",""院區"",""部門"",""主治醫師"",""Subjective"",""Objective"",""未來影像檢查排程"",""未來其他檢查排程"",""未來門診預約""`n"



for k,v in arr {



csv.=OpdHxToCSV(v,chartNo)



}



return csv



}



escapeQuote(str){



return trim(RegExReplace(str,"""",""""""))



}



OpdHxToCSV(html,chartNo){



v:=parseOpdHx(html)



csv:=""



csv.= """" escapeQuote(chartNo) ""","



csv.= """" escapeQuote(v.gender) ""","



RegExMatch(v.birthDay,"(\d+)\/(\d+)\/(\d+)",match)



csv.= """" escapeQuote(match1) ""","



csv.= """" escapeQuote(match2) ""","



csv.= """" escapeQuote(match3) ""","



csv.= """" escapeQuote(v.name) ""","



csv.= """" escapeQuote(v.OpdDate) ""","



str:=""



for x,y in v.diagnosis



str.= y.1 "," y.2 "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.drug



str.= y.name " | " y.dose " | " y.frequency " | " y.duration " | " y.totalAmount " | " y.ifChronic " | " y.orderDate " | " y.specialOrder "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.order



str.= y "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



csv.= """" escapeQuote(v.age) ""","



csv.= """" escapeQuote(v.account) ""","



csv.= """" escapeQuote(v.hospital) ""","



csv.= """" escapeQuote(v.department) ""","



csv.= """" escapeQuote(v.VS) ""","



csv.= """" escapeQuote(v.subjective) ""","



csv.= """" escapeQuote(v.objective) ""","



str:=""



for x,y in v.imageSchedule



str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.examSchedule



str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.FutureSchedule



str.= y.date " | " y.timeShift " | " y.department " | " y.OpdNo " | " y.number " | " y.VS "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) """`n"



return csv



}



parseOpdHx(byref html){



arr:=[]



dom:=ComObjCreate("HtmlFile")



dom.write(html)



str:=$(dom,"TablePatientBasic").rows[1].innerText



regexmatch(str,regex:="is)([^\s]+)\s+?\((\w),\s+?(\w+),\s+?([^)]+)\)",match)



arr.name:=match1



arr.gender:=match2



arr.age:=match3



arr.birthDay:=match4



str:=$(dom,"TablePatientBasic").rows[2].innerText



regexmatch(str,regex:="is)([^\s]+)\s+?([^\s]+)\s+?([^\s]+)\s+?主治醫師：([^\s]+)\s+?看診日期：([\d\/]+)",match)



arr.account:=match1



arr.hospital:=match2



arr.department:=match3



arr.VS:=match4



arr.OpdDate:=match5



arr.subjective:=htmlEscapeBack($(dom,"TableSubjectContent").rows[1].innerText)



arr.objective:=htmlEscapeBack($(dom,"TableObjectContent").rows[1].innerText)



dx:=[]



loop % $(dom,"TableDiagnosis").rows.length {



RegExMatch($(dom,"TableDiagnosis").rows[a_index-1].innerText,"is)([^,]+),\s+?(.+)",match)



dx.push(array("" match1, "" htmlEscapeBack(match2)))



}



arr.diagnosis:=dx



if $(dom,"TablePlanningContent").rows[1].getElementsByTagName("TABLE").length=0



arr.plan:=$(dom,"TablePlanningContent").rows[1].innerText



drug:=[]



loop % (tr:=$(dom,"TableDrugData").rows).length-2 {



d:=[],td:=tr[a_index+1].cells



if ((name:=htmlEscapeBack(td[0].innerText))="") || td.length<8 {



drug[drug.maxIndex(),"specialOrder"]:="" tr[a_index+1].innerText



continue



}



d.name:="" name



d.dose:="" td[1].innerText



d.frequency:="" td[2].innerText



d.duration:="" td[3].innerText



d.totalAmount:="" td[4].innerText



d.ifChronic:="" td[5].innerText



d.orderDate:="" td[6].innerText



drug.push(d.clone())



}



arr.drug:=drug



order:=[]



loop % (tr:=$(dom,"TableOrderInfo").rows).length-1 {



contents:=RegExReplace(tr[a_index].cells[0].innerHTML,"is)<br\s*(\/)?>","ω")



loop,parse,contents,ω



{



if ((txt:=trim(htmlEscapeBack(regexreplace(a_loopfield,"is)<span[^>]+?line-through[^>]+?>.+?<\/span>"))))!="")



order.push(RegExReplace(txt,",$"))



}



}



arr.order:=order



imageSchedule:=[]



loop % (tr:=dom.getElementById("TableImageSchedule").rows).length-2 {



i:=[],td:=tr[a_index+1].cells



if(instr(tr.innerText,"未來一般檢查排程")||instr(tr.innerText,"日期"))



continue



i.date:=td[0].innerText



i.timeShift:=td[1].innerText



i.examRoom:=htmlEscapeBack(td[2].innerText)



i.number:=td[3].innerText



i.orderName:=htmlEscapeBack(td[4].innerText)



imageSchedule.push(i.clone())



}



arr.imageSchedule:=imageSchedule



if ((table:=dom.getElementById("TableImageSchedule").nextSibling).tagName="TABLE"&&instr(table.innerText,"未來一般檢查排程")) {



examSchedule:=[]



loop % (tr:=table.rows).length-2 {



e:=[],td:=tr[a_index+1].cells



e.date:=td[0].innerText



e.timeShift:=td[1].innerText



e.examRoom:=htmlEscapeBack(td[2].innerText)



e.number:=td[3].innerText



e.orderName:=htmlEscapeBack(td[4].innerText)



examSchedule.push(e.clone())



}



arr.examSchedule:=examSchedule



}



FutureSchedule:=[]



loop % (tr:=$(dom,"TableFutureSchedule").rows).length-2 {



f:=[],td:=tr[a_index+1].cells



f.date:=td[0].innerText



f.timeShift:=td[1].innerText



f.department:=htmlEscapeBack(td[2].innerText)



f.OpdNo:=td[3].innerText



f.number:=td[4].innerText



f.VS:=td[5].innerText



FutureSchedule.push(f.clone())



}



arr.FutureSchedule:=FutureSchedule



return arr



}



parseOldOpdHx(byref html){



arr:=[]



dom:=ComObjCreate("HtmlFile")



dom.write(html)



loop % (elm:=dom.body.childNodes).length {



title:=trim((tr:=elm[a_index-1].firstChild.childNodes)[0].innerText)



if(title="基本資料"){



RegExMatch(tr[1].innerText,"([^\s]+)\s*?\((\w),([\d\/]+)\)\s*?\(電話\)([^\s]*?)\s*?\(手機\)([^\s]*?)\s*?\(住址\)([^\n]*)",match)



arr.name:=match1



arr.gender:=match2



arr.birthDay:=match3



arr.phone:=match4



arr.cellPhone:=match5



arr.address:=match6



}else if(title="帳號資料"){



RegExMatch(tr[1].innerText,"N醫院([^\s]+) 科部：([^\s]+) 主治醫師：([^\s]+) 看診時間：([\d\/]+)",match)



arr.hospital:=match1



arr.department:=match2



arr.VS:=match3



arr.OpdDate:=match4



}else if(title="病歷內容"){



arr.chart:=htmlEscapeBack(tr[1].innerText)



}else if(title="診斷內容"){



dx:=[],text:=tr[1].innerText



StringReplace,text,text,`,(,¢



temp:=""



loop,parse,text,¢



{



if(RegExMatch(a_loopfield,"^\w)")){



if(temp)



dx.push(htmlEscapeBack(temp)),temp:=A_LoopField



}else{



temp.=a_loopfield



}



}



dx.push(RegExReplace(htmlEscapeBack(temp),",\s?$"))



arr.diagnosis:=dx



}else if(title="處方內容"){



drug:=[]



loop % tr.length-2 {



d:=[]



name:=(td:=tr[a_index+1].childNodes)[0].innerText



d.route:=td[1].innerText



d.dose:=td[2].innerText



d.frequency:=td[3].innerText



d.duration:=td[4].innerText



d.totalAmount:=td[5].innerText



d.ifChronic:=td[6].innerText



d.specialOrder:=htmlEscapeBack(td[7].innerText)



drug["" name]:=d



}



arr.drug:=drug



}else if(title="醫令內容"){



order:=[]



loop % tr.length-1 {



order.push(htmlEscapeBack(tr[a_index].innerText))



}



arr.order:=order



}



}



return arr



}



OldOpdHxToCSV(byref html,chartNo){



v:=parseOldOpdHx(html)



csv:=""



csv.= """" escapeQuote(chartNo) ""","



csv.= """" escapeQuote(v.gender) ""","



RegExMatch(v.birthDay,"(\d+)\/(\d+)\/(\d+)",match)



csv.= """" escapeQuote(match1) ""","



csv.= """" escapeQuote(match2) ""","



csv.= """" escapeQuote(match3) ""","



csv.= """" escapeQuote(v.name) ""","



csv.= """" escapeQuote(v.OpdDate) ""","



str:=""



for x,y in v.diagnosis



str.= y "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.drug



str.= x " | " y.dose " | " y.frequency " | " y.duration " | " y.totalAmount " | " y.ifChronic " |  | " y.route " | " y.specialOrder "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.order



str.= y "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



csv.= """" escapeQuote(v.age) ""","



csv.= """" escapeQuote(v.account) ""","



csv.= """" escapeQuote(v.hospital) ""","



csv.= """" escapeQuote(v.department) ""","



csv.= """" escapeQuote(v.VS) ""","



csv.= """" escapeQuote(v.chart) ""","



csv.= """" escapeQuote(v.objective) ""","



return csv ","""","""",""""`n"



str:=""



for x,y in v.imageSchedule



str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.examSchedule



str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.FutureSchedule



str.= y.date " | " y.timeShift " | " y.department " | " y.OpdNo " | " y.number " | " y.VS "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) """`n"



}



consultInfo(sid,queryBy="",byref params="",html="",parse=1){



if (params="")



params:=[]



if (queryBy="")



queryBy:="NWeb1$QueryNotifyContent"



if queryBy=Dept



queryBy=NWeb1$ButtonQueryByDept



global __VIEWSTATE,__EVENTVALIDATION,portalAspId,__VIEWSTATEGENERATOR



if (__VIEWSTATE="" || __EVENTVALIDATION="" || portalAspId="" || __VIEWSTATEGENERATOR="")



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/QueryNotifyRecordByDr.aspx?SESSION=" sid,html:="",header:="","charset: utf-8")



,RegExMatch(header,"i)ASP\.NET_SessionId=\w{24}",portalAspId)



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: " url "`nAccept-Language: zh-tw`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nPragma: no-cache`nCookie: " portalAspId



endDate:=startDate:=a_now



if(!params.endYear)



params.endYear:=substr(endDate,1,4)



if(!params.endMonth)



params.endMonth:=substr(endDate,5,2)*1



if(!params.endDay)



params.endDay:=substr(endDate,7,2)*1



startDate+=-3,D



if(!params.startYear)



params.startYear:=substr(startDate,1,4)



if(!params.startMonth)



params.startMonth:=substr(startDate,5,2)*1



if(!params.startDay)



params.startDay:=substr(startDate,7,2)*1



if (queryBy="NWeb1$ButtonQueryByDept"){



post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=" encodeurl("NWeb1$NotDepartSelectionObj$ddlDeptCode") "&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE:=get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")) "&NWeb1%24DateTextBoxYearMonthDayStart%24YearInput=" params.startYear "&NWeb1%24DateTextBoxYearMonthDayStart%24MonthInput=" params.startMonth "&NWeb1%24DateTextBoxYearMonthDayStart%24DayInput=" params.startDay "&NWeb1%24DateTextBoxYearMonthDayEnd%24YearInput=" params.endYear "&NWeb1%24DateTextBoxYearMonthDayEnd%24MonthInput=" params.endMonth "&NWeb1%24DateTextBoxYearMonthDayEnd%24DayInput=" params.endDay "&NWeb1%24NotDepartSelectionObj%24ddlHospitalCode=" ((hospital:=params.hospital)?hospital:"T0") "&NWeb1%24NotDepartSelectionObj%24ddlDeptCode=" params.DeptCode "&NWeb1%24DropDownListPatClass=&NWeb1%24PersonIDInput=" ((id:=params.userId)?id:getUserid(sid)) "&NWeb1%24DropDownListWardCode=" params.ward "&NWeb1%24txbChartNo=" params.chartNo "&NWeb1%24txbPatientPID=" params.patientId "&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=&NWeb1%24HiddenFieldHospitalCode=T0&NWeb1%24NotDepartSelectionObj%24ddlSubDept=&__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR:=get(html,"__VIEWSTATEGENERATOR"))



httprequest(url,html:=post,header1:=header,"charset: utf-8")



}



post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=" encodeurl(queryBy) "&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE:=get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")) "&NWeb1%24DateTextBoxYearMonthDayStart%24YearInput=" params.startYear "&NWeb1%24DateTextBoxYearMonthDayStart%24MonthInput=" params.startMonth "&NWeb1%24DateTextBoxYearMonthDayStart%24DayInput=" params.startDay "&NWeb1%24DateTextBoxYearMonthDayEnd%24YearInput=" params.endYear "&NWeb1%24DateTextBoxYearMonthDayEnd%24MonthInput=" params.endMonth "&NWeb1%24DateTextBoxYearMonthDayEnd%24DayInput=" params.endDay "&NWeb1%24NotDepartSelectionObj%24ddlHospitalCode=" ((hospital:=params.hospital)?hospital:"T0") "&NWeb1%24NotDepartSelectionObj%24ddlDeptCode=" params.DeptCode "&NWeb1%24DropDownListPatClass=&NWeb1%24PersonIDInput=" ((id:=params.userId)?id:getUserid(sid)) "&NWeb1%24DropDownListWardCode=" params.ward "&NWeb1%24txbChartNo=" params.chartNo "&NWeb1%24txbPatientPID=" params.patientId "&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=&NWeb1%24HiddenFieldHospitalCode=T0&NWeb1%24NotDepartSelectionObj%24ddlSubDept=&__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR:=get(html,"__VIEWSTATEGENERATOR"))



httprequest(url,post,header,"charset: utf-8")



if !parse



return post



dom:=ComObjCreate("HtmlFile")



dom.write(post)



arr:=[]



if !(table:=$(dom,"NWeb1_NotifyDrRecord"))



return arr



vsName:=getUserName(params.userId,sid)



loop % (tr:=table.rows).length-1 {



if(instr(tr[a_index].innerHTML,"line-through"))



continue



vs:="" trim((td:=tr[a_index].cells)[9].innerText)



R:="" trim(td[10].innerText)



replyBy:="" trim(td[11].innerText)



GCA:="" trim(td[12].innerText)



if(params.userId && vsName!=vs && vsName!=R && vsName!=replyBy && vsName!=GCA)



continue



if !(time:=trim(RegExReplace(td[4].firstChild.title,"[\/\s:]")))



continue



row:=[]



RegExMatch(td[1].firstChild.title,"is)T0-(.+)分機:(.+)",match)



row.department:="" (d:=RegExReplace(match1,"\s"))?d:td[1].innerText



row.departmentPhone:="" trim(match2)



row.chartNo:="" trim(td[2].innerText)



row.notifyId:="" td[2].firstChild.title



row.account:="" trim(td[3].firstChild.title)



RegExMatch(td[3].innerText,"is)([^\(]+)\((\w),([^\)]+)\)",match)



row.name:=match1,row.gender:=match2,row.age:=match3



row.time:=time



row.type:="" trim(td[5].innerText)



row.type2:=td[5].firstChild.title



row.consulter:="" trim(td[6].innerText)



RegExMatch(td[6].firstChild.title,"\d+",match)



row.consulterPhone:=match



row.purpose:=td[7].firstChild.title



row.consulted:="" trim(td[8].innerText)



row.VS:=vs



RegExMatch(td[9].firstChild.title,"\d+",match)



row.Rphone:=match



row.R:=R



RegExMatch(td[10].firstChild.title,"\d+",match)



row.Rphone:=match



row.replyBy:=replyBy



row.GCA:=GCA



row.status:="" trim(td[13].innerText)



row.leftTime:="" trim(td[14].innerText)



arr.push(row.clone())



}



return arr



}



getConsult(sid,accountIDSE,notifyIDSE,PatClass){



seed2:=(substr(a_now,9,2)<12?"上午":"下午") " " substr(a_now,11,2) ":" substr(a_now,13,2) ":" substr(a_now,15,2)



url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed2



httprequest(url,html:="",header:="","charset: utf-8`n+NO_COOKIES")



return html



}



replyConsult(sid,accountIDSE,notifyIDSE,PatClass,replyContent,diagnosis,suggestion,byref params=""){



seed1:=(substr(a_now,9,2)<12?"%ufffdU%ufffd%ufffd":"%ufffdU%ufffd%ufffd") "+" substr(a_now,11,2) "%3a" substr(a_now,13,2) "%3a" substr(a_now,15,2)



seed2:=(substr(a_now,9,2)<12?"上午":"下午") " " substr(a_now,11,2) ":" substr(a_now,13,2) ":" substr(a_now,15,2)



url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed1



referer:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed2



html:=getConsult(sid,accountIDSE,notifyIDSE,PatClass)



dom:=ComObjCreate("HtmlFile")



dom.write(html)



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " referer "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=NWeb1%24btnRecordFisrtAnalysisTime&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl($(dom,"__VIEWSTATE").value) "&__EVENTVALIDATION=" encodeurl($(dom,"__EVENTVALIDATION").value) "&NWeb1%24TextboxMainPurpose=" regexreplace(encodeurl($(dom,"NWeb1_TextboxMainPurpose").value),"%20","+") "&NWeb1%24TextboxDescription=" regexreplace(encodeurl($(dom,"NWeb1_TextboxDescription").value),"%20","+") "&NWeb1%24TextboxReplyContent=" regexreplace(encodeurl(replyContent),"%20","+") "&NWeb1%24TextboxDiagnosis=" regexreplace(encodeurl(diagnosis),"%20","+") "&NWeb1%24TextboxSuggestion=" regexreplace(encodeurl(suggestion),"%20","+") "&NWeb1%24atxbGCAEmpNo%24txbContent=" (params.VS?params.VS:$(dom,"NWeb1_atxbGCAEmpNo_txbContent").value) "&NWeb1%24TextboxCostCenterInput=" (params.costCenter?params.costCenter:$(dom,"NWeb1_TextboxCostCenterInput").value) "&hiddenInputToUpdateATBuffer_CommonToolkitScripts=1&__VIEWSTATEGENERATOR=" encodeurl($(dom,"__VIEWSTATEGENERATOR").value)



httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



return 1



}



askForPortalIdPw(opt=0, check_valid=true, hospital=0, exitapp=true){



global loginId,loginPw,sid,askForPortalIdPw_loginId,askForPortalIdPw_loginPw,askForPortalIdPw_loginId_hwnd, askForPortalIdPwHwnd



priorSid:=Sid



,branch:=""



,prompt1:="ID"



,prompt2:="Password"



if hospital=0



key1:="loginId"



,key2:="loginPw"



else if hospital=H



key1:="HCH_ID"



,key2:="HCH_PW"



,branch:="(H分院)"



else if hospital=Y



key1:="YLH_ID"



,key2:="YLH_PW"



,branch:="(Y分院)"



if fileexist("portal.ini")



path:="portal.ini"



else if fileexist((dir:=regexreplace(a_scriptdir,"[/\\][^/\\]+$")) "\portal.ini")



path:=dir "\portal.ini"



static AES_pw:="scsnakePortalLib"



if(!opt){



enc_dec:=""



if(loginId=""&&loginPw=""&&fileexist(path)){



iniread,loginId,% path,login,% key1



iniread,loginPw,% path,login,% key2



if loginPw!=



try



loginPw:MOCK_PASSWORD,AES_pw,7,6)



catch



loginPw:MOCK_PASSWORD""



}



priorPw:=loginPw



,priorId:=loginId



}else{



priorPw:=loginPw



,priorId:=loginId



,loginId:="",loginPw:MOCK_PASSWORD""



}



if !(check_valid)



return



ToolTip % "Login portal..."



while loginPw="" || !checkSid(sid:=Login(loginId,loginPw, hospital)) {



ToolTip % "Login portal..."



if (a_index>50) {



msgbox % Can not login Portal !!



exitapp



}



gui,askForPortalIdPw:new,+hwndaskForPortalIdPwHwnd -Resize -MaximizeBox  -MinimizeBox +Owner +LabelaskForPortalIdPw



gui,add,Text,,% A_ScriptName " asking for portal id/pw " branch " ..."



gui,add,Text,,% prompt1



gui,add,Edit,% "vaskForPortalIdPw_loginId hwndaskForPortalIdPw_loginId_hwnd",% (loginId="ERROR")?"":loginId



gui,add,Text,,% prompt2



gui,add,Edit,% "vaskForPortalIdPw_loginPw password"



gui,add,button,% "gaskForPortalIdPw_submit default",% "Login"



gui,Show,% "center autosize",% "Portal Login"



Edit_SetSel(askForPortalIdPw_loginId_hwnd,0,-1)



WinWaitClose, ahk_id %askForPortalIdPwHwnd%



if(loginId="canceled" && !opt){



if ExitApp



ExitApp



else



return -1



}



if(loginId="canceled")



loginId:=priorId



}



ToolTip



encloginPw:MOCK_PASSWORD,AES_pw,7,6)



if !fileexist(path)



path:="portal.ini"



if(opt||priorId!=loginId||priorPw!=loginPw){



iniwrite,% loginId,% path,login,% key1



iniwrite,% encloginPw,% path,login,% key2



}



return sid



askForPortalIdPwGuiClose:



askForPortalIdPwGuiEscape:



loginId:=loginPw:MOCK_PASSWORD"canceled"



gui,askForPortalIdPw:Destroy



return



askForPortalIdPw_submit:



GuiControlGet,loginId,askForPortalIdPw:,askForPortalIdPw_loginId



GuiControlGet,loginPw,askForPortalIdPw:,askForPortalIdPw_loginPw



gui,askForPortalIdPw:Destroy



return



}



getOptionByText(byref el,str){



if(el.tagName="select"){



loop % el.options.length {



if instr(el.options[a_index-1].innerText,str)



return object("index",a_index-1,"value",el.options[a_index-1].value)



}



}



}



queryDigiSign(sid,id){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId



url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DSQuery.aspx?SESSION=" sid



if (!__VIEWSTATE || !__EVENTVALIDATION || !portalAspId) {



header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive"



,httprequest(url,html:="",header,"charset: utf-8")



,portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")



,__VIEWSTATE:=get(html,"__VIEWSTATE")



,__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



}



while strlen(id)<6



id:="0" id



formattime,date,% a_now,yyyy/MM/dd



header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nReferer: http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DSQuery.aspx?SESSION=" sid "`nConnection: close`nCookie: 5=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null"



,post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=NWeb1%24txbEmpNO&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24txbEmpNO=" id "&NWeb1%24txbPinCode=&NWeb1%24txtSDateChar=" encodeurl(date) "&NWeb1%24txtSDateChar_MaskedEditExtender_ClientState=&NWeb1%24txtEDateChar=" encodeurl(date) "&NWeb1%24txtEDateChar_MaskedEditExtender_ClientState="



,httprequest(url,post,header,"charset: utf-8")



return post



}



queryDigiSignN(sid,id){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId,loginId



url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DrugGivenDS.aspx?SESSION=" sid



if (!__VIEWSTATE || !__EVENTVALIDATION || !portalAspId) {



header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive"



httprequest(url,html:="",header,"charset: utf-8")



portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")



__VIEWSTATE:=get(html,"__VIEWSTATE")



__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



}



while strlen(id)<6



id:="0" id



formattime,date,% a_now,yyyy/MM/dd



header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nReferer: http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DrugGivenDS.aspx?SESSION=" sid "`nConnection: close`nCookie: 5=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null"



d:=A_Now



d+=-6,days



post:="NWeb1%24ScriptManager1=NWeb1%24UpdatePanel1%7CNWeb1%24BtnGetEmgPatientListByDoctor&scrollLeft=0&scrollTop=0&hiddenHl7Reg=http%3A%2F%2Fihiswsvc.hospital-n.local%2FHL7Central_IIS%2FCentral.asmx-" sid "-" loginId "-" A_IPAddress1 "-DigitalSignature%2FDrugGivenDS&NWeb1%24txbEmpNO=" id "&NWeb1%24txtSDateChar=" substr(d,1,4) "%2F" substr(d,5,2) "%2F" substr(d,7,2) "&NWeb1%24txtSDateChar_MaskedEditExtender_ClientState=&NWeb1%24txtEDateChar=" a_yyyy "%2F" a_MM "%2F" a_dd "&NWeb1%24txtEDateChar_MaskedEditExtender_ClientState=&NWeb1%24txbPinCode=&NWeb1%24hiddenPin=undefind&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&__AjaxControlToolkitCalendarCssLoaded=&hiddenRecord=000000-" loginId "-T0&__ASYNCPOST=true&NWeb1%24BtnGetEmgPatientListByDoctor=%E6%9F%A5%E8%A9%A2"



httprequest(url,post,header,"charset: utf-8")



return post



}



EMRViewerMobile(sid,chartNo){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId,reportpageguid



while strlen(chartNo)<7



chartNo:="0" chartNo



if !(__VIEWSTATE && __EVENTVALIDATION && reportpageguid){



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx?SESSION=" sid



,header:="Host: ihisaw.hospital-n.local`nConnection: Keep-Alive"



,httprequest(url,post:="",header,"charset: utf-8")



RegExMatch(post,"reportpageguid=([\w\-]+)",match)



reportpageguid:=match1



,__VIEWSTATE:=get(post,"__VIEWSTATE")



,__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



}



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid="reportpageguid



,header:="Referer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" reportpageguid "`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"



,post:="__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&txbIDInput=" chartNo "&btnQueryAction=%E6%9F%A5%E8%A9%A2"



,httprequest(url,post,header,"charset: utf-8")



,RegExMatch(post,"reportpageguid=([\w\-]+)",match)



,reportpageguid:=match1



,__VIEWSTATE:=get(post,"__VIEWSTATE")



,__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



return new portalLib_EMRViewerMobile(post)



}



EMRgetRadExams(EMRViewerMobile){



radExams:=[]



sorting:=[],i:=0



for k,v in EMRViewerMobile.EMR



if instr(v.title,"影核醫") {



for x,y in v



if x is number



{



regexmatch(y.param,"([^_]+)_([^_]+)_([^_]+)",match)



radExams.push({ExamName: RegExReplace(y["報告類別"],"i) \(V\d+\)$","")



,ExamDate: y["檢查日期"]



,Hospital: match1



,AccessNo: match3



,ReportDate: y["報告日期"]})



sorting[RegExReplace(y["檢查日期"],"\D","") match3]:=++i



}



}



sorted:=[]



for k,v in sorting



sorted.push(radExams[v])



return sorted



}



class portalLib_EMRViewerMobile {



__New(html){



dom:=ComObjCreate("HtmlFile")



dom.write(html)



ret:=[]



loop % $(dom,"MobileMenu").childNodes.length



{



arr:=[]



group:=$(dom,"MobileMenu").childNodes[a_index-1]



arr["title"]:=group.firstChild.firstChild.nodeValue



col:=[]



loop % group.childNodes[1].firstChild.firstChild.childNodes.length



col.push(trim(group.childNodes[1].firstChild.firstChild.childNodes[a_index-1].innerText))



loop % group.childNodes[1].childNodes[1].childNodes.length {



i:=a_index



item:=[]



item["param"]:=trim(group.childNodes[1].childNodes[1].childNodes[i-1].param)



loop % group.childNodes[1].childNodes[1].childNodes[i-1].childNodes.length {



j:=a_index



if (col[j]="開報告"){



regexmatch(group.childNodes[1].childNodes[1].childNodes[i-1].childNodes[j-1].firstChild.href,"WebForm_PostBackOptions\(""([^""]+)",match)



item["" col[j]]:="" trim(match1)



}else{



item["" col[j]]:="" trim(group.childNodes[1].childNodes[1].childNodes[i-1].childNodes[j-1].innerText)



}



}



arr.push(item.clone())



}



ret.push(arr.clone())



}



this.EMR:=ret



RegExMatch(html,"reportpageguid=([\w\-]+)",match)



this.reportpageguid:=match1



this.__VIEWSTATE:=get(html,"__VIEWSTATE")



this.__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



this.chartNo:=get(html,"txbIDInput")



}



getReport(reportNameSubStr,examDate,titleSubStr="影核醫",Number=0,reportDate=""){



if (reportNameSubStr="" || titleSubStr="")



return []



arr:=[],arr2:=[]



if isobject(reportNameSubStr) {



for k,v in this.EMR {



if instr(v.title,titleSubStr) {



for x,y in v {



if x is not number



continue



if reportNameSubStr.(y["報告類別"]) && instr(RegExReplace(y["檢查日期"],"\D",""),RegExReplace(examDate,"\D","")){



arr2.push(y["開報告"])



if (reportDate="" || instr(RegExReplace(y["報告日期"],"\D",""),RegExReplace(reportDate,"\D","")))



arr.push(y["開報告"])



}



}



break



}



}



}else{



for k,v in this.EMR {



if instr(v.title,titleSubStr) {



for x,y in v {



if x is not number



continue



if instr(y["報告類別"],reportNameSubStr) && instr(RegExReplace(y["檢查日期"],"\D",""),RegExReplace(examDate,"\D","")){



arr2.push(y["開報告"])



if (reportDate="" || instr(RegExReplace(y["報告日期"],"\D",""),RegExReplace(reportDate,"\D","")))



arr.push(y["開報告"])



}



}



break



}



}



}



if !arr.maxIndex()



arr:=arr2.clone()



if !arr.maxIndex()



return 0



arr2:=[]



for k,v in arr {



if (number>0&&a_index>number)



break



arr2.push(this.getReportByLink(v))



}



return arr2



}



getReportByLink(linkId){



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" this.reportpageguid



header:="Referer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" this.reportpageguid "`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"



post:="__LASTFOCUS=&__EVENTTARGET=" encodeUrl(linkId) "&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(this.__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(this.__EVENTVALIDATION) "&ddlPatChartNo=" encodeUrl(this.chartNo) "&txbIDInput=" encodeUrl(this.chartNo) "&txtEndDate=&txtStartDate="



httprequest(url,post,header,"charset: utf-8")



url:=RegExReplace(get(post,"Reportifrm","id","src"),"&amp;","&")



httprequest(url,post:="",header:="","charset: utf-8")



return post



}



radReportText(html){



dom:=ComObjCreate("HtmlFile")



dom.write(html)



table1:=$(dom,"rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay").previousSibling.childNodes[5].firstChild



table2:=$(dom,"rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay")



str:=""



loop % table1.firstChild.childNodes.length {



i:=a_index



loop % table1.firstChild.childNodes[i-1].childNodes.length {



j:=a_index



str.=trim(table1.firstChild.childNodes[i-1].childNodes[j-1].innerText) " "



}



str.="`n"



}



loop % table2.firstChild.childNodes.length {



i:=a_index



loop % table2.firstChild.childNodes[i-1].childNodes.length {



j:=a_index



if(table2.firstChild.childNodes[i-1].childNodes[j-1].getElementsByTagName("textarea").length>0)



str.=trim(table2.firstChild.childNodes[i-1].childNodes[j-1].firstChild.firstChild.innerText) " "



else



str.=trim(table2.firstChild.childNodes[i-1].childNodes[j-1].innerText) " "



}



str.="`n"



}



return str



}



}



parseRisReport2Yr(html){



table:=getHtmlById(html, "TableRisReport")



,rows:=getHtmlByTagName(table, "TR")



,arr:=[]



loop % rows.maxIndex()-1 {



row:=rows[a_index+1]



Text:=convertHTMLchar(RegExReplace(getHtmlByTagName(row, "TD")[1], "<\/?\w+?>",""))



if regexmatch(text,"is)^醫令: (.+?) 報告醫師: (.+?) 影像時間: (.+?) \(([^\)]+)\) 發報告時間: (.+?)",match)



tmp:=[],tmp.push([trim(match1), trim(match2), trim(match3), trim(match4), trim(match5)])



else if regexmatch(text,"is)^報告內容: (.+)",match) || regexmatch(text,"is)^Impression: (.+)",match)



tmp.push(trim(match1))



else if regexmatch(text,"^症狀: ",match)



arr.push(tmp)



}



return arr



}



RisReport2Yr(sid,chartNo, hospital=""){



if !checksid(sid){



return -1



}



if hospital!=



hospitalSpecified:=true



if StrLen(chartNo)!=10 {



if SubStr(chartNo,1,1)="H"



hospital=T4



else if SubStr(chartNo,1,1)="Y"



hospital=Y0



}



if hospital=H



hospital=T4



else if hospital=Y



hospital=Y0



hospital:="&Hosp=" hospital



if RegExMatch(chartNo,"i)\w\d{9}"){



personId:=chartNo



}else {



while strlen(chartNo)<7



chartNo:="0" chartNo



personId:=patientBasicInfo(chartNo,sid).personId



}



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&Func=RISReport&AccountIDSE=&PersonID=" personid "&WinPup=True&Seed=" a_hour a_min a_sec hospital



,header:="Referer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personid "&Seed=" a_now "`nHost: ihisaw.hospital-n.local"



,httprequest(url,post:="",header,"charset: utf-8")



return post



}



AppendAspInfo(post,html){



global __VIEWSTATE,__EVENTVALIDATION



post:=RegExReplace(post,"i)&?(__VIEWSTATE|__EVENTVALIDATION)=[^&]+","")



post:=RegExReplace(post,"i)(__VIEWSTATE|__EVENTVALIDATION)=[^&]+&?","")



if (post!="")



post.="&"



if (__VIEWSTATE="")



__VIEWSTATE:=get(html,"__VIEWSTATE")



if (__EVENTVALIDATION="")



__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



return post "__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&__VIEWSTATE=" encodeurl(__VIEWSTATE)



}



ExtractHeaderCookie(responseHeader){



i:=0,match:=str:=""



while i:=regexmatch(responseHeader,"i)Set-Cookie: ([^\n]+)",match,i+strlen(match)+1)



str.=match1



return str:=RegExReplace(str,"(path=\/|HttpOnly|expires=[^;]+);?","")



}



queryInjectionRecords(sid,chartno){



global __VIEWSTATE,__EVENTVALVIEWSTATE,__EVENTVALIDATION,portalAspId



url:="http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx?SESSION=" sid



if (!__VIEWSTATE || !__EVENTVALIDATION || !portalAspId) {



header:="Host: hisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive`nCookie: CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=IsShowChartNo=Y; CK_Clinics_OrderSearch=IsShowOrderCode=N;"



httprequest(url,html:="",header,"charset: utf-8")



portalAspId:=RegExReplace(header,"s)^.+ASP\.NET_SessionId=([^;]+);.+$","$1")



__VIEWSTATE:=get(html,"__VIEWSTATE")



__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



}



header:="Host: hisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive`nCookie: CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=IsShowChartNo=Y; CK_Clinics_OrderSearch=IsShowOrderCode=N;ASP.NET_SessionId=" portalAspId ";"



httprequest(url,html:="",header,"charset: utf-8")



ToolkitScriptManager1_HiddenField:=RegExReplace(html,"is)^.+\/WebApplication\/InspectionReport\/ReportOfCase\.aspx\?_TSM_HiddenField_=ToolkitScriptManager1_HiddenField&amp;_TSM_CombinedScripts_=([^""]+).+$","$1")



ucQueryHandler_QueryTab_ClientState:=RegExReplace(get(html,"ucQueryHandler_QueryTab_ClientState"),"i)&quot;","""")



__VIEWSTATE:=get(html,"__VIEWSTATE")



__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



while strlen(chartno)<6



chartno:="0" chartno



formattime,startDate,% a_now,yyyy/M/d



header:="Host: hisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nReferer: http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx?`nConnection: keep-alive`nCookie: ASP.NET_SessionId=" portalAspId "; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y; CK_Clinics_OrderSearch=IsShowOrderCode=N;"



post:="ToolkitScriptManager1_HiddenField=" ToolkitScriptManager1_HiddenField "&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&ucQueryHandler_QueryTab_ClientState=" encodeurl("{""ActiveTabIndex"":1,""TabEnabledState"":[true,true],""TabWasLoadedOnceState"":[true,false]}") "&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__SCROLLPOSITIONX=0&__SCROLLPOSITIONY=0&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&ucQueryHandler%24ddlSystem=17&ucQueryHandler%24QueryTab%24QueryFromScheduling%24ddlOrder=CHMRX&ucQueryHandler%24QueryTab%24QueryFromScheduling%24txbDateStart=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryFromScheduling%24ddlShiftType=&ucQueryHandler%24QueryTab%24QueryFromScheduling%24txbQueryPat=&ucQueryHandler%24QueryTab%24QueryFromScheduling%24TextBoxWatermarkExtender2_ClientState=&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbChartNoOrPersonId=" encodeurl(chartNo) "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24TextBoxWatermarkExtender1_ClientState=&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbStartDate=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbEndDate=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24btnQueryFilled=%E6%9F%A5%E8%A9%A2&isMenuVisible=true"



httprequest("http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx",post,header,"charset: utf-8")



return new portalLib_FoundInjectionRecords(post)



}



class portalLib_FoundInjectionRecords {



__New(post){



dom:=ComObjCreate("HtmlFile")



dom.write(post)



this.ToolkitScriptManager1_HiddenField:=RegExReplace(post,"is)^.+\/WebApplication\/InspectionReport\/ReportOfCase\.aspx\?_TSM_HiddenField_=ToolkitScriptManager1_HiddenField&amp;_TSM_CombinedScripts_=([^""]+).+$","$1")



this.ucQueryHandler_QueryTab_ClientState:=RegExReplace(get(post,"ucQueryHandler_QueryTab_ClientState"),"i)&quot;","""")



arr:=[]



table:=$(dom,"UpdatePanel1").childNodes[2]



loop % table.rows.length-1 {



v:=table.rows[a_index]



pt:=[]



pt.ChartNo:=trim(v.cells[1].innerText)



pt.Name:=trim(v.cells[2].innerText)



pt.Gender:=trim(v.cells[3].innerText)



pt.Age:=trim(v.cells[4].innerText)



pt.Status:=trim(v.cells[5].innerText)



pt.Date:=trim(v.cells[6].innerText)



pt.PostBack:=RegExReplace(v.cells[2].firstChild.href,"is)^.+(lvQuery\$ctrl\d+\$lbtName).+$","$1")



arr.push(pt.clone())



}



this.results:=arr



}



getLink(n="",chartNo="",date="",postback:=""){



global sid,portalAspId,__VIEWSTATE,__EVENTVALIDATION



if(n!=""){



return this.getLink("","","",this.results[n].PostBack)



}else{



arr:=[]



for k,v in this.results {



if (instr(v.chartNo,chartNo) && instr(RegExReplace(v.date,"\D",""),substr(RegExReplace(date,"\D",""),1,8))){



formattime,startDate,% a_now,yyyy/M/d



header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx`nx-requested-with: XMLHttpRequest`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E)`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache`nCookie: ASP.NET_SessionId=" portalAspId "; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y; CK_Clinics_OrderSearch=IsShowOrderCode=N; "



post:="ToolkitScriptManager1=" encodeurl("UpdatePanel1|" (postback=""?v.PostBack:postback)) "&ToolkitScriptManager1_HiddenField=" this.func1(RegExReplace(this.ToolkitScriptManager1_HiddenField,"\+","%20")) "&__EVENTTARGET=" encodeurl(postback=""?v.PostBack:postback) "&__EVENTARGUMENT=&__LASTFOCUS=&ucQueryHandler_QueryTab_ClientState=" encodeurl("{""ActiveTabIndex"":1,""TabEnabledState"":[true,true],""TabWasLoadedOnceState"":[true,true]}") "&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__SCROLLPOSITIONX=0&__SCROLLPOSITIONY=0&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&ucQueryHandler%24ddlSystem=17&ucQueryHandler%24QueryTab%24QueryFromScheduling%24ddlOrder=CHMRX&ucQueryHandler%24QueryTab%24QueryFromScheduling%24txbDateStart=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryFromScheduling%24ddlShiftType=&ucQueryHandler%24QueryTab%24QueryFromScheduling%24txbQueryPat=&ucQueryHandler%24QueryTab%24QueryFromScheduling%24TextBoxWatermarkExtender2_ClientState=&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbChartNoOrPersonId=" v.chartNo "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24TextBoxWatermarkExtender1_ClientState=&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbStartDate=" encodeurl(startDate) "&ucQueryHandler%24QueryTab%24QueryForFilledCase%24txbEndDate=" encodeurl(startDate) "&isMenuVisible=true&__ASYNCPOST=true"



httprequest("http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx",post,header,"charset: utf-8")



arr.push(RegExReplace(clipboard:=post,"is)^.+(http:\/\/hisaw.hospital-n.local\/WebApplication\/InspectionReport\/ReportSheet\.aspx\?SESSION=" sid "[^\\]+).+$","$1"))



if (PostBack!="")



break



}



}



return arr



}



}



StringUpper(str){



StringUpper,str,str



return str



}



func1(str){



str:=RegExReplace(str,"(\%\d)b","$1B")



str:=RegExReplace(str,"(\%\d)a","$1A")



str:=RegExReplace(str,"(\%\d)d","$1D")



str:=RegExReplace(str,"(\%\d)c","$1C")



str:=RegExReplace(str,"(\%\d)e","$1E")



str:=RegExReplace(str,"(\%\d)f","$1F")



return str



}



}



PacsImageViewerRequest(){



global portalUrl



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/ExternalPage/PacesImageViewer.aspx?SESSION=MOCK_SESSION_ID"



header=



	(Ltrim



	Referer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/ExternalPage/PACSImage.aspx?isfrombackupdb=False&sheetnolist=T__________&chartnolist=H______&personid=A123456789&reportpageguid=A123456789&hospitalcode



	Host: ihisaw.hospital-n.local



	Cookie: WardListColumnSelectloginId=DR; InPatientWardDefaultQuery=T0|15C|00||QByBed|4; CK_MedicalReportOpen_PatientQueryCookie=SelectPatListTypeCookieIPatList=&SelectPatListTypeCookieEPatList=&SelectPatListTypeCookieOPatList=&SelectPatListTypeCookieLabPatList=&SelectPatListTypeCookieSpeList=&SelectPatListTypeCookie=IPatList; NPage_MenuSettingCookie=`%u5831`%u544a`%u7d22`%u5f15`%u7cfb`%u7d71=Y; ASP.NET_SessionId=mock_asp_session_id



)



httprequest(url, post:="", header)



return header "`n`n" post



}



PacsWebInfoYLH(byref output,AccNo,chartNo="",loginId="",loginPw="",count="1500"){



baseUrl:="http://dlpacs.hospital-y.local/DicomWeb/DicomWeb.dll/WADO?User=" loginId "&Password=" md5(loginPw)



,httprequest(url:=baseUrl "&requestType=Query&patientID=" chartNo "&accessionNumber=" accNo "&flag=2"



,post:=""



,header:="Host: dlpacs.hospital-y.local"



, "charset: utf-8")



if !IsObject(output)



output:=[]



try {



x:=new xml(post)



,output.studyUID:=x.getText("/queryResult/dataset/study/studyUID")



, series:=x.selectNodes("/queryResult/dataset/study/series")



Loop % series.length {



s:=[]



,s.seriesUID:=series.item(A_Index-1).getElementsByTagName("seriesUID").item(0).Text



,im:=series.item(A_Index-1).getElementsByTagName("image")



Loop % im.length {



i:=[]



, i.objectUID:=im.item(A_Index-1).getElementsByTagName("objectUID").item(0).Text



, i.filePath:=im.item(A_Index-1).getElementsByTagName("filePath").item(0).Text



, i.url:= baseUrl "&requestType=WADO&psHash=&studyUID=" output.studyUID "&seriesUID=" s.seriesUID "&objectUID=" i.objectUID "&flag=2&contentType=image/jpeg&imageQuality=100&columns=1536&windowCenter=&windowWidth=&frameNumber="



, s[A_Index]:=i



}



output[A_Index]:=s



}



}catch e



MsgBox % e.message



return output



}



PacsWebInfoHCH(byref output,AccNo,chartNo="",loginId="",loginPw="",count="1500"){



baseUrl:="http://pacs.hospital-h.local/DicomWeb/DicomWeb.dll/WADO?User=" loginId "&Password=" md5(loginPw)



,httprequest("http://pacs.hospital-h.local/DicomWeb/DicomWeb.dll/WADO?requestType=Query&User=" loginId "&Password=" md5(loginPw) "&patientID=" chartNo "&accessionNumber=" AccNo "&flag=2"



, post:=""



, header:="Host: pacs.hospital-h.local"



, "charset: utf-8")



if !IsObject(output)



output:=[]



try {



x:=new xml(post)



,output.studyUID:=x.getText("/queryResult/dataset/study/studyUID")



, series:=x.selectNodes("/queryResult/dataset/study/series")



Loop % series.length {



s:=[]



,s.seriesUID:=series.item(A_Index-1).getElementsByTagName("seriesUID").item(0).Text



,im:=series.item(A_Index-1).getElementsByTagName("image")



Loop % im.length {



i:=[]



, i.objectUID:=im.item(A_Index-1).getElementsByTagName("objectUID").item(0).Text



, i.filePath:=im.item(A_Index-1).getElementsByTagName("filePath").item(0).Text



, i.url:= baseUrl "&requestType=WADO&psHash=&studyUID=" output.studyUID "&seriesUID=" s.seriesUID "&objectUID=" i.objectUID "&flag=2&contentType=image/jpeg&imageQuality=100&columns=1536&windowCenter=&windowWidth=&frameNumber="



, s[A_Index]:=i



}



output[A_Index]:=s



}



}catch e



MsgBox % e.message



return output



}



PacsWebInfo(byref output,AccNo,chartNo="",loginId="",loginPw="",count="1500", new=true){



PacsWebServer(AccNo, baseUrl, host)



if(host="dlpacs.hospital-y.local")



return PacsWebInfoYLH(output, AccNo, chartNo, loginId, loginPw, Count)



if InStr(baseUrl, "pacsmobile"){



if(new){



return PacsWebInfoNew(AccNo,chartNo,loginId,loginPw)



}else{



url:=baseUrl "/wado/?v=2.0.SU3.3&requestType=STUDY&contentType=text/javascript&maxResults=250&PatientID=" chartNo "&AccessionNumber=" AccNo "&ae=local&IssuerOfPatientID=&groupByIssuer=*&language=zh_TW&user=" loginId "&password=" loginPw



header=



			( Ltrim



			Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr



			Host: %host%



)



httprequest(url,post:="",header)



cookie:=""



}



}else if InStr(baseUrl, "hch"){



return PacsWebInfoHCH(output, AccNo, chartNo, loginId, loginPw, Count)



}



regexmatch(post,"(?<=studyUID=)[^&]+",studyUID)



,regexmatch(post,"(?<=""ver"":"")[^""]+",ver)



,regexmatch(post,"(?<=Count=)\d+",count)



,url:=baseUrl "/wado/?v=2.0.SU3.3&requestType=IMAGE&contentType=text/javascript&regroup=*&studyUID=" (studyUid) "&Position=0&Count=" count "&ver=" ver "&ae=local&language=zh_TW"



if InStr(baseUrl, "pacsmobile")



url.="&user=" loginId "&password=" loginPw



header=



	( Ltrim



	Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr



	Host: %host%



)



if(cookie!="")



header.="`nCookie: " cookie



httprequest(url,post:="",header)



,json:=json_from(post)



if(!isobject(output))



output:=[]



output.studyUID:=json.children.1.children.1.studyUID



,output.url:=PacsWebUrlTrans(json.children.1.children.1.url, baseUrl, host)



header=



	( Ltrim



	Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr



	Host: %host%



)



if(cookie!="")



header.="`nCookie: " cookie



ind:=0



for k,v in json.children.1.children.1.children {



if (v.seriesUID="")



continue



++ind



output[ind]:=[]



,output[ind,"seriesUID"]:=v.seriesUID



,output[ind,"url"]:=PacsWebUrlTrans(v.url, baseUrl, host)



url:=baseUrl "/wado/?v=2.0.SU3.3&" regexreplace(substr(v.url,2),"i)&url=true&regroup=true","")  "&contentType=text/javascript&regroup=*&ver=" ver



if InStr(baseUrl, "pacsmobile")



url.="&user=" loginId "&password=" loginPw



httprequest(url,post:="",header1:=header)



,json2:=json_from(post)



,ind2:=0



for x,y in json2.children.1.children.1.children {



if (y.seriesUID=v.seriesUID){



ind3:=x



break



}



}



for x,y in json2.children.1.children.1.children[ind3].children {



if(y.objectUID="")



continue



++ind2



output[ind,ind2,"objectUID"]:=y.objectUID



,output[ind,ind2,"url"]:=PacsWebUrlTrans(y.url, baseUrl, host)



}



}



return output



}



PacsWebInfoFlatten(byref result){



output:=[]



for k,v in result



if isobject(v)



for x,y in v



if isobject(y) && y.hasKey("ObjectUID")



output.push(y)



return output



}



PacsWebUrlTrans(url, baseUrl, host){



regexmatch(url,"is)(?<=studyUID=)[\d\.]+",studyUID)



regexmatch(url,"is)(?<=seriesUID=)[\d\.]+",seriesUID)



regexmatch(url,"is)(?<=objectUID=)[\d\.]+",objectUID)



return baseUrl "/wado/?v=2.0.SU3.3&requestType=XERO" (studyUID?"&studyUID=" studyUID:"") (seriesUID?"&seriesUID=" seriesUID:"") (objectUID?"&objectUID=" objectUID:"") "&language=zh_TW&ae=local"



}



PacsWebUrl(AccNo,chartNo="",loginId="",loginPw=""){



while strlen(chartNo)<7



chartNo:="0" chartNo



PacsWebServer(AccNo, baseUrl, host)



return baseUrl "/?user=" loginId "&password=" loginPw "&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr"



}



PacsWebCookie(ByRef inout_JSESSIONID="", ByRef inout_JSESSIONIDSSO="", ByRef inout_ViewportSize=""){



static candidates1:="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-_"



, candidates2:="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"



if (inout_JSESSIONID=""){



loop 24 {



random,rand,1,% strlen(candidates1)



inout_JSESSIONID.=substr(candidates1,rand,1)



}



}



if(inout_JSESSIONIDSSO=""){



loop 32 {



random,rand,1,% strlen(candidates2)



inout_JSESSIONIDSSO.=substr(candidates2,rand,1)



}



}



if(inout_ViewportSize=""){



inout_ViewportSize:="1024/643"



}



return "JSESSIONID=" inout_JSESSIONID "; JSESSIONIDSSO=" inout_JSESSIONIDSSO "; xero-viewport-size=" inout_ViewportSize



}



PacsWebTemp(accNo,chartNo,loginId,loginPw){



global JSESSIONID,JSESSIONIDSSO



cookie:=PacsWebCookie(JSESSIONID, JSESSIONIDSSO)



PacsWebServer(AccNo, baseUrl, host)



url:=baseUrl "/?user=" loginId "&password=" loginpw "&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr"



header=



	(



	Referer: http://pacswide.hospital-n.local:8080/kQuery.php



	Host: %host%



	Cookie: %cookie%



)



httprequest(url,post:="",header)



}



PacsWebDownloadDicom(url,AccNo,chartNo,fileName="",folder="",PicWidth="",loginId="",loginPw="",retry=3,fileSize=100,first=1, callback="", param=""){



return PacsWebDownloadJpeg2(url,AccNo,chartNo,fileName,folder,PicWidth,loginId,loginPw,retry,fileSize,first, callback, param, "dicom")



}



PacsWebDownloadPng(url,AccNo,chartNo,fileName="",folder="",PicWidth="",loginId="",loginPw="",retry=3,fileSize=100,first=1, callback="", param=""){



return PacsWebDownloadJpeg2(url,AccNo,chartNo,fileName,folder,PicWidth,loginId,loginPw,retry,fileSize,first, callback, param, "png")



}



PacsWebDownloadJpeg2(url,AccNo,chartNo,fileName="",folder="",PicWidth="",loginId="",loginPw="",retry=3,fileSize=100,first=1, callback="", param="", DownloadFileType="jpeg"){



global __PacsWebCookie, __ua_header



PacsWebServer(AccNo, baseUrl, host)



if(first=1){



while strlen(chartNo)<7



chartNo:="0" chartNo



if InStr(baseUrl, "dlpacs.hospital-y.local") || InStr(baseUrl, "hch"){



if !instr(url,"User=", true)



url.="&User=" loginId



if !instr(url,"Password=", true)



url.="&Password=" md5(loginPw)



if (!instr(url,"columns="))



url.="&columns=" (PicWidth?PicWidth:a_screenwidth*2)



else if PicWidth



url:=RegExReplace(url,"(?<=columns=)[^&]+",PicWidth)



}else{



if InStr(baseUrl, "pacsmobile") && !InStr(baseUrl, "pacsmobilenew"){



if !instr(url,"user=")



url.="&user=" loginId



if !instr(url,"password=")



url.="&password=" loginPw



}



if (!instr(url,"rows="))



url.="&rows=" (PicWidth?PicWidth:a_screenwidth*2)



else if PicWidth



url:=RegExReplace(url,"(?<=rows=)[^&]+",PicWidth)



}



}



if (folder="")



folder:=A_ScriptDir



if (filename="")



filename:=AccNo " " chartNo " 1.jpeg"



regexmatch(header,"(?<=Content-Length: )\d+",len)



if !InStr(FileExist(folder), "D")



FileCreateDir,% folder



fileFullPath:=folder "\" filename



if FileExist(fileFullPath)  {



if !isValidJpeg(fileFullPath)



FileDelete,% fileFullPath



}



_contentType:=""



if(DownloadFileType="dicom" || fileName~="i).dcm$")



_contentType:="&contentType=application/dicom"



,DownloadFileType:="dicom"



else if (DownloadFileType="png" || fileName~="i).png$")



_contentType:="&contentType=image/png"



,DownloadFileType:="png"



,url.="&imageQuality=100"



else



url.="&imageQuality=100"



,DownloadFileType:="jpeg"



if InStr(baseUrl, "pacsmobilenew"){



header=



			( LTRIM



			Referer: %baseUrl%



			Host: %host%



)



winhttprequest(url _contentType, post:="", header1:=header "`n" __ua_header , "binary`nsaveas: " fileFullPath , true)



,PacsWebCookieRenew(header1)



header:=header1



}else{



if InStr(baseUrl, "dlpacs.hospital-y.local"){



header:="Referer: " baseUrl "/html5/ShowImage.html?User=" loginId "&Password=" md5(loginPw) "&patientID=" chartNo "&accessionNumber=" AccNo "`nHost: " host



}else{



header=



			( LTRIM



			Referer: %baseUrl%/?&tab=Display&PatientID=%chartNo%&AccessionNumber=%AccNo%&theme=epr



			Host: %host%



)



if (baseUrl~="xero-\d+")



header.="`nCookie: " __PacsWebCookie



}



httprequest(url,post:="",header,"charset: utf-8`nbinary`nsaveas: " fileFullPath)



}



ifRetry:=false



if isValidJpeg(fileFullPath) || (DownloadFileType!="jpeg"){



if IsFunc(callback)



SetTimerFn(callback,-1, param)



ret:=0



}else{



ifRetry:=true



}



if(ifRetry){



FileDelete,% fileFullPath



if (--retry<1){



ret:=-1



}else



ret:=1



}



return ret<1?ret:PacsWebDownloadJpeg2(url,AccNo,chartNo,fileName,folder,PicWidth,loginid,loginpw,retry,fileSize,0, callback, param)



if (folder="")



folder:=A_ScriptDir



if (filename="")



filename:=AccNo " " chartNo " 1.jpeg"



regexmatch(header,"(?<=Content-Length: )\d+",len)



filedelete,% folder "\" filename



if !InStr(FileExist(folder), "D")



FileCreateDir,% folder



if (len>fileSize)



bytes:=BinWrite(folder "\" filename,post,len)



}



PacsWebServer(AccNo, ByRef outBaseUrl, ByRef outHost, new=true){



if (AccNo~="i)^Y"){



outBaseUrl:="http://dlpacs.hospital-y.local"



,outHost:="dlpacs.hospital-y.local"



return



}



RegExMatch(AccNo, "i)^T(\d)", hospitalCode)



if (hospitalCode1="4" || SubStr(AccNo,1,1)="H")



outBaseUrl:="http://pacs.hospital-h.local"



,outHost:="pacs.hospital-h.local"



else



outBaseUrl:=new?"http://pacsmobilenew.hospital-n.local":"http://pacsmobile.hospital-n.local"



,outHost:=new?"pacsmobilenew.hospital-n.local":"pacsmobile.hospital-n.local"



}



PacsWebDownloadJpeg(AccNo,chartNo="",fileName="",folder="",PicWidth="",loginid="",loginpw="",retry=3,fileSize=100){



static tried



++tried



if (chartNo!="")



while strlen(chartNo)<7



chartNo:="0" chartNo



PacsWebServer(AccNo, baseUrl, host)



url:=PacsWebUrl(AccNo,chartNo,loginId,loginPw)



header:="Host: " host "`nReferer: http://pacswide.hospital-n.local:8080/kQuery.php"



httprequest(url,post:="",header)



regexmatch(post,"i)wado\/\?v=[^\ \""]+",match)



StringReplace,match,match,&amp;,&,all



url:=baseUrl "/" match



url:=RegExReplace(url,"\d+$",picWidth?picWidth:a_screenwidth)



header:="Referer: " baseUrl "/?&tab=Display&PatientID=" chartNo "&AccessionNumber=" AccNo "&theme=epr`nHost: " host



httprequest(url,post:="",header1:=header,"charset: utf-8`nbinary")



if (folder="")



folder:=A_ScriptDir



if (filename="")



filename:=AccNo " " chartNo " 1.jpeg"



regexmatch(header1,"(?<=Content-Length: )\d+",len)



filedelete,% folder "\" filename



bytes:=BinWrite(folder "\" filename,post,len)



if(bytes>100)



return 0



else if (tried>=retry)



return tried



else



return PacsWebDownloadJpeg(AccNo,chartNo,fileName,folder,PicWidth,loginid,loginpw,retry,fileSize)



}



PacsWebCookieRenew(respoinse_headers){



global JSESSIONID, JSESSIONIDSSO



new_set:=false



if RegExMatch(respoinse_headers, "(?<=Set-Cookie: JSESSIONID=)\w+", match)



JSESSIONID:=match, new_set:=true



if RegExMatch(respoinse_headers, "(?<=Set-Cookie: JSESSIONIDSSO=)\w+", match)



JSESSIONIDSSO:=match, new_set:=true



return new_set



}



PacsWebLoginNew(accno, chartNo, loginId, loginPw){



global JSESSIONID, JSESSIONIDSSO, __ua_header



url:=Format("https://pacsmobilenew.hospital-n.local/?user={}&password={}&tab=Display&PatientID={}&AccessionNumber={}"



, loginId, loginPw, chartNo, accno)



,header:="Referer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PACS/MobileScreen.aspx`nHost: pacsmobilenew.hospital-n.local`n" __ua_header



,winhttprequest(url, post:="", header1:=header , "charset: utf-8", true)



,PacsWebCookieRenew(header1)



}



PacsWebLogoutNew(){



global JSESSIONID, JSESSIONIDSSO, __ua_header



static url:="https://pacsmobilenew.hospital-n.local/logout?v=3.0.SU6.23&language=zh_TW"



header=



	(LTrim



	Host: pacsmobilenew.hospital-n.local



	Referer: https://pacsmobilenew.hospital-n.local/



)



header.="`n" __ua_header "`nCookie: JSESSIONID=" JSESSIONID "; xero-viewport-size=1194/1438; JSESSIONIDSSO=" JSESSIONIDSSO "; version=3.0.SU6.23"



,winhttprequest(url,post:="", header1:=header, "charset: utf-8", true)



d:=1



}



PacsWebInfoNew(accNo, chartNo, loginId, loginPw, viewPortSize="1002/729"){



global JSESSIONID, JSESSIONIDSSO, __ua_header



,url:=Format("https://pacsmobilenew.hospital-n.local/wado/?v=3.0.SU6.23&requestType=STUDY&contentType=text/javascript&maxResults=500&PatientID={}&AccessionNumber={}&ae=local&IssuerOfPatientID=&groupByIssuer=*&suppressReportFlags=PRELIMINARY&language=zh_TW&theme=theme"



, chartNo, accno)



header=



	(LTrim



	Referer: https://pacsmobilenew.hospital-n.local/



	Host: pacsmobilenew.hospital-n.local



)



winhttprequest(url, post:="", header1:= header "`n" __ua_header, "charset: utf-8", true)



try



info := JXON_load(post)



catch



return []



output:=[]



,studyUID := info["children"][1]["children"][2]["studyUID"]



,ver := info["children"][1]["children"][2]["ver"]



,count := info["children"][1]["children"][2]["NumberOfStudyRelatedInstances"]



,url := Format("https://pacsmobilenew.hospital-n.local/wado/?v=3.0.SU6.23&requestType=IMAGE&contentType=text/javascript&regroup=*&studyUID={}&Position=0&Count={}&extraDicomAttributes=ImageOrientationPatient\ImagePositionPatient\PixelSpacing\FrameOfReferenceUID&fromHeader=false&suppressReportFlags=PRELIMINARY&ver={}&ae=local&gsps=Impax%20Presentation&language=zh_TW&theme=theme"



,studyUID, Count, ver)



,winhttprequest(url, post:="", header1:=header "`n" __ua_header, "charset: utf-8", true)



try {



json := JXON_load(post)



ind:=0



for k,v in json.children.1.children.2.children {



if (v.seriesUID="" || InStr(SeriesDescription, "Synthetic series") || InStr(v.seriesUID, "Markup"))



continue



++ind



output[ind]:=[]



,output[ind,"seriesUID"]:=seriesUID:=v.seriesUID



,ind2:=0



for x,y in v.children {



if (y.objectUID="" || InStr(y.objectUID, "Markup"))



continue



++ind2



output[ind,ind2,"objectUID"]:=y.objectUID



,output[ind,ind2,"url"]:=Format("https://pacsmobilenew.hospital-n.local/wado/?requestType=XERO&studyUID={}&seriesUID={}&language=zh_TW&objectUID={}&ae=local&v=3.0.SU6.23"



, studyUID, seriesUID, y.objectUID)



}



}



return output



}



catch



return []



}



PacsWebLogin(loginid,loginpw){



global pacsWebPhpid



if (pacsWebPhpId=""){



httprequest("http://pacswide.hospital-n.local:8080/",post:="",header:="","charset: utf-8")



RegExMatch(header,"i)PHPSESSID=(\w+)",match)



pacsWebPhpId:=match1



}



url:="http://pacswide.hospital-n.local:8080/auth_nh.php"



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: http://pacswide.hospital-n.local:8080/`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: pacswide.hospital-n.local:8080`nConnection: Keep-Alive`nPragma: no-cache`nCookie: PHPSESSID=" pacsWebPhpId



post:="account=" loginId "&pwd=" loginPw "&signIn=%E7%99%BB%E5%85%A5"



httprequest(url,post,header,"charset: utf-8")



if instr(post,"﻿﻿<script language='javascript'>location.replace('kQuery.php')</script>")



return 1



else



return 0



}



PacsWebQuery(chartNo,hospital="1",pageLimit=3){



global pacsWebPhpId



while strlen(chartNo)<7



chartNo:="0" chartNo



url:="http://pacsweb.hospital-n.local/gXWL.php"



header:="x-requested-with: XMLHttpRequest`nAccept-Language: zh-tw`nReferer: http://pacswide.hospital-n.local:8080/kQuery.php`nAccept: text/html, */*; q=0.01`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322; .NET4.0C; .NET4.0E)`nHost: pacswide.hospital-n.local:8080`nConnection: Keep-Alive`nPragma: no-cache`nCookie: PHPSESSID=" pacsWebPhpId



hospitalCode:=""



loop,parse,hospital,`,



hospitalCode.="hosp_id_0" a_loopfield "%2C"



hospitalCode:=substr(hospitalCode,1,-3)



if (hospitalCode="")



hospitalCode:="hosp_id_01"



post:="qMethod=pt_id&hosp_id=" hospitalCode "&user_hosp=01&pt_id=" chartNo "&fetchDbFlag=Y&qDirect=+&emgFlag=F"



httprequest(url,post,headerSent:=header,"charset: utf-8")



regexmatch(post,"第(\d)頁 / 共(\d)頁",match)



result:=[]



PacsWebResult(post,result)



loop % match2-1 {



if (pageLimit && a_index>pageLimit)



break



httprequest(url,post:="qMethod=pt_id&hosp_id=" hospitalCode "&user_hosp=01&pt_id=" chartNo "&fetchDbFlag=N&qDirect=next&emgFlag=F",headerSent:=header,"charset: utf-8")



PacsWebResult(post,result)



}



return result



}



PacsWebResult(html,byref arr){



dom:=ComObjCreate("HtmlFile")



,dom.write(html)



,table:=$(dom,"ptWL_table")



loop % table.rows.length-1 {



row:=table.rows[a_index]



,tmp:=[]



,tmp["Hospital"]:=trim(row.cells[2].innerText)



,tmp["Name"]:=trim(row.cells[3].innerText)



,tmp["Gender"]:=trim(row.cells[4].innerText)



,tmp["Age"]:=trim(row.cells[5].innerText)



,tmp["Birthday"]:=trim(row.cells[6].innerText)



,tmp["ChartNo"]:=trim(row.cells[7].innerText)



,tmp["Modality"]:=trim(row.cells[8].innerText)



,tmp["ExamDate"]:=trim(row.cells[9].innerText)



,tmp["AccessNo"]:=trim(row.cells[10].innerText)



,tmp["ExamName"]:=trim(row.cells[11].innerText)



,arr.push(tmp)



}



return arr



}



getRisPatientDx(PatientAccNo,hospital="T0",patientType="I"){



url:="http://hiswsvc.hospital-n.local/HL7Central_IIS/Central.asmx"



header:="User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; MS Web Services Client Protocol 2.0.50727.3623)`nContent-Type: text/xml; charset=utf-8`nSOAPAction: ""http://localhost/HL7Central/HL7Port""`nHost: hiswsvc.hospital-n.local`nExpect: 100-continue"



post:="<?xml version=""1.0"" encoding=""utf-8""?><soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema""><soap:Body><HL7Port xmlns=""http://localhost/HL7Central/""><HL7Input>&lt;QBP_Z10&gt;&lt;MSH&gt;&lt;MSH.3&gt;&lt;HD.1&gt;WebPageID&lt;/HD.1&gt;&lt;/MSH.3&gt;&lt;MSH.7&gt;&lt;TS.1&gt;" a_now ".0001"  "&lt;/TS.1&gt;&lt;/MSH.7&gt;&lt;MSH.9&gt;&lt;MSG.2&gt;Z01&lt;/MSG.2&gt;&lt;/MSH.9&gt;&lt;/MSH&gt;&lt;PV1&gt;&lt;PV1.2&gt;" patientType "&lt;/PV1.2&gt;&lt;PV1.3&gt;&lt;PL.11&gt;&lt;HD.1&gt;" hospital "&lt;/HD.1&gt;&lt;/PL.11&gt;&lt;/PV1.3&gt;&lt;PV1.19&gt;&lt;CX.1&gt;" PatientAccNo "&lt;/CX.1&gt;&lt;/PV1.19&gt;&lt;/PV1&gt;&lt;/QBP_Z10&gt;</HL7Input></HL7Port></soap:Body></soap:Envelope>"



httprequest(url,post,header,"charset: utf-8")



regexmatch(post,"is)<HL7PortResult>(.*)<\/HL7PortResult>",match)



StringReplace,match1,match1,&lt;,<,all



StringReplace,match1,match1,&gt;,>,all



return match1



}



getPacsHx(sid,patientIdorChartNo, hospital="T0"){



if(patientIdorChartNo="")



return



while strlen(patientIdorChartNo)<7



patientIdorChartNo:="0" patientIdorChartNo



if hospital!=



hospitalSpecified:=true



if StrLen(patientIdorChartNo)!=10 {



if SubStr(patientIdorChartNo,1,1)="H"



hospital=T4



else if SubStr(patientIdorChartNo,1,1)="Y"



hospital=Y0



}



if hospital=H



hospital=T4



else if hospital=Y



hospital=Y0



hospital:="&Hosp=" hospital



,personId:=strlen(patientIdorChartNo)<10?patientBasicInfo(patientIdorChartNo,sid).personId:patientIdorChartNo



,url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PACSImageShowList.aspx?SESSION=" sid "&PersonID=" personId hospital



,httprequest(url, post:="", header:="", "charset: utf-8")



,dom:=ComObjCreate("HtmlFile")



,dom.write(post)



,arr:=[]



,rows:=$(dom,"BloodCallRecordDataGrid").rows



loop % rows.length-1 {



cells:=rows[a_index].cells



,arr[a_index]:=[]



,arr[a_index,"ChartNo"]:=trim(cells[1].innerText)



,arr[a_index,"AccessNo"]:=arr[A_Index,"AccNo"]:=trim(cells[2].innerText)



,arr[a_index,"ExamDate"]:=trim(cells[3].innerText)



,arr[a_index,"ExamName"]:=trim(cells[4].innerText)



,arr[a_index,"Modality"]:=trim(cells[5].innerText)



,arr[a_index,"Status"]:=trim(cells[6].innerText)



}



if (!hospitalSpecified && !arr.maxIndex() && hospital!="")



return getPacsHx(sid, patientId, "T0")



else



return arr



}



queryOrderPriceIE(orderCode, sid, ByRef pwb="", query="code", hospitalCode="T0", queryYear="", queryMonth=""){



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/OrderPriceInfo/OrderPriceInfoQuery.aspx?SESSION=" sid



,year:=queryYear=""?A_YYYY:queryYear



,month:=queryMonth=""?a_mm+0:queryMonth



if !pwb



pwb:=ComObjCreate("InternetExplorer.Application")



,pwb.navigate(url)



Loop



Sleep 100



until !pwb.busy || A_Index>30



if(query="code")



pwb.document.getElementById("TxbQueryNOrderCode").value:=orderCode



,pwb.document.getElementById("TxbQueryOrderName").value:=""



else



pwb.document.getElementById("TxbQueryNOrderCode").value:=""



,pwb.document.getElementById("TxbQueryOrderName").value:=SubStr(orderCode,1,30)



pwb.document.getElementById("TxbHospitalCode").value:=hospitalCode



,pwb.document.getElementById("TxbQueryYear").value:=year



,pwb.document.getElementById("TxbQueryMonth").value:=month



,pwb.document.getElementById("BtnQuery").Click()



Loop



Sleep 100



until !pwb.busy && InStr(pwb.document.getElementById("DltNOrderInfoList").innerText, orderCode) || A_Index>30



tables:=pwb.document.getElementById("DltNOrderInfoList").rows



,ret:=[], col:=[]



Loop % tables.length {



dom:=ComObjCreate("HtmlFile")



,dom.write(t:=pwb.document.getElementById("DltNOrderInfoList").rows[A_Index-1].cells[0].innerHTML)



,table:=dom.getElementsByTagName("TABLE")[0]



,row:=table.rows[0]



if(A_Index=1){



Loop % row.cells.length



col.push(Trim(row.cells[A_Index-1].innerText))



}else{



ret[i:=A_Index-1]:=[]



Loop % row.cells.length



ret[i, col[A_Index]]:=Trim(row.cells[A_Index-1].innerText)



}



}



return ret



}



queryOrderPrice(orderCode, sid, hospitalCode="T0", queryYear="", queryMonth=""){



global __VIEWSTATE, __VIEWSTATEGENERATOR, __EVENTVALIDATION, portalAspId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/OrderPriceInfo/OrderPriceInfoQuery.aspx?SESSION=" sid



header1=



	(LTrim



	Host: ihisaw.hospital-n.local



	Referer: %url%



	Content-Type: application/x-www-form-urlencoded; charset=utf-8



	User-Agent: Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko



	X-Content-Type-Options: nosniff



	Cookie: menuHidden=Y; NPage_MenuSettingCookie=`%u91ab`%u4ee4`%u50f9`%u683c`%u67e5`%u8a62=Y



)



if (__VIEWSTATE="" || __EVENTVALIDATION="" || __VIEWSTATEGENERATOR="" || portalAspId=""){



httprequest(url, post:="",header:=header1, "charset: utf-8")



,RegExMatch(header,"i)(?<=ASP.NET_SessionId=)\w+",portalAspId)



,httprequest(url, post:="",header:=header1 "; ASP.NET_SessionId=" portalAspId, "charset: utf-8")



,renewPortalState(post)



}



header:=header1 "; ASP.NET_SessionId=" portalAspId



year:=queryYear=""?A_YYYY:queryYear



,month:=queryMonth=""?a_mm+0:queryMonth



,post:="ScriptManager1=UdpNOrderInfo%7CBtnQuery&__EVENTTARGET=&__EVENTARGUMENT=&ctl08_ExpandState=eenunnnnnnn&ctl08_SelectedNode=&ctl08_PopulateLog=&TxbQueryNOrderCode=" orderCode "&TxbQueryNHIOrderCode=&TxbQueryOrderName=&TxbHospitalCode=" hospitalCode "&TxbQueryYear=" year "&TxbQueryMonth=" month "&__ASYNCPOST=true&BtnQuery=%E6%9F%A5%E8%A9%A2(Q)"



httprequest(url



, post:=addPortalState(post)



, header, "charset: utf-8`n+NO_AUTO_REDIRECT")



dom:=ComObjCreate("HtmlFile")



,dom.write(post)



,tables:=dom.getElementById("DltNOrderInfoList").getElementByTagName("table")



,ret:=[], col:=[]



Loop % tables.length {



table:=tables[A_Index-1]



,row:=table.rows[0]



if(A_Index=1){



Loop % row.cells.length



col.push(Trim(row.cells[A_Index-1].innerText))



}else{



ret[i:=A_Index-1]:=[]



Loop % row.cells.length



ret[i, col[A_Index]]:=Trim(row.cells[A_Index-1].innerText)



}



}



return ret



}



queryPerformancePercentage(orderCode, sid, hospitalCode="T0"){



global __VIEWSTATE, __VIEWSTATEGENERATOR, __EVENTVALIDATION, portalAspId



url:="http://ahisaw.hospital-n.local/WebApplication/Administration/GCAPerformance/QueryPerformancePercentage.aspx?SESSION=" sid



if (__VIEWSTATE="" || __EVENTVALIDATION="" || __VIEWSTATEGENERATOR="" || portalAspId=""){



httprequest(url, post:="",header:="Host: ahisaw.hospital-n.local", "charset: utf-8")



,RegExMatch(header,"i)(?<=ASP.NET_SessionId=)\w+",portalAspId)



,renewPortalState(post)



}



header=



	(LTrim



	Referer: %url%



	Host: ahisaw.hospital-n.local



	Cookie: 15=1; remember=0; mypassword=; myaccount=; ASP.NET_SessionId=%portalAspId%; JSESSIONID=null



)



post:="scrollLeft=0&scrollTop=0&WebCtrlQueryPP%24ddlHospital=" hospitalCode "&WebCtrlQueryPP%24tbxOrderCode=" orderCode "&WebCtrlQueryPP%24btnQueryOrderPP=%E6%9F%A5%E8%A9%A2%E9%86%AB%E4%BB%A4%E6%8F%90%E6%88%90&WebCtrlQueryPP%24QueryOrderPercentageByOrderName1%24tbxOrderName="



,httprequest(url, post:=addPortalState(post), header, "charset: utf-8")



dom:=ComObjCreate("HtmlFile")



,dom.write(post)



,table:=dom.getElementById("WebCtrlQueryPP_dgrQOrderPP")



,ret:=[], col:=[]



Loop % table.rows.length {



row:=table.rows[A_Index-1]



if(A_Index=1){



Loop % row.cells.length



col.push(Trim(row.cells[A_Index-1].innerText))



}else{



ret[i:=A_Index-1]:=[]



Loop % row.cells.length



ret[i, col[A_Index]]:=Trim(row.cells[A_Index-1].innerText)



}



}



return ret



}



getPortalMessages(sid){



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ShowInfo.aspx?SESSION=" sid "&ACT=ShowNCPHSMessage", post:="")



,renewPortalState(post)



,dom:=ComObjCreate("HtmlFile")



,dom.write(post)



,tables:=dom.getElementById("dtlPHSMessage").getElementsByTagName("TABLE")



,arr:=[]



Loop % (tables.length-1)



Loop % (rows:=tables[A_Index].rows).length {



cells:=rows[A_Index-1].cells



,tmp:=[]



for k,v in ["index", "receiveNo", "sender", "sendTime", "receiveTime", "text", "status"]



tmp[v]:=Trim(cells[k].innerText)



arr.push(tmp)



break



}



return arr



}



getPortalMessages2(sid){



global __VIEWSTATE, __VIEWSTATEGENERATOR, __EVENTVALIDATION, portalAspId



header=



	(



	Host: portal.hospital-n.local



	Referer: http://portal.hospital-n.local/General/NewRedirect.aspx?SESSION=%sid%



	Content-Type: application/x-www-form-urlencoded; charset=UTF-8



	X-Requested-With: XMLHttpRequest



)



post:="Mode=CriticalPHSMessage"



,url:="http://portal.hospital-n.local/General/GeneralHandler.ashx"



,httprequest(url, post, header, "charset: utf-8")



try



return JXON_load(post)



}



confirmMessage(msgIndex, sid, ByRef portalMessage=""){



global __VIEWSTATE, __VIEWSTATEGENERATOR, __EVENTVALIDATION



if !IsObject(portalMessage)



msg:=getPortalMessages(sid)



else



msg:=portalMessage



for k, v in msg



if (v.index=msgIndex){



cb:="dtlPHSMessage$ctl" fill0(k,2) "$ckbSelect"



break



}



if(cb="")



return 1



post:="__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR) "&" encodeurl(cb) "=on&btnConfirm=%E7%A2%BA%E8%AA%8D%E7%B0%A1%E8%A8%8A"



,url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ShowInfo.aspx?SESSION=" sid "&ACT=ShowNCPHSMessage"



,httprequest(url, post, header:="Host: ihisaw.hospital-n.local`nReferer: " url, "charset: utf-8")



return !!InStr(post, "self.close()")



}



confirmMessage2(msg, sid){



global __VIEWSTATE, __VIEWSTATEGENERATOR, __EVENTVALIDATION, portalAspId



if (msg.hasKey("MessageSeqNo"))



jsonStr:=JXON_dump([{MessageSeqNo: msg.MessageSeqNo, PHSTelNo: msg.PHSTelNo, RoleCode: msg.RoleCode}])



else{



json:=[]



for k,v in msg



json.push({MessageSeqNo: v.MessageSeqNo, PHSTelNo: v.PHSTelNo, RoleCode: v.RoleCode})



jsonStr:=JXON_dump(json)



}



header:="Host: portal.hospital-n.local`nReferer: http://portal.hospital-n.local/General/NewRedirect.aspx?SESSION=" sid "`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nX-Requested-With: XMLHttpRequest"



,post:="Mode=CheckCriticalPHSMessage&ProcessString=" encodeurl(jsonStr)



,url:="http://portal.hospital-n.local/General/GeneralHandler.ashx"



,httprequest(url, post, header, "charset: utf-8")



return post=""""""



}



getPortalAspId(sid, url=""){



global portalAspId



if url=



url:="http://portal.hospital-n.local/General/NewRedirect.aspx?SESSION=" sid



httprequest(url, post:="", header:="")



,RegExMatch(header, "i)ASP\.NET_SessionId=(\w+)", match)



if match1



portalAspId:=match1



return portalAspId



}



getVSConfirmList(sid){



global portalAspId



url:="http://portal.hospital-n.local/General/NewRedirect.aspx?SESSION=" sid



,httprequest("http://portal.hospital-n.local/General/GeneralHandler.ashx", post:="Mode=VSConfirmList", header:="



	(LTrim



	X-Requested-With: XMLHttpRequest



	Content-Type: application/x-www-form-urlencoded; charset=UTF-8



	Referer: http://portal.hospital-n.local/General/NewRedirect.aspx?SESSION=" sid "



	Host: portal.hospital-n.local



	Cookie: ASP.NET_SessionId=" portalAspId "



	User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:61.0) Gecko/20100101 Firefox/61.0



)", "charset: utf-8")



try



return j:=JXON_load(post)



catch e



return []



}



EBMWebPacsLogin_IE(loginId, loginPw, branch, ByRef pwb=""){



if (SubStr(branch,1,2)="HC")



url:="http://hchwebpacs.hospital-h.local/"



else if (SubStr(branch,1,2)="YL")



url:="http://hwpacs.hospital-y.local/"



else if (branch=="CHUT")



url:="http://pacs.chut.hospital-n.local/"



if !pwb



pwb:=ComObjCreate("InternetExplorer.Application")



pwb.navigate(url)



while pwb.busy && A_Index <20



Sleep 100



Sleep 1000



js=javascript: (d=document).querySelector('input[name=User][class=Form]').value='%loginId%';d.querySelector('input[name=Password][class=Form]').value='%loginPw%';d.querySelector('#raQuery').click();loginclick();void 0;



pwb.navigate(js)



return pwb



}



HchWebPacsLogin_IE(loginId, loginPw, ByRef pwb=""){



static hchWebPacsUrl:="http://hchwebpacs.hospital-h.local/"



if !pwb



pwb:=ComObjCreate("InternetExplorer.Application")



pwb.navigate(hchWebPacsUrl)



while pwb.busy && A_Index <20



Sleep 100



Sleep 1000



js=javascript: (d=document).querySelector('input[name=User][class=Form]').value='%loginId%';d.querySelector('input[name=Password][class=Form]').value='%loginPw%';d.querySelector('#raQuery').click();loginclick();void 0;



pwb.navigate(js)



return pwb



}



EBMWebPacsQuery_IE(accno, ByRef pwb, chartNo="", no_re_search=true, open=true, ByRef breakQuery=false){



if WinExist(chartNo " ahk_exe WEBVIE~1.exe" ) || WinExist(chartNo " ahk_exe WebViewerComSrvEC.exe")



return



while StrLen(chartNo)<7



chartNo:="0" chartNo



while pwb.busy && (lastIndex:=A_Index) <20



if breakQuery



return -2



else



Sleep 100



sleep 1000



no_re_search:=!!no_re_search



,open:=!!open



js=!function(){var t,n,o,a,c,i,l="%chartNo%",m="%accno%",s=%no_re_search%,r=%open%,g=new RegExp(l.slice(0,-2)+"\\w\\w","i"),d=new RegExp(m.slice(0,-2)+"\\w\\w","i"),u=0;function f(){var e;try{e=o.getElementById("qkAccessNo").getElementsByTagName("input")[0].value===m&&o.getElementById("qkPatientID").getElementsByTagName("input")[0].value===l}catch(e){}void 0===e||s&&e||(t.value=0,t.onchange(),(t=n.COMPARISON).value=1,t.onchange(),""===l?((a=o.getElementById("qkAccessNo").getElementsByTagName("input")[0]).value=m,a.onchange(),(a=o.getElementById("qkPatientID").getElementsByTagName("input")[0]).value=""):((a=o.getElementById("qkPatientID").getElementsByTagName("input")[0]).value=l,a.onchange(),(a=o.getElementById("qkAccessNo").getElementsByTagName("input")[0]).value=""),a.onchange(),o.getElementById("QueryBtn").click(),console.log("info entered")),r&&(u=0,setTimeout(T,500))}function T(){var e;try{e=!g.test((i=(o=document.getElementById("mainframeset").getElementsByTagName("frameset")[0].getElementsByTagName("frame").Patientfrm.contentWindow.document).getElementById("RTable")).innerText)&&-1==o.innerText.indexOf("連線逾")}catch(e){}++u<50?void 0===e||e||-1!=o.body.innerText.indexOf("連線逾")?(console.log("wait search..."),setTimeout(T,100)):setTimeout(y,500):console.log("wait search... time out!")}function y(){var e,t,n;for(e=0;e<i.rows.length;e++)if(-1<(t=i.rows[e]).innerText.indexOf(m))return N(t),void console.log("found accno!");for(;;){try{n=i.rows.length}catch(e){n=0}if(0<n)break}for(e=0;e<i.rows.length;e++)if(t=i.rows[e],d.test(t.innerText)&&/CT|MR/i.test(t.cells[14].innerText))return N(t),void console.log("found accnoRegex...");console.log("not found...")}function N(e){e.click(),setTimeout(function(){e.cells[0].firstChild.click()},200),setTimeout(e.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.ondblclick,500)}setTimeout(function e(){try{c=(t=(n=(o=document.getElementById("mainframeset").getElementsByTagName("frame").Queryfrm.contentWindow.document).getElementsByTagName("select")).DATEOPTION).name}catch(e){c=""}u++;u<50?""===c?(console.log("wait loaded..."),setTimeout(e,100)):setTimeout(f,500):console.log("wait loaded... time out!")},100)}();



execJS(pwb, js)



if breakQuery



return -2



if(open){



while pwb.busy && (lastIndex:=A_Index)<20



if breakQuery



return -2



else



Sleep 100



while !((tb:=(d:=pwb.document.getElementById("mainframeset").getElementsByTagName("frameset")[0].getElementsByTagName("frame")["Patientfrm"].contentWindow.document).getElementById("RTable")).innerText ~= SubStr(chartNo,1,-2) "\w\w" ) && !InStr(d.innerText, "連線逾") && (lastIndex:=A_Index)<50



if breakQuery



return -2



else



Sleep 100



if lastIndex==50



return -1



if InStr(d.innerText, "連線逾"){



return -1



}



Sleep 500



if breakQuery



return -2



Loop % (rows:=tb.rows).length {



row:=rows[(lastIndex:=A_Index)-1]



if InStr(row.innerText, accno){



row.cells[0].firstChild.click()



return



}



}



if breakQuery



return -2



Loop % (rows:=tb.rows).length {



row:=rows[(lastIndex:=A_Index)-1]



if (row.innerText~= SubStr(accno,1,-2) "\w\w") && (row.cells[14].innerText~="i)CT|MR"){



row.cells[0].firstChild.click()



return



}



}



if breakQuery



return -2



Loop % (rows:=tb.rows).length {



row:=rows[(lastIndex:=A_Index)-1]



row.cells[0].firstChild.click()



pwb.Visible:=true



return



}



}



return -1



}



ParseHchWebPacsQueryResult(ByRef pwb){



d:=pwb.document.getElementById("mainframeset").getElementsByTagName("frameset")[0].getElementsByTagName("frame")["Patientfrm"].contentWindow.document



,tb:=d.getElementById("RTable")



,titles:=[]



,data:=[]



Loop % (rows:=tb.rows).length {



row:=rows[A_Index-1]



,r:=[]



if (A_Index=1){



Loop % (cells:=row.cells).length {



cell:=cells[A_Index-1]



,r.push(Trim(cell.innerText))



}



}else{



}



}



}



class HcHWebPacs {



__New(loginId, loginPw) {



this.host:="hchwebpacs.hospital-h.local"



,this.url:="http://hchwebpacs.hospital-h.local/"



,this.params:=[]



,httprequest(this.url, post:="", header:="")



this.login(loginId, loginPw)



}



login(id, pw){



httprequest(this.url "DicomWeb/DicomWeb.dll/Login", post:="User=" id "&Password=" pw, header:="



		(



		Referer: " this.url "



		Host: " this.host "



		Cookie: TS=43253.5002399074; SN=-1721468625



)")



if InStr(post, "LoginErrorLocalization()")



MsgBox fail



this.loginId:=id



this.loginPw:MOCK_PASSWORD



}



}



execJS(byref pwb, byref js){



e:=pwb.document.createElement("script")



,e.text:=js



if (p:=pwb.document.head) || (p:=pwb.document.documentElement) || (p:=pwb.document.body)



p.appendChild(e)



}



#MaxMem 4095



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



,SC_FOLDLEVELHEADERFLAG:=0x2000,SC_FOLDLEVELBOXHEADERFLAG:=0x4000,SC_FOLDLEVELBOXFOOTERFLAG:=0x8000,SC_FOLDLEVELCONTRACTED:=0x10000



,SC_FOLDLEVELUNINDENT:=0x20000,SC_FOLDLEVELNUMBERMASK:=0x0FFF,SC_FOLDFLAG_LINEBEFORE_EXPANDED:=0x0002,SC_FOLDFLAG_LINEBEFORE_CONTRACTED:=0x0004



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



class ACC_OBJID{



static    WINDOW                :=    0x00000000



static    SYSMENU               :=    0xFFFFFFFF



static    TITLEBAR              :=    0xFFFFFFFE



static    MENU                  :=    0xFFFFFFFD



static    CLIENT                :=    0xFFFFFFFC



static    VSCROLL               :=    0xFFFFFFFB



static    HSCROLL               :=    0xFFFFFFFA



static    SIZEGRIP              :=    0xFFFFFFF9



static    CARET                 :=    0xFFFFFFF8



static    CURSOR                :=    0xFFFFFFF7



static    ALERT                 :=    0xFFFFFFF6



static    SOUND                 :=    0xFFFFFFF5



static    QUERYCLASSNAMEIDX     :=    0xFFFFFFF4



static    NATIVEOM            :=    0xFFFFFFF0



}



class ACC_STATE {



static    NORMAL                  :=        0



static    UNAVAILABLE             :=        0x1



static    SELECTED                :=        0x2



static    FOCUSED                 :=        0x4



static    PRESSED                 :=        0x8



static    CHECKED                 :=        0x10



static    MIXED                   :=        0x20



static    INDETERMINATE           :=        this.MIXED



static    READONLY                :=        0x40



static    HOTTRACKED              :=        0x80



static    DEFAULT                 :=        0x100



static    EXPANDED                :=        0x200



static    COLLAPSED               :=        0x400



static    BUSY                    :=        0x800



static    FLOATING                :=        0x1000



static    MARQUEED                :=        0x2000



static    ANIMATED                :=        0x4000



static    INVISIBLE               :=        0x8000



static    OFFSCREEN               :=        0x10000



static    SIZEABLE                :=        0x20000



static    MOVEABLE                :=        0x40000



static    SELFVOICING             :=        0x80000



static    FOCUSABLE               :=        0x100000



static    SELECTABLE              :=        0x200000



static    LINKED                  :=        0x400000



static    TRAVERSED               :=        0x800000



static    MULTISELECTABLE         :=        0x1000000



static    EXTSELECTABLE           :=        0x2000000



static    ALERT_LOW               :=        0x4000000



static    ALERT_MEDIUM            :=        0x8000000



static    ALERT_HIGH              :=        0x10000000



static    PROTECTED               :=        0x20000000



static    VALID                   :=        0x7fffffff



}



class ACC_ROLE {



static    TITLEBAR                :=        0x1



static    MENUBAR                 :=        0x2



static    SCROLLBAR               :=        0x3



static    GRIP                    :=        0x4



static    SOUND                   :=        0x5



static    CURSOR                  :=        0x6



static    CARET                   :=        0x7



static    ALERT                   :=        0x8



static    WINDOW                  :=        0x9



static    CLIENT                  :=        0xa



static    MENUPOPUP               :=        0xb



static    MENUITEM                :=        0xc



static    TOOLTIP                 :=        0xd



static    APPLICATION             :=        0xe



static    DOCUMENT                :=        0xf



static    PANE                    :=        0x10



static    CHART                   :=        0x11



static    DIALOG                  :=        0x12



static    BORDER                  :=        0x13



static    GROUPING                :=        0x14



static    SEPARATOR               :=        0x15



static    TOOLBAR                 :=        0x16



static    STATUSBAR               :=        0x17



static    TABLE                   :=        0x18



static    COLUMNHEADER            :=        0x19



static    ROWHEADER               :=        0x1a



static    COLUMN                  :=        0x1b



static    ROW                     :=        0x1c



static    CELL                    :=        0x1d



static    LINK                    :=        0x1e



static    HELPBALLOON             :=        0x1f



static    CHARACTER               :=        0x20



static    LIST                    :=        0x21



static    LISTITEM                :=        0x22



static    OUTLINE                 :=        0x23



static    OUTLINEITEM             :=        0x24



static    PAGETAB                 :=        0x25



static    PROPERTYPAGE            :=        0x26



static    INDICATOR               :=        0x27



static    GRAPHIC                 :=        0x28



static    STATICTEXT              :=        0x29



static    TEXT                    :=        0x2a



static    PUSHBUTTON              :=        0x2b



static    CHECKBUTTON             :=        0x2c



static    RADIOBUTTON             :=        0x2d



static    COMBOBOX                :=        0x2e



static    DROPLIST                :=        0x2f



static    PROGRESSBAR             :=        0x30



static    DIAL                    :=        0x31



static    HOTKEYFIELD             :=        0x32



static    SLIDER                  :=        0x33



static    SPINBUTTON              :=        0x34



static    DIAGRAM                 :=        0x35



static    ANIMATION               :=        0x36



static    EQUATION                :=        0x37



static    BUTTONDROPDOWN          :=        0x38



static    BUTTONMENU              :=        0x39



static    BUTTONDROPDOWNGRID      :=        0x3a



static    WHITESPACE              :=        0x3b



static    PAGETABLIST             :=        0x3c



static    CLOCK                   :=        0x3d



static    SPLITBUTTON             :=        0x3e



static    IPADDRESS               :=        0x3f



static    OUTLINEBUTTON           :=        0x40



}



class ACC_NAVDIR {



static    MIN                     :=    0x0



static    UP                      :=    0x1



static    DOWN                    :=    0x2



static    LEFT                    :=    0x3



static    RIGHT                   :=    0x4



static    NEXT                    :=    0x5



static    PREVIOUS                :=    0x6



static    FIRSTCHILD              :=    0x7



static    LASTCHILD               :=    0x8



static    MAX                     :=    0x9



}



class ACC_SELECTIONFLAG {



static    NONE                    := 0x0



static    TAKEFOCUS               := 0x1



static    TAKESELECTION           := 0x2



static    EXTENDSELECTION         := 0x4



static    ADDSELECTION            := 0x8



static    REMOVESELECTION         := 0x10



static    VALID                   := 0x1f



}



class ACC_EVENT {



static MIN                        := 0x00000001



static MAX                        := 0x7FFFFFFF



static SYSTEM_SOUND               := 0x0001



static SYSTEM_ALERT               := 0x0002



static SYSTEM_FOREGROUND          := 0x0003



static SYSTEM_MENUSTART           := 0x0004



static SYSTEM_MENUEND             := 0x0005



static SYSTEM_MENUPOPUPSTART      := 0x0006



static SYSTEM_MENUPOPUPEND        := 0x0007



static SYSTEM_CAPTURESTART        := 0x0008



static SYSTEM_CAPTUREEND          := 0x0009



static SYSTEM_MOVESIZESTART       := 0x000A



static SYSTEM_MOVESIZEEND         := 0x000B



static SYSTEM_CONTEXTHELPSTART    := 0x000C



static SYSTEM_CONTEXTHELPEND      := 0x000D



static SYSTEM_DRAGDROPSTART       := 0x000E



static SYSTEM_DRAGDROPEND         := 0x000F



static SYSTEM_DIALOGSTART         := 0x0010



static SYSTEM_DIALOGEND           := 0x0011



static SYSTEM_SCROLLINGSTART      := 0x0012



static SYSTEM_SCROLLINGEND        := 0x0013



static SYSTEM_SWITCHSTART         := 0x0014



static SYSTEM_SWITCHEND           := 0x0015



static SYSTEM_MINIMIZESTART       := 0x0016



static SYSTEM_MINIMIZEEND         := 0x0017



static CONSOLE_CARET              := 0x4001



static CONSOLE_UPDATE_REGION      := 0x4002



static CONSOLE_UPDATE_SIMPLE      := 0x4003



static CONSOLE_UPDATE_SCROLL      := 0x4004



static CONSOLE_LAYOUT             := 0x4005



static CONSOLE_START_APPLICATION  := 0x4006



static CONSOLE_END_APPLICATION    := 0x4007



static OBJECT_CREATE              := 0x8000



static OBJECT_DESTROY             := 0x8001



static OBJECT_SHOW                := 0x8002



static OBJECT_HIDE                := 0x8003



static OBJECT_REORDER             := 0x8004



static OBJECT_FOCUS               := 0x8005



static OBJECT_SELECTION           := 0x8006



static OBJECT_SELECTIONADD        := 0x8007



static OBJECT_SELECTIONREMOVE     := 0x8008



static OBJECT_SELECTIONWITHIN     := 0x8009



static OBJECT_STATECHANGE         := 0x800A



static OBJECT_LOCATIONCHANGE      := 0x800B



static OBJECT_NAMECHANGE          := 0x800C



static OBJECT_DESCRIPTIONCHANGE   := 0x800D



static OBJECT_VALUECHANGE         := 0x800E



static OBJECT_PARENTCHANGE        := 0x800F



static OBJECT_HELPCHANGE          := 0x8010



static OBJECT_DEFACTIONCHANGE     := 0x8011



static OBJECT_ACCELERATORCHANGE   := 0x8012



}



class VT_CONSTANTS {



static EMPTY     :=    0x0



static NULL      :=    0x1



static I2        :=    0x2



static I4        :=    0x3



static R4        :=    0x4



static R8        :=    0x5



static CY        :=    0x6



static DATE      :=    0x7



static BSTR      :=    0x8



static DISPATCH  :=    0x9



static ERROR     :=    0xA



static BOOL      :=    0xB



static VARIANT   :=    0xC



static UNKNOWN   :=    0xD



static DECIMAL   :=    0xE



static I1        :=   0x10



static UI1       :=   0x11



static UI2       :=   0x12



static UI4       :=   0x13



static I8        :=   0x14



static UI8       :=   0x15



static INT       :=   0x16



static UINT      :=   0x17



static RECORD    :=   0x24



static ARRAY     := 0x2000



static BYREF     := 0x4000



}



class ACC_FILTERS {



byDefaultAction(oAcc,action){



try



b := oAcc.accDefaultAction = action



return b



}



byDescription(oAcc,desc){



try



b := oAcc.accDescription = desc



return b



}



byValue(oAcc,value){



try



b := oAcc.accValue = value



return b



}



byHelp(oAcc,help){



try



b := oAcc.accHelp = help



}



byState(oAcc,state){



try



return oAcc.accState & state



}



byRole(oAcc,role){



try



b := oAcc.accRole = role



return b



}



byName(oAcc,name){



try



b := oAcc.accName = name



return b



}



byRegex(oAcc,rx){



try



info := oAcc.accName . ";"



. oAcc.accHelp . ";"



. oAcc.accValue ";"



. oAcc.accDescription . ";"



. oAcc.accDefaultAction



return RegexMatch(Haystack, rx) > 0



}



}



Acc_Init() {



Static    h := DllCall("LoadLibrary","Str","oleacc","Ptr")



}



Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild) {



Acc_Init()



if (DllCall("oleacc\AccessibleObjectFromEvent"



, "Ptr", hWnd



, "UInt", idObject



, "UInt", idChild



, "Ptr*", pacc



, "Ptr", VarSetCapacity(varChild, 8 + 2 * A_PtrSize, 0) * 0 + &varChild) = 0) {



_idChild_:=NumGet(varChild,8,"UInt")



return ComObjEnwrap(9,pacc,1)



}



}



Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "") {



Acc_Init()



if (DllCall("oleacc\AccessibleObjectFromPoint"



, "Int64", x == ""||y==""



? 0 * DllCall("GetCursorPos","Int64*",pt) + pt



: x & 0xFFFFFFFF | y << 32



, "Ptr*", pacc



, "Ptr", VarSetCapacity(varChild, 8 + 2 * A_PtrSize, 0) * 0 + &varChild) = 0) {



_idChild_:=NumGet(varChild,8,"UInt")



return ComObjEnwrap(9,pacc,1)



}



}



Acc_ObjectFromWindow(hWnd, idObject = -4) {



Acc_Init()



if (DllCall("oleacc\AccessibleObjectFromWindow"



, "Ptr", hWnd



, "UInt", idObject &= 0xFFFFFFFF



, "Ptr", -VarSetCapacity(IID,16)



+ NumPut(idObject == 0xFFFFFFF0



? 0x46000000000000C0



: 0x719B3800AA000C81



, NumPut(idObject == 0xFFFFFFF0



? 0x0000000000020400



: 0x11CF3C3D618736E0,IID,"Int64"),"Int64")



, "Ptr*", pacc) = 0)



return ComObjEnwrap(9,pacc,1)



}



Acc_WindowFromObject(pacc) {



if (DllCall("oleacc\WindowFromAccessibleObject"



, "Ptr", IsObject(pacc) ? ComObjValue(pacc) : pacc



, "Ptr*", hWnd) = 0)



return hWnd



}



Acc_GetRoleText(nRole) {



nSize := DllCall("oleacc\GetRoleText"



, "Uint", nRole



, "Ptr", 0



, "Uint", 0)



VarSetCapacity(sRole, (A_IsUnicode ? 2 : 1) * nSize)



DllCall("oleacc\GetRoleText"



, "Uint", nRole



, "str", sRole



, "Uint", nSize+1)



return sRole



}



Acc_GetStateText(nState) {



nSize := DllCall("oleacc\GetStateText"



, "Uint", nState



, "Ptr", 0



, "Uint", 0)



VarSetCapacity(sState, (A_IsUnicode ? 2 : 1) * nSize)



DllCall("oleacc\GetStateText"



, "Uint", nState



, "str", sState



, "Uint", nSize+1)



return sState



}



Acc_SetWinEventHook(eventMin, eventMax, pCallback) {



Return    DllCall("SetWinEventHook", "Uint", eventMin, "Uint", eventMax, "Uint", 0, "Ptr", pCallback, "Uint", 0, "Uint", 0, "Uint", 0)



}



Acc_UnhookWinEvent(hHook) {



Return    DllCall("UnhookWinEvent", "Ptr", hHook)



}



Acc_Role(Acc, ChildId=0) {



try return ComObjType(Acc,"Name") = "IAccessible"



? Acc_GetRoleText(Acc.accRole(ChildId))



: "invalid object"



}



Acc_State(Acc, ChildId=0) {



try return ComObjType(Acc,"Name") = "IAccessible"



? Acc_GetStateText(Acc.accState(ChildId))



: "invalid object"



}



Acc_Location(Acc, ChildId=0) {



try Acc.accLocation(ComObj(0x4003, & x := 0)



, ComObj(0x4003,&y:=0)



, ComObj(0x4003,&w:=0)



, ComObj(0x4003,&h:=0)



, ChildId)



catch



return



return { x:NumGet(x,0,"int")



, y:NumGet(y,0,"int")



, w:NumGet(w,0,"int")



, h:NumGet(h,0,"int")



, pos:"x" NumGet(x,0,"int")



. " y" NumGet(y,0,"int")



. " w" NumGet(w,0,"int")



. " h" NumGet(h,0,"int") }



}



Acc_Parent(Acc) {



try parent := Acc.accParent



return parent ? Acc_Query(parent) :



}



Acc_Child(Acc, ChildId=0) {



try child := Acc.accChild(ChildId)



return child ? Acc_Query(child) :



}



Acc_Query(Acc) {



try return ComObj(9, ComObjQuery(Acc, "{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)



}



Acc_Error(p="") {



static setting:=0



return p=""?setting:setting:=p



}



Acc_Children(Acc) {



if ComObjType(Acc,"Name") != "IAccessible"



ErrorLevel := "Invalid IAccessible Object"



else {



Acc_Init(), cChildren:=Acc.accChildCount, Children:=[], ErrorLevel=



if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {



Loop %cChildren%



{



i:=(A_Index-1)*(A_PtrSize*2+8)+8



,child:=NumGet(varChildren,i)



,ComType := NumGet(varChildren,i-8)



if (ComType = VT_CONSTANTS.DISPATCH) {



Children.push(Acc_Query(child))



,ObjRelease(child)



} else if (ComType = VT_CONSTANTS.I4) {



Children.push(new ACC_ChildProxy(Acc,child))



} else {



ErrorLevel := "Unknown ComType: " ComType



,Children.push(child)



}



}



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



AccChild:=Acc_Query(child), ObjRelease(child), Acc_Role(AccChild)=Role?Children.Insert(AccChild):



else



Acc_Role(Acc, child)=Role?Children.Insert(child):



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



acc_childrenByName(oAccessible, name,returnOne=false){



items:=Acc_Children(oAccessible)



results := []



for k,item in items



{



if item.accName = name {



if returnOne {



return item



}



results.push(item)



}



}



return results



}



acc_childrenFilter(oAcc, fCondition, value=0, returnOne=false, obj=0){



items:=Acc_Children(oAcc)



results := []



if !IsFunc(fCondition)



return 0



if obj =0



obj:=ACC_FILTERS



methodCallConvention = instr(fCondition.name, ".") > 0



for k,item in items



{



if methodCallConvention {



condition := fCondition.call(obj,item,value)



} else {



condition := fCondition.call(item,value)



}



if condition {



if returnOne {



return item



}



results.push(item)



}



}



return results



}



acc_getRootElement(){



return acc_ObjectFromWindow(0x10010)



}



class ACC_ChildProxy {



__New(oAccParent,id){



try



this.__accParent         := oAccParent



try



this.__accChildID        := id



try



this.accDefaultAction    := oAccParent.accDefaultAction(id)



try



this.accDescription      := oAccParent.accDescription(id)



try



this.accHelp             := oAccParent.accHelp(id)



try



this.accHelpTopic        := oAccParent.accHelpTopic(id)



try



this.accKeyboardShortcut := oAccParent.accKeyboardShortcut(id)



try



this.accName             := oAccParent.accName(id)



try



this.accParent           := oAccParent



try



this.accRole             := oAccParent.accRole(id)



try



this.accState            := oAccParent.accState(id)



try



this.accValue            := oAccParent.accValue(id)



try



this.accFocus            := this.accState && ACC_STATE.FOCUSED



}



accDoDefaultAction(){



try



return this.__accParent.accDoDefaultAction(this.__accChildID)



}



accHitTest(){



return false



}



accLocation(ByRef left, Byref top, ByRef width, ByRef height){



try



return this.__accParent.accLocation(left, top, width, height, this.__accChildID)



}



accNavigate(){



try



return this.__accParent.accNavigate(navDir,this.__accChildID)



}



accSelect(flagsSelect){



try



return this.__accParent.accSelect(flagsSelect,this.__accChildID)



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



Acc_ObjectFromWindow2(hWnd, idObject = -4)



{



If DllCall(AccessibleObjectFromWindowProc, "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0



Return	ComObjEnwrap(9,pacc,1)



}



Acc_Children_first(Acc,Count=1){



if ComObjType(Acc,"Name") != "IAccessible"



ErrorLevel := "Invalid IAccessible Object"



else {



Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]



if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {



Loop %cChildren%



{



if A_Index>Count



break



i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.push(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):



}



return Children.MaxIndex()?Children:[]



} else



ErrorLevel := "AccessibleChildren DllCall Failed"



}



if Acc_Error()



throw Exception(ErrorLevel,-1)



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



SetTimerF(Function, Period=0, ParmObject=0, Priority=0 ) {



return setTimerFn(Function, Period, ParmObject, Priority, true)



}



SetTimerF_( Function, Period=0, ParmObject=0, Priority=0 ) {



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



if hwnd=



return



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



WS_EX_CONTROLPARENT =0x10000



WS_EX_APPWINDOW =0x40000



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



EmptyMem(PIDtoEmpty=""){



if(PIDtoEmpty="")



PIDtoEmpty:=DllCall("GetCurrentProcessId")



h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", PIDtoEmpty, "Ptr")



,DllCall("SetProcessWorkingSetSize", "Ptr", h, "Int", -1, "Int", -1)



,DllCall("CloseHandle", "Ptr", h)



}



class setTimerClass {



setTimer(method, period){



if this.__setTimerBindFn.has(method)



fn:=this.__setTimerBindFn[method]



else



this.__setTimerBindFn[method]:= fn := this[method].bind(this)



settimer % fn, % period



}



}



SetTitleMatchMode,2



DetectHiddenWindows,on



CoordMode,mouse,screen



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



try



RisImpaxPwData:=Crypt.Encrypt.StrDecrypt(RegExReplace(RisImpaxPwData, "^\s*ENCRYPT", ""),AES_pw,7,6)



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



return Crypt.Encrypt.StrEncrypt(str, pw, 7,6)



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



return 0



}



RisImpaxPollingNotExist(){



}



RisImpax__tooltip(){



ToolTip



}



RisImpaxRegister(infoJson){



if !(hwnd:=RisImpaxPollingInit()){



MsgBox % "RisImpaxPolling.exe not found!"



return new RisImpaxPollingSingleInstance(infoJson)



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



class RisImpaxPollingSingle extends setTimerClass {



static __RisImpaxPollingSingleInstance:=0



__New(infoJson){



if IsObject( this.__RisImpaxPollingSingleInstance )



return this.__RisImpaxPollingSingleInstance



this.thisHwnd:=WinExist("Ahk_PID " this.thisPid:=DllCall("GetCurrentProcessId"))



for k,v in infoJson {



if (v.msg.msg && v.func && v.func!=OnMessage(v.msg.msg))



OnMessage(v.msg.msg, v.func)



if (v.func && v.initStart)



SetTimerF(v.func, (-1)*v.initStart)



if !WinExist("ahk_id " v.hwnd)



infoJson[k, "hwnd"]:=this.thisHwnd



}



this.RisRegisterList:={StateChange:{}



, AccNoChange:{}



, OldReportChange:{}



, Count:0}



,this.ImpaxRegisterList:={StateChange:{}



, AccNoChange:{}



, Count:0}



for k, cmd in infoJson



if WinExist("ahk_id "  cmd.hwnd){



app:=cmd.App



,this[%app%RegisterList][cmd.Type "Change", cmd.hwnd]:=cmd.msg



PostMessage,% cmd.msg,% cmd.wParam,% cmd.lParam,,% "ahk_id " cmd.hwnd



}



this.infoJson:=infoJson



,this.risRefreshInterval:=-300



,this.impaxRefreshInterval:=-300



,this.setTimer("RisRefresh", this.risRefreshInterval)



,this.setTimer("ImpaxRefresh", this.impaxRefreshInterval)



,this.setTimer("EmptyMem", 300000)



}



RisRefresh(){



if (this.RisRegisterList.Count=0){



this.setTimer("RisRefresh", this.risRefreshInterval)



return



}



this.cRisState:=RisOpened()



if (this.pRisState[1]!=this.cRisState[1] || this.pRisState[2]!=this.cRisState[2])



this.SetTimer("postMsg_RisState",-1)



this.pRisState:=this.cRisState



if(this.RisRegisterList.AccNoChange.SetCapacity(0)>0){



cAccNo:=getRisAccNo(this.cRisState[2])



if(pAccNo!=cAccNo)



SetTimerF("postMsg_RisAccNo", -500)



pAccNo:=cAccNo



}



if(this.RisRegisterList.OldReportChange.SetCapacity(0)>0){



this.cOldReport:=ControlGetText(getRisReports(this.cRisState[2])[2,1])



if(this.pOldReport!=this.cOldReport){



this.SetTimer("postMsg_RisOldreport",-1)



}



this.pOldReport:=this.cOldReport



}



this.setTimer("RisRefresh", this.risRefreshInterval)



}



ImpaxRefresh(){



if (this.impaxRegisterList.Count=0){



this.setTimer("ImpaxRefresh", this.impaxRefreshInterval)



return



}



this.cImpaxState:=impaxOpened()



if (this.pImpaxState[1]!=this.cImpaxState[1] || this.pImpaxState[2,1]!=this.cImpaxState[2,1] || this.pImpaxState[2,4]!=this.cImpaxState[2,4])



this.SetTimer("postMsg_ImpaxState",-1)



this.pImpaxState:=this.cImpaxState



if(this.impaxRegisterList.AccNoChange.SetCapacity(0)>0){



cAccNo:=getimpaxAccNo(this.cImpaxState[2])



if(pAccNo!=cAccNo)



this.SetTimer("postMsg_ImpaxAccNo",-500)



pAccNo:=cAccNo



}



this.setTimer("ImpaxRefresh", this.impaxRefreshInterval)



}



postMsg_RisState(){



this.postMsg(this.RisRegisterList["StateChange"])



}



postMsg_RisOldreport(){



this.postMsg(this.RisRegisterList["OldreportChange"])



}



postMsg_RisAccNo(){



this.postMsg(this.RisRegisterList.AccNoChange)



}



postMsg_ImpaxState(){



this.postMsg(this.ImpaxRegisterList["StateChange"])



}



postMsg_ImpaxAccNo(){



this.postMsg(this.impaxRegisterList.AccNoChange)



}



postMsg(list){



for hwnd, msg in list



PostMessage,% msg.msg,% msg.wParam,% msg.lParam,,% "ahk_id " hwnd



}



EmptyMem(){



EmptyMem(this.thisPid)



}



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



if(!direct){



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



directPaths:=[]



loop,HKCU,Software\Microsoft\Windows\ShellNoRoam\MUICache



if instr(a_loopregname,"Menu.exe") && fileexist(a_loopregname)



directPaths.push(a_loopregname)



loop,HKCU,Software\Microsoft\Internet Explorer\TypedURLs



{



regread,v



if instr(a,"Menu.exe") && fileexist(v)



directPaths.push(v)



}



for k,v in searchFile("Menu.exe",a_appdata "\..\Local\Apps\2.0")



directPaths.push(v)



return directPaths



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



getChartNo(id, getprv=true){



return getRisChartNo(id, getprv)



}



getRisChartNo(hwnd, getprv=true){



static prvHwnd



for k,v in controls:=getcontrols(hwnd)



if RegExMatch(v.text,"^\w{6}\d$") && controls[k-1].text="病歷號"



chartNo:=v.text, prvHwnd:=v.hwnd



if(chartNo="") && getprv



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



getRisChartNoHwnd(hwnd, getprv=true){



static prvHwnd



for k,v in controls:=getcontrols(hwnd)



if RegExMatch(v.text,"^\w{6}\d$") && controls[k-1].text="病歷號"



return % prvHwnd:=id:=v.hwnd



if getprv



return prvHwnd



for k,v in getcontrols(hwnd)



if instr(v.classNN,"WindowsForms10.EDIT") && acc_objectfromwindow(v.hwnd).accName="病歷號"



{



return v.hwnd



}



}



getRisAccNo(hwnd, getprv=true){



return getRisSheetNo(hwnd, getprv)



}



getRisSheetNo(hwnd, getprv=true){



static prvHwnd



for k,v in controls:=getcontrols(hwnd)



if controls[k-1].text="照會單號" && regexmatch(v.text,"^\w{11}$") && instr(v.classNN,"WindowsForms10.EDIT")



{



prvHwnd:=v.hwnd



return v.text



}



if getprv



return ControlGetText(prvHwnd)



}



getRisAccNoHwnd(risHwnd, getPrv=true){



static prvHwnd



for k,v in controls:=getcontrols(risHwnd)



if controls[k-1].text="照會單號" && regexmatch(v.text,"^\w{11}$") && instr(v.classNN,"WindowsForms10.EDIT")



{



return prvHwnd:=v.hwnd



}



if getprv



return prvHwnd



}



getRisHistoryId(hwnd, getprv=true){



static prvHwnd



for k,v in controls:=getControls(hwnd)



if (instr(v.classNN,"WindowsForms10.Window.8.app") && v.text="歷史報告" && instr(controls[k+3,"classNN"],"WindowsForms10.Window.8.app")){



if (controlId:=controls[k+3,"hwnd"])



return prvHwnd:=controlId



}



if getprv



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



loop,Files,% RegExReplace(dir, "\\$", "") "\" f,FR



arr.push(A_LoopFileLongPath)



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



parseDataGrid2(listHwnd="", RisHwnd="",ByRef childrenAcc="", wait=false, useCurrentClipboard=false, unselectAll=true, selectAll=true, grabTitle=false, preserveClipboard=false, useCtrlA=false){



if (!useCurrentClipboard){



if !listHwnd



listHwnd:=getRisList(RisHwnd)



if (childrenAcc!=""){



if childrenAcc is Integer



{



if childrenAcc<4



return []



}else if IsObject(childrenAcc) && !childrenAcc.length()>0



return []



}



#ClipboardTimeout 2000



if preserveClipboard



clipboardOld:=ClipboardAll



clipboard:=""



loop 3 {



if (selectAll){



if(!useCtrlA && childrenAcc && winvisible(risHwnd))



selectAllRisList(childrenAcc)



else{



BlockInput,on



ControlFocus,,ahk_id %listHwnd%



controlsend,,^a,ahk_id %listHwnd%



BlockInput,off



}



Sleep % 500*(A_Index)



}



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



ShowToolTip(A_ScriptName ": Copy failed!",2000)



return -1



}



data:=Clipboard



if !preserveClipboard



clipboard:=clipboardOld



}else{



data:=clipboard



}



if(grabTitle){



title:=""



if (!childrenAcc){



if !listHwnd



listHwnd:=getRisList(RisHwnd)



titleRow:=Acc_Children_first(acc_ObjectFromWindow(listHwnd))[1]



}else{



titleRow:=childrenAcc[1]



}



for k,v in acc_children(titleRow)



title.=v.accValue "`t"



data:=SubStr(title,1,-1) "`n" data



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



,this.data:=data



for k,v in this.titles



if (v!="")



this.colNos[v]:=k



this.colNos["AccNo"]:=this.colNos["照會單號"]



,this.colNos["ChartNo"]:=this.colNos["病歷號"]



,this.colNos["ExamName"]:=this.colNos["檢查名稱"]



,this.colNos["Status"]:=this.colNos["狀態"]



,this.colNos["ExamDate"]:=this.colNos["檢查日"]



,this.colNos["ReportVS"]:=this.colNos["報告醫師"]



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



,this.data:=data



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



if (DllCall("GetWindowLong",Ptr,hwnd,Int,-20)=0x10008){



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



getRisHistory(hwnd, getprv=true){



static prvHwnd



for k,v in getcontrols(hwnd) {



if (getControlNameByHwnd(hwnd,v.hwnd)="dgHisReport") {



return prvHwnd:=v.hwnd



}



}



if getprv



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



impaxSelectImage(im, SeriesNoOrFrameCoord="", MouseMoveCoord="", whichScreen="", impaxHwnd="", nextKey="{Right}", prvKey="{Left}", current=false, timeOut=10){



CoordMode,mouse,screen



static SEIMReg:="i)DICOM S: (\d+) +I: (\d+)", clientImNoReg:="i)S: (\d+)\/\d+ +I: (\d+)\/(\d+)"



static lastFoundFrameHwnd



startImpaxSelectImage:=A_TickCount



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



if ((A_TickCount-startImpaxSelectImage)>1000*timeOut){



tried:=999



break



}



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



risOpenOldStudy(risHwnd, open=true, chooseRecent=false){



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



,afterStudy:="", priorStudy:=""



,afterStudyDate:="", priorStudyDate:=""



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



afterStudy:=v, afterStudyDate:=priorDate



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



priorStudy:=v, priorStudyDate:=priorDate



break



}



}



if(priorStudy || afterStudy){



if(priorStudy && !afterStudy)



v:=priorStudy



else if !priorStudy {



v:=afterStudy



}else if chooseRecent {



v:=DateDiff(RegExReplace(priorStudyDate,"\W",""),SubStr(RegExReplace(examDate,"\W",""),1,8))<DateDiff(RegExReplace(afterStudyDate,"\W",""),SubStr(RegExReplace(examDate,"\W",""),1,8)) ? priorStudy : afterStudy



}



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



h:=acc_windowfromobject(RisListAccChildren[1])



ControlFocus,% "ahk_id " h



ControlClick,x1 y1,% "ahk_id " h



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



return ClickRisList(index, RisListAcc, RisListAccChildren, risHwnd, activateRis, "dbclick")



}



RClickRisList(index, RisListAcc="", RisListAccChildren="", risHwnd="", activateRis=true){



return ClickRisList(index, RisListAcc, RisListAccChildren, risHwnd, activateRis, "rclick")



}



ClickRisList(index, RisListAcc="", RisListAccChildren="", risHwnd="", activateRis=true, action="click"){



global RisState



if !WinExist("ahk_id " risHwnd)



risHwnd:=(RisState:=risOpened())[2]



if(RisListAcc=""){



RisListAcc:=acc_ObjectFromWindow(RisListHwnd:=getRisList(risHwnd))



}else if !IsObject(RisListAcc) {



RisListHwnd:=RisListAcc



,RisListAcc:=acc_ObjectFromWindow(RisListAcc)



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



winset,Transparent,1,% "ahk_id " RisHwnd



state:="non_active"



}else{



winset,Transparent,1,% "ahk_id " RisHwnd



WinShow,% "ahk_id " RisHwnd



state:="hidden"



}



winactivate,% "ahk_id " RisHwnd



WinWaitActive,% "ahk_id " RisHwnd,,3



ControlFocus,,% "ahk_id " RisListHwnd



if(action="dbclick")



mouseclick,l,% pos.x+1,% pos.y+1,2,0



else if(action="rclick")



mouseclick,r,% pos.x+1,% pos.y+1,1,0



else



mouseclick,l,% pos.x+1,% pos.y+1,1,0



if(state="non_active"){



winset,Transparent,255,% "ahk_id " RisHwnd



}else if(state="hidden"){



winset,Transparent,255,% "ahk_id " RisHwnd



WinHide,% "ahk_id " RisHwnd



}



winactivate,% "ahk_id " activeWin



}



selectRisListItem(index="", AccNo="", chartNo="", ByRef ReportList="", RisListAccChildren="", ByRef RisState="",MultiSelect=false){



if (RisState="")



RisState:=risOpened()



if (RisListAccChildren="")



RisListHwnd:=getRisList(RisState[2])



,RisListAcc:=acc_ObjectFromWindow(RisListHwnd)



,RisListAccChildren:=acc_children(RisListAcc)



else if(RisListAccChildren.length()="")



RisListHwnd:=acc_windowfromobject(RisListAccChildren)



,RisListACC:=RisListAccChildren



,RisListAccChildren:=acc_children(RisListAcc)



if (!index && AccNo="" && chartNo ="")



index:=1



if (AccNo chartNo = ""){



if IsObject(index){



RisListAccChildren[2].accSelect(ComObj(3,16),0)



for k,v in index



selectRisListItem(v, "", "", doubleClick, ReportList, RisListAcc, true)



}else{



item:=RisListAccChildren[index+1]



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



RisListAccChildren[2].accSelect(ComObj(3,16),0)



for k,v in AccNo



selectRisListItem("", v, "", doubleClick, ReportList, RisListAcc, true)



}else{



for k,v in ReportList



if (v[AccNoCol]=AccNo){



item:=RisListAccChildren[k]



if !IsObject(item)



return -1



item.accSelect(MultiSelect?ComObj(3,8):ComObj(3,3),0)



break



}



}



}else{



if IsObject(ChartNo){



RisListAccChildren[2].accSelect(ComObj(3,16),0)



for k,v in ChartNo



selectRisListItem("", v, "", doubleClick, ReportList, RisListAcc, true)



}else{



for k,v in ReportList



if (v[ChartNoCol]=ChartNo){



item:=RisListAccChildren[k]



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



if WinActive("ahk_id " risHwnd){



mousegetpos,,,win



if (win=risHwnd)



{



mousemove,1,0,0,R



mousemove,-1,0,0,R



return



}



}



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



mon:=monitorInfo()



,mask:=[]



,mask.l:=mon[2].l



,mask.t:=mon[2].t



,mask.r:=mon[mon.length()].r



,mask.b:=mon[2].b



,mask.w:=mask.r-mask.l+1



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



getRisSearchDate(risHwnd="", type=0){



if !WinExist("ahk_id " risHwnd)



risHwnd:=risOpened()[2]



d:=getNetAcc(risHwnd,"FID_LABEL","STATIC",-1,1,type?"結束日期":"起始日期").accName



if(d!=""){



if RegExMatch(d, "(\d{4})\/(\d\d?)\/(\d\d?)", m)



return m1 SubStr("0" m2,-2) SubStr("0" m3,-2)



else if RegExMatch(d, "(\d\d?)\/(\d\d?)\/(\d{4})", m)



return m3 SubStr("0" m1,-2) SubStr("0" m2,-2)



}



}



getRisSearchStartDate(risHwnd=""){



return getRisSearchDate(risHwnd, 0)



}



getRisSearchEndDate(risHwnd=""){



return getRisSearchDate(risHwnd, 1)



}



setRisSearchStartDate(date, risHwnd=""){



return setRisSearchDate(date, risHwnd, 0)



}



setRisSearchEndDate(date, risHwnd=""){



return setRisSearchDate(date, risHwnd, 1)



}



setRisSearchDate(date, risHwnd="", type=0){



if !WinExist("ahk_id " risHwnd)



risHwnd:=risOpened()[2]



acc:=getNetAcc(risHwnd,"FID_LABEL","STATIC",-1,1,type?"結束日期":"起始日期")



,controlHwnd:=acc_windowfromobject(acc)



,date:=RegExReplace(date, "\D", ""),yr:=SubStr(date,1,4),mn:=SubStr(date,5,2),dy:=SubStr(date,7,2)



,oldDate:=acc.accName



if(oldDate="")



return



else if RegExMatch(oldDate, "(\d{4})\/(\d\d?)\/(\d\d?)", m)



NormalDateFormat:=true



if (NormalDateFormat)



setDate:=yr "/" mn "/" dy



else



setDate:= mn "/" dy "/" yr



setDate_:=RegExReplace(setDate, "^0|(?<=\/)0", "")



loop 4 {



ControlFocus,,ahk_id %controlHwnd%



controlsend,,% setDate,ahk_id %controlHwnd%



if (setDate_==acc.accName)



break



else



controlsend,,% "{right}{right}",ahk_id %controlHwnd%



}



}



setRisSearchFields(RisState, query_dict, search=true){



static examTypes:=["All","Plain","Special","CT","MR"]



, examStatus:=["All","NotReport","Recorded","Save","NotSend","Sent","Unassigned","NotVerify"]



, hospital:=["All", "CC", "T0", "T2", "T3", "T4", "T5", "Y0"]



, hospital2:=["All", "CC", "T", "N", "J", "H", "C", "Y"]



, examFrom:=["All", "E", "HMC", "I", "O"]



if (!query_dict.SetCapacity(0))



return



if query_dict.haskey("QuickButton"){



return RisQuickButton(RisState, query_dict["QuickButton"])



}



risHwnd:=IsObject(RisState)?RisState[2]:RisState



,controls:=GetControls(risHwnd)



for x,y in query_dict {



if(x="ChartNo"){



for k,v in controls



if (instr(v.text,"病歷號") && instr(v.classNN,"WindowsForms10.STATIC") && !instr(controls[k-3].text,"照會單號")){



thisHwnd:=controls[k+1].hwnd



controlfocus,,% "ahk_id " thisHwnd



controlsettext,,% y,% "ahk_id " thisHwnd



break



}



}else if (x="ExamType"){



if (modalityHwnd:=getNetControl2(RisState[2],"檢查類別","FID_LABEL","檢查類別","WindowsForms10.STATIC.app","","","",1)[1]) {



control,choose,% (y:=HasVal(examTypes, y))?y:1,,% "ahk_id " modalityHwnd



}



}else if (x="ExamStatus"){



if (modalityHwnd:=getNetControl2(RisState[2],"狀態","FID_LABEL","狀態","WindowsForms10.STATIC.app","","","",1)[1]) {



control,choose,% (y:=HasVal(examStatus, y))?y:1,,% "ahk_id " modalityHwnd



}



}else if (x="Hospital"){



if (modalityHwnd:=getNetControl2(RisState[2],"檢查地","FID_LABEL","檢查地","WindowsForms10.STATIC.app","","","",1)[1]) {



control,choose,% (y:=HasVal(hospital, y))?y:(y:=HasVal(hospital, query_dict["Hospital"]))?y:1,,% "ahk_id " modalityHwnd



}



}else if (x="VS"){



if (y="YCHH")



y:="陳醫師HC"



if (reportDrHwnd:=getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]) {



control,choosestring,% (y:=trim(y))=""?"所有報告醫師":y " ",,% "ahk_id " reportDrHwnd



}



}else if (x="ExamFrom"){



if (modalityHwnd:=getNetControl2(RisState[2],"診別","FID_LABEL","診別","WindowsForms10.STATIC.app","","","",1)[1]) {



control,choose,% (y:=HasVal(examFrom, y))?y:1,,% "ahk_id " modalityHwnd



}



}else if(x="StartDate"){



setRisSearchStartDate(y, risHwnd)



}else if(x="EndDate"){



setRisSearchEndDate(y, risHwnd)



}



}



if(search){



controlclick,,% "ahk_id " getNetControl2(risHwnd,"","cmdSearch","","WindowsForms10.BUTTON.app","","","",0)[1]



}



}



RisQuickButton(RisState, which){



static RisButtons:={ERCT: "cmdER_CT"



, ER: "cmdER"



, CT: "cmdCT"



, MR: "cmdMR"



, Special: "cmdSC"



, XR: "cmdXR"



, plain: "cmdXR"



, notReport: "cmdNOT_REPORT"



, notSend: "cmdNOT_SEND"



, save: "cmdSAVE"



, notVerify: "cmdNOT_VERIFY"}



if (which="")



return



risHwnd:=IsObject(RisState)?RisState[2]:RisState



if RisButtons.haskey(which) && (acc:=getNetAcc(risHwnd,RisButtons[which],"WindowsForms10.BUTTON.app"))



acc.accDoDefaultAction()



}



RisOpenMoreDialog(){



if h:=winexist("ahk_class #32770", "已有程式執行中,是否確定重複開啟程式")



controlclick,Button1,ahk_id %h%



}



StopRisLogin(){



settimer,RisOpenMoreDialog,off



}



checkNewRisLogin(oldRis, logincallback, initTick=""){



if(initTick!="" && A_TickCount-initTick>120000)



return logincallback.call(0)



for k,v in risOpened(1)[2]



if !HasVal(oldRis, v){



if !IsObject(logincallback)



logincallback:=func(logincallback)



return logincallback.call(v)



}



SetTimerFn("checkNewRisLogin", -1000, [oldRis, logincallback, initTick])



}



RisLogin(RisId="", RisPw="", logincallback="", RisPath="", state=0, initTick=""){



if (initTick!="" && A_TickCount-initTick>120000){



settimer,StopRisLogin,-1



return



}else if(initTick="")



initTick:=A_TickCount



if (state=0){



settimer,StopRisLogin,-60000



if !risOpened(1)[1].length() {



if !FileExist(RisPath) && !(RisPath:=GetRisPath(1)[1])



RisPath:=GetRisPath()



settimer,RisOpenMoreDialog,100



try {



SplitPath,RisPath,,wdir



run,% RisPath,% wdir



SetTimerFn("RisLogin", -500, [RisId, RisPw, logincallback, RisPath, 1, initTick])



}catch



settimer,StopRisLogin,-1



}else{



RisLogin(RisId, RisPw, logincallback, RisPath, 2, initTick)



}



}else if(state=1){



if !risOpened(1)[1].length() {



SetTimerFn("RisLogin", -500, [RisId, RisPw,logincallback, RisPath, 1, initTick])



}else{



RisLogin(RisId, RisPw, logincallback, RisPath, 2, initTick)



}



}else if(state=2){



settimer,RisOpenMoreDialog,off



risHwnd:=risOpened(1)[1,1]



,RisIdHwnd:=getNetAcc(risHwnd, "USER_ID", "WindowsForms10.EDIT",0,0)



,RisPwHwnd:=getNetAcc(risHwnd, "PASSWORD", "WindowsForms10.EDIT",0,0)



,usernameHwnd:=getNetAcc(risHwnd, "USER_NAME", "WindowsForms10.EDIT",0,0)



,oldRis:=risOpened(1)[2]



WinShow,ahk_id %risHwnd%



winactivate,ahk_id %risHwnd%



WinWaitActive,ahk_id %risHwnd%,,2



ControlFocus,,ahk_id %RisIdHwnd%



controlsend,,{Home}+{End},ahk_id %RisIdHwnd%



ControlSendRaw,,% risid,ahk_id %RisIdHwnd%



ControlSend,,{tab},ahk_id %RisIdHwnd%



loop {



Sleep 100



}until ControlGetText(usernameHwnd) || (A_Index>30)



winactivate,ahk_id %risHwnd%



WinWaitActive,ahk_id %risHwnd%,,2



ControlFocus,,ahk_id %RisPwHwnd%



ControlSendRaw,,% RisPw,ahk_id %RisPwHwnd%



ControlSend,,{Enter},ahk_id %RisPwHwnd%



SetTimerFn("checkNewRisLogin", 1000, [oldRis, logincallback, initTick])



}



}



risGoToStudyCall(ChartNo, AccNo, ReportList="", RisSearchFields="", RisListAccChildren="", RisReports="", RisState="", loginHospital="", RisImpaxLoginInfo="", hwnd=0){



risGoToStudy(ChartNo, AccNo, ReportList,RisSearchFields, RisListAccChildren, RisReports, hwnd, loginHospital,RisImpaxLoginInfo, 2.5)



}



risGoToStudy(ChartNo, AccNo, ReportList="",RisSearchFields="", RisListAccChildren="", RisReports="", RisState="", loginHospital="", RisImpaxLoginInfo="", state=0){



if(state=0){



risHwnd:=IsObject(RisState)?RisState[2]:RisState



if !WinExist("ahk_id " risHwnd){



return risGoToStudy(ChartNo, AccNo, ReportList,RisSearchFields, RisListAccChildren, RisReports, RisState, loginHospital,RisImpaxLoginInfo, 1)



}else{



return risGoToStudy(ChartNo, AccNo, ReportList,RisSearchFields, RisListAccChildren, RisReports, risHwnd, loginHospital,RisImpaxLoginInfo, 2)



}



}else if(state=1){



h_idx:=(loginHospital~="T0|N總院")?1:(loginHospital~="T4|H分院")?2:(loginHospital~="Y0|Y分院")?3:(AccNo~="^(T[023]|TH)")?1:(AccNo~="^(T4|HH)")?2:(AccNo~="^(Y0|YH)")?3:(chartNo~="^(\d|N|J)")?1:(chartNo~="^(H)")?2:(chartNo~="^(Y)")?3:1



, RisId:=RisImpaxLoginInfo.ris[h_idx].user



, RisPw:=RisImpaxLoginInfo.ris[h_idx].pw



if(risid="" || rispw=""){



OutputDebug,No RIS ID/PW!



return -1



}



RisLogin(RisId, RisPw, Func("risGoToStudyCall").bind(ChartNo, AccNo, ReportList,RisSearchFields, RisListAccChildren, RisReports, RisState, loginHospital,RisImpaxLoginInfo))



}else if(state<3){



if WinExist("ahk_id " RisReports[1,1]) && (accNo=getRisAccNo(RisState)){



return 0



}else



return risGoToStudy(ChartNo, AccNo, ReportList,RisSearchFields, RisListAccChildren, RisReports, RisState, loginHospital,RisImpaxLoginInfo, state+1)



}else if(state<4){



if (state=3.5 && RisSearchFields!="" ){



Loop



Sleep 100



until (RisListHwnd:=getRisList(RisState)) || A_Index>200



ReportList:=""



,setRisSearchFields(RisState, RisSearchFields)



loop {



if(lastcount = (thiscount:=acc_ObjectFromWindow(RisListHwnd).accChildCount))



break



else



lastcount:=thisCount



Sleep 100



}until A_Index>200



}



if(ReportList=""){



RisListHwnd:=getRisList(RisState)



if(RisListAccChildren="")



RisListAccChildren:=acc_children(acc_ObjectFromWindow(RisListHwnd))



ReportList:=ParseDataGrid2(RisListHwnd, RisState, RisListAccChildren)



if(ReportList.data.length()<2){



OutputDebug,Empty Report List



return -1



}



}



currentRow:=ReportList.getRow("AccNo", thisAccNo:=getRisAccNo(RisState))



,nextRow:=ReportList.getRow("AccNo", nextAccNo:=AccNo)



if(!nextRow.rowNo){



OutputDebug,% "Can't find next AccNo: " AccNo



return -1



}



if(currentRow.rowNo && currentRow.rowNo=nextRow.rowNo-1){



risNextStudy(RisState)



return 0



}



if(RisListAccChildren="")



RisListAccChildren:=acc_children(acc_ObjectFromWindow(RisListHwnd))



doubleClickRisList(nextRow.rowNo-1, RisListHwnd, RisListAccChildren, RisState, false)



}



}



GetActiveBrowserURL() {



WinGetClass, sClass, A



If sClass In Chrome_WidgetWin_1,Chrome_WidgetWin_0,Maxthon3Cls_MainFrm



Return GetBrowserURL_ACC(sClass)



Else



Return GetBrowserURL_DDE(sClass)



}



GetBrowserURL_DDE(sClass, getControl=0) {



WinGet, sServer, ProcessName, % "ahk_class " sClass



StringTrimRight, sServer, sServer, 4



iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC



DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)



hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)



hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)



hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)



hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)



hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult)



sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")



DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)



DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)



DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)



DllCall("DdeUnaccessData", "UPtr", hData)



DllCall("DdeFreeDataHandle", "UPtr", hData)



DllCall("DdeDisconnect", "UPtr", hConv)



DllCall("DdeUninitialize", "UPtr", idInst)



csvWindowInfo := StrGet(&sData, "CP0")



StringSplit, sWindowInfo, csvWindowInfo, `"



Return sWindowInfo2



}



GetBrowserURL_ACC(sClass, getControl=0) {



global nWindow, accAddressBar



If (nWindow != WinExist("ahk_class " sClass))



{



nWindow := WinExist("ahk_class " sClass)



accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))



}



Try sURL := accAddressBar.accValue(0)



urlControl:=accAddressBar



If (sURL == "") {



sURL := accAddressBar.accDescription(0)



If (sURL == "") {



WinGet, nWindows, List, % "ahk_class " sClass



If (nWindows > 1) {



accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindows2))



urlControl:=accAddressBar



sURL := accAddressBar.accValue(0)



}



}



}



If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) and (SubStr(sURL,1,4)!="file")



sURL := "http://" sURL



if(getControl)



return urlControl



else



Return sURL



}



GetAddressBar(accObj) {



Try If ((accObj.accName(0) != "") and IsURL(accObj.accValue(0)))



Return accObj



Try If ((accObj.accName(0) != "") and IsURL("http://" accObj.accValue(0)))



Return accObj



Try If (InStr(accObj.accDescription(0), accObj.accName(0)) and IsURL(accObj.accDescription(0)))



Return accObj



For nChild, accChild in Acc_Children(accObj)



If IsObject(accAddressBar := GetAddressBar(accChild))



Return accAddressBar



}



IsURL(sURL) {



Return RegExMatch(sURL, "^(?<Protocol>https?|ftp)://(?:(?<Username>[^:]+)(?::(?<Password>[^@]+))?@)?(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$") || RegExMatch(sURL, "is)^file\:\/\/\/(.+)$")



}



class NotifyCross {



__New(Color="red"){



CoordMode,mouse,Screen



this.guiHwnds:=[]



loop 4 {



gui,__notify%a_index%: -Caption +ToolWindow +AlwaysOnTOp +lastfound +hwndguihwnd



this.guiHwnds.push(guihwnd)



gui,__notify%a_index%:  Color, % color



}



this.hideFn:=this.hide.bind(this)



}



Show(CenterX, CenterY, CenterSpace=100, length=0, width=5, hideAfter=1000){



MonitorInfo:=MonitorInfo()



,which:=whichMonitor(CenterX, CenterY, MonitorInfo)[1]



,thisMonitor:=MonitorInfo[which]



,halfWidth:=Floor(width/2)



,x:=[CenterX-halfWidth, CenterX+CenterSpace, CenterX-halfWidth, length=0?thisMonitor.l:CenterX-CenterSpace-length]



,y:=[length=0?thisMonitor.t:centerY-CenterSpace-length, CenterY-halfWidth, CenterY+CenterSpace, CenterY-halfWidth]



,a:=[x[1]+width-1, length=0?thisMonitor.r:x[2]+length-1, x[3]+width-1, CenterX-CenterSpace]



,b:=[CenterY-CenterSpace, y[2]+width-1, length=0?thisMonitor.b:y[3]+length-1, y[2]+width-1]



Loop 4 {



id:=this.guiHwnds[i:=A_Index]



gui,%id%:Show,% "x" x[i] " y" y[i] " w" a[i]-x[i]+1 " h" b[i]-y[i]+1 " NoActivate"



}



if (hideAfter>0){



fn:=this.hideFn



SetTimer,% fn,% (-1)*hideAfter



}



}



hide(){



Loop 4 {



id:=this.guiHwnds[i:=A_Index]



gui,%id%:hide



}



}



__Delete(){



for k,v in this.guiHwnds



WinClose,ahk_id %v%



}



}



class Socket



{



static WM_SOCKET := 0x9987, MSG_PEEK := 2



static FD_READ := 1, FD_ACCEPT := 8, FD_CLOSE := 32



static Blocking := True, BlockSleep := 50



__New(Socket:=-1)



{



static Init



if (!Init)



{



DllCall("LoadLibrary", "Str", "Ws2_32", "Ptr")



VarSetCapacity(WSAData, 394+A_PtrSize)



if (Error := DllCall("Ws2_32\WSAStartup", "UShort", 0x0202, "Ptr", &WSAData))



throw Exception("Error starting Winsock",, Error)



if (NumGet(WSAData, 2, "UShort") != 0x0202)



throw Exception("Winsock version 2.2 not available")



Init := True



}



this.Socket := Socket



}



__Delete()



{



if (this.Socket != -1)



this.Disconnect()



}



Connect(Address, Port="")



{



if (this.Socket != -1)



throw Exception("Socket already connected")



Next := pAddrInfo := this.GetAddrInfo(Address, Port)



while Next



{



ai_addrlen := NumGet(Next+0, 16, "UPtr")



ai_addr := NumGet(Next+0, 16+(2*A_PtrSize), "Ptr")



if ((this.Socket := DllCall("Ws2_32\socket", "Int", NumGet(Next+0, 4, "Int")



, "Int", this.SocketType, "Int", this.ProtocolId, "UInt")) != -1)



{



if (DllCall("Ws2_32\WSAConnect", "UInt", this.Socket, "Ptr", ai_addr



, "UInt", ai_addrlen, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Int") == 0)



{



DllCall("Ws2_32\freeaddrinfo", "Ptr", pAddrInfo)



return this.EventProcRegister(this.FD_READ | this.FD_CLOSE)



}



this.Disconnect()



}



Next := NumGet(Next+0, 16+(3*A_PtrSize), "Ptr")



}



throw Exception("Error connecting")



}



Bind(Address, Port="")



{



if (this.Socket != -1)



throw Exception("Socket already connected")



Next := pAddrInfo := this.GetAddrInfo(Address, Port)



while Next



{



ai_addrlen := NumGet(Next+0, 16, "UPtr")



ai_addr := NumGet(Next+0, 16+(2*A_PtrSize), "Ptr")



if ((this.Socket := DllCall("Ws2_32\socket", "Int", NumGet(Next+0, 4, "Int")



, "Int", this.SocketType, "Int", this.ProtocolId, "UInt")) != -1)



{



if (DllCall("Ws2_32\bind", "UInt", this.Socket, "Ptr", ai_addr



, "UInt", ai_addrlen, "Int") == 0)



{



DllCall("Ws2_32\freeaddrinfo", "Ptr", pAddrInfo)



return this.EventProcRegister(this.FD_READ | this.FD_ACCEPT | this.FD_CLOSE)



}



this.Disconnect()



}



Next := NumGet(Next+0, 16+(3*A_PtrSize), "Ptr")



}



throw Exception("Error binding")



}



Listen(backlog=32)



{



return DllCall("Ws2_32\listen", "UInt", this.Socket, "Int", backlog) == 0



}



Accept()



{



if ((s := DllCall("Ws2_32\accept", "UInt", this.Socket, "Ptr", 0, "Ptr", 0, "Ptr")) == -1)



throw Exception("Error calling accept",, this.GetLastError())



Sock := new Socket(s)



Sock.ProtocolId := this.ProtocolId



Sock.SocketType := this.SocketType



Sock.EventProcRegister(this.FD_READ | this.FD_CLOSE)



return Sock



}



Disconnect()



{



if (this.Socket == -1)



return 0



this.EventProcUnregister()



if (DllCall("Ws2_32\closesocket", "UInt", this.Socket, "Int") == -1)



throw Exception("Error closing socket",, this.GetLastError())



this.Socket := -1



return 1



}



MsgSize()



{



static FIONREAD := 0x4004667F



if (DllCall("Ws2_32\ioctlsocket", "UInt", this.Socket, "UInt", FIONREAD, "UInt*", argp) == -1)



throw Exception("Error calling ioctlsocket",, this.GetLastError())



return argp



}



Send(pBuffer, BufSize, Flags:=0)



{



if ((r := DllCall("Ws2_32\send", "UInt", this.Socket, "Ptr", pBuffer, "Int", BufSize, "Int", Flags)) == -1)



throw Exception("Error calling send",, this.GetLastError())



return r



}



SendText(Text, Flags:=0, Encoding:="UTF-8")



{



VarSetCapacity(Buffer, StrPut(Text, Encoding) * ((Encoding="UTF-16"||Encoding="cp1200") ? 2 : 1))



Length := StrPut(Text, &Buffer, Encoding)



return this.Send(&Buffer, Length - 1)



}



Recv(ByRef Buffer, BufSize:=0, Flags:=0)



{



while (!(Length := this.MsgSize()) && this.Blocking)



Sleep, this.BlockSleep



if !Length



return 0



if !BufSize



BufSize := Length



VarSetCapacity(Buffer, BufSize)



if ((r := DllCall("Ws2_32\recv", "UInt", this.Socket, "Ptr", &Buffer, "Int", BufSize, "Int", Flags)) == -1)



throw Exception("Error calling recv",, this.GetLastError())



return r



}



RecvText(BufSize:=0, Flags:=0, Encoding:="UTF-8")



{



if (Length := this.Recv(Buffer, BufSize, flags))



return StrGet(&Buffer, Length, Encoding)



return ""



}



RecvLine(BufSize:=0, Flags:=0, Encoding:="UTF-8", KeepEnd:=False)



{



while !(i := InStr(this.RecvText(BufSize, Flags|this.MSG_PEEK, Encoding), "`n"))



{



if !this.Blocking



return ""



Sleep, this.BlockSleep



}



if KeepEnd



return this.RecvText(i, Flags, Encoding)



else



return RTrim(this.RecvText(i, Flags, Encoding), "`r`n")



}



GetAddrInfo(Address, Port="")



{



static a := ["127.0.0.1", "0.0.0.0", "255.255.255.255", "::1", "::", "FF00::"]



static conv := {localhost:a[1], addr_loopback:a[1], inaddr_loopback:a[1], addr_any:a[2], inaddr_any:a[2], addr_broadcast:a[3]



, inaddr_broadcast:a[3], addr_none:a[3], inaddr_none:a[3], localhost6:a[4], addr_loopback6:a[4], inaddr_loopback6:a[4]



, addr_any6:a[5], inaddr_any:a[5], addr_broadcast6:a[6], inaddr_broadcast6:a[6], addr_none6:a[6], inaddr_none6:a[6]}



if(IsObject(Address))



Host := Address[1], Port := Address[2]



else



Host:=Address, Port:=Port



if (conv[host])



host := conv[host]



VarSetCapacity(Hints, 16+(4*A_PtrSize), 0)



NumPut(this.SocketType, Hints, 8, "Int")



NumPut(this.ProtocolId, Hints, 12, "Int")



if (Error := DllCall("Ws2_32\getaddrinfo", "AStr", Host, "AStr", Port, "Ptr", &Hints, "Ptr*", Result))



throw Exception("Error calling GetAddrInfo",, Error)



return Result



}



OnMessage(wParam, lParam, Msg, hWnd)



{



Critical



if (Msg != this.WM_SOCKET || wParam != this.Socket)



return



if (lParam & this.FD_READ)



this.onRecv()



else if (lParam & this.FD_ACCEPT)



this.onAccept()



else if (lParam & this.FD_CLOSE)



this.Disconnect(), this.OnDisconnect()



}



EventProcRegister(lEvent)



{



this.AsyncSelect(lEvent)



if !this.Bound



{



this.Bound := this.OnMessage.Bind(this)



OnMessage(this.WM_SOCKET, this.Bound)



}



}



EventProcUnregister()



{



this.AsyncSelect(0)



if this.Bound



{



OnMessage(this.WM_SOCKET, this.Bound, 0)



this.Bound := False



}



}



AsyncSelect(lEvent)



{



if (DllCall("Ws2_32\WSAAsyncSelect"



, "UInt", this.Socket



, "Ptr", A_ScriptHwnd



, "UInt", this.WM_SOCKET



, "UInt", lEvent) == -1)



throw Exception("Error calling WSAAsyncSelect",, this.GetLastError())



}



GetLastError()



{



return DllCall("Ws2_32\WSAGetLastError")



}



}



class SocketTCP extends Socket



{



static ProtocolId := 6



static SocketType := 1



}



class SocketUDP extends Socket



{



static ProtocolId := 17



static SocketType := 2



SetBroadcast(Enable)



{



static SOL_SOCKET := 0xFFFF, SO_BROADCAST := 0x20



if (DllCall("Ws2_32\setsockopt"



, "UInt", this.Socket



, "Int", SOL_SOCKET



, "Int", SO_BROADCAST



, "UInt*", !!Enable



, "Int", 4) == -1)



throw Exception("Error calling setsockopt",, this.GetLastError())



}



}



ComObjError(false)



OnExit,OnExit



setbatchlines,-1



SendLevel,1



CoordMode,mouse,Screen



DetectHiddenWindows,on



SetTitleMatchMode,2



#SingleInstance,force



#InstallKeybdHook



#InstallMouseHook



try



Menu, Tray, Icon,% A_ScriptDir "\showLungCAD.ico"



gosub sethotkey



if !CaptureTextPath()



NoCaptureText:=true



if !WinExist("WM_COPYDATA_Listener_RegionGrowMorph") && OpenRegionGrow



try {



run % a_scriptdir "\RegionGrowMorph.exe"



winwait,ahk_class ConsoleWindowClass ahk_exe RegionGrowMorph.exe,,30



}



feedbackPort:=10007



,pwbs:=[]



,monitorInfo:=monitorInfo()



,OnMessage(0x4A, "On_WM_COPYDATA")



gui,+hwndguihwnd



WinSetTitle,ahk_id %guihwnd%,,showLungCAD_main



OnMessage(0x2001, "next")



,OnMessage(0x2002, "prior")



,OnMessage(0x8100, "search")



,cross:=new NotifyCross("white")



,clearReadUrl:="http://10.0.0.100:9104/?accession="



return



errorHandle:



ifwinexist,ahk_class #32770,hotkeys have been received in the last



ControlClick,Button1,ahk_class #32770,hotkeys have been received in the last



return



grabCorner:



info:=getImpaxFrameInfo(cornerHwnd, corner)



,info.CornerInfo:=1



,Send_WM_COPYDATA(mainHwnd, 19, jxon_dump(info))



return



On_WM_COPYDATA(wParam, lParam, msg, hwnd) {



dwData := NumGet(lParam+0, 0)



,cbData := NumGet(lParam + A_PtrSize)



,lpData := NumGet(lParam + 2*A_PtrSize)



,str := StrGet(lpData)



If  (dwData = 19)



{



try



j:=JXON_load(str)



catch



return



SetTimerF("ParseInfo", -1, [j])



}



}



ParseInfo(j, tried=0){



global monitorInfo, info, which, frames, NoCaptureText



if (j.area=0)



return



if (!NoCaptureText && !info.FOV){



if (tried<3){



ToolTip % "Waiting for OCR..."



SetTimerF("ParseInfo", -500, [j, tried+1])



}



return



}



ToolTip



if NoCaptureText && !info.FOV && !info.StudyDescription && !info.thickness && !info.WL && !info.WW && !info.z



MsgBox,,,% "Please make IMPAX show corner informations!",5



settimer,ReportGUI,-1



SetTimerF("setReportGUI", -500, [info, j, frames[which.1-1,1,1]])



}



noduleLine(){



global reporthwnd



GuiControlGet,d1,%reportHwnd%:,rMinD



GuiControlGet,d2,%reportHwnd%:,rMaxD



GuiControlGet,lobe,%reportHwnd%:,selectLobe



GuiControlGet,SE,%reportHwnd%:,rSE



GuiControlGet,IM,%reportHwnd%:,rIM



str:="A "



, str.=d1=""||d2=""?d1 d2 "mm":(d2>=6||(d1=d2)?d2 "mm":d1 "*" d2 "mm (mean " Round(d1/2+d2/2) " mm)")



, str.=" nodule in the " (lobe?lobe:"[lobe]") ". " (SE&&IM? "(SE" SE " IM" IM ")":"")



,setReportGUIControl("rText", str)



return str



}



setReportGUI(info, json, frameHwnd){



global reporthwnd, ratio_coord_x, ratio_coord_y, rStudyDate, rAccNo, rChartNo



WinGetPos,x,y,w,h,% "ahk_id " frameHwnd



ratio_coord_x:=h>w?(json.Center_X - x)/w:  (json.Center_X - (x+w/2-h/2))/w



,ratio_coord_y:=w>h?(json.Center_Y-y)/h: (json.Center_Y-(y+h/2-w/2))/w



MouseMove,% x,% y,0



MouseMove,1,1,2,R



SEIM:=getSEIM()



MouseMove,% json.Center_X,% json.Center_Y,0



setReportGUIControl("rMinDp", json.min_diameter)



,setReportGUIControl("rMaxDp", json.max_diameter)



,setReportGUIControl("rSE", SEIM.1)



,setReportGUIControl("rIM", SEIM.2)



,setReportGUIControl("rLoc", info.Z)



if (info.FOV>0){



setReportGUIControl("rMinD", d1:=Round(json.min_diameter/w*info.FOV))



,setReportGUIControl("rMaxD", d2:=Round(json.max_diameter/w*info.FOV))



,str:=noduleLine()



}



impaxHwnd:=ImpaxOpened()[2,1]



,rStudyDate:=getImpaxExamDate(impaxHwnd)[1]



,rAccNo:=getImpaxAccNo(impaxHwnd)



,rChartNo:=getImpaxChartNo(impaxHwnd)



guicontrol,%reporthwnd%:Move,rFP,w0 h0 x-1 y-1



gui,%reporthwnd%:show,% "x" json.Center_X-30 " y" json.Center_Y+100 " noactivate",Nodule info #New



settimer,HideGUIifInactive,-5000



}



setReportGUIControl(var, value){



global reporthwnd



guicontrol,%reporthwnd%:,% var,% value



}



DisplayNoduleInfo(noduleInd, isSameSeries){



global reporthwnd, jsonData, rNoduleInd, coord, noduleListHwnd, ShowNoduleList, lastX, lastY, thisInd, EBMmode, ebm_show_x, ebm_show_y, noduleButtonText



gosub ReportGUI



thisInd:=noduleInd



,nodule:=jsonData.Nodules[rNoduleInd:=noduleInd-1]



if (isSameSeries){



setReportGUIControl("rSE", jsonData.SeriesNumber)



,setReportGUIControl("rIM", nodule.InstanceNumber)



}



setReportGUIControl("rMinD", Round(nodule.Diameter))



,setReportGUIControl("rLoc", Round(nodule.SliceLocation))



,noduleLine()



if (nodule.hasKey("MalignancyProbability")){



prb:=nodule.MalignancyProbability



f:=A_FormatFloat



SetFormat,FloatFast,0.2



prb+=0.0



SetFormat,FloatFast,% f



,setReportGUIControl("rMaligProb", prb)



,setReportGUIControl("rProb", prb>0.5?": > 0.5":": < 0.5")



}



guicontrol,%reporthwnd%:Move,rFN,w0 h0 x-1 y-1



guicontrol,%reporthwnd%:,rFNtext,% ""



if (ebm_show_x!="" && ebm_show_y!="")



gui,%reporthwnd%:show,% "x" ebm_show_x " y" ebm_show_y " noactivate",Nodule info #%noduleInd%



else



gui,%reporthwnd%:show,% "x"coord.1-30 " y" coord.2+100 " noactivate",Nodule info #%noduleInd%



for k,v in noduleButtonText {



guicontrol,%noduleListHwnd%:,noduleButton%k%,% v



}



guicontrol,%noduleListHwnd%:,noduleButton%thisInd%,% "[" thisInd "]"



width1:=80



if (ebm_show_x!="" && ebm_show_y!="")



gui,%noduleListHwnd%:show,% "x" ebm_show_x-80 " y" ebm_show_y " w" width1 " noactivate",List



else if ShowNoduleList && lastX && lastY



gui,%noduleListHwnd%:show,% "x" lastX " y" lastY " w" width1 " noactivate",List



else



gui,%noduleListHwnd%:show,% "x" coord.1-120 " y" coord.2+100 " w" width1 " noactivate",List



settimer,HideGUIifInactive,-5000



}



HideGUIifInactive:



MouseGetPos,,,win



if !WinActive("ahk_id " reporthwnd) && win!=reporthwnd



WinHide,% "ahk_id " reporthwnd



if !WinActive("ahk_id " noduleListHwnd) && win!=noduleListHwnd && !ShowNoduleList



WinHide,% "ahk_id " noduleListHwnd



return



#IfWinActive,Nodule info ahk_class AutoHotkeyGUI



~LButton::



MouseGetPos,,,,con,2



if (con!=TextHwnd)



return



gosub CopyText



return



#IfWinActive



ReportGUI:



gui,report:new,+hwndReportHwnd +ToolWindow +AlwaysOnTop



gui,Font,s10,Verdana



gui,Color,ececec



gui,Add,Text,,% "Size:"



gui,Add,Edit,xp+40 yp w40 vrMinD,



gui,Add,Text,xp+50 yp,×



gui,Add,Edit,xp+20 yp w40 vrMaxD,



gui,Add,Text,xp+50 yp,mm



gui,Add,Edit,xp+50 yp w40 vrMinDp,



gui,Add,Text,xp+50 yp vrMulp,×



gui,Add,Edit,xp+20 yp w40 vrMaxDp,



gui,Add,Text,xp+50 yp vrPixel,px



gui,Add,Text,xm,% "  "



gui,Add,Text,xp+20 yp,SE



gui,Add,Edit,xp+20 yp w40 vrSE



gui,Add,Text,xp+50 yp,IM



gui,Add,Edit,xp+20 yp w40 vrIM



gui,Add,ComboBox,xp+100 yp w150 gselectLobe vselectLobe,RUL|RML|RLL|LUL|LLL|lingular LUL



gui,Add,Text,xm,% "  "



gui,Add,Text,xp+20,Loc



gui,Add,Edit,vrLoc xp+40 w60



gui,Add,Text,xp+80,Malig Prob



gui,Add,Edit,xp+80 vrMaligProb w60



gui,Add,Text,xp+80 yp+5 vrProb,% "              "



gui,Add,Edit,xm r2 w400 vrText -VScroll hwndtextHwnd,



gui,Add,button,greportFP xm vrFP,Report FP



gui,Add,button,greportFN xp yp vrFN,Report FN



gui,Add,Text,x+10 yp+5 vrFNtext,: require at least SE/IM



gui,Add,button,gundo x250 y+20,Undo last feedback



if !thickSliceMode



gui,Add,button,gthickSliceMode xm,% "Thick slice mode"



else



gui,Add,button,gthinSliceMode xm,% "Thin slice mode"



return



thinSliceMode:



thickSliceMode:=0



gosub magicResult



return



thickSliceMode:



thickSliceMode:=1



gosub magicResult



return



Undo:



gosub HideGUI



impaxHwnd:=ImpaxOpened()[2,1]



,rAccNo:=getImpaxAccNo(impaxHwnd)



,rChartNo:=getImpaxChartNo(impaxHwnd)



feedback:={Undo: 1}



,feedback["AccessionNumber"]:=rAccNo



,feedback["PatientID"]:=rChartNo



,SetTimerF("MoveMsgbox", 100, ["Undo"])



MsgBox,4,Undo,% "Undo last feedback for " rChartNo "/" rAccNo " ?"



IfMsgBox,Yes



{



sendFeedback(feedback)



gosub HideGUI



}



return



MoveMsgbox(title){



if h:=WinExist(title " ahk_class #32770 ahk_exe showLungCAD.exe") {



MouseGetPos,x,y



WinMove,ahk_id %h%,,% x-100,% y-200



SetTimerF("MoveMsgbox", 0)



}



}



selectLobe:



gui,%reporthwnd%:Submit,NoHide



reportText:=noduleLine()



gosub CopyText1



return



CopyText:



gosub selectLobe



return



CopyText1:



if selectLobe=



return



clipboard:=noduleLine()



ToolTip % "Text copied !"



settimer,ToolTip,-2000



return



reportFP:



reportFN:



if EBMmode



return



gui,%reporthwnd%:Default



gui,Submit,NoHide



gosub selectLobe



if (A_ThisLabel="reportFN") && (rSE="" || rIM=""){



MsgBox,,, % "Please at least specify SE/IM to feedback!",5



return



}



feedback:={}



,feedback[A_ThisLabel]:=1



if InStr(A_ThisLabel, "FN"){



feedback["SE"]:=rSE



,feedback["IM"]:=rIM



,feedback["X-Ratio"]:=ratio_coord_x



,feedback["Y-Ratio"]:=ratio_coord_y



,feedback["SliceLocation"]:=info.z



,feedback["MinDiameter"]:=rMinD



,feedback["MaxDiameter"]:=rMaxD



,feedback["MinPixelDiameter"]:=rMinDp



,feedback["MaxPixelDiameter"]:=rMaxDp



,feedback["AccessionNumber"]:=rAccNo



,feedback["PatientID"]:=rChartNo



,RegExMatch(rStudyDate, "s)^(\d+)\W(\d+)\W(\d+).+", m)



,feedback["StudyDate"]:=m1 (StrLen(m2)=1?"0":"") m2 (StrLen(m3)=1?"0":"") m3



}else{



for k,v in jsonData



if !IsObject(v)



feedback["" k]:="" v



feedback["Nodules"]:={}



, nodule:=jsonData.Nodules[rNoduleInd]



,thisInd:=rNoduleInd+1



,feedback["Nodules", "" (nodule.hasKey("NoduleIndBeforeSort")?nodule.noduleIndBeforeSort:rNoduleInd)]:=nodule.clone()



}



sendFeedback(feedback)



gosub HideGUI



return



HideGUI:



try



gui,report:Hide



try {



if !ShowNoduleList



gui,noduleList:Hide



}



return



sendFeedback(feedback){



global myTCP, feedbackIp, feedbackPort



if !(myTCP:=new SocketTCP())



goto sendFeedbackFail



if myTCP.connect(feedbackIp, feedbackPort)



goto sendFeedbackFail



j:=jxon_dump(feedback)



,l:=StrLen(j), Encoding:="UTF-8"



,VarSetCapacity(Buffer, (Length:=StrPut(j, Encoding) * ((Encoding="UTF-16"||Encoding="cp1200") ? 2 : 1) )+4)



,Length-=1



,NumPut(Length, Buffer, 0, "UInt")



,Length := StrPut(j, &Buffer+4, Encoding)



,myTCP.send(&Buffer, Length+3)



ToolTip % "Feedback successfully!"



settimer,ToolTip,-3000



return



sendFeedbackFail:



MsgBox,,,% "Feedback fail, please contact YCH!",5



return



}



setSocket:



return



ToolTip:



ToolTip



return



getPwb(instance, position="", Visible=true){



global monitorInfo, pwbs



if (position=""){



mon:=monitorInfo[1]



,position:={x: mon.l, y: mon.t, w: Floor(mon.w*0.75), h: Floor(mon.h*0.75)}



}



if !WinExist("ahk_id " pwbs[instance].hwnd){



pwbs[instance]:=pwb:=ComObjCreate("InternetExplorer.Application")



,pwb.Visible:=Visible



WinMove,% "ahk_id " pwb.hwnd,,% position.x,% position.y,% position.w,% position.h



}



return pwbs[instance]



}



sethotkey:



iniPath:=A_ScriptDir "\showLungCAD.ini"



IniRead,secondKey,% iniPath,Hotkey,QueryMagic,#i



IniRead,priorKey,% iniPath,Hotkey,Prior,#PgUp



IniRead,nextKey,% iniPath,Hotkey,Next,#PGDN



IniRead,ShowInBrowser,% iniPath,Hotkey,ShowInBrowser,0



IniRead,ShowInImpax,% iniPath,Hotkey,ShowInImpax,1



IniRead,OpenRegionGrow,% iniPath,Hotkey,OpenRegionGrow,1



IniRead,EBMmode,% iniPath,Hotkey,EBMmode,0



IniRead,ShowNoduleList,% iniPath,Hotkey,ShowNoduleList,1



IniRead,ReportFPKey,% iniPath,Hotkey,reportFP,#p



IniRead,reportFNKey,% iniPath,Hotkey,reportFN,#n



IniRead,dismissKey,% iniPath,Hotkey,quickClose,% "F2,F3,Esc"



IniRead,threshold,% iniPath,Hotkey,threshold,0.5



IniRead,ShowClearRead,% iniPath,Hotkey,ShowClearRead,0



GroupAdd,RisOrImpax,ahk_exe impax-client-main.exe



GroupAdd,RisOrImpax,ahk_exe Menu.exe



GroupAdd,RisOrImpax,ahk_exe WebViewerComSrvEC.exe



GroupAdd,RisOrImpax,ahk_exe WEBVIE~1.EXE



GroupAdd,RisOrImpax,ahk_exe simpleRIS.exe



GroupAdd,RisOrImpax,ahk_exe showLungCAD.exe



ips=



(



intranet.hospital.example



10.0.0.100



127.0.0.1:8000



localhost:8000



)



baseurl:=feedbackIp:=""



ToolTip % "Finding server ... "



if (A_IPAddress1~="^172.2")



ips:="10.0.0.100`n"ips



Loop,parse,ips,`n



{



whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")



,whr.Open("GET",(url:="http://" (ip:=A_LoopField)) "/nodulePic/", true)



,whr.Send()



,whr.WaitForResponse(2)



if InStr(whr.ResponseText, "Lung Nodule Finder"){



baseurl:=url, feedbackIp:=ip



break



}



}



if (baseurl=""){



MsgBox % "Can not connect to server!`nPlease contact YCH!"



ExitApp



}



ToolTip



if(EBMmode){



ShowInBrowser:=1



,ShowInImpax:=0



}else{



}



Hotkey,IfWinActive,ahk_group RisOrImpax



Hotkey,% Trim(secondKey),magicResult,on



Hotkey,% Trim(priorKey),prior,on



Hotkey,% Trim(nextKey),next,on



if(!EBMmode){



Hotkey,% Trim(ReportFPKey),ReportFPHotkey,on



Hotkey,% Trim(ReportFNKey),ReportFNHotkey,on



}



Loop,parse,dismissKey,`,



Hotkey,% "~" Trim(A_LoopField),dismiss,on



Hotkey,IfWinActive



if OpenRegionGrow {



Hotkey,IfWinExist,WM_COPYDATA_Listener_RegionGrowMorph



Hotkey,~+LButton,~+LButton_



Hotkey,IfWinExist



}



return



ReportFNHotkey:



MouseGetPos,mx,my



which:=whichMonitor("", "", monitorInfo)



,frames:=getViewFrame()



if !NoCaptureText {



ToolTip % "Waiting for OCR..."



info:=getImpaxFrameInfo(frames[which.1-1,1,1], "LL")



}else



info:={}



ToolTip



ParseInfo({Center_X:mx, Center_Y:my})



return



ReportFPHotkey:



SetTimerF("MoveMsgbox", 100, ["Report FP"])



MsgBox, 4,Report FP, Report False Positive? `n(Not a nodule)



IfMsgBox,No



return



gosub ReportFP



return



search(){



gosub magicResult



}



next(){



gosub next



}



prior(){



gosub prior



}



magicResult:



gosub HideGUI



gosub getChartNo



if (chartNo="") {



msgbox,,,Failed to get chart No.,3



return



}



if (examDate=""){



MsgBox,,,Failed to get exam date,3



return



}



magicUrl:=(ip:=baseurl "/nodulePic/") (examDate:=SubStr(RegExReplace(examDate,"\D",""),1,8)) "/" chartNo "/"



,httprequest(magicUrl, post:="", header, "charset: utf-8")



,regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)



,FirstOpened:=true



if (code1<200 || code1>=300){



MsgBox,260,, % "Can't find result of " chartNo " on " examDate " !`n`nRequest for CAD?",15



IfMsgBox,Yes



{



sid:=askForPortalIdPw()



if (sid){



if portalMessage(sid, "0900000000", examDate " " chartNo "希望有CAD!"){



MsgBox,,,% "已發送簡訊給CHM!",3



}else{



MsgBox,,,% "發送簡訊給CHM失敗，請電話(52113)告知病歷號、檢查日期!",3



}



}



}



return



}



clipboard:=currentUrl:=magicUrl "#&gid=1&pid=1"



lastFound:="magic"



gosub UrlToBrowser



SetTimer,loadJson,-1



return



loadJson:



httprequest(jsonUrl:=baseurl "/lungNoduleResult/" chartNo "_" AccNo ".json"



, post:="", header, "charset: utf-8")



try



jsonData:=jxon_load(post)



catch {



MsgBox,,,% "JSON data error, plz contact CHM or YCH!",5



return



}



thisInd:=1



, nodCount:=jsonData.Nodules.SetCapacity(0)



, First:=true



if nodCount>0



gosub noduleListGui



if nodCount=0



goto noResult



gosub impaxSelect



return



noduleListGui:



gui,noduleList:new,+hwndNoduleListHwnd +ToolWindow +AlwaysOnTop



gui,Font,s12 w400,Verdana



gui,Color,ececec



noduleButtonText:=[]



width1:=80, width2:=40



if (nodCount<=10){



Loop % nodCount



guiNoduleButton(A_Index, width1, width2, 0, "+0")



}else{



Loop % Floor(nodCount/2)



guiNoduleButton(2*(A_Index-1)+1, width2, width2, 0, "+0")



,guiNoduleButton(2*(A_Index), width2, width2, "+0", "p")



if Mod(nodCount,2)



guiNoduleButton(nodCount, width2, width2, 0, "+0")



}



gui,Font,s10 w400,Verdana



gui,Add,button,gorderBySize w%width1% h%width2% x0 y+0 vorderBySizeButton,By Size



return



guiNoduleButton(_i, w, h, x, y){



local conf,FontColor,t



conf:=jsonData.Nodules[_i-1].Confidence



gui,Font,% "s12 w" (conf>5?700:400),Verdana



FontColor:=conf>threshold?"black":"gray"



gui,Add,button,gjumpToNodule w%w% h%h% x%x% y%y% vnoduleButton%_i% c%FontColor%,%  t:=(conf>5)?("-" _i "-"):(" " _i " ")



noduleButtonText[_i]:=t



}



orderBySize:



gosub hideGUI



orders:=[]



for k,nodule in jsonData.Nodules {



key:=Floor(nodule.Diameter*1000)



if !orders.hasKey(key)



orders[key]:=[]



orders[key].push(k)



}



newNodules:=[]



,Count:=jsonData.Nodules.maxindex()



,i:=0



for k,v in orders {



for x,y in v



newNodules[thisI:=Count-(i++)]:=jsonData.Nodules[y].clone()



,newNodules[thisI, "NoduleIndBeforeSort"]:=y



}



jsonData.Nodules:=newNodules



,thisInd:=1



gosub noduleListGui



guicontrol,noduleList:Move,orderBySizeButton,w0 h0 x-1



gosub changeIm2



return



jumpToNodule:



if RegExMatch(A_GuiControl, "\d+", jumpNoduleInd){



thisInd:=jumpNoduleInd



gosub HideGUI



if ShowNoduleList



settimer,ShowNoduleListGUI,-1000



gosub changeIm2



}



return



ShowNoduleListGUI:



gui,%nodulelisthwnd%:show,NoActivate



return



nextInd(ind){



global nodCount, thisInd, threshold, jsonData



if ind=



ind:=thisInd



Loop {



if (++ind>nodCount)



ind-=nodCount



if (ind==thisInd) || (jsonData.Nodules[ind-1].Confidence>threshold)



break



}



return ind



}



priorInd(ind){



global nodCount, thisInd, threshold, jsonData



if ind=



ind:=thisInd



Loop {



if (--ind<1)



ind:=nodCount



if (ind==thisInd) || (jsonData.Nodules[ind-1].Confidence>threshold)



break



}



return ind



}



disconnectSocket:



inUdp.disconnect()



for k,v in outUdp



v.disconnect()



return



sendChartNo:



return



getChartNo:



lastChartNo:=chartNo, lastAccNo:=AccNo



chartNo:=""



winget,pName,ProcessName,A



if (EBMmode || pName~="i)WebViewerComSrvEC.exe|WEBVIE~1.EXE"){



if rChartNo:=getRisChartNo(RisOpened()[2])



chartNo:=rChartNo, examDate:=getRisExamDate(RisHwnd:=RisOpened()[2])



, AccNo:=getRIsAccNo(RisHwnd)



else



ret:=getEBMInfo()



,chartNo:=ret.chartNo



,examDate:=ret.examYear (StrLen(ret.examMonth)=1?"0":"") ret.examMonth (StrLen(ret.examDay)=1?"0":"") ret.examDay



,AccNo:=ret.AccNo



}



else if iChartNo:=getImpaxChartNo(impaxHwnd:=ImpaxOpened()[2,1]){



chartNo:=iChartNo, examDate:=getImpaxExamDate(impaxHwnd)[1]



, AccNo:=getImpaxAccNo(impaxHwnd)



if RegExMatch(examDate, "^(\d+)\/(\d+)\/(\d+)", m)



examDate:=m1 (StrLen(m2)=1?"0":"") m2 (StrLen(m3)=1?"0":"") m3



}



else if rChartNo:=getRisChartNo(RisOpened()[2])



chartNo:=rChartNo, examDate:=getRisExamDate(RisHwnd:=RisOpened()[2])



, AccNo:=getRIsAccNo(RisHwnd)



else if regexmatch(clipboard,"\w{6}\d",match)



chartNo:=match, AccNo:=""



return



main:



gosub HideGUI



chartNo:=AccNo:=examDate:=""



, jsonData:=[]



gosub getChartNo



if (chartNo="") {



msgbox,,,Failed to get chart No.,3



return



}



test:



dateStr:=SubStr(examDate,1,4) SubStr(examDate,6,2) SubStr(examDate,9,2)



,ip:="http://10.0.0.100:8042/"



,httprequest(url:=ip "patients/" SHA1dash(chartNo),post:="",header:="","charset: utf-8")



if (!post){



goto fail



return



}



patient:=json_from(post)



,url:="",processed:=0



Loop % patient.studies.maxindex() {



httprequest(ip "studies/" patient.studies[A_Index],post:="",header:="","charset: utf-8")



if !post



continue



study:=json_from(post)



if(study.MainDicomTags.StudyDate=dateStr){



Loop % study.series.maxindex() {



httprequest(ip "series/" study.series[A_Index],post:="",header:="","charset: utf-8")



if(!post)



continue



series:=json_from(post)



if(series.MainDicomTags.SeriesDescription="Evidence Documents MM Oncology Reading"){



processed:=1



}else if(series.MainDicomTags.SeriesDescription="Results MM Oncology Reading" || series.MainDicomTags.SeriesDescription="Hologic R2 ImageChecker CAD SC"){



clipboard:=url:=ip "web-viewer/app/viewer.html?series=" study.series[A_Index]



break 2



}



}



}



}



if(url=""){



if(processed){



goto noResult



return



}else{



goto fail



return



}



}



lastFound:="syngovia"



UrlToBrowser:



if (!ShowInBrowser && lastFound!="syngovia")



return



if(ShowClearRead && (AccNo!="")){



getPwb(2).navigate(clearReadUrl AccNo)



winactivate,% "ahk_id " getPwb(2).hwnd



}



getPwb(1).navigate(currentUrl)



winactivate,% "ahk_id " getPwb(1).hwnd



return



ifwinexist,ahk_class MozillaWindowClass



{



winactivate,ahk_class MozillaWindowClass



WinWaitActive,ahk_class MozillaWindowClass,,2



}else ifwinexist,ahk_class Chrome_WidgetWin_1



{



WinActivate,ahk_class Chrome_WidgetWin_1



WinWaitActive,ahk_class Chrome_WidgetWin_1,,2



}else{



openNew:=false



gosub openNewChromeOrFirefox



if(openNew="firefox" && !err){



WinActivate,ahk_class MozillaWindowClass



WinWaitActive,ahk_class MozillaWindowClass,,2



}else if(openNew="chrome" && !err){



WinActivate,ahk_class Chrome_WidgetWin_1



WinWaitActive,ahk_class Chrome_WidgetWin_1,,2



}else if (err){



MsgBox,,, % "The URL is copied. Please paste in FireFox or Chrome browser.",5



return



}



}



Sleep 500



if !InStr(activeUrl:=GetActiveBrowserURL(),ip) && activeUrl!="" {



send ^t



Sleep 200



}



send !d



sleep 200



send ^v



sleep 200



send {enter}



recoverClip:



return



openNewChromeOrFirefox:



appPath:=""



Loop,% a_desktop "\*.lnk"



if InStr(A_LoopFileName, "firefox"){



FileGetShortcut,% A_LoopFileFullPath, appPath



break



}



if(appPath!=""){



run % """" appPath """ """ url """"



err:=ErrorLevel



,openNew:="firefox"



return



}



Loop,% A_DesktopCommon "\*.lnk"



if InStr(A_LoopFileName, "firefox"){



FileGetShortcut,% A_LoopFileFullPath, appPath



break



}



if(appPath!=""){



run % """" appPath """ """ url """"



err:=ErrorLevel



,openNew:="firefox"



return



}



Loop,% a_desktop "\*.lnk"



if InStr(A_LoopFileName, "chrome"){



FileGetShortcut,% A_LoopFileFullPath, appPath



break



}



if(appPath!=""){



run % """" appPath """ """ url """"



err:=ErrorLevel



,openNew:="chrome"



return



}



Loop,% A_DesktopCommon "\*.lnk"



if InStr(A_LoopFileName, "chrome"){



FileGetShortcut,% A_LoopFileFullPath, appPath



break



}



if(appPath!=""){



run % """" appPath """ """ url """"



err:=ErrorLevel



,openNew:="chrome"



return



}



MsgBox,,, % "Please open Firefox or Chrome first!",5



openNew:=false



return



fail:



MsgBox, 4164, ,% "Lung CAD not processed or study not found in SyngoVia?",60



return



noResult:



MsgBox,,,% "No lesion found by CAD !",3



return



SHA1dash(str){



str:=SHA(str)



stringlower,str,str



return substr(str,1,8) "-" substr(str,9,8) "-" substr(str,17,8) "-" substr(str,25,8) "-" substr(str,33,8)



}



next:



prior:



gosub HideGUI



key:=A_ThisLabel



,lastfound:=InStr(A_ThisHotkey, "^")?"syngovia":"magic"



gosub changeIm



return



changeIm:



thisInd:=key="next"?nextInd(thisInd):priorInd(thisInd)



changeIm2:



if ShowInBrowser



nd:=jsonData.Nodules[thisInd-1]



,getPwb(1).navigate(RegExReplace(currentUrl, "(?<=pid=)\d+$", nd.hasKey("noduleIndBeforeSort")?nd.noduleIndBeforeSort+1:thisInd))



if (EBMmode)



gosub EBMselect



if ShowInImpax {



gosub impaxSelect



}



if ShowInBrowser {



winactivate,% "ahk_id " getPwb(1).hwnd



}



return



activeWin:=WinExist("A")



MouseGetPos,beforeScrollX,beforeScrollY



if WinExist("ahk_class MozillaWindowClass")



browser:="ahk_class MozillaWindowClass"



else if WinExist("ahk_class Chrome_WidgetWin_1")



browser=ahk_class Chrome_WidgetWin_1



else



return



WinActivate,%browser%



WinWaitActive,,,2



RegExMatch(currentUrl:=GetActiveBrowserURL(), "(?<=pid=)\d+$", lastInd)



,repeat:=false



WinGetPos,bx,by,bw,bh,% browser



if (LastFound="syngovia"){



mousemove,% bx+bw-100,% by+Floor(bh/2),0



Sleep 50



send % (key="prior")?"{WheelUp}":"{WheelDown}"



Sleep 50



}else{



mouseclick,L,% bx+bw-10,% by+Floor(bh/2),1,0



Sleep 50



send % (key="next")?"{Right}":"{Left}"



Loop {



Sleep 100



}until currentUrl!=GetActiveBrowserURL() || A_Index>10



thisInd:=key="next"?nextInd(lastInd):priorInd(lastInd)



repeat:=thisInd=1



}



mousemove,% beforeScrollX,% beforeScrollY,0



WinActivate,ahk_id %activeWin%



if (lastFound!="syngovia")



gosub impaxSelect



if (repeat && !First)



MsgBox,,,% "Back to first picture!",2



First:=false



return



impaxSelect:



ebm_show_x:=ebm_show_y:=""



if EBMmode || (chartNo~="i)^[H]")



goto EBMselect



if !ShowInImpax



return



if (ShowNoduleList){



WinGetPos,lastX,lastY



WinHide,ahk_id %noduleListHwnd%



}



MouseGetPos,,,,mCon,2



if !(ControlGetText(mCon)~="Screen_\d+_format_\d+_Position_\d+_\d+")



return



SEIM:=getSEIM()



if (jsonData.AccessionNumber=AccNo) && nodCount>0 {



nodule:=jsonData.Nodules[thisInd-1]



if ((originalThickness:=jsonData.spacing[3])=""){



if RegExMatch(jsonData.spacing, "\[[\d\.]+\, *[\d\.]+\, *([\d\.]+)\]", match)



originalThickness:=match1



else



originalThickness:=1.0



}



if(lastAccNo!=AccNo)



thickSliceMode:=!(SEIM.1=jsonData.SeriesNumber)



, z:=(SEIM.1=jsonData.SeriesNumber)?(nodule.InstanceNumber):Round(nodule.InstanceNumber*originalThickness/5)



else



z:=!thickSliceMode?(nodule.InstanceNumber):Round(nodule.InstanceNumber*originalThickness/5)



if z<1



z:=1



coord:=impaxSelectImageCurrent(nodule["X-Ratio"], nodule["Y-Ratio"], z)



if (coord){



cross.show(coord.1, coord.2)



,OnScreenDisplay(thisInd, 400, 50, "white")



,DisplayNoduleInfo(thisInd, SEIM.1=jsonData.SeriesNumber)



}



First:=false



}



return



EBMselect:



if (ShowNoduleList){



WinGetPos,lastX,lastY



WinHide,ahk_id %noduleListHwnd%



}



if (jsonData.AccessionNumber=AccNo) && nodCount>0 {



nodule:=jsonData.Nodules[thisInd-1]



if ((originalThickness:=jsonData.spacing[3])=""){



if RegExMatch(jsonData.spacing, "\[[\d\.]+\, *[\d\.]+\, *([\d\.]+)\]", match)



originalThickness:=match1



else



originalThickness:=1.0



}



MouseGetPos,mx,my



IMnumber:= nodule.InstanceNumber



,IMinfo:=originalThickness=1?IMnumber " (1mm)":IMnumber " , " Floor((IMnumber-1)*originalThickness + 1) " (1mm)"



,IMinfo.=" , " Floor((IMnumber-1)*originalThickness/3 + 1) " (3mm)`n" (StrLen((s:=Floor((IMnumber-1)*originalThickness/5 + 1)))<3?" ":"") s " (5mm) , " Floor((IMnumber-1)*originalThickness/2.5 + 1) " (2.5mm)"



coord:=[]



,coord.1:=mx, coord.2:=my



,which:=whichMonitor("", "", monitorInfo).1



,ebm_show_x:=nodule["X-Ratio"]<0.5?Floor(monitorInfo[which].l+monitorInfo[which].w*2/3):Floor(monitorInfo[which].l+monitorInfo[which].w/8)



,ebm_show_y:=nodule["Y-Ratio"]<0.5?Floor(monitorInfo[which].t+monitorInfo[which].h*2/3):Floor(monitorInfo[which].t+monitorInfo[which].h/4)



OnScreenDisplay("# " thisInd "`n" IMinfo "`n( X , Y ) = ( " Floor(512*nodule["X-Ratio"]) " , " Floor(512*nodule["Y-Ratio"]) " )", 120000, 50, "CCCCCC", "Verdana", [monitorInfo[which].l+10, monitorInfo[which].b-500])



,DisplayNoduleInfo(thisInd, true)



First:=false



}



return



^!q::



exitapp



return



OnExit:



gosub disconnectSocket



for k,pwb in pwbs



pwb.quit()



ExitApp



dismiss:



winget,pActiveHwnd,id,A



ControlGetFocus,pActiveControl,A



if WinVisible(reporthwnd)



WinHide,% "ahk_id " reporthwnd



else if WinVisible(noduleListHwnd) {



MouseGetPos,lastX,lastY



WinHide,% "ahk_id " noduleListHwnd



}



if (A_ThisHotkey~="F\d"){



MouseGetPos,lastX,lastY



WinHide,% "ahk_id " noduleListHwnd



WinHide,% "ahk_id " reporthwnd



for k, pwb in pwbs



{



WinHide,% "ahk_id " pwb.hwnd



WinMinimize,% "ahk_id " pwb.hwnd



WinShow,% "ahk_id " pwb.hwnd



}



}



OnScreenDisplay("", 1,1,"white")



winget,pName,ProcessName,% "ahk_id " pActiveHwnd



if(pName~="i)Menu.exe|impax-client-main.exe"){



winactivate,% "ahk_id " pActiveHwnd



ControlFocus,% pActiveControl,% "ahk_id " pActiveHwnd



}



return



#IfWinExist,WM_COPYDATA_Listener_RegionGrowMorph



~+LButton_:



settimer,LButton_Shift,-500



settimer,LButtonUP,100



gosub HideGUI



which:=whichMonitor("", "", monitorInfo)



,frames:=getViewFrame()



if !NoCaptureText



info:=getImpaxFrameInfo(frames[which.1-1,1,1], "LL")



else



info:={}



return



LButton_Shift:



if GetKeyState("Shift") && GetKeyState("Lbutton") {



MouseGetPos,x,y



Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_RegionGrowMorph"), 25, jxon_dump({"start":1



, "mouse_pos": [x,y]}))



}



LButtonUp:



if !GetKeyState("LButton") {



settimer,LButton_Shift,Off



settimer,LButtonUp,Off



Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_RegionGrowMorph"), 25, jxon_dump({"end":1



, "mouse_pos": [x,y]}))



}



return



#IfWinExist



#IfWinActive,ahk_exe Menu.exe



~*F3::



lastX:=lastY:=""



WinHide,% "ahk_id " reporthwnd



WinHide,% "ahk_id " noduleListHwnd



return



#IfWinActive



~Rbutton::



mousegetpos,,,win,con,2



if(win==reporthwnd || win==noduleListHwnd) && !instr(WinGetClass(con),"edit"){



winhide,% "ahk_id " reporthwnd



winhide,% "ahk_id " noduleListHwnd



}



return



StringUpper(ByRef str){



StringUpper,str,str



}



IsValidJPEG( JPEG ) {



FileGetSize, Size, %JPEG%



IfLessOrEqual, Size, 1, Return False



FileRead, Bin, *c %JPEG%



Return ( NumGet( Bin, Size-2, "UShort" ) = 0xD9FF ) ? True : False



}



WinHttpRequest( URL, ByRef In_POST__Out_Data="", ByRef In_Out_HEADERS="", Options="", https=false)



{



static nothing := ComObjError(0)



static oHTTP   := ComObjCreate("WinHttp.WinHttpRequest.5.1")



static oADO    := ComObjCreate("adodb.stream")



if(https){



oHTTP.option(9):=0x2728



,oHTTP.option(4):=0x3300



}



If IsObject(URL)



Return oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")



If (In_POST__Out_Data != "") || InStr(Options, "Method: POST")



oHTTP.Open("POST", URL, True)



Else If InStr(Options, "Method: HEAD")



oHTTP.Open("HEAD", URL, True)



Else



oHTTP.Open("GET", URL, True)



If In_Out_HEADERS



{



In_Out_HEADERS := Trim(In_Out_HEADERS, " `t`r`n")



Loop, Parse, In_Out_HEADERS, `n, `r



{



If !( _pos := InStr(A_LoopField, ":") )



Continue



Header_Name  := SubStr(A_LoopField, 1, _pos-1)



Header_Value := SubStr(A_LoopField, _pos+1)



If (  Trim(Header_Value) != ""  )



oHTTP.SetRequestHeader( Header_Name, Header_Value )



}



}



If (In_POST__Out_Data != "") && !InStr(In_Out_HEADERS, "Content-Type:")



oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")



If Options



{



Loop, Parse, Options, `n, `r



{



If ( _pos := InStr(A_LoopField, "Timeout:") )



Timeout := SubStr(A_LoopField, _pos+8)



Else If ( _pos := InStr(A_LoopField, "Proxy:") )



oHTTP.SetProxy( 2, SubStr(A_LoopField, _pos+6) )



Else If ( _pos := InStr(A_LoopField, "Codepage:") )



oHTTP.Option(2) := SubStr(A_LoopField, _pos+9)



}



oHTTP.Option(6) := InStr(Options, "NO_AUTO_REDIRECT") ? 0 : 1



}



oHTTP.Send(In_POST__Out_Data)



,ReturnCode := oHTTP.WaitForResponse(Timeout ? Timeout : -1)



If InStr(Options, "SaveAs:")



{



RegExMatch(Options, "i)SaveAs:[ \t]*\K[^\r\n]+", SavePath)



,_s:=SavePath



,_p:=comobjquery(oHTTP.responsestream,"{0000000c-0000-0000-C000-000000000046}")



,_f:=fileopen(_s,"w")



loop{



varsetcapacity(_b,8192)



,_r:=dllcall(numget(numget(_p+0)+3*a_ptrsize),ptr,_p,ptr,&_b,uint,8192, "ptr*",_c)



,_f.rawwrite(&_b,_c)



}until (_c=0)



objrelease(_p)



,_f.close()



In_POST__Out_Data := ""



}



Else If InStr(Options, "Charset:")



{



RegExMatch(Options, "i)Charset:[ \t]*\K[\w-]+", Encoding)



oADO.Type     := 1



,oADO.Mode     := 3



,oADO.Open()



,oADO.Write( oHTTP.ResponseBody() )



,oADO.Position := 0



,oADO.Type     := 2



,oADO.Charset  := Encoding



,In_POST__Out_Data := IsByRef(In_POST__Out_Data) ? oADO.ReadText() : ""



,oADO.Close()



}



Else



In_POST__Out_Data := IsByRef(In_POST__Out_Data) ? oHTTP.ResponseText : ""



In_Out_HEADERS := "HTTP/1.1 " oHTTP.Status() "`n" oHTTP.GetAllResponseHeaders()



Return, ReturnCode



}



ControlGetText(ByRef control="", ByRef title="",ByRef Text="",ByRef exclude_title="",ByRef exclude_text=""){



if control is integer



{



if(title text exclude_title  exclude_text=="")



return __ControlGetText(hwnd:=control)



}



ControlGetText,var,% control,% title,% Text,% exclude_title,% exclude_text



return var



}



__controlGetText(hwnd){



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



WinGetClass(ByRef title="",ByRef Text="",ByRef exclude_title="",ByRef exclude_text=""){



if title is integer



{



if(text exclude_title exclude_text==""){



WinGetClass,t,ahk_id %title%



return t



}



}



WinGetClass,var,% title,% Text,% exclude_title,% exclude_text



return var



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



DateDiff(date, refDate, AbsValue=true){



date-=refDate, Days



return AbsValue?abs(date):date



}