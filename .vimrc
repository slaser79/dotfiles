set relativenumber
set hlsearch
set cursorline
inoremap jk <ESC>

call plug#begin('~/.vim/plugged')

Plug 'LnL7/vim-nix'
Plug 'hzchirs/vim-material'
Plug 'morhetz/gruvbox'

call plug#end()

set background=dark
"hi CursorLine   cterm=NONE ctermbg=lightred ctermfg=white guibg=lightred guifg=white
hi CursorLine   cterm=NONE ctermbg=darkblue guibg=darkblue 

"required to make vim work in tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

colorscheme gruvbox

