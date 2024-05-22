{config, lib, ...}: let
  inherit (lib) mkForce;
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
          startship = enabled;
          zsh = enabled;
        };
      };
    };
  };

  home.stateVersion = "23.11";
}