return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",     -- LSP completions
        "hrsh7th/cmp-buffer",        -- Buffer completions
        "hrsh7th/cmp-path",          -- Path completions
        "L3MON4D3/LuaSnip",          -- Snippet engine
        "saadparwaiz1/cmp_luasnip",  -- Snippet completions
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                -- Navigate completion menu
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                -- Scroll docs
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                -- Show completion menu
                ["<C-Space>"] = cmp.mapping.complete(),
                -- Cancel
                ["<C-e>"] = cmp.mapping.abort(),
                -- Confirm selection
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                -- Tab to confirm or jump in snippet
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },  -- LSP
                { name = "luasnip" },   -- Snippets
                { name = "buffer" },    -- Current buffer
                { name = "path" },      -- File paths
            }),
        })
    end,
}

