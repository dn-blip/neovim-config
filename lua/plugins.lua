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

local setup_yazi = function()
    require('yazi').setup({
        open_for_directories = true,
        keymaps = {
            show_help = '<f1>',
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
            lua = { 'selene' },
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
    --require('mini.cmdline').setup()
    require('mini.pick').setup()
    require('mini.pairs').setup()
    require('mini.bracketed').setup()
    require('mini.ai').setup()
    require('mini.indentscope').setup()
    require('mini.git').setup()
end

local setup_lazydev = function()
    require('lazydev').setup({
        library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            { path = 'wezterm-types', mods = { 'wezterm' } },
            { path = 'xmake-luals-addon/library', files = { 'xmake.lua' } },
        },
    })
end
local setup_whichkey = function()
    require('which-key').setup({
        preset = 'helix',
        win = {
            padding = { 0, 1 },
        },

        icons = {
            breadcrumbs = '>>==',
            separator = ':: ',
            group = ' ++ ',
            keys = {},
        },
    })
end

local setup = function()
    setup_mason()
    setup_yazi()
    setup_codetools()
    setup_mini()
    setup_lazydev()
    setup_whichkey()
end

M.setup = setup

return M
