return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",         

    "esmuellert/codediff.nvim",      

    "nvim-telescope/telescope.nvim", 
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
  }
}
