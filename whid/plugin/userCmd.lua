vim.api.nvim_create_user_command("SayHello", function(opts)
	local line1 = opts.line1 - 1
	local line2 = opts.line2
	print("Hello Liuyc", line1, line2)

	local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)

	-- print(vim.inspect(lines))
	print(lines)
	-- 把选中行替换成新的内容
	-- vim.api.nvim_buf_set_lines(0, line1, line2, false, {
	-- 	lines,
	-- 	"-- 替换后的内容2",
	-- })
end, { range = true })
