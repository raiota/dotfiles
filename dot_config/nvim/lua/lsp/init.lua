local navic = require("nvim-navic")

local lsp_names = {
	"denols",
	"gopls",
	"jsonls",
	"lua_ls",
	"marksman",
	"pyright",
	"ruff",
	"ts_ls",
	"yamlls",
}

local augroup = vim.api.nvim_create_augroup("lsp/init.lua", {})

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method("textDocument/definition") then
			vim.keymap.set("n", "grd", function()
				vim.lsp.buf.definition()
			end, { buffer = args.buf, desc = "vim.lsp.buf.definition()" })
		end

		if client.server_capabilities.documentSymbolProvider then
			vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
			navic.attach(client, args.buf)
		end
	end,
})

vim.api.nvim_create_user_command("LspHealth", "checkhealth vim.lsp", { desc = "LSP health check" })

vim.lsp.config("*", {
	root_markers = { ".git" },
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = true,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󱩎 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

vim.lsp.enable(lsp_names)
