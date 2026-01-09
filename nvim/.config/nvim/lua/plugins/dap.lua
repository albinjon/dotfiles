return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
  },
  cmd = {
    'DapContinue',
    'DapStepInto',
    'DapStepOver',
    'DapStepOut',
    'DapToggleBreakpoint',
    'DapToggleUI',
    'DapCloseUI',
    'DapSetConditionalBreakpoint',
  },
  keys = {
    { '<leader>dl', '<cmd>DapContinue<cr>', desc = 'Debug: Start/Continue' },
    { '<leader>di', '<cmd>DapStepInto<cr>', desc = 'Debug: Step Into' },
    { '<leader>do', '<cmd>DapStepOver<cr>', desc = 'Debug: Step Over' },
    { '<leader>dO', '<cmd>DapStepOut<cr>', desc = 'Debug: Step Out' },
    { '<leader>b', '<cmd>DapToggleBreakpoint<cr>', desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', '<cmd>DapSetConditionalBreakpoint<cr>', desc = 'Debug: Set Conditional Breakpoint' },
    { '<leader>du', '<cmd>DapToggleUI<cr>', desc = 'Debug: Toggle UI' },
    { '<leader>dq', '<cmd>DapCloseUI<cr>', desc = 'Debug: Close UI' },
  },

  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    dapui.setup()
    dap.defaults.fallback.terminal_win_cmd = 'tabnew'

    require('dap.ext.vscode').load_launchjs(nil, { node = { 'typescript', 'javascript' } })

    local enter_launch_url = function()
      local co = coroutine.running()
      return coroutine.create(function()
        vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:' }, function(url)
          if url == nil or url == '' then
            return
          else
            coroutine.resume(co, url)
          end
        end)
      end)
    end

    for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue' }) do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file using Node.js (nvim-dap)',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to process using Node.js (nvim-dap)',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        -- requires ts-node to be installed globally or locally
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file using Node.js with ts-node/register (nvim-dap)',
          program = '${file}',
          cwd = '${workspaceFolder}',
          runtimeArgs = { '-r', 'ts-node/register' },
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Chrome (nvim-dap)',
          url = enter_launch_url,
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
        },
        {
          type = 'pwa-msedge',
          request = 'launch',
          name = 'Launch Edge (nvim-dap)',
          url = enter_launch_url,
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
        },
      }
    end
    local js_adapter_cmd = vim.fn.stdpath('config') .. '/lib/js-debug/src/dapDebugServer.js'

    for _, adapterType in ipairs({ 'node', 'chrome', 'msedge' }) do
      local pwaType = 'pwa-' .. adapterType

      dap.adapters[pwaType] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        resolveSourceMapLocations = { '${workspaceFolder}/', '!/node_modules/**' },
        executable = {
          command = 'node',
          args = {
            js_adapter_cmd,
            '${port}',
          },
        },
      }

      -- this allow us to handle launch.json configurations
      -- which specify type as "node" or "chrome" or "msedge"
      dap.adapters[adapterType] = function(cb, config)
        local nativeAdapter = dap.adapters[pwaType]

        config.type = pwaType

        if type(nativeAdapter) == 'function' then
          nativeAdapter(cb, config)
        else
          cb(nativeAdapter)
        end
      end
    end

    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#E53935' })
    vim.api.nvim_set_hl(0, 'DapConditionalBreakpoint', { ctermbg = 0, fg = '#FFF176' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })

    vim.fn.sign_define(
      'DapBreakpoint',
      { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define('DapBreakpointCondition', {
      text = '',
      texthl = 'DapConditionalBreakpoint',
      linehl = '',
      numhl = 'DapConditionalBreakpoint',
    })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '→', linehl = '', texthl = 'DapStopped', numhl = 'DapStopped' })

    vim.api.nvim_create_user_command('DapContinue', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.api.nvim_create_user_command('DapStepInto', function()
      dap.step_into()
    end, { desc = 'Debug: Step Into' })
    vim.api.nvim_create_user_command('DapStepOver', function()
      dap.step_over()
    end, { desc = 'Debug: Step Over' })
    vim.api.nvim_create_user_command('DapStepOut', function()
      dap.step_out()
    end, { desc = 'Debug: Step Out' })
    vim.api.nvim_create_user_command('DapToggleBreakpoint', function()
      dap.toggle_breakpoint()
    end, { desc = 'Debug: Toggle Breakpoint' })
    vim.api.nvim_create_user_command('DapSetConditionalBreakpoint', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = 'Debug: Set Conditional Breakpoint' })
    vim.api.nvim_create_user_command('DapToggleUI', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.api.nvim_create_user_command('DapCloseUI', dapui.close, { desc = 'Quit DAP UI' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
