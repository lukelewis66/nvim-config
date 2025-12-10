return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
        size = 15,
        open_mapping = [[<C-\>]],
        direction = "horizontal", -- "horizontal", "vertical", "float", or "tab"
        shade_terminals = true,
        start_in_insert = true,
        persist_mode = true,
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        -- Make Esc and C-\ work in terminal mode
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
        vim.keymap.set("t", "<C-\\>", [[<cmd>ToggleTerm<cr>]], { desc = "Toggle terminal" })
    end,
}

