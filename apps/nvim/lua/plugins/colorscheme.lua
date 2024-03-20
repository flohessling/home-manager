return {
    {
        "aktersnurra/no-clown-fiesta.nvim",
        enabled = true,
        lazy = false,
        priority = 999,
        config = function()
            require("no-clown-fiesta").setup({
                transparent = true,
            })
            vim.cmd("colorscheme no-clown-fiesta")
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        enabled = false,
        lazy = false,
        priority = 999,
        config = function()
            require("kanagawa").setup({
                transparent = true,
                colors = { theme = { all = { ui = { bg_gutter = "none" }}}}
            })
            vim.cmd("colorscheme kanagawa-dragon")
        end,
    },
    {
        "Mofiqul/vscode.nvim",
        enabled = false,
        lazy = false,
        priority = 999,
        config = function()
            require("vscode.colors").get_colors()
            require("vscode").setup({
                transparent = true, -- enable transparent background
                italic_comments = true, -- enable italic comments
                disable_nvimtree_bg = true, -- disable nvim-tree background color
            })
            vim.cmd("colorscheme vscode")
        end,
    },
}
