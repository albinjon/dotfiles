return {
  {
    'neovim/nvim-lspconfig',
    event = {
      'BufReadPre *',
      'BufNewFile *',
    },
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
    dependencies = {
      { 'saghen/blink.cmp' },
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
        { '<leader>cr', vim.lsp.buf.rename, '[r]ename' },
        {
          '<leader>ca',
          vim.lsp.buf.code_action,
          '[c]ode [a]ctions',
          { 'n', 'v' },
        },
        { '<leader>cl', '<cmd>LspInfo<cr>', 'Info' },
        {
          'K',
          function()
            require('noice.lsp').hover()
          end,
          'Hover Documentation',
        },
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
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      local mason_registry = require('mason-registry')
      local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path()
        .. '/node_modules/@vue/language-server'

      -- INFO: This requres manual installation with npm i -g @styled/typescript-styled-plugin
      local styled_components_path = '/usr/local/lib/node_modules/@styled/typescript-styled-plugin'

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
              {
                name = '@styled/typescript-styled-plugin',
                location = styled_components_path,
                languages = { 'tsx', 'jsx' },
              },
            },
          },
          filetypes = { 'vue', 'typescript', 'typescriptreact', 'javascriptreact', 'javascript' },
          root_dir = require('lspconfig').util.root_pattern('package.json'),
          single_file_support = false,
        },
        cssls = {
          settings = {
            css = {
              lint = {
                unknownAtRules = 'ignore',
              },
            },
          },
        },
        denols = {
          root_dir = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc', 'deno.lock'),
          single_file_support = false,
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
        'terraform-ls',
        'delve',
        'jsonlint',
        'lua-language-server',
        'prismals',
        'markdownlint',
        'prettierd',
        'pyright',
        'stylua',
        'vale',
        'sqlls',
        'volar',
        'crlfmt',
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
