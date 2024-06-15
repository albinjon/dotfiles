return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      vim.keymap.set(
        "n",
        "<leader>db",
        dap.toggle_breakpoint,
        { noremap = true, silent = true, desc = "Toggle breakpoint" }
      )
      vim.keymap.set("n", "<leader>dc", dap.continue, { noremap = true, silent = true, desc = "Continue" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { noremap = true, silent = true, desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>dn", dap.step_over, { noremap = true, silent = true, desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { noremap = true, silent = true, desc = "Step into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { noremap = true, silent = true, desc = "Step out" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { noremap = true, silent = true, desc = "Run last" })
      -- vim.keymap.set("n", "<leader>ds", dap.close, { noremap = true, silent = true, desc = "Stop Debugging" })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "leoluz/nvim-dap-go" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dapui.setup()
      require("dap-go").setup()
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      vim.keymap.set("n", "<leader>dq", dapui.close, { noremap = true, silent = true, desc = "Quit DAP UI" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { noremap = true, silent = true, desc = "Toggle DAP UI" })
    end,
  },
}
