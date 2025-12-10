-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Buffer management
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Copy file path to clipboard
vim.keymap.set("n", "<leader>cp", ':let @+ = expand("%:.")<CR>', { desc = "Copy relative path" })
vim.keymap.set("n", "<leader>cP", ':let @+ = expand("%:p")<CR>', { desc = "Copy absolute path" })

-- Toggle between source and test file
vim.keymap.set("n", "<leader>tt", function()
    local current = vim.fn.expand("%:p")
    local target

    if current:match("%.spec%.tsx?$") then
        -- Currently in test file, go to source
        target = current:gsub("%.spec%.ts", ".ts"):gsub("%.spec%.tsx", ".tsx")
    else
        -- Currently in source file, go to test
        local base = current:gsub("%.tsx?$", "")
        local ext = current:match("%.tsx$") and ".spec.tsx" or ".spec.ts"
        target = base .. ext
    end

    if vim.fn.filereadable(target) == 1 then
        vim.cmd.edit(target)
    else
        vim.notify("Test file not found: " .. vim.fn.fnamemodify(target, ":t"), vim.log.levels.WARN)
    end
end, { desc = "Toggle test file" })

-- Wrap selection with performance measurement
local function wrap_with_perf()
    -- Get buffer content to find existing perf variables
    local buf_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    
    -- Find the next available suffix
    local suffix = ""
    local counter = 1
    while buf_content:find("_perfStart" .. suffix) or buf_content:find("_perfEnd" .. suffix) do
        suffix = tostring(counter)
        counter = counter + 1
    end
    
    local start_var = "_perfStart" .. suffix
    local end_var = "_perfEnd" .. suffix
    
    -- Get visual selection range
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    
    -- Get indentation of first selected line
    local first_line = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
    local indent = first_line:match("^(%s*)") or ""
    
    -- Insert after selection first (so line numbers don't shift)
    vim.api.nvim_buf_set_lines(0, end_line, end_line, false, {
        indent .. "const " .. end_var .. " = performance.now()",
        indent .. "console.log(`took ${(" .. end_var .. " - " .. start_var .. ") / 1000}s`)",
    })
    
    -- Insert before selection
    vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, {
        indent .. "const " .. start_var .. " = performance.now()",
    })
end

vim.keymap.set("v", "<leader>perf", ":<C-u>lua _G.wrap_with_perf()<CR>", { desc = "Wrap with performance timing", silent = true })

-- Export for the keymap
_G.wrap_with_perf = wrap_with_perf
