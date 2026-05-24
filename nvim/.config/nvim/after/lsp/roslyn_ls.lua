-- Calibration on top of nvim-lspconfig's lsp/roslyn_ls.lua.
-- Deep-merged: only the keys below override upstream defaults.

---@type vim.lsp.Config
return {
  handlers = {
    -- Auto-restore on demand, but don't toast every "Restore started",
    -- "Determining projects...", "Restored X in Yms" status line. Real
    -- failures still surface.
    ['workspace/_roslyn_projectNeedsRestore'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      ---@diagnostic disable-next-line: param-type-mismatch
      client:request('workspace/_roslyn_restore', result, function(err)
        if err then
          vim.notify('roslyn restore: ' .. err.message, vim.log.levels.ERROR, { title = 'roslyn_ls' })
        end
      end)
      return vim.NIL
    end,
  },

  settings = {
    -- Analyze open files only -> snappy cold start on large solutions.
    ['csharp|background_analysis'] = {
      dotnet_analyzer_diagnostics_scope = 'openFiles',
      dotnet_compiler_diagnostics_scope = 'openFiles',
    },
  },
}
