GetFullPath(path) {
	VarSetCapacity(fullpath, 260 * (!!A_IsUnicode + 1))
	if DllCall("GetFullPathName", "Str", path, "UInt", 260, "Ptr", &fullpath, "Ptr", 0, "UInt")
		return fullpath,VarSetCapacity(fullpath,-1)
}
