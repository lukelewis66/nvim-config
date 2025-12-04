return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Automatically update parsers on installation
  config = function()
    require("nvim-treesitter.configs").setup({
      -- List of parsers to ensure are installed
      ensure_installed = { "c", "lua", "vim", "javascript", "typescript", "html", "css", "json", "tsx" },
      highlight = { enable = true }, -- Enable syntax highlighting
      indent = { enable = true },    -- Enable indentation
      autoinstall = true,            -- Automatically install missing parsers
      -- You can add other features like folds, textobjects, etc.
    })
  end,
}
