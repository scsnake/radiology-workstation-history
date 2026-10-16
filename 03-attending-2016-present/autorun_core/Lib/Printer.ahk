GetInstalledPrinters(Delimiter="|",Default=True)
{
	if (Default = True)
	{
		regread,defaultPrinter,HKCU,Software\Microsoft\Windows NT\CurrentVersion\Windows,device
		stringsplit,defaultName,defaultPrinter,`,
		defaultName := defaultName1
		printerlist =
		loop,HKCU,Software\Microsoft\Windows NT\CurrentVersion\devices
		{
			if (A_LoopRegName = defaultname)
			printerlist = %printerlist%%A_loopRegName%%Delimiter%%Delimiter%
			else printerlist = %printerlist%%A_loopRegName%%Delimiter%
		}
	}
	else
	{
		printerlist =
		loop,HKCU,Software\Microsoft\Windows NT\CurrentVersion\devices
		{
			printerlist = %printerlist%%A_loopRegName%%Delimiter%
		}
	}
	StringTrimRight, printerlist, printerlist, StrLen(Delimiter)
	return %printerlist%
}


SetDefaultPrinter(sPrinter)
{
	DllCall("winspool.drv\SetDefaultPrinterW", "str", sPrinter)
} 


GetDefaultPrinter()
{
	nSize := VarSetCapacity(gPrinter, 256)
	DllCall("winspool.drv\GetDefaultPrinterW", "str", gPrinter, "UintP", nSize)
	Return gPrinter
}