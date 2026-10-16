#include <httprequest>
#include <BinaryIO>

HttpDownload(url, filePath, ByRef post="", ByRef header="", options=""){
	httprequest(url, post, header, "Binary`n" options)
	regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
	if !(code1<200 || code1>=300){
		BinWrite(filePath, post, len)
		return filePath
	}
	return 
}
