{config, lib, ...}: let
  inherit (lib) mkForce;
in {
  wktlNix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    archetypes = {
      wsl = true;
    };
  };

  home.stateVersion = "23.11";
}