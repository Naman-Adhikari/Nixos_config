return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },

			python = { "isort" },

			rust = { "rustfmt", lsp_format = "fallback" },
		},
	},
}
