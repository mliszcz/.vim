vim.lsp.start({
  name = 'mtcd',
  cmd = {'mtcd'},
  root_dir = vim.fs.root(0, {'package.yml'}),
  on_attach = function(client, bufnr)
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
})
