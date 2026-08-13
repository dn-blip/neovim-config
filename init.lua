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
    { src = gh('nvim-mini/mini.nvim') },
    { src = gh('Aejkatappaja/sora') },
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

----- options -----
vim.g.mapleader = ' '
local opt = vim.opt

opt.clipboard:append('unnamedplus')

opt.encoding = 'utf-8'
opt.matchpairs = { '(:)', '{:}', '[:]', '<:>' }

local indent = 4
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.tabstop = indent

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.termguicolors = true
opt.showmode = false
opt.hlsearch = false

opt.scrolloff = 8
opt.wrap = true

opt.history = 100 -- keep 100 lines of history
opt.redrawtime = 1500
opt.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.ttimeoutlen = 10
opt.updatetime = 100

vim.cmd([[filetype plugin indent on]])
----- end of options -----

----- key mappings -----
local map = vim.keymap.set

map('i', 'jj', '<ESC>')

map('n', '<leader>w', '<cmd>w<CR>', { desc = 'save current buffer' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = '' })

map('n', '<leader>h', '<C-w>h', { desc = 'switch window left' })
map('n', '<leader>l', '<C-w>l', { desc = 'switch window right' })
map('n', '<leader>k', '<C-w>k', { desc = 'switch window up' })
map('n', '<leader>j', '<C-w>j', { desc = 'switch window down' })

map({ 'n', 'i', 'v' }, '<Up>', '<nop>')
map({ 'n', 'i', 'v' }, '<Down>', '<nop>')
map({ 'n', 'i', 'v' }, '<Left>', '<nop>')
map({ 'n', 'i', 'v' }, '<Right>', '<nop>')

map(
    'n',
    '<leader>pb',
    function() require('mini.pick').builtin.files() end,
    { desc = '[p]ick [b]uffers (mini.nvim)' }
)
map(
    'n',
    '<leader>pf',
    function() require('mini.pick').builtin.files() end,
    { desc = '[p]ick [f]iles (mini.nvim)' }
)
map(
    'n',
    '<leader>ph',
    function() require('mini.pick').builtin.help() end,
    { desc = '[p]ick [h]elp menu entries (mini.nvim)' }
)

map('n', '<leader>?', function() require('which-key').show({ global = true }) end)
map({ 'n', 'v' }, '<leader>f', '<cmd>Yazi<cr>', { desc = 'Open yazi at current file' })
map({ 'n', 'v' }, '<leader>fr', '<cmd>Yazi toggle<cr>', { desc = 'Resume last yazi session' })
map({ 'n', 'v' }, '<leader>fd', '<cmd>Yazi cwd', { desc = 'Open Yazi in current directory' })
map({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'leap search local' })
map('n', 'S', '<Plug>(leap-from-window)', { desc = 'leap in other window' })
----- end of key mappings -----

require('autocmds')
require('plugins').setup()
vim.cmd('colorscheme sora')

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
