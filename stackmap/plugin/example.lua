print("hello base")

vim.keymap.set("n", "asdf", ":echo 'hellow'")

P = function(v)
	print(vim.inspect(v))
end

RELOAD = function(...)
	return require("plenary.reload").reload_module(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end
