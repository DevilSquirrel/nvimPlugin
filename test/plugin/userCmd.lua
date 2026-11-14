vim.api.nvim_create_user_command("Sayselect", function(opts)
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
end, { range = true })

vim.api.nvim_create_user_command("Sayinput", function(opts)
	local inputOpts = { prompt = "请输入名称", default = "hello" }
	vim.ui.input(inputOpts, function(input)
		print("input：", input)
		if input == nil then
			print("没有输入内容")
		elseif input == "" then
			print("输入了空字符串")
			local id = vim.ui.img.set(
				vim.fn.readblob("C:/Users/Administrator/Desktop/桌面/1_ad1388.jpg"),
				{ row = 5, col = 10, width = 40, height = 20, zindex = 50 }
			)

			-- Update the image position
			vim.ui.img.set(id, { row = 8, col = 12 })

			-- Retrieve the current image opts
			local opts = vim.ui.img.get(id)

			-- Remove the image
			vim.ui.img.del(id)

			-- Remove all images
			vim.ui.img.del(math.huge)
		else
			print(input)
		end
	end)
end, { range = true })
