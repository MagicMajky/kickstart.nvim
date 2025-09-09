return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = '[a]dd buffer to harpoon' })

    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'toggle harpoon quick menu' })

    vim.keymap.set('n', '<C-h>', function()
      harpoon:list():select(1)
    end, { desc = 'harpoon select first' })

    vim.keymap.set('n', '<C-j>', function()
      harpoon:list():select(2)
    end, { desc = 'harpoon select second' })

    vim.keymap.set('n', '<C-k>', function()
      harpoon:list():select(3)
    end, { desc = 'harpoon select third' })

    vim.keymap.set('n', '<C-l>', function()
      harpoon:list():select(4)
    end, { desc = 'harpoon select fourth' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end, { desc = 'Toggle previous buffer stored within Harpoon list' })
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end, { desc = 'Toggle next buffer stored within Harpoon list' })
  end,
}
