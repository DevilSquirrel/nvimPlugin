-- print("OK we loaded stackmap now")
local M = {}

-- TODO
-- TODO we someing
-- M.setup = function(opts)
-- 	print("Option", opts)
-- end
local find_mapping = function(maps, lhs)
	for _, value in ipairs(maps) do
		-- P(value)
		if value.lhs == lhs then
			return value
		end
		-- break
	end
end

M._stack = {}

M.push = function(name, mode, mappings)
	-- 获取所有模式的映射键
	local maps = vim.api.nvim_get_keymap(mode)
	local existing_maps = {}

	for lhs, rhs in pairs(mappings) do
		local existing = find_mapping(maps, lhs)
		if existing then
			table.insert(existing_maps, existing)
		end
	end
	M._stack[name] = existing_maps

	for lhs, rhs in pairs(mappings) do
		vim.keymap.set(mode, lhs, rhs)
		print(lhs, rhs)
	end

	-- P(maps)
end

M.pop = function(name) end

M.push("debug_mode", "n", {
	[" st"] = "echo 'Hello'",
	[" sz"] = "echo 'Goodbye'",
})
--[[
-- lua require
--]]
print("----------------------")
return M
