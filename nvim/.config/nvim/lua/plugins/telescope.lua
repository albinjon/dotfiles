local function del_map(mode, prefix, commands)
  for i = 1, #commands do
    vim.keymap.del(mode, prefix .. commands[i])
  end
end

local function kmopt(desc)
  return { silent = true, desc = desc }
end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope")
      del_map("n", "<leader>", { ",", "/", "<space>", "fF", "ff" })
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set(
        "n",
        "<leader>fE",
        ":Telescope file_browser no_ignore=true hidden=true<cr>",
        kmopt("File Explorer (Root)")
      )
      vim.keymap.set(
        "n",
        "<leader>fe",
        ":Telescope file_browser hidden=true no_ignore=true path=%:p:h select_buffer=true<cr>",
        kmopt("File Explorer (CWD)")
      )
      vim.keymap.set(
        "n",
        "<leader>fr",
        ":Telescope oldfiles hidden=true cwd_only=true<cr>",
        kmopt("Recent Files (CWD)")
      )
      vim.keymap.set("n", "<leader>fR", ":Telescope oldfiles hidden=true<cr>", kmopt("Recent Files (All)"))
      vim.keymap.set(
        "n",
        "<leader>ff",
        ":Telescope find_files no_ignore=true no_ignore_parent=true hidden=true<cr>",
        kmopt("Find Files")
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>fp",
        [[<cmd>lua require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root})<cr>]],
        { desc = "Find Plugin File" }
      )
    end,
  },
}
