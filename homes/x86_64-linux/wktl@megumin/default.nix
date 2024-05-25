{config, lib, namespace, ...}: let
  inherit (lib.${namespace}) enabled;
in {
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };
  };

  home.stateVersion = "23.11";
}