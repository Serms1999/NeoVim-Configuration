local opt = vim.opt

opt.expandtab = true
opt.smarttab = true
opt.shiftwidth = 4
opt.tabstop = 4

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 5
opt.fileencoding = 'UTF-8'
opt.termguicolors = true

opt.number = true
opt.relativenumber = false
opt.cursorline = true

opt.hidden = true
opt.undofile = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 400

opt.clipboard = 'unnamedplus'

opt.completeopt = { 'menu', 'menuone', 'noselect' }

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.confirm = true
