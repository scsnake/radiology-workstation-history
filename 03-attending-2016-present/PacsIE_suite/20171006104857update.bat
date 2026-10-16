TITLE Updating...
@echo off
ping 1.1.1.1 -n 1 -w 3000
xcopy "F:\scripts\radiology\pacsie\20171006104856_update_simpleRIS" "F:\scripts\radiology\pacsie" /c /q /i /s /e /k /h /y
echo 20171006104857 > "F:\scripts\radiology\pacsie\lastUpdate_simpleRIS"
attrib +h "F:\scripts\radiology\pacsie\lastUpdate_simpleRIS"
start "" "F:\scripts\radiology\pacsie\simpleRIS.exe"
rd "F:\scripts\radiology\pacsie\20171006104856_update_simpleRIS" /s /q
(goto) 2>nul & del "%~f0"