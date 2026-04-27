return {
  "stevearc/resession.nvim",
  opts = {},

  config = function(_, opts)
    local resession = require("resession")
    resession.setup(opts)

    -- Keymaps
    vim.keymap.set("n", "<leader>ss", function()
      resession.save()
    end, { desc = "Save session" })

	vim.keymap.set("n", "<leader>sl", function()
	  require("resession").load("last")
	end, { desc = "Load last session" })

    vim.keymap.set("n", "<leader>sd", function()
      resession.delete()
    end, { desc = "Delete session" })

    -- Auto-save last session on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        resession.save("last")
      end,
    })
  end,
}

