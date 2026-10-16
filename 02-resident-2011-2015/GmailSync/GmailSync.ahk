googleSyncFolder:="C:\Google Drive\Gmail Attachments"

settimer,parseFile,% 1000*60*60

return


parseFile:
loop,% googldeSyncFolder "\*.*",1,1
{
	if !RegExMatch(a_loopfilename,"is)(\d{4})(\d\d)(\d\d)(\d\d)(\d\d)(\d\d) (.*) (#\w+) ([^\.]+)(.*)",match)
		continue
	
	if a_yyyy*12+a_mm+a_dd/30-match1*12-match2-match3/30=>2
		filedelete,% a_loopfilename
		
}
return