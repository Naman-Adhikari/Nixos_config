return {
	"folke/flash.nvim",
	event = "VeryLazy",

	opts = {
		modes = {
			char = {
				enabled = false,
			},
		},

		highlight = {
			groups = {
				match = "FlashMatch",
				label = "FlashLabel",
			},
		},
	},

	config = function(_, opts)
		require("flash").setup(opts)

		vim.api.nvim_set_hl(0, "FlashMatch", {
			bg = "#3e68d7",
			fg = "#c8d3f5",
		})

		vim.api.nvim_set_hl(0, "FlashLabel", {
			bg = "#ffffff",
			fg = "#000000",
			bold = true,
		})
	end,

	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
	},
}
