-- LSP + Mason + format/lint pipeline.
-- Driven entirely by `lua/config/languages.lua`; this file is generic.

local langs = require('config.languages')

------------------------------------------------------------
-- Mason (must come first so the registry is available)
------------------------------------------------------------
require('mason').setup({
    max_concurrent_installers = 4,
    ui = {
        border = 'rounded',
        check_outdated_packages_on_open = true,
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
    },
})

------------------------------------------------------------
-- Resolve LSP candidates: pick the first one Mason recognises
-- per language. This decouples the config from concrete LSP names.
------------------------------------------------------------
local mason_lspconfig = require('mason-lspconfig')
local mappings_ok, mappings = pcall(mason_lspconfig.get_mappings)
local lspconfig_to_package = mappings_ok and mappings.lspconfig_to_package or {}
local registry = require('mason-registry')

local lsps_to_install = {}
local seen_lsp = {}

for _, spec in pairs(langs) do
    for _, candidate in ipairs(spec.lsp or {}) do
        local pkg = lspconfig_to_package[candidate]
        if pkg and registry.has_package(pkg) then
            if not seen_lsp[candidate] then
                table.insert(lsps_to_install, candidate)
                seen_lsp[candidate] = true
            end
            break
        end
    end
end

------------------------------------------------------------
-- mason-lspconfig v2: ensure_installed + automatic_enable
-- automatic_enable triggers vim.lsp.enable() per server automatically.
------------------------------------------------------------
mason_lspconfig.setup({
    ensure_installed = lsps_to_install,
    automatic_enable = true,
})

------------------------------------------------------------
-- Defaults shared by every LSP client (capabilities, root markers, etc.)
-- Per-server overrides live in `lsp/<server>.lua` (Neovim 0.11+ runtimepath).
------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config('*', {
    capabilities = capabilities,
    root_markers = { '.git', '.hg' },
})

------------------------------------------------------------
-- Diagnostics presentation
------------------------------------------------------------
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

------------------------------------------------------------
-- Buffer-local LSP keymaps when a server attaches
------------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP buffer keymaps',
    callback = function(ev)
        local bufopts = function(desc)
            return { noremap = true, silent = true, buffer = ev.buf, desc = desc }
        end
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts('LSP: definition'))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts('LSP: declaration'))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts('LSP: implementation'))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts('LSP: references'))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts('LSP: hover'))
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts('LSP: signature'))
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts('LSP: type definition'))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts('LSP: rename'))
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, bufopts('LSP: code action'))
        vim.keymap.set('n', '<leader>f', function()
            require('conform').format({ async = true, lsp_format = 'fallback' })
        end, bufopts('LSP: format'))
    end,
})

------------------------------------------------------------
-- conform.nvim: formatters per filetype, derived from `languages.lua`
------------------------------------------------------------
local formatters_by_ft = {}
for _, spec in pairs(langs) do
    if spec.formatters and #spec.formatters > 0 then
        for _, ft in ipairs(spec.filetypes or {}) do
            formatters_by_ft[ft] = spec.formatters
        end
    end
end

require('conform').setup({
    formatters_by_ft = formatters_by_ft,
    default_format_opts = { lsp_format = 'fallback' },
    format_on_save = function(buf)
        if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
            return
        end
        return { timeout_ms = 1000, lsp_format = 'fallback' }
    end,
})

vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, { desc = 'Disable autoformat-on-save (use ! for buffer only)', bang = true })

vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = 'Re-enable autoformat-on-save' })

------------------------------------------------------------
-- nvim-lint: linters per filetype, derived from `languages.lua`
------------------------------------------------------------
local linters_by_ft = {}
for _, spec in pairs(langs) do
    if spec.linters and #spec.linters > 0 then
        for _, ft in ipairs(spec.filetypes or {}) do
            linters_by_ft[ft] = spec.linters
        end
    end
end

local lint = require('lint')
lint.linters_by_ft = linters_by_ft

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    desc = 'Run linters when buffer changes',
    callback = function()
        if next(lint.linters_by_ft) then
            lint.try_lint()
        end
    end,
})

------------------------------------------------------------
-- mason-tool-installer: ensure formatters/linters are installed.
-- Some tool names used by conform.nvim / nvim-lint are aliases that do not
-- match the underlying Mason package name. Translate here so that the
-- single source of truth in `languages.lua` stays runtime-oriented.
------------------------------------------------------------
local MASON_ALIAS = {
    ruff_format  = 'ruff',
    clang_format = 'clang-format',
    sql_formatter = 'sql-formatter',
}

local tools = {}
local seen_tool = {}
local function add_tool(name)
    if not name then return end
    local pkg = MASON_ALIAS[name] or name
    if not seen_tool[pkg] then
        table.insert(tools, pkg)
        seen_tool[pkg] = true
    end
end
for _, spec in pairs(langs) do
    for _, f in ipairs(spec.formatters or {}) do add_tool(f) end
    for _, l in ipairs(spec.linters or {}) do add_tool(l) end
end

require('mason-tool-installer').setup({
    ensure_installed = tools,
    run_on_start = true,
    auto_update = false,
    start_delay = 3000,
})
