vim.api.nvim_buf_set_keymap(
  0,
  'n',
  '<CR>',
  '<cmd>KulalaVSCode<cr>',
  { noremap = true, silent = true, desc = 'Execute the request' }
)
