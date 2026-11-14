local M = {}
local api = vim.api
M.open_test = function()
	print("open_test")
end

M.setup = function(opts)
	opts = opts or {}
	-- print("test runing", vim.inspect(opts))
end

M.input = function()
	local inputOpts = { prompt = "请输入名称", default = "hello" }
	vim.ui.input(inputOpts, function(input)
		print("input：", input)
		if input == nil then
			print("没有输入内容")
		elseif input == "" then
			print("输入了空字符串")
		else
			print(input)
		end
	end)
end

M.select = function()
	vim.ui.select({ "tabs", "spaces" }, {
		prompt = "Select tabs or spaces:",
		format_item = function(item)
			return ("I choose %s!"):format(item)
		end,
	}, function(choice)
		print("choice:", choice)
		-- vim.o.expandtab = choice == "spaces"
		vim.opt.number = choice == "spaces"
		vim.print(('Selected "%s" => expandtab=%s'):format(choice, vim.o.expandtab))
	end)
end

return M
