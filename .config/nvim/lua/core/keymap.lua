local function opts(desc)
  return { desc = desc, noremap = true, silent = true }
end

-- lsp
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts("Open float"))
vim.keymap.set("n", "[d",
  function()
    vim.diagnostic.jump({ count = -1, float = true })
  end,
opts("Pre diagnostic"))
vim.keymap.set("n", "]d",
  function()
    vim.diagnostic.jump({ count=1, float=true })
  end,
opts("Next diagnostic"))

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local function lsp(desc)
      if desc then
        desc = "LSP: " .. desc
      end
      return { desc = desc, buffer = ev.buf }
    end

    -- リネーム
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, lsp("[r]e[n]ame"))

    -- 関数の引数表示
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, lsp("signature"))

    -- 宣言へ移動
    -- ：次のエラーが発生するため停止中
    --     method textDocument/declaration is not supported by any of the servers registered for the current buffer
    -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, lsp("[g]oto [D]eclaration"))

    -- 実装へ移動
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, lsp("[g]oto [i]mplementation"))

    -- 定義へ移動
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, lsp("[g]oto [d]efinition"))

    -- 呼び出し元へ移動
    vim.keymap.set("n", "gr", vim.lsp.buf.references, lsp("[g]oto [r]eferences"))

    -- 定義をホバー
    vim.keymap.set("n", "H", vim.lsp.buf.hover, lsp("H"))

    -- 型定義へ移動
    vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, lsp("type [D]efinition"))

    -- コードアクション
    vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, lsp("[c]ode [a]ction"))

  end,
})

-- Code Companion
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ccc CodeCompanionChat]])
