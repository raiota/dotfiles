-- インデントのサイズ
local function set_indent(tab_size, use_spaces)
  vim.bo.tabstop = tab_size
  vim.bo.shiftwidth = tab_size
  vim.bo.expandtab = use_spaces
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        set_indent(8, false)
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "typescript*",
    callback = function()
        set_indent(2, true)
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        set_indent(2, true)
    end
})
