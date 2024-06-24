vim.lsp.start({
  name = 'basedpyright-langserver',
  cmd = {'basedpyright-langserver', '--stdio'},
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
  root_dir = vim.fs.root(0, {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
  }),
})
