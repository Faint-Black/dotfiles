" Aesthetics
colorscheme industry
hi MatchParen cterm=bold ctermbg=none ctermfg=214
hi Normal      ctermbg=232
hi LineNr      ctermbg=235 ctermfg=241
hi EndOfBuffer ctermbg=232 ctermfg=52
hi StatusLine  ctermbg=232 ctermfg=244

" Basic settings
set number         " Show line numbers
set relativenumber " Show relative line numbers
set expandtab      " Use spaces instead of tabs
set tabstop=4      " Number of spaces tabs count for
set shiftwidth=4   " Number of spaces to use for each step of (auto)indent
set smartindent    " Smart indentation
set wrap           " Wrap lines
set linebreak      " Wrap lines at word boundaries

" Custom commands
command! TrimTrailingWhitespaces %s/\s\+$//e | noh
