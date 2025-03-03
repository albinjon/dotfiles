return {
  ft = 'http',
  'mistweaverco/kulala.nvim',
  opts = {},
  config = function()
    vim.api.nvim_create_user_command('KulalaVSCode', function()
      -- Get current buffer content and path
      local bufnr = vim.api.nvim_get_current_buf()
      local buf_path = vim.api.nvim_buf_get_name(bufnr)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      -- Find .env file (search upward from current file to project root)
      local env_file = nil
      local dir = vim.fn.fnamemodify(buf_path, ':h')

      while true do
        local candidate = dir .. '/.env'
        if vim.fn.filereadable(candidate) == 1 then
          env_file = candidate
          break
        end

        -- Check for .git directory to identify project root
        if vim.fn.isdirectory(dir .. '/.git') == 1 then
          break
        end

        -- Move up one directory
        local parent = vim.fn.fnamemodify(dir, ':h')
        if parent == dir then -- reached filesystem root
          break
        end
        dir = parent
      end

      -- Load environment variables from the .env file
      local env_vars = {}
      if env_file then
        local file = io.open(env_file, 'r')
        if file then
          for line in file:lines() do
            -- Skip comments and empty lines
            if not line:match('^%s*#') and line:match('%S') then
              local name, value = line:match('^%s*([%w_]+)%s*=%s*(.*)')
              if name and value then
                -- Remove quotes if present
                value = value:gsub('^["\'](.*)["\']$', '%1')
                env_vars[name] = value
              end
            end
          end
          file:close()
        end
      else
        print('Warning: No .env file found in directory hierarchy')
      end

      -- Convert $dotenv syntax for all lines
      local converted_lines = {}
      for _, line in ipairs(lines) do
        -- Replace {{$dotenv VAR}} with the actual value or ENV_NOT_FOUND
        line = line:gsub('{{%$dotenv%s+([%w_]+)}}', function(var_name)
          return env_vars[var_name] or 'ENV_NOT_FOUND_' .. var_name
        end)
        table.insert(converted_lines, line)
      end

      -- Save the original content
      local original_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local cursor_pos = vim.api.nvim_win_get_cursor(0)

      -- Temporarily disable redrawing to reduce flashing
      vim.cmd('set lazyredraw')

      -- Replace the buffer content with the converted content
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, converted_lines)

      -- Run kulala
      vim.cmd("lua require('kulala').run()")

      -- Restore the original content immediately
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, original_lines)
      vim.api.nvim_win_set_cursor(0, cursor_pos)

      -- Re-enable redrawing
      vim.cmd('set nolazyredraw')
    end, {})
  end,
}
