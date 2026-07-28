
#Requires AutoHotkey v2.0
#SingleInstance Force
; #WinActivateForce

DetectHiddenWindows(True)

; 强制关闭 CapsLock 的大写锁定状态，避免干扰
SetCapsLockState("AlwaysOff")

; 当 CapsLock 被按下时，将其作为 Ctrl 键
; *CapsLock:: {
;     Send("{Blind}{Ctrl Down}")
; }
;
; ; 3. 当 CapsLock 被释放
; *CapsLock Up:: {
;     Send("{Blind}{Ctrl Up}")
;     ; 判断如果 CapsLock 是单独按下并释放的（期间没有按过其他键），则发送 Esc
;     if (A_PriorKey = "CapsLock") {
;         Send("{Esc}")
;     }
; }

; --- 单独按下 CapsLock 发送 Esc ---
*CapsLock::
{
    Send "{Blind}{Esc}"
}

; 示例：使用 Hyper Key 组合键快捷操作
; Hyper + H/J/K/L 方向键映射

; 禁用单独按下 WIN
; ~LWin::Send("{Blind}{vkE8}")

; ==========================================
; 仅在指定 app 中生效的快捷键
; ==========================================
GroupAdd "TabeSwitchApp", "ahk_exe wezterm-gui.exe"
GroupAdd "TabeSwitchApp", "ahk_exe brave.exe"

#HotIf WinActive("ahk_group TabeSwitchApp")
    ; Ctrl + ] 切换到下一个标签页
    CapsLock & ]::Send("^{Tab}")
    ; Ctrl + [ 切换到上一个标签页
    CapsLock & [::Send("^+{Tab}")
#HotIf

; ==========================================
; Win + H/J/K/L
; ==========================================
CapsLock & k::Send "{Up}"
CapsLock & j::Send "{Down}"
CapsLock & h::Send "{Left}"
CapsLock & l::Send "{Right}"

CapsLock & f::
{
  WinMaximize("A")
}

; ==========================================
; 触发 app
; ==========================================
ToggleApp(winTitle, exeName)
{
    ; 检查窗口是否存在（此时可以搜寻到隐藏在其他工作区的窗口）
    if WinExist(winTitle)
    {
        WinActivate(winTitle)
    }
    else
    {
        Run(exeName)
        WinWait(winTitle)
        WinMaximize
    }
}

CapsLock & i::
{
  ToggleApp("ahk_exe wezterm-gui.exe", "wezterm-gui.exe")
}
CapsLock & g::
{
  ToggleApp("ahk_exe brave.exe", "brave.exe")
}
CapsLock & u::
{
  ToggleApp("WeLink", "WeLink.exe")
}
CapsLock & o::
{
  ToggleApp("ahk_class WeWorkWindow", "WXWork.exe")
}

CapsLock & m::
{
    ; 判断包含 "Emacs" 且属于 msrdc.exe (WSLg) 的窗口
    if WinActive("Emacs ahk_exe msrdc.exe")
    {
        ; 当前聚焦在 Emacs -> 最小化
        WinMinimize("A")
    }
    else if WinExist("Emacs ahk_exe msrdc.exe")
    {
        ; 已打开 Emacs -> 切换到最前
        WinActivate("Emacs ahk_exe msrdc.exe")
    }
    else
    {
        ; 未启动 -> 后台静默启动
        Run("wsl.exe -- exec emacs", , "Hide")
    }
}

#HotIf WinActive("Emacs ahk_exe msrdc.exe")
CapsLock & Space::Send("^{\}")
#HotIf
#HotIf !WinActive("Emacs ahk_exe msrdc.exe")
CapsLock & Space::Send("^{Space}")
#HotIf
