{
  extraConfigLuaPre = ''
    if vim.g.neovide then
      vim.g.neovide_transparency = 0.9
      vim.g.neovide_refresh_rate = 60
      vim.g.neovide_hide_mouse_when_typing = true
      vim.g.neovide_no_idle = true
      vim.g.neovide_cursor_antialiasing = true
      vim.g.neovide_cursor_animate_command_line = true
      vim.g.neovide_cursor_smooth_blink = true
      vim.g.neovide_cursor_animate_in_insert_mode = true
      vim.g.neovide_cursor_vfx_mode = "sonicboom"

      vim.o.guifont = "VictorMono Nerd Font,LXGW WenKai Mono Medium:h14"
    end
  '';
}
