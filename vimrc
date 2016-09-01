
if has("multi_byte")
  if !exists('g:encoding_set') && !has('nvim')
    set encoding=utf-8
    let g:encoding_set = 1
  endif
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

call plug#begin('~/.vim/plugged')

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/indentLine'
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'gustafj/vim-ttcn'

call plug#end()


" appearance -----------------------------------------------------------------

if has("termguicolors")
  set termguicolors
endif

syntax on
colorscheme onedark
set background=light
highlight Normal
  \ ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE

set list
set listchars=eol:¬,tab:»\ ,trail:·
if v:version > 704 || v:version == 704 && has("patch710")
  set listchars+=space:·
endif

set number
set textwidth=80
set colorcolumn=+1
set mouse-=a
set ruler
set laststatus=2


" behavior -------------------------------------------------------------------

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd Filetype
  \ vim,javascript,json,yaml,css,less,sass,xml,html,haml,sh,zsh,markdown
  \ setlocal expandtab ts=2 sts=2 sw=2

" Alt+leftarrow will go one window left, etc.
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

" remove trailing empty lines
" autocmd BufWritePre * %s#\($\n\s*\)\+\%$##


" autocomplete ---------------------------------------------------------------

" C-Space opens autocomplete
inoremap <C-@> <C-x><C-n>

set completeopt=menuone,preview

if v:version > 704 || v:version == 704 && has("patch784")
  set completeopt+=noinsert
  " based on https://gist.github.com/vheon/10104517
  autocmd InsertCharPre *
    \ if !pumvisible() | call feedkeys("\<C-x>\<C-n>", "nt") | endif
else
  set completeopt+=longest
endif


" plugins --------------------------------------------------------------------

" plug sometimes crashes on paralell downloads
let g:plug_threads = 1

let g:fzf_layout = { 'down': '~40%' }
let $FZF_DEFAULT_COMMAND= 'pt --hidden -g ""'
map <C-p> :Files<CR>
map <C-o> :Buffers<CR>

let g:indentLine_color_term = 59
let g:indentLine_color_gui = '#5C6370'
let g:indentLine_char = '|'

let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_winsize = -28

" C-/ comments-out line/selection
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1

" ttcn plugin does not recognize this extension
autocmd BufRead,BufNewFile *.ttcn3 set filetype=ttcn
