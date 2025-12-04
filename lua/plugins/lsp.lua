return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "ts_ls",      -- TypeScript/JavaScript
                "eslint",     -- Linting
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Add LSP capabilities for nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Configure LSP servers with capabilities
            vim.lsp.config("*", { capabilities = capabilities })
            -- LSP keymaps (set when LSP attaches to buffer)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client then
                        vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)
                    end

                    local opts = { buffer = args.buf }

                    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
                    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                end,
            })

            -- Enable LSP servers
            vim.lsp.enable("ts_ls")
            vim.lsp.enable("eslint")
        end,
    },
}
