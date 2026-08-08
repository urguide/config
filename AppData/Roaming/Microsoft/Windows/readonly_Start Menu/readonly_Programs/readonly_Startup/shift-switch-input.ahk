#Requires AutoHotkey v2.0
#SingleInstance Force
InstallMouseHook   ; 讓滑鼠點擊也進入按鍵歷史

global shiftDown := 0

~LShift:: {
    global shiftDown
    if (shiftDown = 0)
        shiftDown := A_TickCount
}

~LShift up:: {
    global shiftDown
    held := A_TickCount - shiftDown
    shiftDown := 0
    if (A_PriorKey = "LShift" && held < 180)
        Send "^{Space}"
}