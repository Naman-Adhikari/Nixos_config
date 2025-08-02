--[[
return {
    "EdenEast/nightfox.nvim", lazy = false, priority = 1000,
	config= function()
vim.cmd.colorscheme "carbonfox"
end
}
	]]--
--[[return {
    "rebelot/kanagawa.nvim", lazy = false, priority = 1000,
	config= function()
vim.cmd.colorscheme "kanagawa-dragon"
end
}]]--

--[[return{
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme cyberdream")
  end,
}]]--

--[[return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
        contrast = "medium", -- or "soft", "medium"
        palette_overrides = {},
        overrides = {},
        transparent_mode = true,
    },
    config = function(_, opts)
        require("gruvbox").setup(opts)
        vim.cmd("colorscheme gruvbox")
    end
}
]]--


--[[return {
    "folke/tokyonight.nvim", lazy = false, priority = 1000,
	config= function()
vim.cmd.colorscheme "tokyonight-night" 
end
}]]--	

--[[
return {
  "NTBBloodbath/doom-one.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "doom-one"
  end
}
]]--

--[[
return {
  "kdheepak/monochrome.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "monochrome"
  end
}
]]--

return {
  "neko-night/nvim",
  lazy = false,
  priority = 1000,
  config = function()
     vim.cmd.colorscheme "nekonight-fire-obsidian"
  end
}
