﻿﻿; control
SendMode Input
#Hotstring EndChars -()[]{}:;'"\,.?!`n `t
SetDefaultMouseSpeed, 0
setTitleMatchMode 2

Loop
{
  Sleep 60000
  if (A_TimeIdle > 1______)
    Shutdown, 6
}
