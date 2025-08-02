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
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(file_path)
                        -- Automatically close Neo-tree after opening a file
                        require("neo-tree.command").execute({ action = "close" })
                    end,
                },
            },
        })

        vim.keymap.set('n', "<S-t>", ":Neotree filesystem reveal left<CR>", { noremap = true, silent = true })
    end
}

