return {
  "nvim-telescope/telescope.nvim",
  event = "UIEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    {
      "<leader>ff",
      function() require("telescope.builtin").find_files() end,
    },
    {
      "<leader>fg",
      function() require("telescope.builtin").live_grep() end,
    },
    {
      "<leader>fb",
      function() require("telescope.builtin").buffers() end,
    },
    {
      "<leader>fh",
      function() require("telescope.builtin").help_tags() end,
    },
    {
      "<leader>fd",
      function() require("telescope.builtin").diagnostics() end,
    },
    {
      "<space>fb",
      ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
      { noremap = true }
    }
  },
  config = function()
    require("telescope").load_extension("file_browser")
  end,
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      file_ignore_patterns = { "node_modules" }
    },
    pickers = {
      find_files = {
        theme = "dropdown"
      }
    },
    extensions = {
      file_browser = {
        -- hidden = True
      }
    }
  }
}
