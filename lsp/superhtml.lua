---@type vim.lsp.Config
return {
    cmd = { 'superhtml', 'lsp' },
    filetypes = { 'html' },
    root_markers = {
        '.prettierrc',
        'index.html',
        '.git',
    },

    single_file_support = true,
}
