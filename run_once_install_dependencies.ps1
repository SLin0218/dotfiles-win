Write-Host "====== [Chezmoi Setup] 开始检查并安装环境依赖 ======" -ForegroundColor Cyan

# 1. 自动安装 PSReadLine (预发布版)
if (!(Get-Module -ListAvailable PSReadLine | Where-Object { $_.Version -ge '2.3.0' })) {
    Write-Host "[1/3] 正在配置类 Linux 智能补全组件 (PSReadLine)..." -ForegroundColor Yellow
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck -AllowPrerelease -Scope CurrentUser -ErrorAction SilentlyContinue
} else {
    Write-Host "[1/3] PSReadLine 已安装，跳过。" -ForegroundColor Green
}

# 5. 自动安装 PSFzf PowerShell 模块
if (!(Get-Module -ListAvailable PSFzf)) {
    Write-Host "[5/5] 正在安装 PSFzf 模块..." -ForegroundColor Yellow
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue
    Install-Module -Name PSFzf -Force -Scope CurrentUser -ErrorAction SilentlyContinue
} else {
    Write-Host "[5/5] PSFzf 模块已安装，跳过。" -ForegroundColor Green
}

Write-Host "====== [Chezmoi Setup] 依赖检查完成 ======" -ForegroundColor Cyan
