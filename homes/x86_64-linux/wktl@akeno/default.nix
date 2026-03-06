{ lib, ... }:
let
  inherit (lib.wktlnix) enabled;
in
{
  wktlnix = {
    user = enabled;

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

  stylix.overlays.enable = false;

  home.stateVersion = "24.05";
}
