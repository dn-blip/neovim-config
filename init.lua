vim.g.mapleader = ' '
vim.g.cc = 'zig cc'
vim.g.loaded_netrwPlugin = 1

vim.o.winborder = 'single'
vim.o.pumborder = 'single'
vim.o.complete = '.,w,b,o'
vim.o.completeopt = 'fuzzy,menuone,noselect'

local gh = function(url) return 'https://github.com/' .. url end

local cb = function(url) return 'https://codeberg.org/' .. url end

vim.pack.add({
    { src = gh('scottmckendry/cyberdream.nvim') },
    { src = gh('nvim-mini/mini.nvim') },
    { src = gh('mason-org/mason.nvim') },
    { src = gh('WhoIsSethDaniel/mason-tool-installer.nvim') },
    { src = gh('mason-org/mason-lspconfig.nvim') },
    { src = gh('nvim-lua/plenary.nvim') },
    { src = gh('mikavilpas/yazi.nvim') },
    { src = gh('DrKJeff16/wezterm-types') },
    { src = gh('folke/lazydev.nvim') },
    { src = gh('folke/which-key.nvim') },
    { src = gh('antonk52/filepaths_ls.nvim') },
    { src = gh('mfussenegger/nvim-lint') },
    { src = gh('stevearc/conform.nvim') },
    { src = gh('NStefan002/screenkey.nvim') },
    { src = cb('cryptomilk/nvim-pack-ui') },
    { src = cb('andyg/leap.nvim') },
})

for _, source in ipairs({
    'mappings',
    'plugin_mappings',
    'options',
    'autocmds',
}) do
    local ok, fault = pcall(require, source)
    if not ok then vim.api.nvim_err_write('Failed to load ' .. source .. '\n\n' .. fault) end
end

require('plugins').setup()

vim.cmd([[filetype plugin indent on]])
vim.cmd('colorscheme cyberdream')

-- Enable LSPs,
vim.lsp.enable({
    'basedpyright',
    'clangd',
    'gopls',
    'lua_ls',
    'zls',
    'filepaths_ls',
    'superhtml',
})
