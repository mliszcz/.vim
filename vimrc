" This configuration is intended to be used with recent Neovim versions,
" but basic support is provided also for Vim starting from 7.4 version.
let s:min_nvim_version = 'nvim-0.10.0'

" https://stackoverflow.com/questions/4976776/how-to-get-path-to-the-current-vimscript-being-executed
let s:vimdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

if has('multi_byte')
  set encoding=utf-8
  set fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

if has('packages')
  execute 'set packpath^=' . s:vimdir
  packadd! gustafj/vim-ttcn
  packadd! junegunn/fzf.vim
  packadd! MTDL9/vim-log-highlighting
endif

if has(s:min_nvim_version)
  packadd! chentoast/marks.nvim
  packadd! HiPhish/rainbow-delimiters.nvim
  packadd! lewis6991/gitsigns.nvim
  packadd! lukas-reineke/indent-blankline.nvim
  packadd! navarasu/onedark.nvim
  packadd! nvim-treesitter/nvim-treesitter
  packadd! nvim-treesitter/nvim-treesitter-context
  packadd! nvim-treesitter/nvim-treesitter-textobjects
endif

" The syntax on/enable option is not necessary when using Tree-sitter but
" without it being enabled the ColorScheme autocommands are not triggered.

" Filetype detection is needed to get syntax highlighting for files opened
" after startup (with :e or :Files). Otherwise it only works for the first
" opened file passed in the command line argument (nvim <file>). This also
" applies to any languages handled by Tree-sitter.
" Plugin and indent files are ignored when using Tree-sitter but otherwise
" plugin file is needed to load the syntax highlighting and indent file is
" needed to have language-specific indentation rules.
if !has(s:min_nvim_version)
  syntax on
  filetype plugin indent on
endif

au BufRead,BufNewFile *.k3.txt,*.err,*.out set filetype=log

set number
set relativenumber
set textwidth=0
set colorcolumn=80
set mouse=
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
set showcmd
set wildmenu
set wildmode=full
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

if has('termguicolors')
  set termguicolors
endif

if has('unnamedplus')
  set clipboard+=unnamedplus
endif

" Do not use custom listchars in a Linux console,
" the font does not provide all these characters.
set list
if $TERM != 'linux'
  set listchars=eol:¬,tab:»\ ,trail:·
  if has('patch-7.4-710')
    set listchars+=space:·
  endif
endif

if has('patch-7.4-2201')
  set signcolumn=yes
endif

set completeopt=menu,menuone
if has('patch-7.4-775')
  set completeopt+=noinsert
endif

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Remove any backgrounds. EndOfBuffer is for the initial welcome window.
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight EndOfBuffer ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE

" Make indentation lines and whitespaces darker.
autocmd ColorScheme onedark highlight NonText guifg=#404040
autocmd ColorScheme onedark highlight Whitespace guifg=#404040
autocmd ColorScheme onedark highlight IblWhitespace guifg=#404040

" Remove the diagnostic sign (text) and highlight the line number instead.
" We do not define a new highlight group but use the one from the virtual
" text instead. See also :h diagnostic-signs, diagnostic-highlights, and
" https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization.
if has(s:min_nvim_version)
  sign define DiagnosticSignError text= texthl= linehl= numhl=DiagnosticVirtualTextError
  sign define DiagnosticSignWarn  text= texthl= linehl= numhl=DiagnosticVirtualTextWarn
  sign define DiagnosticSignInfo  text= texthl= linehl= numhl=DiagnosticVirtualTextInfo
  sign define DiagnosticSignHint  text= texthl= linehl= numhl=DiagnosticVirtualTextHint
endif

" Automatically open quick fix window after it is populated (:grep only).
autocmd QuickFixCmdPost grep copen

" Indent certain languages with only two spaces.
autocmd Filetype
  \ vim,javascript,json,yaml,css,less,sass,xml,html,haml,sh,zsh,markdown,purescript
  \ setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

" Auto-wrap text on textwidth in markdown files.
autocmd Filetype markdown setlocal textwidth=80 formatoptions+=t

" Automatically remove trailing whitespaces on save.
" autocmd BufWritePre * %s/\s\+$//e

" Automatically remove trailing empty lines on save.
" autocmd BufWritePre * %s#\($\n\s*\)\+\%$##e

" The TTCN plugin does not recognize the .ttcn3 extension.
autocmd BufRead,BufNewFile *.ttcn3 set filetype=ttcn commentstring=//\ %s

" Prefer // over /**/ for C++. This will be the default starting with 0.11.
autocmd Filetype cpp setlocal commentstring=//\ %s

" A .tpp file with template definitions.
autocmd BufRead,BufNewFile *.tpp set filetype=cpp

" Colorscheme must be set after the ColorScheme autocommands are defined.
if has(s:min_nvim_version)
  let g:onedark_config = {'style': 'darker'}
  colorscheme onedark
endif

" Fix true colors (see :h xterm-true-color),
" https://github.com/vim/vim/issues/993
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

noremap <Up> <nop>
noremap <Down> <nop>
noremap <Right> <nop>
noremap <Left> <nop>

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Right> <nop>
inoremap <Left> <nop>

map <space> <leader>

" Bang makes window to use 100% height. Note: these commands are from fzf-vim.
noremap <leader>p :Files!<CR>
noremap <leader>o :Buffers!<CR>

noremap <leader>g :silent execute "grep! <cword>"<CR>

nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>
nnoremap <silent> [<C-Q> :cpfile<CR>
nnoremap <silent> ]<C-Q> :cnfile<CR>

noremap <silent> [f :colder<CR>
noremap <silent> ]f :cnewer<CR>

nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lfirst<CR>
nnoremap <silent> ]l :llast<CR>
nnoremap <silent> [<C-L> :lpfile<CR>
nnoremap <silent> ]<C-L> :lnfile<CR>

nnoremap <silent> [b :bprev<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :brewind<CR>

nnoremap <silent> ]c :Gitsigns next_hunk<CR>
nnoremap <silent> [c :Gitsigns prev_hunk<CR>

nnoremap <silent> <leader>c :Gitsigns setqflist "all"<CR>

nnoremap <silent> <leader>hs :Gitsigns stage_hunk<CR>
nnoremap <silent> <leader>hr :Gitsigns reset_hunk<CR>
nnoremap <silent> <leader>hu :Gitsigns undo_stage_hunk<CR>
nnoremap <silent> <leader>hc :Gitsigns preview_hunk<CR>

" Mappings for the builtin LSP client. It is ok to not have them configured in
" Lua inside the on_attach callback because the commands are resolved when the
" mapping is executed.

" These mappings should be default starting with 0.11.
" See: https://github.com/neovim/neovim/pull/28650
nnoremap <silent> grn :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gra :lua vim.lsp.buf.code_action()<CR>
xnoremap <silent> gra :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> grr :lua vim.lsp.buf.references()<CR>
inoremap <silent> <C-S> <C-O>:lua vim.lsp.buf.signature_help()<CR>

" These are TBD according to the recent comments in #28650.
nnoremap <silent> grd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> grD :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gri :lua vim.lsp.buf.implementation()<CR>

nnoremap <silent> <leader>i :lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>

nmap <silent> [w <Plug>(Marks-prev)
nmap <silent> ]w <Plug>(Marks-next)
nmap <silent> [e <Plug>(Marks-prev-bookmark0)
nmap <silent> ]e <Plug>(Marks-next-bookmark0)
nmap <silent> m; <Plug>(Marks-toggle)
nmap <silent> m/ <Plug>(Marks-toggle-bookmark0)

" Rename with feedback.
nmap <leader>r :%s/<c-r>=expand("<cword>")<cr>/<c-r>=expand("<cword>")<cr>
nmap <leader>R :%s/<c-r>=expand("<cWORD>")<cr>/<c-r>=expand("<cWORD>")<cr>

let g:fzf_layout = { 'down': '~40%' } " Use bottom 40% of screen for fzf.
let g:fzf_preview_window = [] " Disable preview for commands like :Files.

" Commands for ripgrep, copied from fzf.vim with the following changes:
" * bang behavior is inverted, i.e. omitting it will use the whole screen,
" * preview is hardcoded to override the global configuration.
let s:rg_cmd = "rg --column --line-number --no-heading --color=always --smart-case -- "
command! -bang -nargs=* Rg call fzf#vim#grep(s:rg_cmd . fzf#shellescape(<q-args>), fzf#vim#with_preview('up:60%'), <bang>1)
command! -bang -nargs=* RG call fzf#vim#grep2(s:rg_cmd, <q-args>, fzf#vim#with_preview('up:60%'), <bang>1)

" Display a separator line between the context and the rest of the file.
" This saves us one screen line by not needing to use the 'separator' option.
hi TreesitterContextBottom gui=underline guisp=Grey
hi TreesitterContextLineNumberBottom gui=underline guisp=Grey

" Function for opening a persistent terminal.
let g:Terminals = {}
function! OpenTerminal(name)
  if has_key(g:Terminals, a:name)
    execute 'buffer ' . g:Terminals[a:name]
  else
    edit term://fish
    let g:Terminals[a:name] = bufnr('%')
    let b:TerminalName = a:name
    autocmd BufDelete <buffer> unlet g:Terminals[b:TerminalName]
    " Map <space> instead of <leader> for switching back because <space>
    " is not a <leader> in the terminal mode (for now this is intentional).
    tnoremap <buffer> <space><CR> <C-\><C-n><C-6>
    tnoremap <buffer> <space><Esc> <C-\><C-n>
    setlocal nonumber
    setlocal norelativenumber
  endif
  startinsert
endfunction

nnoremap <silent> <leader><CR> :call OpenTerminal('Scratch')<CR>

if has(s:min_nvim_version)
lua << EOF

require('gitsigns').setup {
  _signs_staged_enable = true
}

require'marks'.setup {
  default_mappings = false,
}

require('treesitter-context').setup()

require('ibl').setup {
  indent = {
    char = '│'
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false
  },
}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Do not run `:h syntax` for files handled by Tree-sitter.
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ia"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",
      },
    },
  },
}

-- Disable LSP logging. This file grows very quickly.
vim.lsp.set_log_level('OFF')
require('vim.lsp.log').set_format_func(vim.inspect)
EOF
endif
