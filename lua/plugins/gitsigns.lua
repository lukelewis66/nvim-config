return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            signs = {
                add          = { text = "│" },
                change       = { text = "│" },
                delete       = { text = "_" },
                topdelete    = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local opts = { buffer = bufnr }

                -- Navigation between hunks
                vim.keymap.set("n", "]h", gs.next_hunk, opts)
                vim.keymap.set("n", "[h", gs.prev_hunk, opts)

                -- Actions
                vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
                vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
                vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
                vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
                vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
                vim.keymap.set("n", "<leader>hd", gs.diffthis, opts)
                vim.keymap.set("n", "<leader>hS", gs.stage_buffer, opts)  -- stage entire file

                -- Toggle blame on current line
                vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, opts)
            end,
        })
    end,
}

