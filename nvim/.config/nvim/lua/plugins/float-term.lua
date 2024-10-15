return {
  enabled = true,
  'numToStr/FTerm.nvim',
  cmd = { 'FTermToggle', 'FTermBtop', 'FTermPosting' },
  config = function()
    local fterm = require('FTerm')
    fterm.setup({
      border = 'rounded',
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
    })
    local btop = fterm:new({
      border = 'rounded',
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
      ft = 'fterm_btop',
      cmd = 'btop',
    })
    local posting = fterm:new({
      border = 'rounded',
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
      ft = 'fterm_posting',
      cmd = 'posting',
    })
    vim.api.nvim_create_user_command('FTermBtop', function()
      btop:toggle()
    end, {})
    vim.api.nvim_create_user_command('FTermPosting', function()
      posting:toggle()
    end, {})
    vim.api.nvim_create_user_command('FTermToggle', fterm.toggle, {})
  end,
}
