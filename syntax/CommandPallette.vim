" ~/.config/nvim/syntax/myfile.vim

" Match square brackets anywhere in the line
syntax match myBrackets /\[[^]]*\]/  " Matches square brackets

" Match angle brackets anywhere in the line
syntax match myMods /<[^>]*>/  " Matches angle brackets

" Define highlighting styles
highlight myBrackets ctermfg=green guifg=green
highlight myMods ctermfg=cyan guifg=cyan

