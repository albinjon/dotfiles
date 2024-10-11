return {
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
        auto_trigger = true,
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
