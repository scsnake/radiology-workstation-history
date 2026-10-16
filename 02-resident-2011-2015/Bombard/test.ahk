a:=""
loop,parse,clipboard,`n
{
   RegExMatch(a_loopfield,"([^=]+)=",match)
   a.=""""
   a.=match1
   a.="""`,"
   
}

clipboard:=a
send ^v
exitapp


,