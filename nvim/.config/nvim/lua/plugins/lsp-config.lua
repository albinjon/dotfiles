return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "typescript-language-server",
        "vue-language-server",
        "tailwindcss-language-server",
        --"prettierd",
        "html-lsp",
        "css-lsp",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup_handlers({})
      local mason_registry = require("mason-registry")
      local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
        .. "/node_modules/@vue/language-server"
      local lspconfig = require("lspconfig")
      local util = lspconfig.util
      lspconfig.tailwindcss.setup({
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "vue" },
        root_dir = util.root_pattern(".git"),
        single_file_support = false,
      })
      -- lspconfig.eslint.setup({
      --   root_dir = util.root_pattern(".git"),
      -- })
      lspconfig.tsserver.setup({
        root_dir = function(fname)
          return util.root_pattern("package-lock.json")(fname) or util.root_pattern(".git")
        end,
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue", "javascript", "typescript" },
            },
          },
        },
        filetypes = { "vue", "javascript", "typescript" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" }
      keys[#keys + 1] = { "K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover Code" }
    end,
  },
}
