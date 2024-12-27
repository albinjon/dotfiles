return {
  'yetone/avante.nvim',
  keys = {
    { '<leader>ae', '<cmd>AvanteEdit<cr>', desc = '[a]vante [e]dit', mode = 'v' },
    { '<leader>aa', '<cmd>AvanteAsk<cr>', desc = '[a]vante [a]sk' },
  },
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = 'openai',
    auto_suggestions_provider = 'copilot',
    hints = { enabled = false },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {

      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
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
        file_types = { 'Avante' },
      },
      ft = { 'Avante' },
    },
  },
}
