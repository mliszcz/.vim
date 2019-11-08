
if has("multi_byte")
  set encoding=utf-8
  set fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

" neovim does not look there by default (https://bugs.archlinux.org/task/47029)
let s:vimfiles_dir = '/usr/share/vim/vimfiles'
if isdirectory(s:vimfiles_dir)
  exe 'set rtp^=' . s:vimfiles_dir
  exe 'set rtp+=' . s:vimfiles_dir . '/after'
endif

if v:version >= 800
  set packpath^=~/.vim
  packadd! indentLine
  packadd! onedark.vim
  packadd! vim-polyglot
  packadd! vim-ttcn
  packadd! vim-commentary
  packadd! fzf.vim
endif

if executable('fzf')
  " fzf package shall put the 'base' plugin in an existing runtimepath
  " if fzf is being run from a git checkout, one needs to set FZF_HOME
  if !exists('g:loaded_fzf')
    let s:fzf_base_plugin = $FZF_HOME . '/plugin/fzf.vim'
    if filereadable(expand(s:fzf_base_plugin))
      exe 'source ' . s:fzf_base_plugin
    endif
  endif
endif


" syntax highlighting ---------------------------------------------------------

filetype plugin indent on " filetype detection, plugin and indent autoloading

syntax on

autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

let g:onedark_terminal_italics = 1
colorscheme onedark

if has("termguicolors")
  set termguicolors
endif

" fix true colors (see :h xterm-true-color)
" https://github.com/vim/vim/issues/993
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"


" options -----------------------------------------------------------------

set list
set listchars=eol:¬,tab:»\ ,trail:·
if has('patch-7.4-710')
  set listchars+=space:·
endif

set number
set relativenumber
set textwidth=0
set colorcolumn=80
set mouse-=a
set ruler
set laststatus=2
set title
set scrolloff=10
set hidden
set nowrap
set autoindent
set copyindent
set showmatch
set ignorecase
set smartcase
set hlsearch
set incsearch
set undolevels=1000
set nobackup
set noswapfile
set cursorline
set autoread
set whichwrap+=<,>,h,l,[,]
set formatoptions-=t
set formatoptions-=c
set conceallevel=0

autocmd Filetype markdown setlocal formatoptions+=t

set wildmenu
set wildmode=full
set showcmd

set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd Filetype
  \ vim,javascript,json,yaml,css,less,sass,xml,html,haml,sh,zsh,markdown,purescript
  \ setlocal expandtab ts=2 sts=2 sw=2

if executable('rg')
  set grepprg=rg\ --vimgrep
endif

if !empty($CLIPBOARD_COPY_CMD) && !empty($CLIPBOARD_PASTE_CMD)
  " must be set before unnamedplus check and other clipboard operations
  " https://github.com/neovim/neovim/issues/8017
  let g:clipboard = {
    \   'name': 'generic',
    \   'copy': {
    \      '+': $CLIPBOARD_COPY_CMD,
    \      '*': $CLIPBOARD_COPY_CMD,
    \    },
    \   'paste': {
    \      '+': $CLIPBOARD_PASTE_CMD,
    \      '*': $CLIPBOARD_PASTE_CMD,
    \   },
    \   'cache_enabled': 1,
    \ }
endif

if has('unnamedplus')
  set clipboard+=unnamedplus
endif

" autocommands ----------------------------------------------------------------

" remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

" remove trailing empty lines
" autocmd BufWritePre * %s#\($\n\s*\)\+\%$##

" ttcn plugin does not recognize this extension
autocmd BufRead,BufNewFile *.ttcn3 set filetype=ttcn

" https://github.com/neovim/neovim/issues/7994
autocmd InsertLeave * set nopaste


" mappings --------------------------------------------------------------------

noremap <Up> <nop>
noremap <Down> <nop>
noremap <Right> <nop>
noremap <Left> <nop>

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Right> <nop>
inoremap <Left> <nop>

" bang makes window to use 100% height
noremap <C-o> :Buffers!<CR>

if exists(':Files')
  noremap <C-p> :Files!<CR>
else
  noremap <C-p> :FZF!<CR>
endif


" plugin options --------------------------------------------------------------

let g:fzf_layout = { 'down': '~40%' }

let g:indentLine_color_term = 59
let g:indentLine_color_gui = '#5C6370'
let g:indentLine_char = '|'

let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_winsize = -28

" http://stackoverflow.com/questions/18160953/disable-latex-symbol-conversion-in-vim
let g:indentLine_setConceal = 0
let g:vim_markdown_conceal = 0
let g:tex_conceal = ""


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


" grep ------------------------------------------------------------------------

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

