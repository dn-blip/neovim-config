local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    pattern = '*',
    callback = function() vim.hl.on_yank({ timeout = 170 }) end,
    group = highlight_group,
})

--local api = vim.api
autocmd('LspAttach', {
    group = augroup('LspKeymaps', { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        --local client = vim.lsp.get_client_by_id(event.data.client_id)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'K', function()
            local max_width = math.max(20, math.floor(vim.api.nvim_win_get_width(0) * 0.5))
            vim.lsp.buf.hover({ max_width = max_width })
        end, opts)
        vim.keymap.set(
            'n',
            '<leader>th',
            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
            { desc = '[t]oggle inlay [h]ints' }
        )
    end,
})
