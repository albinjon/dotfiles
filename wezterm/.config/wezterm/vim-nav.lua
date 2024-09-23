local wezterm = require("wezterm")
local mux = require("wezterm").mux
local act = wezterm.action

local wez_nvim_action = function(window, pane, action_wez, forward_key_nvim, direction, process)
	local echo = "echo " .. process .. " >> /tmp/aerospace.log"
	wezterm.run_child_process({
		"/bin/bash",
		"-c",
		echo,
	})
	-- For debugging
	-- local echo = "echo " .. current_process .. " >> /tmp/aerospace.log"
	-- wezterm.run_child_process({
	-- 	"/bin/bash",
	-- 	"-c",
	-- 	echo,
	-- })
	if process == "nvim" then
		window:perform_action(forward_key_nvim, pane)
	else
		if direction == "Split" then
			window:perform_action(action_wez, pane)
		end
		local no_neighbor = mux.get_window(window:window_id()):active_tab():get_pane_direction(direction) == nil
		if no_neighbor then
			wezterm.run_child_process({
				"aerospace",
				"focus",
				direction:lower(),
			})
			return
		end
		window:perform_action(action_wez, pane)
	end
end

wezterm.on("split-vertical", function(window, pane)
	wez_nvim_action(
		window,
		pane,
		act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		act.Multiple({
			act.SendKey({ key = "s", mods = "CTRL" }),
			act.SendKey({ key = "l" }),
		}),
		"Split",
		"nvim"
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
		}),
		"Split",
		"nvim"
	)
end)

wezterm.on("close-pane", function(window, pane)
	wez_nvim_action(
		window,
		pane,
		act.CloseCurrentPane({ confirm = false }),
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL|ALT" }),
			act.SendKey({ key = "q" }),
		}),
		"Split",
		"nvim"
	)
end)

local function get_vim_key(direction)
	if direction == "Left" then
		return "h"
	elseif direction == "Right" then
		return "l"
	elseif direction == "Down" then
		return "j"
	elseif direction == "Up" then
		return "k"
	end
end

wezterm.on("user-var-changed", function(window, pane, name, value)
	local echo = "echo " .. "var changed" .. " >> /tmp/aerospace.log"
	wezterm.run_child_process({
		"/bin/bash",
		"-c",
		echo,
	})
	local direction = value
	if name == "wez" or name == "nvim" then
		wez_nvim_action(
			window,
			pane,
			act.ActivatePaneDirection(direction),
			act.SendKey({ key = get_vim_key(direction), mods = "CTRL|ALT" }),
			direction,
			name
		)
	else
		wezterm.run_child_process({
			"aerospace",
			"focus",
			direction:lower(),
		})
	end
end)

-- wezterm.on("close-pane", function(window, pane)
-- 	wez_nvim_action(window, pane, act.CloseCurrentPane({ confirm = false }), act.SendString(":q\r"))
-- end)
