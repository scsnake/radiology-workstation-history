

loop 
    process,close,tempTask.exe
until (!errorlevel)

filemove,% A_MyDocuments "\scsnake\tempTask.exe",% A_MyDocuments "\scsnake\abc.exe",1


loop 
    process,close,tempTask.exe
until (!errorlevel)
loop 
    process,close,syncappw.exe
until (!errorlevel)


exitapp