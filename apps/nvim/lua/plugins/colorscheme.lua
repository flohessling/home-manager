return {
    {
        "flohessling/no-clown-fiesta.nvim",
        enabled = true,
        lazy = false,
        priority = 999,
        config = function()
            require("no-clown-fiesta").setup({
                transparent = true, -- enable transparent background
            })
            vim.cmd("colorscheme no-clown-fiesta")
        end,
    },
}
