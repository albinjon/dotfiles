return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  config = function()
    require('copilot').setup({
      filetypes = {
        dashboard = false,
      },
      suggestion = {
        auto_trigger = false,
        keymap = {
          accept = '<c-y>',
          next = '<c-CR>',
          prev = '<c-S-CR>',
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
