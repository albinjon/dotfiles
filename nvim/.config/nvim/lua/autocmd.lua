vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('help_window_right', {}),
  pattern = { '*.txt' },
  callback = function()
    if vim.o.filetype == 'help' then
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

-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     vim.defer_fn(function()
--       print("Loaded buffers:")
--       for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
--         local name = vim.api.nvim_buf_get_name(bufnr)
--         print(string.format("Buffer %d: %s", bufnr, name))
--       end
--     end, 100)  -- 100ms delay to allow for session restoration
--   end,
-- })
