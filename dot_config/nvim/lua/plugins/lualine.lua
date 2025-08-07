return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lualine = require("lualine")

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		local config = {
			options = {
				icons_enabled = true,
				theme = "catppuccin",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						separater = { left = "" },
						right_padding = 2,
					},
				},
				lualine_b = {
					{
						"filetype",
						icon_only = true,
					},
					{
						"filename",
						cond = conditions.buffer_not_empty,
						symbols = {
							modified = "", -- Text to show when the file is modified.
							readonly = "", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "", -- Text to show for newly created file before first write
						},
					},
					{
						"branch",
						icon = "",
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic", "nvim_lsp" },
						sections = { "error", "warn", "info", "hint" },
						symbols = { error = " ", warn = " ", info = " ", hint = "󱩎 " },
					},
				},
				lualine_c = {
					{
						"progress",
					},
					{
						"searchcount",
						icon = "",
					},
				},
				lualine_x = {
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
						cond = conditions.hide_in_width,
					},
				},
				lualine_y = {
					{
						function()
							local msg = "No Active Lsp"
							local buf_ft = vim.bo.filetype
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if next(clients) == nil then
								return msg
							end
							for _, client in ipairs(clients) do
								local filetypes = client.config.filetypes
								if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
									return client.name
								end
							end
							return msg
						end,
						icon = "  LSP:",
					},
				},
				lualine_z = {
					{
						"filesize",
						cond = conditions.buffer_not_empty,
					},
					{
						"o:encoding",
						cond = conditions.hide_in_width,
					},
					{
						"location",
					},
				},
			},
		}
		lualine.setup(config)
	end,
}
