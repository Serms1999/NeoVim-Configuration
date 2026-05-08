local map = vim.keymap.set
local function opts(desc) return { noremap = true, silent = true, desc = desc } end

------------------------------------------------------------
-- General
------------------------------------------------------------
map('n', '<leader>w', '<cmd>write<cr>', opts('Save buffer'))
map('n', '<leader>q', '<cmd>quit<cr>', opts('Quit window'))
map('n', '<leader>Q', '<cmd>qa!<cr>', opts('Quit all (force)'))
map('n', '<Esc>', '<cmd>nohlsearch<cr>', opts('Clear search highlight'))

------------------------------------------------------------
-- Windows
------------------------------------------------------------
map('n', '<C-h>', '<C-w>h', opts('Window: left'))
map('n', '<C-j>', '<C-w>j', opts('Window: down'))
map('n', '<C-k>', '<C-w>k', opts('Window: up'))
map('n', '<C-l>', '<C-w>l', opts('Window: right'))

------------------------------------------------------------
-- Buffers
------------------------------------------------------------
map('n', '[b', '<cmd>bprevious<cr>', opts('Buffer: previous'))
map('n', ']b', '<cmd>bnext<cr>', opts('Buffer: next'))
map('n', '<leader>bd', '<cmd>bdelete<cr>', opts('Buffer: delete'))

------------------------------------------------------------
-- Diagnostics
------------------------------------------------------------
map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts('Diagnostic: previous'))
map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts('Diagnostic: next'))
map('n', '<leader>dl', vim.diagnostic.open_float, opts('Diagnostic: line float'))
map('n', '<leader>dq', vim.diagnostic.setloclist, opts('Diagnostic: loclist'))

------------------------------------------------------------
-- Terminal escape
------------------------------------------------------------
map('t', '<C-\\><C-n>', [[<C-\><C-n>]], opts('Terminal: normal mode'))
map('t', '<Esc><Esc>', [[<C-\><C-n>]], opts('Terminal: normal mode (Esc Esc)'))

------------------------------------------------------------
-- Visual: keep selection while indenting
------------------------------------------------------------
map('v', '<', '<gv', opts('Indent left, keep selection'))
map('v', '>', '>gv', opts('Indent right, keep selection'))

------------------------------------------------------------
-- File explorer
------------------------------------------------------------
map('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', opts('Explorer: toggle'))

------------------------------------------------------------
-- Picker (fzf-lua)
------------------------------------------------------------
map('n', '<leader>ff', function() require('fzf-lua').files() end, opts('Find: files'))
map('n', '<leader>fg', function() require('fzf-lua').live_grep() end, opts('Find: grep'))
map('n', '<leader>fb', function() require('fzf-lua').buffers() end, opts('Find: buffers'))
map('n', '<leader>fh', function() require('fzf-lua').helptags() end, opts('Find: help'))
map('n', '<leader>fr', function() require('fzf-lua').oldfiles() end, opts('Find: recent files'))
map('n', '<leader>fd', function() require('fzf-lua').diagnostics_workspace() end, opts('Find: diagnostics'))
map('n', '<leader>fs', function() require('fzf-lua').lsp_document_symbols() end, opts('Find: doc symbols'))
map('n', '<leader>fS', function() require('fzf-lua').lsp_workspace_symbols() end, opts('Find: workspace symbols'))
