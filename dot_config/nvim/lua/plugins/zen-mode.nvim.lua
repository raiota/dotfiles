return {
	"folke/zen-mode.nvim",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		window = {
			width = 200,
		},
	},
	keys = {
		{
			"<leader>z",
			"<cmd>ZenMode<cr>",
			desc = "Switch to Zen Mode",
			mode = "n",
		},
	},
}
