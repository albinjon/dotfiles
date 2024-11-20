return {
  enabled = true,
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup({
      filetypes = {
        dashboard = false,
        sql = true,
      },
      suggestion = {
        auto_trigger = false,
        keymap = {
          next = '<c-p>n',
          prev = '<c-p>p',
        },
      },
      panel = {
        keymap = {
          jump_prev = '<c-k>',
          jump_next = '<c-j>',
          accept = '<CR>',
          refresh = 'gr',
        },
      },
    })
  end,
}
