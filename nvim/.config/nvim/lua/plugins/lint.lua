return {
  'mfussenegger/nvim-lint',
  enabled = false,
  opts = {
    -- Event to trigger linters
    events = { 'BufWritePost', 'BufReadPost', 'TextChanged' },
  },
  config = function(_, opts)
    local M = {}
    local eslint_d = require('lint').linters.eslint_d
    local test = require('lspconfig').util.root_pattern('tsconfig.json')()
    eslint_d.cwd = test
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
