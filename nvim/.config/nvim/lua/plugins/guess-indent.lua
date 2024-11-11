-- using packer.nvim
return {
  event = 'BufRead',
  'nmac427/guess-indent.nvim',
  config = function()
    require('guess-indent').setup({})
  end,
}
