local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ "neovim/nvim-lspconfig" },
		{ "b0o/schemastore.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
	},
	defaults = {
		lazy = false,
		version = false,
	},
	-- 更新の確認は 30 日に 1 回だけ（最後に確かめた時刻は lazy の state.json に残る）。
	-- lazy-lock.json は dotfiles で配らないので、通知が来たら各マシンで :Lazy sync する。
	checker = { enabled = true, frequency = 30 * 24 * 60 * 60 },
	performance = {
		rtp = {
			disabled_plugins = {
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
			},
		},
	},
})
