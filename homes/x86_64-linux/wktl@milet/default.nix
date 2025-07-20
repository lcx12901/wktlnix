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
          eza = enabled;
          ripgrep = enabled;
        };
      };
    };
  };

  home.stateVersion = "24.05";
}
