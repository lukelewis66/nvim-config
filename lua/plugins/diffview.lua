return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open diff view (all changes)" },
        { "<leader>gV", "<cmd>DiffviewOpen --staged<cr>", desc = "Open diff view (staged only)" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
        { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
    },
    config = function()
        local actions = require("diffview.actions")
        require("diffview").setup({
            keymaps = {
                view = {
                    { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
                },
                file_panel = {
                    { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
                },
                file_history_panel = {
                    { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
                },
            },
        })
    end,
}

