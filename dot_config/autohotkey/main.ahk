
#Requires AutoHotkey v2.0
#SingleInstance Force
DetectHiddenWindows(True)

; 强制关闭 CapsLock 的大写锁定状态，避免干扰
SetCapsLockState("AlwaysOff")

; 当 CapsLock 被按下时，将其作为 Ctrl 键
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

; 禁用单独按下 WIN
~LWin::Send("{Blind}{vkE8}")

; ==========================================
; 仅在指定 app 中生效的快捷键
; ==========================================
GroupAdd "TabeSwitchApp", "ahk_exe WindowsTerminal.exe"
GroupAdd "TabeSwitchApp", "ahk_exe brave.exe"

#HotIf WinActive("ahk_group TabeSwitchApp")
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

; 初始化全局变量
InMarkMode := false    ; 是否进入了标记模式
SelectMode := false    ; 是否开启了选择模式（类似 Vim 的 v 键）

; 2. 只有在标记模式下，按键才生效
#HotIf WinActive("ahk_exe WindowsTerminal.exe")

;  进入标记模式 (Ctrl + Shift + Enter)
^+Enter:: {
    global InMarkMode := true
    global SelectMode := false ; 每次进入时默认关闭选择模式
    Send("^+m")
    UpdateStatusIndicator()    ; 显示提示
}

#HotIf InMarkMode
; 【核心：按 v 键切换选择模式】
v:: {
    global SelectMode := !SelectMode ; 取反，按一次开启，再按一次关闭
    UpdateStatusIndicator()    ; 显示提示
}

; 核心移动逻辑：根据 SelectMode 自动决定是否加 Shift (+)
h:: Send(SelectMode ? "+{Left}" : "{Left}")
j:: Send(SelectMode ? "+{Down}" : "{Down}")
k:: Send(SelectMode ? "+{Up}" : "{Up}")
l:: Send(SelectMode ? "+{Right}" : "{Right}")
^:: Send(SelectMode ? "+{Home}" : "{Home}")
$:: Send(SelectMode ? "+{End}" : "{End}")

y:: {
    global InMarkMode := false
    Send(SelectMode ? "^+c" : "")
    global SelectMode := false
    UpdateStatusIndicator()          ; 移除提示
}

q:: {
    global InMarkMode := false
    global SelectMode := false
    UpdateStatusIndicator()          ; 移除提示
}

Esc:: {
    global InMarkMode := false
    global SelectMode := false
    UpdateStatusIndicator()          ; 移除提示
    Send("{Esc}")
}
#HotIf

#HotIf

; ================== 核心指示器函数 ==================
UpdateStatusIndicator() {
    global InMarkMode, SelectMode

    ; 如果退出了模式，直接关闭提示
    if (!InMarkMode) {
        ToolTip()
        return
    }

    ; 根据当前状态组装文字
    statusText := SelectMode ? "模式: -- VISUAL --" : "模式: -- NORMAL --"

    ; 获取当前活动窗口（终端）的位置，把提示框固定在终端窗口的右上角
    if WinExist("A") {
        WinGetPos(&X, &Y, &W, &H, "A")
        ; 提示框显示在终端内部右上角，向下向左偏移一点防止贴边
        ToolTip(statusText, X, Y)
    } else {
        ToolTip(statusText) ; 备用：如果获取不到窗口，直接显示在鼠标光标旁
    }
}
