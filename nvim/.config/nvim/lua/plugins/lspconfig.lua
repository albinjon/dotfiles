return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    cmd = { 'LspInfo', 'Mason', 'MasonToolsInstall', 'MasonToolsClean' },
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          local map_v = function(keys, func, desc)
            vim.keymap.set('v', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')
          map('<leader>td', require('telescope.builtin').lsp_type_definitions, 'type [d]efinition')
          map('<leader>cr', vim.lsp.buf.rename, '[r]ename')
          map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
          map('<leader>cl', '<cmd>LspInfo<cr>', 'Info')
          map_v('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local mason_registry = require('mason-registry')
      local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path()
        .. '/node_modules/@vue/language-server'
      local servers = {
        eslint = {
          settings = {
            workingDirectories = {
              { pattern = 'packages/*' },
              { pattern = 'apps/*' },
              { pattern = 'services/*' },
            },
            useFlatConfig = false,
          },
        },
        ts_ls = {
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                languages = { 'vue' },
              },
            },
          },
          filetypes = { 'vue' },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        mdx_analyzer = {
          filetypes = { 'mdx' },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- 'eslint-lsp',
        'tailwindcss',
        'delve',
        'jsonlint',
        'lua-language-server',
        'prismals',
        'markdownlint',
        'prettierd',
        'pyright',
        'ts_ls',
        'stylua',
        'vale',
        'sqlls',
        'volar',
        'crlfmt',
        'gopls',
        'vue-language-server',
      })
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
        automatic_installation = true,
      })
    end,
  },
}
