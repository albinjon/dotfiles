---@diagnostic disable: need-check-nil
local function repl(to_run)
  local filetype = vim.bo.filetype
  if filetype ~= 'typescript' and filetype ~= 'javascript' then
    vim.notify('Only TypeScript or JavaScript files are supported.', vim.log.levels.ERROR)
    return
  end

  local config = vim.fn.stdpath('config') .. '/repl'
  local ext = filetype == 'javascript' and 'js' or 'ts'
  local tmp = config .. '/tmp/temp.' .. ext

  local content = to_run and vim.split(to_run, '\n') or vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.fn.writefile(content, tmp)

  if filetype == 'typescript' then
    local out = vim.fn.system(string.format('cd %s && tsc %s', config, tmp))
    if vim.v.shell_error ~= 0 and not out:find('only allowed at the top level') then
      vim.notify('Compilation failed: ' .. out, vim.log.levels.ERROR)
      return
    end
    tmp = tmp:gsub('%.ts$', '.js')
  end

  local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  local running = true
  local notif_id = 'repl_progress'

  vim.notify('Running...', vim.log.levels.INFO, {
    title = 'Result',
    id = notif_id,
    opts = function(notif)
      notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    end,
  })

  local timer = vim.loop.new_timer()
  timer:start(100, 100, function()
    if not running then
      timer:stop()
      timer:close()
      return
    end
    vim.schedule(function()
      vim.notify('Running...', vim.log.levels.INFO, {
        title = 'Result',
        id = notif_id,
        opts = function(notif)
          notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end)
  end)

  local stdout, stderr = {}, {}
  vim.fn.jobstart({ 'node', tmp }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if line ~= '' then
          table.insert(stdout, line)
        end
      end
    end,
    on_stderr = function(_, data, _)
      for _, line in ipairs(data) do
        if line ~= '' then
          table.insert(stderr, line)
        end
      end
    end,
    on_exit = function(_, code, _)
      running = false
      vim.schedule(function()
        local msg = ''
        if code == 0 then
          msg = #stdout > 0 and table.concat(stdout, '\n') or ''
        else
          msg = #stderr > 0 and table.concat(stderr, '\n') or 'Error running file.'
        end
        vim.notify('Output:\n' .. msg, code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR, {
          title = 'Result',
          id = notif_id,
          opts = function(notif)
            notif.icon = code == 0 and ' ' or ''
          end,
        })
      end)
    end,
  })
end

return { run = repl }
