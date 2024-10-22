return {
  'epwalsh/obsidian.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = { 'ObsidianWorkspace', 'ObsidianOpen', 'ObsidianNew', 'ObsidianSearch', 'ObsidianFindAll' },
  version = '*', -- recommended, use latest release instead of latest commit
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  config = function()
    local obs = require('obsidian')
    obs.setup({
      workspaces = {
        {
          name = 'personal',
          path = '/Users/albin/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal',
        },
        {
          name = 'work',
          path = '/Users/albin/Library/Mobile Documents/iCloud~md~obsidian/Documents/work',
        },
      },
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ''
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix .. '-' .. tostring(os.time())
      end,
    })
  end,
}
