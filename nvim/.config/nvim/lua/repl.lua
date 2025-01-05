local notif_id = 'repl_progress'

local function formatOutput(output, fallback)
  local msg = #output > 0 and table.concat(output, '\n') or fallback
  return output and 'Output:\n' .. msg
end

local function spinnerNotification(message)
  local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  vim.notify(message, vim.log.levels.INFO, {
    title = 'Result',
    id = notif_id,
    opts = function(notif)
      notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    end,
  })
end

local function repl(to_run)
  if type(to_run) ~= 'string' then
    to_run = nil
  end

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
    local tsc_cmd = string.format(
      'cd %s && tsc %s --lib es2023,dom --target es2022 --module node16 --moduleResolution node16',
      config,
      tmp
    )
    local out = vim.fn.system(tsc_cmd)
    if vim.v.shell_error ~= 0 and not out:find('only allowed at the top level') then
      vim.notify('Compilation failed: ' .. out:gsub('.-*repl/tmp/.-: ', ''), vim.log.levels.ERROR)
      return
    end
    tmp = tmp:gsub('%.ts$', '.js')
  end

  local running = true

  local timer = vim.loop.new_timer()
  if timer == nil then
    vim.notify('Failed to start timer.', vim.log.levels.WARN, { title = 'Result', id = notif_id })
    return
  end
  local stdout, stderr = {}, {}

  timer:start(100, 100, function()
    if not running then
      timer:stop()
      timer:close()
      return
    end
    vim.schedule(function()
      local message = formatOutput(stdout, 'Running...')
      spinnerNotification(message)
    end)
  end)

  vim.fn.jobstart({ 'node', tmp }, {
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if line ~= '' then
          table.insert(stdout, line)
          local message = formatOutput(stdout, 'Running...')
          spinnerNotification(message)
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
        local output = ''
        if code == 0 then
          output = formatOutput(stdout, '')
        else
          output = formatOutput(stderr, 'Error running file.')
        end
        vim.notify(output, code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR, {
          title = 'Result',
          id = notif_id,
          timeout = 5000,
          opts = function(notif)
            notif.icon = code == 0 and ' ' or ''
          end,
        })
      end)
    end,
  })
end

return { run = repl }
