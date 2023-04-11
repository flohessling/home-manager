local M = {
    "Mofiqul/vscode.nvim",
    enabled = true,
    lazy = false,
    priority = 999,
}

function M.config()
    local c = require("vscode.colors")
    local vscode = require("vscode")
    vscode.setup({
        transparent = true, -- enable transparent background
        italic_comments = true, -- enable italic comments
        disable_nvimtree_bg = true, -- disable nvim-tree background color
    })
    vim.cmd("colorscheme vscode")
end

return M
