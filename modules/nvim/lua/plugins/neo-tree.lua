return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},

	config = function()
		require("neo-tree").setup({
			filesystem = {
				window = {
					mappings = {
						["h"] = "navigate_up",
						["l"] = "open",
						["j"] = "next",
						["k"] = "prev",
					},
				},
			},

			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		})

		--[ So that neotree toggles and focuses too

		vim.keymap.set("n", "<S-t>", function()
			local manager = require("neo-tree.sources.manager")
			local renderer = require("neo-tree.ui.renderer")

			local state = manager.get_state("filesystem")

			if state and renderer.window_exists(state) then
				-- Neo-tree is open
				if vim.api.nvim_get_current_win() == state.winid then
					-- Already focused → close it
					require("neo-tree.command").execute({ action = "close" })
				else
					-- Open but not focused → focus it
					vim.api.nvim_set_current_win(state.winid)
				end
			else
				-- Not open → open + focus
				require("neo-tree.command").execute({
					action = "focus",
					source = "filesystem",
					position = "left",
					dir = vim.fn.expand("%:p:h"),
				})
			end
		end, { silent = true })
	end,
}
