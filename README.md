# Neovim Configuration

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/4/4f/Neovim-logo.svg", style="width:55%">
</p>

This repository contains all the files needed to configure my personal neovim customization.

## Table of contents

- [Features](#features)
    - [Cursor reset](#cursor-reset)
    - [Vim options](#vim-options)
- Usage
## Features

### Cursor reset

By default, the block cursor persist after exiting neovim. One way to restore the terminal cursor is use `vim autocmd`. A lua script controls that [`lua/cursor-reset/init.lua`](lua/cursor-config/init.lua).

When neovim is opened, vim's default cursor style is set.

```
guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
```

On the other hand, on exit the cursor is reset to the one before.

```
guicursor=a:ver25-blinkon0
```

This can be changed to any preference `block`, `ver<size>`, `hor<size>`. 

### Vim options

In addition to anything else, a lot of vim options can be configured. Those who I consider more important can be found in [`lua/settings/init.lua`](lua/settings/init.lua).

```lua
set.expandtab = true        -- Use spaces instead of <Tab>
set.smarttab = true         -- Use 'shiftwifth' when inserting <Tab>
set.shiftwidth = 4          -- Number of spaces to use for (auto)indent
set.tabstop = 4	            -- Number of spaces that <Tab> uses

set.hlsearch = true	        -- Highlight matches with last search pattern
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

## Usage

To try this configuration, all you have to do is execute the following command.

```zsh
mkdir -p ~/.config/nvim && git clone https://github.com/Serms1999/NeoVim-Configuration.git ~/.config/nvim
```
