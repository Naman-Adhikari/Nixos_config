return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
	  },
  			})   

    vim.keymap.set("n", "<C-p>", function()
      builtin.find_files({
        hidden = true,
	file_ignore_patterns = {
		  "node_modules",
		  "%.git/",
		  "dist/",
		  "build/",
		  "target/",
		  "%.cache/",
		  "%.minecraft/",
		  "%.pub%-cache/",
		  "%.steam/",
		  "%.android/",
		  "%.ssh/",
		  "%.local/",
		  "%.java/",
		  "%.pki/",
		  "%.zoom/",
		  "%.tlauncher/",
		  "%.icons/",
		  "%.var/",
		},
      })
    end, { silent = true })

    vim.keymap.set("n", "<C-g>", function()
      builtin.live_grep({
      })
    end)

  end
}
