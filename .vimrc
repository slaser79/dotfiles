set relativenumber
set hlsearch
set cursorline
set cursorcolumn
set nowrap
set et

set relativenumber
set hlsearch
set cursorline
set nowrap
set et
syntax on 
filetype plugin indent on

"Keyboard shortcuts
inoremap jk <ESC>
inoremap <c-s> <Esc>:update<CR>
noremap <c-s> :update<CR>

call plug#begin('~/.vim/plugged')

Plug 'LnL7/vim-nix'
Plug 'hzchirs/vim-material'
Plug 'dkasak/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'neovimhaskell/haskell-vim' 
Plug 'drewtempelmeyer/palenight.vim'
Plug 'habamax/vim-sendtoterm'

call plug#end()

set background=dark
"hi CursorLine   cterm=NONE ctermbg=lightred ctermfg=white guibg=lightred guifg=white
"hi CursorLine   cterm=NONE ctermbg=darkblue guibg=darkblue 

"required to make vim work in tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

"Airline extension overrides
let g:airline#extension#tabline#enabled = 1

"CtrlP setup
"
if executable('rg')
	set grepprg=rg\ --color=never
	let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
	let g:ctrlp_use_caching = 0
endif

let g:gruvbox_italic=1
colorscheme gruvbox


"settings for Haskell-vim
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

let g:haskell_classic_highlighting = 1
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1
let g:cabal_indent_section = 2
"
"sending automatic build comands to repl
"Not modified for Neovim yet

fun! Get_terminal_windows()
	return map(filter(copy(getwininfo()), {k,v -> getbufvar(v.bufnr, '&buftype') == 'terminal'}), 'v:val')
endfu

"
fu! SendCommandToTerminal(...)
	let terms = Get_terminal_windows()
	if len(terms) < 1
		echomsg "There is no visible terminal!"
		return
	endif

	if !a:0
		let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
		return 'g@'
	endif


	let term_window = terms[0].winnr
	if len(terms) > 1
		let msg =  "Too many terminals open!"
		for t in terms
			let msg .= "\n\t[".t.winnr.']: '.t.variables.netrw_prvfile
		endfor
		let msg .= "\nSelect terminal: "
		let term_window = input(msg, terms[0].winnr)
	endif


	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@
	let clipboard_save = &clipboard
	let &clipboard = ""


	if has('nvim')
		exe term_window . "wincmd w"

		if has('win32')
			let @" .= "\r"
		else
			let @" .= "\n"
		endif
		normal! pG

		exe winnr('#') . "wincmd w"
	else
		let text = substitute(a:1, '\n\|$', '\r', "g")
		if !&expandtab && g:sendtoterm_expandtab
			let text = substitute(text, '\t', repeat(' ', shiftwidth()), "g")
		endif
		call term_sendkeys(winbufnr(term_window+0), text)
	endif

	let &selection = sel_save
	let @@ = reg_save
	let &clipboard = clipboard_save
endfu

nnoremap <leader>c  :call SendCommandToTerminal ("cabal build")<cr><esc>  
nnoremap <leader>r  :call SendCommandToTerminal (":r")<cr><esc>  




>>>>>>> f142bc83d2d18c90763942df6f70d2095b7cf13c
