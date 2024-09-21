-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = require("wezterm").mux

-- This will hold the configuration.
local config = wezterm.config_builder()
config.debug_key_events = true

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
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
local act = wezterm.action

local wez_nvim_action = function(window, pane, action_wez, forward_key_nvim)
	local current_process = mux.get_window(window:window_id()):active_pane():get_foreground_process_name()
	if string.match(current_process, "[^/]+$") == "nvim" then
		window:perform_action(forward_key_nvim, pane)
	else
		window:perform_action(action_wez, pane)
	end
end

wezterm.on("move-left", function(window, pane)
	wez_nvim_action(window, pane, act.ActivatePaneDirection("Left"), act.SendKey({ key = "h", mods = "CTRL" }))
end)

wezterm.on("move-right", function(window, pane)
	wez_nvim_action(window, pane, act.ActivatePaneDirection("Right"), act.SendKey({ key = "l", mods = "CTRL" }))
end)

wezterm.on("move-down", function(window, pane)
	wez_nvim_action(window, pane, act.ActivatePaneDirection("Down"), act.SendKey({ key = "j", mods = "CTRL" }))
end)

wezterm.on("move-up", function(window, pane)
	wez_nvim_action(window, pane, act.ActivatePaneDirection("Up"), act.SendKey({ key = "k", mods = "CTRL" }))
end)

wezterm.on("split-vertical", function(window, pane)
	wez_nvim_action(
		window,
		pane,
		act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		act.Multiple({
			act.SendKey({ key = "s", mods = "CTRL" }),
			act.SendKey({ key = "l" }),
		})
	)
end)

wezterm.on("split-horizontal", function(window, pane)
	wez_nvim_action(
		window,
		pane,
		act.SplitVertical({ domain = "CurrentPaneDomain" }),
		act.Multiple({
			act.SendKey({ key = "s", mods = "CTRL" }),
			act.SendKey({ key = "j" }),
		})
	)
end)

-- wezterm.on("close-pane", function(window, pane)
-- 	wez_nvim_action(window, pane, act.CloseCurrentPane({ confirm = false }), act.SendString(":q\r"))
-- end)
wezterm.on("close-pane", function(window, pane)
	wez_nvim_action(
		window,
		pane,
		act.CloseCurrentPane({ confirm = false }),
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "q" }),
		})
	)
end)

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

local io = require("io")
local os = require("os")
wezterm.on("trigger-vim-with-scrollback", function(window, pane)
	-- Retrieve the text from the pane
	local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

	-- Create a temporary file to pass to vim
	local name = os.tmpname()
	local f = io.open(name, "w+")
	f:write(text)
	f:flush()
	f:close()

	-- Open a new window running vim and tell it to open the file
	window:perform_action(
		act.SpawnCommandInNewTab({
			args = { "nvim", name },
		}),
		pane
	)
	-- Wait "enough" time for vim to read the file before we remove it.
	-- The window creation and process spawn are asynchronous wrt. running
	-- this script and are not awaitable, so we just pick a number.
	--
	-- Note: We don't strictly need to remove this file, but it is nice
	-- to avoid cluttering up the temporary directory.
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

return config
