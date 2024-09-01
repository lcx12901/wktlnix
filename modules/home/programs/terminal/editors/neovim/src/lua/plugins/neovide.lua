if not vim.g.neovide then
  return {} -- do nothing if not in a Neovide session
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = { -- configure vim.opt options
        -- line spacing
        linespace = 0,
        termguicolors = true,
      },
      g = { -- configure vim.g variables
        neovide_transparency = 0.9,
        neovide_refresh_rate = 60,
        neovide_hide_mouse_when_typing = true,
        neovide_no_idle = true,
        neovide_cursor_antialiasing = true,
        neovide_cursor_animate_command_line = true,
        neovide_cursor_smooth_blink = true,
        neovide_cursor_animate_in_insert_mode = true,
        neovide_cursor_vfx_mode = "sonicboom",
      },
      o = {
        guifont = "MonaspiceRn Nerd font,WenQuanYi Zen Hei Mono:h14",
      },
    },
  },
}
