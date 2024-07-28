return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup({
      filetypes = {
        dashboard = false,
      },
      suggestion = {
        auto_trigger = true,
      },
      panel = {
        keymap = {
          jump_prev = '<c-e>',
          jump_next = '<c-n>',
          accept = '<CR>',
          refresh = 'gr',
        },
      },
    })
  end,
}
