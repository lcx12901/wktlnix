{
  extraConfigLuaPre = ''
    if vim.g.neovide then
      -- vim.g.neovide_transparency = 0.9
      vim.g.neovide_refresh_rate = 60
      vim.g.neovide_hide_mouse_when_typing = true
      vim.g.neovide_no_idle = true
      vim.g.neovide_cursor_antialiasing = true
      vim.g.neovide_cursor_animate_command_line = true
      vim.g.neovide_cursor_smooth_blink = true
      vim.g.neovide_cursor_animate_in_insert_mode = true
      vim.g.neovide_cursor_vfx_mode = "sonicboom"

      vim.o.guifont = "Maple Mono NF CN,Cascadia Mono NF:h15"

      -- copy_to_clipboard
      vim.keymap.set('v', '<C-S-c>', '"+y', { noremap = true, silent = true })

      -- paste_from_clipboard
      vim.keymap.set('i', '<C-S-v>', '<C-r>+', { noremap = true, silent = true })
      vim.keymap.set('n', '<C-S-v>', '"+p', { noremap = true, silent = true })

      -- paste_from_clipboard in cmd model
      vim.keymap.set('c', '<C-S-v>', '<C-R>+', { noremap = true, silent = true })

      -- paste_from_clipboard in terminal model
      vim.keymap.set('t', '<C-S-v>', '<C-\\><C-n>"+pi', { noremap = true, silent = true })
    end
  '';
}
