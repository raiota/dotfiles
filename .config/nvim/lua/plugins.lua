local ensure_packer = function()
    local fn = vim.fn
    local packer_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

    if fn.empty(fn.glob(packer_path)) > 0 then
        fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            packer_path,
        })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local is_packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)

    -- # Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- # Libraries
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'

    -- ## devicons
    use 'nvim-tree/nvim-web-devicons'

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
