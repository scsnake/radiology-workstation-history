a=<a>asdf</a>

RegExMatch(a,"<([^>\s]+)>[^\n]*<\/\1>",match)
msgbox % match

exitapp