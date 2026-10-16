#include <WS2>

class FF_Mozrepl
{
	__New(aUrl = "current", aMake = 1){
		FF_Connect()
		if(RegExMatch(aUrl, "http://") || RegExMatch(aUrl, "https://") || RegExMatch(aUrl, "ftp://")){
			aSearch := "spec"
			aUrl := __FF_urlCheck(aUrl)
		}
		else
			aSearch := "host"
		if(aUrl = "current"){
			this.pwb := __FF_genPwb()
			FF_Do("var " . this.pwb . " = window.content")
		}
		else{
			this.pwb := __FF_findTab(aUrl, aSearch) 
			if(aSearch = "spec"){
				if(RegExMatch(aUrl, "http://")){
					tempUrl := RegExReplace(aUrl, "http://", "https://")
				}
				else if(RegExMatch(aUrl, "https://")){
					tempUrl := RegExReplace(aUrl, "https://", "http://")
				}
				this.pwb := __FF_findTab(tempUrl, aSearch)
			}
			if(!this.pwb){
				if(aSearch = "host"){
					if(RegExMatch(aUrl, "www.")){
						tempUrl := RegExReplace(aURl, "www.", "")
					}
					else if(RegExMatch(aUrl, "^[a-zA-Z]{1,4}\.") && (!RegExMatch(aUrl, "^[a-zA-Z]{1,4}\.(com|net|edu|org)"))){
						tempUrl := RegExReplace(aUrl, "^[a-zA-Z]{1,4}\.", "www.")
					}
					else{
						tempUrl := "www." . aUrl
					}
					this.pwb := __FF_findTab(tempUrl, aSearch)
				}
			}
			if(!this.pwb){
				aUrl := __FF_urlCheck(aUrl)
				if(aMake = 1){
					this.pwb := __FF_newTab(aUrl)
				}
				else {
					throw Exception("Couldn't find " . aUrl . " as " . aSearch . ".")
				}
			}
		}
	}
		
	isAlive(){
		return RegExMatch(FF_Do(this.pwb), "object Window")
	}
	Navigate(url){
		url := __FF_urlCheck(url)
		return FF_Do(this.pwb . ".location.href = '" . url . "'")
	}
	

	Back() {
	  return FF_Do(this.pwb . ".window.back()")
	}

	Home() {
	  return FF_Do(this.pwb . ".window.home()")
	}

	Forward() {
	  return FF_Do(this.pwb . ".window.forward()")
	}

	Reload() {
	  reload := FF_Do(this.pwb . ".location.href")
	  return this.Navigate(reload)
	}

	Copy() {
	  return FF_Do(this.pwb . ".document.getSelection();")
	}


	LoadWait() {
	  timeout = 100
	  Loop, %timeout% 
	  {
		  loadCheck := FF_Do(this.pwb . ".document.readyState")
		  if(loadCheck = "complete") 
		  {
			sleep,500
			break
		  }
		  sleep,100
	  }
		
	  return 
	}
	
	;~ LoadWait(){
		;~ timeout = 1000
		;~ Loop, %timeout%
		;~ {
			;~ if(RegExMatch(FF_Do("document.title"), "Firefox \.$")){
				;~ sleep,200
				;~ Break
			;~ }
			;~ sleep,50
		;~ }
		;~ return
	;~ }


	getElementsByName(name, index, action)
	{
		if(index == null)
		{
		  command := this.pwb . ".document.getElementsByName('" . name . "')" . action
		}
		else    
		{
		  command := this.pwb . ".document.getElementsByName('" . name . "')[" . index . "]" . action
		}
		return FF_Do(" " . command)
	}

	getElementById(name, action)
	{
		return FF_Do(this.pwb . ".document.getElementById('" . name . "')" . action)
	}

	getElementsByTagName(name, index, action)
	{
		if(index == null){
		  command := this.pwb . ".document.getElementsByTagName('" . name . "')" . action
		}
		else    {
		  command := this.pwb . ".document.getElementsByTagName('" . name . "')[" . index . "]" . action
	  }
		return FF_Do(" " . command)
	}

	getElementsByClassName(name, index, action)
	{
		if(index == null){
		  command := this.pwb . ".document.getElementsByClassName('" . name . "')" . action
		}
		else    {
		  command := this.pwb . ".document.getElementsByClassName('" . name . "')[" . index . "]" . action
	  }
		return FF_Do(" " . command)
	}


	Close(){
	  return FF_Do(this.pwb . ".window.close()")
	}

	getWinTitle()
	{
		while(!FF_Do(this.pwb . ".document.title")){
			sleep,100
		}
	  return FF_Do(this.pwb . ".document.title")
	}
	

}


;##############################################################################
;*** These functions extend WS2 to handle nonblocking recv

; configure socket for nonblocking reads
; returns 0 on success
__FF_SetNonblocking(socket) {
  FIONBIO := 0x8004667e
  return DllCall("Ws2_32\ioctlsocket", "UInt", socket, "UInt", FIONBIO, "UInt", &FIONBIO)
}

; returns "socket closed", "no more data", or "error"
; no more data means all the available data has been read for now
__FF_LastRecvStatus() {
  return __FF_RecvSock("get last receive status")
}

; returns data received, or empty string
; use __FF_LastRecvStatus to determine condition in case of empty string
__FF_RecvSock(socket) {
  static laststatus := "no more data"
  if (socket == "get last receive status") {
    return laststatus
  }
  chunksize := 4096 ; 4k receive buffer
  VarSetCapacity(recvbuf, chunksize, 0) ; zero-fill buffer
  result := ""
  Loop
  {
    received := DllCall("Ws2_32\recv", "UInt", socket, "Str", recvbuf, "Int", chunksize, "Int", 0)
    if (received > 0) {
      result .= recvbuf  ; append the received data
    }
    else if (received == 0) { ; connection gracefully closed
      laststatus := "socket closed"
      return result
    }
    else { ; error of some kind
      err := DllCall("Ws2_32\WSAGetLastError")
      if (err == 10035) { ; WSAEWOULDBLOCK
        laststatus := "no more data"
        return result
      }
      else {
        laststatus := "error"
        return result ; some other error
      }
    }
  }
}
;*

;##############################################################################
;*** Lower-level socket operations to connect to MozRepl

; save the global socket in a static variable, not in global namespace
__FF_Socket(setsocket="") {
  static mozrepl_socket := -1
  if (setsocket) {
    mozrepl_socket := setsocket
  }
  return mozrepl_socket
}

; connect global socket
; also sets socket to non-blocking and slurps initial MozRepl text
; returns 0 on success, nonzero on failure
FF_Connect(host = "127.0.0.1", port=4242) {
  FF_Disconnect()   ; disconnects if already connected
  sock := WS2_Connect(host . ":" . port)
  if (sock < 0) {
    return -1
  }
  __FF_Socket(sock) ; save the global socket
  if (__FF_SetNonblocking(sock)) {  ; set nonblocking
    FF_Disconnect()
    return -1
  }
  initial := ""
  Loop 100 {
    initial .= __FF_RecvSock(sock)
    if (RegExMatch(initial, "repl\d?> ")) {
      return 0
    }
    laststatus := __FF_LastRecvStatus()
    if (laststatus == "socket closed" || laststatus == "error") {
      FF_Disconnect()
      return -1 ; socket closed or error before we got our indicator
    }
    Sleep, 100 ; wait and receive again
  }
  FF_Disconnect()
  return -1 ; never received the initial prompt.. connected to wrong port?
}

; disconnects global socket (or does nothing if already disconnected)
FF_Disconnect() {
  sock := __FF_Socket()
  if (sock > 0) {
    WS2_Disconnect(sock)
  }
  __FF_Socket(-1)
}

; sends data to the global socket
; returns zero on success
FF_Send(data) {
  return WS2_SendData(__FF_Socket(), data . "`n")
}

; get data
; stream is essentially a sequence of strings delimited by "repl> " prompts
; this function returns the next string in the sequence
FF_Recv(timeout=0) {
  sock := __FF_Socket()
  static received := ""
  
  iterations := round(timeout/100)
  if (iterations < 1) {
    iterations := 1
  }
  
  Loop, %iterations% {
    received .= __FF_RecvSock(sock)
    nextprompt := RegExMatch(received, "\n?repl\d?> ")
    if (nextprompt == 1) { ; superfluous prompt at the very start
      received := RegExReplace(received, "^\n?repl\d?> ") ; delete the prompt
    }
    else if (nextprompt) {
      response := SubStr(received, 1, nextprompt-1)
      StringTrimLeft, received, received, nextprompt-1
      received := RegExReplace(received, "^\n?repl\d?> ") ; delete the prompt
      response := RegExReplace(response, """", "")
      return response
    }
    if (InStr(received, "....>")) {
      FF_Send(";")
      Sleep, 10  ;default: 200
    }
    laststatus := __FF_LastRecvStatus()
    if (laststatus == "socket closed" || laststatus == "error") {
      return received
    }
    Sleep, 5   ;default: 100
  }
  return ""
}
;*

;##############################################################################
;*** Everythig else

FF_Do(command, responsewait=1000) {
  FF_Send(command)
  return FF_Recv(responsewait)
}

__FF_findTab(url, search){
  pwb := __FF_genPwb()
   js := ""
   . "var wm = Components.classes['@mozilla.org/appshell/window-mediator;1']"
     . ".getService(Components.interfaces.nsIWindowMediator);"
   . "var browserEnumerator = wm.getEnumerator('navigator:browser');"
   . "var found = false;"
   . "while (!found && browserEnumerator.hasMoreElements())"
    . "{"
    . "var browserWin = browserEnumerator.getNext();"
     . "var tabbrowser = browserWin.gBrowser;"
     . "var numTabs = tabbrowser.browsers.length;"
     . "for (var index = 0; index < numTabs; index++)"
      . "{"
            . "var currentBrowser = tabbrowser.getBrowserAtIndex(index);"
            . "if ('" . url . "' == currentBrowser.currentURI." . search . ")"
            . " {"
                . "var " . pwb . " = tabbrowser.tabContainer.childNodes[index];"
                . " " . pwb . " = " . pwb . ".linkedBrowser.contentWindow;"
                . "found = true;"
                . " break;"
              . "}"
      . "}"
   . "}"
	FF_Do(js)
	if(RegExMatch(FF_Do(pwb), "object Window")) {
		return pwb
	}	
	else {
		return 0
	}
		
} 


__FF_newTab(url)
{
	pwb := __FF_genPwb()
   js := "var " . pwb . " = gBrowser.loadOneTab('" . url . "');"
	. " " . pwb . " = " . pwb . ".linkedBrowser.contentWindow;"
    FF_Do(js)
	if(RegExMatch(FF_Do(pwb), "object Window")){
		return pwb
	}
	else{
		return 0
	}
}


__FF_genPwb()
{
    while(RegExMatch(FF_Do(pwb), "object Window") || (!pwb))
    {
      Random num, 0, 30
      pwb = newTab%num%
    }
    return pwb
}

__FF_urlCheck(url){
	if(!(RegExMatch(url, "http://") || RegExMatch(url, "https://") || RegExMatch(url, "ftp://"))){
		url := "http://" . url
	}
	if((!(RegExMatch(url, "/$"))) && RegExMatch(url, ".(com|org|edu|net|info|xxx)$")){
		url := url . "/"
	}
	return url
}

__FF_LoadStart(){
	js := " " 
		. "function loaded(){ document.title += ' .';};"
		. "var x = window;"
		. "var appcontent = x.document.getElementById('appcontent');"
		. "appcontent.addEventListener('load', function(){loaded();}, true);"
	return FF_Do(js)
}
