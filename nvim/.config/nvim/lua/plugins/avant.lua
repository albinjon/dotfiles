return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>ae', '<cmd>AvanteEdit<cr>', desc = '[a]vante [e]dit', mode = 'v' },
    { '<leader>aa', '<cmd>AvanteAsk<cr>', desc = '[a]vante [a]sk', mode = 'v' },
    { '<leader>aa', '<cmd>AvanteAsk<cr>', desc = '[a]vante [a]sk' },
  },
  version = '*', -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
    -- add any opts here
    -- for example
    provider = 'openai',
    hints = { enabled = false },
    providers = {
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- timeout in milliseconds
        extra_request_body = {
          temperature = 0,
          max_tokens = 4096,
        },
      },
    },
  },
  build = 'make',
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
