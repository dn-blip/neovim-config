return {
    'alexpasmantier/hubbamax.nvim',
    lazy = false,
    priority = 1000,
    config = function() require('hubbamax').setup({ transparent_background = true }) end,
}
