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
  packadd! HiPhish/rainbow-delimiters.nvim
  packadd! lewis6991/gitsigns.nvim
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

set autoindent
set autoread
set colorcolumn=80
set conceallevel=0
set copyindent
set cursorline
set expandtab
set formatoptions-=c
set formatoptions-=t
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set mouse=
set nobackup
set noswapfile
set nowrap
set number
set relativenumber
set ruler
set scrolloff=10
set shiftwidth=4
set showbreak=\ >\ 
set showcmd
set showmatch
set sidescrolloff=30
set smartcase
set smarttab
set softtabstop=4
set tabstop=4
set textwidth=0
set title
set undolevels=1000
set whichwrap+=<,>,h,l,[,]
set wildmenu
set wildmode=full

if has('unnamedplus')
  set clipboard+=unnamedplus
endif

set completeopt=menu,menuone
if has('patch-7.4.775')
  set completeopt+=noinsert
endif

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Do not use custom listchars in a Linux console,
" the font does not provide all these characters.
if $TERM != 'linux'
  set listchars=eol:¬,tab:»\ ,trail:·
  if has('patch-7.4.710')
    set listchars+=space:·
  endif
  if has('patch-9.0.1938') || has('nvim-0.10.0')
    set listchars+=leadmultispace:│···
  endif
endif

if has('patch-7.4.2201')
  set signcolumn=yes
endif

if has('termguicolors')
  set termguicolors
endif

" Automatically open quick fix window after it is populated (:grep only).
autocmd QuickFixCmdPost grep copen

" Indent certain languages with only two spaces.
autocmd Filetype
  \ vim,javascript,json,yaml,css,less,sass,xml,html,haml,sh,zsh,markdown,purescript
  \ setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
  \ | if has('patch-9.0.1938') || has('nvim-0.10.0') | setlocal listchars+=leadmultispace:│· | endif

autocmd Filetype log setlocal nomodifiable nolist colorcolumn=

" Auto-wrap text on textwidth in markdown files.
autocmd Filetype markdown setlocal textwidth=80 formatoptions+=t

" Automatically remove trailing whitespaces on save.
" autocmd BufWritePre * %s/\s\+$//e

" Automatically remove trailing empty lines on save.
" autocmd BufWritePre * %s#\($\n\s*\)\+\%$##e

" Prefer // over /**/. For C++ This will be the default starting with 0.11.
autocmd Filetype cpp setlocal commentstring=//\ %s
autocmd Filetype ttcn setlocal commentstring=//\ %s

autocmd BufRead,BufNewFile *.tpp set filetype=cpp
autocmd BufRead,BufNewFile *.k3.txt,*.err,*.out set filetype=log

map <space> <leader>

nnoremap <leader>p :Files!<CR>
nnoremap <leader>o :Buffers!<CR>

noremap <leader>g :silent execute "grep! <cword>"<CR>

nnoremap <silent> <C-H> :colder<CR>
nnoremap <silent> <C-J> :cnext<CR>
nnoremap <silent> <C-K> :cprevious<CR>
nnoremap <silent> <C-L> :cnewer<CR>

nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

nnoremap <silent> ]c :Gitsigns next_hunk<CR>
nnoremap <silent> [c :Gitsigns prev_hunk<CR>

nnoremap <silent> <leader>c :Gitsigns setqflist "all"<CR>

nnoremap <silent> <leader>hs :Gitsigns stage_hunk<CR>
nnoremap <silent> <leader>hr :Gitsigns reset_hunk<CR>
nnoremap <silent> <leader>hu :Gitsigns undo_stage_hunk<CR>
nnoremap <silent> <leader>hc :Gitsigns preview_hunk<CR>

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

" Rename with feedback.
nnoremap <leader>r :%s/<c-r>=expand("<cword>")<cr>/<c-r>=expand("<cword>")<cr>
nnoremap <leader>R :%s/<c-r>=expand("<cWORD>")<cr>/<c-r>=expand("<cWORD>")<cr>

let g:fzf_layout = { 'down': '~40%' } " Use bottom 40% of screen for fzf.
let g:fzf_preview_window = [] " Disable preview for commands like :Files.

" Commands for ripgrep, copied from fzf.vim with the following changes:
" * bang behavior is inverted, i.e. omitting it will use the whole screen,
" * preview is hardcoded to override the global configuration.
let s:rg_cmd = "rg --column --line-number --no-heading --color=always --smart-case -- "
command! -bang -nargs=* Rg call fzf#vim#grep(s:rg_cmd . fzf#shellescape(<q-args>), fzf#vim#with_preview('up:60%'), <bang>1)
command! -bang -nargs=* RG call fzf#vim#grep2(s:rg_cmd, <q-args>, fzf#vim#with_preview('up:60%'), <bang>1)

" Remove any backgrounds. EndOfBuffer is for the initial welcome window.
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight EndOfBuffer ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE

" Make indentation lines and whitespaces darker.
autocmd ColorScheme onedark highlight NonText guifg=#404040
autocmd ColorScheme onedark highlight Whitespace guifg=#404040

" Display a separator line between the context and the rest of the file.
" This saves us one screen line by not needing to use the 'separator' option.
autocmd ColorScheme onedark highlight TreesitterContextBottom gui=underline guisp=Grey
autocmd ColorScheme onedark highlight TreesitterContextLineNumberBottom gui=underline guisp=Grey

" Colorscheme must be set after the ColorScheme autocommands are defined.
if has(s:min_nvim_version)
  let g:onedark_config = {'style': 'darker'}
  colorscheme onedark
else
  colorscheme darkblue
endif

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

if has(s:min_nvim_version)
lua << EOF

-- Place a sign when a mark is defined. This is deliberately not cleared when
-- the mark is removed to simplify the implementation. The signs are assigned
-- ids with a high offset value to avoid collisions.
vim.keymap.set('n', 'm', function ()
  local mark = vim.fn.getcharstr()
  local name = 'mark' .. mark
  local id = mark:byte() + 272145
  vim.fn.sign_define(name, { text = mark, texthl = "Identifier" })
  vim.fn.sign_place(id, '', name, vim.fn.bufname(), { lnum = vim.fn.line('.'), priority = 10 })
  vim.cmd("normal! m" .. mark)
end)

require('gitsigns').setup()

require('treesitter-context').setup()

require('nvim-treesitter.configs').setup {
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
