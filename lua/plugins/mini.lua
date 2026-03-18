---@module "lazy"
---@type LazySpec
return {
    'nvim-mini/mini.nvim',
    version = false,
    -- TODO: Add mini.picker.
    config = function()
        require('mini.animate').setup()
        require('mini.icons').setup()
        require('mini.statusline').setup()
        require('mini.notify').setup()
        require('mini.cmdline').setup()
        require('mini.pick').setup()
        require('mini.trailspace').setup()
        require('mini.pairs').setup()
        require('mini.bracketed').setup()
        require('mini.ai').setup()
    end,
}
