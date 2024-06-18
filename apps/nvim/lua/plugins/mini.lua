return {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,

    config = function()
        require("mini.bracketed").setup()
        require("mini.surround").setup()
        require("mini.trailspace").setup()
        require("mini.bufremove").setup()
        require("mini.cursorword").setup()
        -- require("mini.statusline").setup()
        require("mini.notify").setup()
        require("mini.splitjoin").setup()
        require("mini.misc").setup({ make_global = { "setup_auto_root" } })
        require("mini.misc").setup_auto_root()

        require("mini.move").setup({})
        -- to use meta keys with iterm change the setting in iterm for option key to +Esc
        -- profiles > keys > general > option key acts as +Esc

        require("mini.indentscope").setup({
            -- symbol = "╎",
            symbol = "│",
            options = { try_as_border = true },
            draw = {
                animation = require("mini.indentscope").gen_animation.linear(),
            },
        })

        require("mini.comment").setup({
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
            mappings = {
                comment_line = "<leader>/",
                comment_visual = "<leader>/",
            },
        })

        require("mini.files").setup({
            mappings = {
                go_in_plus = "<Enter>",
                go_out_plus = "<Left>",
            },
        })

        local MiniFiles = require("mini.files")
        local map_split = function(buf_id, lhs, direction)
            local rhs = function()
                -- create new window and set it as target
                local new_target_window
                vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
                    vim.cmd(direction .. " split")
                    new_target_window = vim.api.nvim_get_current_win()
                end)

                MiniFiles.set_target_window(new_target_window)
            end

            vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "split " .. direction })
        end

        vim.api.nvim_create_autocmd("user", {
            pattern = "MiniFilesBufferCreate",
            callback = function(args)
                local buf_id = args.data.buf_id

                -- open in split
                map_split(buf_id, "gs", "belowright horizontal")
                map_split(buf_id, "gv", "belowright vertical")

                -- grep in folder
                vim.keymap.set("n", "gg", function()
                    local cur_entry_path = MiniFiles.get_fs_entry().path
                    local basedir = vim.fs.dirname(cur_entry_path)
                    MiniFiles.close()
                    require("telescope.builtin").find_files({ cwd = basedir, hidden = true })
                end, { buffer = buf_id, desc = "grep in directory" })
            end,
        })
        vim.api.nvim_create_autocmd("user", {
            pattern = "MiniFilesWindowOpen",
            callback = function(args)
                local win_id = args.data.win_id
                vim.api.nvim_win_set_config(win_id, { border = "rounded" })
            end,
        })
    end,
    -- stylua: ignore
    keys = {
        { "<leader>X", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer", },
        { "<leader>e", function()
            local MiniFiles = require("mini.files")
            if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
        end, desc = "open in file explorer" }
    },
}
