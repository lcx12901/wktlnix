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
      terminal = {
        emulators.kitty = enabled;
        tools = {
          git = enabled;
          direnv = enabled;
        };
      };
    };

    scenes = {
      development = enabled;
    };
  };

  home.stateVersion = "24.05";
}
