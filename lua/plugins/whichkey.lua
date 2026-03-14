return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        preset = 'helix',
        win = {
            padding = { 0, 1 },
        },

        icons = {
            breadcrumbs = '>>=',
            separator = ':: ',
            group = ' ++ ',
            keys = {},
        },
    },

    config = function(_, opts) require('which-key').setup(opts) end,
    keys = {
        {
            '<leader>?',
            function() require('which-key').show({ global = false }) end,
        },
    },
}
