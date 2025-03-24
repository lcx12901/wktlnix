{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.programs.terminal.emulators.ghostty;

in
{
  options.${namespace}.programs.terminal.emulators.ghostty = {
    enable = mkBoolOpt false "Whether or not to enable ghostty.";
    fontSize = mkOpt lib.types.number 16 "ghostty font size.";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      installBatSyntax = true;
      installVimSyntax = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;

      settings = {
        adw-toolbar-style = "raised";

        clipboard-trim-trailing-spaces = true;
        copy-on-select = "clipboard";

        focus-follows-mouse = true;

        font-size = cfg.fontSize;
        font-family = "Maple Mono NF CN";

        gtk-single-instance = false;

        quit-after-last-window-closed = true;

        window-decoration = false;
      };
    };
  };
}
