local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    pattern = '*',
    callback = function() vim.hl.on_yank({ timeout = 170 }) end,
    group = highlight_group,
})

autocmd('LspAttach', {
    group = augroup('my.lsp', { clear = true }),
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        -- Keymaps for things to do with the LSP server
        if client:supports_method('textDocument/definition') then
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        end

        if client:supports_method('textDocument/declaration') then
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        end

        if client:supports_method('textDocument/implementation') then
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        end

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        if client:supports_method('textDocument/references') then
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        end

        if client:supports_method('textDocument/typeDefinition') then
            vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
        end

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

autocmd('BufWritePost', {
    callback = function()
        require('lint').try_lint()
    end,
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
    group = augroup('my.treesitter', { clear = true })
    pattern = { 'c', 'cpp', 'css', 'go', 'lua', 'python', 'html', 'zig' }
    callback = function(event)
        vim.treesitter.start()
    end,
})
