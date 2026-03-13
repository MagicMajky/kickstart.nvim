return { -- lsp configuration & plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- automatically install lsps and related tools to stdpath for neovim
    { 'williamboman/mason.nvim', config = true }, -- note: must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- useful status updates for lsp.
    -- note: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- `lazydev` configures lua lsp for your neovim config, runtime and plugins
    -- used for completion, annotations and signatures of neovim apis
    { 'folke/lazydev.nvim', ft = 'lua', opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } } },
  },
  config = function()
    -- brief aside: **what is lsp?**
    --
    -- lsp is an initialism you've probably heard, but might not understand what it is.
    --
    -- lsp stands for language server protocol. it's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- in general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). these language servers
    -- (sometimes called lsp servers, but that's kind of like atm machine) are standalone
    -- processes that communicate with some "client" - in this case, neovim!
    --
    -- lsp provides neovim with features like:
    --  - go to definition
    --  - find references
    --  - autocompletion
    --  - symbol search
    --  - and more!
    --
    -- thus, language servers are external tools that must be installed separately from
    -- neovim. this is where `mason` and related plugins come into play.
    --
    -- if you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    --  this function gets run when an lsp attaches to a particular buffer.
    --    that is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('lspattach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- note: remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- in this case, we create a function that lets us more easily define mappings specific
        -- for lsp related items. it sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'lsp: ' .. desc })
        end

        -- jump to the definition of the word under your cursor.
        --  this is where a variable was first declared, or where a function is defined, etc.
        --  to jump back, press <c-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')

        -- find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')

        -- jump to the implementation of the word under your cursor.
        --  useful when your language has ways of declaring types without an actual implementation.
        map('gi', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')

        -- jump to the type of the word under your cursor.
        --  useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>d', require('telescope.builtin').lsp_type_definitions, 'type [d]efinition')

        -- fuzzy find all the symbols in your current document.
        --  symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')

        -- fuzzy find all the symbols in your current workspace.
        --  similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')

        -- rename the variable under your cursor.
        --  most language servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')

        -- execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your lsp for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

        -- opens a popup that displays documentation about the word under your cursor
        --  see `:help k` for why this keymap.
        map('K', vim.lsp.buf.hover, 'hover documentation')

        -- warn: this is not goto definition, this is goto declaration.
        --  for example, in c this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[g]oto [d]eclaration')

        -- the following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    see `:help cursorhold` for information about when this is executed
        --
        -- when you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documenthighlightprovider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'cursorhold', 'cursorholdi' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'cursormoved', 'cursormovedi' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- the following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- this may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayhintprovider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[t]oggle inlay [h]ints')
        end
      end,
    })

    vim.api.nvim_create_autocmd('lspdetach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
      callback = function(event)
        vim.lsp.buf.clear_references()
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documenthighlightprovider then
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event.buf }
        end
      end,
    })

    -- Capabilities: extend defaults with cmp_nvim_lsp
    local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

    -- Configure LSP servers using vim.lsp.config (Neovim 0.11+ native API)
    vim.lsp.config('lua_ls', {
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    })

    vim.lsp.config('graphql', {
      capabilities = capabilities,
    })

    -- Define the path to the Vue plugin installed by Mason
    -- often ~/.local/share/nvim/mason/
    local vue_plugin_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

    -- Configure vtsls (TypeScript server with Vue hybrid mode support)
    vim.lsp.config('vtsls', {
      capabilities = capabilities,
      -- Important: 'vue' must be in the filetypes list
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = '@vue/typescript-plugin',
                location = vue_plugin_path,
                languages = { 'vue' },
                configNamespace = 'typescript',
              },
            },
          },
        },
      },
    })

    -- Configure the Vue language server (Volar)
    vim.lsp.config('vue_ls', {
      capabilities = capabilities,
    })

    -- Mason: install LSP servers and tools
    require('mason').setup()

    require('mason-tool-installer').setup {
      ensure_installed = {
        'lua_ls',
        'jdtls',
        'graphql',
        'stylua',
        'graphql-language-service-cli',
        'vtsls',
        'vue-language-server',
        'prettierd',
      },
    }

    -- mason-lspconfig: auto-enable installed servers via vim.lsp.enable()
    require('mason-lspconfig').setup {
      automatic_enable = true,
    }
  end,
}
