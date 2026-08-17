-- Central language registry.
-- Each entry maps a logical language name to:
--   lsp        : ordered list of LSP candidates (first available on PATH wins)
--   filetypes  : Neovim filetypes that map to this language
--   treesitter : list of tree-sitter parsers to ensure installed
--
return {
    bash = {
        lsp = { 'bashls' },
        filetypes = { 'sh', 'bash' },
        treesitter = { 'bash' },
    },
    c = {
        lsp = { 'clangd' },
        filetypes = { 'c' },
        treesitter = { 'c' },
    },
    cpp = {
        lsp = { 'clangd' },
        filetypes = { 'cpp' },
        treesitter = { 'cpp' },
    },
    cmake = {
        lsp = { 'neocmake', 'cmake' },
        filetypes = { 'cmake' },
        treesitter = { 'cmake' },
    },
    docker = {
        lsp = { 'dockerls' },
        filetypes = { 'dockerfile' },
        treesitter = { 'dockerfile' },
    },
    java = {
        lsp = { 'jdtls' },
        filetypes = { 'java' },
        treesitter = { 'java' },
    },
    kotlin = {
        lsp = { 'kotlin_language_server' },
        filetypes = { 'kotlin' },
        treesitter = { 'kotlin' },
    },
    latex = {
        lsp = { 'texlab' },
        filetypes = { 'tex', 'plaintex' },
        -- `latex` tree-sitter grammar requires the external `tree-sitter` CLI to
        -- generate the parser. Omit it here so Neovim falls back to Vimtex-style
        -- syntax highlighting until you install the CLI and re-add `latex`.
        treesitter = {},
    },
    lua = {
        lsp = { 'lua_ls' },
        filetypes = { 'lua' },
        treesitter = { 'lua', 'luadoc' },
    },
    python = {
        lsp = { 'ty', 'basedpyright' },
        filetypes = { 'python' },
        treesitter = { 'python' },
    },
    sql = {
        lsp = { 'sqls', 'sqlls' },
        filetypes = { 'sql', 'mysql', 'plsql' },
        treesitter = { 'sql' },
    },
}
