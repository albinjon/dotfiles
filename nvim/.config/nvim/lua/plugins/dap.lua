return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    "nvim-neotest/nvim-nio"
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
    { '<F5>',       '<cmd>DapContinue<cr>',                 desc = 'Debug: Start/Continue' },
    { '<F1>',       '<cmd>DapStepInto<cr>',                 desc = 'Debug: Step Into' },
    { '<F2>',       '<cmd>DapStepOver<cr>',                 desc = 'Debug: Step Over' },
    { '<F3>',       '<cmd>DapStepOut<cr>',                  desc = 'Debug: Step Out' },
    { '<leader>b',  '<cmd>DapToggleBreakpoint<cr>',         desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B',  '<cmd>DapSetConditionalBreakpoint<cr>', desc = 'Debug: Set Conditional Breakpoint' },
    { '<leader>du', '<cmd>DapToggleUI<cr>',                 desc = 'Debug: Toggle UI' },
    { '<leader>dq', '<cmd>DapCloseUI<cr>',                  desc = 'Debug: Close UI' },
  },

  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    dapui.setup()
    dap.defaults.fallback.terminal_win_cmd = 'tabnew'

    require('dap.ext.vscode').load_launchjs(nil, { node = { 'typescript', 'javascript' } })
    require('dap').configurations.typescript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'TS: Launch file',
        runtimeExecutable = 'ts-node-dev',
        runtimeArgs = {
          '-O {"module":"commonjs"}',
        },
        program = '${file}',
        env = { NODE_ENV = 'development' },
        skipFiles = { 'node_modules/**' },
        cwd = '${workspaceFolder}',
      },
    }
    require('dap').configurations.javascript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Node: Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Deno: Launch file',
        runtimeExecutable = 'deno',
        runtimeArgs = {
          'run',
          '--inspect-wait',
          '--allow-all',
        },
        program = '${file}',
        cwd = '${workspaceFolder}',
        attachSimplePort = 9229,
      },
      {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = 'Node: Attach to process',
        type = 'pwa-node',
        request = 'attach',
        processId = require('dap.utils').pick_process,
      },
    }
    local mason_registry = require('mason-registry')
    local js_adapter_cmd = mason_registry.get_package('js-debug-adapter'):get_install_path() .. '/js-debug-adapter'

    require('dap').adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      resolveSourceMapLocations = { '${workspaceFolder}/', '!/node_modules/**' },
      executable = {
        command = js_adapter_cmd,
        args = { '${port}' },
      },
    }

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
