" Aesthetics
colorscheme industry
highlight MatchParen   guibg=none    guifg=#f542e6 gui=bold,underline
highlight Normal       guibg=#111111
highlight LineNr       guibg=#171717 guifg=#555555
highlight CursorLineNr guibg=#323232 guifg=#8d8d8d gui=bold,italic
highlight EndOfBuffer  guibg=#141414 guifg=#662222
highlight StatusLine   guibg=#171717 guifg=#66bb66

" Basic settings
set cursorline
set cursorlineopt=number " enable current line number customization
set mouse=               " disable mouse
set number               " Show line numbers
set relativenumber       " Show relative line numbers
set expandtab            " Use spaces instead of tabs
set tabstop=4            " Number of spaces tabs count for
set shiftwidth=4         " Number of spaces to use for each step of (auto)indent
set smartindent          " Smart indentation
set wrap                 " Wrap lines
set linebreak            " Wrap lines at word boundaries

" Custom commands
command! TrimTrailingWhitespaces %s/\s\+$//e | noh
