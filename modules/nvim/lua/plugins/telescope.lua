return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',  
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<C-p>", ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
      end
    }
