return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      -- prettier = {
      --   prepend_args = { "--single-attribute-per-line" },
      -- }
    },
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      vue = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      svelte = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },
  },
}
