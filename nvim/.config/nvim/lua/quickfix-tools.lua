-- plugin/quickfix_tools.lua

-- Helpers -----------------------------------------------------------
local function set_qflist_keep_cursor(new, idx)
  vim.fn.setqflist(new, 'r')
  if #new == 0 then
    vim.cmd.cclose()
    return
  end
  vim.cmd.copen()
  pcall(vim.api.nvim_win_set_cursor, 0, { math.min(idx, #new), 0 })
end

-- :QFDelete /pattern/  -> remove entries whose **file path** matches pattern
vim.api.nvim_create_user_command('QFDelete', function(opts)
  local pat = opts.args
  if pat:match('^/.+/$') then
    pat = pat:sub(2, -2)
  end
  local re = vim.regex(pat)

  local qf, out = vim.fn.getqflist(), {}
  for _, it in ipairs(qf) do
    local fname = it.filename or (it.bufnr and vim.api.nvim_buf_get_name(it.bufnr)) or ''
    if not re:match_str(fname) then
      table.insert(out, it)
    end
  end
  set_qflist_keep_cursor(out, 1)
end, { nargs = 1, complete = 'file' })

-- :QFKeep /pattern/  -> keep only entries whose **file path** matches pattern
vim.api.nvim_create_user_command('QFKeep', function(opts)
  local pat = opts.args
  if pat:match('^/.+/$') then
    pat = pat:sub(2, -2)
  end
  local re = vim.regex(pat)

  local qf, out = vim.fn.getqflist(), {}
  for _, it in ipairs(qf) do
    local fname = it.filename or (it.bufnr and vim.api.nvim_buf_get_name(it.bufnr)) or ''
    if re:match_str(fname) then
      table.insert(out, it)
    end
  end
  set_qflist_keep_cursor(out, 1)
end, { nargs = 1, complete = 'file' })

-- Quickfix-only maps ------------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(ev)
    local function remove_current()
      local idx = vim.api.nvim_win_get_cursor(0)[1]
      local qf = vim.fn.getqflist()
      if #qf == 0 then
        return
      end
      table.remove(qf, idx)
      set_qflist_keep_cursor(qf, idx)
    end

    -- dd: delete current quickfix entry
    vim.keymap.set('n', 'dd', remove_current, { buffer = ev.buf, silent = true, desc = 'Delete quickfix entry' })

    -- <leader>sf: keep only files matching pattern
    vim.keymap.set('n', '<leader>sf', function()
      local pat = vim.fn.input('QF keep (file pattern): ')
      if pat == '' then
        return
      end
      vim.cmd(('QFKeep /%s/'):format(pat:gsub('/', '\\/')))
    end, { buffer = ev.buf, silent = true, desc = 'Filter quickfix (keep matches by file)' })

    -- <leader>sd: delete files matching pattern
    vim.keymap.set('n', '<leader>sd', function()
      local pat = vim.fn.input('QF delete (file pattern): ')
      if pat == '' then
        return
      end
      vim.cmd(('QFDelete /%s/'):format(pat:gsub('/', '\\/')))
    end, { buffer = ev.buf, silent = true, desc = 'Filter quickfix (delete matches by file)' })
  end,
})
