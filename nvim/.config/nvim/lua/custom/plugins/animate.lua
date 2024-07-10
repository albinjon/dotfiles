return {
  'echasnovski/mini.animate',
  version = '*',
  config = function()
    require('mini.animate').setup {
      cursor = {
        enable = false,
      },
      scroll = {
        enable = true,
        timing = function(_, n)
          return 85 / n
        end,
      },
      resize = {
        enable = false,
      },
      open = {
        enable = false,
      },
      close = {
        enable = false,
      },
    }
  end,
}
