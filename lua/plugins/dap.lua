return {
    -- Core DAP (Debug Adapter Protocol) plugin
    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional Breakpoint" },
            { "<leader>d<space>", function() require("dap").continue() end, desc = "Start/Continue Debugging" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
            { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
            { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<leader>ds", function() require("dap").session() end, desc = "Session" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            { "<leader>dw", function()
                local widgets = require("dap.ui.widgets")
                local word = vim.fn.expand("<cword>")
                if word and word ~= "" then
                    widgets.hover(nil, { expr = word })
                else
                    widgets.hover()
                end
            end, desc = "Inspect Variable (word under cursor)" },
            { "<leader>dl", function() require("dap").list_breakpoints() vim.cmd("copen") end, desc = "List Breakpoints" },
            { "<leader>df", function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames) end, desc = "Show Stack Frames" },
        },
        config = function()
            local dap = require("dap")

            -- Path to js-debug-adapter installed by Mason
            local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

            -- Register the pwa-node adapter
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = { js_debug_path, "${port}" },
                },
            }

            -- Configure Node.js debugging for TypeScript/JavaScript
            for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
                dap.configurations[language] = {
                    -- Attach to local backend via Bazel (matches your VS Code "Local backend" config)
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach to Local Backend (Bazel)",
                        port = 9229,
                        cwd = "${workspaceFolder}",
                        sourceMaps = true,
                        -- Allow all source map locations
                        resolveSourceMapLocations = nil,
                        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
                        -- Source map path overrides (maps Bazel paths back to workspace)
                        sourceMapPathOverrides = {
                            ["../*"] = "${workspaceFolder}/*",
                            ["../../*"] = "${workspaceFolder}/*",
                            ["../../../*"] = "${workspaceFolder}/*",
                            ["../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../../../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../../../../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../../../../../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../../../../../../../../../*"] = "${workspaceFolder}/*",
                        },
                        -- Don't restrict outFiles - let it find source maps anywhere (Bazel output)
                    },
                    -- Attach to jest debug (port 9230)
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach to Jest (9230)",
                        port = 9230,
                        cwd = "${workspaceFolder}",
                        sourceMaps = true,
                        resolveSourceMapLocations = nil,
                        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
                        sourceMapPathOverrides = {
                            ["../*"] = "${workspaceFolder}/*",
                            ["../../*"] = "${workspaceFolder}/*",
                            ["../../../*"] = "${workspaceFolder}/*",
                            ["../../../../*"] = "${workspaceFolder}/*",
                            ["../../../../../*"] = "${workspaceFolder}/*",
                        },
                    },
                    -- Launch current file
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch Current File",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                        sourceMaps = true,
                    },
                }
            end

            -- Visual signs for breakpoints
            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
            vim.fn.sign_define("DapLogPoint", { text = "◎", texthl = "DapLogPoint", linehl = "", numhl = "" })

            -- Highlight colors
            vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
            vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
            vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d" })
        end,
    },

    -- Nice UI for debugging
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        keys = {
            { "<leader>du", function() require("dapui").toggle({}) end, desc = "Toggle DAP UI" },
            { "<leader>de", function()
                local dapui = require("dapui")
                local mode = vim.fn.mode()
                if mode == "v" or mode == "V" then
                    -- Visual mode: eval selection
                    dapui.eval()
                else
                    -- Normal mode: eval word under cursor
                    local word = vim.fn.expand("<cword>")
                    if word and word ~= "" then
                        dapui.eval(word)
                    else
                        dapui.eval()
                    end
                end
            end, desc = "Eval (word under cursor or selection)", mode = { "n", "v" } },
        },
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)

            -- Automatically open/close UI when debugging starts/ends
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    },

    -- Virtual text showing variable values inline
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
        },
    },

    -- Telescope integration for DAP (frames with preview!)
    {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
        keys = {
            { "<leader>dF", function() require("telescope").extensions.dap.frames({}) end, desc = "Telescope Stack Frames" },
            { "<leader>dL", function() require("telescope").extensions.dap.list_breakpoints({}) end, desc = "Telescope Breakpoints" },
            { "<leader>dv", function() require("telescope").extensions.dap.variables({}) end, desc = "Telescope Variables" },
        },
        config = function()
            require("telescope").load_extension("dap")
        end,
    },
}
