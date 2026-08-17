-- Native LSP pipeline (Neovim 0.11+). No Mason: binaries come from the system.
-- Driven entirely by `lua/config/languages.lua`; this file is generic.

local langs = require('config.languages')

-- Map server name -> executable name, only where they differ.
local EXECUTABLE = {
    bashls                 = 'bash-language-server',
    lua_ls                 = 'lua-language-server',
    basedpyright           = 'basedpyright-langserver',
    pyright                = 'pyright-langserver',
    neocmake               = 'neocmakelsp',
    cmake                  = 'cmake-language-server',
    dockerls               = 'docker-langserver',
    kotlin_language_server = 'kotlin-language-server',
    -- Binary name == server name (no entry needed): ty, clangd, texlab, jdtls, sqls
}

-- Enable the first candidate whose binary is on PATH.
local to_enable = {}
for _, spec in pairs(langs) do
    for _, server in ipairs(spec.lsp or {}) do
        local bin = EXECUTABLE[server] or server
        if vim.fn.executable(bin) == 1 then
            table.insert(to_enable, server)
            break
        end
    end
end

-- Defaults shared by every client. Per-server overrides in `lsp/<server>.lua`.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config('*', {
    capabilities = capabilities,
    root_markers = { '.git', '.hg' },
})

vim.lsp.enable(to_enable)

-- Diagnostics presentation
vim.diagnostic.config({
    virtual_text = { spacing = 2, prefix = '●' },
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    float = { border = 'rounded', source = true },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN]  = '',
            [vim.diagnostic.severity.INFO]  = '',
            [vim.diagnostic.severity.HINT]  = '',
        },
    },
})

-- Buffer-local keymaps when a server attaches
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP buffer keymaps',
    callback = function(ev)
        local o = function(desc)
            return { noremap = true, silent = true, buffer = ev.buf, desc = desc }
        end
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition,        o('LSP: definition'))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,       o('LSP: declaration'))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,    o('LSP: implementation'))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references,        o('LSP: references'))
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover,             o('LSP: hover'))
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, o('LSP: signature'))
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, o('LSP: type definition'))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,    o('LSP: rename'))
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, o('LSP: code action'))
    end,
})

-- Debug: uncomment to see which servers got enabled
-- vim.notify('LSP enabled: ' .. vim.inspect(to_enable))
