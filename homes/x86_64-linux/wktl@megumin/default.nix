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
      graphical.browsers.firefox = enabled;
      terminal = {
        emulators.kitty = enabled;
        tools.git = enabled;
      };
    };
  };

  home.stateVersion = "23.11";
}
