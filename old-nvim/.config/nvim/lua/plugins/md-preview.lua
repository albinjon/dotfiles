-- install without yarn or npm
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      -- vim.keymap.set("n", "<leader>mdp", "<cmd>MarkdownPreview<cr>", { noremap = true, silent = true })
      -- vim.keymap.set("n", "<leader>mds", "<cmd>MarkdownPreviewStop<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { noremap = true, silent = true })
    end,
  },

  -- install with yarn or npm
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   build = "cd app && yarn install",
  --   init = function()
  --     vim.g.mkdp_filetypes = { "markdown" }
  --   end,
  --   ft = { "markdown" },
  -- },
}
