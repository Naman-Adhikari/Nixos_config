return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},

	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				preview = false,
				path_display = { "truncate" },
				layout_strategy = "center",
				layout_config = {
					center = {
						width = 0.4,
						height = 0.2,
						anchor = "N",
						anchor_padding = 0,
						prompt_position = "top",
					},
				},
				winblend = 10,
				border = true,
				prompt_prefix = "🔍 ",
				selection_caret = "❯ ",
				cache_picker = {
					num_pickers = 1,
					limit_entries = 1000,
				},
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<C-n>"] = false,
						["<C-c>"] = false,
						["<C-p>"] = false,
						["<S-j>"] = require("telescope.actions").move_selection_next,
						["<S-k>"] = require("telescope.actions").move_selection_previous,
						["<S-c>"] = require("telescope.actions").close,
					},
				},
			},

			extensions = {
				fzf = {},
			},
		})

		pcall(telescope.load_extension, "fzf")

		vim.keymap.set("n", "<leader>fg", function()
			builtin.git_files({})
		end, { silent = true })

		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({})
		end, { silent = true })

		vim.keymap.set("n", "<leader>fb", function()
			builtin.buffers({})
		end, { silent = true })

		vim.keymap.set("n", "<leader>fo", function()
			builtin.oldfiles({})
		end, { silent = true })

		vim.keymap.set("n", "<C-g>", function()
			builtin.live_grep({})
		end)
	end,
}
