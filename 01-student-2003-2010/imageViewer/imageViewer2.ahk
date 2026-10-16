
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1


;~ #include gdip.ahk   ;Tic's gdip library  http://www.autohotkey.com/forum/topic32238.html 


If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}

Gui, 1:  -Caption +E0x80000 +LastFound +OwnDialogs +Owner +hwndhwnd +alwaysontop
Gui, 1: Show, NA ,dialog
Gui, 2:  -Caption +E0x80000 +LastFound +OwnDialogs +Owner +hwndhwnd2 +alwaysontop
Gui, 2: Show, NA x0 y0,dialog


w:=h:=300

hbm := CreateDIBSection(w,h)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
pGraphics:=Gdip_GraphicsFromHDC(hdc)

Gdip_GraphicsClear(pGraphics, 0xc0000000)
UpdateLayeredWindow(hwnd, hdc,(a_screenwidth-w)//2,(a_screenheight-h)//2,w,h)

hbm2 := CreateDIBSection(w,h)
;~ hdc := CreateCompatibleDC()
obm2 := SelectObject(hdc, hbm2)
pGraphics2:=Gdip_GraphicsFromHDC(hdc)

Gdip_GraphicsClear(pGraphics2, 0xc0000000)
UpdateLayeredWindow(hwnd2, hdc,(a_screenwidth-w)//2-100,(a_screenheight-h)//2-100,w,h)
counter:=1
counter2:=2
gosub create_array
settimer,update,1000
OnMessage(0x201, "WM_LBUTTONDOWN")
Return

update:
gui,1:hide
counter:=counter<4 ? counter : 1
counter2:=counter2<4 ? counter2 : 1
cImg:=img[counter]
cImg2:=img[counter2]
;~ obm := SelectObject(hdc, hbm)
Gdip_DrawImage(pGraphics, cImg.pBm, (w-cImg.nw)//2,(h-cImg.nh)//2,cImg.nw,cImg.nh)
UpdateLayeredWindow(hwnd, hdc)
;~ obm2 := SelectObject(hdc, hbm2)
Gdip_DrawImage(pGraphics2, cImg2.pBm, (w-cImg2.nw)//2,(h-cImg2.nh)//2,cImg2.nw,cImg2.nh)
UpdateLayeredWindow(hwnd2, hdc)
counter++
counter2++
gui,1:show
return

create_array:
img:={}
loop 4
{
sfile=%a_scriptdir%\%A_Index%.jpg
pBitmap:=Gdip_CreateBitmapFromFile(sFile)
width:=Gdip_GetImageWidth(pBitmap)
height:=Gdip_GetImageHeight(pBitmap)
img[A_Index]:={pbm:pBitmap,name:sFile,nW:width,nH:height}
}
return

esc::
loop 4
  {
  cImg:=img[A_Index]
  Gdip_DisposeImage(cImg.pbm)
  }
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(pGraphics)
SelectObject(hdc, obm2)
DeleteObject(hbm2)
DeleteDC(hdc)
Gdip_DeleteGraphics(pGraphics2)

Gdip_Shutdown(pToken)
exitapp

WM_LBUTTONDOWN()
{
	PostMessage, 0xA1, 2
}

