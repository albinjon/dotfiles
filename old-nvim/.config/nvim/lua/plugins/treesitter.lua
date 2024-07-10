return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    ---@diagnostic disable-next-line: missing-fields
    config.setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "prisma",
        "query",
        "regex",
        "vue",
        "go",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    })
  end,
}
