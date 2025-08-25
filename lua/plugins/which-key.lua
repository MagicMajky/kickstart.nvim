-- NOTE: plugins can also be configured to run lua code when they are loaded.
--
-- this is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- for example, in the following configuration, we use:
--  event = 'vimenter'
--
-- which loads which-key before all the ui elements are loaded. events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return { -- useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'vimenter', -- sets the loading event to 'vimenter'
  config = function() -- this is the function that runs, after loading
    require('which-key').setup()

    -- document existing key chains
    -- require('which-key').register {
    --   ['<leader>c'] = { name = '[c]ode', _ = 'which_key_ignore' },
    --   ['<leader>d'] = { name = '[d]ocument', _ = 'which_key_ignore' },
    --   ['<leader>r'] = { name = '[r]ename', _ = 'which_key_ignore' },
    --   ['<leader>s'] = { name = '[s]earch', _ = 'which_key_ignore' },
    --   ['<leader>w'] = { name = '[w]orkspace', _ = 'which_key_ignore' },
    --   ['<leader>t'] = { name = '[t]oggle', _ = 'which_key_ignore' },
    --   ['<leader>h'] = { name = 'git [h]unk', _ = 'which_key_ignore' },
    -- }
    require('which-key').add {
      { '<leader>c', group = '[c]ode' },
      { '<leader>c_', hidden = true },
      { '<leader>d', group = '[d]ocument' },
      { '<leader>d_', hidden = true },
      { '<leader>h', group = 'git [h]unk' },
      { '<leader>h_', hidden = true },
      { '<leader>r', group = '[r]ename' },
      { '<leader>r_', hidden = true },
      { '<leader>s', group = '[s]earch' },
      { '<leader>s_', hidden = true },
      { '<leader>t', group = '[t]oggle' },
      { '<leader>t_', hidden = true },
      { '<leader>w', group = '[w]orkspace' },
      { '<leader>w_', hidden = true },
    }

    -- visual mode
    -- require('which-key').register({
    --   ['<leader>h'] = { 'git [h]unk' },
    -- }, { mode = 'v' })
    require('which-key').add {
      { '<leader>h', desc = 'git [h]unk', mode = 'v' },
    }
  end,
}
