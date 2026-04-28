require("options")
require("keybinds")

vim.g.maplocalleader = " "

--loading lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.lsp" },
	},
})

--for undo persistence
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

--for formatting code
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

--config for text folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldtext = [[v:folddashes.substitute(getline(v:foldstart),'\t',repeat(' ',&tabstop),'g')]]
vim.cmd([[
  highlight Folded guifg=#87cde0 guibg=#454747 gui=italic
]])

vim.opt.fillchars = {
	fold = " ",
	foldopen = "",
	foldclose = "",
}
