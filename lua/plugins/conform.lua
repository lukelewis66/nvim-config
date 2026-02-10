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
        {
            "<leader>fI",
            function()
                require("conform").info()
            end,
            desc = "Conform Info",
        },
    },
    opts = {
        notify_on_error = true,
        format_on_save = function(bufnr)
            return { timeout_ms = 2000, lsp_fallback = true }
        end,
        formatters_by_ft = {
            javascript = { "eslint_d", "prettier" },
            javascriptreact = { "eslint_d", "prettier" },
            typescript = { "eslint_d", "prettier" },
            typescriptreact = { "eslint_d", "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            html = { "prettier" },
        },
        formatters = {
            prettier = {
                prepend_args = { "--stdin-filepath", "$FILENAME" },
            },
        },
    },
}

