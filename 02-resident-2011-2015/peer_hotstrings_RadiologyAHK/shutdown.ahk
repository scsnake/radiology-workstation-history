﻿﻿; control
SendMode Input
#Hotstring EndChars -()[]{}:;'"\,.?!`n `t
SetDefaultMouseSpeed, 0
setTitleMatchMode 2
EnvSet, shut, 1
LButton::
{
  Click
  EnvSet, shut, 0
}

  MsgBox, %shut%

Loop
{
  Sleep 5000
  MsgBox, %shut%
  EnvSet, shut, 1
}
