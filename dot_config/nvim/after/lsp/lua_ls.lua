return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				pathStrict = true,
				path = {
					"?.lua",
					"?/init.lua",
				},
			},
		},
		workspace = {
			checkThirdParty = "Disable",
			library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
				vim.env.VIMRUNTIME,
				"${3rd}/luv/library",
				"${3rd}/busted/library",
				"${3rd}/luassert/library",
			}),
		},
	},
}
