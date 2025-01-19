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
        adw-toolbar-style = "flat";

        background-opacity = 0.8;

        font-size = 13;
        font-family = "MonaspiceNe Nerd Font";
        font-family-bold = "MonaspiceXe Nerd Font";
        font-family-italic = "MonaspiceRn Nerd Font";
        font-family-bold-italic = "MonaspiceKr Nerd Font";

        window-decoration = false;
      };
    };
  };
}
