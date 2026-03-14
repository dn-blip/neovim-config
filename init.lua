vim.g.mapleader = ' '
vim.g.cc = 'zig cc'
-- Load default configurations and plugins
-- it is like automatic require("something")
--
for _, source in ipairs({
    'lazy_init',
    'mappings',
    'options',
    'autocmds',
}) do
    local ok, fault = pcall(require, source)
    if not ok then vim.api.nvim_err_write('Failed to load ' .. source .. '\n\n' .. fault) end
end

vim.cmd('colorscheme tokyonight')

-- Enable LSPs
vim.lsp.enable({
    'lua_ls',
    'zls',
    'basedpyright',
    'clangd',
    'gopls',
})

-- Load custom configurations
local exist, custom = pcall(require, 'custom')
if exist and type(custom) == 'table' and custom.configs then custom.configs() end
