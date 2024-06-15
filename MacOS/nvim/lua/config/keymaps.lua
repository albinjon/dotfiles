-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--

local function del_map(mode, prefix, commands)
  for i = 1, #commands do
    vim.keymap.del(mode, prefix .. commands[i])
  end
end

local commands = {
  "<tab>]",
  "<tab>[",
  "<tab><tab>",
  "<tab>d",
  "<tab>f",
  "<tab>o",
  "<tab>l",
  "`",
  "K",
  "wd",
  "|",
  "w|",
  "-",
  "w-",
  "ww",
}

del_map("n", "<leader>", commands)

vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-W>", { desc = "Delete word backwards" })
vim.keymap.set({ "i", "c" }, "<M-Left>", "<S-Left>", { desc = "Move cursor word backwards" })
vim.keymap.set({ "i", "c" }, "<M-Right>", "<S-Right>", { desc = "Move cursor word forwards" })
vim.keymap.set({ "i", "c" }, "<M-Del>", "<S-Right><C-W>", { desc = "Delete word forwards" })
vim.keymap.set({ "n" }, "<leader>ww", ":q<cr>", { desc = "Close window", noremap = true, silent = true })
vim.keymap.set("n", "<C-å>", "<C-]>", { desc = "Follow link" })

-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})
-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})
-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})
