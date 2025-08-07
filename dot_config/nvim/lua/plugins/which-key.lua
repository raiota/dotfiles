return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		spec = {
			{
				mode = { "n", "v" },
				{
					"<leader>a",
					group = "CopilotChat",
					icon = { icon = "" },
				},
				{ "<leader>l", group = "LSP" },
				{
					"<leader>f",
					group = "Finder",
					icon = { icon = "" },
				},
				{
					"<leader?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
	},
}
