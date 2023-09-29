local M = {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>e", ":NvimTreeToggle<CR>", { desc = "[E]xplorer" } },
    },
}

M.config = function()
    require('nvim-web-devicons').setup()

    function start_telescope(node, telescope_mode)
        -- local node = require("nvim-tree.lib").get_node_at_cursor()
        local abspath = node.link_to or node.absolute_path
        local is_folder = node.open ~= nil
        local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
        require("telescope.builtin")[telescope_mode] {
            cwd = basedir,
            hidden = true,
        }
    end

    local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "gtf", function()
            local node = api.tree.get_node_under_cursor()
            start_telescope(node, "live_grep")
        end, opts("telescope_live_grep"))
    end

    require("nvim-tree").setup({
        hijack_cursor = true,
        prefer_startup_root = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        diagnostics = {
            enable = true,
            show_on_dirs = false,
        },
        update_focused_file = {
            enable = true,
            update_root = true,
        },
        system_open = {
            cmd = nil,
            args = {},
        },
        git = {
            enable = true,
            ignore = false,
            timeout = 200,
        },
        view = {
            width = 40,
            side = "left",
            adaptive_size = true,
        },
        renderer = {
            indent_markers = {
                enable = false,
                icons = {
                    corner = "└",
                    edge = "│",
                    item = "│",
                    none = " ",
                },
            },
            highlight_git = true,
            group_empty = false,
            root_folder_modifier = ":t",
        },
        filters = {
            dotfiles = false,
            custom = { "node_modules", "\\.cache" },
            exclude = {},
        },
        actions = {
            use_system_clipboard = true,
            change_dir = {
                global = true,
            },
            open_file = {
                window_picker = {
                    enable = false,
                },
            },
        },
    })
end
-- NvimTree

return M
