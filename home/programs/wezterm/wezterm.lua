local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- github.com/NixOS/nixpkgs/issues/336069#issuecomment-2299008280
config.front_end = "WebGpu"

config.font = wezterm.font("Source Code Pro")
config.font_size = 14.0

config.color_scheme = "Catppuccin Macchiato"

-- Appearance

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.use_resize_increments = true
config.tab_bar_at_bottom = true
config.scrollback_lines = 3500
config.enable_scroll_bar = true
config.show_new_tab_button_in_tab_bar = false

wezterm.on("update-status", function(window, pane)
	local function basename(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	local cwd = pane:get_current_working_dir()
	cwd = cwd and cwd.path or ""
	local cmd = pane:get_foreground_process_name()
	cmd = cmd and basename(cmd) or ""
	local time = wezterm.strftime("%H:%M")

	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.md_application_outline .. "  " .. wezterm.mux.get_active_workspace() },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Foreground = { Color = "#e0af68" } },
		{ Text = wezterm.nerdfonts.md_code_braces .. "  " .. cmd },
		"ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock_outline .. "  " .. time },
		{ Text = "  " },
	}))
end)

config.disable_default_key_bindings = true
config.use_ime = false
config.use_dead_keys = false

config.leader = { key = "Space", mods = "CTRL" }
config.keys = {
	{ key = "Enter", mods = "LEADER", action = act.ToggleFullScreen },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

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

	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "g", mods = "LEADER", action = act.PaneSelect },
	{ key = "G", mods = "SHIFT|LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },

	-- Font size
	{ key = "0", mods = "SUPER", action = act.ResetFontSize },
	{ key = "+", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },

	{ key = "C", mods = "SUPER", action = act.CopyTo("Clipboard") },
	{ key = "V", mods = "SUPER", action = act.PasteFrom("Clipboard") },
	{ key = "F", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },

	{ key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "l", mods = "SUPER", action = act.ShowDebugOverlay },
	{ key = "n", mods = "SUPER", action = act.SpawnWindow },

	{ key = "p", mods = "LEADER", action = act.ActivateCommandPalette },
	{ key = "L", mods = "LEADER", action = act.ShowLauncher },
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
	{ key = "q", mods = "SUPER", action = act.QuitApplication },
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },

	{ key = "LeftArrow", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "DownArrow", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "LeftArrow", mods = "SHIFT|LEADER", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "DownArrow", mods = "SHIFT|LEADER", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "UpArrow", mods = "SHIFT|LEADER", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "RightArrow", mods = "SHIFT|LEADER", action = act.AdjustPaneSize({ "Right", 1 }) },
}

config.key_tables = {
	copy_mode = {
		{ key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
		{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
		{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
		{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
		{ key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "g", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
		},
		{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
		{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
	},

	search_mode = {
		{ key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
		{ key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
	},
}

return config
