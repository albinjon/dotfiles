return {
  'folke/sidekick.nvim',
  opts = {
    cli = {
      watch = true, -- notify Neovim of file changes done by AI CLI tools
      ---@class sidekick.win.Opts
      win = {
        config = function(terminal) end,
        wo = {}, ---@type vim.wo
        bo = {}, ---@type vim.bo
        layout = 'right', ---@type "float"|"left"|"bottom"|"top"|"right"
        float = {
          width = 0.9,
          height = 0.9,
        },
        split = {
          width = 60, -- set to 0 for default split with
          height = 20, -- set to 0 for default split height
        },
        keys = {
          hide_n = { 'q', 'hide', mode = 'n', desc = 'hide the terminal window' },
          hide_ctrl_q = { '<c-q>', 'hide', mode = 'n', desc = 'hide the terminal window' },
          hide_ctrl_dot = { '<c-.>', 'hide', mode = 'nt', desc = 'hide the terminal window' },
          hide_ctrl_z = { '<c-z>', 'hide', mode = 'nt', desc = 'hide the terminal window' },
          prompt = { '<c-p>', 'prompt', mode = 't', desc = 'insert prompt or context' },
          stopinsert = { '<c-q>', 'stopinsert', mode = 't', desc = 'enter normal mode' },
          nav_left = { '<c-h>', 'nav_left', expr = true, desc = 'navigate to the left window' },
          nav_down = { '<c-j>', 'nav_down', expr = true, desc = 'navigate to the below window' },
          nav_up = { '<c-k>', 'nav_up', expr = true, desc = 'navigate to the above window' },
          nav_right = { '<c-l>', 'nav_right', expr = true, desc = 'navigate to the right window' },
        },
        ---@type fun(dir:"h"|"j"|"k"|"l")?
        nav = nil,
      },
    },
  },
  keys = {
    {
      '<c-.>',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle CLI',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = 'Select CLI',
    },
    {
      '<leader>ad',
      function()
        require('sidekick.cli').close()
      end,
      desc = 'Detach a CLI Session',
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send({ msg = '{this}' })
      end,
      mode = { 'x', 'n' },
      desc = 'Send This',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send({ msg = '{file}' })
      end,
      desc = 'Send File',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send({ msg = '{selection}' })
      end,
      mode = { 'x' },
      desc = 'Send Visual Selection',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick Select Prompt',
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle({ name = 'claude', focus = true })
      end,
      desc = 'Sidekick Toggle Claude',
    },
    {
      '<leader>ag',
      function()
        require('sidekick.cli').toggle({ name = 'copilot', focus = true })
      end,
      desc = 'Sidekick Toggle Github Copilot',
    },
    {
      '<leader>ax',
      function()
        require('sidekick.cli').toggle({ name = 'codex', focus = true })
      end,
      desc = 'Sidekick Toggle Codex',
    },
  },
}
