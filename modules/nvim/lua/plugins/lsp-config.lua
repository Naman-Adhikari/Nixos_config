return {
  {
    "williamboman/mason.nvim",
	commit = "00f14f787c71d060db9fa9b0db44c6cf12b64f61",	
    lazy = false,
    priority = 1000,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
	commit = "1a634d623f16bba0f2f5746c75882d28f47a9c7f",	
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- ensure this is installed too
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      end

      -- LSP setups
      local servers = {
        lua_ls = {},
        vtsls = {},
        html = {},
		ast_grep = {},		
	    dartls  = {},
        cssls = {},
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  ignore = {
                    "E265", "E231", "E225", "E261", "W293", "E302",
                    "E303", "E222", "E262", "E305", "W291", "E501",
                    "W391", "E202", "E114", "E201"
                  },
                },
              },
            },
          }
        },
      }

      for server, config in pairs(servers) do
        config.on_attach = on_attach
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end
    end,
  },
}



