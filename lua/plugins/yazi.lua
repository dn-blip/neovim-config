---@brief file explorer: yazi.nvim
---@type LazySpec
return {
    'mikavilpas/yazi.nvim',
    version = '*', -- use the latest stable version
    event = 'VeryLazy',
    dependencies = {
        { 'nvim-lua/plenary.nvim', lazy = true },
    },
    keys = {
        {
            '<leader>fr',
            '<cmd>Yazi toggle<cr>',
            desc = 'Resume the last yazi session',
        },
    },
    ---@type YaziConfig | {}
    opts = {
        open_for_directories = true,
        keymaps = {
            show_help = '<f1>',
        },
    },
    init = function() vim.g.loaded_netrwPlugin = 1 end,
}
