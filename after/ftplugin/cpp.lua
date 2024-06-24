vim.lsp.start({
  name = 'clangd',
  cmd = {'clangd',
    -- Use a match-all query driver to support compilers in no-standard paths.
    -- https://clangd.llvm.org/troubleshooting.html#cant-find-standard-library-headers-map-stdioh-etc
    -- https://github.com/clangd/clangd/issues/539
    '--query-driver=/**/*',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=never',
    '--header-insertion-decorators',
  },
  -- Use a custom TMPDIR for storing (potentially large) precompiled preambles.
  cmd_env = vim.env.CLANGD_TMPDIR and {
    TMPDIR = vim.env.CLANGD_TMPDIR
  },
  -- This list is taken from nvim-lspconfig. It would be better to rely only
  -- on compilation database presence and also look into build/.
  root_dir = vim.fs.root(0, {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
  }),
})
