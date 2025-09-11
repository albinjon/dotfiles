local function term_run(cmd)
  vim.cmd('botright 12split | terminal')
  local chan = vim.b.terminal_job_id
  vim.fn.chansend(chan, cmd .. '\n')
end

-- Run current buffer on Pico (no copy)
vim.keymap.set('n', '<leader>pr', function()
  local file = vim.fn.expand('%:p')
  local config_path = vim.fn.stdpath('config') .. '/scripts/pico/'
  local script = config_path .. 'run_current.sh'

  term_run(string.format(script .. ' ' .. file))
end, { desc = 'Pico: run current buffer' })

-- Deploy src/ to Pico and reset (runs main.py)
vim.keymap.set('n', '<leader>pd', function()
  local config_path = vim.fn.stdpath('config') .. '/scripts/pico/'
  local script = config_path .. 'deploy.sh'
  term_run(script)
end, { desc = 'Pico: deploy project' })

-- Open REPL
vim.keymap.set('n', '<leader>pp', function()
  local config_path = vim.fn.stdpath('config') .. '/scripts/pico/'
  local script = config_path .. 'repl.sh'
  term_run(script)
end, { desc = 'Pico: REPL' })
