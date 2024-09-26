" ~/.config/nvim/syntax/myfile.vim

" Match square brackets anywhere in the line
syntax match myBrackets /\[[^]]*\]/  " Matches square brackets

" Match angle brackets anywhere in the line
syntax match myMods /<[^>]*>/  " Matches angle brackets

" Define highlighting styles
" highlight myBrackets ctermfg=lightgreen guifg=lightgreen
" highlight myMods ctermfg=lightblue guifg=#8EDFFF

