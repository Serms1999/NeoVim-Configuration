local augroup = function(name)
    return vim.api.nvim_create_augroup('user_' .. name, { clear = true })
end

------------------------------------------------------------
-- Restore terminal cursor shape on exit, set block cursor on entry.
-- Without this, the block cursor can persist after exiting Neovim
-- in some terminal emulators.
------------------------------------------------------------
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
    group = augroup('cursor_reset'),
    pattern = '*',
    command = 'set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20',
})
vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
    group = augroup('cursor_reset'),
    pattern = '*',
    command = 'set guicursor=a:ver25-blinkon0',
})

------------------------------------------------------------
-- Highlight yanked text briefly.
------------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('highlight_yank'),
    callback = function()
        vim.hl.on_yank({ timeout = 200 })
    end,
})

------------------------------------------------------------
-- Auto-close nvim-tree when it is the only remaining window.
------------------------------------------------------------
local function tree_only_modified_buffers(bufs)
    local count = 0
    for _, v in pairs(bufs) do
        if not v.name:match('NvimTree_') then
            count = count + 1
        end
    end
    return count
end

vim.api.nvim_create_autocmd('BufEnter', {
    group = augroup('nvim_tree_autoclose'),
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1
            and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil
            and tree_only_modified_buffers(vim.fn.getbufinfo({ bufmodified = 1 })) == 0
        then
            vim.cmd('quit')
        end
    end,
})
