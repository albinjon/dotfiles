local wezterm = require("wezterm")
local mux = require("wezterm").mux
local act = wezterm.action

function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

local function debug_log(message)
	file = io.open(".wezterm.log", "a") -- Open file in append mode
	file:write(dump(message) .. "\n") -- Add a new line
	file:close() -- Close the file
end

local function is_nvim_context(process, depth)
	depth = depth or 3
	if depth <= 0 then
		return false
	end

	if process.name == "nvim" then
		return true
	end

	if process.children then
		for _, child in pairs(process.children) do
			if is_nvim_context(child, depth - 1) then
				return true
			end
		end
	end

	return false
end

local wez_nvim_action = function(window, pane, action_wez, forward_key_nvim)
	local current_process = mux.get_window(window:window_id()):active_pane()
	local name = current_process:get_foreground_process_name()
	-- INFO: This is because editors can be opened through file managers.
	local process = current_process:get_foreground_process_info()
	local is_nvim = is_nvim_context(process)

	if is_nvim then
		window:perform_action(forward_key_nvim, pane)
	elseif string.match(name, "[^/]+$") == "posting" then
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
			act.SendKey({ key = "w", mods = "CTRL" }),
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
			act.SendKey({ key = "w", mods = "CTRL" }),
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
