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

local function copy_current_file_name()
  local file_path = vim.fn.expand('%:t')
  vim.notify('Copied ' .. file_path .. ' to clipboard', vim.log.levels.INFO)
  vim.fn.setreg('+', file_path)
end

local function replace_selection()
  local selected_text = get_visual_selection()
  local replacement = vim.fn.input('Enter replacement text: ', selected_text)
  vim.cmd(string.format('%%s/%s/%s/gc', selected_text:gsub('/', '\\/'), replacement:gsub('/', '\\/')))
end

-- local function reload_file()
--   vim.cmd('LspStop')
--   vim.defer_fn(function()
--     vim.cmd('LspStart')
--   end, 500)
-- end

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    spec = {
      {
        -- Groups
        { mode = 'n', '<leader>c',  group = '[c]ode' },
        { mode = 'n', '<leader>cp', group = '[c]opilot' },
        { mode = 'n', '<leader>cn', group = '[c(s)]nippets' },
        { mode = 'n', '<leader>m',  group = '[m]arkdown' },
        { mode = 'n', '<leader>p',  group = '[p]ostgres' },
        { mode = 'n', '<leader>d',  group = '[d]ebug (dap)' },
        { mode = 'n', '<leader>f',  group = '[f]iles' },
        { mode = 'v', '<leader>g',  group = '[g]it' },
        { mode = 'v', '<leader>c',  group = '[c]ut (snippets)' },
        { mode = 'v', '<leader>s',  group = '[s]earch' },
        { mode = 'n', '<leader>dc', '<cmd>DapContinue<cr>',    desc = 'DAP [c]ontinue' },
        {
          mode = 'n',
          '<leader>fo',
          open_file_in_finder,
          desc = '[o]pen current file (finder)',
        },
        {
          mode = 'n',
          '<leader>fy',
          copy_current_file_name,
          desc = '[y]ank current file name',
        },
        {
          mode = 'n',
          '<leader>fx',
          confirm_and_delete_buffer,
          desc = 'Delete file',
        },
        {
          mode = 'n',
          '<leader>fe',
          '<cmd>MiniExploreFiles<cr>',
          desc = '[f]ile [e]xplorer',
        },
        { mode = 'n', '<leader>g', group = '[g]it' },
        -- Obsidian
        { mode = 'n', '<leader>o', group = '[o]bsidian' },
        {
          mode = 'n',
          '<leader>rr',
          require('repl').run,
          desc = 'open [r]epl',
        },
        {
          mode = 'v',
          '<leader>rr',
          function()
            require('repl').run(get_visual_selection())
          end,
          desc = 'open [r]epl',
        },
        { mode = 'n', '<leader>on',  '<cmd>ObsidianNew<cr>',           desc = 'open [n]ew' },
        { mode = 'n', '<leader>oo',  '<cmd>ObsidianOpen<cr>',          desc = '[o]pen obsidian' },
        { mode = 'n', '<leader>os',  '<cmd>ObsidianSearch<cr>',        desc = '[s]earch' },
        { mode = 'n', '<leader>of',  '<cmd>ObsidianSearchAll<cr>',     desc = '[s]earch all' },
        { mode = 'n', '<leader>ow',  '<cmd>ObsidianWorkspace<cr>',     desc = 'open [w]orkspace' },
        -- Database
        { mode = 'n', '<leader>po',  '<cmd>DbeeToggle<cr>',            desc = '[p]ostgres [o]pen' },
        -- Snippets
        { mode = 'n', '<leader>cna', '<cmd>ScissorsAddNewSnippet<CR>', { desc = '[a]dd new snippet' } },
        { mode = 'n', '<leader>cnr', '<cmd>ScissorsEditSnippet<CR>',   { desc = '[e]dit snippet' } },
        { mode = 'v', '<leader>cna', '<cmd>ScissorsAddNewSnippet<CR>', { desc = '[a]dd new snippet' } },
        -- Windows/Buffers
        { mode = 'n', '<leader>q',   group = '[q]uit/session' },
        { mode = 'n', '<C-Tab>',     '<cmd>tabnext<cr>',               desc = '[c]hange [t]ab' },
        { mode = 'n', '<C-S-Tab>',   '<cmd>tabprev<cr>',               desc = '[c]hange [t]ab' },
        { mode = 'n', '<leader>tn',  '<cmd>tabnew<cr>',                desc = '[n]ew [t]ab' },
        { mode = 'n', '<leader>qq',  '<cmd>wa<cr><cmd>qa<cr>',         desc = '[q]uit and write all' },
        { mode = 'n', '<leader>r',   group = '[r]eload' },
        -- INFO: Currently breaking the LSP.
        -- {
        --   mode = 'n',
        --   '<leader>rf',
        --   reload_file,
        --   desc = '[r]eload [f]ile',
        -- },
        { mode = 'n', '<leader>s',   group = '[s]plits/[s]earch' },
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
          '<c-w>s',
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
        {
          mode = 'n',
          '<c-w>v',
          function()
            split_and_switch_buffer('v')
          end,
          desc = '[s]plit (vertical/to right)',
        },
        { mode = 'n', '<c-w>q',     '<cmd>q<cr>',       desc = '[s]plit delete' },
        { mode = 'n', '<leader>t',  group = '[t]rouble' },
        { mode = 'n', '<leader>z',  group = '[z]en' },
        { mode = 'n', '<leader>w',  group = '[w]rite' },
        { mode = 'n', '<leader>wa', '<cmd>wa<cr>',      desc = 'write [a]ll' },
        { mode = 'n', '<leader>ww', '<cmd>update<cr>',  desc = '[w]rite' },

        -- Coding assistance
        { mode = 'n', '<leader>a',  group = '[a]vant' },
        {
          mode = 'v',
          '<leader>sh',
          search_help,
          desc = 'search [h]elp (visual selection)',
        },
        {
          mode = 'v',
          '<leader>sr',
          replace_selection,
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
