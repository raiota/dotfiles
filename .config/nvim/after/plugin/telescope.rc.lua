local status, telescope = pcall(require, 'telescope')
if (not status) then return end

telescope.load_extension 'file_browser'

telescope.setup({
    pickers = {
        find_files = {
            hidden = true,
            theme = "dropdown"
        }
    },
    extensions = {
        file_browser = {
            -- hidden = True
        }
    }
})

local builtin = require("telescope.builtin")

-- fuzzy finder
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})

-- filer
vim.keymap.set('n', '<space>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true })
