# Quick guide to this Neovim setup

How the stack works and which file to edit when you want to change something.

**Leader:** `<Space>`. Full keymap reference: `:h cheatsheet`.

---

## 1. Where everything lives

| What you want to change | File |
|-------------------------|------|
| Global keymaps | [`lua/config/keymaps.lua`](lua/config/keymaps.lua) |
| Editor options | [`lua/config/options.lua`](lua/config/options.lua) |
| **Languages and their LSP** | [`lua/config/languages.lua`](lua/config/languages.lua) |
| Plugin list, colorscheme, treesitter, UI | [`lua/config/plugins.lua`](lua/config/plugins.lua) |
| LSP wiring, diagnostics, LSP keymaps | [`lua/config/lsp.lua`](lua/config/lsp.lua) |
| Settings for one LSP server | [`lsp/<server>.lua`](lsp/) |
| Autocommands | [`lua/config/autocmds.lua`](lua/config/autocmds.lua) |
| Keymap cheatsheet | [`doc/cheatsheet.txt`](doc/) |

[`lua/config/languages.lua`](lua/config/languages.lua) is the single source of
truth. Each entry declares, per language, its ordered LSP candidates, its
filetypes and its tree-sitter parsers. Both `lsp.lua` and the treesitter setup
derive their configuration from that table, so adding a language is a single
edit.

---

## 2. The LSP pipeline

1. You install the server binary with your system package manager.
2. `languages.lua` declares ordered candidates per language.
3. `lsp.lua` enables the **first candidate whose binary is on `PATH`**
   (`vim.fn.executable`).
4. `nvim-lspconfig` supplies how to launch it: `cmd`, `filetypes`,
   `root_markers`.
5. `lsp/<server>.lua` adds or overrides `settings` for that server, and takes
   precedence over the lspconfig definition.
6. `vim.lsp.enable()` activates the resulting list.

Binary names sometimes differ from server names (`lua_ls` →
`lua-language-server`). That mapping is the `EXECUTABLE` table in
[`lua/config/lsp.lua`](lua/config/lsp.lua). When binary and server share a name
(`ty`, `clangd`, `sqls`), no entry is needed.

A missing binary is not an error: that server stays inactive and everything
else keeps working. Verify with `:echo executable('name')` and
`:checkhealth lsp`.

Diagnostics presentation and the buffer-local LSP keymaps (`gd`, `gr`, `K`,
`<leader>rn`, `<leader>ca`…) are set in `lsp.lua`, the keymaps inside an
`LspAttach` autocommand so they only exist where a server is attached.

---

## 3. Add a language

1. Install the server binary.
2. Add an entry to `languages.lua`:

   ```lua
   rust = {
       lsp = { 'rust_analyzer' },
       filetypes = { 'rust' },
       treesitter = { 'rust' },
   },
   ```

3. If the binary name differs from the server name, add it to `EXECUTABLE` in
   `lsp.lua`.
4. Install the parser: `:TSInstall rust`.
5. Restart Neovim, open a `.rs` file, check `:checkhealth lsp`.

Server names must match `nvim-lspconfig`. Use `lsp = {}` for a language you
only want highlighted.

Optionally create `lsp/rust_analyzer.lua` returning `{ settings = { ... } }`
for server-specific options.

---

## 4. Switch or prefer a different LSP

The `lsp` list is preference-ordered and the first candidate with an available
binary wins, so switching is a reorder:

```lua
python = { lsp = { 'basedpyright', 'ty' }, ... }
```

Per-server files coexist; only the active server's settings apply. Installing
or removing a binary switches servers too, with no config change.

### Python

`ty` (Astral's Rust type checker and language server) is first, with
`basedpyright` as fallback. [`lsp/ty.lua`](lsp/) carries its `cmd`,
`filetypes` and `root_markers`; the others only carry `settings`.

Install with `uv tool install ty`.

### SQL

`sqls` is first, `sqlls` as fallback. Install `sqls` with a pinned version on
every machine:

```bash
go install github.com/sqls-server/sqls@<version>
```

`sqls` autocompletes real table and column names when connected to a database.
Without a connection it logs `no database connection` on startup and keeps
serving generic SQL, which is what this setup uses it for. To connect it, add a
`settings.sqls.connections` block in `lsp/sqls.lua` — keep credentials out of
the repo.

---

## 5. Completion

blink.cmp, configured in [`lua/config/plugins.lua`](lua/config/plugins.lua)
with the `default` preset. Sources: `lsp`, `path`, `buffer`. LSP capabilities
are extended with blink's in `lsp.lua`, so servers know what the client
supports.

Key behaviour: `:h blink-cmp`.

`nvim-autopairs` closes brackets and quotes as you type.

---

## 6. Colorscheme

**nordern** is active, with Aurora accents on the SQL and Python tokens that
matter most:

```lua
require('nordern').setup({ transparent = true, italic_comments = false })
vim.cmd.colorscheme('nordern')

local set = vim.api.nvim_set_hl
set(0, '@keyword.sql', { fg = '#B48EAD' })
-- ...
```

Loading a colorscheme resets every highlight group, so `nvim_set_hl` calls
belong **after** `vim.cmd.colorscheme(...)`. Placed before, they are discarded
silently.

`onenord` is installed with its setup block commented out as an alternative. To
switch, comment the nordern block, uncomment onenord, and update `lualine`'s
`theme` to match.

`:Inspect` shows the highlight groups under the cursor — use it before writing
an override, since capture names differ per language.

---

## 7. Treesitter

Parsers come from `ensure_installed`, derived from the `treesitter` field of
every entry in `languages.lua`. `auto_install` is off, so the installed set is
exactly what the registry declares — the same on every machine. Install a new
one with `:TSInstall <parser>` and check status with `:TSInstallInfo`.

Enabled modules: `highlight`, `indent`, `incremental_selection` (`<C-space>` to
grow, `<bs>` to shrink) and `textobjects` (`af`/`if` for functions, `ac`/`ic`
for classes, `]f`/`[f` and `]c`/`[c` to jump).

The `latex` grammar needs the external `tree-sitter` CLI, so it is left out of
the registry; TeX files use classic syntax highlighting.

---

## 8. Comments and cursor

Comments use the built-in `gc` / `gcc`.

The cursor is Neovim's default: block in normal mode, bar in insert. Nothing in
this config sets `guicursor`. Terminal cursor behaviour after quitting belongs
to the terminal config (Ghostty: `cursor-style = bar`,
`cursor-style-blink = true`).

---

## 9. Add or remove a plugin

**Add:**

1. Add `{ src = 'https://github.com/user/repo' }` to `vim.pack.add({...})` in
   `plugins.lua`.
2. Add its `require('...').setup({})` below, if it needs one.
3. Restart Neovim.
4. Optional pinning: `version = 'v1.2.3'` or
   `version = vim.version.range('1.0')` (`:h vim.pack`).
5. Commit the lockfile.

**Remove:**

1. Remove its entry from `vim.pack.add` and its `setup()` call.
2. Delete it from disk. `vim.pack` keeps plugins that are no longer declared,
   and anything left there is re-added to the lockfile on the next startup:

   ```vim
   :lua vim.pack.del({ 'plugin-folder-name' })
   ```

   Folder names: `ls ~/.local/share/nvim/site/pack/core/opt` or
   `:lua vim.inspect(vim.pack.get())`.

3. Restart and commit the lockfile.

---

## 10. Keeping machines in sync

`nvim-pack-lock.json` pins exact plugin revisions, so it is what keeps every
machine identical.

1. Commit it after every `:lua vim.pack.update()`.
2. Pull it on the other machines before opening Neovim.
3. Pin binary versions where the package manager allows it.

If the lockfile gains entries you did not declare, the matching pluginAquí va la continuación desde donde se cortó:

```markdown
If the lockfile gains entries you did not declare, the matching plugin is still
on disk. Remove it (section 9), then regenerate:

```bash
rm nvim-pack-lock.json   # restart Neovim, then commit the result
```

---

## 11. Maintenance commands

| Command | Purpose |
|---------|---------|
| `:checkhealth` | Environment and plugin health |
| `:checkhealth lsp` | Enabled configurations and active clients |
| `:lua vim.pack.update()` | Update plugins |
| `:TSInstall <parser>` | Install a tree-sitter parser |
| `:TSInstallInfo` | Parser status (takes no arguments) |
| `:Inspect` | Highlight groups under the cursor |
| `:h cheatsheet` | Keymap reference |

---

## 12. Troubleshooting

**Lua errors on startup** — `:messages`. A `module 'x' not found` means a
`require` outlived the plugin it referenced.

**LSP not attaching** — `:checkhealth lsp`:

- Listed under *Enabled configurations* with *"config not found"*:
  `nvim-lspconfig` has no definition for that server. Write `lsp/<server>.lua`
  with `cmd`, `filetypes` and `root_markers`.
- Not listed at all: the binary is not on `PATH`. Check with
  `:echo executable('name')`.
- The shell finds the binary but Neovim does not: `PATH` inheritance. Neovim
  uses the `PATH` of the process that launched it, so define `PATH` in
  `.zshenv` (always sourced) rather than `.zprofile` (login shells only).

**Highlight overrides have no effect** — they must run after
`vim.cmd.colorscheme(...)`. Confirm the real capture name with `:Inspect`.

**Warnings about plugins that are not in `plugins.lua`** — they are still on
disk. See section 9.

---

For installation and dependencies, see [`README.md`](README.md).
