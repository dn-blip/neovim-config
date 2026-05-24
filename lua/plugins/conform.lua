-- conform.nvim for formatting

return {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
        require('conform').setup({
            formatters_by_ft = {
                lua = { 'stylua' },
                c = { 'clang-format' },
                cpp = { 'clang-format' },
            },
        })
    end,
}
