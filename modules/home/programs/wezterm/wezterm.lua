local merge_all = require("util").merge_all

local misc = {
	-- github.com/NixOS/nixpkgs/issues/336069#issuecomment-2299008280
	--front_end = "WebGpu",
	unzoom_on_switch_pane = true,
	use_resize_increments = true,
	mux_enable_ssh_agent = false,
}

local appearance = require("appearance")
local keys = require("keys")
return merge_all(table.unpack({
	misc,
	appearance,
	keys,
}))
