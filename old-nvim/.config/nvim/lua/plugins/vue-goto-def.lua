return {
  "catgoose/vue-goto-definition.nvim",
  filetypes = { "vue" },
  event = "BufReadPost",
  opts = {
    filters = {
      auto_imports = true,
      auto_components = true,
      import_same_file = true,
      declaration = true,
      duplicate_filename = true,
    },
    filetypes = { "vue", "typescript" },
    detection = {
      nuxt = function()
        return vim.fn.glob(".nuxt/") ~= ""
      end,
      vue3 = function()
        local test = vim.fn.filereadable("vite.config.mts") == 1 or vim.fn.filereadable("src/App.vue") == 1
        if test then
          vim.notify("FOUND VUE3")
        else
          vim.notify("NO")
        end
        return test
      end,
      priority = { "nuxt", "vue3" },
    },
    lsp = {
      override_definition = true, -- override vim.lsp.buf.definition
    },
    debounce = 200,
  },
}
