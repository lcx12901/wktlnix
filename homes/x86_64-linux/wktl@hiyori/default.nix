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

  home.stateVersion = "24.05";
}
