return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find Files' },
        { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live Grep' },
        { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
        { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help Tags' },
        { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Keymaps' },
        { '<leader>fo', '<cmd>Telescope oldfiles<cr>', desc = 'Old Files' },
        -- LSP pickers
        { '<leader>gd', '<cmd>Telescope lsp_definitions<cr>', desc = 'LSP Definitions' },
        { '<leader>gr', '<cmd>Telescope lsp_references<cr>', desc = 'LSP References' },
        { '<leader>gi', '<cmd>Telescope lsp_implementations<cr>', desc = 'LSP Implementations' },
        -- Git pickers
        { '<leader>gs', '<cmd>Telescope git_status<cr>', desc = 'Git Status (changed files)' },
        { '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'Git Commits' },
        -- Diagnostics
        { '<leader>dd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Diagnostics (current file)' },
        { '<leader>dD', '<cmd>Telescope diagnostics<cr>', desc = 'Diagnostics (all files)' },
    },
    config = function()
        local actions = require("telescope.actions")
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                    n = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                },
            },
        })
    end,
}
