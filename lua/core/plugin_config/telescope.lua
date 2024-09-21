local telescope = require('telescope')

telescope.setup{
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            "migrations",
            "venv/",
            "staticfiles/",
            "debug/",
            "cache/",
        }
    }
}




local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader><C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>cs', builtin.colorscheme, {})



