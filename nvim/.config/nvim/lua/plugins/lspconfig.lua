return {
  {
    'neovim/nvim-lspconfig',
    event = {
      'BufReadPre *',
      'BufNewFile *',
    },
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
    dependencies = {
      {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        build = ':MasonUpdate',
        config = true,
      },
      {
        'williamboman/mason-lspconfig.nvim',
        cmd = { 'LspInstall', 'LspUninstall' },
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        cmd = { 'MasonToolsInstall', 'MasonToolsClean' },
      },
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('ExcludeLspFiletypes', { clear = true }),
        pattern = { 'lazy', 'mason', 'notify', 'help', 'noice' },
        callback = function(event)
          vim.b[event.buf].lsp_attached = false
        end,
      })
      local keys = {
        {
          'gd',
          function()
            require('telescope.builtin').lsp_definitions()
          end,
          '[g]oto [d]efinition',
        },
        {
          'gr',
          function()
            require('telescope.builtin').lsp_references()
          end,
          '[g]oto [r]eferences',
        },
        {
          'gI',
          function()
            require('telescope.builtin').lsp_implementations()
          end,
          '[g]oto [i]mplementation',
        },
        {
          '<leader>td',
          function()
            require('telescope.builtin').lsp_type_definitions()
          end,
          'type [d]efinition',
        },
        { '<leader>cr', vim.lsp.buf.rename, '[r]ename' },
        { '<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction' },
        { '<leader>cl', '<cmd>LspInfo<cr>', 'Info' },
        {
          'K',
          function()
            require('noice.lsp').hover()
          end,
          'Hover Documentation',
        },
        { 'gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration' },
      }

      -- Register keymaps on LspAttach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(event)
          -- Skip if this is a excluded filetype
          if vim.b[event.buf].lsp_attached == false then
            return
          end

          for _, key in ipairs(keys) do
            vim.keymap.set('n', key[1], key[2], { buffer = event.buf, desc = 'LSP: ' .. key[3] })
          end
          -- Special case for visual mode
          vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { buffer = event.buf, desc = 'LSP: code action' })
        end,
      })
    end,
    config = function()
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
        denols = {
          root_dir = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc'),
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { disable = { 'missing-fields' } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        mdx_analyzer = { filetypes = { 'mdx' } },
      }

      local ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
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
        'denols',
        'gopls',
        'vue-language-server',
        'js-debug-adapter',
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
