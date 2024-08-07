{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      graphical = {
        browsers.firefox = enabled;
        editors.vscode = enabled;
      };
      terminal = {
        tools = {
          git = enabled;
          direnv = enabled;
        };
      };
    };

    theme = {
      gtk = enabled;
      catppuccin = enabled;
    };
  };

  home.stateVersion = "24.05";
}
