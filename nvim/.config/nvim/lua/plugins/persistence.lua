return {
  'folke/persistence.nvim',
  ft = 'dashboard',
  event = 'InsertEnter',
  opts = {
    options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' }, -- sessionoptions used for saving
  },
}
