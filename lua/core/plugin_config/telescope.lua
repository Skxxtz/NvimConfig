local telescope = require('telescope')
local appendix
if UserSettings.Os.Platform == "Windows_NT" then
    appendix = "\\"
else
    appendix = "/"
end

telescope.setup{
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            "migrations",
            "venv" .. appendix,
            "staticfiles" .. appendix,
            "debug" .. appendix,
            "cache" .. appendix,
            ".git" .. appendix,
            ".cargo" .. appendix,
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



