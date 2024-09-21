vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.netrw_wrowse_split = 0
vim.g.netrw_banner = 0

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.cursorline = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false


-- set completion height
vim.opt.pumheight = 5


vim.cmd [[ set noswapfile ]]
vim.cmd [[ set termguicolors ]]

-- disables the auto line break for .html and .js files
vim.cmd [[ autocmd BufRead,BufNewFile *.html,*.js set nowrap ]]
vim.cmd [[ autocmd BufRead,BufNewFile *.html setlocal filetype=html ]]

--Line numbers
vim.wo.number = true
vim.wo.relativenumber = true


-- Initialize Themes
if vim.g.current_theme == nil then
    vim.g.current_theme = ReadTheme()
end
vim.cmd("Theme " .. THEMES[vim.g.current_theme])

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Set conceal level
vim.opt.conceallevel = 2

-- Define syntax match and highlight linking in an autocmd group
vim.cmd([[
  augroup CustomSyntax
    autocmd!
    autocmd FileType * syntax match singleArrow '->' conceal cchar=→
    autocmd FileType * syntax match doubleArrow '=>' conceal cchar=⟹
    autocmd FileType * highlight default link singleArrow Normal
    autocmd FileType * highlight default link doubleArrow Normal
  augroup END
]])

vim.cmd('autocmd FileType html,vue,django,javascript setlocal filetype=html')
