vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.cc = 'zig cc'
vim.g.loaded_netrwPlugin = 1

local gh = function(url) return 'https://github.com/' .. url end
local cb = function(url) return 'https://codeberg.org/' .. url end
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt
local map = vim.keymap.set

--- use <C-x><C-f> for file completion
--- use <C-x><C-o> for omnicompletion triggers
--- use <C-]> for definition under cursor
-- use <C-t> for going back one level in history (Back button)
-- <g-C-}> for showing an interactive selection menu if a tag is duplicated
-- ':tags' for showing a history stack of our tag journey

--- TODO: Make this check for already-generated ctags files and append with -a.
local maketags = function()
    -- CTags is basically LSP but no 'S' or 'P'.
    if vim.fn.executable('ctags') ~= 1 then
        vim.notify('ctags is either not installed, or not in $PATH.', vim.log.levels.INFO)
        return
    else
        vim.fn.jobstart({ 'ctags', '-R', '.' }, {
            detach = true,
            on_exit = function(_, code)
                if code ~= 0 then vim.notify('ctags failed for some reason', vim.log.levels.INFO) end
            end,
        })
    end
end

--- utility: terminal buffer ---
local make_terminal_buffer = function(default_prog)
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, 'Termed')
    vim.api.nvim_win_set_buf(0, buf)

    -- cursor at the absolute beginning
    vim.api.nvim_buf_set_option(buf, 'filetype', 'termed')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })

    local job_id
    local last_sent_cmd = ''
    local prompt_ns_id = vim.api.nvim_create_namespace('TermedPrompt')

    local render_prompt = function()
        vim.api.nvim_buf_clear_namespace(buf, prompt_ns_id, 0, -1)
        local total_lines = vim.api.nvim_buf_line_count(buf)
        -- Places a virtual '>' in front of the last active line
        vim.api.nvim_buf_set_extmark(buf, prompt_ns_id, total_lines - 1, 0, {
            virt_text = { { '>', 'TermedVPrompt' } },
            virt_text_pos = 'overlay', -- Overlay hides column 0 visually without adding bytes
        })
    end

    local get_stdout = function(_, data, _)
        if data then
            local lines_added = false
            for _, line in ipairs(data) do
                -- carriage return cleanup
                line = line:gsub('\r', '')
                -- strip whitespace
                local clean_line = line:gsub('%s*$', '')
                if line ~= '' then
                    -- I have no clue how this line works, it's AI-generated.
                    local is_prompt = line:match('^%a:[\\%w%s%p]+>$')
                        or line:match('^Microsoft Windows')
                        or line:match('^%s*P%s*S%s+.*>$')
                    -- HACK: Check if what we sent came back to us
                    local is_echo = (clean_line == last_sent_cmd) or (clean_line == '@echo off')
                    if not is_prompt and not is_echo then
                        vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
                        lines_added = true
                    end
                end
            end

            if lines_added then
                vim.schedule(function()
                    local total_lines = vim.api.nvim_buf_line_count(buf)
                    vim.api.nvim_win_set_cursor(0, { total_lines, 0 })
                end)
                render_prompt()
            end
        end
    end

    local spawn_line = function()
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, { '' })
        local total_lines = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_win_set_cursor(0, { total_lines, 0 })
        render_prompt()
    end

    local send_current_line = function()
        local current_line = vim.api.nvim_get_current_line()
        last_sent_cmd = current_line:gsub('%s*$', '')
        vim.api.nvim_chan_send(job_id, current_line .. '\n')
        vim.schedule(spawn_line)
    end

    local prog = default_prog or 'cmd.exe'
    local spawn_cmd = { prog }

    -- headless background arguments to prevent shell replication
    if prog == 'powershell.exe' or prog == 'pwsh' then spawn_cmd = { prog, '-NoProfile', '-Command', '-' } end

    job_id = vim.fn.jobstart(spawn_cmd, {
        on_stdout = get_stdout,
        stdout_buffered = false,
    })

    if prog == 'cmd.exe' then vim.api.nvim_chan_send(job_id, '@echo off\n') end
    -- initial rendering
    render_prompt()
    map('n', '<CR>', send_current_line, { buffer = buf, noremap = true, silent = true })
end

vim.pack.add({
    { src = gh('shaunsingh/nord.nvim') },
    { src = gh('nvim-mini/mini.nvim') },
    { src = gh('mason-org/mason.nvim') },
    { src = gh('WhoIsSethDaniel/mason-tool-installer.nvim') },
    { src = gh('mfussenegger/nvim-lint') },
    { src = gh('stevearc/oil.nvim') },
    { src = gh('stevearc/conform.nvim') },
    { src = cb('cryptomilk/nvim-pack-ui') },
    { src = cb('andyg/leap.nvim') },
})

----- options -----
vim.o.winborder = 'single'
vim.o.pumborder = 'single'
vim.o.complete = '.,w,b,o,u,t'
vim.o.completeopt = 'fuzzy,menuone,noselect'
-- Defines how completion behaves when you press <Tab>
vim.o.wildmode = 'longest:full,full'
-- Configures the visual presentation of the completion menu
vim.o.wildoptions = 'pum'

local indent = 4

opt.clipboard:append('unnamedplus')

opt.encoding = 'utf-8'
opt.matchpairs = { '(:)', '{:}', '[:]', '<:>' }

-- first search in the current directory, then into parent folders recursively.
--opt.tags = './tags;,tags;'

opt.autoindent = true
opt.expandtab = false
opt.shiftwidth = indent
opt.smartindent = true
opt.tabstop = indent
opt.swapfile = false

opt.foldlevelstart = 99
opt.foldmethod = 'syntax'

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.termguicolors = true
opt.guicursor = 'a:block'
opt.showmode = false
opt.hlsearch = false
opt.colorcolumn = '80,100'

opt.scrolloff = 8
opt.wrap = true

opt.history = 100
opt.redrawtime = 1500
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.updatetime = 100

vim.cmd([[filetype plugin indent on]])

map('i', 'jj', '<ESC>')

map('n', '<leader>w', '<cmd>w<CR>', { desc = 'save current buffer.' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = '[q]uit.' })

map('n', '<leader>h', '<C-w>h', { desc = 'switch window left.' })
map('n', '<leader>l', '<C-w>l', { desc = 'switch window right.' })
map('n', '<leader>k', '<C-w>k', { desc = 'switch window up.' })
map('n', '<leader>j', '<C-w>j', { desc = 'switch window down.' })

map('n', '<leader>qf', '<cmd>copen<CR>', { desc = 'Open [q]uick[f]ix list.' })
map('n', '<leader>qc', '<cmd>cclose<CR>', { desc = '[q]uickfix list: [c]lose.' })

map({ 'n', 'i', 'v' }, '<Up>', '<nop>')
map({ 'n', 'i', 'v' }, '<Down>', '<nop>')
map({ 'n', 'i', 'v' }, '<Left>', '<nop>')
map({ 'n', 'i', 'v' }, '<Right>', '<nop>')

map(
    'n',
    '<leader>ph',
    function() require('mini.pick').builtin.help() end,
    { desc = '[p]ick [h]elp menu entries (mini.nvim)' }
)

map({ 'n', 'v' }, '<leader>f', '<cmd>Oil<cr>', { desc = 'Open oil.nvim' })
map({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'leap search local' })
map('n', 'S', '<Plug>(leap-from-window)', { desc = 'leap in other window' })

require('plugins').setup()

local getmode = function()
    local mode_table = {
        ['n'] = 'NORMAL',
        ['no'] = 'OP_PENDING',
        ['nov'] = 'OP_PENDING',
        ['noV'] = 'OP_PENDING',
        ['no\22'] = 'OP_PENDING',
        ['niI'] = 'NORMAL',
        ['niR'] = 'NORMAL',
        ['niV'] = 'NORMAL',
        ['nt'] = 'NORMAL',
        ['ntT'] = 'NORMAL',
        ['v'] = 'VISUAL',
        ['vs'] = 'VISUAL',
        ['V'] = 'V-LINE',
        ['Vs'] = 'V-LINE',
        ['\22'] = 'V-BLOCK',
        ['\22s'] = 'V-BLOCK',
        ['s'] = 'SELECT',
        ['S'] = 'S-LINE',
        ['\19'] = 'S-BLOCK',
        ['i'] = 'INSERT',
        ['ic'] = 'INSERT',
        ['ix'] = 'INSERT',
        ['R'] = 'REPLACE',
        ['Rc'] = 'REPLACE',
        ['Rx'] = 'REPLACE',
        ['Rv'] = 'V-REPLACE',
        ['Rvc'] = 'V-REPLACE',
        ['Rvx'] = 'V-REPLACE',
        ['c'] = 'COMMAND',
        ['cv'] = 'EX',
        ['ce'] = 'EX',
        ['r'] = 'REPLACE',
        ['rm'] = 'MORE',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        ['t'] = 'TERMINAL',
    }
    return mode_table[vim.fn.mode()]
end

function _G.mystatusline()
    require('mini.git')
    local summary = vim.b.minigit_summary_string or '?'
    local git_data = 'Git: ' .. summary
    return getmode() .. '%=' .. git_data
end

function _G.mywinbar()
    local filename = vim.fn.expand('%:~:.')
    local modified = ' %m'
    if filename == '' then filename = '[no name]' end
    return filename .. modified .. '%='
end

autocmd('User', {
    pattern = 'MiniGitUpdated',
    group = augroup('my.statusline.git', { clear = true }),
    command = 'redrawstatus',
})

opt.winbar = '%{%v:lua.mywinbar()%}'
opt.statusline = '%!v:lua.mystatusline()'

-- Highlight yanked text
autocmd('TextYankPost', {
    pattern = '*',
    callback = function() vim.hl.on_yank({ timeout = 170 }) end,
    group = augroup('YankHighlight', { clear = true }),
})

-- TODO: Find a better way to implement this, or replace everything with tags and a linter..
autocmd('LspAttach', {
    group = augroup('my.lsp', { clear = true }),
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        -- Keymaps for things to do with the LSP server
        if client:supports_method('textDocument/definition') then map('n', 'gd', vim.lsp.buf.definition, opts) end

        if client:supports_method('textDocument/declaration') then map('n', 'gD', vim.lsp.buf.declaration, opts) end

        if client:supports_method('textDocument/implementation') then
            map('n', 'gi', vim.lsp.buf.implementation, opts)
        end

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        if client:supports_method('textDocument/references') then map('n', 'gr', vim.lsp.buf.references, opts) end

        if client:supports_method('textDocument/typeDefinition') then
            map('n', 'gy', vim.lsp.buf.type_definition, opts)
        end

        vim.keymap.set('n', 'K', function()
            local max_width = math.max(20, math.floor(vim.api.nvim_win_get_width(0) * 0.5))
            vim.lsp.buf.hover({ max_width = max_width })
        end, opts)
        map(
            'n',
            '<leader>th',
            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
            { desc = '[t]oggle inlay [h]ints' }
        )
    end,
})

-- Thanks to u/SergioVim in the r/neovim August monthly dotfile review thread..
autocmd('BufReadPost', {
    group = augroup('my.cursor', { clear = true }),
    desc = 'Restore cursor position when opening a file',
    callback = function(event)
        local exclude = { 'gitcommit', 'COMMIT_EDITMSG' }
        local ft = vim.bo[event.buf].filetype

        if vim.tbl_contains(exclude, ft) or vim.b[event.buf].lazy_user_have_location then return end

        vim.b[event.buf].lazy_user_have_location = true
        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
        local lcount = vim.api.nvim_buf_line_count(event.buf)

        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

autocmd('BufWritePost', {
    callback = function()
        require('lint').try_lint()
        vim.diagnostic.setqflist({ open = false })
    end,
})

autocmd('FileType', {
    pattern = { 'c', 'go', 'make', 'dosbatch', 'ps1', 'sh' },
    callback = function()
        vim.opt_local.tabstop = 8
        vim.opt_local.shiftwidth = 8
        vim.opt_local.expandtab = true
        vim.opt_local.cindent = true
    end,
})

autocmd('FileType', {
    group = augroup('my.treesitter', { clear = true }),
    pattern = '*',
    callback = function(event)
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
        if pcall(vim.treesitter.add, lang) then vim.treesitter.start(event.buf, lang) end
    end,
})

autocmd('FileType', {
    group = augroup('my.termed', { clear = true }),
    pattern = { 'termed' },
    callback = function() vim.opt_local.statusline = ' %#DiagnosticWarn#   TERMED %= Line: %l/%L ' end,
})

local delete_qf_line = function()
    local qf = vim.fn.getqflist()

    -- remove and update list
    table.remove(qf, vim.fn.line('.'))

    vim.fn.setqflist(qf, 'r')

    vim.fn.cmd('copen')
    local total_lines = #qf
    local target_line = math.min(vim.fn.line('.'), total_lines)
    if target_line > 0 then vim.api.nvim_win_set_cursor(0, { target_line, 0 }) end
end

autocmd('FileType', {
    pattern = 'qf',
    callback = function() map('n', 'dd', delete_qf_line, { buffer = true, silent = true }) end,
})

autocmd({ 'FileType', 'BufWinEnter' }, {
    pattern = '*',
    callback = function(args)
        local is_valid = vim.api.nvim_buf_is_valid(args.buf)
        if not is_valid then
            return
        else
            local alert_pattern = [[\v<(TODO|BUG|HACK|FIXME|XXX|NOTE):?]]
            vim.fn.matchadd('Todo', alert_pattern, 10, -1, { window = 0 })
        end
    end,
})

vim.api.nvim_create_user_command('Termed', function(opts)
    local prog = opts.fargs[1] or nil
    make_terminal_buffer(prog)
end, { nargs = '?', desc = 'Open an empty buffer you can use like a terminal into.' })

vim.cmd('colorscheme nord')
vim.g.nord_disable_background = true
require('nord').set()

-- end of my config! --
