--keys for opening specific files
vim.keymap.set("n", "<leader>oh", function()
	vim.cmd("edit ~/.dotfiles/home.nix")
end)

vim.keymap.set("n", "<leader>oc", function()
	vim.cmd("edit ~/.dotfiles/configuration.nix")
end)

vim.keymap.set("n", "<leader>op", function()
	vim.cmd("edit ~/.dotfiles/modules/hyprland/hyprland.conf")
end)

-- keys for saving and quitting files
vim.keymap.set("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- for caps instead of esc
vim.keymap.set("i", "jk", "<Esc>")

-- for splitting and navigating windows
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>wh", "<cmd>split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>bk", "<cmd>bd<CR>", { desc = "Killing buffer" })

-- for deleting all buffers except the current one
vim.keymap.set("n", "<leader>bo", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = false })
		end
	end
end, { desc = "Delete all buffers except current" })

-- For buffer navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>")

--bind for terminal spawn
vim.keymap.set("n", "<leader>t", function()
	local dir = vim.fn.expand("%:p:h")

	vim.cmd("vsplit | wincmd l | vertical resize 40")
	vim.cmd("lcd " .. dir)
	vim.cmd("terminal")
	vim.cmd("startinsert")
end)

--to escap[e terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- increase / decrease vertical size
vim.keymap.set("n", "<leader>]", "<cmd>vertical resize +10<CR>")
vim.keymap.set("n", "<leader>[", "<cmd>vertical resize -10<CR>")

-- increase / decrease horizontal size
vim.keymap.set("n", "<C-Up>", "<cmd>resize +10<CR>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -10<CR>")

--org fold keybinds
vim.api.nvim_create_autocmd("FileType", {
	pattern = "org",
	callback = function()
		vim.keymap.set(
			"n",
			"<Leader>za",
			"<Cmd>lua require('orgmode').action('org_mappings.cycle')<CR>",
			{ buffer = true, desc = "Toggle org fold" }
		)
	end,
})

-- ctrl bs removes word
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true })
