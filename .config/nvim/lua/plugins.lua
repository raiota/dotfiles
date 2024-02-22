-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugin setup
require("lazy").setup({

    -- utilities
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",

    -- colorschemes
    "EdenEast/nightfox.nvim",

    -- fuzzy finder
    {"nvim-telescope/telescope.nvim", dependencies = {"nvim-lua/plenary.nvim"}},

    -- filer
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
    },

    -- coc.nvim
    {"neoclide/coc.nvim", branch = "release"},

    -- syntax highlight
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},

    -- terminal
    {"akinsho/toggleterm.nvim", version = "*", config = true},

    -- git
    {"dinhhuy258/git.nvim"},

    {"lewis6991/gitsigns.nvim"},

    -- UI
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
          -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },

    {"nvim-lualine/lualine.nvim"},
    
    {"norcalli/nvim-colorizer.lua"},

    -- completion
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
    },
})

--[[
return require('packer').startup(function(use)

    -- # Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- # Libraries
    -- use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'

    -- ## devicons
    -- use 'nvim-tree/nvim-web-devicons'

    -- # TreeSitter
    -- ## treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    -- # FuzzyFinder
    -- ## telescope
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- # Filer
    use {
        'nvim-telescope/telescope-file-browser.nvim',
        requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
    }

    -- # LSP
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig'
    }
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use 'j-hui/fidget.nvim'

    -- # CMP
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'

    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-vsnip'

    use 'onsails/lspkind.nvim'

    use "windwp/nvim-autopairs"

    -- # Colorscheme
    -- ## nord
    use 'shaunsingh/nord.nvim'

    -- # Appearance
    -- ## UI
    use {
        'folke/noice.nvim',
        requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
    }

    -- ## lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- ## bufferline
    use {
        'akinsho/bufferline.nvim',
        tag = "v3.*",
        requires = 'nvim-tree/nvim-web-devicons'
    }

    -- ## sidebar
    use 'sidebar-nvim/sidebar.nvim'

    -- ## scroll bar
    use 'petertriho/nvim-scrollbar'


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if is_packer_bootstrap then
        require('packer').sync()
    end
end)
]]