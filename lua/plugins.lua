---@diagnostic disable undefined-global
local M = {}
local setup_mason = function()
    local ensure_installed_tools = {
        'stylua',
        'selene',
        'clangd',
        'lua-language-server',
        'basedpyright',
        'ruff',
        'superhtml',
        'csskit',
    }

    require('mason').setup()

    local mti = require('mason-tool-installer')

    mti.setup({
        ensure_installed = ensure_installed_tools,
        auto_update = true,
        run_on_start = true,
    })

    local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'
    vim.env.PATH = mason_bin .. ':' .. vim.env.PATH

    vim.lsp.enable({
        'basedpyright',
        'clangd',
        'filepaths_ls',
        'gofmt',
        'gopls',
        'lua_ls',
        'superhtml',
    })
end

local setup_oil = function()
    require('oil').setup({
        default_file_explorer = true,
        delete_to_trash = true,
        watch_for_changes = true,
        columns = {
            'icons',
            'permissions',
            'size',
            'mtime',
        },
        keymaps = {
            ['g?'] = { 'actions.show_help', mode = 'n' },
            ['h'] = { 'actions.parent', mode = 'n' },
            ['l'] = function()
                local entry = require('oil').get_cursor_entry()
                if entry and entry.type ~= 'directory' then
                    return
                else
                    require('oil').select()
                end
            end,
            ['<Tab>'] = 'actions.preview',
            ['<CR>'] = 'actions.select',
            ['q'] = 'actions.close',
            ['<C-c>'] = 'actions.close',
        },
    })
end
local setup_codetools = function()
    local diagnostics = {
        underline = true,
        virtual_text = true,
        severity_sort = true,
        update_in_insert = false,

        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = '󰅚 ',
                [vim.diagnostic.severity.WARN] = '󰅚 ',
                [vim.diagnostic.severity.INFO] = '󰅚 ',
                [vim.diagnostic.severity.HINT] = '󰌶 ',
            },
            numhl = {
                [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
                [vim.diagnostic.severity.WARN] = 'WarningMsg',
            },
        },
    }

    vim.diagnostic.config(diagnostics)

    require('lint').linters_by_ft = {
        lua = { 'selene' },
        python = { 'ruff' },
    }

    require('conform').setup({
        formatters_by_ft = {
            lua = { 'stylua' },
            c = { 'clang-format' },
            cpp = { 'clang-format' },
            css = { 'csskit' },
            go = { 'gofmt' },
            python = { 'ruff' },
        },

        formatters = {
            csskit = {
                command = 'csskit',
                args = { 'fmt', '-' },
                stdin = true,
            },
        },

        format_on_save = {
            timeout_ms = 500,
            lsp_format = 'fallback',
        },
    })
end

local setup_mini = function()
    require('mini.icons').setup()
    require('mini.notify').setup()
    require('mini.pick').setup()
    require('mini.pairs').setup()
    require('mini.bracketed').setup()
    require('mini.ai').setup()
    require('mini.indentscope').setup()
    require('mini.move').setup()
    require('mini.git').setup()
    require('mini.diff').setup()
    local miniclue = require('mini.clue')
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = { 'n', 'x' }, keys = '<Leader>' },

            -- `[` and `]` keys
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = { 'n', 'x' }, keys = 'g' },

            -- Marks
            { mode = { 'n', 'x' }, keys = "'" },
            { mode = { 'n', 'x' }, keys = '`' },

            -- Registers
            { mode = { 'n', 'x' }, keys = '"' },
            { mode = { 'i', 'c' }, keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },

            -- `z` key
            { mode = { 'n', 'x' }, keys = 'z' },
        },
        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            miniclue.gen_clues.square_brackets(),
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
        },
    })
end

local setup = function()
    setup_mason()
    setup_oil()
    setup_codetools()
    setup_mini()
end

M.setup = setup

return M
