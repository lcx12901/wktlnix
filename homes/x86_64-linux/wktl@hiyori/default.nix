{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      terminal = {
        tools = {
          btop = enabled;
          bat = enabled;
          colorls = enabled;
          git = enabled;
          lazygit = enabled;
          eza = enabled;
          direnv = enabled;
          ripgrep = enabled;
          yazi = enabled;
        };
      };
    };

    scenes.development = enabled;
  };

  home.stateVersion = "24.05";
}
