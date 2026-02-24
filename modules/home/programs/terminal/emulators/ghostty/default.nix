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

        clipboard-trim-trailing-spaces = true;
        copy-on-select = "clipboard";

        focus-follows-mouse = true;

        gtk-single-instance = false;

        quit-after-last-window-closed = true;

        window-decoration = false;

        window-padding-x = 0;
        window-padding-y = 0;

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
