#Include <Progress_Lib>

;Download the example images
RequiredFiles := "P-N.png|P-R.png|P-N-2.png|P-R-2.png|P-V-N.png|P-V-R.png"
Loop, Parse, RequiredFiles, |
  If (!FileExist(A_LoopField))
    UrlDownloadToFile, % "http://www.autohotkey.net/~Banane/Images/" A_LoopField, % A_LoopField

GuiCreate:
  ;Create a gui with some fancy options
  Gui, 1:+LastFound -Caption
  Gui, 1:Color, 111111
  WinSet, Region, 0-0 0-0 w395 H100 R9-9

    ;Configure the font
    Gui, 1:Font, cFFFFFF Bold, Arial
    ;Create a slider that will be "connected" with the progressbars
    Gui, 1:Add, Slider, x15 y20 w340 h20 +Range0-4 vSlider gGuiSlider
    ;Select the horizontal progressbar images
    Progress_SetFile("P-N.png","P-R.png")
    ;Create a new progressbar with a range of 0 to 4, Startvalue 0 and a text overlay
    hBar1 := Progress_Add(1,"x15 y50 w340 h15","0-4",0,"$Position/$Range")
    ;Select the vertical progressbar images
    Progress_SetFile("P-V-N.png","P-V-R.png")
    ;Create a new progressbar with a range of 0 to 4, Startvalue 0 and no text overlay
    hBar2 := Progress_Add(1,"x365 y20 w15 h45","0-4",0,"",1)

    Gui, Add, Text, x115 y70 w140 h15 , Graphical Progressbar...

    ;Create some text controls that contain info on the progressbars value
    Gui, Add, Text, x300 y70 w50 h15 vText1 +Right, % Progress_Get(hBar1,2) "%"
    Gui, Add, Text, x15 y70 w75 h15 vText2, % Progress_Get(hBar1,1) "/" Progress_Get(hBar1,3)

  Gui, 1:Show, w395 h100, Progress
  Return

GuiSlider:
  GuiControlGet, Slider
  ;Set the progressbar position to the sliders value
  Progress_Set(hBar1,Slider),Progress_Set(hBar2,Slider)
  GoSub, GuiUpdate
  Return

GuiUpdate:
  ;Update the percent text
  GuiControl, 1:, Text1, % Progress_Get(hBar1,2) "%"
  ;Update the external value text (Position/Range)
  GuiControl, 1:, Text2, % Progress_Get(hBar1,1) "/" Progress_Get(hBar1,3)
  Return

GuiClose:
  ExitApp

#IfWinActive, Progress

;Hide the progressbars when F1 is pressed
~F1::Progress_Hide(hBar1),Progress_Hide(hBar2)

;Show the progressbars when F2 is pressed
~F2::Progress_Show(hBar1),Progress_Show(hBar2)

;Show the progressbars visibility state when F3 is pressed
~F3::MsgBox % "hBar1: " Progress_Get(hBar1,4) "`nhBar2: " Progress_Get(hBar2,4)

;Change the internal text of the first progressbar to Hello World when F4 is pressed
~F4::Progress_SetText(hBar1,"Hello World")

;Change the slider and progressbar range from 0-4 to 0-100 when F5 is pressed
~F5::
  GuiControl, +Range0-100, Slider
  Progress_Set(hBar1,"0-100",1),Progress_Set(hBar2,"0-100",1)
  GoSub, GuiUpdate
  Return

;Set the progressbars value from 0 up to their range when F6 is pressed
~F6::
  Progress_Set(hBar1,0),Progress_Set(hBar2,0)
  Loop, % Progress_Get(hBar1,3) {
    Progress_Set(hBar1,A_Index),Progress_Set(hBar2,A_Index)
    GoSub, GuiUpdate
    Sleep, 5
  }
  Return

;Change the progressbars images
~F7::
  Progress_SetFile("P-N-2.png","P-R-2.png",hBar1)
  Return

;Show the progressbar images when pressed
~F8::MsgBox % "Background: " Progress_Get(hBar1,6) "`nProgress:  " Pro


esc::
exitapp