return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      -- prettierd = {
      --   prepend_args = { "--single-attribute-per-line" },
      -- }
    },
    formatters_by_ft = {
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      vue = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      svelte = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      graphql = { "prettierd" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },
  },
}
