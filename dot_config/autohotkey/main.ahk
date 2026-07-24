#Requires AutoHotkey v2.0

; 1. 强制关闭 CapsLock 的大写锁定状态，避免干扰
SetCapsLockState("AlwaysOff")

; 2. 当 CapsLock 被按下时，将其作为 Ctrl 键
*CapsLock:: {
    Send("{Blind}{Ctrl Down}")
}

; 3. 当 CapsLock 被释放时
*CapsLock Up:: {
    Send("{Blind}{Ctrl Up}")
    ; 判断如果 CapsLock 是单独按下并释放的（期间没有按过其他键），则发送 Esc
    if (A_PriorKey = "CapsLock") {
        Send("{Esc}")
    }
}

; ==========================================
; 2. 仅在 Windows Terminal 中生效的快捷键
; ==========================================
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
    ; Ctrl + ] 切换到下一个标签页
    ^]::Send("^{Tab}")
    ; Ctrl + [ 切换到上一个标签页
    ^[::Send("^+{Tab}")
#HotIf

; ==========================================
; Win + I 智能切换/打开 Windows Terminal
; ==========================================
#i:: {
    ; 尝试激活已经打开的 Windows Terminal 窗口
    if WinExist("ahk_exe WindowsTerminal.exe") {
        WinActivate("ahk_exe WindowsTerminal.exe")
    } else {
        ; 如果窗口不存在，则启动 Windows Terminal
        Run("wt.exe")
    }
}

; ==========================================
; Win + M 智能切换/打开 Emacs
; ==========================================
#m:: {
    SetTitleMatchMode 2
    ; 尝试激活已经打开的 Windows Terminal 窗口
    if WinExist("Emacs ahk_exe msrdc.exe") {
        WinActivate("Emacs ahk_exe msrdc.exe")
    } else {
        ; 如果窗口不存在，则启动 Windows Terminal
        Run("wsl.exe -- bash -ic 'emacs'", , "Hide")
    }
    SetTitleMatchMode 1
}

; ==========================================
; Win + G 智能切换/打开 Brave
; ==========================================
#g:: {
    ; 尝试激活已经打开的 Brave 窗口
    if WinExist("ahk_exe brave.exe") {
        WinActivate("ahk_exe brave.exe")
    } else {
        ; 如果窗口不存在，则启动 Windows Terminal
        Run("brave.exe")
    }
}

; ==========================================
; Win + H/J/K/L
; ==========================================
#h::Send("{Left}")
#j::Send("{Down}")
#k::Send("{Up}")
#l::Send("{Right}")

#Include "komorebi.ahk"
