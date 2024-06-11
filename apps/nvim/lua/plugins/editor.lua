return {
    {
        "github/copilot.vim",
        event = "InsertEnter",
        init = function()
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_tab_fallback = ""
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = {},
        keys = {
            -- stylua: ignore start
            { "<leader>x",  function() require("trouble").toggle(); end,                                    desc = "Toggle trouble", },
            { "<C-x>",      function() require("trouble").toggle(); end,                                    desc = "Toggle trouble", },
            { "<leader>xw", function() require("trouble").toggle("workspace_diagnostics"); end,             desc = "Toggle trouble with workspace diagnostics", },
            { "<leader>xd", function() require("trouble").toggle("document_diagnostics"); end,              desc = "Toggle trouble with document diagnostics", },
            { "<leader>xq", function() require("trouble").toggle("quickfix"); end,                          desc = "Toggle trouble with quickfix list", },
            { "<leader>xl", function() require("trouble").toggle("loclist"); end,                           desc = "Toggle trouble with LSP references", },
            { "gR",         function() require("trouble").toggle("lsp_references"); end,                    desc = "Toggle trouble with loclist", },
            { "]x",         function() require("trouble").next({ skip_groups = true, jump = true }); end,   desc = "Jump to next trouble item", },
            { "[x",         function() require("trouble").previous({ skip_groups = true, jump = true }); end, desc = "Jump to previous trouble item", },
            { "<C-q>",      function() require("trouble").toggle("quickfix"); end,                          desc = "Jump to previous trouble item", },
            -- stylua: ignore end
        },
    },
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        keys = {
            -- stylua: ignore start
            { "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle Harpoon menu" },
            { "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Add file to Harpoon" },
            { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Navigate to Harpoon file 1" },
            { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Navigate to Harpoon file 2" },
            { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Navigate to Harpoon file 3" },
            { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Navigate to Harpoon file 4" },
            { "<leader>5", function() require("harpoon.ui").nav_file(5) end, desc = "Navigate to Harpoon file 5" },
            -- stylua: ignore end
        },
    },
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.gitblame_enabled = 0
        end,
        keys = {
            { "<leader>gb", ":GitBlameToggle<CR>", { desc = "git blame" } },
            { "<leader>gbo", ":GitBlameOpenCommitURL<CR>", { desc = "git blame open commit URL" } },
        },
    },
    {
        "tpope/vim-abolish",
        event = "BufReadPost",
    },
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
        },
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggle", "DiffviewFileHistory" },
    },
    {
        "mcauley-penney/visual-whitespace.nvim",
        config = true,
        event = "BufReadPost",
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        config = true,
    },
}
