{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.terminal.tools.btop;
in
{
  options.wktlnix.programs.terminal.tools.btop = {
    enable = mkEnableOption "Whether or not to enable btop.";
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      package = pkgs.btop;

      settings = {
        #* If the theme set background should be shown, set to false if you want terminal background transparency.
        theme_background = true;

        #* Sets if 24-bit truecolor should be used, will convert 24-bit colors to 256 color (6x6x6 color cube) if false.
        truecolor = true;

        #* Set to true to force tty mode regardless if a real tty has been detected or not.
        #* Will force 16-color mode and TTY theme, set all graph symbols to "tty" and swap out other non tty friendly symbols.
        force_tty = false;

        #* Define presets for the layout of the boxes. Preset 0 is always all boxes shown with default settings. Max 9 presets.
        #* Format: "box_name:P:G,box_name:P:G" P=(0 or 1) for alternate positions, G=graph symbol to use for box.
        #* Use whitespace " " as separator between different presets.
        #* Example: "cpu:0:default,mem:0:tty,proc:1:default cpu:0:braille,proc:0:tty"
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";

        #* Set to true to enable "h,j,k,l,g,G" keys for directional control in lists.
        #* Conflicting keys for h:"help" and k:"kill" is accessible while holding shift.
        vim_keys = false;

        #* Rounded corners on boxes, is ignored if TTY mode is ON.
        rounded_corners = true;
      };
    };
  };
}
