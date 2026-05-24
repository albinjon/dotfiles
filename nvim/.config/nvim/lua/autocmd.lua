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

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
  command = 'silent! EslintFixAll',
})

-- Drop nvim's informational "watch.watch: ENOENT" / "watch.watchdirs: ENOENT"
-- notify_once spam. The Roslyn LSP registers watchers on bin/, obj/, and
-- NuGet paths that often don't exist yet — nvim notifies once per missing
-- root, which floods the UI on first .cs open.
do
  local orig_notify_once = vim.notify_once
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify_once = function(msg, level, opts)
    if type(msg) == 'string' and msg:match('^watch%.watch[a-z]*: ENOENT') then
      return false
    end
    return orig_notify_once(msg, level, opts)
  end
end

vim.api.nvim_create_autocmd('ExitPre', {
  callback = function()
    local file = vim.uv.os_tmpdir() .. '/nvim_cwd'
    local f = io.open(file, 'w')
    f:write('cd ' .. vim.fn.getcwd() .. '\n')
    f:close()
  end,
})
