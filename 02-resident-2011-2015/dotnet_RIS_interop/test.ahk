
#include CLR.ahk
;~ #include <ImportTypeLib>
#NoEnv
SetWorkingDir, %A_ScriptDir%


CLR_start()
pasm:=CLR_LoadLibrary("Microsoft.Office.Interop.PowerPoint.dll")

ppt:= CLR_CreateObject(pasm,"Microsoft.Office.Interop.PowerPoint.ApplicationClass")
presentations:=COM_invoke(ppt,"Presentations")
msgbox % com_invoke(presentation,"Count")




/*
c#=
(
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PowerPoint = Microsoft.Office.Interop.PowerPoint;

namespace readPPT
{
    class Program
    {
        static void Main(string[] args)
        {
            Microsoft.Office.Interop.PowerPoint.Application PowerPoint_App = new Microsoft.Office.Interop.PowerPoint.Application();
            Microsoft.Office.Interop.PowerPoint.Presentations multi_presentations = PowerPoint_App.Presentations;
            Microsoft.Office.Interop.PowerPoint.Presentation presentation = multi_presentations.Open(@"D:\test.pptx");
            string presentation_text = "";
            for (int i = 0; i < presentation.Slides.Count; i++)
            {
                foreach (var item in presentation.Slides[i+1].Shapes)
                {
                    var shape = (PowerPoint.Shape)item;
                    if (shape.HasTextFrame == MsoTriState.msoTrue)
                    {
                        if (shape.TextFrame.HasText == MsoTriState.msoTrue)
                        {
                            var textRange = shape.TextFrame.TextRange;
                            var text = textRange.Text;
                            presentation_text += text+" ";
                        }
                    }
                }
            }
            PowerPoint_App.Quit();
            MessageBox.Show(presentation_text);
        }
    }
}
)

CLR_Start()

asm := CLR_CompileC#(c#, "System.dll | System.Windows.Forms.dll | Microsoft.Office.Interop.PowerPoint.dll")
obj := CLR_CreateObject(asm, "readPPT")
COM_Invoke(obj, "Program")
COM_Release(obj)
; Note: This doesn't unload the Assembly itself, just frees the Assembly object.
COM_Release(asm)


