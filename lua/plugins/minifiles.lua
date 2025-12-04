return {
    "echasnovski/mini.files",
    version = "*",
    keys = {
        { "<leader>e", function() require("mini.files").open() end, desc = "Open file explorer" },
        { "<leader>E", function() require("mini.files").open(vim.fn.expand("%:p:h")) end, desc = "Open explorer at current file" },
    },
    config = function()
        require("mini.files").setup()
    end,
}
