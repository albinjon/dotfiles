-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set(
  'n',
  '[d',
  vim.diagnostic.goto_prev,
  { desc = 'Go to previous [D]iagnostic message' }
)
vim.keymap.set(
  'n',
  ']d',
  vim.diagnostic.goto_next,
  { desc = 'Go to next [D]iagnostic message' }
)
vim.keymap.set(
  'n',
  '<leader>e',
  vim.diagnostic.open_float,
  { desc = 'Show diagnostic [E]rror messages' }
)
vim.keymap.set(
  'n',
  '<leader>qf',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)

-- Movement keymaps
vim.keymap.set(
  { 'i', 'c' },
  '<M-BS>',
  '<C-W>',
  { desc = 'Delete word backwards' }
)
vim.keymap.set(
  { 'i', 'c' },
  '<M-Left>',
  '<S-Left>',
  { desc = 'Move cursor word backwards' }
)
vim.keymap.set(
  { 'i', 'c' },
  '<M-Right>',
  '<S-Right>',
  { desc = 'Move cursor word forwards' }
)
vim.keymap.set('n', '<C-å>', '<C-]>', { desc = 'Follow link' })
vim.keymap.set('n', '-', '$', { desc = 'End of line' })

-- Deletion keymaps
vim.keymap.set(
  { 'i', 'c' },
  '<M-Del>',
  '<S-Right><C-W>',
  { desc = 'Delete word forwards' }
)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set(
  'n',
  '<C-h>',
  '<C-w><C-h>',
  { desc = 'Move focus to the left window' }
)
vim.keymap.set(
  'n',
  '<C-l>',
  '<C-w><C-l>',
  { desc = 'Move focus to the right window' }
)
vim.keymap.set(
  'n',
  '<C-j>',
  '<C-w><C-j>',
  { desc = 'Move focus to the lower window' }
)
vim.keymap.set(
  'n',
  '<C-k>',
  '<C-w><C-k>',
  { desc = 'Move focus to the upper window' }
)

-- Persistence
vim.api.nvim_set_keymap(
  'n',
  '<leader>qs',
  [[<cmd>lua require("persistence").load()<cr>]],
  { desc = 'Re[s]tore session' }
)
-- restore the last session
vim.api.nvim_set_keymap(
  'n',
  '<leader>ql',
  [[<cmd>lua require("persistence").load({ last = true })<cr>]],
  { desc = 'Restore [l]ast session' }
)
-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap(
  'n',
  '<leader>qd',
  [[<cmd>lua require("persistence").stop()<cr>]],
  { desc = '[D]isable session saving' }
)

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup(
    'kickstart-highlight-yank',
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
