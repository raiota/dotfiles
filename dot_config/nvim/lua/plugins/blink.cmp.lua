return {
	"saghen/blink.cmp",
	dependencies = {
		"fang2hou/blink-copilot",
	},
	version = "*",
	event = { "InsertEnter", "CmdLineEnter" },
	opts = {
		keymap = {
			preset = "default",
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			menu = {
				border = "single",
			},
			documentation = {
				auto_show = true,
				window = {
					border = "single",
				},
			},
		},
		signature = {
			window = {
				border = "single",
			},
		},
		sources = {
			default = { "snippets", "lsp", "path", "buffer", "copilot" },
			per_filetype = {
				markdown = { "snippets", "lsp", "path" },
			},
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},
		snippets = { preset = "luasnip" },
	},
	opts_extend = { "sources.default" },
}
