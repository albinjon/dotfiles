---@diagnostic disable: missing-fields

local function find_git_root()
  local current_dir = vim.fn.getcwd()
  local git_dir = current_dir
  local home_dir = vim.fn.expand '~'

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
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'thenbe/neotest-playwright',
  },
  config = function()
    local nt = require 'neotest'
    vim.keymap.set('n', '<leader>trd', function()
      nt.run.run { strategy = 'dap' }
    end, { desc = 'run test with DAP' })
    vim.keymap.set('n', '<leader>trr', function()
      nt.run.run()
    end, { desc = 'run all tests in file' })
    vim.keymap.set('n', '<leader>tra', function()
      nt.run.run()
    end, { desc = 'run nearest test' })
    require('neotest').setup {
      adapters = {
        require('neotest-playwright').adapter {
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
        },
      },
      consumers = {
        -- add to your list of consumers
        playwright = require('neotest-playwright.consumers').consumers,
      },
    }
  end,
}
