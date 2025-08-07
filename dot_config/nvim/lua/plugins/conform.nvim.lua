return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "goimports" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			javascript = { "prettierd", stop_after_first = true },
			typescript = { "prettierd", stop_after_first = true },
			javascriptreact = { "prettierd", stop_after_first = true },
			typescriptreact = { "prettierd", stop_after_first = true },
			json = { "prettierd", stop_after_first = true },
			yaml = { "prettierd", stop_after_first = true },
			markdown = { "prettierd", stop_after_first = true },
			html = { "prettier", stop_after_first = true },
			css = { "prettier", stop_after_first = true },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
