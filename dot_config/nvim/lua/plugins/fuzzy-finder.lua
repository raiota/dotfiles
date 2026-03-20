return {
	"ibhagwan/fzf-lua",
	event = "UIEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	keys = {
		{
			"<leader>ff",
			"<cmd>FzfLua files<cr>",
			desc = "Find files",
			mode = "n",
		},
		{
			"<leader>fg",
			"<cmd>FzfLua live_grep<cr>",
			desc = "Live grep",
			mode = "n",
		},
	},
}
