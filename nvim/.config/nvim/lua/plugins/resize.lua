return {
  "pogyomo/winresize.nvim",
  config = function()
    local resize = require("winresize").resize
    vim.keymap.set("n", "<C-M-h>", function()
      resize(0, 7, "left")
    end)
    vim.keymap.set("n", "<C-M-j>", function()
      resize(0, 2, "down")
    end)
    vim.keymap.set("n", "<C-M-k>", function()
      resize(0, 2, "up")
    end)
    vim.keymap.set("n", "<C-M-l>", function()
      resize(0, 7, "right")
    end)
  end,
}
