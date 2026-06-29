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
    }

    local mti = require('mason-tool-installer')

    mti.setup({
        ensure_installed = ensure_installed_tools,
        auto_update = true,
        run_on_start = true,
    })

    mti.run_on_start()
end

local setup_colorschemes = function()
    require('cyberdream').setup({
        transparent = true,
        italic_comments = true,
        cache = true,
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

local setup_lint_diag_format = function()
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
            python = { 'ruff' },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_format = 'fallback',
        },
    })
end

local setup_mini = function()
    require('mini.animate').setup()
    require('mini.icons').setup()
    require('mini.notify').setup()
    require('mini.cmdline').setup()
    require('mini.pick').setup()
    require('mini.trailspace').setup()
    require('mini.pairs').setup()
    require('mini.bracketed').setup()
    require('mini.ai').setup()
    require('mini.statusline').setup()
    require('mini.jump2d').setup()
end

local setup_lazydev = function()
    require('lazydev').setup({
        library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            { path = 'wezterm-types', mods = { 'wezterm' } },
        },
    })
end

local setup = function()
    setup_mason()
    setup_colorschemes()
    setup_yazi()
    setup_lint_diag_format()
    setup_mini()
    setup_lazydev()
    require('ibl').setup()
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

M.setup = setup

return M
