{config, lib, ...}: let
  inherit (lib) mkForce;
in {
  wktlNix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    }
  };

  home.stateVersion = "23.11";
}