return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  auto_install = true,
  config = function()
    require('nvim-treesitter.configs').setup({
      highlight = { enable = true },
      indent = { enable = true },
      folding = { enable = true },  -- Enable Treesitter-based folding
      ensure_installed = { "python", "dart", "c", "cpp" },
    })

    -- Set fold method to use Treesitter
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldlevelstart = 99  -- Start with folds open
  end
}
