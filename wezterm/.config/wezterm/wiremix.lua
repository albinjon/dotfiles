local wezterm = require("wezterm")
local mux = require("wezterm").mux
local act = wezterm.action

local wez_mix_action = function(window, pane, action_wez)
	local current_process = mux.get_window(window:window_id()):active_pane():get_foreground_process_name()
	-- INFO: For checking the process name.
	-- os.execute("notify-send 'Current process' '" .. current_process .. "'")
	if string.match(current_process, "[^/]+$") == "wiremix" then
		window:perform_action(action_wez, pane)
	else
		window:perform_action(act.SendKey({ key = "Escape" }), pane)
	end
end

wezterm.on("escape", function(window, pane)
	wez_mix_action(window, pane, act.CloseCurrentPane({ confirm = false }))
end)
