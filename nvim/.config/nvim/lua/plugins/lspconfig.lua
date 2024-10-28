return {
  {
    'neovim/nvim-lspconfig',
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

          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>td', require('telescope.builtin').lsp_type_definitions, 'type [d]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>cr', vim.lsp.buf.rename, '[r]ename')
          map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
          map('<leader>cl', '<cmd>LspInfo<cr>', 'Info')
          map_v('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')

          -- local function desc(description)
          --   return { desc = 'LSP: ' .. description }
          -- end
          -- vim.api.nvim_create_user_command(
          --   'GoToDefinition',
          --   require('telescope.builtin').lsp_definitions,
          --   desc('[g]o to [d]efinition')
          -- )
          -- vim.api.nvim_create_user_command('GoToDeclaration', vim.lsp.buf.declaration, desc('Go to declaration'))
          -- vim.api.nvim_create_user_command(
          --   'GoToReferences',
          --   require('telescope.builtin').lsp_references,
          --   desc('[g]o to [r]eferences')
          -- )
          -- vim.api.nvim_create_user_command(
          --   'GoToImplementation',
          --   --  Useful when your language has ways of declaring types without an actual implementation.
          --   require('telescope.builtin').lsp_implementations,
          --   desc('[g]oto [i]mplementation')
          -- )
          --
          -- vim.api.nvim_create_user_command(
          --   'GoToTypeDefinition',
          --   -- Jump to the type of the word under your cursor.
          --   --  Useful when you're not sure what type a variable is and you want to see
          --   --  the definition of its *type*, not where it was *defined*.
          --   require('telescope.builtin').lsp_type_definitions,
          --   desc('type [d]efinition')
          -- )
          -- vim.api.nvim_create_user_command('Rename', vim.lsp.buf.rename, desc('[r]ename'))
          -- vim.api.nvim_create_user_command('Hover', vim.lsp.buf.hover, desc('Hover Documentation'))
          -- vim.api.nvim_create_user_command('CodeAction', vim.lsp.buf.code_action, desc('[c]ode [a]ction'))
          -- vim.api.nvim_create_user_command('GoToDeclaration', vim.lsp.buf.declaration, desc('[g]o to [d]eclaration'))
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
