vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('help_window_right', {}),
  pattern = { '*.txt' },
  callback = function()
    if vim.o.filetype == 'help' then
      vim.cmd('set relativenumber')
      vim.cmd.wincmd('L')
    end
  end,
})

-- This is a workaround for the issue where the filetype is not detected fork
-- files opened with scp:// and netrw
vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*',
  callback = function()
    if vim.fn.expand('%'):match('^scp://') then
      vim.defer_fn(function()
        vim.cmd('filetype detect')
      end, 10)
    end
  end,
})

-- Add to your config:
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyCheck',
  callback = function()
    print('Cache check triggered')
  end,
})
