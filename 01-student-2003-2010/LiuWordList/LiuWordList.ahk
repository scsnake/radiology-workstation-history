#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines,-1

^d::
sleep 200
x=0,y=0

a:=97
loop 26
{
	wordRoot:= chr(a),host=0,page=0
	while writeToTxt(wordRoot,host,page)
	{
		if host=8
			page++,host=0
		else
			host++
	}	
	b:=97
	loop 26
	{
		wordRoot:= chr(a) chr(b),host=0,page=0
		while writeToTxt(wordRoot,host,page)
		{
			if host=8
				page++,host=0
			else
				host++
		}	
		c:=97
		loop 26
		{
			wordRoot:= chr(a) chr(b) chr(c),host=0,page=0
			while writeToTxt(wordRoot,host,page)
			{
				if host=8
					page++,host=0
				else
					host++
			}	
			d:=97
			loop 26
			{
				wordRoot:= chr(a) chr(b) chr(c) chr(d),host=0,page=0
				while writeToTxt(wordRoot,host,page)
				{
					if host=8
						page++,host=0
					else
						host++
				}	
				;~ e:=97
				;~ loop 26
				;~ {
					;~ wordRoot:= chr(a) chr(b) chr(c) chr(d) chr(e),host=0,page=0
					;~ while writeToTxt(wordRoot,host,page)
					;~ {
						;~ if host=8
							;~ page++,host=0
						;~ else
							;~ host++
					;~ }	
					;~ e++
				;~ }
				d++
			}
			c++
		}
		b++
	}
a++
send ^s
}

return


writeToTxt(wordRoot,host=0,page=0)
{
	
	
	clipboard:=wordRoot

	send ^v
	send {tab}
	send %wordRoot%

	loop % page
		send {pgdn}
	

	if host=8
		imagesearch,x,y,0,640,a_screenwidth,a_screenheight,next.bmp
	else
	{
		tmp:=host+1 ".bmp"
		imagesearch,x,y,0,640,a_screenwidth,a_screenheight,%tmp%
	}
	found:=not errorlevel
	
	send %host%
	send {space}
	send {enter}
	
	return % found
}




!q::exitapp
