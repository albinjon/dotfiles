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

local api = vim.api
local function open_floating_window()
  local floating_window_scaling_factor = 0.7

  -- Why is this required?
  -- vim.g.lazygit_floating_window_scaling_factor returns different types if the value is an integer or float
  if type(floating_window_scaling_factor) == 'table' then
    floating_window_scaling_factor = floating_window_scaling_factor[false]
  end

  local status, plenary = pcall(require, 'plenary.window.float')
  if status and vim.g.lazygit_floating_window_use_plenary and vim.g.lazygit_floating_window_use_plenary ~= 0 then
    local ret = plenary.percentage_range_window(floating_window_scaling_factor, floating_window_scaling_factor)
    return ret.win_id, ret.bufnr
  end

  local height = math.ceil(vim.o.lines * floating_window_scaling_factor) - 1
  local width = math.ceil(vim.o.columns * floating_window_scaling_factor)

  local row = math.ceil(vim.o.lines - height) / 2
  local col = math.ceil(vim.o.columns - width) / 2

  local border_opts = {
    style = 'minimal',
    relative = 'editor',
    row = row - 1,
    col = col - 1,
    width = width + 2,
    height = height + 2,
  }

  local opts = { style = 'minimal', relative = 'editor', row = row, col = col, width = width, height = height }

  local topleft, top, topright, right, botright, bot, botleft, left
  local window_chars = vim.g.lazygit_floating_window_border_chars
  if type(window_chars) == 'table' and #window_chars == 8 then
    topleft, top, topright, right, botright, bot, botleft, left = unpack(window_chars)
  else
    topleft, top, topright, right, botright, bot, botleft, left = '╭', '─', '╮', '│', '╯', '─', '╰', '│'
  end

  local border_lines = { topleft .. string.rep(top, width) .. topright }
  local middle_line = left .. string.rep(' ', width) .. right
  for _ = 1, height do
    table.insert(border_lines, middle_line)
  end
  table.insert(border_lines, botleft .. string.rep(bot, width) .. botright)

  -- create a unlisted scratch buffer for the border
  local border_buffer = api.nvim_create_buf(false, true)

  -- set border_lines in the border buffer from start 0 to end -1 and strict_indexing false
  api.nvim_buf_set_lines(border_buffer, 0, -1, true, border_lines)
  -- create border window
  local border_window = api.nvim_open_win(border_buffer, true, border_opts)
  vim.api.nvim_set_hl(0, 'LazyGitBorder', { link = 'Normal', default = true })
  vim.cmd('set winhl=NormalFloat:LazyGitBorder')

  -- create a unlisted scratch buffer
  if LAZYGIT_BUFFER == nil or vim.fn.bufwinnr(LAZYGIT_BUFFER) == -1 then
    LAZYGIT_BUFFER = api.nvim_create_buf(false, true)
  else
    LAZYGIT_LOADED = true
  end
  -- create file window, enter the window, and use the options defined in opts
  local win = api.nvim_open_win(LAZYGIT_BUFFER, true, opts)

  vim.bo[LAZYGIT_BUFFER].filetype = 'posting'

  vim.cmd('setlocal bufhidden=hide')
  vim.cmd('setlocal nocursorcolumn')
  vim.api.nvim_set_hl(0, 'LazyGitFloat', { link = 'Normal', default = true })
  vim.cmd('setlocal winhl=NormalFloat:LazyGitFloat')
  vim.cmd('set winblend=0')

  -- use autocommand to ensure that the border_buffer closes at the same time as the main buffer
  local cmd = [[autocmd WinLeave <buffer> silent! execute 'hide']]
  vim.cmd(cmd)
  cmd = [[autocmd WinLeave <buffer> silent! execute 'silent bdelete! %s']]
  vim.cmd(cmd:format(border_buffer))

  return win, LAZYGIT_BUFFER
end
local function confirm_and_delete_buffer()
  local confirm = vim.fn.confirm('Delete buffer and file?', '&Yes\n&No', 2)

  if confirm == 1 then
    os.remove(vim.fn.expand('%'))
    vim.api.nvim_buf_delete(0, { force = true })
  end
end

local function split_and_switch_buffer(split_type)
  if split_type == 'v' then
    vim.cmd('vsplit')
  else
    vim.cmd('split')
  end

  local new_win = vim.api.nvim_get_current_win()

  vim.cmd('wincmd p')

  local recent_buffers = vim.fn.getbufinfo({ buflisted = 1 })
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
  local original_register = vim.fn.getreg('"')
  vim.cmd('normal! "vy')
  local selected_text = vim.fn.getreg('"')
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
      local fb = require('telescope').extensions.file_browser
      local wk = require('which-key')
      wk.register({
        ['c'] = { name = '[c]ode', _ = 'which_key_ignore' },
        ['d'] = {
          name = '[d]ebug (dap)',
          {
            c = { '<cmd>lua require("dap").continue()<cr>', '[c]ontinue' },
          },
        },
        ['f'] = {
          name = '[f]iles',
          e = {
            function()
              fb.file_browser({
                select_buffer = true,
                cwd = vim.fn.expand('%:p:h'),
                respect_gitignore = false,
                hidden = true,
              })
            end,
            '[f]ile [e]xplorer',
          },
          d = { confirm_and_delete_buffer, 'Delete file' },
          E = { '<cmd>Explore<cr>', '[e]xplore (netrw)' },
        },
        ['r'] = {
          name = '[r]eload',
          b = { '<cmd>bufdo e<cr>', '[r]eload all [b]uffers' },
          f = { '<cmd>e<cr>', '[r]eload [f]ile' },
        },
        ['s'] = {
          name = '[s]plits/[s]earch',
          ['l'] = {
            {
              function()
                split_and_switch_buffer('v')
              end,
              '[s]plit (vertical/to right)',
            },
          },
          ['j'] = {
            function()
              split_and_switch_buffer('h')
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
          o = { open_floating_window, '[o]pen' },
        },
        ['g'] = { name = '[g]it', _ = 'which_key_ignore' },
        ['o'] = {
          name = '[o]bsidian',
          ['o'] = {
            '<cmd>ObsidianOpen<cr>',
            '[o]pen obsidian',
          },
          ['n'] = {
            '<cmd>ObsidianNew<cr>',
            'open [n]ew',
          },
          ['s'] = {
            '<cmd>ObsidianSearch<cr>',
            '[s]earch',
          },
          ['w'] = {
            '<cmd>ObsidianWorkspace<cr>',
            '[s]earch',
          },
        },
        ['q'] = {
          name = '[q]uit/session',
          q = { '<cmd>wa<cr><cmd>qa<cr>', '[q]uit and write all' },
          d = { '<cmd>wa<cr><cmd>Dashboard<cr>', '[q]uit and go to [d]ashboard' },
          ['Q'] = { '<cmd>qa!<cr>', '[q]uit and abandon all' },
          ['F'] = {
            '<cmd>Bdelete!<cr>',
            '[a]bandon file',
          },
          f = {
            '<cmd>up<cr><cmd>Bdelete<cr>',
            '[q]uit and write file',
          },
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
