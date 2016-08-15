
call plug#begin('~/.vim/plugged')

Plug '~/.fzf'

Plug 'junegunn/fzf.vim'

Plug 'Yggdroot/indentLine'

Plug 'joshdick/onedark.vim'

Plug 'tyrannicaltoucan/vim-deep-space'

call plug#end()

let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_winsize = -28
let g:netrw_chgwin = 2


" plug sometimes crashes on paralell downloads
let g:plug_threads = 1

if (has("termguicolors"))
  set termguicolors
endif

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab

" Alt+leftarrow will go one window left, etc.
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

let g:fzf_layout = { 'down': '~40%' }
map <c-p> :Files<CR>

set number

" autocmd vimenter * NERDTree

" let g:ctrlp_reuse_window = ''

" autocmd vimenter * call ToggleVExplorer()
" autocmd VimEnter * wincmd p " focus main window

" let NERDTreeMinimalUI = 1
" let NERDTreeDirArrows = 1

" highlight lines of length 80+
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

syntax on
colorscheme onedark
" set background=dark
" colorscheme deep-space 
highlight Normal ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
