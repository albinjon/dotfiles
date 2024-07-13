---@diagnostic disable: missing-fields
return {
  'kndndrj/nvim-dbee',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require('dbee').install()
  end,

  config = function()
    require('dbee').setup({
      call_log = {
        buffer_options = {},
        candies = {
          archive_failed = {
            icon = '',
            icon_highlight = 'Error',
            text_highlight = '',
          },
          archived = {
            icon = '',
            icon_highlight = 'Title',
            text_highlight = '',
          },
          canceled = {
            icon = '',
            icon_highlight = 'Error',
            text_highlight = '',
          },
          executing = {
            icon = '󰑐',
            icon_highlight = 'Constant',
            text_highlight = 'Constant',
          },
          executing_failed = {
            icon = '󰑐',
            icon_highlight = 'Error',
            text_highlight = '',
          },
          retrieving = {
            icon = '',
            icon_highlight = 'String',
            text_highlight = 'String',
          },
          retrieving_failed = {
            icon = '',
            icon_highlight = 'Error',
            text_highlight = '',
          },
          unknown = {
            icon = '',
            icon_highlight = 'NonText',
            text_highlight = '',
          },
        },
        disable_candies = false,
        mappings = {
          {
            action = 'show_result',
            key = '<CR>',
            mode = '',
          },
          {
            action = 'cancel_call',
            key = '<C-c>',
            mode = '',
          },
        },
        window_options = {},
      },
      drawer = {
        buffer_options = {},
        candies = {
          add = {
            icon = '',
            icon_highlight = 'String',
            text_highlight = 'String',
          },
          column = {
            icon = '󰠵',
            icon_highlight = 'WarningMsg',
            text_highlight = '',
          },
          connection = {
            icon = '󱘖',
            icon_highlight = 'SpecialChar',
            text_highlight = '',
          },
          database_switch = {
            icon = '',
            icon_highlight = 'Character',
          },
          edit = {
            icon = '󰏫',
            icon_highlight = 'Directory',
            text_highlight = 'Directory',
          },
          help = {
            icon = '󰋖',
            icon_highlight = 'Title',
            text_highlight = 'Title',
          },
          history = {
            icon = '',
            icon_highlight = 'Constant',
            text_highlight = '',
          },
          node_closed = {
            icon = '',
            icon_highlight = 'NonText',
          },
          node_expanded = {
            icon = '',
            icon_highlight = 'NonText',
          },
          none = {
            icon = ' ',
          },
          none_dir = {
            icon = '',
            icon_highlight = 'NonText',
          },
          note = {
            icon = '',
            icon_highlight = 'Character',
            text_highlight = '',
          },
          remove = {
            icon = '󰆴',
            icon_highlight = 'SpellBad',
            text_highlight = 'SpellBad',
          },
          source = {
            icon = '󰃖',
            icon_highlight = 'MoreMsg',
            text_highlight = 'MoreMsg',
          },
          table = {
            icon = '',
            icon_highlight = 'Conditional',
            text_highlight = '',
          },
          view = {
            icon = '',
            icon_highlight = 'Debug',
            text_highlight = '',
          },
        },
        disable_candies = false,
        disable_help = true,
        mappings = {
          {
            action = 'refresh',
            key = 'r',
            mode = 'n',
          },
          {
            action = 'action_1',
            key = 'o',
            mode = 'n',
          },
          {
            action = 'action_2',
            key = 'cw',
            mode = 'n',
          },
          {
            action = 'action_3',
            key = 'dd',
            mode = 'n',
          },
          {
            action = 'toggle',
            key = '<CR>',
            mode = 'n',
          },
          {
            action = 'menu_confirm',
            key = '<CR>',
            mode = 'n',
          },
          {
            action = 'menu_yank',
            key = 'y',
            mode = 'n',
          },
          {
            action = 'menu_close',
            key = '<Esc>',
            mode = 'n',
          },
          {
            action = 'menu_close',
            key = 'q',
            mode = 'n',
          },
        },
        window_options = {},
      },
      editor = {
        buffer_options = {},
        mappings = {
          {
            action = 'run_selection',
            key = 'BB',
            mode = 'v',
          },
          {
            action = 'run_file',
            key = 'BB',
            mode = 'n',
          },
        },
        window_options = {},
      },
      extra_helpers = {},
      float_options = {},
      result = {
        buffer_options = {},
        mappings = {
          {
            action = 'page_next',
            key = 'L',
            mode = '',
          },
          {
            action = 'page_prev',
            key = 'H',
            mode = '',
          },
          {
            action = 'page_last',
            key = 'E',
            mode = '',
          },
          {
            action = 'page_first',
            key = 'F',
            mode = '',
          },
          {
            action = 'yank_current_json',
            key = 'yaj',
            mode = 'n',
          },
          {
            action = 'yank_selection_json',
            key = 'yaj',
            mode = 'v',
          },
          {
            action = 'yank_all_json',
            key = 'yaJ',
            mode = '',
          },
          {
            action = 'yank_current_csv',
            key = 'yac',
            mode = 'n',
          },
          {
            action = 'yank_selection_csv',
            key = 'yac',
            mode = 'v',
          },
          {
            action = 'yank_all_csv',
            key = 'yaC',
            mode = '',
          },
          {
            action = 'cancel_call',
            key = '<C-c>',
            mode = '',
          },
        },
        page_size = 1000,
        progress = {
          spinner = {
            '⠋',
            '⠙',
            '⠹',
            '⠸',
            '⠼',
            '⠴',
            '⠦',
            '⠧',
            '⠇',
            '⠏',
          },
          text_prefix = 'Executing...',
        },
        window_options = {},
      },
    })
    vim.keymap.set(
      'n',
      '<leader>po',
      "<cmd>lua require('dbee').toggle()<CR>",
      { noremap = true, silent = true }
    )
  end,
}
