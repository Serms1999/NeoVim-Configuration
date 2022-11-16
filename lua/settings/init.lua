local set = vim.opt         -- Create alias for vim.opt

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
