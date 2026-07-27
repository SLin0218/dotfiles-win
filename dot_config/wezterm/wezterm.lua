local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

-- ==========================================
-- 1. 核心启动与环境配置 (PowerShell 7 & WSL)
-- ==========================================

-- 设置默认启动为 PowerShell 7 (pwsh)
config.default_prog = { "pwsh.exe", "-NoLogo" }

-- 配置右上角「+」号下拉菜单的终端列表
config.launch_menu = {
	{
		label = "PowerShell 7",
		args = { "pwsh.exe", "-NoLogo" },
	},
	{
		label = "Nix OS",
		args = { "wsl.exe", "--cd", "~" },
	},
}

-- ==========================================
-- 2. 界面与外观优化
-- ==========================================
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Consolas",
	"Microsoft YaHei",
})
config.font_size = 14.0
config.color_scheme = "Catppuccin Mocha"

-- Windows 11/10 磨砂玻璃效果
config.win32_system_backdrop = "Acrylic"
config.window_background_opacity = 0.85
-- 隐藏标题栏（仅保留调整大小的边框）
-- config.window_decorations = "RESIZE"
-- 让标签栏（Tabs）直接显示在窗口顶部，不占用额外空间
config.use_fancy_tab_bar = false
config.default_cursor_style = "BlinkingUnderline"

-- ==========================================
-- 快捷键配置 (快速新建与分屏)
-- ==========================================
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- CTRL + SHIFT + t : 快速打开下拉菜单选择终端
	{ key = "t", mods = "LEADER", action = wezterm.action.ShowLauncher },
	-- Alt + d : 水平分屏 (默认复制当前运行的 Shell)
	{ key = "%", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Alt + Shift + d : 垂直分屏
	{ key = '"', mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- 切换面板
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },

	-- 模拟 Tmux 调整窗格大小 (Ctrl + b 激活后，按 Ctrl + 方向键微调)
	{ key = "h", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "l", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "k", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "j", mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

	-- 切换标签
	{ key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = wezterm.action.ActivateTab(-1) },

	-- 进入复制模式
	{ key = "Enter", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
}

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Catppuccin Mocha",
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = { " " },
		tab_active = {
			{
				"process",
				process_to_icon = {
					["air"] = { wezterm.nerdfonts.md_language_go },
					["bacon"] = { wezterm.nerdfonts.dev_rust },
					["bat"] = { wezterm.nerdfonts.md_bat },
					["btm"] = { wezterm.nerdfonts.md_chart_donut_variant },
					["btop"] = { wezterm.nerdfonts.md_chart_areaspline },
					["bun"] = { wezterm.nerdfonts.md_hamburger },
					["cargo"] = { wezterm.nerdfonts.dev_rust },
					["cmd.exe"] = { wezterm.nerdfonts.md_console_line },
					["curl"] = wezterm.nerdfonts.md_flattr,
					["debug"] = { wezterm.nerdfonts.cod_debug },
					["default"] = wezterm.nerdfonts.md_application,
					["docker"] = { wezterm.nerdfonts.md_docker },
					["docker-compose"] = { wezterm.nerdfonts.md_docker },
					["dpkg"] = { wezterm.nerdfonts.dev_debian },
					["fish"] = { wezterm.nerdfonts.md_fish },
					["git"] = { wezterm.nerdfonts.dev_git },
					["go"] = { wezterm.nerdfonts.md_language_go },
					["kubectl"] = { wezterm.nerdfonts.md_docker },
					["kuberlr"] = { wezterm.nerdfonts.md_docker },
					["lazygit"] = { wezterm.nerdfonts.cod_github },
					["lua"] = { wezterm.nerdfonts.seti_lua },
					["make"] = wezterm.nerdfonts.seti_makefile,
					["nix"] = { wezterm.nerdfonts.linux_nixos },
					["node"] = { wezterm.nerdfonts.md_nodejs },
					["npm"] = { wezterm.nerdfonts.md_npm },
					["nvim"] = { wezterm.nerdfonts.custom_neovim },
					-- and more...
				},
				-- process_to_icon is a table that maps process to icons
			},
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = { "ram", "cpu" },
		tabline_y = { "datetime", "battery" },
		tabline_z = { "domain" },
	},
	extensions = {},
})
tabline.apply_to_config(config)

return config
