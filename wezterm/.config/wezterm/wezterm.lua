-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action
require("vim-nav")
require("vim-scrollback")

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("JetBrains Mono SemiBold")
config.font_size = 16.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20
config.enable_tab_bar = false
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 2,
}
config.window_decorations = "RESIZE"
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({
			key = "b",
			mods = "ALT",
		}),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
	{
		key = "e",
		mods = "CTRL",
		action = act.EmitEvent("trigger-vim-with-scrollback"),
	},
	{
		key = "g",
		mods = "CTRL",
		action = act.SendKey({ key = "c", mods = "ALT" }),
	},
	{
		key = "f",
		mods = "CTRL",
		action = act.SendKey({ key = "t", mods = "CTRL" }),
	},
	{ key = "h", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-left" }) },
	{ key = "l", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-right" }) },
	{ key = "j", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-down" }) },
	{ key = "k", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ EmitEvent = "split-vertical" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ EmitEvent = "split-horizontal" }) },
	{ key = "s", mods = "LEADER", action = wezterm.action({ EmitEvent = "close-pane" }) },
}

return config