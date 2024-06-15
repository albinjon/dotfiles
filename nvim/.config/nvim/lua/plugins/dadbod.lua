return {
  {
    "tpope/vim-dadbod",
    enabled = false,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = false,
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 60
      vim.g.db_ui_table_helpers = {
        postgresql = {
          all = "SELECT * FROM {table}",
        },
      }
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.keymap.set("n", "<leader>dbu", ":DBUIToggle<CR>")
    end,
  },
}
