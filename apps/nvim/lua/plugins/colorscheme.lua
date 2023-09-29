return {
    {
        "Mofiqul/vscode.nvim",
        enabled = true,
        lazy = false,
        priority = 999,
        config = function()
            require("vscode.colors").get_colors()
            require("vscode").setup({
                transparent = true, -- enable transparent background
                italic_comments = true, -- enable italic comments
                disable_nvimtree_bg = true, -- disable nvim-tree background color
            })
            vim.cmd.colorscheme("vscode")
        end,
    },
    {
        "catppuccin/nvim",
        enabled = false,
        lazy = false,
        priority = 999,
        config = function ()
            require("catppuccin").setup({
                flavour = "mocha",
                background = {
                    dark = "mocha",
                },
                term_colors = true,
                color_overrides = {
                    mocha = {
                        base = "#14171a",
                        mantle = "#14171a",
                        crust = "#14171a",
                    }
                },
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                },
            })
            vim.cmd.colorscheme("catppuccin-mocha")
        end
    },
}
