IsValidJPEG( JPEG ) {
 FileGetSize, Size, %JPEG%
 IfLessOrEqual, Size, 1, Return False
 FileRead, Bin, *c %JPEG%
Return ( NumGet( Bin, Size-2, "UShort" ) = 0xD9FF ) ? True : False
}