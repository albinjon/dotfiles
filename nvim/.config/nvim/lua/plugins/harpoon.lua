return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  enabled = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    vim.notify('setting up harpoon')
    local harpoon = require('harpoon')
    -- REQUIRED
    harpoon:setup({
      -- Setting up custom behavior for a list named "cmd"
      cmd = {

        -- When you call list:add() this function is called and the return
        -- value will be put in the list at the end.
        --
        -- which means same behavior for prepend except where in the list the
        -- return value is added
        --
        -- @param possible_value string only passed in when you alter the ui manual
        add = function()
          -- get the current line idx

          vim.notify('hello')
          local idx = vim.fn.line('.')

          -- read the current line
          local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
          vim.notify(cmd)
          if cmd == nil then
            return nil
          end

          return {
            value = cmd,
          }
        end,

        --- This function gets invoked with the options being passed in from
        --- list:select(index, <...options...>)
        --- @param list_item {value: any, context: any}
        --- @param list { ... }
        --- @param option any
        select = function(list_item, list, option)
          -- WOAH, IS THIS HTMX LEVEL XSS ATTACK??
          vim.notify(list_item.value)
          vim.cmd(list_item.value)
        end,
      },
    })
    -- REQUIRED

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list('cmd'):add()
    end)
    vim.keymap.set('n', '<leader>hf', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<leader>hh', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<leader>hj', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<leader>hk', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<leader>hl', function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>hK', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<leader>hJ', function()
      harpoon:list():next()
    end)
  end,
}
