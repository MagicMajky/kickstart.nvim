-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- Open neo tree automatically when starting neovim
-- vim.api.nvim_create_augroup('neotree-auto-open', {})
-- vim.api.nvim_create_autocmd('UiEnter', {
--   desc = 'Open Neotree automatically',
--   group = 'neotree-auto-open',
--   once = true,
--   callback = function()
--     if not vim.g.neotree_opened then
--       vim.cmd 'Neotree show'
--       vim.g.neotree_opened = true
--     end
--   end,
-- })

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
      },
    },
  },
}
