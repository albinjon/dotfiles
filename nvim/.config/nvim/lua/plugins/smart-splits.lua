return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  opts = {
    multiplexer_integration = 'wezterm',
  },
  keys = {
    {
      '<C-h>',
      function()
        require('smart-splits').move_cursor_left()
      end,
      mode = { 'n', 'i' },
      desc = 'Move to left split/pane',
    },
    {
      '<C-j>',
      function()
        require('smart-splits').move_cursor_down()
      end,
      mode = { 'n', 'i' },
      desc = 'Move to lower split/pane',
    },
    {
      '<C-k>',
      function()
        require('smart-splits').move_cursor_up()
      end,
      mode = { 'n', 'i' },
      desc = 'Move to upper split/pane',
    },
    {
      '<C-l>',
      function()
        require('smart-splits').move_cursor_right()
      end,
      mode = { 'n', 'i' },
      desc = 'Move to right split/pane',
    },
  },
}
