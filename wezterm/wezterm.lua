local wezterm = require 'wezterm'

local config = wezterm.config_builder()
config.color_scheme = 'hardcore'

config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
