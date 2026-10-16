#include <CLR>
SetTitleMatchMode,2

;~ process,exist,Menu.exe
;~ msgbox % errorlevel

c# =
(
    using System;
    using System.Diagnostics;
    using System.Windows.Forms;    
    using System.Windows.Automation;    
    class foo {
        public void Test(){
            int id = System.Diagnostics.Process.GetProcessesByName("Menu")[0].Id;
            MessageBox.Show(System.Convert.ToString(id));
            AutomationElement desktop = AutomationElement.RootElement;

            AutomationElement bw = desktop.FindFirst(TreeScope.Children, new PropertyCondition(AutomationElement.ProcessIdProperty, id));

            AutomationElement datagrid = bw.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.AutomationIdProperty, "dgHisReport"));
            
            MessageBox.Show("Hello, world, from C#!");
        }
    }
)

    CLR_Start()

    ; Compile and execute C# code
    asm := CLR_CompileC#(c#, "System.dll | System.Windows.Forms.dll | C:\WINDOWS\system32\uiautomationcore.dll")
    obj := CLR_CreateObject(asm, "Foo")
    obj.Test()

    ExitApp
    
    
    
    /*
    AutomationElement desktop = AutomationElement.RootElement;

            AutomationElement bw = desktop.FindFirst(TreeScope.Children, new PropertyCondition(AutomationElement.ProcessIdProperty, id));

            AutomationElement datagrid = bw.FindFirst(TreeScope.Children, new PropertyCondition(AutomationElement.AutomationIdProperty, "lv"));
    */