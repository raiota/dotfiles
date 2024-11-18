return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  config = function()
    require("nightfox").setup({
      options = {
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled",
        transparent = true,
        terminal_colors = true,
        module_default = true,
        styles = {
          comments = "italic"
        },
      }
    })
    vim.cmd("colorscheme nightfox")
  end,
}
