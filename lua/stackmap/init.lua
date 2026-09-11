-- print("OK we loaded stackmap now")
local M = {}

M.setup = function(opts)
	print("Option", opts)
end

M.push = function(name, mode, mappings)
	local maps = vim.api.nvim_get_keymap(mode)
	P(maps)
end

M.pop = function(name) end

M.push("debug_mode", "n", {
	["<localleader>st"] = "echo 'Hello'",
	["<localleader>sz"] = "echo 'Goodbye'",
})
--[[
-- lua require
--]]
return M
