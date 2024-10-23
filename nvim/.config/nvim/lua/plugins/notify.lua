---@diagnostic disable: missing-fields
return {
  event = { 'BufReadPost' },
  'rcarriga/nvim-notify',
  config = function()
    require('notify').setup({
      render = 'wrapped-compact',
      stages = 'slide',
      fps = 60,
      timeout = 1800,
      max_width = 80,
    })
  end,
}
