-- mini.nvim
vim.keymap.set(
    'n',
    '<leader>pb',
    function() require('mini.pick').builtin.files() end,
    { desc = '[p]ick [b]uffers (mini.nvim)' }
)
vim.keymap.set(
    'n',
    '<leader>pf',
    function() require('mini.pick').builtin.files() end,
    { desc = '[p]ick [f]iles (mini.nvim)' }
)
vim.keymap.set(
    'n',
    '<leader>ph',
    function() require('mini.pick').builtin.help() end,
    { desc = '[p]ick [h]elp menu entries (mini.nvim)' }
)

vim.keymap.set('n', '<leader>?', function() require('which-key').show({ global = true }) end)

vim.keymap.set({ 'n', 'v' }, '<leader>f', '<cmd>Yazi<cr>', { desc = 'Open yazi at current file' })
vim.keymap.set({ 'n', 'v' }, '<leader>fr', '<cmd>Yazi toggle<cr>', { desc = 'Resume last yazi session' })
vim.keymap.set({ 'n', 'v' }, '<leader>fd', '<cmd>Yazi cwd', { desc = 'Open Yazi in current directory' })

vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'leap search local' })
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = 'leap in other window' })
