return {
  "nvimdev/indentmini.nvim",
  event = "BufEnter",
  config = function()
    require("indentmini").setup()
    vim.cmd.highlight('IndentLine guifg=#666666')
    vim.cmd.highlight('IndentLineCurrent guifg=#81b29a')
  end
}
