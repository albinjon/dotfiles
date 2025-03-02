return {
  'mfussenegger/nvim-lint',
  lazy = false,
  enabled = false,
  opts = {
    -- Event to trigger linters
    events = { 'BufWritePost', 'BufReadPost', 'TextChanged', 'ModeChanged' },
  },
  config = function(_, opts)
    local M = {}
    vim.env.ESLINT_D_PPID = vim.fn.getpid()
    local lint = require('lint')
    lint.linters_by_ft = {
      fish = { 'fish' },
      typescript = { 'eslint_d' },
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      vue = { 'eslint_d' },
      -- Use the "*" filetype to run linters on all filetypes.
      -- ['*'] = { 'global linter' },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      -- ['_'] = { 'fallback linter' },
      -- ["*"] = { "typos" },
    }
    local eslint = lint.linters.eslint_d

    eslint.args = {
      '--no-warn-ignored', -- <-- this is the key argument
      '--format',
      'json',
      '--stdin',
      '--stdin-filename',
      function()
        return vim.api.nvim_buf_get_name(0)
      end,
    }

    function M.debounce(ms, fn)
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = M.debounce(100, function()
        lint.try_lint()
      end),
    })
  end,
}
