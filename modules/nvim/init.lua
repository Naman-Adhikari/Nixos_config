-- Load basic options first
require "options"

-- Lazy.nvim setup
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

-- Initialize plugins
require("lazy").setup("plugins")


-- Fold settings (MUST come before plugin setup)
vim.opt.foldmethod = "expr"               -- Use Treesitter for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99               -- Start with all folds open
--vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"  -- Nicer fold display
vim.opt.foldtext = [[v:folddashes.substitute(getline(v:foldstart),'\t',repeat(' ',&tabstop),'g')]]
vim.cmd([[
  highlight Folded guifg=#87cde0 guibg=#454747 gui=italic
]])


-- Optional: Better fold characters (requires NerdFont)
vim.opt.fillchars = {
  fold = " ",
  foldopen = "",  -- Down arrow icon
  foldclose = "", -- Right arrow icon
}

-- F5 keybinding to compile/run depending on filetype
vim.api.nvim_set_keymap('n', '<F5>', '', { noremap = true, silent = true, callback = function()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%')
  local fname_no_ext = vim.fn.expand('%:r')

  if filetype == "c" then
    -- Compile and run C file
    vim.cmd('w') -- Save current file
    vim.cmd('split | terminal gcc ' .. filename .. ' -o ' .. fname_no_ext .. ' && ./' .. fname_no_ext)
  elseif filetype == "cpp" then
    -- Compile and run C++ file
    vim.cmd('w') -- Save current file
    vim.cmd('split | terminal g++ ' .. filename .. ' -o ' .. fname_no_ext .. ' && ./' .. fname_no_ext)
  elseif filetype == "python" then
    -- Run Python script
    vim.cmd('w') -- Save current file
    vim.cmd('split | terminal python3 ' .. filename)
  else
    print("F5: No run command set for filetype: " .. filetype)
  end
end})
