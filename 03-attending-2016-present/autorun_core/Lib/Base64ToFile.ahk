#include <Base64Dec>

Base64ToFile(base64, filePath){
	if RegExMatch(base64, "i)data:image/(\w+);base64,", extension)
		base64:=SubStr(base64, StrLen(extension)+1)
		,extension:=extension1
	
	SplitPath,filePath,,,ext
	if (ext="" && extension!="")
		filePath.="." extension
	
	nBytes := Base64Dec( base64, Bin )
	File := FileOpen(filePath, "w")	
	,File.RawWrite(Bin, nBytes)
	,File.Close()

}

