--[[
local status, null_ls = pcall(require, 'null-ls')
if (not status) then return end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    sources = {
        -- javascript 
        null_ls.builtins.diagnostics.eslint.with({
            prefer_local = "node_modules/.bin",
        }),
        null_ls.builtins.formatting.prettier,

        -- python
        null_ls.builtins.diagnostics.ruff.with({
            prefer_local = ".venv/bin",
        }),
        null_ls.builtins.formatting.isort.with({
            prefer_local = '.venv/bin',
        }),
        null_ls.builtins.formatting.black.with({
            prefer_local = '.venv/bin',
        }),

        --rust
        null_ls.builtins.formatting.rustfmt
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    -- vim.lsp.buf.format({ async = false })
                    vim.lsp.buf.formatting({
                        bufnr = bufnr,
                        filter = function(client)
                            return client.name == "null-ls"
                        end
                    })
                end,
            })
        end
    end,
    debug = false
})
]]
