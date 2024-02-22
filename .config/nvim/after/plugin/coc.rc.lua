local status, coc = pcall(require, "coc")
if (not status) then return end

-- status line
vim.opt.statusline:prepend("%{coc#status()}")

vim.g.coc_global_extensions = {
    "coc-black-formatter",
    "coc-copilot",
    "coc-css",
    "coc-cssmodules",
    "coc-diagnostic",
    "coc-docker",
    "coc-eslint",
    "coc-git",
    "coc-go",
    "coc-golines",
    "coc-graphql",
    "coc-html",
    "coc-html-css-support",
    "coc-json",
    "coc-lua",
    "coc-mypy",
    "coc-nginx",
    --"coc-prettier",
    "coc-pydocstring",
    "coc-pylsp",
    "coc-ruff",
    "coc-rust-analyzer",
    "coc-sql",
    "coc-toml",
    "coc-tsserver",
    "coc-yaml",
}
