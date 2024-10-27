local wezterm = require("wezterm")
local merge_all = require("util").merge_all

local font = {
	font = wezterm.font("NotoMono Nerd Font Mono"),
	font_size = 14.0,
}

local colors = {
	color_scheme = "Catppuccin Macchiato",
	colors = {
		visual_bell = "#202020",
	},
}

local window = {
	enable_scroll_bar = false,
	scrollback_lines = 3500,
	window_padding = {
		left = "1cell",
		right = "1cell",
		bottom = 0,
		top = 0,
	},
}

local tab_bar = {
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	show_new_tab_button_in_tab_bar = false,
}

wezterm.on("update-status", function(win, pane)
	local function basename(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	local cwd = pane:get_current_working_dir()
	cwd = cwd and cwd.path or ""
	local cmd = pane:get_foreground_process_name()
	cmd = cmd and basename(cmd) or ""
	local time = wezterm.strftime("%H:%M")

	win:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.md_application_outline .. "  " .. wezterm.mux.get_active_workspace() },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_code_braces .. "  " .. cmd },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock_outline .. "  " .. time },
		{ Text = "  " },
	}))
end)

local bell = {
	audible_bell = "Disabled",
	visual_bell = {
		fade_in_function = "EaseIn",
		fade_in_duration_ms = 25,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 275,
	},
}

return merge_all(table.unpack({
	font,
	colors,
	window,
	tab_bar,
	bell,
}))
