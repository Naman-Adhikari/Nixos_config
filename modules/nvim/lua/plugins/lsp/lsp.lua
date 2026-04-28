return {
	"neovim/nvim-lspconfig",
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		--lsp for lua
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = false,
						ignoreDir = {
							"%.git",
							"node_modules",
							"%.cache",
							"%.local",
							"%.cargo",
							"%.npm",
							"result",
							"%.dotfiles/",
						},
					},
				},
			},
		})

		--lsp for python
		vim.lsp.config("pyright", {
			capabilities = capabilities,
		})

		--lsp for nix language
		vim.lsp.config("nil_ls", {
			capabilities = capabilities,
			settings = {
				["nil"] = {
					formatting = {
						command = { "nixfmt" },
					},
					nix = {
						flake = {
							autoArchive = true,
						},
					},
				},
			},
		})

		--lsp for rust
		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					diagnostics = { enable = true },
					lens = {
						enable = true,
						run = { enable = true },
						debug = { enable = true },
					},
				},
			},
		})

		-- show only diagnostic for critical errors
		vim.diagnostic.config({
			virtual_text = {
				severity = { min = vim.diagnostic.severity.ERROR },
				source = "if_many",
				format = function(diagnostic)
					if diagnostic.severity == vim.diagnostic.severity.ERROR then
						return diagnostic.message
					end
					return ""
				end,
			},
			signs = true,
			underline = false,
			severity_sort = true,
		})

		--enable the lsps
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("nil_ls")
		vim.lsp.enable("pyright")
		vim.lsp.enable("rust_analyzer")
	end,
}
