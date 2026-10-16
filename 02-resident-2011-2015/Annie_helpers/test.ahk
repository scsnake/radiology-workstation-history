


data=
(
microsoft,soft,andy
apple,apple,jack
tesla,tesla,chris
microsoft,soft,andy
apple,apple,jack
tesla,tesla,chris
microsoft,soft,andy
apple,apple,jack
tesla,tesla,chris
microsoft,soft,andy
apple,apple,jack
tesla,tesla,chris
microsoft,soft,andy
apple,apple,jack
tesla,tesla,chris
microsoft,soft,andy
apple,apple,jack
tesla,tesla,chris1

)
pass:="avsdf"

MsgBox % t:=rc4txt2hex(data, pass)
MsgBox % rc4hex2txt(t, pass)