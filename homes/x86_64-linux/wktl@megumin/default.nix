{config, lib, ...}: let
  inherit (lib.internal) enabled;
in {
  wktlNix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      terminal = {
        shell = {
          zsh = enabled;
        };
      };
    };
  };

  home.stateVersion = "23.11";
}