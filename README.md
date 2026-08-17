# Neovim configuration

Personal Neovim config for macOS and Linux. Minimal by design: a comfortable
editor for scripts and quick edits.

Built on **Neovim 0.12+** with the built-in plugin manager (`vim.pack`) and
native LSP (`vim.lsp.config` / `vim.lsp.enable`). Language server binaries come
from the system package manager, which keeps versions under your control and
identical across machines.

## Requirements

- **Neovim** >= 0.12 (`nvim -v`)
- **Git** — `vim.pack` clones plugins
- A **true-color terminal** (`termguicolors` is enabled)
- A **Nerd Font** in the terminal, for the icons in nvim-tree and lualine
- The system binaries listed below, for the languages you care about

## Install

```bash
git clone https://github.com/Serms1999/NeoVim-Configuration.git \
  "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

Start Neovim. `vim.pack` installs every plugin declared in
[`lua/config/plugins.lua`](lua/config/plugins.lua) and pins them in
[`nvim-pack-lock.json`](nvim-pack-lock.json) — commit that file so every machine
lands on the same revisions.

Then install the binaries for the languages you use. A missing binary is not an
error: that language server simply stays inactive.

## System dependencies

Neovim uses these binaries; it never installs them.

### Arch Linux

```bash
sudo pacman -S --needed neovim git fzf ripgrep fd \
  lua-language-server bash-language-server clang go
paru -S basedpyright        # AUR
```

### macOS

```bash
brew install neovim git fzf ripgrep fd \
  lua-language-server bash-language-server llvm go basedpyright
```

`clangd` ships inside `llvm`. Homebrew does not link it by default, so you may
need `$(brew --prefix llvm)/bin` on your `PATH`.

### Both platforms

```bash
uv tool install ty                                  # Python LSP
go install github.com/sqls-server/sqls@<version>    # SQL LSP
```

Both land outside the system package manager, so make sure `$UV_BIN_DIR` (or
wherever `uv` places tools) and `$GOBIN` are on your `PATH`.

Neovim inherits the `PATH` of the process that starts it. Define it in
`.zshenv`, which is always sourced, rather than `.zprofile`, which only runs for
login shells — otherwise a server may be visible in the shell but not inside
Neovim.

### Optional

- `chafa` — image previews in the fzf-lua picker

## Layout

| Concern | Location |
|---------|----------|
| Entry point | [`init.lua`](init.lua) |
| Options, plugins, LSP, keymaps, autocommands | [`lua/config/`](lua/config/) |
| **Languages and their LSP** | [`lua/config/languages.lua`](lua/config/languages.lua) |
| LSP wiring and diagnostics | [`lua/config/lsp.lua`](lua/config/lsp.lua) |
| Plugin list and plugin setup | [`lua/config/plugins.lua`](lua/config/plugins.lua) |
| Per-server LSP settings | [`lsp/<server>.lua`](lsp/) |
| Keymap reference | [`doc/cheatsheet.txt`](doc/) → `:h cheatsheet` |

### Language registry

[`lua/config/languages.lua`](lua/config/languages.lua) is the single source of
truth. Each language declares ordered LSP candidates, its filetypes and its
tree-sitter parsers:

```lua
python = {
    lsp = { 'ty', 'basedpyright' },
    filetypes = { 'python' },
    treesitter = { 'python' },
},
```

At startup, `lsp.lua` walks each candidate list and enables the **first server
whose binary is on `PATH`**. Reorder the list to change preference, or install a
different binary — nothing else needs editing.

`nvim-lspconfig` provides the launch details for each server (`cmd`,
`filetypes`, `root_markers`). Files under [`lsp/`](lsp/) add per-server
`settings` on top of that.

### Plugins

| Purpose | Plugin |
|---------|--------|
| Manager | `vim.pack` (built-in) |
| Colorscheme | nordern, with onenord available as an alternative |
| LSP definitions | nvim-lspconfig |
| Completion | blink.cmp |
| Syntax and textobjects | nvim-treesitter, nvim-treesitter-textobjects |
| File explorer | nvim-tree |
| Picker | fzf-lua |
| Statusline | lualine |
| Brackets | nvim-autopairs |
| Icons | nvim-web-devicons |

## Maintenance

```vim
:lua vim.pack.update()   " update plugins, then commit the lockfile
:checkhealth             " environment and plugin health
:checkhealth lsp         " enabled configurations and active clients
:h cheatsheet            " keymap reference
```

Commit `nvim-pack-lock.json` after every update and pull it on the other
machines; that is what keeps them from drifting apart.

## Keymaps

Leader is `<Space>`. Full reference: `:h cheatsheet`.

| Keys | Action |
|------|--------|
| `<leader>e` | Toggle file tree |
| `<leader>ff` / `<leader>fg` | Find files / live grep |
| `<leader>w` / `<leader>q` | Write / quit window |
| `gd` / `K` / `gr` | Definition / hover / references |
| `[d` / `]d` | Previous / next diagnostic |
| `gcc` | Toggle comment |

## Further reading

[`GUIDE.md`](GUIDE.md) covers how to add languages, switch LSP servers, manage
plugins and troubleshoot.

## License

See repository default; configuration is provided as-is.
