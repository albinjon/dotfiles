return {
  cmd = 'BlameToggle',
  'FabijanZulj/blame.nvim',
  config = function()
    require('blame').setup({

      mappings = {
        commit_info = 'K',
      },
    })
  end,
}
