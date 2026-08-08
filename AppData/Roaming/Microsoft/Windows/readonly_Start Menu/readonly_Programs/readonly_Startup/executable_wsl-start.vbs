Set ws = WScript.CreateObject("WScript.Shell")
WScript.Sleep 1000
ws.Run "wsl.exe -d arch -- sleep infinity", 0
Set ws = Nothing