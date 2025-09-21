return {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup({
      enable = true, 
      extra_groups = { 
        "NormalFloat", 
        "NvimTreeNormal", 
        "TelescopeNormal", 
		"NvimTreeEndOfBuffer",		
		"NeoTreeNormal",
		"NeoTreeNormalNC",
		"NeoTreeEndOfBuffer",
		"NeoTreeStatusLine",
		"NeoTreeStatusLineNC",
		"NeoTreeWinSeparator",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "TelescopeResultsNormal",
        "TelescopeResultsBorder",
      },
      exclude_groups = {}, 
    })
  end,
}
