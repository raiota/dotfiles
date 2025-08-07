return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	priority = 1000,
	opts = {
		preset = "ghost",
		transparent_background = true,
		options = {
			show_source = {
				enabled = true,
				if_many = true,
			},
			multiline = {
				enabled = true,
				always_show = true,
			},
			--throttle = 0,
			--enable_on_insert = true,
		},
	},
}
