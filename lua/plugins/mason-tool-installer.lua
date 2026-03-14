return {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
    },
    event = 'VeryLazy',

    config = function()
        local mason_tool_installer = require('mason-tool-installer')

        local ensure = {
            'stylua',
            'clangd',
            'selene',
            'lua_ls',
            'basedpyright',
        }

        mason_tool_installer.setup({
            ensure_installed = ensure,
            auto_update = false,
            run_on_start = true,
        })

        mason_tool_installer.run_on_start()
    end,
}
