--[[
local on_attach = function(client, bufnr)

    client.server_capabilities.documentFormattingProvider = false

    local set = vim.keymap.set
    set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
    set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
    set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")

end


local capabilities = require("cmp_nvim_lsp").default_capabilities()


require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
    function (server_name)
        require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities
        })
    end,
    ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                },
            },
        })
    end,
}


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = false,
    virtual_text = {
        format = function(diagnostic)
            return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
        end,
    },
})
]]
