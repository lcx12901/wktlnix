{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.programs.terminal.emulators.ghostty;

in
{
  options.wktlnix.programs.terminal.emulators.ghostty = {
    enable = lib.mkEnableOption "ghostty";
    fontSize = mkOpt lib.types.int 14 "Font size for ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      installBatSyntax = true;
      installVimSyntax = true;

      enableBashIntegration = true;
      enableFishIntegration = true;

      settings = {
        font-size = lib.mkForce cfg.fontSize;

        adw-toolbar-style = "flat";
        background-blur-radius = 20;
        clipboard-trim-trailing-spaces = true;
        copy-on-select = "clipboard";
        cursor-click-to-move = true;
        cursor-style = "block";
        cursor-style-blink = false;
        focus-follows-mouse = true;

        gtk-single-instance = false;

        mouse-hide-while-typing = true;
        quit-after-last-window-closed = true;
        window-colorspace = "srgb";
        window-decoration = false;
        window-padding-x = 2;
        window-padding-y = 2;
        window-padding-balance = true;

        custom-shader-animation = "always";
        custom-shader = [
          "${./shaders/glow-rgbsplit-twitchy.glsl}"
          "${./shaders/wrap_cursor.glsl}"
          "${./shaders/ripple_cursor.glsl}"
        ];
      };
    };
  };
}
