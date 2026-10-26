-- local M = {}
--
-- function M.setup(opts)
-- 	opts = opts or {}
-- 	vim.notify("whid loaded: " .. vim.inspect(opts))
-- end
--
-- return M

local M = {}
local api = vim.api
local buf, win
local position = 0
M.open_test = {}
M.open_window = function()
	buf = api.nvim_create_buf(false, true) -- create new emtpy buffer

	api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

	-- get dimensions
	local width = api.nvim_get_option_value("columns", {})
	local height = api.nvim_get_option_value("lines", {})

	-- calculate our floating window size
	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)

	-- and its starting position
	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)

	-- set some options
	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
	}
	-- local border_opts = {
	-- 	style = "minimal",
	-- 	relative = "editor",
	-- 	width = win_width + 2,
	-- 	height = win_height + 2,
	-- 	row = row - 1,
	-- 	col = col - 1,
	-- }

	-- and finally create it with buffer attached
	-- win = api.nvim_open_win(buf, true, opts)
	-- print("buff", buf, width, height)

	-- local border_buf = api.nvim_create_buf(false, true)

	-- local border_lines = { "╔" .. string.rep("═", win_width) .. "╗" }
	-- local middle_line = "║" .. string.rep(" ", win_width) .. "║"
	-- for i = 1, win_height do
	-- 	table.insert(border_lines, middle_line)
	-- end
	-- table.insert(border_lines, "╚" .. string.rep("═", win_width) .. "╝")

	-- api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)
	-- set bufer's (border_buf) lines from first line (0) to last (-1)
	-- ignoring out-of-bounds error (false) with lines (border_lines)
	-- local border_win = api.nvim_open_win(border_buf, true, border_opts)
	win = api.nvim_open_win(buf, true, opts)
	-- api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "' .. border_buf)
end

M.update_view = function(direction)
	-- Is nice to prevent user from editing interface, so
	-- we should enabled it before updating view and disabled after it.
	-- api.nvim_buf_set_option(buf, "modifiable", true)
	api.nvim_set_option_value("modifiable", true, { buf = buf })
	position = position + direction
	if position < 0 then
		position = 0
	end

	local result = vim.fn.systemlist("git diff-tree --no-commit-id --name-only -r  HEAD~" .. position)
	for k, v in pairs(result) do
		result[k] = "  " .. result[k]
	end

	api.nvim_buf_set_lines(buf, 0, -1, false, {
		M.center("What have i done?"),
		M.center("HEAD~" .. position),
		"",
	})
	api.nvim_buf_set_lines(buf, 3, -1, false, result)

	api.nvim_buf_add_highlight(buf, -1, "WhidHeader", 0, 0, -1)
	api.nvim_buf_add_highlight(buf, -1, "whidSubHeader", 1, 0, -1)

	api.nvim_buf_set_option(buf, "modifiable", false)
end

M.center = function(str)
	local width = api.nvim_win_get_width(0)
	local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
	return string.rep(" ", shift) .. str
end

M.set_mappings = function()
	local mappings = {
		["["] = "update_view(-1)",
		["]"] = "update_view(1)",
		["<cr>"] = "open_file()",
		h = "update_view(-1)",
		l = "update_view(1)",
		q = "close_window()",
		k = "move_cursor()",
	}

	for k, v in pairs(mappings) do
		api.nvim_buf_set_keymap(buf, "n", k, ':lua require"whid".' .. v .. "<cr>", {
			nowait = true,
			noremap = true,
			silent = true,
		})
	end
end

M.close_window = function()
	api.nvim_win_close(win, true)
end

-- Our file list start at line 4, so we can prevent reaching above it
-- from bottm the end of the buffer will limit movment
M.move_cursor = function()
	print("win:::::", win)
	local new_pos = math.max(4, api.nvim_win_get_cursor(win)[1] - 1)
	api.nvim_win_set_cursor(win, { new_pos, 0 })
end

-- Open file under cursor
M.open_file = function()
	local str = api.nvim_get_current_line()
	M.close_window()
	api.nvim_command("edit " .. str)
end

M.setup = function(opts)
	opts = opts or {}
	print("whid runing1")
	vim.notify("whid loaded: " .. vim.inspect(opts))
	position = 0 -- if you want to preserve last displayed state just omit this line
	M.open_window()
	M.set_mappings()
	M.update_view(0)
	print("win:" .. win)
	api.nvim_win_set_cursor(win, { 4, 0 }) -- set cursor on fir
end

return M
