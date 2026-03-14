---@module 'lazy'
---@type LazySpec
return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvimtools/none-ls-extras.nvim',
    },

    event = { 'BufWinEnter', 'BufReadPost' },
    config = function()
        local null_ls = require('null-ls')
        local diagnostics = {
            underline = true,
            virtual_text = true,
            severity_sort = true,
            update_in_insert = false,

            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN] = '󰅚 ',
                    [vim.diagnostic.severity.INFO] = '󰅚 ',
                    [vim.diagnostic.severity.HINT] = '󰌶 ',
                },
                numhl = {
                    [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
                    [vim.diagnostic.severity.WARN] = 'WarningMsg',
                },
            },
        }
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua.with({
                    extra_args = {
                        '--column-width=120',
                        '--indent-type=Spaces',
                        '--indent-width=4',
                        '--quote-style=AutoPreferSingle',
                        '--line-endings=Unix',
                    },
                }),
                null_ls.builtins.diagnostics.selene.with({
                    diagnostic_config = diagnostics,
                }),
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.clang_format,
            },
        })
    end,
}
