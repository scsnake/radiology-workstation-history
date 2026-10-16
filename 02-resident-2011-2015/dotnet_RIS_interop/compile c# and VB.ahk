#include CLR.ahk

c# =
(
    using System.Windows.Forms;
    class Foo {
        public void Test() {
            MessageBox.Show("Hello, world, from C#!");
        }
    }
)
vb =
(
    Imports System.Windows.Forms
    Class Foo
        Public Sub Test()
            MessageBox.Show("Hello, world, from VB!")
        End Sub
    End Class
)

    CLR_Start()

    ; Compile and execute C# code
    asm := CLR_CompileC#(c#, "System.dll | System.Windows.Forms.dll")
    obj := CLR_CreateObject(asm, "Foo")
    obj.Test()

    obj=
    ; Note: This doesn't unload the Assembly itself, just frees the Assembly object.
    asm=

    ; Compile and execute VB code
    asm := CLR_CompileVB(vb, "System.dll | System.Windows.Forms.dll")
    obj := CLR_CreateObject(asm, "Foo")
    obj.Test()

    ; Create a .NET Form all in AHK.  Haven't figured out how to add controls yet, but I'd probably do that in C# anyway
    asm := CLR_LoadLibrary("System.Windows.Forms")
    frm := CLR_CreateObject(asm, "System.Windows.Forms.Form")
    frm.StartPosition := 1 ; FormStartPosition.CenterScreen
    frm.Text := "Hello WinForms"
    frm.ShowDialog()
    ExitApp