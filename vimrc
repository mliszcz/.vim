
" neovim does not look here by default (https://bugs.archlinux.org/task/47029)
let s:vimfiles_dir = '/usr/share/vim/vimfiles'
if isdirectory(s:vimfiles_dir)
  exe 'set rtp^=' . s:vimfiles_dir
  exe 'set rtp+=' . s:vimfiles_dir . '/after'
endif

if has("multi_byte")
  if !exists('g:encoding_set') && !has('nvim')
    set encoding=utf-8
    let g:encoding_set = 1
  endif
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

set packpath^=~/.vim

packadd! indentLine
packadd! onedark.vim
packadd! nerdcommenter
packadd! vim-polyglot
packadd! vim-ttcn

if executable('fzf')
  " fzf package shall put the 'base' plugin in an existing runtimepath
  " if fzf is being run from a git checkout, one needs to set FZF_HOME
  if !exists('g:loaded_fzf')
    let s:fzf_base_plugin = $FZF_HOME . '/plugin/fzf.vim'
    if filereadable(s:fzf_base_plugin)
      exe 'source ' . s:fzf_base_plugin
    endif
  endif
  packadd! fzf.vim
endif


" appearance -----------------------------------------------------------------

if has("termguicolors")
  set termguicolors
endif

syntax on
colorscheme onedark
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
set title
set scrolloff=5
set hidden
set nowrap
set autoindent
set copyindent
set showmatch
set ignorecase
set smartcase
set hlsearch
set incsearch
set undolevels=100
set nobackup
set noswapfile
set cursorline
set autoread
set whichwrap+=<,>,h,l,[,]
set formatoptions-=t
set formatoptions-=c


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

if executable('rg')
  set grepprg=rg\ --vimgrep
endif


" autocomplete ---------------------------------------------------------------

" C-Space opens autocomplete
inoremap <C-@> <C-x><C-n>

set completeopt=menuone,preview

if v:version > 704 || v:version == 704 && has("patch784")
  set completeopt+=noinsert
  " based on https://gist.github.com/vheon/10104517
  let s:complete_after = 3
  autocmd InsertCharPre *
    \ if !pumvisible()
    \ && getline('.')[col('.') - s:complete_after].v:char =~# '\k\k'
    \ | call feedkeys("\<C-x>\<C-n>", "nt") | endif
  inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
else
  set completeopt+=longest
endif


" plugins --------------------------------------------------------------------

" NERDCommenter:filetype plugins should be enabled.
filetype plugin on

let g:fzf_layout = { 'down': '~40%' }

" bang makes window to use 100% height
map <C-p> :Files!<CR>
map <C-o> :Buffers!<CR>

" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
" https://www.reddit.com/r/vim/comments/7axmsb/i_cant_believe_how_good_fzf_is/
command! -bang -nargs=* Rg call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --fixed-strings --hidden --follow --glob "!.git/*" --glob "!.svn/*" --color "always" '
  \     .join(map(split(<q-args>), 'shellescape(v:val)'))
  \     .'| tr -d "\017"',
  \ 1,
  \ <bang>1 ? fzf#vim#with_preview('up:60%')
  \         : fzf#vim#with_preview('right:50%', '?'),
  \ <bang>1)

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

" http://stackoverflow.com/questions/18160953/disable-latex-symbol-conversion-in-vim
let g:vim_markdown_conceal = 0
let g:tex_conceal = ""

" ttcn plugin does not recognize this extension
autocmd BufRead,BufNewFile *.ttcn3 set filetype=ttcn
