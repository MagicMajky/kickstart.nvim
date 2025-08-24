-- NOTE: plugins can specify dependencies.
--
-- the dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- use the `dependencies` key to specify the dependencies of a particular plugin

return { -- fuzzy finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'vimenter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- if encountering errors, see telescope-fzf-native readme for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- this is only run then, not every time neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- useful for getting pretty icons, but requires a nerd font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! it's more than just a "file finder", it can search
    -- many different aspects of neovim, your workspace, lsp, and more!
    --
    -- the easiest way to use telescope, is to start by doing something like:
    --  :telescope help_tags
    --
    -- after running this command, a window will open up and you're able to
    -- type in the prompt window. you'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- two important keymaps to use while in telescope are:
    --  - insert mode: <c-/>
    --  - normal mode: ?
    --
    -- this opens a window that shows you all of the keymaps for the current
    -- telescope picker. this is really useful to discover what telescope can
    -- do as well as how to actually do it!

    -- [[ configure telescope ]]
    -- see `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- you can put your default mappings / updates / etc. in here
      --  all the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        path_display = { 'truncate' },
        layout_config = {
          horizontal = {
            width = 0.9,
          },
        },
        -- mappings = {
        --   i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        -- },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- enable telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- see `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[s]earch [f]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[s]earch [s]elect telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch by [g]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[s]earch recent files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] find existing buffers' })

    -- slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- you can pass additional configuration to telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] fuzzily search in current buffer' })

    -- it's also possible to pass additional configuration options.
    --  see `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'live grep in open files',
      }
    end, { desc = '[s]earch [/] in open files' })

    -- shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[s]earch [n]eovim files' })
  end,
}
