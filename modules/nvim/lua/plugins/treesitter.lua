return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  auto_install = true,
  config = function()
    require('nvim-treesitter.configs').setup({
      highlight = { enable = true },
      indent = { enable = true },
      folding = { enable = true },  
      ensure_installed = { "python", "dart", "c", "cpp", "rust" },
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldlevelstart = 99  
  end
}
