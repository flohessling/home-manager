local M = {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    keys = {
        { "<leader>gb", ":GitBlameToggle<CR>", { desc = "git blame" } },
        { "<leader>gbo", ":GitBlameOpenCommitURL<CR>", { desc = "git blame open commit URL" } },
    },
}

M.init = function()
    vim.g["gitblame_enabled"] = 0
end

return M
