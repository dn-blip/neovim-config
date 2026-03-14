-- for auto-completion

return {
    {
        'saghen/blink.cmp',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                version = 'v2.*',
                config = function()
                    local luasnip = require('luasnip')

                    luasnip.add_snippets('zig', require('snippets.zig'))
                    luasnip.add_snippets('c', require('snippets.c'))
                    luasnip.add_snippets('cpp', require('snippets.cpp'))
                    luasnip.add_snippets('cpp', require('snippets.c'))
                end,
            },
        },
        version = '1.*',

        ---@module 'blink.cmp'
        opts = {
            keymap = {
                ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<CR>'] = { 'select_and_accept', 'fallback' },
                ['<C-e>'] = { 'hide', 'fallback' },
            },

            appearance = {
                nerd_font_variant = 'mono',
            },
            signature = {
                enabled = true,
                window = {
                    show_documentation = true,
                },
            },
            completion = {
                trigger = {
                    show_on_insert_on_trigger_character = false,
                    show_on_accept_on_trigger_character = false,
                    show_on_blocked_trigger_characters = { '{', '(', '}', ')' },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                menu = {
                    auto_show = true,
                    scrollbar = false,
                    draw = {
                        columns = {
                            { 'kind_icon' },
                            { 'label', 'label_description', gap = 1 },
                            { 'kind', gap = 1 },
                            { 'label_description', gap = 1 },
                            { 'source_name', gap = 1 },
                        },
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                width = { fill = true },
                                text = function(ctx)
                                    local kind_icons = {
                                        Function = 'func', -- Lambda symbol for functions
                                        Method = 'method', -- Lambda symbol for methods
                                        Field = 'field', -- Lambda symbol for methods
                                        Variable = 'var', -- Lambda symbol for methods
                                        Property = 'property', -- Lambda symbol for methods
                                        Keyword = 'keyword', -- Lambda symbol for methods
                                        Struct = 'struct', -- Lambda symbol for methods
                                        Enum = 'enum', -- Lambda symbol for methods
                                        EnumMember = 'enum_member', -- Lambda symbol for methods
                                        Snippet = 'snippet',
                                        Text = 'txt',
                                        Module = 'module',
                                        Constructor = 'constructor',
                                    }

                                    local icon = kind_icons[ctx.kind]
                                    if icon == nil then icon = ctx.kind_icon end
                                    return icon
                                end,
                            },
                        },
                    },
                },
            },
            snippets = {
                preset = 'luasnip',
                -- Function to use when expanding LSP provided snippets
                expand = function(snippet) vim.snippet.expand(snippet) end,
                -- Function to use when checking if a snippet is active
                active = function(filter) return vim.snippet.active(filter) end,
                -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
                jump = function(direction) vim.snippet.jump(direction) end,
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = 'prefer_rust_with_warning' },
        },
        opts_extend = { 'sources.default' },
    },
}
