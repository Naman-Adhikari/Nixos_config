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
				path_display = { "truncate" },
				layout_strategy = "center",
				layout_config = {
					center = {
						width = 0.4,
						height = 0.3,
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
			},
			pickers = {
				find_files = {
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
						"%.cargo/",
						"%.javacpp/",
						"%.jpg$",
						"%.jpeg$",
						"%.png$",
					},
				},
			},
		})

		-- Safely load extension if available
		pcall(telescope.load_extension, "fzf")

		local home = vim.fn.expand("~")

		vim.keymap.set("n", "<C-p>", function()
			builtin.find_files({ cwd = home })
		end, { silent = true })

		vim.keymap.set("n", "<C-g>", function()
			builtin.live_grep({})
		end)
	end,
}
