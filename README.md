# Neovim configuration

Personal Neovim config for macOS/Linux. Targets **Neovim 0.12+** with the built-in plugin manager (`vim.pack`), native LSP configuration (`vim.lsp.config` / `vim.lsp.enable`), and Mason for binaries.

## Requirements

- **Neovim** >= 0.12 (`nvim -v`)
- **Git** (`vim.pack` clones plugins)
- **True-color terminal** (most modern terminals; `termguicolors` is enabled)
- **Optional**: [`fzf`](https://github.com/junegunn/fzf) on `PATH` for the best `fzf-lua` experience (falls back gracefully if missing)

## Quick start

1. Clone into your config path (or use this repo directly):

   ```bash
   git clone https://github.com/Serms1999/NeoVim-Configuration.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
   ```

2. Start Neovim once. On first launch, `vim.pack` installs every plugin listed in [`lua/config/plugins.lua`](lua/config/plugins.lua). Restart if prompted.

3. The lockfile [`nvim-pack-lock.json`](nvim-pack-lock.json) pins exact revisions—commit it so every machine gets the same plugin state.

4. After plugins load, **Mason** installs language servers and tools in the background. Open `:Mason` to watch progress or install extras.

## Architecture

| Concern | File / location |
|--------|------------------|
| Entry point | [`init.lua`](init.lua) |
| Options, plugins, LSP, keymaps | [`lua/config/`](lua/config/) |
| **Which language → which tools** | [`lua/config/languages.lua`](lua/config/languages.lua) — edit this to add or change stacks |
| Per-server LSP overrides | [`lsp/<server>.lua`](lsp/) (Neovim 0.11+ convention) |
| Plugin URLs + UI plugin setup | [`lua/config/plugins.lua`](lua/config/plugins.lua) |
| Mason, `vim.lsp.config`, conform, lint | [`lua/config/lsp.lua`](lua/config/lsp.lua) |

### Generic LSP selection (no hard-coded server names in logic)

[`lua/config/languages.lua`](lua/config/languages.lua) lists **ordered candidates** per language, e.g. Python:

```lua
lsp = { 'basedpyright', 'pyright', 'pylsp' },
```

At startup, the first name that Mason can install wins. To prefer **Pyright** over **Basedpyright**, swap the order—no other file needs to change. Optional per-server settings still live in [`lsp/pyright.lua`](lsp/pyright.lua) and [`lsp/basedpyright.lua`](lsp/basedpyright.lua); unused configs are harmless.

Formatter/linter names occasionally differ from Mason package names. Aliases are mapped in [`lua/config/lsp.lua`](lua/config/lsp.lua) (`MASON_ALIAS`, e.g. `ruff_format` → `ruff`).

### Plugins (summary)

- **Manager**: `vim.pack` (built-in), lockfile: `nvim-pack-lock.json`
- **UI**: onenord, lualine, gitsigns, which-key, indent-blankline
- **Explorer**: nvim-tree (`<leader>e`)
- **Picker**: fzf-lua (`<leader>f…`)
- **LSP**: nvim-lspconfig + Mason + mason-lspconfig + mason-tool-installer
- **Completion**: blink.cmp + LuaSnip
- **Format / lint**: conform.nvim + nvim-lint
- **Treesitter**: nvim-treesitter + textobjects (parser list derived from `languages.lua`)

### LaTeX tree-sitter

The `latex` grammar often requires the external **tree-sitter** CLI. This config therefore does **not** auto-install the LaTeX parser; TeX files use classic syntax highlighting until you install the CLI and add `latex` back under `treesitter` in `languages.lua`.

## Maintenance

Update plugins (review the confirmation buffer that `vim.pack` may open):

```vim
:lua vim.pack.update()
```

Health checks:

```vim
:checkhealth
```

## Keyboard (basics)

| Keys | Action |
|------|--------|
| `<leader>` | Space |
| `<leader>e` | Toggle file tree |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>w` / `<leader>q` | Save / quit window |
| `[d` / `]d` | Previous / next diagnostic |
| `gd` / `K` | Go to definition / hover (LSP buffers) |
| `<leader>f` | Format buffer (conform + LSP fallback) |

## License

See repository default; configuration is provided as-is.
