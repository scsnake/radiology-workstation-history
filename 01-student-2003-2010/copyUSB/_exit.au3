$PID1=ProcessExists("copyppt,exe")
If $PID1 Then ProcessClose($PID1)
$PID2=ProcessExists("_error.exe")
If $PID2 Then ProcessClose($PID2)