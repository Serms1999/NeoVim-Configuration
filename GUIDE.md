# Quick guide to this Neovim setup 

How to use the stack (`vim.pack`, Mason, native LSP, conform, lint, blink.cmp, fzf-lua, etc.) and which files to edit when you want to change something.

**Leader:** `<Space>`.

---

## 1. Where everything lives

| What you want to change | Usual file |
|-------------------------|------------|
| Global keymaps | [`lua/config/keymaps.lua`](lua/config/keymaps.lua) |
| Editor options (tabs, clipboard, etc.) | [`lua/config/options.lua`](lua/config/options.lua) |
| **Which languages you use and which tools** | [`lua/config/languages.lua`](lua/config/languages.lua) |
| Plugin list (Git URLs) + theme/treesitter/UI bootstrap | [`lua/config/plugins.lua`](lua/config/plugins.lua) |
| Mason, default LSP, conform, lint, binary install | [`lua/config/lsp.lua`](lua/config/lsp.lua) |
| Fine-grained settings for a **specific LSP server** | [`lsp/<server_name>.lua`](lsp/) (Neovim 0.11+ convention) |
| Autocommands (cursor, NvimTree close, etc.) | [`lua/config/autocmds.lua`](lua/config/autocmds.lua) |

The **central table** is `languages.lua`: there you define LSP candidates, formatters, linters, filetypes, and Tree-sitter parsers.

---

## 2. Useful shortcuts (summary)

### General and windows

- `<leader>w` — write buffer  
- `<leader>q` — close window  
- `<leader>Q` — quit all (force)  
- `<Esc>` (Normal mode) — clear search highlight  
- `<C-h>` `<C-j>` `<C-k>` `<C-l>` — move focus between windows (same as `Ctrl-w` + direction)

### Buffers

- `[b` / `]b` — previous / next buffer  
- `<leader>bd` — delete current buffer  

### Diagnostics

- `[d` / `]d` — previous / next diagnostic  
- `<leader>dl` — diagnostic in a float  
- `<leader>dq` — send diagnostics to the location list  

### Explorer and search (fzf-lua)

- `<leader>e` — toggle **NvimTree**  
- `<leader>ff` — find files  
- `<leader>fg` — live grep  
- `<leader>fb` — buffers  
- `<leader>fh` — help tags (`:help`)  
- `<leader>fr` — recent files  
- `<leader>fd` — workspace diagnostics  
- `<leader>fs` / `<leader>fS` — document / workspace symbols  

*(If `fzf` is installed on the system, fzf-lua is usually snappier.)*

### Built-in terminal

- `<C-\><C-n>` or `Esc` `Esc` — return to Normal mode from terminal mode  

### With **LSP active** in the buffer (set in `LspAttach`)

- `gd` — go to definition  
- `gD` — declaration  
- `gi` — implementations  
- `gr` — references  
- `K` — hover documentation  
- `<C-k>` — signature help  
- `<leader>D` — type definition  
- `<leader>rn` — rename symbol  
- `<leader>ca` — code actions  
- `<leader>f` — format buffer (conform + LSP fallback)

**Which-key:** after pausing on `<leader>` (or per `:help which-key`), you can see groups and described mappings.

---

## 3. Completion and snippets (blink.cmp + LuaSnip)

- Config uses blink’s **`default` preset** (Tab/Shift-Tab, Enter, etc.).  
- For exact behavior: `:help blink-cmp` or the `require('blink.cmp').setup({...})` call in [`lua/config/plugins.lua`](lua/config/plugins.lua).

---

## 4. Format on save (conform.nvim)

By default, buffers are formatted **on save** according to `languages.lua`.

- `:FormatDisable` — disable auto-format on save everywhere  
- `:FormatDisable!` — only for the current buffer  
- `:FormatEnable` — turn format-on-save back on  

---

## 5. Mason (LSP, linters, formatters binaries)

- `:Mason` — UI to install / update / remove packages  
- After editing `languages.lua`, **restart Neovim**; `mason-tool-installer` will try to install missing tools (slightly delayed at startup).

If a formatter/linter name differs from the Mason package name (e.g. `ruff_format` → package `ruff`), see **`lua/config/lsp.lua`** (`MASON_ALIAS`). Extend that table if Mason cannot find the package.

---

## 6. How to **add** support for a new language

1. Open [`lua/config/languages.lua`](lua/config/languages.lua).  
2. Add an entry, for example:

   ```lua
   rust = {
       lsp = { 'rust_analyzer' },
       formatters = { 'rustfmt' },
       linters = { 'clippy' },  -- optional; must exist for nvim-lint + Mason
       filetypes = { 'rust' },
       treesitter = { 'rust' },
   },
   ```

3. **LSP server names** must match nvim-lspconfig / Mason (e.g. `rust_analyzer`, `lua_ls`). See Mason docs and `:help lspconfig-all`.

4. Optional: add [`lsp/rust_analyzer.lua`](lsp/) with `return { settings = { ... } }` if you need server-specific options.

5. Restart Neovim. Check `:Mason` and `:LspInfo` on a `.rs` file.

---

## 7. How to **switch LSP** without rewriting the whole config

In `languages.lua`, the `lsp` list is **preference-ordered**. The **first** candidate Mason can install wins.

Python example (current setup):

```lua
lsp = { 'basedpyright', 'pyright', 'pylsp' },
```

To prefer Pyright over Basedpyright, reorder:

```lua
lsp = { 'pyright', 'basedpyright', 'pylsp' },
```

[`lsp/pyright.lua`](lsp/pyright.lua) and [`lsp/basedpyright.lua`](lsp/basedpyright.lua) can coexist; only the active server’s settings apply.

### SQL (`sqls` vs `sqlls`)

The Mason package **`sqls`** (Go server) often fails to install. In `languages.lua` the SQL list prefers **`sqlls`** and keeps `sqls` as fallback. After changing the config, restart Neovim; if Mason still tries `sqls`, open `:Mason`, uninstall `sqls` with `X`, and install `sqlls` with `i` if needed. If you want no SQL LSP (highlighting + formatting only), set `lsp = {}` on the `sql` entry.

---

## 8. How to **remove** a language or tool

- Delete or comment out the block in **`languages.lua`** (or clear the lists).  
- To **stop loading** a whole plugin, remove its `vim.pack.add({...})` line in **`lua/config/plugins.lua`** and remove its `require(...).setup(...)` in that file if any.  
- Update plugins and the lockfile: `:lua vim.pack.update()` (or restart).  
- Commit **`nvim-pack-lock.json`** if you want the same state on another machine.

---

## 9. Adding or removing **plugins**

1. Edit **`lua/config/plugins.lua`**: add e.g.  
   `{ src = 'https://github.com/user/repo' }`  
2. If the plugin needs configuration, add `require('...').setup({})` below `vim.pack.add` in the same file (or a new module and `require` it).  
3. Restart Neovim the first time (or let `vim.pack` install).  
4. Optional: pin with `version = 'v1.2.3'` or `version = vim.version.range('2')` (see `:help vim.pack`).

To **remove** a plugin: delete its entry from `vim.pack.add`, restart, and optionally remove from disk: `:lua vim.pack.del({ 'plugin-folder-name' })` (folder name under `pack/core/opt`; see `:lua vim.inspect(vim.pack.get())`).

---

## 10. Maintenance commands

| Command | Purpose |
|---------|---------|
| `:checkhealth` | Plugin and environment health |
| `:lua vim.pack.update()` | Update `vim.pack`-managed plugins |
| `:TSInstall <parser>` | Install a single Tree-sitter parser if needed |
| `:LspInfo` | Active LSP clients for the buffer |

---

## 11. If something breaks

1. `:messages` — recent Lua errors.  
2. `:checkhealth` — mason, treesitter, lspconfig, blink, conform sections.  
3. Check that the **server name** in `lsp = { ... }` exists in Mason for your OS.  
4. Check **aliases** in `lsp.lua` if mason-tool-installer errors (“Cannot find package …”).

---

For a fresh install and high-level repo overview, see [`README.md`](README.md).
