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

local function get_visual_selection()
  local original_register = vim.fn.getreg('"')
  vim.cmd('normal! "vy')
  local selected_text = vim.fn.getreg('"')
  vim.fn.setreg('"', original_register)
  return selected_text
end

local function search_help()
  vim.cmd('help ' .. get_visual_selection())
end

local function open_file_in_finder()
  local file_path = vim.fn.expand('%:p')
  vim.fn.system('open -R ' .. file_path)
end

local function replace_selection()
  local selected_text = get_visual_selection()
  local replacement = vim.fn.input('Enter replacement text: ', selected_text)
  vim.cmd(string.format('%%s/%s/%s/gc', selected_text:gsub('/', '\\/'), replacement:gsub('/', '\\/')))
end

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    -- You can add any Which-Key specific options here
    -- or leave it empty to use the default settings
    spec = {
      {
        -- Normal mode mappings
        { mode = 'n', '<leader>c', group = '[c]ode' },
        { mode = 'n', '<leader>cp', group = '[c]opilot' },
        { mode = 'n', '<leader>cn', group = '[c(s)]nippets' },
        { mode = 'n', '<leader>m', group = '[m]arkdown' },
        { mode = 'n', '<leader>p', group = '[p]ostgres' },
        { mode = 'n', '<leader>d', group = '[d]ebug (dap)' },
        { mode = 'n', '<leader>dc', "<cmd>lua require('dap').continue()<cr>", desc = 'DAP [c]ontinue' },
        { mode = 'n', '<leader>f', group = '[f]iles' },
        { mode = 'n', '<leader>fE', '<cmd>Explore<cr>', desc = '[e]xplore (netrw)' },
        {
          mode = 'n',
          '<leader>fo',
          function()
            open_file_in_finder()
          end,
          desc = '[o]pen current file (finder)',
        },
        {
          mode = 'n',
          '<leader>fd',
          function()
            confirm_and_delete_buffer()
          end,
          desc = 'Delete file',
        },
        {
          mode = 'n',
          '<leader>fe',
          function()
            require('mini.files').open(
              vim.api.nvim_buf_get_name(0)
              -- , false, {
              -- filter = function(fs_entry)
              --   return vim.startswith(fs_entry.name, '.DS_Store')
              -- end,
            )
          end,
          desc = '[f]ile [e]xplorer',
        },
        { mode = 'n', '<leader>g', group = '[g]it' },
        { mode = 'n', '<leader>o', group = '[o]bsidian' },
        { mode = 'n', '<leader>on', '<cmd>ObsidianNew<cr>', desc = 'open [n]ew' },
        { mode = 'n', '<leader>oo', '<cmd>ObsidianOpen<cr>', desc = '[o]pen obsidian' },
        { mode = 'n', '<leader>os', '<cmd>ObsidianSearch<cr>', desc = '[s]earch' },
        { mode = 'n', '<leader>ow', '<cmd>ObsidianWorkspace<cr>', desc = 'open [w]orkspace' },
        { mode = 'n', '<leader>po', '<cmd>DbeeToggle<cr>', desc = '[p]ostgres [o]pen' },
        { mode = 'n', '<leader>q', group = '[q]uit/session' },
        { mode = 'n', '<leader>qF', '<cmd>Bdelete!<cr>', desc = '[a]bandon file' },
        { mode = 'n', '<leader>qQ', '<cmd>qa!<cr>', desc = '[q]uit and abandon all' },
        { mode = 'n', '<leader>qd', '<cmd>wa<cr><cmd>Dashboard<cr>', desc = '[q]uit and go to [d]ashboard' },
        { mode = 'n', '<leader>qf', '<cmd>up<cr><cmd>Bdelete<cr>', desc = '[q]uit and write file' },
        { mode = 'n', '<leader>qb', '<cmd>Bdelete!<cr>', desc = '[q]uit buffer' },
        { mode = 'n', '<leader>tn', '<cmd>terminal<cr>', desc = '[n]ew [t]erminal' },
        { mode = 'n', '<leader>qq', '<cmd>wa<cr><cmd>qa<cr>', desc = '[q]uit and write all' },
        { mode = 'n', '<leader>r', group = '[r]eload' },
        { mode = 'n', '<leader>rb', '<cmd>bufdo e<cr>', desc = '[r]eload all [b]uffers' },
        { mode = 'n', '<leader>rf', '<cmd>e<cr>', desc = '[r]eload [f]ile' },
        { mode = 'n', '<leader>s', group = '[s]plits/[s]earch' },
        { mode = 'n', '<leader>cna', '<cmd>ScissorsAddNewSnippet<CR>', { desc = '[a]dd new snippet' } },
        { mode = 'n', '<leader>cnr', '<cmd>ScissorsEditSnippet<CR>', { desc = '[e]dit snippet' } },
        {
          mode = 'n',
          '<c-w>j',
          function()
            split_and_switch_buffer('h')
          end,
          desc = '[s]plit (horizontal/down)',
        },
        {
          mode = 'n',
          '<c-w>l',
          function()
            split_and_switch_buffer('v')
          end,
          desc = '[s]plit (vertical/to right)',
        },
        { mode = 'n', '<c-w>q', '<cmd>q<cr>', desc = '[s]plit delete' },
        { mode = 'n', '<leader>t', group = '[t]rouble' },
        { mode = 'n', '<leader>w', group = '[w]rite' },
        { mode = 'n', '<leader>wa', '<cmd>wa<cr>', desc = 'write [a]ll' },
        { mode = 'n', '<leader>ww', '<cmd>update<cr>', desc = '[w]rite' },

        -- Visual mode mappings
        { mode = 'v', '<leader>g', group = '[g]it' },
        { mode = 'v', '<leader>c', group = '[c]ut (snippets)' },
        { mode = 'v', '<leader>cna', '<cmd>ScissorsAddNewSnippet<CR>', { desc = '[a]dd new snippet' } },
        { mode = 'v', '<leader>s', group = '[s]earch' },
        {
          mode = 'v',
          '<leader>sh',
          function()
            search_help()
          end,
          desc = 'search [h]elp (visual selection)',
        },
        {
          mode = 'v',
          '<leader>sr',
          function()
            replace_selection()
          end,
          desc = '[r]eplace (visual selection)',
        },
      },
    },
    preset = 'modern',
    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
      mappings = false,
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
