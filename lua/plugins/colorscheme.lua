return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("kanagawa")
        end,
    },
    { "catppuccin/nvim", name = "catppuccin", lazy = true },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "folke/tokyonight.nvim", name = "tokyonight", lazy = true },
}
