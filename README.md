# Neovim Configuration

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/4/4f/Neovim-logo.svg", style="width:55%">
</p>

This repository contains all the files needed to configure my personal neovim customization.

## Table of contents

- [Example images](#example-images)
- [Features](#features)
    - [Cursor reset](#cursor-reset)
    - [Vim options](#vim-options)
    - [Plugin manager](#plugin-manager)
    - [Color scheme](#color-scheme)
    - [NeovimTree](#neovimtree)
    - [Language servers](#language-servers)
    - [Treesitter](#treesitter)
- [Usage](#usage)
    - [Packer installation](#packer-installation)

## Example images

Example with Lua          | Example with Python
:------------------------:|:--------------------------:
![](imgs/example_lua.png) | ![](imgs/example_pyton.png)

## Features

### Cursor reset

By default, the block cursor persist after exiting neovim. One way to restore the terminal cursor is use `vim autocmd`. A lua script controls that [`lua/cursor-reset/init.lua`](lua/cursor-config/init.lua).

When neovim is opened, vim's default cursor style is set.

```vim
guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
```

On the other hand, on exit the cursor is reset to the one before.

```vim
guicursor=a:ver25-blinkon0
```

This can be changed to any preference `block`, `ver<size>`, `hor<size>`. 

### Vim options

In addition to anything else, a lot of vim options can be configured. Those who I consider more important can be found in [`lua/settings/init.lua`](lua/settings/init.lua).

```lua
set.expandtab = true        -- Use spaces instead of <Tab>
set.smarttab = true         -- Use 'shiftwifth' when inserting <Tab>
set.shiftwidth = 4          -- Number of spaces to use for (auto)indent
set.tabstop = 4             -- Number of spaces that <Tab> uses

set.hlsearch = true         -- Highlight matches with last search pattern
set.incsearch = true        -- Highlight match while typing search pattern
set.ignorecase = true       -- Ignore case in search patterns
set.smartcase = true        -- No ignore case when pattern has uppercase

set.splitbelow = true       -- New window from split is below the current one
set.splitright = true       -- New window is put right of the current one
set.scrolloff = 5           -- Minimum number of lines above and below cursor
set.fileencoding = 'UTF-8'  -- File encoding
set.termguicolors = true    -- Enable 24-bit colors and uses "gui" attributes
                            -- instead of "cterm"

set.number = true           -- Enable line numbers
set.cursorline = true       -- Highlight current line

set.background = 'dark'     -- Change highlight colors depending on terminal 
                            -- background
set.hidden = true           -- Allow to have unwritten files to a file and 
                            -- open a new file using :e without being forced
                            -- to write or undo those changes
```

### Plugin manager

To manage all the plugins I am going to use Packer plugin manager.

### Color scheme

I am a big nord fan, for that reason I am going to use `onenord` colorscheme. This colorscheme combines the nord aesthetic with a higher contrast syntax highlighting. 
Credits to: [`rmehri01/onenord.nvim`](https://github.com/rmehri01/onenord.nvim).

### NeovimTree

This plugin adds a file explorer to neovim. It can be opened using <kbd>Space</kbd> + <kbd>e</kbd>.

### Language servers

Language servers facilitate features like go-to-definition, find-references, hover,
completion, rename, format, refactor, etc., using semantic whole-project analysis.

In my case, I have defined no servers but you can add as much as you want ([`lua/mason-config/init.lua`](lua/mason-config/init.lua)).

```lua
-- Required servers
servers = { --[[ Set here the servers --]] }
```

You can find a wide list [here](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers).

### Treesitter

Treesitter improves syntax highlighting. It also gives us the ability to refactor code as well as navigate throw definitions and usages of variables or functions. 

## Usage

> **Warning**
It's necessary to have a terminal emulator compatible with true colors to use this configuration. You can remove the colorscheme config if you still want to use the rest of this configuration.

To try this configuration, all you have to do is run the following command and install the plugin manager.

```zsh
mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim && git clone https://github.com/Serms1999/NeoVim-Configuration.git ${XDG_CONFIG_HOME:-$HOME/.config}/nvim
```

### LSP servers

If you want to customize the language servers that are going to be installed you must modify the var showed [here](#language-servers).

After the installation, you can use `Mason` to see and manage servers.

### Packer installation

You can see a full guide of how to install and configure it [here](https://github.com/wbthomason/packer.nvim#quickstart).

To summarize, to download it you only have to run:

```zsh
git clone --depth 1 https://github.com/wbthomason/packer.nvim ${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/packer/start/packer.nvim
```

Lastly, you need to run `PackerSync` in neovim. This will download all the require plugins.
