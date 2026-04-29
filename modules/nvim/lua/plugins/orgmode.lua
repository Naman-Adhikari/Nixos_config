return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	config = function()
		-- Setup orgmode
		require("orgmode").setup({
			org_agenda_files = "~/orgfiles/**/*",
			org_default_notes_file = "~/orgfiles/refile.org",
			org_hide_leading_stars = true, -- Fixed: moved inside setup()
			mappings = {
				org = {
					org_cycle = false, -- Disable Tab for folding
					org_global_cycle = false, -- Disable Shift-Tab for global folding
				},
			},
		})
		-- Experimental LSP support
		vim.lsp.enable("org")
	end,
}
