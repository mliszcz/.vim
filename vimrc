" This configuration is intended to be used with recent Neovim versions,
" but basic support is provided also for Vim starting from 7.4 version.

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
  " packadd! sheerun/vim-polyglot
endif

if has('nvim-0.7')
  packadd! chentoast/marks.nvim
  packadd! lewis6991/gitsigns.nvim
  packadd! lukas-reineke/indent-blankline.nvim
  packadd! navarasu/onedark.nvim
  packadd! neovim/nvim-lspconfig
  packadd! numToStr/Comment.nvim
  packadd! nvim-treesitter/nvim-treesitter
  packadd! nvim-treesitter/nvim-treesitter-textobjects
  packadd! p00f/nvim-ts-rainbow
endif

let g:polyglot_disabled = ['autoindent', 'sensible', 'ftdetect']

let g:fzf_layout = { 'down': '~40%' } " Use bottom 40% of screen for fzf.
let g:fzf_preview_window = [] " Disable preview for commands like :Files.

" The syntax on/enable option is not necessary when using Tree-sitter but
" without it being enabled the ColorScheme autocommands are not triggered.
syntax on

" Filetype detection is needed to get syntax highlighting for files opened
" after startup (with :e or :Files). Otherwise it only works for the first
" opened file passed in the command line argument (nvim <file>). This also
" applies to any languages handled by Tree-sitter.
" Plugin and indent files are ignored when using Tree-sitter but otherwise
" plugin file is needed to load the syntax highlighting and indent file is
" needed to have language-specific indentation rules.
filetype plugin indent on

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

if has('nvim-0.7')
lua << EOF
  local ts = require'nvim-treesitter'
  local options = {
    indicator_size = 50,
    type_patterns = { 'class', 'function', 'method' },
  }
  function _G.SourceCodeLocation()
    return ts.statusline(options)
  end
EOF

  " The status line is similar to the default one but includes source code
  " location information. See also: https://unix.stackexchange.com/a/518439.
  set statusline=
  set statusline+=%f\                             " Path to the file.
  set statusline+=%h%w%m%r\                       " [Help][Preview][+/-][RO]
  set statusline+=%=                              " Center alignment.
  set statusline+=%{v:lua.SourceCodeLocation()}\  " Source code location.
  set statusline+=%=                              " Right alignment
  set statusline+=%-14.(%l,%c%V%)\ %P             " Cursor position.
endif

" Remove any backgrounds. EndOfBuffer is for the initial welcome window.
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight EndOfBuffer ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE

" Make indentation lines and whitespaces darker.
autocmd ColorScheme onedark highlight NonText guifg=#404040
autocmd ColorScheme onedark highlight Whitespace guifg=#404040
autocmd ColorScheme onedark highlight IndentBlanklineChar guifg=#404040
autocmd ColorScheme onedark highlight IndentBlanklineSpaceChar guifg=#404040

" Remove the diagnostic sign (text) and highlight the line number instead.
" We do not define a new highlight group but use the one from the virtual
" text instead. See also :h diagnostic-signs, diagnostic-highlights, and
" https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization.
sign define DiagnosticSignError text= texthl= linehl= numhl=DiagnosticVirtualTextError
sign define DiagnosticSignWarn  text= texthl= linehl= numhl=DiagnosticVirtualTextWarn
sign define DiagnosticSignInfo  text= texthl= linehl= numhl=DiagnosticVirtualTextInfo
sign define DiagnosticSignHint  text= texthl= linehl= numhl=DiagnosticVirtualTextHint

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
autocmd BufRead,BufNewFile *.ttcn3 set filetype=ttcn commentstring=/*%s*/

" A .tpp file with template definitions.
autocmd BufRead,BufNewFile *.tpp set filetype=cpp

" Colorscheme must be set after the ColorScheme autocommands are defined.
if has('nvim-0.7')
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

nnoremap <silent> <leader>jc :Gitsigns preview_hunk<CR>
nnoremap <silent> <leader>c :Gitsigns setqflist "all"<CR>

" Mappings for the builtin LSP client. It is ok to not have them configured in
" Lua inside the on_attach callback because the commands are resolved when the
" mapping is executed.
nnoremap <silent> <leader>jD :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>jd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>ji :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>jr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>ja :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>jf :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>js :lua vim.lsp.buf.signature_help()<CR>

nnoremap <silent> [d :lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d :lua vim.diagnostic.goto_next()<CR>

nmap <silent> [w <Plug>(Marks-prev)
nmap <silent> ]w <Plug>(Marks-next)
nmap <silent> [e <Plug>(Marks-prev-bookmark0)
nmap <silent> ]e <Plug>(Marks-next-bookmark0)
nmap <silent> m; <Plug>(Marks-toggle)
nmap <silent> m/ <Plug>(Marks-toggle-bookmark0)

" Rename with feedback.
nmap <leader>r :%s/<c-r>=expand("<cword>")<cr>/<c-r>=expand("<cword>")<cr>
nmap <leader>R :%s/<c-r>=expand("<cWORD>")<cr>/<c-r>=expand("<cWORD>")<cr>

" Wrapper for ripgrep. Bang (Rg!) will make it use just half of the screen.
" https://github.com/junegunn/fzf.vim#example-rg-command-with-preview-window
command! -bang -nargs=* Rg call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>),
  \ 1,
  \ <bang>1 ? fzf#vim#with_preview('up:60%')
  \         : fzf#vim#with_preview('right:50%', '?'),
  \ <bang>1)

if has('nvim-0.7')
lua << EOF

require('gitsigns').setup()

require'marks'.setup {
  default_mappings = false,
}

require('Comment').setup()

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Do not run `:h syntax` for files handled by Tree-sitter.
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
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
    swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]a"] = "@parameter.outer",
      },
      goto_next_end = {
        ["]A"] = "@parameter.outer",
      },
      goto_previous_start = {
        ["[a"] = "@parameter.outer",
      },
      goto_previous_end = {
        ["[A"] = "@parameter.outer",
      },
    },
  },
}

-- See below link for more details regarding LSP configuration:
-- https://github.com/neovim/nvim-lspconfig#Keybindings-and-completion
local function lsp_on_attach(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
      vim.lsp.buf.inlay_hint(bufnr, true)
  end
end

local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'

-- Add custom server configuration for ntt: https://github.com/nokia/ntt.
if not configs.ntt then
  configs.ntt = {
    default_config = {
      cmd = {'ntt', 'langserver'},
      filetypes = {'ttcn3', 'ttcn'},
      root_dir = lspconfig.util.root_pattern 'package.yml',
    }
  }
end

if not configs.mtcd then
  configs.mtcd = {
    default_config = {
      cmd = {'mtcd'},
      filetypes = {'ttcn3', 'ttcn'},
      root_dir = lspconfig.util.root_pattern 'package.yml',
    }
  }
end

lspconfig.lua_ls.setup{
  on_attach = lsp_on_attach
}

lspconfig.pyright.setup{
  on_attach = lsp_on_attach
}

-- lspconfig.ntt.setup{
--   on_attach = lsp_on_attach
-- }

lspconfig.mtcd.setup{
  on_attach = function(client, bufnr)
    lsp_on_attach(client, bufnr)
    -- mtcd is using a custom method for initial configuration.
    client.notify("$/configuration", {
      inlayHintConfiguration = {
        arrayExpressions = true,
        arrayIndexes = true,
        componentVariableUsage = true,
        defaultValues = true,
        implicitlyDefaultedParameters = true,
        modifiedTemplateDefaultValues = true,
        parameterDirection = true,
        unnamedParameter = true,
      }
    })
  end,
}

lspconfig.gopls.setup{
  on_attach = lsp_on_attach
}

lspconfig.clangd.setup{
  on_attach = lsp_on_attach,
  -- Use a custom TMPDIR for storing (potentially large) precompiled preambles.
  cmd_env = vim.env.CLANGD_TMPDIR and {
    TMPDIR = vim.env.CLANGD_TMPDIR
  },
  cmd = {'clangd',
    -- Use a match-all query driver to support compilers in no-standard paths.
    -- https://clangd.llvm.org/troubleshooting.html#cant-find-standard-library-headers-map-stdioh-etc
    -- https://github.com/clangd/clangd/issues/539
    '--query-driver=/**/*',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=never',
    '--header-insertion-decorators',
  }
}
EOF
endif
