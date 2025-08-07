return {
	"nvimdev/lspsaga.nvim",
	opts = {
		diagnostic = {
			max_height = 0.8,
			keys = {
				quit = { "q", "<ESC>" },
			},
		},
		finder = {
			max_height = 0.7,
			left_width = 0.3,
			right_width = 0.6,
			keys = {
				shuttle = "<Space>w",
				toggle_or_open = "<CR>",
			},
		},
	},
	keys = {
		{
			"<leader>l]",
			"<cmd>Lspsaga diagnostic_jump_next<cr>",
			desc = "Next Diagnostic",
			mode = "n",
		},
		{
			"<leader>l[",
			"<cmd>Lspsaga diagnostic_jump_prev<cr>",
			desc = "Previous Diagnostic",
			mode = "n",
		},
		{
			"<leader>ld",
			"<cmd>Lspsaga peek_definition<cr>",
			desc = "Definition",
			mode = "n",
		},
		{
			"<leader>lf",
			"<cmd>Lspsaga finder<cr>",
			desc = "Finder",
			mode = "n",
		},
		{
			"<leader>lh",
			"<cmd>Lspsaga hover_doc<cr>",
			desc = "Hover Documentation",
			mode = "n",
		},
		{
			"<leader>lr",
			"<cmd>Lspsaga rename<cr>",
			desc = "Rename",
			mode = "n",
		},
		{
			"<leader>t",
			"<cmd>Lspsaga term_toggle<cr>",
			desc = "Toggle Terminal",
			mode = "n",
		},
	},
}
