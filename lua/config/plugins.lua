-- Plugin manifest using Neovim's native plugin manager (`vim.pack`).
-- Lockfile lives at ~/.config/nvim/nvim-pack-lock.json (commit it).
--
-- After editing this file, restart Neovim or run `:lua vim.pack.update()`.
vim.pack.add({
    -- Colorscheme
    { src = 'https://github.com/rmehri01/onenord.nvim' },
    { src = 'https://github.com/fcancelinha/nordern.nvim' },

    -- Icons
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },

    -- File explorer
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },

    -- LSP server definitions
    { src = 'https://github.com/neovim/nvim-lspconfig' },

    -- Completion
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.0') },

    -- Treesitter (stable master branch: ships pre-built parsers, no extra CLI required).
    -- The `main` branch is the future but requires the `tree-sitter` CLI to build parsers
    -- from source. Stick to master until your toolchain is ready.
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'master' },

    -- Picker
    { src = 'https://github.com/ibhagwan/fzf-lua' },

    -- UI / DX
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/windwp/nvim-autopairs' },
})

------------------------------------------------------------
-- Colorscheme
------------------------------------------------------------

require('nordern').setup({
    transparent = true,
    italic_comments = false,
})
vim.cmd.colorscheme('nordern')

-- Overrides Aurora
local set = vim.api.nvim_set_hl
set(0, '@keyword.sql',      { fg = '#B48EAD' })
set(0, '@type.sql',         { fg = '#EBCB8B' })
set(0, '@keyword.python',   { fg = '#B48EAD' })
set(0, '@function.python',  { fg = '#A3BE8C' })

-- require('onenord').setup({
--     theme = nil,
--     borders = true,
--     fade_nc = false,
--     styles = {
--         comments = 'NONE',
--         strings = 'NONE',
--         keywords = 'NONE',
--         functions = 'NONE',
--         variables = 'NONE',
--         diagnostics = 'underline',
--     },
--     disable = {
--         background = true,
--         cursorline = false,
--         eob_lines = true,
--     },
--     inverse = { match_paren = false },
--     custom_highlights = {},
--     custom_colors = {},
-- })
-- vim.cmd.colorscheme('onenord')

------------------------------------------------------------
-- File explorer
------------------------------------------------------------
require('nvim-tree').setup({
    diagnostics = { enable = true },
    update_focused_file = { enable = true, update_root = true },
    renderer = { highlight_git = true },
})

------------------------------------------------------------
-- Treesitter (master-branch API, with parser list derived from languages.lua)
------------------------------------------------------------
local langs = require('config.languages')
local ts_parsers = {}
for _, spec in pairs(langs) do
    for _, parser in ipairs(spec.treesitter or {}) do
        if not vim.tbl_contains(ts_parsers, parser) then
            table.insert(ts_parsers, parser)
        end
    end
end

require('nvim-treesitter.configs').setup({
    ensure_installed = ts_parsers,
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_, buf)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection    = '<C-space>',
            node_incremental  = '<C-space>',
            node_decremental  = '<bs>',
            scope_incremental = false,
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start     = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
            goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
        },
    },
})

------------------------------------------------------------
-- Completion + snippets (blink.cmp)
------------------------------------------------------------
require('blink.cmp').setup({
    keymap = {
        preset = 'super-tab',
        ['<CR>'] = { 'accept', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        list = { selection = { preselect = true, auto_insert = false } },
    },
    sources = {
        default = { 'lsp', 'path', 'buffer' },
    },
    signature = { enabled = true },
})

------------------------------------------------------------
-- UI / DX
------------------------------------------------------------
require('lualine').setup({
    options = {
        theme = 'nordern',
        globalstatus = true,
        section_separators = '',
        component_separators = '',
    },
    sections = {
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'diagnostics', 'encoding', 'fileformat', 'filetype' },
    },
})

require('nvim-autopairs').setup({})

require('fzf-lua').setup({})
