return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'williamboman/mason.nvim',
    'rcarriga/nvim-dap-ui',
    'nvim-telescope/telescope.nvim',
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
    { '<F5>', '<cmd>DapContinue<cr>', desc = 'Debug: Start/Continue' },
    { '<F1>', '<cmd>DapStepInto<cr>', desc = 'Debug: Step Into' },
    { '<F2>', '<cmd>DapStepOver<cr>', desc = 'Debug: Step Over' },
    { '<F3>', '<cmd>DapStepOut<cr>', desc = 'Debug: Step Out' },
    { '<leader>db', '<cmd>DapToggleBreakpoint<cr>', desc = 'Debug: Toggle Breakpoint' },
    { '<leader>dB', '<cmd>DapSetConditionalBreakpoint<cr>', desc = 'Debug: Set Conditional Breakpoint' },
    { '<leader>du', '<cmd>DapToggleUI<cr>', desc = 'Debug: Toggle UI' },
    { '<leader>dq', '<cmd>DapCloseUI<cr>', desc = 'Debug: Close UI' },
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
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }
    require('dap').configurations.javascript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }
    local mason_registry = require('mason-registry')
    local js_adapter_cmd = mason_registry.get_package('js-debug-adapter'):get_install_path() .. '/js-debug-adapter'

    require('dap').adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = js_adapter_cmd,
        args = { '${port}' },
      },
    }

    vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
    -- Create user commands
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
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
