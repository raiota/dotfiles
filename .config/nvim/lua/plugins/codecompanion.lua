return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = function ()
    require("codecompanion").setup({
      adapters = {
        copilot = function ()
          return require("codecompanion.adapters").extend("copilot")
        end
      },
      strategies = {
        chat = {
          adapter = "copilot",
        }
      }
    })
  end
}