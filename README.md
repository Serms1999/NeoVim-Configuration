# Neovim Configuration

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/4/4f/Neovim-logo.svg", style="width:55%">
</p>

This repository contains all the files needed to configure my personal neovim customization.

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

## Usage

To try this configuration, all you have to do is execute the following command.

```
mkdir -p ~/.config/nvim && git clone https://github.com/Serms1999/NeoVim-Configuration.git ~/.config/nvim
```
