---@diagnostic disable: missing-fields

local function find_git_root()
  local current_dir = vim.fn.getcwd()
  local git_dir = current_dir
  local home_dir = vim.fn.expand('~')

  while git_dir ~= '/' and git_dir ~= home_dir do
    if vim.fn.isdirectory(git_dir .. '/.git') == 1 then
      return git_dir .. '/.git'
    end
    git_dir = vim.fn.fnamemodify(git_dir, ':h')
  end

  return current_dir -- Return current working dir if ~ or root is reached
end

return {
  'nvim-neotest/neotest',
  cmd = { 'NeotestRunDAP', 'NeotestRunFile', 'NeotestRunNearest' },
  keys = {
    { '<leader>trd', '<cmd>NeotestRunDAP<cr>', desc = 'Run test with DAP' },
    { '<leader>trr', '<cmd>NeotestRunFile<cr>', desc = 'Run all tests in file' },
    { '<leader>tra', '<cmd>NeotestRunNearest<cr>', desc = 'Run nearest test' },
  },
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'thenbe/neotest-playwright',
  },
  config = function()
    local nt = require('neotest')

    -- Create user commands
    vim.api.nvim_create_user_command('NeotestRunDAP', function()
      nt.run.run({ strategy = 'dap' })
    end, { desc = 'Run test with DAP' })

    vim.api.nvim_create_user_command('NeotestRunFile', function()
      nt.run.run(vim.fn.expand('%'))
    end, { desc = 'Run all tests in file' })

    vim.api.nvim_create_user_command('NeotestRunNearest', function()
      nt.run.run()
    end, { desc = 'Run nearest test' })
    require('neotest').setup({
      adapters = {
        require('neotest-playwright').adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            get_playwright_binary = function()
              local path = find_git_root() .. '/node_modules/.bin/playwright'
              vim.notify('Using Playwright binary at ' .. path, 4)
              return path
            end,
          },
          config = function()
            vim.keymap.set({ 'n' }, '<leader>tpa', function()
              require('neotest').playwright.attachment()
            end, { desc = 'show test attachments' })
          end,
        }),
      },
      consumers = {
        -- add to your list of consumers
        playwright = require('neotest-playwright.consumers').consumers,
      },
    })
  end,
}
