return {
	"tamton-aquib/duck.nvim",
	keys = {
		{
			"<leader>dd",
			function()
				require("duck").hatch()
			end,
			desc = "Hatch a duck",
			mode = "n",
		},
		{
			"<leader>dk",
			function()
				require("duck").cook()
			end,
			desc = "Cook a duck",
			mode = "n",
		},
		{
			"<leader>da",
			function()
				require("duck").cook_all()
			end,
			desc = "Cook all ducks",
			mode = "n",
		},
	},
}
