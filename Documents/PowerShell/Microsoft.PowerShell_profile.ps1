# =====================================================================
# 编码与环境初始化 (解决中文乱码)
# =====================================================================
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# =====================================================================
# PSReadLine 智能补全与历史记录 (体验类似 Zsh)
# =====================================================================
if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Emacs
    
    # 开启类似 zsh-autosuggestions 的历史命令灰色预测
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
    
    # Tab 键触发类 Linux 的网格菜单补全
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    
    # 上下方向键根据已输入字符筛选历史记录
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    
    # 更改预测文本颜色为暗灰色
    Set-PSReadLineOption -Colors @{ InlinePrediction = "$([char]0x1b)[38;5;244m" }


    # -----------------------------------------------------------------
    # FZF 模糊搜索集成 (类似 Linux Zsh 体验)
    # -----------------------------------------------------------------
    if (Get-Module -ListAvailable PSFzf) {
        Import-Module PSFzf

        if (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) {
            Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
        }
        
        # 替换 Tab 键：触发自动提示时，直接调用 fzf 进行交互式筛选 (极度丝滑)
        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock {
            Invoke-FzfTabCompletion
        }
    } else {
        # 如果未检测到 PSFzf，降级使用类 Linux 的标准网格菜单补全
        Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    }

}

# =====================================================================
# Starship 提示符美化引擎集成
# =====================================================================
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
} else {
    Write-Host "提示: 未检测到 starship，请运行 'winget install starship' 安装。" -ForegroundColor Yellow
} 
