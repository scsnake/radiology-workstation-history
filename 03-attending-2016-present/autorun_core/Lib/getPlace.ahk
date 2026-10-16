#include <CTH_RIS>
getPlace(){
	global CTH_RIS, __is_CTH,__is_NTUH
	FileExist(root_dir := A_MyDocuments "\reportSet") || FileExist(root_dir := A_MyDocuments "\reportSetCTH") 
	
	place_info := root_dir "\place" 
	if !FileExist(place_info){
		if (A_UserName="CTH"){
			p:="CTH", __is_CTH:=true
		}else{
			p:="N_HOSPITAL", __is_NTUH:=true
		}
		
		FileAppend,% p,% place_info,utf-8-Raw
		
	}else{
		fileread,p,% place_info
		
	}
	
	if InStr(p, "CTH"){
		__is_CTH:=true
		if !CTH_RIS
			CTH_RIS:=new CTH_RIS_REPORT()
	}
	if InStr(p, "NTUH") || InStr(p, "N_HOSPITAL")
		__is_NTUH:=true
	
	return p
}