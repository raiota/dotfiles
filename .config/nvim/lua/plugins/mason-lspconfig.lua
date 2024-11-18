return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" }
  },
  config = function()
    require('mason').setup()

    local registry = require('mason-registry')
    local packages = {
      'css-lsp',
      'dockerfile-language-server',
      'docker-compose-language-service',
      'gopls',
      'html-lsp',
      'lua-language-server',
      'rust-analyzer',
      'typescript-language-server',
      'yaml-language-server',
    }
    registry.refresh(function ()
      for _, pkg_name in ipairs(packages) do
        local pkg = registry.get_package(pkg_name)
        if not pkg:is_installed() then
          pkg:install()
        end
      end
    end)

    require('mason-lspconfig').setup()

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

    -- local servers = {
    --   "dockerls",
    --   "docker_compose_language_service",
    --   "html",
    --   "lua_ls",
    --   "gopls",
    --   "ts_ls"
    -- }
    --
    -- for _, server in ipairs(servers) do
    --   lspconfig[server].setup {
    --     capabilities = capabilities,
    --   }
    -- end

    lspconfig.cssls.setup({ capabilities = capabilities })
    lspconfig.dockerls.setup({ capabilities = capabilities })
    lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })
    lspconfig.gopls.setup({ capabilities = capabilities })
    lspconfig.html.setup({ capabilities = capabilities })
    lspconfig.lua_ls.setup({
      on_init = function(client)
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          },
        })
      end,
      settings = {
        Lua = {}
      }
    })
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          cargo = {
            buildScripts = {
              enable = true,
            },
          },
          procMacro = {
            enable = true,
          },
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    })
    lspconfig.ts_ls.setup({ capabilities = capabilities })
    lspconfig.yamlls.setup({ capabilities = capabilities })
  end,
}
