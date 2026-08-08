; Accelerated Scrolling (AHK v2) - 距離驅動、緩和曲線版
; 設計原則:
;   - 少量滾動 = 完全原速(1x),保留精準度
;   - 連續多格才逐步加速,曲線線性緩升而非 1/x 爆衝
;   - 小數倍率累積(carry),讓 1.3x / 1.7x 這類非整數倍率真的成立
#Requires AutoHotkey v2.0
#SingleInstance Force
A_HotkeyInterval := 2000
A_MaxHotkeysPerInterval := 500
SendMode "Input"

; ===================== 手感參數 =====================
TOOLTIPS  := 0      ; 1 = 顯示目前倍率(調手感時開)
TIMEOUT   := 400    ; 間隔超過此值(ms) → session 重置回原速
IDLE_GATE := 110    ; 單格間隔 > 此值視為「精準慢滾」→ 不加速並衰減 combo
DECAY     := 2      ; 慢滾時每格扣掉的 combo 數(漸退回原速,不用整個停下)
WARMUP    := 6      ; 前 N 格完全維持原速
GAIN      := 0.30   ; warmup 之後每多一格增加的倍率
SOFT_CAP  := 6.0    ; 一般捲動的倍率上限
FAR_DIST  := 40     ; 超過此距離視為「長距離捲動」
FAR_GAIN  := 0.25   ; 長距離後每格再追加的倍率
HARD_CAP  := 20.0   ; 絕對上限(避免一格衝過整份文件)
; ===================================================

WheelUp::   Scroll("WheelUp")
WheelDown:: Scroll("WheelDown")

#SuspendExempt          ; 讓下面兩個 hotkey 在 Suspend 狀態下仍可用
#WheelUp::   Suspend()  ; Win+上滾 = 暫停/恢復
#WheelDown:: ExitApp()  ; Win+下滾 = 退出
#SuspendExempt False

Scroll(dir) {
    global TOOLTIPS, TIMEOUT, IDLE_GATE, DECAY, WARMUP, GAIN
    global SOFT_CAP, FAR_DIST, FAR_GAIN, HARD_CAP
    static dist := 0, carry := 0.0, lastTick := 0, lastDir := ""

    now := A_TickCount
    t   := now - lastTick
    lastTick := now

    ; 換方向或停頓過久 → session 重置,這一格一定是原速
    if (dir != lastDir || t > TIMEOUT) {
        lastDir := dir
        dist  := 0
        carry := 0.0
        Click(dir)
        return
    }

    ; 間隔太長 = 使用者在慢慢對位 → combo 衰減,不加速
    if (t > IDLE_GATE)
        dist := Max(dist - DECAY, 0)
    else
        dist++

    ; ---- 倍率曲線:線性、由累積距離決定,與瞬時速度脫鉤 ----
    v := 1.0
    if (dist > WARMUP) {
        v := Min(1 + (dist - WARMUP) * GAIN, SOFT_CAP)
        if (dist > FAR_DIST)
            v := Min(v + (dist - FAR_DIST) * FAR_GAIN, HARD_CAP)
    }

    ; ---- 小數累積:這是「緩和」能成立的關鍵 ----
    carry += v
    n := Floor(carry)
    carry -= n
    if (n < 1)
        n := 1

    if (TOOLTIPS && n > 1) {
        ToolTip(Format("x{:.2f} -> {}  (d={})", v, n, dist))
        SetTimer(() => ToolTip(), -TIMEOUT)
    }
    Click(dir " " n)
}
