-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  'mfussenegger/nvim-dap',
  event = 'BufRead',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  cmd = {
    'DapContinue',
    'DapStepInto',
    'DapStepOver',
    'DapStepOut',
    'DapToggleBreakpoint',
    'DapSetConditionalBreakpoint',
  },
  keys = {
    { '<F5>', '<cmd>DapContinue<cr>', desc = 'Debug: Start/Continue' },
    { '<F1>', '<cmd>DapStepInto<cr>', desc = 'Debug: Step Into' },
    { '<F2>', '<cmd>DapStepOver<cr>', desc = 'Debug: Step Over' },
    { '<F3>', '<cmd>DapStepOut<cr>', desc = 'Debug: Step Out' },
    { '<leader>db', '<cmd>DapToggleBreakpoint<cr>', desc = 'Debug: Toggle Breakpoint' },
    { '<leader>dB', '<cmd>DapSetConditionalBreakpoint<cr>', desc = 'Debug: Set Conditional Breakpoint' },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    require('mason-nvim-dap').setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
      },
    })

    -- Create user commands
    vim.api.nvim_create_user_command('DapContinue', function()
      dap.continue()
    end, { desc = 'Debug: Start/Continue' })
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
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F4>', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<leader>dq', dapui.close, { noremap = true, silent = true, desc = 'Quit DAP UI' })
    vim.keymap.set('n', '<leader>du', dapui.toggle, { noremap = true, silent = true, desc = 'Toggle DAP UI' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- get nvim config path
    local nvim_config_path = vim.fn.stdpath('config')
    require('dap').adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        -- 💀 Make sure to update this path to point to your installation
        args = { nvim_config_path .. '/.dap/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }

    require('dap').configurations.javascript = {
      config = function()
        local vscode_launch_path = vim.fn.getcwd() .. '/.vscode/launch.json'
        -- check if file exists
        if vim.fn.filereadable(vscode_launch_path) == 1 then
          vim.notify('Found launch.json file, loading configurations...', 'info')
          require('dap.ext.vscode').load_launchjs(
            vscode_launch_path,
            { node = { 'javascript', 'javascriptreact', 'typescriptreact', 'typescript' } }
          )
        end
      end,
    }

    -- Install golang specific config
    require('dap-go').setup({
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has('win32') == 0,
      },
    })
  end,
}
