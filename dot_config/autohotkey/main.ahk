
#Requires AutoHotkey v2.0
#SingleInstance Force
DetectHiddenWindows(True)

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

~LWin::Send("{Blind}{vkE8}")

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
; Win + H/J/K/L
; ==========================================
#h::Send("{Left}")
#j::Send("{Down}")
#k::Send("{Up}")
#l::Send("{Right}")

/**
 * 核心万能函数：通过 komorebi 内部状态查找并聚焦窗口
 * @param exeName 目标进程名，例如 "WindowsTerminal.exe"
 * @param runCmd 没找到时用于启动的命令
 */
FocusOrRun(exeName, runCmd) {
    ; 1. 在后台隐式运行 komorebic state 并捕获它的纯文本输出 (JSON)
    shell := ComObject("WScript.Shell")
    exec := shell.Exec("komorebic.exe state")
    jsonText := exec.StdOut.ReadAll()

    if (StrLen(jsonText) > 10) {
        ; 正则高效模拟 JSON 解析：匹配 hwnd 块与紧随其后的目标 exe 进程名
        if RegExMatch(jsonText, 's)"hwnd":\s*(\d+)(?:(?!"hwnd").)*?"exe":\s*"' . exeName . '"', &match) {
            Run("komorebic.exe focus-window-by-hwnd " . match[1], , "Hide")
            return
        }
    }
    Run(runCmd)
}

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

!q::Komorebic("close")
!m::Komorebic("minimize")

; Focus windows
!h::Komorebic("focus left")
!j::Komorebic("focus down")
!k::Komorebic("focus up")
!l::Komorebic("focus right")

!+[::Komorebic("cycle-focus previous")
!+]::Komorebic("cycle-focus next")

; Move windows
!+h::Komorebic("move left")
!+j::Komorebic("move down")
!+k::Komorebic("move up")
!+l::Komorebic("move right")

; Stack windows
!Left::Komorebic("stack left")
!Down::Komorebic("stack down")
!Up::Komorebic("stack up")
!Right::Komorebic("stack right")
!;::Komorebic("unstack")
![::Komorebic("cycle-stack previous")
!]::Komorebic("cycle-stack next")

; Resize
!=::Komorebic("resize-axis horizontal increase")
!-::Komorebic("resize-axis horizontal decrease")
!+=::Komorebic("resize-axis vertical increase")
!+_::Komorebic("resize-axis vertical decrease")

; Manipulate windows
!t::Komorebic("toggle-float")
!f::Komorebic("toggle-monocle")

; Window manager options
!+r::Komorebic("retile")
!p::Komorebic("toggle-pause")

; Layouts
!x::Komorebic("flip-layout horizontal")
!y::Komorebic("flip-layout vertical")

; Workspaces
!1::Komorebic("focus-workspace 0")
!2::Komorebic("focus-workspace 1")
!3::Komorebic("focus-workspace 2")
!4::Komorebic("focus-workspace 3")
!5::Komorebic("focus-workspace 4")
!6::Komorebic("focus-workspace 5")
!7::Komorebic("focus-workspace 6")
!8::Komorebic("focus-workspace 7")
!9::Komorebic("focus-workspace 8")
!0::Komorebic("focus-workspace 9")

; Move windows across workspaces
!+1::Komorebic("move-to-workspace 0")
!+2::Komorebic("move-to-workspace 1")
!+3::Komorebic("move-to-workspace 2")
!+4::Komorebic("move-to-workspace 3")
!+5::Komorebic("move-to-workspace 4")
!+6::Komorebic("move-to-workspace 5")
!+7::Komorebic("move-to-workspace 6")
!+8::Komorebic("move-to-workspace 7")
!+9::Komorebic("move-to-workspace 8")
!+0::Komorebic("move-to-workspace 9")

; ==========================================
; 适配 Komorebi 的通用跳转函数
; ==========================================
ToggleOrRunKomorebi(winTitle, exeName)
{
    ; 检查窗口是否存在（此时可以搜寻到隐藏在其他工作区的窗口）
    if WinExist(winTitle)
    {
        hwnd := WinExist(winTitle)
        WinShow(hwnd)
        ; 激活该窗口（komorebi 监听到激活后，会自动将其移至当前活动工作区并完成平铺聚焦）
        WinActivate(hwnd)
    }
    else
    {
        ; 不存在则启动
        RunWait(exeName)
    }
}

#i::
{
  ToggleOrRunKomorebi("ahk_exe WindowsTerminal.exe", "wt.exe")
}
#g::
{
  ToggleOrRunKomorebi("ahk_exe brave.exe", "brave.exe")
}

