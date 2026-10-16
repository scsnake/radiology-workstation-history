using System.Windows.Forms;
using System.Windows.Automation;


class RIS {
	public void getDataGrid() {
		AutomationElement rootElement = AutomationElement.RootElement;
		if (rootElement == null) {
			return ;
		}
		
		Condition condition = new PropertyCondition(AutomationElement.NameProperty, "Radiology Information System");

		AutomationElement appElement = rootElement.FindFirst(TreeScope.Children, condition);
		int processIdentifier = (int) appElement.GetCurrentPropertyValue(AutomationElement.ProcessIdProperty);
		MessageBox.Show(processIdentifier.ToString());
		if(appElement==null){
			MessageBox.Show("Hello, world, from C#!");
		}
			
			
			
		
	}
}