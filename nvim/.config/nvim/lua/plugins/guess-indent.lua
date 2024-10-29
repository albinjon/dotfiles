-- using packer.nvim
return {
  event = 'InsertEnter',
  'nmac427/guess-indent.nvim',
  config = function()
    require('guess-indent').setup({})
  end,
}
