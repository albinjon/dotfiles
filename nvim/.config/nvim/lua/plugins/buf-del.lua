return {
  "famiu/bufdelete.nvim",
  config = function()
    vim.keymap.set("n", "<leader>fw", ":Bdelete<cr>", { silent = true, desc = "Delete current buffer" })
  end,
}
