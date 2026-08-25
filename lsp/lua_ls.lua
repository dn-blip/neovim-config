return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },

    root_markers = {
        '.luacheckrc',
        '.luarc.json',
        '.luarc.jsonc',
        '.stylua.toml',
        'selene.toml',
        'selene.yml',
        'stylua.toml',
        '.git',
    },
    settings = {
        Lua = {
            version = 'LuaJIT',
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = {
                    vim.fn.expand('$VIMRUNTIME/lua'),
                    vim.fn.stdpath('config') .. '/lua',
                },
                checkThirdParty = true,
            },
            telemetry = {
                enable = false,
            },
            format = {
                enable = true,
            },
        },
    },
    single_file_support = true,
}
