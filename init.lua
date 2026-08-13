vim.g.mapleader = ' '
vim.g.cc = 'zig cc'
vim.g.loaded_netrwPlugin = 1

local gh = function(url) return 'https://github.com/' .. url end
local cb = function(url) return 'https://codeberg.org/' .. url end
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt
local map = vim.keymap.set

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
vim.o.winborder = 'single'
vim.o.pumborder = 'single'
vim.o.complete = '.,w,b,o'
vim.o.completeopt = 'fuzzy,menuone,noselect'

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

opt.history = 100
opt.redrawtime = 1500
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.updatetime = 100

vim.cmd([[filetype plugin indent on]])
----- end of options -----

----- key mappings -----
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

require('plugins').setup()

----- autocommands -----
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    pattern = '*',
    callback = function() vim.hl.on_yank({ timeout = 170 }) end,
    group = highlight_group,
})

-- TODO: Find a better way to implement this..
autocmd('LspAttach', {
    group = augroup('my.lsp', { clear = true }),
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        -- Keymaps for things to do with the LSP server
        if client:supports_method('textDocument/definition') then
            map('n', 'gd', vim.lsp.buf.definition, opts)
        end

        if client:supports_method('textDocument/declaration') then
            map('n', 'gD', vim.lsp.buf.declaration, opts)
        end

        if client:supports_method('textDocument/implementation') then
            map('n', 'gi', vim.lsp.buf.implementation, opts)
        end

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        if client:supports_method('textDocument/references') then
            map('n', 'gr', vim.lsp.buf.references, opts)
        end

        if client:supports_method('textDocument/typeDefinition') then
            map('n', 'gy', vim.lsp.buf.type_definition, opts)
        end

        vim.keymap.set('n', 'K', function()
            local max_width = math.max(20, math.floor(vim.api.nvim_win_get_width(0) * 0.5))
            vim.lsp.buf.hover({ max_width = max_width })
        end, opts)
        map(
            'n',
            '<leader>th',
            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
            { desc = '[t]oggle inlay [h]ints' }
        )
    end,
})

autocmd('BufWritePost', {
    callback = function() require('lint').try_lint() end,
})

autocmd('FileType', {
    pattern = { 'c', 'cpp', 'go' },
    callback = function()
        vim.opt_local.tabstop = 8
        vim.opt_local.shiftwidth = 8
        vim.opt_local.softtabstop = 8
        vim.opt_local.expandtab = true
        vim.opt_local.cindent = true
    end,
})

autocmd('FileType', {
    group = augroup('my.treesitter', { clear = true }),
    pattern = '*',
    callback = function(event)
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
        if pcall(vim.treesitter.add, lang) then vim.treesitter.start(event.buf, lang) end
    end,
})
----- end of autocommands -----
require('sora').setup({ transparent = true, })
vim.cmd('colorscheme sora')
