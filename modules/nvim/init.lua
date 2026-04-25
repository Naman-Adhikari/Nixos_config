require "options"

vim.g.maplocalleader = ' '

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

require("lazy").setup("plugins")


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

vim.api.nvim_set_keymap('n', 'tc', '<cmd>VimtexTocToggle<CR>', {noremap = true, silent = true})
vim.keymap.set("n", "<A-t>", ":TransparentToggle<CR>", { noremap = true, silent = true, desc = "Toggle transparency" })

vim.api.nvim_set_keymap('n', '<F5>', '', { noremap = true, silent = true, callback = function()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%')
  local fname_no_ext = vim.fn.expand('%:r')

  if filetype == "c" then
    vim.cmd('w') 
    vim.cmd('split | terminal gcc ' .. filename .. ' -o ' .. fname_no_ext .. ' && ./' .. fname_no_ext)
  elseif filetype == "cpp" then
    vim.cmd('w') 
    vim.cmd('split | terminal g++ ' .. filename .. ' -o ' .. fname_no_ext .. ' && ./' .. fname_no_ext)
  elseif filetype == "python" then
    vim.cmd('w') 
    vim.cmd('split | terminal python3 ' .. filename)
  elseif filetype == "rust" then
	  vim.cmd('w')
	  local dir = vim.fn.expand('%:p:h')
	  vim.cmd('split | terminal cd ' .. dir .. ' && cargo run')
		
  elseif filetype == "tex" then
    vim.cmd('w')
    vim.cmd('VimtexCompile')
    vim.defer_fn(function()
      vim.cmd('VimtexView')
    end, 500)
  else
    print("F5: No run command set for filetype: " .. filetype)
  end
end})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.cmd("RustFmt")
  end
})
