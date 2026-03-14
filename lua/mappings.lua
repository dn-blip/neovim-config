vim.g.mapleader = ' '

local map = vim.keymap.set

map('i', 'jj', '<ESC>')

--
map('n', '<leader>w', '<cmd>w<CR>', { desc = 'save current buffer' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = '' })

map('n', '<leader>h', '<C-w>h', { desc = 'switch window left' })
map('n', '<leader>l', '<C-w>l', { desc = 'switch window right' })
map('n', '<leader>k', '<C-w>k', { desc = 'switch window up' })
map('n', '<leader>j', '<C-w>j', { desc = 'switch window down' })

map({ 'n', 'i', 'v' }, '<Up>', '<nop>', { desc = 'Get better. ' })
map({ 'n', 'i', 'v' }, '<Down>', '<nop>', { desc = 'Get better.' })
map({ 'n', 'i', 'v' }, '<Left>', '<nop>', { desc = 'Get better. ' })
map({ 'n', 'i', 'v' }, '<Right>', '<nop>', { desc = 'Get better. ' })

-- plugin mappings
map('n', '<leader>pf', function() require('mini.pick').builtin.files() end, { desc = '[p]ick [f]iles (mini.nvim) ' })

map(
    'n',
    '<leader>pb',
    function() require('mini.pick').builtin.buffers() end,
    { desc = '[p]ick [b]uffers (mini.nvim) ' }
)
