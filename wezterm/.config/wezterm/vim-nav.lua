local wezterm = require("wezterm")
local mux = require("wezterm").mux
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
