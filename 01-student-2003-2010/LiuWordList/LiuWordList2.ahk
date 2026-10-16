#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines,-1


^d::
sleep 200
x=0
str:=""

a:=97
loop 26
{
	str.= chr(a) " \"
	
	b:=97
	loop 26
	{
		str.= chr(a) chr(b) " \"
		
		c:=97
		loop 26
		{
			str.= chr(a) chr(b) chr(c) " \"
			
			d:=97
			loop 26
			{
				str.= chr(a) chr(b) chr(c) chr(d) " \"
				;~ e:=97
				;~ loop 26
				;~ {
					;~ str.= chr(a) chr(b) chr(c) chr(d) chr(e) " \"
					
					;~ e++
				;~ }
				
				d++
			}
			clipboard:=str
			send ^v
			send {raw}`,`,x
			send {space}
			sleep 150
			c++
		}
		
		b++
	}
a++

}
send ^s
return

^!p::
str:=Clipboard
num2rootArr:=object()
a:=97
loop 26
{
	num2rootArr.push(chr(a))
	
	b:=97
	loop 26
	{
		num2rootArr.push(chr(a) chr(b))
		
		c:=97
		loop 26
		{
			num2rootArr.push(chr(a) chr(b) chr(c))
			
			d:=97
			loop 26
			{
				num2rootArr.push(chr(a) chr(b) chr(c) chr(d))
				;~ e:=97
				;~ loop 26
				;~ {
					;~ num2rootArr.push(chr(a) chr(b) chr(c) chr(d) chr(e))
					
					;~ e++
				;~ }
				
				d++
			}
			c++
		}
		b++
	}
a++
}


loop,parse,str,\
{
	if a_loopfield
		FileAppend,% num2rootArr[a_index] "`t" a_loopfield "`r`n",*output2.txt,UTF-8
}
return

^!2::
rootArr1:=object()
loop,parse,clipboard,`n
{
	;~ loop,parse,a_loopfield,`t
	;~ {
		RegExMatch(a_loopfield,"^[a-z]{1,4}",tmp)
		rootArr1.push(tmp)
		
		;~ break
	;~ }
}



for k,vl in rootArr1
{
	clipboard:=vl
	send ^v
	sendraw 1
	send `t
	tmp:=vl "1 "
	send %tmp%
	send `n
	sleep 200
	
}

send ^s

return

^!3::
rootArr2:=object()
loop,parse,clipboard,`n
{
	;~ loop,parse,a_loopfield,`t
	;~ {
		RegExMatch(a_loopfield,"^[a-z]{1,4}",tmp)
		rootArr2.push(tmp)
		;~ break
	;~ }
}



for k,vl in rootArr2
{
	clipboard:=vl
	send ^v
	sendraw 2
	send `t
	tmp:=vl "2 "
	send %tmp%
	send `n
	sleep 200
	
}

send ^s

return

^!4::
rootArr2:=object()
loop,parse,clipboard,`n
{
	;~ loop,parse,a_loopfield,`t
	;~ {
		RegExMatch(a_loopfield,"^[a-z]{1,4}",tmp)
		rootArr2.push(tmp)
		;~ break
	;~ }
}



for k,vl in rootArr2
{
	clipboard:=vl
	send ^v
	sendraw 7
	send `t
	tmp:=vl "7 "
	send %tmp%
	send `n
	sleep 200
	
}

send ^s

return

!^5::
str=
loop,parse,clipboard,`n,s/
{
	str.=substr(a_loopfield,1,1) "`t" substr(a_loopfield,3,1) "`n"
}
clipboard:=str
return

num2root(i)
{
	str:=chr(((i-1)//(26+26**2+26**3))+97)
	
	if not mod(i-1,26+26**2+26**3)
		return % str
	else
		i:=mod(i-1,26**3),str.=chr(((i-1)//(26**2+26))+97)
	
	if not mod(i-1,26+26**2)
		return % str
	else
		i:=mod(i-1,26**2),str.=chr(((i-1)//(26))+97)
	
	if not mod(i-1,26)
		return % str
	else
		return % str chr(mod(i-1,26)-1+97)
	
	
}

^!w::
str=
i=0
loop,parse,clipboard,`n
{
	if asc(substr(a_loopfield,1,1))=97+i
	{
		
		FileAppend,% "[" chr(97+i) " iLiuBox]`n",*final.txt,UTF-8
		i++
	}
	RegExMatch(a_loopfield,"[a-z]{1,4}",tmp)
	;msgbox % a_loopfield
	FileAppend,% tmp "=" substr(trim(a_loopfield),0) "`n",*final.txt,UTF-8
}
msgbox % Finished!
return

!q::exitapp
