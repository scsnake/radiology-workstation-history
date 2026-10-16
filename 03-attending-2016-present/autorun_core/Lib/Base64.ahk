Base64Enc( ByRef Bin, nBytes, LineLength := 64, LeadingSpaces := 0 ) { ; By SKAN / 18-Aug-2017
Local Rqd := 0, B64, B := "", N := 0 - LineLength + 1  ; CRYPT_STRING_BASE64 := 0x1
  DllCall( "Crypt32.dll\CryptBinaryToString", "Ptr",&Bin ,"UInt",nBytes, "UInt",0x1, "Ptr",0,   "UIntP",Rqd )
  VarSetCapacity( B64, Rqd * ( A_Isunicode ? 2 : 1 ), 0 )
  DllCall( "Crypt32.dll\CryptBinaryToString", "Ptr",&Bin, "UInt",nBytes, "UInt",0x1, "Str",B64, "UIntP",Rqd )
  If ( LineLength = 64 and ! LeadingSpaces )
    Return B64
  B64 := StrReplace( B64, "`r`n" )        
  Loop % Ceil( StrLen(B64) / LineLength )
    B .= Format("{1:" LeadingSpaces "s}","" ) . SubStr( B64, N += LineLength, LineLength ) . "`n" 
Return RTrim( B,"`n" )    
}
MsgBox % base64("test")
Base64(string) { 

   Loop Parse, string 

   { 

      If Mod(A_Index,3) = 1 

         buffer := Asc(A_LoopField) << 16 

      Else If Mod(A_Index,3) = 2 

         buffer += Asc(A_LoopField) << 8 

      Else { 

         buffer += Asc(A_LoopField) 

         out := out . Code(buffer>>18) . Code(buffer>>12) . Code(buffer>>6) . Code(buffer) 

      } 

   } 

   If Mod(StrLen(string),3) = 0 

      Return out 

   If Mod(StrLen(string),3) = 1 

      Return out . Code(buffer>>18) . Code(buffer>>12) "==" 

   Return out . Code(buffer>>18) . Code(buffer>>12) . Code(buffer>>6) "=" 

} 
Code(i) {   ; <== Chars[i & 63], 0-base index 

   static Chars:="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

   StringMid i, Chars, (i&63)+1, 1 

   Return i 

} 