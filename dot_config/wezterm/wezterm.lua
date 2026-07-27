
local wezterm = require 'wezterm'
local config = wezterm.config_builder()


config.color_scheme = "Catppuccin Mocha"

-- ==========================================
-- 1. 核心启动与环境配置 (PowerShell 7 & WSL)
-- ==========================================

-- 设置默认启动为 PowerShell 7 (pwsh)
config.default_prog = { 'pwsh.exe', '-NoLogo' }

-- 配置右上角「+」号下拉菜单的终端列表
config.launch_menu = {
  {
    label = 'PowerShell 7',
    args = { 'pwsh.exe', '-NoLogo' },
  },
  {
    label = 'Nix OS',
    args = { 'wsl.exe', '--cd', '~' },
  }
}

-- ==========================================
-- 2. 界面与外观优化
-- ==========================================
config.font = wezterm.font_with_fallback({
  'JetBrains Mono',
  'Consolas',
  'Microsoft YaHei',
})
config.font_size = 14.0
config.color_scheme = "Catppuccin Mocha"

-- Windows 11/10 磨砂玻璃效果
config.win32_system_backdrop = 'Acrylic'
config.window_background_opacity = 0.85
-- 隐藏标题栏（仅保留调整大小的边框）
config.window_decorations = "RESIZE"
-- 让标签栏（Tabs）直接显示在窗口顶部，不占用额外空间
config.use_fancy_tab_bar = false

-- ==========================================
-- 3. 快捷键配置 (快速新建与分屏)
-- ==========================================
-- 定义主键为 Alt
config.leader = { key = 'a', mods = 'ALT', timeout_milliseconds = 1000 }

config.keys = {
  -- Alt + p : 快速打开下拉菜单选择终端
  { key = 'p', mods = 'ALT', action = wezterm.action.ShowLauncher },

  -- Alt + d : 水平分屏 (默认复制当前运行的 Shell)
  { key = 'd', mods = 'ALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- Alt + Shift + d : 垂直分屏
  { key = 'D', mods = 'ALT|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Alt + t : 新建默认标签页
  { key = 't', mods = 'ALT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },

  -- Alt + 方向键 : 在分屏间切换焦点
  { key = 'LeftArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
}

return config
