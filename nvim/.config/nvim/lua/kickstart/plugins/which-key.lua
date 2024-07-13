-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

local function confirm_and_delete_buffer()
  local confirm = vim.fn.confirm('Delete buffer and file?', '&Yes\n&No', 2)

  if confirm == 1 then
    os.remove(vim.fn.expand '%')
    vim.api.nvim_buf_delete(0, { force = true })
  end
end

local function split_and_switch_buffer(split_type)
  if split_type == 'v' then
    vim.cmd 'vsplit'
  else
    vim.cmd 'split'
  end

  local new_win = vim.api.nvim_get_current_win()

  vim.cmd 'wincmd p'

  local recent_buffers = vim.fn.getbufinfo { buflisted = 1 }
  if #recent_buffers <= 1 then
    vim.api.nvim_set_current_win(new_win)
    return
  end
  table.sort(recent_buffers, function(a, b)
    return a.lastused > b.lastused
  end)

  for _, buf in ipairs(recent_buffers) do
    if #buf.windows == 0 then
      vim.cmd('buffer ' .. buf.bufnr)
      break
    end
  end

  vim.api.nvim_set_current_win(new_win)
end

local function search_help()
  local original_register = vim.fn.getreg '"'
  vim.cmd 'normal! "vy'
  local selected_text = vim.fn.getreg '"'
  vim.fn.setreg('"', original_register)
  vim.cmd('help ' .. selected_text)
end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      local wk = require 'which-key'
      wk.register({
        ['c'] = { name = '[c]ode', _ = 'which_key_ignore' },
        ['d'] = { name = '[d]ebug (dap)', {
          c = { '<cmd>lua require("dap").continue()<cr>', '[c]ontinue' },
        } },
        ['f'] = { name = '[f]iles', d = { confirm_and_delete_buffer, 'Delete file' }, E = { '<cmd>Explore<cr>', '[e]xplore (netrw)' } },
        ['fe'] = { name = '[f]ile [e]xplorer', _ = 'which_key_ignore' },
        ['r'] = { name = '[r]eload', b = { '<cmd>bufdo e<cr>', '[r]eload all [b]uffers' }, f = { '<cmd>e<cr>', '[r]eload [f]ile' } },
        ['s'] = {
          name = '[s]plits/[s]earch',
          ['l'] = {
            {
              function()
                split_and_switch_buffer 'v'
              end,
              '[s]plit (vertical/to right)',
            },
          },
          ['j'] = {
            function()
              split_and_switch_buffer 'h'
            end,
            '[s]plit (horizontal/down)',
          },
          ['s'] = {
            '<cmd>q<cr>',
            '[s]plit delete',
          },
        },
        ['t'] = { name = '[t]rouble', _ = 'which_key_ignore' },
        ['w'] = {
          name = '[w]rite',
          w = { '<cmd>update<cr>', '[w]rite' },
          a = { '<cmd>wa<cr>', 'write [a]ll' },
          q = {
            '<cmd>up<cr><cmd>Bdelete<cr>',
            '[q]uit and write file',
          },
          Q = {
            '<cmd>Bdelete!<cr>',
            '[q]uit and abandon file',
          },
        },
        ['g'] = { name = '[g]it', _ = 'which_key_ignore' },
        ['q'] = {
          name = '[q]uit/session',
          q = { '<cmd>qa<cr>', '[q]uit all' },
          w = { '<cmd>wa<cr><cmd>qa<cr>', '[w]rite and [q]uit all' },
        },
      }, { prefix = '<leader>' })
      -- visual mode
      wk.register({
        ['<leader>g'] = { '[g]it' },
        ['<leader>s'] = {
          name = '[s]earch',
          h = {
            search_help,
            'search [h]elp (visual selection)',
          },
        },
      }, { mode = 'v' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
