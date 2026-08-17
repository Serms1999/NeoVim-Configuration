-- lsp/ty.lua
return {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ty.toml', 'setup.py', 'requirements.txt', '.git' },
}
