local wezterm = require("wezterm")
local act = wezterm.action
local concat_arrays = require("util").concat_arrays

local leader = { key = "Space", mods = "CTRL" }

local normal_window = {
	{ key = "Enter", mods = "LEADER", action = act.ToggleFullScreen },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "LeftArrow", mods = "CTRL", action = act.ResetFontSize },
	{ key = "UpArrow", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "DownArrow", mods = "CTRL", action = act.DecreaseFontSize },
}

local normal_tabs = {
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "(", mods = "SHIFT|LEADER", action = act.ActivateTabRelative(1) },
	{ key = ")", mods = "SHIFT|LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "l", mods = "LEADER", action = act.ActivateLastTab },
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },
	{ key = "0", mods = "LEADER", action = act.ActivateTab(9) },
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
}

local normal_panes = {
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "g", mods = "LEADER", action = act.PaneSelect },
	{ key = "G", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	{ key = "H", mods = "CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "J", mods = "CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "K", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "L", mods = "CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
}

local normal_scrollback = {
	{ key = "y", mods = "LEADER", action = act.CopyTo("Clipboard") },
	{ key = "p", mods = "LEADER", action = act.PasteFrom("Clipboard") },
	{ key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "K", mods = "LEADER", action = act.ClearScrollback("ScrollbackOnly") },
}

local normal_workspaces = {
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "W",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
}

local normal_launchers = {
	{ key = "?", mods = "LEADER", action = act.ShowDebugOverlay },
	{ key = "P", mods = "LEADER", action = act.ActivateCommandPalette },
	{ key = "L", mods = "LEADER", action = act.ShowLauncher },
}

local copy_movement = {
	-- hjkl
	{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
	{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
	{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
	{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },

	-- word
	{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
	{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
	{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },

	-- line position
	{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
	{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
	{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
	{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
	{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
	{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },

	-- jump
	{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
	{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
	{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
	{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
	{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
	{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },

	-- selection
	{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
	{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },

	-- viewport
	{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
	{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
	{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },

	-- scrollback
	{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
	{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
	{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
	{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
	{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
	{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
	{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
	{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
}

local copy_actions = {
	{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
	{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
	{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
	{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
	{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
	{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
	{
		key = "y",
		mods = "NONE",
		action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
	},
}

local search = {
	{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
	{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },

	{ key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
	{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
	{ key = "P", mods = "CTRL", action = act.CopyMode("PriorMatchPage") },
	{ key = "P", mods = "CTRL", action = act.CopyMode("PriorMatchPage") },

	{ key = "Enter", mods = "SHIFT", action = act.CopyMode("NextMatch") },
	{ key = "n", mods = "CTRL", action = act.CopyMode("PriorMatch") },
	{ key = "N", mods = "CTRL", action = act.CopyMode("PriorMatchPage") },
	{ key = "N", mods = "CTRL", action = act.CopyMode("PriorMatchPage") },

	{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
	{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
}

local keys = concat_arrays(table.unpack({
	normal_window,
	normal_tabs,
	normal_panes,
	normal_scrollback,
	normal_workspaces,
	normal_launchers,
}))

local copy_mode = concat_arrays(table.unpack({
	copy_movement,
	copy_actions,
}))

local search_mode = search

local key_tables = {
	copy_mode = copy_mode,
	search_mode = search_mode,
}

return {
	disable_default_key_bindings = true,
	use_ime = false,
	use_dead_keys = false,
	leader = leader,
	keys = keys,
	key_tables = key_tables,
}
