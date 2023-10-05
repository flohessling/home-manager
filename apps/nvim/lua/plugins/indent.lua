return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
        indent = { char = "│" },
        scope = { exclude = { language = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" } } },
    },
}
