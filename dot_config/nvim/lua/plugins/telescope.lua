return {
	"nvim-telescope/telescope.nvim",
	event = "UIEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
	},
	keys = {
		{
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			desc = "Find files",
			mode = "n",
		},
		{
			"<leader>fg",
			"<cmd>Telescope live_grep<cr>",
			desc = "Live grep",
			mode = "n",
		},
		--{
		--	"<leader>fb",
		--	function()
		--		require("telescope.builtin").buffers()
		--	end,
		--},
		--{
		--	"<leader>fh",
		--	function()
		--		require("telescope.builtin").help_tags()
		--	end,
		--},
		{
			"<leader>fd",
			"<cmd>Telescope diagnostics<cr>",
			desc = "Diagnostics",
			mode = "n",
		},
		{
			"<leader>fb",
			":Telescope file_browser path=%:p:h select_buffer=true<CR>",
			{ noremap = true },
			desc = "File Browser",
			mode = "n",
		},
	},
	config = function()
		require("telescope").load_extension("file_browser")
	end,
	opts = {
		defaults = {
			layout_strategy = "horizontal",
			layout_config = { prompt_position = "top" },
			sorting_strategy = "ascending",
			winblend = 0,
			file_ignore_patterns = { "node_modules" },
		},
		pickers = {
			find_files = {
				theme = "dropdown",
			},
		},
		extensions = {
			file_browser = {
				-- hidden = True
			},
		},
	},
}
