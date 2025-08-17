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
          eza = enabled;
        };
      };
    };
  };

  stylix.overlays.enable = false;

  home.stateVersion = "24.05";
}
