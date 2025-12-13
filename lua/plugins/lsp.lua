-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "hrsh7th/cmp-nvim-lsp",
    "pmizio/typescript-tools.nvim",
  },
  config = function()
    -- Capabilities for nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- Mason setup
    require("mason").setup()

    -- TypeScript tooling for .tsx/.jsx
    local ok_ts, ts_tools = pcall(require, "typescript-tools")
    if ok_ts then
      ts_tools.setup({
        capabilities = capabilities,
        settings = {
          tsserver_max_memory = 8192,
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
          },
        },
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
      })
    end

    -- LSP attach keymaps and autocommands
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local buf = event.buf
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc, nowait = true })
        end

        local telescope_ok, telescope = pcall(require, "telescope.builtin")

        -- Go to definitions, references, implementations
        map("gd", function()
          if telescope_ok then telescope.lsp_definitions() else vim.lsp.buf.definition() end
        end, "[G]oto [D]efinition")

        map("gr", function()
          if telescope_ok then telescope.lsp_references({ show_line = false }) else vim.lsp.buf.references() end
        end, "[G]oto [R]eferences")

        map("gI", function()
          if telescope_ok then telescope.lsp_implementations() else vim.lsp.buf.implementation() end
        end, "[G]oto [I]mplementation")

        map("<leader>D", function()
          if telescope_ok then telescope.lsp_type_definitions() else vim.lsp.buf.type_definition() end
        end, "Type [D]efinition")

        map("<leader>ds", function()
          if telescope_ok then telescope.lsp_document_symbols() else vim.lsp.buf.document_symbol() end
        end, "[D]ocument [S]ymbols")

        map("<leader>ws", function()
          if telescope_ok then telescope.lsp_dynamic_workspace_symbols() else vim.lsp.buf.workspace_symbol() end
        end, "[W]orkspace [S]ymbols")

        -- Rename, code actions, hover, declaration
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gh", vim.lsp.buf.hover, "[G]o [H]over")
        map("<leader>d", vim.diagnostic.open_float, "[D]iagnostic under cursor")
        map("<leader>dc", function()
          local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
          if #diagnostics > 0 then
            local message = diagnostics[1].message
            vim.fn.setreg("+", message)
            vim.fn.setreg("*", message)
            vim.notify("Copied diagnostic: " .. message:sub(1, 50) .. (message:len() > 50 and "..." or ""), vim.log.levels.INFO)
          else
            vim.notify("No diagnostic found at cursor", vim.log.levels.WARN)
          end
        end, "[D]iagnostic [C]opy")

        -- Inlay hints toggle
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
            )
          end, "[T]oggle Inlay [H]ints")
        end

        -- Highlight references
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = ev.buf })
            end,
          })
        end
      end,
    })

    -- Global diagnostic keymaps
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

    -- Diagnostic symbols
    if vim.g.have_nerd_font then
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end

    -- LSP servers
    local servers = {
      bashls = {},
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
            format = { enable = false },
          },
        },
      },
      eslint = {
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        settings = { format = false, codeActionOnSave = { enable = false, mode = "all" }, run = "onSave" },
      },
    }

    -- Mason LSP setup
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

          -- Increase ESLint memory if needed
          if server_name == "eslint" then
            local path = vim.fn.stdpath("data") .. "/mason/packages/eslint-lsp/node_modules/vscode-eslint-language-server/out/eslintServer.js"
            if vim.fn.filereadable(path) == 1 then
              server.cmd = { "node", "--max-old-space-size=8192", path, "--stdio" }
            end
          end

          if vim.lsp.config[server_name] then
            vim.lsp.config[server_name].setup(server)
          end
        end,
      },
    })

    -- Mason tool installer
    require("mason-tool-installer").setup({
      ensure_installed = { "stylua", "eslint", "typescript-language-server", "prettier" },
    })
  end,
}

