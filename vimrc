
scriptencoding utf-8
set encoding=utf-8

call plug#begin('~/.vim/plugged')

Plug '~/.fzf'

Plug 'junegunn/fzf.vim'

Plug 'Yggdroot/indentLine'

Plug 'joshdick/onedark.vim'

Plug 'scrooloose/nerdcommenter'

Plug 'gustafj/vim-ttcn'
", { 'rtp': 'syntax', 'as': 'vim-ttcn-syntax' }

call plug#end()

" if has("multi_byte")
"   if &termencoding == ""
"     let &termencoding = &encoding
"   endif
"   set encoding=utf-8
"   setglobal fileencoding=utf-8
"   "setglobal bomb
"   set fileencodings=ucs-bom,utf-8,latin1
" endif
"

let g:indentLine_color_term = 59
let g:indentLine_color_gui = '#5C6370'

let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_winsize = -28
let g:netrw_chgwin = 2

" ttcn3
au BufRead,BufNewFile *.ttcn3 set filetype=ttcn

let g:indentLine_char = '|'

" autocompletion
filetype plugin on
au FileType php setlocal ofu=phpcomplete#CompletePHP
au FileType ruby,eruby setlocal ofu=rubycomplete#Complete
au FileType html,xhtml setlocal ofu=htmlcomplete#CompleteTags
au FileType c,cpp setlocal ofu=ccomplete#Complete
au FileType css setlocal ofu=csscomplete#CompleteCSS
au FileType clojure setlocal ofu=clojurecomplete#Complete
au FileType ada setlocal ofu=adacomplete#Complete
au FileType javascript setlocal ofu=javascriptcomplete#CompleteJS
au FileType python setlocal ofu=pythoncomplete#Complete
au FileType python3 setlocal ofu=python3complete#Complete
au FileType sql setlocal ofu=sqlcomplete#Complete
au FileType xml setlocal ofu=xmlcomplete#CompleteTags

set completeopt=longest,menuone

" C-Space opens autocomplete
inoremap <C-@> <C-x><C-p>

" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
 " \ '<C-n><C-r>=pumvisible() ? "\<Down>" : ""<CR>'
" inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
 " \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<Down>" : ""<CR>'
" inoremap <expr> <CR> pumvisible

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
" vim maps / as _
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>

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

" show whitespaces
:if v:version > 704 || v:version == 704 && has("patch710")
    set listchars=eol:¬,tab:»\ ,trail:·,space:·
else
    set listchars=eol:¬,tab:»\ ,trail:·
endif
set list

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
highlight Normal ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE

" remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

" remove trailing empty lines
autocmd BufWritePre * %s#\($\n\s*\)\+\%$##
