return {
  "famiu/bufdelete.nvim",
  config = function()
    vim.keymap.set("n", "<S-w>", ":Bdelete<cr>", { silent = true })
  end,
}
