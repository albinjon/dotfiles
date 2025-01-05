return {
  'pogyomo/winresize.nvim',
  keys = {
    {
      '<C-M-h>',
      function()
        require('winresize').resize(0, 7, 'left')
      end,
    },
    {
      '<C-M-j>',
      function()
        require('winresize').resize(0, 2, 'down')
      end,
    },
    {
      '<C-M-k>',
      function()
        require('winresize').resize(0, 2, 'up')
      end,
    },
    {
      '<C-M-l>',
      function()
        require('winresize').resize(0, 7, 'right')
      end,
    },
  },
}
