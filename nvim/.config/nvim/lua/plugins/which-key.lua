local function confirm_and_delete_buffer()
  local confirm = vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2)

  if confirm == 1 then
    os.remove(vim.fn.expand("%"))
    vim.api.nvim_buf_delete(0, { force = true })
  end
end

local function split_and_switch_buffer(split_type)
  if split_type == "v" then
    vim.cmd("vsplit")
  else
    vim.cmd("split")
  end

  local new_win = vim.api.nvim_get_current_win()

  vim.cmd("wincmd p")

  local recent_buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #recent_buffers <= 1 then
    vim.api.nvim_set_current_win(new_win)
    return
  end
  table.sort(recent_buffers, function(a, b)
    return a.lastused > b.lastused
  end)

  for _, buf in ipairs(recent_buffers) do
    if #buf.windows == 0 then
      vim.cmd("buffer " .. buf.bufnr)
      break
    end
  end

  vim.api.nvim_set_current_win(new_win)
end

local function search_help()
  local original_register = vim.fn.getreg('"')
  vim.cmd('normal! "vy')
  local selected_text = vim.fn.getreg('"')
  vim.fn.setreg('"', original_register)
  vim.cmd("help " .. selected_text)
end

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local wk = require("which-key")
    wk.register(
      {
        ["`"] = "which_key_ignore",
        ["-"] = "which_key_ignore",
        ["|"] = "which_key_ignore",
        ["w|"] = "which_key_ignore",
        ["wd"] = "which_key_ignore",
        ["<space>"] = "which_key_ignore",
        w = {
          name = "windows",
          ["s"] = {
            function()
              split_and_switch_buffer("v")
            end,
            "Split Vertically",
          },
          ["S"] = {
            function()
              split_and_switch_buffer("h")
            end,
            "Split Horizontally",
          },
          q = {
            "<cmd>up<cr><cmd>Bdelete<cr>",
            "Close and write file",
          },
          Q = {
            "<cmd>Bdelete!<cr>",
            "Close and abandon file",
          },
        },
        f = {
          d = { confirm_and_delete_buffer, "Delete file" },
        },
        ["s"] = {
          mode = "v",
          h = {
            search_help,
            "Search help (visual selection)",
          },
        },
      },
      { prefix = "<leader>" },
      wk.register({
        s = {
          mode = "v",
          name = "Search",
          h = {
            search_help,
            "Search help (visual selection)",
          },
        },
      })
    )
  end,
  opts = {
    layout = {
      align = "center",
    },
    window = {
      position = "top",
    },

    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
