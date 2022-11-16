-- Restore line cursor after exit neovim
vim.api.nvim_create_augroup("cursor_reset", {clear = true})
vim.api.nvim_create_autocmd({"VimEnter", "VimResume"}, {
	group = "cursor_reset",
	pattern = {"*"},
	command = "set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
})
vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend"}, {
	group = "cursor_reset",
	pattern = {"*"},
	command = "set guicursor=a:ver25-blinkon0"
})
