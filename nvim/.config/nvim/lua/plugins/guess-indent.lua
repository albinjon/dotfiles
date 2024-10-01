-- using packer.nvim
return {
  event = 'BufReadPost',
  'nmac427/guess-indent.nvim',
  config = function()
    require('guess-indent').setup({})
  end,
}
