return {
  'toppair/peek.nvim',
  keys = {
    { '<leader>mdd', '<cmd>PeekOpen<cr>', { desc = '[m]ark[d]own preview' } },
    { '<leader>mdw', '<cmd>PeekClose<cr>', { desc = '[m]ark[d]own close' } },
  },
  build = 'deno task --quiet build:fast',
  config = function()
    require('peek').setup()
    vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
    vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
  end,
}
