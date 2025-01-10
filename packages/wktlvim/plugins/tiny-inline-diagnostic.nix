{ pkgs, ... }:
{
  extraPlugins = with pkgs; [
    vimPlugins.tiny-inline-diagnostic-nvim
  ];

  extraConfigLuaPre = ''
    require("tiny-inline-diagnostic").setup({
      preset = "ghost",
      options = {
        throttle = 0,

        multilines = {
          enabled = true,
          always_show = true,
        },

        show_all_diags_on_cursorline = true,
        enable_on_insert = true,
      },
    })
  '';
}
