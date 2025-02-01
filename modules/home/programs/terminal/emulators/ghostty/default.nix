{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.emulators.ghostty;

in
{
  options.${namespace}.programs.terminal.emulators.ghostty = {
    enable = mkBoolOpt false "Whether or not to enable ghostty.";
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

        background-opacity = 0.8;

        clipboard-trim-trailing-spaces = true;
        copy-on-select = "clipboard";

        focus-follows-mouse = true;

        font-size = 13;
        font-family = "RecMonoCasual Nerd Font";

        gtk-single-instance = false;

        quit-after-last-window-closed = true;

        window-decoration = false;
      };
    };
  };
}
