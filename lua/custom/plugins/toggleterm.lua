return {
  'akinsho/toggleterm.nvim',
  keys = '<C-t>',
  version = '*',

  config = function()
    require('toggleterm').setup {
      size = 10,
      open_mapping = '<C-t>',
      hide_numbers = true,
      autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      direction = 'horizontal',
      auto_scroll = true,
      close_on_exit = true,
    }
  end,
}
