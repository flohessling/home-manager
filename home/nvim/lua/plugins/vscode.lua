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
}
