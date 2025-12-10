return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("treesitter-context").setup({
            enable = true,
            max_lines = 3,           -- max lines to show at top
            multiline_threshold = 1, -- show context for single-line functions too
        })
    end,
}



