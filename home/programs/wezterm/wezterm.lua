local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("SauceCodePro Nerd Font Mono")

config.color_scheme = "Catppuccin Macchiato"

return config
