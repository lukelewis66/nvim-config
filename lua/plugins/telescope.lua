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
                -- Truncate path from the left, keeping the filename visible
                path_display = { "truncate" },
                -- Wider layout to see more of the path
                layout_config = {
                    horizontal = {
                        width = 0.9,
                        preview_width = 0.5,
                    },
                },
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        -- Press Ctrl+f to see full path in a floating window
                        ["<C-f>"] = function(prompt_bufnr)
                            local entry = require("telescope.actions.state").get_selected_entry()
                            if entry then
                                local path = entry.filename or entry.path or entry.value or entry[1] or "No path"
                                -- Show in a floating window that stays visible
                                local buf = vim.api.nvim_create_buf(false, true)
                                vim.api.nvim_buf_set_lines(buf, 0, -1, false, { path })
                                local width = math.min(#path + 4, vim.o.columns - 4)
                                local win = vim.api.nvim_open_win(buf, false, {
                                    relative = "cursor",
                                    row = 1,
                                    col = 0,
                                    width = width,
                                    height = 1,
                                    style = "minimal",
                                    border = "rounded",
                                })
                                -- Auto-close after 3 seconds
                                vim.defer_fn(function()
                                    if vim.api.nvim_win_is_valid(win) then
                                        vim.api.nvim_win_close(win, true)
                                    end
                                end, 3000)
                            end
                        end,
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
