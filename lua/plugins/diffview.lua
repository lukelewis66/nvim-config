return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open diff view (all changes)" },
        { "<leader>gV", "<cmd>DiffviewOpen --staged<cr>", desc = "Open diff view (staged only)" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
        { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Full git history" },
        { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
    },
    config = function()
        local actions = require("diffview.actions")
        require("diffview").setup({
            keymaps = {
                view = {
                    { "n", "q", actions.close, { desc = "Close diffview" } },
                    -- Navigate hunks (vim's built-in diff navigation)
                    { "n", "]h", "]c", { desc = "Next hunk" } },
                    { "n", "[h", "[c", { desc = "Previous hunk" } },
                },
                file_panel = {
                    { "n", "q", actions.close, { desc = "Close diffview" } },
                    { "n", "X", actions.restore_entry, { desc = "Restore file to git version" } },
                    { "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage file" } },
                    { "n", "S", actions.stage_all, { desc = "Stage all files" } },
                    { "n", "U", actions.unstage_all, { desc = "Unstage all files" } },
                },
                file_history_panel = {
                    { "n", "q", actions.close, { desc = "Close diffview" } },
                },
            },
        })
    end,
}

