return {
	"SmiteshP/nvim-navic",
	enabled = true,
	event = "BufReadPre",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	opts = {
		lsp = {
			auto_attach = true,
			preference = nil,
		},
		highlight = true,
		separator = "   ",
	},
}
