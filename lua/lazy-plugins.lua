-- [[ configure and install plugins ]]
--
--  to check the current status of your plugins, run
--    :Lazy
--
--  you can press `?` in this menu for help. use `:q` to close the window
--
--  to update plugins you can run
--    :Lazy update
--
-- note: here is where you install your plugins.
require('lazy').setup({
  -- note: plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- detect tabstop and shiftwidth automatically

  require 'plugins.cmp',

  require 'plugins.comment',

  require 'plugins.conform',

  require 'plugins.gitsigns',

  require 'plugins.lspconfig',

  require 'plugins.mini',

  require 'plugins.markdown',

  require 'plugins.neo-tree',

  require 'plugins.telescope',

  require 'plugins.tokyonight',

  require 'plugins.treesitter',

  require 'plugins.which-key',

  require 'plugins.harpoon',

  -- highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'vimenter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
