return {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>F",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable auto format on save for now (you can enable if you want)
            return false
        end,
        formatters_by_ft = {
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            html = { "prettier" },
        },
        formatters = {
            prettier = {
                -- Prettier will automatically find .prettierrc files in the project
                -- No need to specify config path, it will use the one closest to the file
            },
        },
    },
}

